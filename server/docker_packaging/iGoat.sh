   docker run \
        -p 8080:8080 \
        -p 8443:8443 \
        -p 8442:8442 \
        -e MAIN_APP_FILE=igoat_server.rb \
        -d b9e6e94d431a
