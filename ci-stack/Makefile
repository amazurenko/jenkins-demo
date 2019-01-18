.PHONY: help

# Including .env file 
include .env

# Setting up vars
DC = docker-compose
DOCKER_COMPOSE_FILES =  $(foreach var, $(shell echo $(IN_SERVICE) | sed -e 's/[ \t]+/\n/g'),-f $(wildcard  *.$(var).yml))

ifeq (nginx, $(filter $(IN_SERVICE), nginx))
  NGINX_CONFIG_FILES := $(foreach var, $(shell echo $(IN_SERVICE) | sed -e 's/[ \t]+/\n/g'), $(wildcard  $(NGINX_CONFIG_PATH)/$(var).vhost.conf)) 
endif
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
	@$(DC) $(DOCKER_COMPOSE_FILES) ps $(SERVICE_LIST)

up: init    ## Create and start containers: docker-compose -f <config_file> up -d [service]
	@$(DC) $(DOCKER_COMPOSE_FILES) up -d $(SERVICE_LIST)
 
start:  ## Start containers: docker-compose -f <config_file> start [service] 
	@$(DC) $(DOCKER_COMPOSE_FILES) start $(SERVICE_LIST)

stop:	## Stop services: docker-compose -f <config_file> stop [service]
	@$(DC) $(DOCKER_COMPOSE_FILES) stop $(SERVICE_LIST)

restart: init ## Restart services: docker-compose -f <config_file> restart [service]
	@$(DC) $(DOCKER_COMPOSE_FILES) restart $(SERVICE_LIST)

showinsrv: ## Shows services which are under control of docker-compose
	@echo 'IN_SERVICE  = ' $(IN_SERVICE)
	@echo 'COMPOSED CONFIGS = ' $(DC) $(DOCKER_COMPOSE_FILES)
	@echo 'NGINX_CONFIG_FILES = ' $(NGINX_CONFIG_FILES)

nginxconf: ## Generate nginx.conf file in accordance to service list defined in .env file
	@echo '=================================================================================================='
	@cat $(NGINX_CONFIG_FILES)  > $(NGINX_CONFIG_PATH)/nginx.conf
	@echo 'nginx.conf file for services '' $(IN_SERVICE) ''has been generated'
	@echo '--------------------------------------------------------------------------------------------------'
	@ls -la $(NGINX_CONFIG_PATH)/nginx.conf
	@echo '=================================================================================================='

config:	## Generate common docker-compose.yml  file
	@echo '=================================================================================================='
	@$(DC) $(DOCKER_COMPOSE_FILES) config > docker-compose.yml
	@echo 'docker-compose.yml file for services '' $(IN_SERVICE) ''has been generated'
	@echo '--------------------------------------------------------------------------------------------------'
	@ls -la docker-compose.yml
	@echo '=================================================================================================='

init: nginxconf config ## Generate config files

