import os
import yaml
import jinja2

BASE_DIR = os.path.dirname(os.path.dirname(__file__))
THEME_FILE = os.path.join(BASE_DIR, "themes", "config.yml")

CONFIG_EXT = ".j2"

with open(THEME_FILE) as f:
    config = yaml.safe_load(f)

# Jinja2 Environment Setup
env = jinja2.Environment(loader=jinja2.FileSystemLoader(BASE_DIR), autoescape=False)

for root, dirs, files in os.walk(BASE_DIR):
    dirs[:] = [d for d in dirs if d not in [".venv", ".git"]]

    for fname in files:
        if fname.endswith(CONFIG_EXT):
            rel_dir = os.path.relpath(root, BASE_DIR)
            rel_path = os.path.join(rel_dir, fname) if rel_dir != "." else fname

            template = env.get_template(rel_path)
            rendered = template.render(**config)

            output_path = os.path.join(root, fname[:-len(CONFIG_EXT)]) 
            with open(output_path, "w") as out:
                out.write(rendered)
            
            print(f"Rendered {output_path}")