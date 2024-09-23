
## **Chapter 15: From REST API to GraphQL – Efficient Pagination and Date Filtering with FastAPI**

### Introduction

As **FountainAI** matured, our original REST API-based GitHub integration struggled to meet the demands of handling large and complex datasets. The increasing size of commit histories and repository trees led to performance issues, hitting REST API rate limits and encountering inefficiencies in data retrieval.

In this chapter, we transition from the **GitHub REST API** to the **GitHub GraphQL API**, which provides more flexibility and efficiency in querying. Specifically, we focus on how to implement **cursor-based pagination** and **date filtering**, essential for dealing with large datasets like commit histories in repositories. 

By the end of this chapter, you'll understand:
- Why the transition from REST to GraphQL was necessary.
- How cursor-based pagination is superior to offset-based pagination.
- How to implement a real-world example of querying GitHub commit history with pagination and filtering by date.

---

### Limitations of the REST API

The **GitHub REST API** initially served our needs well, enabling straightforward access to repository data such as commit histories, file contents, and directory structures. However, as the repository grew in size and complexity, several key challenges surfaced:

1. **Inefficient Data Fetching**: 
   - The REST API’s fixed endpoints often returned more data than required, leading to over-fetching.
   
2. **Offset-Based Pagination**:
   - Pagination in the REST API is handled through numeric offsets, which become unreliable when new data (such as commits) is constantly being added. This results in inconsistent and inaccurate results over time.

3. **Rate Limits**:
   - The REST API has stringent rate limits, especially for unauthenticated requests. Even authenticated requests, capped at 5,000 per hour, quickly became a bottleneck when retrieving large sets of data.

These limitations prompted us to transition to the **GitHub GraphQL API**, where we could fine-tune queries, only retrieve the exact data we needed, and implement **cursor-based pagination** for efficient data handling.

---

### Enter GraphQL: A Better Alternative

GraphQL introduces several advantages over REST:

1. **Exact Data Retrieval**:
   - With GraphQL, we specify exactly which fields and relationships to fetch, avoiding the over-fetching problem inherent to REST.

2. **Cursor-Based Pagination**:
   - Instead of relying on numeric offsets, GraphQL uses **cursors** to mark the position of items in the dataset. This ensures consistent pagination, even as new data is added.

3. **Efficient Querying**:
   - GraphQL allows us to structure complex queries, such as fetching commits based on a date range or paginating through large commit histories, all within a single API request.

Let’s now explore the process of implementing **GraphQL-based pagination** and **date filtering** in a FastAPI application.

---

### Implementing Pagination and Date Filtering with GraphQL

#### Step 1: Setting Up FastAPI and GitHub GraphQL

First, ensure you have FastAPI and the required dependencies installed. We use the `requests` library to interact with GitHub’s GraphQL API.

```bash
pip install fastapi uvicorn requests
```

Now, create a new FastAPI app. Here’s the skeleton of our app:

```python
from fastapi import FastAPI, HTTPException, Query
import requests

app = FastAPI()

GITHUB_GRAPHQL_API_URL = "https://api.github.com/graphql"
GITHUB_TOKEN = "your_github_token_here"  # Replace with your GitHub token

# Helper function to query GitHub GraphQL API
def github_graphql_query(query: str, variables: dict = {}):
    headers = {
        "Authorization": f"Bearer {GITHUB_TOKEN}",
        "Content-Type": "application/json"
    }
    response = requests.post(GITHUB_GRAPHQL_API_URL, json={"query": query, "variables": variables}, headers=headers)
    if response.status_code != 200:
        raise HTTPException(status_code=response.status_code, detail=response.text)
    return response.json()
```

---

#### Step 2: Understanding Cursor-Based Pagination

In GraphQL, **cursor-based pagination** uses a cursor, which is a unique identifier for each item (commit, file, etc.). The cursor allows you to move forward or backward through the dataset without losing track of your position, even if new data is added.

**Why Cursors?**
- **Consistency**: With new commits constantly being added, cursor-based pagination ensures that you never miss or skip items.
- **Performance**: Instead of loading all items at once, cursors enable you to load items in manageable batches.

Here’s a simple GraphQL query to fetch the first 5 commits and their corresponding cursors:

```graphql
query($owner: String!, $repo: String!, $limit: Int!, $cursor: String) {
  repository(owner: $owner, name: $repo) {
    ref(qualifiedName: "main") {
      target {
        ... on Commit {
          history(first: $limit, after: $cursor) {
            edges {
              cursor
              node {
                message
                committedDate
              }
            }
            pageInfo {
              hasNextPage
              endCursor
            }
          }
        }
      }
    }
  }
}
```

---

#### Step 3: Implementing the Query in FastAPI

Now, we’ll integrate this GraphQL query into our FastAPI app, allowing for paginated retrieval of commits. Additionally, we’ll add date filtering to fetch commits within a specific date range.

```python
@app.get("/repo/{owner}/{repo}/commits")
def get_commits_by_date(
    owner: str, 
    repo: str, 
    limit: int = Query(5, description="Number of commits to fetch per page"), 
    cursor: Optional[str] = Query(None, description="Cursor for fetching the next page of commits"),
    start_date: Optional[str] = Query(None, description="Filter commits starting from this date (YYYY-MM-DD)"),
    end_date: Optional[str] = Query(None, description="Filter commits until this date (YYYY-MM-DD)")
):
    """
    Fetch the most recent commits from a GitHub repository, with pagination support and optional date filtering.
    """
    query = """
    query($owner: String!, $repo: String!, $limit: Int!, $cursor: String) {
      repository(owner: $owner, name: $repo) {
        ref(qualifiedName: "main") {
          target {
            ... on Commit {
              history(first: $limit, after: $cursor) {
                edges {
                  cursor
                  node {
                    message
                    committedDate
                  }
                }
                pageInfo {
                  hasNextPage
                  endCursor
                }
              }
            }
          }
        }
      }
    }
    """
    
    variables = {"owner": owner, "repo": repo, "limit": limit, "cursor": cursor}
    result = github_graphql_query(query, variables)
    
    # Filter commits by date if start_date and end_date are provided
    commits = []
    for commit in result["data"]["repository"]["ref"]["target"]["history"]["edges"]:
        commit_date = commit["node"]["committedDate"]
        
        # Only add the commit if it's within the specified date range
        if (not start_date or commit_date >= start_date) and (not end_date or commit_date <= end_date):
            commits.append({
                "message": commit["node"]["message"],
                "cursor": commit["cursor"],
                "committedDate": commit_date
            })
    
    page_info = result["data"]["repository"]["ref"]["target"]["history"]["pageInfo"]
    
    return {
        "commits": commits,
        "pageInfo": {
            "hasNextPage": page_info["hasNextPage"],
            "endCursor": page_info["endCursor"]
        }
    }
```

---

#### Step 4: Efficient Pagination and Date Filtering

Now that we have the basic structure in place, you can efficiently paginate through commit histories and filter them by date. This approach ensures that even large datasets are handled gracefully, avoiding the performance issues we encountered with the REST API.

You can test your API by fetching:
- The most recent 5 commits:  
  `GET /repo/{owner}/{repo}/commits?limit=5`
  
- Commits between `2024-09-01` and `2024-09-07`:  
  `GET /repo/{owner}/{repo}/commits?start_date=2024-09-01&end_date=2024-09-07`

---

### Conclusion

Transitioning from the REST API to **GraphQL** offers significant advantages in handling large datasets efficiently. By using **cursor-based pagination** and **date filtering**, we ensure that our API remains performant and flexible, even as our repository grows.

GraphQL's ability to query exactly the data we need—without over-fetching—has proven invaluable for scaling FountainAI. As you continue to develop more complex API features, remember that **GraphQL** is not just a replacement for REST, but an evolution in how we think about data querying and efficiency.

---

### Sidebar: Does Kong Support GraphQL?

As of now, **Kong Gateway** (a popular API gateway tool) does not natively expose a **GraphQL API**. However, Kong can be used to route **GraphQL queries** just like any other HTTP request, and plugins can be developed or configured to handle specific **GraphQL needs**, such as caching or authentication. Many organizations use Kong as part of their GraphQL architecture, particularly for handling authentication, rate-limiting, and monitoring.

