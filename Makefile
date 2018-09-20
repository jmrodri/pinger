SERVER_NS     ?= nsa
FETCHER_NS    ?= nsa
.DEFAULT_GOAL := help

build-fetcher: fetcher.sh Dockerfile-fetcher ## build fetcher image
	docker build -f Dockerfile-fetcher --tag docker.io/jmrodri/fetcher:latest .

push-fetcher: ## push fetcher image
	docker push docker.io/jmrodri/fetcher:latest

clean-fetcher: ## cleanup the fetcher deployment config
	oc delete deploymentconfig fetcher

run-fetcher: ## run the fetcher image
	oc run fetcher --image=docker.io/jmrodri/fetcher:latest -n ${FETCHER_NS}

server: server.go Dockerfile-server ## compile the server binary
	go build server.go

build-server: server ## build the server image
	docker build -f Dockerfile-server --tag docker.io/jmrodri/server:latest .

push-server: ## push the server image
	docker push docker.io/jmrodri/server:latest

clean-server: ## cleanup the server deployment config
	oc delete deploymentconfig server
	oc delete services server

run-server: ## run the server image
	oc run server --image=docker.io/jmrodri/server:latest --expose --port=9090  -n ${SERVER_NS}

clean-all: clean-server clean-fetcher ## clean EVERYTHING
	@echo ""

push-all: push-fetcher push-server ## push-all images
	@echo ""

help: ## Show this help screen
	@echo 'Usage: make <OPTIONS> ... <TARGETS>'
	@echo ''
	@echo 'Available targets are:'
	@echo ''
	@grep -E '^[ a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo ''

