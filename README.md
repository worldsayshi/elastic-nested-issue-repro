

# Reproducing `Child query must not match same docs with parent filter` elastic issue

Here is a minimal-ish reproduction of Elastic throwing an error when using a seemingly reasonable combination of queries and aggregations.
Below are also examples of workarounds.

Tested on Elastic `6.4.2`, `6.5.1` and `7.0.0-alpha1`. 

## Prerequisites

Linux with sh, curl and docker-compose.

## How to reproduce

```sh
$ docker-compose up -d
$ sh test.sh
```

## Error


```json
{
  "error": {
    "root_cause": [{
      "type": "illegal_state_exception",
      "reason": "Child query must not match same docs with parent filter. Combine them as must clauses (+) to find a problem doc. docId=2147483647, class org.apache.lucene.search.TermScorer"
    }],
    "type": "search_phase_execution_exception",
    "reason": "all shards failed",
    "phase": "query",
    "grouped": true,
    "failed_shards": [{
      "shard": 0,
      "index": "integration_test_index_de",
      "node": "pfrxb1q0Rsui_PJOgLNjOw",
      "reason": {
        "type": "illegal_state_exception",
        "reason": "Child query must not match same docs with parent filter. Combine them as must clauses (+) to find a problem doc. docId=2147483647, class org.apache.lucene.search.TermScorer"
      }
    }],
    "caused_by": {
      "type": "illegal_state_exception",
      "reason": "Child query must not match same docs with parent filter. Combine them as must clauses (+) to find a problem doc. docId=2147483647, class org.apache.lucene.search.TermScorer",
      "caused_by": {
        "type": "illegal_state_exception",
        "reason": "Child query must not match same docs with parent filter. Combine them as must clauses (+) to find a problem doc. docId=2147483647, class org.apache.lucene.search.TermScorer"
      }
    }
  },
  "status": 500
}
```

## Known workarounds

You can either set `size` to 1 or remove the score aggregation to avoid the exception. See `query-works-1.json` and `query-works-2.json` for examples.

## Useful links
- [Stale but related issue: A problem involving parent-child documents ... ](https://github.com/elastic/elasticsearch/issues/28478)
- [Logging Requests to Elasticsearch](http://blog.florian-hopf.de/2016/03/logging-requests-to-elasticsearch.html)
