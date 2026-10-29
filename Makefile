SHELL := bash
CARGO ?= cargo

.PHONY: run
run:
	@if [ -z "$$CRAFT_I18N_DIR" ]; then \
		catalog="$$(cd ../craft-i18n && pwd -P)" || exit 1; \
		if command -v cygpath >/dev/null 2>&1; then catalog="$$(cygpath -m "$$catalog")"; fi; \
		export CRAFT_I18N_DIR="$$catalog"; \
	fi; \
	if [ ! -d "$$CRAFT_I18N_DIR/locales" ]; then \
		printf 'Catalog directory not found: %s\n' "$$CRAFT_I18N_DIR" >&2; exit 1; \
	fi; \
	$(CARGO) run -p wordcraft -- --sample