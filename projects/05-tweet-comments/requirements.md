# Tweet Comments

This continues the [Twitter API](../04-training-api/requirements.md) you already built. Keep
working in the same project — you're adding the ability to comment on a tweet.

# The Twist

You're going to build this feature only by prompting Claude Code, applying what you've learned
about AI engineering. This changes how you work:

- Every line of application code, tests, schema and migrations comes out of Claude Code. You write
  the prompts, `CLAUDE.md` / `.claude/` config, and the reviews — nothing else.
- Reading and *rejecting* what comes back is part of the job. Merging something you don't
  understand is exactly the habit this exercise is here to break.
- If you do end up hand-editing code, that's allowed — but log it in your prompt history as a
  prompt failure, and write down what you'd prompt instead next time.

# Setup

You already have the general resources on Claude Code and AI engineering from the earlier email.
Here's what's specific to this exercise:

```bash
# Add the marketplace
/plugin marketplace add agilefreaks/claude-skills

# Install both plugins
/plugin install feature-development@agilefreaks-skills
/plugin install code-review@agilefreaks-skills
```

Then run each plugin's own setup wizard — easy step to miss, don't skip it:

```
set up feature-development
set up code-review
```

- `set up feature-development` reads your existing `CLAUDE.md` / `.claude/rules/` and asks which
  test-collaboration mode you want. **Pick Solo AI.** The other modes have you hand-writing test
  assertions, which this exercise doesn't allow — see The Twist above.
- `set up code-review` detects GitHub Actions and can generate
  `.github/workflows/code-review.yml` so the review runs automatically on your PR. That needs a
  `CLAUDE_CODE_OAUTH_TOKEN` repository secret, generated with `claude setup-token`. Running the
  review locally before you push works just as well if you'd rather skip the CI wiring.

Links: [marketplace](https://github.com/Agilefreaks/claude-skills),
[feature-development](https://github.com/Agilefreaks/claude-skills/tree/main/plugins/feature-development),
[code-review](https://github.com/Agilefreaks/claude-skills/tree/main/plugins/code-review).

`feature-development` is a six-phase workflow — frame, explore, plan, implement, verify, hand off —
built to work with plan mode. Use it as the spine of this exercise instead of free-styling prompts.
Run `code-review` against your own PR before you ask anyone else to look at it.

# Project

### Create Comment Mutation

- The API will receive a tweet's `uuid` and a text message.
- Scans the comment's content for URLs, same as tweets do.
- Extracts Open Graph Metadata from those URLs and saves it against the comment for later
  querying.
- Commenting against a `tweetUuid` that doesn't exist returns a GraphQL error, not a comment with
  a `null` field.

```graphql
type CommentCreateInput {
    tweetUuid: ID!
    content: String!
}

mutation($input: CommentCreateInput!) {
    commentCreate(input: $input) {
        comment {
            uuid
        }
    }
}
```

Example variables:
```json
{
  "input": {
    "tweetUuid": "1231-1231-1231-1231",
    "content": "This is exactly the ladder I needed: https://12ft.io/"
  }
}
```

Returns:

```json
{
  "comment": {
    "uuid": "9911-9911-9911-9911"
  }
}
```

### List Tweets Query

Update the existing `tweets` query so each tweet also exposes its comments, resources and all.

```graphql
type Comment {
    uuid: ID!
    message: String!
    resources: [ResourceDescription]!
}

type Tweet {
    uuid: ID!
    message: String!
    resources: [ResourceDescription]!
    comments: [Comment]!
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
        comments {
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
      ],
      "comments": [
        {
          "uuid": "9911-9911-9911-9911",
          "message": "This is exactly the ladder I needed: https://12ft.io/",
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
  ]
}
```

### General Considerations

- *Reuse, don't duplicate.* You already scan URLs and extract Open Graph metadata for tweets. The
  interesting part of this exercise is getting Claude to find that code and reuse it for comments.
  It will happily write you a second copy instead — catch that in review.
- *Watch your queries.* `tweets` now loads comments and their resources too. Have a look at how
  many queries that fires for a handful of tweets, each with a handful of comments.
- Hint: the Open Graph scraping pattern is in
  [`../04-training-api/examples/nokogiri_example.rb`](../04-training-api/examples/nokogiri_example.rb).

# The Pull Request

Submit two things:

1. The code change.
2. A `PROMPTS.md` at the root of your project. Shape:
   - Chronological entries, one per prompt: the prompt verbatim in a quote block, a short note on
     what came back, and a verdict — accepted / rejected / re-prompted.
   - A closing `## Reflection` section: which prompt did the most work, where did you have to step
     in, what would you put in `CLAUDE.md` so you wouldn't have to next time, and what did Claude
     get wrong that you almost merged anyway.

Take your notes live, as you go — the reflection is the part you can't reconstruct afterwards. But
if you forget, your history isn't lost:

- `/export` inside the session dumps it for you, or
- your transcripts live at `~/.claude/projects/<cwd-with-slashes-as-dashes>/<session-id>.jsonl`,
  and this pulls out just your prompts:

  ```bash
  jq -r 'select(.type=="user") | (.message.content | if type=="string" then . else (map(select(.type=="text").text) | join("\n")) end)' <session-id>.jsonl
  ```

# What We'll Talk About In Review

- Did the Open Graph extraction get reused, or did you end up with two copies of it?
- What ended up in your `CLAUDE.md`, and why?
- Which prompts needed a retry, and what made the first one fail?
- What did you reject outright?
- What did `code-review` flag on your own PR before you handed it over?
