git-gq administration scripts
=============================

How to create a new release
---------------------------

Get the current version::

  ./show-version.sh

and make up a new version number.

Create a new version
++++++++++++++++++++

Set up a new version like this::

  ./new-version.sh VERSION

HTML documentation
------------------

Rebuild documentation
+++++++++++++++++++++

Run::

  ./doc-rebuild.sh

Upload documentation to github
++++++++++++++++++++++++++++++

Run::

  github-upload-html.sh

Create distribution tar file
----------------------------

Run::

  ./mk-dist.sh
