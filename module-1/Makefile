# Public Variables
# ==============================================================================
#
# The Makefile supports overriding these variables, either by setting them with
# an environment variable or changing them in the Makefile itself. Note that
# "support" only means that the Makefile will continue to work as expected; any
# consequences of changing these variables in terms of the actual Terraform
# code are up to you to handle.

TERRAFORM_VERSION ?= 1.10.5


# Private Variables
# ==============================================================================
#
# These variables are used internally by the Makefile and should not be changed;
# doing so may break the Makefile.

ROOT_DIR ?= ..
BIN_DIR := $(ROOT_DIR)/bin/$(TERRAFORM_VERSION)
SHARED_DIR := $(ROOT_BIR)/shared

TERRAFORM := $(BIN_DIR)/terraform
SHA256SUMS := terraform_$(TERRAFORM_VERSION)_SHA256SUMS

COMMON_FILES := $(shell if [ -d $(SHARED_DIR) ]; then ls $(SHARED_DIR)/*.tf ; fi)
SOURCE_FILES := $(shell find . -type f -name '*.tf') $(COMMON_FILES)
COMMON_CONFIG_FILES := $(shell if [ -d $(SHARED_DIR) ]; then ls $(SHARED_DIR)/providers.tf ; fi)
LOCAL_CONFIG_FILES := $(shell find . -type f -name 't*cloud*.tf')
CONFIG_FILES := $(COMMON_CONFIG_FILES) $(LOCAL_CONFIG_FILES)

OS := $(shell uname -s | tr '[:upper:]' '[:lower:]')
ARCH := $(shell uname -m | sed 's/x86_64/amd64/')
TERRAFORM_ZIP := terraform_$(TERRAFORM_VERSION)_$(OS)_$(ARCH).zip

# Make Commands
# ==============================================================================

plan: $(TERRAFORM) init
	$(TERRAFORM) plan

install-terraform: $(TERRAFORM)

init: .tf_init.tgt
.tf_init.tgt: $(CONFIG_FILES) | $(TERRAFORM)
	$(TERRAFORM) init
	@touch $@

clean:
	rm -rf bin .terraform.* .*.tgt

$(TERRAFORM): | $(BIN_DIR)
	curl -sSL -o /tmp/$(SHA256SUMS) https://releases.hashicorp.com/terraform/$(TERRAFORM_VERSION)/$(SHA256SUMS)
	curl -sSL -o /tmp/$(TERRAFORM_ZIP) https://releases.hashicorp.com/terraform/$(TERRAFORM_VERSION)/$(TERRAFORM_ZIP)
	@actual_sha256sum="$$(cd /tmp && sha256sum $(TERRAFORM_ZIP))"; \
		if ! grep "$$actual_sha256sum" /tmp/$(SHA256SUMS); then \
			echo "The Terraform ZIP file is corrupted; please try again" 1>&2; \
			exit 1; \
		fi
	unzip -d $(BIN_DIR) /tmp/$(TERRAFORM_ZIP)
	@rm /tmp/$(TERRAFORM_ZIP)
	@rm /tmp/$(SHA256SUMS)
	@touch $@

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

.PHONY: plan install-terraform clean init
