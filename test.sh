
set -e

sh setup.sh

curl -H 'Content-Type: application/json' -XPOST http://localhost:9200/integration_test_index_de/_search?pretty=true -d@query.json

sh teardown.sh
