.POSIX:
DIR_BIN = /usr/local/bin
CONFIG = ~/.config/boltrc
init:
	@[ -f $(CONFIG) ] || cp src/bolt-config $(CONFIG)
	@echo Done initiating configs.
install:
	@mkdir -p $(DIR_BIN)
	@for script in src/*; do \
		cp -f $$script $(DIR_BIN); \
		chmod 755 $(DIR_BIN)/$${script#src/}; \
		done
	@echo Done installing the executable files.
uninstall:
	@for script in src/*;do rm -f $(DIR_BIN)/$${script#src/}; done
	@rm -fr $(CONFIG)
	@echo Done removing executable files.
.PHONY: init install uninstall
