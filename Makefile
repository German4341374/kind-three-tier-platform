SHELL := /bin/bash
TOOLS := $(CURDIR)/.tools/bin
export PATH := $(TOOLS):$(HOME)/.local/bin:$(PATH)

.PHONY: setup lint test up down deploy smoke rollback clean
setup:
	bash scripts/install-tools.sh
	python3 -m pip install --user yamllint==1.38.0
	python3 -m pip install --user -r api/requirements-dev.txt

lint:
	bash scripts/validate.sh
	cd api && ruff check app tests

test:
	cd api && pytest -q

up:
	bash scripts/cluster.sh create

down:
	bash scripts/cluster.sh delete

deploy:
	bash scripts/deploy.sh development

smoke:
	bash scripts/smoke-test.sh

rollback:
	bash scripts/rollback-demo.sh

clean:
	rm -rf .tools build .pytest_cache api/.pytest_cache api/.ruff_cache api/**/__pycache__
