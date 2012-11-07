all::

SOURCES = \
autoload/textobj/motionmotion.vim \
plugin/textobj/motionmotion.vim

# testing; requires ../vimtap, ../textobj-user-vim, zsh and gauche installed

S = test/gentest.scm
D = test/.t
R = $(D)/runtest.vim
G = $(D)/000-testgen.vim
TESTS := $(wildcard test/??-*.vim)

$(G): $(S)
	mkdir -p $(D)
	gosh $(S) > $@

$(R): $(SOURCES) test/000-builtin.vim $(G)
	cat $^ > $@

test: $(R)
	sh ../vimtap/vtruntest.sh ../vimtap/ $(R)
#	prove --nocolor --exec 'zsh test/r.zsh' test --ext .vim
	for t in $(TESTS); do \
		zsh test/r.zsh $$t; \
	done

VERSION = $(shell sh -c 'git describe HEAD')
ZIPNAME = textobj-motionmotion-$(VERSION)

dist:
	git archive --format=zip --prefix=$(ZIPNAME)/ HEAD^{tree} > $(ZIPNAME).zip

clean:
	rm -f *.zip
	rm -f -r test/.t

.PHONY: test dist clean
