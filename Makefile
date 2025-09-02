.DEFAULT_GOAL := help

.PHONY: tfdocs
tfdocs: ## Generate Terraform documentation
	terraform-docs markdown table --output-file README.md --output-mode inject ./

.PHONY: help
help: ## Show this help message
	@echo "Usage: make [target]"
	@echo "Targets:"
	@echo ""
	@grep -E '^[a-zA-Z0-9_-]+:.*?$$' $(MAKEFILE_LIST) | grep -v ".PHONY" | \
		awk '{split($$0, a, ":"); printf "  %-15s", a[1]; \
		if (match($$0, /##[ \t]+([^#]+)/)) { printf "%s", substr($$0, RSTART+2, RLENGTH-2); } \
		printf "\n";}' | sort
