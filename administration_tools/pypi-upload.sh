#!/bin/bash

# Pypi usage taken from here:
# https://packaging.python.org/guides/migrating-to-pypi-org/

twine upload ../dist/*.whl ../dist/*.tar.gz

# Note: install the package with:
# pip install git-gq
