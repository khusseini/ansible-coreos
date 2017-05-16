### Settings ###
MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
.SUFFIXES:

### Options
cn := vagrant                        ##Opt: Sets the cluster name (e.g. make cn=my-cloud coreos-kubernetes/configure.yml
i := inventory/vagrant/inventory.ini ##Opt: Set the inventory file location (e.g. make i=inventory/my-cloud/inventory.ini)
verbose := off                       ##Opt: Set ansible verbosity (e.g. make verbose=on coreos-kubernetes/configure.yml)

### Variables ####
inventory = $(strip $(i))
verbose_ansible_on = -vvvv
verbose_ansible_off = ""

### Commands ###
boot = echo "";
info += echo "Using $(inventory)"; echo ""
boot += $(info)

define playbook
cd ansible/; \
    ansible-playbook $(verbose_ansible_$(verbose)) \
        -e "kube_cluster_name=$(cn)" \
        -i $(inventory) playbooks
endef

define help
    echo "Available make commands"
    grep \
        -E \
        '^[a-zA-Z_%-]+:.*?## .*$$'\
        $(MAKEFILE_LIST) \
    | sort \
    | awk '\
        BEGIN {FS = ":.*?## "}; \
        { printf "\033[36m%-30s\033[0m             %s\n", $$1, $$2 } \
    '
    echo "----------------------------------------------"
    echo "Available options"
    grep \
        -E \
        '^[a-zA-Z^-]+.*?##Opt: .*$$' \
        $(MAKEFILE_LIST) \
    | sort \
    | awk '\
        BEGIN {FS = "##Opt: "}; \
        { printf "\033[36m%-30s\033[0m      %s\n", $$1, $$2 } \
    '
endef

define help-playbooks
    echo "Available playbooks"
    grep -rE "^- name: .*$$" ansible/playbooks \
    | grep -oP '([0-9a-z_-]+/[0-9a-z_-]+)\.yml:- name: .*' \
    | sed 's#playbooks/##g' \
    | awk '\
        BEGIN {FS = ":.*- name: "}; \
        {printf "\033[36m%-30s\033[0m            %s\n", $$1, $$2}; \
    ' 2>/dev/null
endef

### Rules ###
.PHONY: help
help:               ## Shows this help
	@$(boot)
	@$(help)
	@echo "----------------------------------------------"
	@$(help-playbooks)
	@echo ""

.PHONY: %
%:                  ## Runs a playbook
	@$(boot)
	@$(playbook)/$*
