.PHONY: help

# Including .env file 
include .env

# Setting up vars
DC = docker-compose
CONFIG_FILES =  $(foreach var, $(shell echo $(IN_SERVICE) | sed -e 's/[ \t]+/\n/g'),-f $(wildcard  *.$(var).yml))

# Parsing arguments 
ifeq ($(firstword $(MAKECMDGOALS)),$(filter $(MAKECMDGOALS),ps debug up start stop restart))
  SERVICE_LIST := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(SERVICE_LIST):;@:)
endif

help:
	@echo 'Usage:'
	@echo '  make <target> [service]'
	@echo 
	@echo 'Managed services: ' $(IN_SERVICE) '(defined in .env file)'
	@echo
	@echo 'Targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo

ps:     ## List of running containers: docker-compose -f <config_file> ps
	@$(DC) $(CONFIG_FILES) ps $(SERVICE_LIST)

up:     ## Create and start containers: docker-compose -f <config_file> up -d [service]
	@$(DC) $(CONFIG_FILES) up -d $(SERVICE_LIST)
 
start:  ## Start containers: docker-compose -f <config_file> start [service] 
	@$(DC) $(CONFIG_FILES) start $(SERVICE_LIST)

stop:	## Stop services: docker-compose -f <config_file> stop [service]
	@$(DC) $(CONFIG_FILES) stop $(SERVICE_LIST)

restart: ## Restart services: docker-compose -f <config_file> restart [service]
	@$(DC) $(CONFIG_FILES) restart $(SERVICE_LIST)

showinsrv: ## Shows services which are under control of docker-compose
	@echo 'IN_SERVICE  = ' $(IN_SERVICE)
	@echo 'COMPOSED CONFIGS = ' $(DC) $(CONFIG_FILES)

config:	## Generate common docker-compose.yml  file
	@echo '=================================================================================================='
	@$(DC) $(CONFIG_FILES) config > docker-compose.yml
	@echo 'docker-compose.yml file for services '' $(IN_SERVICE) ''has been generated'
	@echo '=================================================================================================='
	@ls -la docker-compose.yml
