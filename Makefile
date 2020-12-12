.POSIX:
DIR_BIN = /usr/local/bin
SCRIPTS = $(shell grep -lr "^#\!" ./* | sed 's/.\///')
CONFIG = $(shell find $$PWD -type f -name "*rc")
init:
	@[ $(CONFIG) ] && { \
		[ -f ~/.config/$(CONFIG) ] || cp $(CONFIG) ~/.config; \
	} || exit 0
	@echo Initiation finished.
install:
	@mkdir -p $(DIR_BIN)
	@for script in $(SCRIPTS); do \
		cp -f $$script $(DIR_BIN); \
		chmod 755 $(DIR_BIN)/$${script##*/}; \
		done
	@echo Installation finished.
uninstall:
	@for script in $(SCRIPTS); do rm -f $(DIR_BIN)/$${script##*/}; done
	@echo Uninstallation finished.
.PHONY: init install uninstall
