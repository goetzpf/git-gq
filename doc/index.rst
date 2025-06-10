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
   prerequisites
   implementation
   conflicts
   examples
   commandline
   install

Patch queues for git
--------------------

This program implements patch queues for 
`git <https://git-scm.com/>`_.

It adds a new command 'gq' in git so you can use it like any other built-in git command.

It also provides
`command completion <https://en.wikipedia.org/wiki/Command-line_completion>`_ so
you don't have to type commands in full length.

Patch queues are a very flexible tool for your *local* development. You can put
your git commits aside on the patch queue, re-apply them later, reorder or
combine them.

Patch queues can replace the 'git pull, git rebase' workflow. Instead you put
your local commits aside, run 'git pull' and re-apply them. 

You do not resolve all merge conflicts at once in one merge commit, instead you
resolve conflicts separately for each patch. This is usually much easier.

:Author:
    Goetz Pfeiffer <goetzpf@googlemail.com>

:Version:
    |version|

.. seealso::
   `Goetz Pfeiffer's Project site <https://goetzpf.github.io/>`_
   for other open source projects.

Disclaimer
----------

.. warning::
   I have tested git-gq and use it myself. However, I cannot *guarantee* that
   it will *never* damage your repository. It's high degree of flexibility also
   means that you may use it in a way I didn't intend and didn't test. 

When you first use this tool you should make regular backups of your
repository. This can be as simple as::

  cp -a MYREPO MYREPO-BACKUP

A simple backup of the state of the patch queue can be done with::

  git gq backup

Run this *before* you reorder or fold patches and before you run `git pull`
while some patches are unapplied.

Documentation
-------------

- :doc:`overview`
- :doc:`prerequisites`
- :doc:`implementation`
- :doc:`conflicts`
- :doc:`examples`
- :doc:`commandline`
- :doc:`install`

Installation
------------

See :doc:`install`

Repository site
---------------

https://github.com/goetzpf/git-gq

Indices and tables
------------------

* :ref:`genindex`
* :ref:`search`


License and copyright
---------------------

Copyright (c) 2025 by Goetz Pfeiffer <goetzpf@googlemail.com>

This software of this project can be used under GPL v.3, see :doc:`license`.

