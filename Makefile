.PHONY: install-packages checkenv help test setup update-shared list-packages lint format health-check-local
EXTERNALS = python3 pip3 pipenv serverless
P := $(foreach exec,$(EXTERNALS),$(if $(shell which $(exec)),missing,$(warning "===>>>WARNING:  No required `$(exec)` in PATH <<<===")))

test: ## run all tests in test directory
	AWS_PROFILE=${AWS_PROFILE} PYTHONPATH=${PWD} pipenv run pytest -s -o log_cli=true

setup: install-packages ## install required python + sls packages, only needed one time
#TODO, install serverless locally (npm install serverless, without -g) ???
	sls plugin install -n serverless-python-requirements

install-packages: ## install python packages listed in Pipfile
	pipenv install --dev

list-packages: ## list all the packages, then list all the out of date packages
	@pipenv run pip list
	@echo
	@pipenv run pip list -o

lint: ## lint all the python code using flake8
	@pipenv run flake8 functions tests --show-source --max-line-length 120

format: ## format code inline to python PEP standards using black
	@pipenv run black functions tests --line-length 120

update-shared: ## update sls-shared python package
	sls requirements clean
	pipenv update sls-shared

clean:  ## attempts to make dev environment pristine, removing all serverless, test, and virtual env files
	rm -rf .pytest_cache
	rm -rf .serverless
	rm -rf .venv

health-check-local: ## run sls healthcheck (must be logged in on AWS command-line)
	SLS_DEBUG=* sls invoke local  -f healthCheck --stage dev --log

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
