#!/bin/bash

# Pypi usage taken from here:
# https://packaging.python.org/guides/using-testpypi/

twine upload --repository testpypi ../dist/*.whl ../dist/*.tar.gz

# Note: install the package from pypi test with:
# pip install -i https://test.pypi.org/simple/ git-gq

