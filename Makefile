include Makefile.inc

.PHONY: fonts fonts-clean

venv:
	python3 -m venv ${VENV_DIR}
	${VENV_PIP} install jinja2 pyyaml

stow: 
	stow .

waybar:
	killall waybar
	nohup waybar > /dev/null &

fonts:
	@echo "Installing fonts (preserving directory structure)..."
	@mkdir -p "${FONTS_DEST}"
	@cd "${FONTS_SRC}" && \
	find . -type d -exec mkdir -p "${FONTS_DEST}/{}" \; && \
	find . -type f \( -name "*.ttf" -o -name "*.otf" \) | while read file; do \
		ln -sf "${FONTS_SRC}/$$file" "${FONTS_DEST}/$$file"; \
	done
	@echo "Refreshing font cache..."
	@fc-cache -fv
	@echo "Done."

fonts-clean:
	@echo "Removing symlinked fonts (preserving structure)..."
	@cd "${FONTS_SRC}" && \
	find . -type f \( -name "*.ttf" -o -name "*.otf" \) | while read file; do \
		rm -f "${FONTS_DEST}/$$file"; \
	done
	@fc-cache -fv
	@echo "Fonts removed."

update: stow
