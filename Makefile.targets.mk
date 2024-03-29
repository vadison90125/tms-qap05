.PHONY: format qa tests coverage code-typing code-format code-linters
.PHONY: sh venv-dir venv venv-dev venv-deploy venv-deploy-all upgrade-venv


qa: tests coverage code-typing code-format code-linters
	$(call log, QA checks)


format:
	$(call log, reorganizing imports & formatting code)
	isort --virtual-env="$(DIR_VENV)" \
		"$(DIR_TESTS)" \
		|| exit 1
	black \
		"$(DIR_TESTS)" \
		|| exit 1


tests:
	$(call log, running tests)
	rm -f .coverage
	rm -f coverage.xml
	rm -rf htmlcov
	pytest


coverage:
	$(call log, calculating coverage)
	coverage html
	coverage xml


code-typing:
	$(call log, checking code typing)
	mypy


code-format:
	$(call log, checking code format)
	isort --virtual-env="$(DIR_VENV)" --check-only \
		"$(DIR_TESTS)" \
		|| exit 1
	black --check \
		"$(DIR_TESTS)" \
		|| exit 1


code-linters:
	$(call log, linting)
	flake8


sh:
	$(call log, starting Python shell)
	ipython


venv-dir:
	$(call log, initializing venv directory)
	test -d .venv || mkdir .venv


venv: venv-dir
	$(call log, installing packages)
	pipenv install


venv-dev: venv-dir
	$(call log, installing development packages)
	pipenv install --dev


venv-deploy: venv-dir
	$(call log, installing packages into system)
	pipenv install --deploy --system


venv-deploy-all: venv-dir
	$(call log, installing all packages into system)
	pipenv install --dev --deploy --system


upgrade-venv: venv-dir
	$(call log, upgrading all packages in virtualenv)
	pipenv update --dev
