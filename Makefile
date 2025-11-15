include Makefile.inc

venv:
	python3 -m venv ${VENV_DIR}
	${VENV_PIP} install jinja2 pyyaml

render:
	${VENV_PYTHON} scripts/render.py

stow: 
	stow .

waybar:
	killall waybar
	nohup waybar &

update: render stow
