# Twitter API

The purpose of the this project is to expose a GraphQL API.

# Resources

Go through the following before starting the implementation

- [GraphQL Crash Course](https://www.youtube.com/watch?v=YFS5fAH2zFQ)
- [Open Graph Protocol](https://ogp.me/)

Don't let the naming confuse you, these are 2 different concepts.

# Project

The API is meant to allow users to post and read tweets.
Setup a new project and install [GraphQL](https://graphql-ruby.org/getting_started)

### Post Tweet Mutation

- The API will receive a text message
- Scans the content for URLs
- Extract Open Graph Metadata from the URLs (ref: )
- Saves the metadata against the created tweet for later querying

```graphql
type TweetCreateInput {
    content: String!
}

mutation($input: TweetCreateInput!) {
    tweetCreate(input: $input) {
        tweet {
            uuid
        }
    }
}
```

Example variables:
```json
{
  "input": {
    "content": "Best thing I found in a while: https://12ft.io/"
  }
}
```

Returns:

```json
{
  "tweet": {
    "uuid": "1231-1231-1231-1231"
  }
}
```

### List Tweets Query

Return a list of tweets and expose resources referenced.

```graphql
type Image {
    url: String!
    byteSize: Int!
}

type ResourceDescription {
    title: String!
    description: String!
    url: String!
    image: Image!
}

type Tweet {
    message: String!
    resources: [ResourceDescription]!
}

query {
    tweets {
        uuid
        message
        resources {
            title
            description
            url
            image {
                url
            }
        }
    }
}
```


Example Return:

```json
{
  "tweets": [
    {
      "uuid": "1231-1231-1231-1231",
      "message": "Best thing I found in a while: https://12ft.io/",
      "resources": [
        {
          "title": "12ft – Hop any paywall",
          "description": "Show me a 10ft paywall, I’ll show you a 12ft ladder",
          "url": "https://12ft.io/",
          "image": {
            "url": "https://12ft.io/og-banner.png"
           }
        }
      ]
    }
  ]
}
```
