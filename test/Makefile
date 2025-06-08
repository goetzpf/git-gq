TOP:=$(shell pwd)
GIT_GQ=$(TOP)/../bin/git-gq

HASH=\#

# The list of tests and their order is taken from file "TESTS":
shell_tests:= $(shell grep -v '^$(HASH)\|^X' TESTS | sed -e 's/ .*//')

# *.sh are the shell scripts:
shell_tests_sh:= $(addsuffix .sh, $(shell_tests))

# *.tst are pseudo files:
shell_tests_tst:= $(addsuffix .tst, $(shell_tests))

all: $(shell_tests_tst)

# sample git repo must be created
repo.stamp:
	mkdir repo
	echo "A readme file" > repo/README.txt
	echo -e '#!/bin/bash\n\necho HOHO\n' > repo/script.sh
	chmod u+x repo/script.sh
	git -C repo init > /dev/null 2>&1
	echo 'Makefile' > repo/.gitignore
	echo '/test*' >> repo/.gitignore
	echo '*.tst' >> repo/.gitignore
	echo '*.log' >> repo/.gitignore
	git -C repo add README.txt script.sh .gitignore > /dev/null
	git -C repo commit -m 'initial commit' > /dev/null
	touch $@

clean:
	rm -rf repo.stamp repo
	rm -rf tmp_*
	rm -rf *.out *.tst

# how to generate an out file:
%.out: %.sh repo.stamp
	@bash ./$< $(GIT_GQ) > $@

# how to perform a shell test:
$(shell_tests_tst): %.tst: %.sh %.ok %.out
	@echo "Test $*" >&2
	@diff $(wordlist 2, 3, $+) 
	@touch $@

git_gq_add_2.out: git_gq_init.out
git_gq_pop.out: git_gq_add_2.out
git_gq_push.out: git_gq_pop.out
git_gq_pop_all.out: git_gq_add_2.out
git_gq_push_all.out: git_gq_pop_all.out
git_gq_pop_all_push_all.out: git_gq_add_2.out
git_gq_pop_reorder_push.out: git_gq_add_2.out
git_gq_new.out: git_gq_add_2.out
git_gq_refresh.out: git_gq_add_2.out
git_gq_goto.out: git_gq_new.out
git_gq_fold.out: git_gq_add_2.out
git_gq_record.out: git_gq_add_2.out
git_gq_delete.out: git_gq_new.out
git_gq_qname.out: git_gq_add_2.out
git_gq_show.out: git_gq_new.out
git_gq_continue.out: git_gq_add_2.out
git_gq_abort.out: git_gq_add_2.out
git_gq_glog.out: git_gq_add_2.out
git_gq_backup.out: git_gq_new.out
git_gq_export.out: git_gq_add_2.out
git_gq_import.out: git_gq_add_2.out
git_gq_parent.out: git_gq_add_2.out
git_gq_pop_tracking_err.out: git_gq_add_2.out

