printf "\n"

sh teardown.sh

curl -H 'Content-Type: application/json' -XPUT http://localhost:9200/_template/*_de -d@template.json

curl -H 'Content-Type: application/json' -XPUT http://localhost:9200/integration_test_index_de -d '{
    "settings" : {
        "index" : {
            "number_of_shards" : 1
        }
    }
}'

curl -H 'Content-Type: application/json' -XPUT http://localhost:9200/integration_test_index_de/default/test_document?refresh=true -d@document.json

printf "\n"
