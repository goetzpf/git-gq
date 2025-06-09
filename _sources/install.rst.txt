How to install git-gq
=====================

Install from source
-------------------

.. note::
   Usually you have a distribution tar.gz file. If this is the case see below
   at "Install from distribution".

Check out the repository::

  git clone https://github.com/goetzpf/git-gq.git

Build distribution directory::

  administration_tools/doc-rebuild.sh
  administration_tools/mk-dist.sh  

Now go to directory "dist::

  cd dist

Unpack the tar file::

  tar -xzf git-gq-*.tar.gz

See with `ls -l` which directory was created and change into that directory::

  cd git-gq-<SOME-VERSION-NUMBER>

And continue below at "Install from distribution".

Install from distribution
-------------------------

You can install git-gq system-wide if you have "sudo" rights, or in a local
directory.

In both cases you do this with the script `install.sh`.

System wide installation
++++++++++++++++++++++++

Run::

  ./install.sh install global

Local installation in directory "DIR"
+++++++++++++++++++++++++++++++++++++

Run::

  ./install.sh install DIR

How to uninstall
----------------

In any case, git-gq can be uninstalled with::

  git-gq-uninstall.sh

The script is installed at the same location as the program `git-gq`.
