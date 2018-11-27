curl -H 'Content-Type: application/json' -XPUT 'http://localhost:9200/integration_test_index_*/_settings?preserve_existing=true' -d '{
  "index.indexing.slowlog.threshold.index.debug" : "0s",
  "index.search.slowlog.threshold.fetch.debug" : "0s",
  "index.search.slowlog.threshold.query.debug" : "0s"
}'
