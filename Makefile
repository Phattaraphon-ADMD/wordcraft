SHELL := bash
CARGO ?= cargo
TRUNK ?= trunk

.PHONY: run web
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

web:
	@if [ -z "$$CRAFT_I18N_DIR" ]; then \
		catalog="$$(cd ../craft-i18n && pwd -P)" || exit 1; \
		if command -v cygpath >/dev/null 2>&1; then catalog="$$(cygpath -m "$$catalog")"; fi; \
		export CRAFT_I18N_DIR="$$catalog"; \
	fi; \
	if [ -z "$$CRAFT_FONTS_DIR" ]; then \
		fonts="$$(cd ../craft-fonts && pwd -P)" || exit 1; \
		if command -v cygpath >/dev/null 2>&1; then fonts="$$(cygpath -m "$$fonts")"; fi; \
		export CRAFT_FONTS_DIR="$$fonts"; \
	fi; \
	if [ ! -d "$$CRAFT_I18N_DIR/locales" ] || [ ! -f "$$CRAFT_FONTS_DIR/fonts/manifest.txt" ]; then \
		printf 'Missing craft-i18n or craft-fonts checkout\n' >&2; exit 1; \
	fi; \
	export CRAFT_I18N_REQUIRED=1 CRAFT_FONTS_REQUIRED=1; \
	cd apps/wordcraft-web && $(TRUNK) build --release