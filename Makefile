.POSIX:

##################
# Additional Tasks
##################

.PHONY: help
help: ## show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | \
	sort | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

######################
# Development Workflow
######################

.PHONY: build
build: ## builds a local development Docker image
	. ./scripts/build.sh dev

.PHONY: start
start: ## starts both local development Docker containers
	. ./scripts/start.sh dev

.PHONY: stop
stop: ## stops the local development Docker containers
	. ./scripts/stop.sh dev

.PHONY: test
test: ## runs unit tests in a local development Docker container
	. ./scripts/start.sh test

.PHONY: serve-tests
serve-tests: ## runs unit tests on every file change
	find ./src | entr make test

##############
# UAT Workflow
##############

.PHONY: clean-uat
clean-uat: clean ## cleans remnants of the build process on the UAT machine
	. ./scripts/clean.sh uat

.PHONY: build-uat
build-uat: clean-uat ## builds a remote UAT Docker image
	. ./scripts/build.sh uat

.PHONY: deploy-uat
deploy-uat: ## deploys a remote UAT environment
	. ./scripts/deploy.sh uat

.PHONY: stop-uat
stop-uat: ## stops a remote UAT environment
	. ./scripts/stop.sh uat

#####################
# Deployment Workflow
#####################

.PHONY: clean-prod
clean-prod: clean ## cleans remnants of the build process on the production machine
	. ./scripts/clean.sh prod

.PHONY: build-prod
build-prod: ## builds a remote production Docker image
	. ./scripts/build.sh prod

.PHONY: deploy
deploy: ## deploys the remote production Docker image
	. ./scripts/deploy.sh prod

.PHONY: stop-prod
stop-prod: ## stops the remote prod service
	. ./scripts/stop.sh prod

.PHONY: redeploy
redeploy: stop build-prod deploy ## stops, builds, and deploys a new production Docker image
