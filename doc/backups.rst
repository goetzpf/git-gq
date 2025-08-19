Backups
=======

The flexibility of the patch queue also makes it easier to mess things up.

In order to have some kind of safety and to be able to restore an older working
state of the patch queue, git-gq uses a git repository for backups.

Implementation
--------------

If ``git gq backup`` is called for the first time, it creates a git repository
inside the patch queue directory.

.. note::
   *All* patch queues are managed with a single git repository.

The backup command creates a directory 'applied' inside the current queue
directory which has a copy of all patches applied at the time.

It then runs ``git commit`` for the patch queue repository.

You can enter arbitrary git commands on the patch queue repository with::

  git gq qrepo COMMAND -- OPTIONS

The command::

  git gq restore REVISION

checks out the given revision in the queue repository.

.. caution
   All changes in the patch queue since the last backup are discarded with this
   command.

.. note::
   Your git repository is not changed by the commands ``git gq backup`` and
   ``git gq restore``.

The command::

  git revert

changes the git repository to the state it had when the last backup was made.
At the parent revision a new branch is created where all the patches from
directory 'applied' are added as regular commits.

How to create  a backup
-----------------------

Simply enter::

  git gq backup

How to restore a backup
-----------------------

Look what backups are present, e.g. with::

  git gq qrepo log

Select a revision and restore it with::

  git gq restore REVISION

Your main git repository is still not changed at this stage.

If you want to reset your main repository to the state of the backup, enter::

  git gq revert

