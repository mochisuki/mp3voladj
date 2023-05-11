SCRIPT := mp3voladj
CURRENTDIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

PREFIX := ${HOME}/local

.PHONY: install
install:
	mkdir -p $(PREFIX)/bin/
	cp -fa $(CURRENTDIR)/$(SCRIPT) $(PREFIX)/bin/

.PHONY: uninstall
uninstall:
	rm -f $(PREFIX)/bin/$(SCRIPT)
