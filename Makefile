PRESET_FILES := $(wildcard *.json)

check: ## Run checks
check: lint-presets-valid lint-presets-have-description

lint-presets-valid: ## Ensure preset files are valid Renovate configs
	renovate-config-validator $(PRESET_FILES)

lint-presets-have-description: ## Ensure preset files have a "description" field for project documentation
	@if output=$$(grep -L '^  "description": ' $(PRESET_FILES)) && [ -n "$$output" ]; then printf "Missing description field:\n%s\n" "$$output" && exit 1; fi

fmt: ## Format code
	git ls-files "*.nix" -z | parallel -0 nix fmt

generate-preset-summary-table:
	@grep -oP '^  "description": "\K(.*)(?=",$$)' $(PRESET_FILES) | (echo "Preset:Description"; echo "---:---"; cat) | column -t -s ':' -o ' | '

SUMMARY_TABLE_BEGIN_MARKER := <!-- preset_summary_table_begin -->
SUMMARY_TABLE_END_MARKER := <!-- preset_summary_table_end -->

update-preset-summary-table: ## Update preset summary table in README.md
	awk '/$(SUMMARY_TABLE_BEGIN_MARKER)/{print; print ""; system("$(MAKE) -s generate-preset-summary-table"); skip=1} /$(SUMMARY_TABLE_END_MARKER)/{skip=0} !skip' README.md > README.md.new && mv README.md{.new,}

help: ## Display help screen
	@grep -Eh '^[^#[:space:]]+[[:print:]]+:.*?##' $(MAKEFILE_LIST) | \
	sort -d | \
	awk -F':.*?## ' '{printf "\033[36m%s\033[0m\t%s\n", $$1, $$2}' | \
	column -t -s "$$(printf '\t')"
