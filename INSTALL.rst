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
  administration_tools/mk-dist.sh --keep

Now go to directory "dist::

  cd dist

go to the distribution directory::

  cd git-gq-*[0-9]

And continue below at "Install from distribution".

Install from distribution
-------------------------

You can install git-gq system-wide if you have "sudo" rights, or in a local
directory.

In both cases you do this with the script `install.sh`.

System wide installation
++++++++++++++++++++++++

Run::

  sudo ./install.sh

Local installation in DIRECTORY
+++++++++++++++++++++++++++++++

Run::

  ./install.sh DIRECTORY

You should set your PATH variable to the install location. Add this line to
your `$HOME/.bashrc` file (replace 'DIRECTORY' with the actual directory
name)::

  PATH=DIRECTORY/bin:$PATH

To have bash completion, add this line to your `$HOME/.bashrc` file (replace
'DIRECTORY' with the actual directory name)::

  source DIRECTORY/profile.d/git-gq.sh

How to uninstall
----------------

In any case, git-gq can be uninstalled with::

  git-gq-uninstall.sh

The script is installed at the same location as the program `git-gq`.


