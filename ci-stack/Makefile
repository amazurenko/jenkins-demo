.PHONY: version

DC = docker-compose
CONFIG_FILES = $(foreach var,$(shell ls *.yml),-f $(var) )
SERVICE=''

#ifeq (up stop ps restart start gen test, $(firstword $(MAKECMDGOALS)))

ifeq ($(firstword $(MAKECMDGOALS)),$(filter $(MAKECMDGOALS),ps test up start stop restart))
  SERVICE := $(word 2, $(MAKECMDGOALS))
  $(eval $(SERVICE):;@true)
endif

help:
	@echo 'Usage:'
	@echo '  make <target> [service]'
	@echo 
	@echo 'Targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo

ps:     ## List of running containers: docker-compose -f <config_file> ps
	@$(DC) $(CONFIG_FILES) ps $(SERVICE)

up:     ## Create and start containers: docker-compose -f <config_file> up -d [service]
	@$(DC) $(CONFIG_FILES) up -d $(SERVICE)
 
start:  ## Start containers: docker-compose -f <config_file> start [service] 
	@$(DC) $(CONFIG_FILES) start $(SERVICE)

stop:	## Stop services: docker-compose -f <config_file> stop [service]
	@$(DC) $(CONFIG_FILES) stop $(SERVICE)

restart: ## Restart services: docker-compose -f <config_file> restart [service]
	@$(DC) $(CONFIG_FILES) restart $(SERVICE)

string:	## Generate 'docker-compose' command with config list without action
	@echo $(DC) $(CONFIG_FILES)

