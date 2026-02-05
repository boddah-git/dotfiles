include Makefile.inc

venv:
	python3 -m venv ${VENV_DIR}
	${VENV_PIP} install jinja2 pyyaml

stow: 
	stow .

waybar:
	killall waybar
	nohup waybar > /dev/null &

update: stow
