/// Generic async lifecycle shared by the feed and search blocs.
enum FetchStatus { initial, loading, success, failure }

/// How the feed renders its articles.
enum FeedLayout { list, grid }
