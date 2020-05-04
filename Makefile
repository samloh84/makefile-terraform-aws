SHELL := /bin/bash
.SHELLFLAGS := -ec

.PHONY: build push save load rmi run rund run_shell exec_shell kill logs logsf rm start stop

TERRAFORM_TFVARS_FILES := *.tfvars

define _LOAD_AWSRC :=
	if [[ -f "~/.awsrc" ]]; then \
		source "~/.awsrc"; \
	fi; \
	if [[ -f "$(CURDIR)/.awsrc" ]]; then \
		source "~/.awsrc";  \
	fi
endef

define _SET_TERRAFORM_TFVARS_FILES :=
	if [[ ! -z "$(TERRAFORM_TFVARS_FILES)" ]]; then \
		TERRAFORM_TFVARS_FILES=($(TERRAFORM_TFVARS_FILES)); \
	else \
		TERRAFORM_TFVARS_FILES=(); \
	fi; \
	TERRAFORM_VAR_FILE_ARGS=(); \
	for TERRAFORM_TFVARS_FILE_PATTERN in $${TERRAFORM_TFVARS_FILES[@]}; do \
		for TERRAFORM_TFVARS_FILE in $$(find $(CURDIR) -name "$${TERRAFORM_TFVARS_FILE_PATTERN}"); do \
			TERRAFORM_VAR_FILE_ARGS+=("-var-file" "$${TERRAFORM_TFVARS_FILE}"); \
		done; \
	done
endef


all: apply destroy refresh output

apply:
	set -euxo pipefail; \
	$(call _LOAD_AWSRC); \
	$(call _SET_TERRAFORM_TFVARS_FILES); \
	TERRAFORM_APPLY_ARGS=("-auto-approve" "$${TERRAFORM_VAR_FILE_ARGS[@]}"); \
	terraform init; \
	terraform apply "$${TERRAFORM_APPLY_ARGS[@]}"

destroy:
	set -euxo pipefail; \
	$(call _LOAD_AWSRC); \
	$(call _SET_TERRAFORM_TFVARS_FILES); \
	TERRAFORM_DESTROY_ARGS=("-auto-approve" "$${TERRAFORM_VAR_FILE_ARGS[@]}"); \
	terraform init; \
	terraform destroy "$${TERRAFORM_DESTROY_ARGS[@]}"

refresh:
	set -euxo pipefail; \
	$(call _LOAD_AWSRC); \
	$(call _SET_TERRAFORM_TFVARS_FILES); \
	TERRAFORM_REFRESH_ARGS=("$${TERRAFORM_VAR_FILE_ARGS[@]}"); \
	terraform init; \
	terraform refresh "$${TERRAFORM_REFRESH_ARGS[@]}"

output:
	set -euxo pipefail; \
	$(call _LOAD_AWSRC); \
	terraform init; \
	terraform output