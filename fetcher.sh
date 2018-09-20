while true; do
    echo "Fetching testfile"
    curl --output `date --iso-8601=seconds` --connect-timeout 2 -s -S "server.nsa:9090/testfile"
    echo "Sleeping 2 seconds"
    sleep 2
done
