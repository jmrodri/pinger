while true; do
    echo "Fetching testfile"
    curl --output `date --iso-8601=seconds` -s "server.nsa:9090/testfile"
    echo "Sleeping 10 seconds"
    sleep 10
done
