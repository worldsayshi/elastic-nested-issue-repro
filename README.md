

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

Error from Elastic version 6.X:

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

The error from Elastic 7.X:


```json
{
  "error" : {
    "root_cause" : [
      {
        "type" : "script_exception",
        "reason" : "runtime error",
        "script_stack" : [
          "org.apache.lucene.search.join.ToParentBlockJoinQuery$BlockJoinScorer.setScoreAndFreq(ToParentBlockJoinQuery.java:349)",
          "org.apache.lucene.search.join.ToParentBlockJoinQuery$BlockJoinScorer.score(ToParentBlockJoinQuery.java:309)",
          "org.apache.lucene.search.ConjunctionScorer.score(ConjunctionScorer.java:59)",
          "org.apache.lucene.search.FilterScorable.score(FilterScorable.java:46)",
          "org.elasticsearch.script.AggregationScript.get_score(AggregationScript.java:124)",
          "<<< unknown portion of script >>>"
        ],
        "script" : "_score",
        "lang" : "painless"
      }
    ],
    "type" : "search_phase_execution_exception",
    "reason" : "all shards failed",
    "phase" : "query",
    "grouped" : true,
    "failed_shards" : [
      {
        "shard" : 0,
        "index" : "integration_test_index_de",
        "node" : "VmWbmOc3SbSLmb8LNQml0A",
        "reason" : {
          "type" : "script_exception",
          "reason" : "runtime error",
          "script_stack" : [
            "org.apache.lucene.search.join.ToParentBlockJoinQuery$BlockJoinScorer.setScoreAndFreq(ToParentBlockJoinQuery.java:349)",
            "org.apache.lucene.search.join.ToParentBlockJoinQuery$BlockJoinScorer.score(ToParentBlockJoinQuery.java:309)",
            "org.apache.lucene.search.ConjunctionScorer.score(ConjunctionScorer.java:59)",
            "org.apache.lucene.search.FilterScorable.score(FilterScorable.java:46)",
            "org.elasticsearch.script.AggregationScript.get_score(AggregationScript.java:124)",
            "<<< unknown portion of script >>>"
          ],
          "script" : "_score",
          "lang" : "painless",
          "caused_by" : {
            "type" : "illegal_state_exception",
            "reason" : "Child query must not match same docs with parent filter. Combine them as must clauses (+) to find a problem doc. docId=2147483647, class org.apache.lucene.search.TermScorer"
          }
        }
      }
    ]
  },
  "status" : 400
}
```

## Known workarounds

You can either set `size` to 1 or remove the score aggregation to avoid the exception. See `query-works-1.json` and `query-works-2.json` for examples.

## Useful links
- [Stale but related issue: A problem involving parent-child documents ... ](https://github.com/elastic/elasticsearch/issues/28478)
- [Logging Requests to Elasticsearch](http://blog.florian-hopf.de/2016/03/logging-requests-to-elasticsearch.html)
