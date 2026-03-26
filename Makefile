SKILLS   = Fakturoid HealthFiling Revolut SecuritiesTax SocialFiling TaxAnalysis TaxFiling TaxReturn
AGENTS   = TaxAdvisorCZ
AGENT_SRC = agents
SKILL_SRC = skills
LIB_DIR  = $(or $(FORGE_LIB),lib)

INSTALL_AGENTS  ?= $(LIB_DIR)/bin/install-agents
INSTALL_SKILLS  ?= $(LIB_DIR)/bin/install-skills
VALIDATE_MODULE ?= $(LIB_DIR)/bin/validate-module

.PHONY: help install clean verify test lint init

init:
	@if [ ! -f $(LIB_DIR)/Cargo.toml ]; then \
	  echo "Initializing forge-lib submodule..."; \
	  git submodule update --init $(LIB_DIR); \
	fi

ifneq ($(wildcard $(LIB_DIR)/mk/common.mk),)
  include $(LIB_DIR)/mk/common.mk
  include $(LIB_DIR)/mk/skills/install.mk
  include $(LIB_DIR)/mk/skills/verify.mk
  include $(LIB_DIR)/mk/agents/install.mk
  include $(LIB_DIR)/mk/agents/verify.mk
  include $(LIB_DIR)/mk/lint.mk
endif

install: install-agents install-skills
clean: clean-agents clean-skills
verify: verify-skills verify-agents
test: $(VALIDATE_MODULE)
	@$(VALIDATE_MODULE) $(CURDIR)
lint: lint-schema lint-shell
