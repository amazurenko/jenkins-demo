.PHONY: help

# Including .env file and exporting variables
include .env
#VARS:=$(shell sed -ne 's/ *\#.*$$//; /./ s/=.*$$// p' .env )
#$(foreach v,$(VARS),$(eval $(shell echo export $(v)="$($(v))")))

# Setting up vars
DC = docker-compose
CONFIG_FILES =  $(foreach var, $(shell echo $(IN_SERVICE) | sed -e 's/ /\n/g'),-f $(wildcard  *.$(var).yml))

# Parsing arguments 
ifeq ($(firstword $(MAKECMDGOALS)),$(filter $(MAKECMDGOALS),ps debug up start stop restart))
  #SERVICE_LIST := $(word 2, $(MAKECMDGOALS))
  SERVICE_LIST := $(filter-out $(firstword $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(SERVICE_LIST):;@true)
endif

help:
	@echo 'Usage:'
	@echo '  make <target> [service]'
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

string:	## Generate 'docker-compose' command with config list without action
	@echo $(DC) $(CONFIG_FILES)

debug: ## Just debug
	@echo 'CONFIG_FILES = ' $(CONFIG_FILES) 
	@echo 'SERVICE_LIST = ' $(SERVICE_LIST)
	@echo 'IN_SERVICE  = ' $(IN_SERVICE)
	@echo 'TEST  = ' $(TEST)
