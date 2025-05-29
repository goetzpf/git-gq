TOP:=$(shell pwd)
GIT_GQ=$(TOP)/../bin/git-gq

# The list of tests and their order is taken from file "TESTS":
shell_tests:= $(shell cat TESTS)

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

git_gq_add_2.out: git_gq_init.tst
git_gq_pop: git_gq_add_2.out
git_gq_push: git_gq_pop.out
git_gq_pop_all: git_gq_add_2
git_gq_push_all: git_gq_pop_all
git_gq_pop_all_push_all: git_gq_add_2
git_gq_pop_reorder_push: git_gq_add_2
git_gq_new: git_gq_add_2
git_gq_refresh: git_gq_add_2

#--------------------------
#
#all: repo.tst gqpatches.tst 01_patch.tst 02_patch.tst 03_pop.tst \
#	04_pop.tst 05_goto.tst 06_goto.tst
#
#clean:
#	rm -rf .git* .gq* README* script* test* *.tst *.log
#
#repo.tst:
#	echo "A readme file" > README.txt
#	echo -e '#!/bin/bash\n\necho HOHO\n' > script.sh
#	chmod u+x script.sh
#	git init
#	echo 'Makefile' > .gitignore
#	echo '/test*' >> .gitignore
#	echo '*.tst' >> .gitignore
#	echo '*.log' >> .gitignore
#	git add README.txt script.sh .gitignore
#	git commit -m 'initial commit'
#	touch $@
#
#gqpatches.tst: repo.tst
#	git gq init
#	touch $@
#
#01_patch.tst: gqpatches.tst
#	echo "This is an improved README file." > README.txt
#	git commit -a -m 'README was improved.'
#	touch $@
#
#02_patch.tst: 01_patch.tst
#	sed -i -e 's/^echo.*/echo "Script prototype"/' script.sh
#	git commit -a -m 'script.sh was improved.'
#	touch $@
#
#03_pop.tst: 02_patch.tst
#	git gq pop
#	touch $@
#
#04_pop.tst: 03_pop.tst
#	git gq pop
#	touch $@
#
#05_goto.tst: 04_pop.tst
#	git gq goto script
#	touch $@
#
#06_goto.tst: 05_goto.tst
#	git gq goto README
#	touch $@
