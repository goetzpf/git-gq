.. git-gq documentation master file, created by
   sphinx-quickstart on Fri Jun  6 09:27:37 2025.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Welcome to git-gq's documentation!
==================================

.. toctree::
   :maxdepth: 2
   :hidden:
   :caption: Contents:

   overview
   implementation
   conflicts
   examples
   commandline

Patch queues for git
--------------------

This program implements patch queues for git.

It adds a new command 'gq' in git so you can use it like any other built-in git command.

With command completion, you can press <TAB> on the command line to complete
commands, for example::

  git gq p<TAB><TAB> 

shows the possible sub commands that start with 'p'::

  parent pop push

Patch queues are a very flexible tool for your *local* development. You can put
your git commits aside on the patch queue, re-apply them later, reorder or
combine them.

Patch queues can replace the 'git pull, git rebase' workflow. Instead you put
your local commits aside, run 'git pull' and re-apply them. 

You do not resolve all merge conflicts in one commit, instead you resolve
conflicts separately for each patch, usually this is easier than the standard
approach.

Documentation
-------------

- :doc:`overview`
- :doc:`implementation`
- :doc:`conflicts`
- :doc:`examples`
- :doc:`commandline`

Indices and tables
------------------

* :ref:`genindex`
* :ref:`search`


License and copyright
---------------------

Copyright (c) 2025 by Goetz Pfeiffer <goetzpf@googlemail.com>

This software of this project can be used under GPL v.3, see :doc:`license`.

