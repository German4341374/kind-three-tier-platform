# Contributing

Create a focused branch, keep all source and documentation in English, and never commit credentials. Run `make lint`, `make test`, and—when Docker is available—`make up && make smoke && make rollback && make down` before opening a pull request. Explain any check that could not be run.

Keep manifests in the base when shared by every environment and use small Kustomize patches for environment-specific differences. Update documentation whenever operational behavior changes.
