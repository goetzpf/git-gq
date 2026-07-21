git-gq administration scripts
=============================

Run the tests
-------------

Enter::

  (cd ../test && make clean -sj && make -sj)

How to create a new release
---------------------------

Get the current version::

  ./show-version.sh

and make up a new version number.

Create a new version
++++++++++++++++++++

Set up a new version like this::

  ./new-version.sh VERSION

Documentation
-------------

Rebuild documentation
+++++++++++++++++++++

Run::

  ./doc-rebuild.sh

Upload documentation to github
++++++++++++++++++++++++++++++

Run::

  ./github-upload-html.sh

and follwow the instructions printed on the console.

Create distribution files
-------------------------

First cleanup distribution dir::

  ./cleanup-distdirs.sh

Create distribution for pypi
++++++++++++++++++++++++++++

To create the distribution run::

  ./mk-dist.sh

Create distribution tar file for github
+++++++++++++++++++++++++++++++++++++++

To create the distribution run::

  ./mk-tar-dist.sh

Upload to github
----------------

Run::

  git push

Now go to "Releases" on the web site, click on "draft a new release". Select a
tag and upload the distribution tar file from directory "dist-github".

Upload to pypi
--------------

Note: ~/.pypirc must have this content (password token omitted here)::

  [distutils]
  index-servers=
      pypi
      testpypi

  [testpypi]
  repository = https://test.pypi.org/legacy/
  username = __token__
  password = <PASSWORD-TOKEN FOR testpypi>

  [pypi]
  username = __token__
  password = <PASSWORD-TOKEN FOR pypi>

Since you cannot undo an upload of a specific version, first test with the
pypi test site.

pypi test site
::::::::::::::

Run::

  ./pypi-test-upload.sh

Now test with these commands::

  python3 -m venv tmp
  cd tmp
  bash
  source bin/activate
  pip install -i https://test.pypi.org/simple/ git-gq
  git-gq --version
  <ctrl-d>
  cd ..

If everything worked, remove the test directory with::

  rm -rf tmp

pypi site
:::::::::

Upload to pypi with::

  ./pypi-upload.sh

Third party tools needed for documentation generation
-----------------------------------------------------

You need the following tools:

sphinx
++++++

Homepage: https://www.sphinx-doc.org/en/master/

Package name on fedora systems: python3-sphinx

Installation: Use your package manager

ReadTheDocs
+++++++++++

Homepage: https://sphinx-rtd-theme.readthedocs.io/en/stable/

Installation: Install with pip::

 pip install sphinx_rtd_theme

Explanation of scripts
----------------------

cleanup-distdirs.sh
  Clean all distribution directories.

cleanup-doc.sh
  Remove all generated documentation.

doc-rebuild.sh
  Rebuild documentation.

git-gq-uninstall.sh
  Unstall script used in github tar file (see mk-tar-dist.sh)
  This script is not intended to be called directly from this directory.

github-upload-html.sh
  Upload html documentation to github.

install.sh
  Install script used in github tar file (see mk-tar-dist.sh)
  This script is not intended to be called directly from this directory.

mk-dist.sh
  Create pypi distribution files.

mk-tar-dist.sh
  Create tar distribution file for github.

new-version.sh
  Create a new version.

pypi-test-upload.sh
  Upload to the pypi test site.

pypi-upload.sh
  Upload to pypi.

setenv.sh
  Set environment and create a symlink to run git-gq directly from the working
  copy without installing it.

show-version.sh
  Show the version number of all files that a version number hard-coded.
