PREFIX = /usr/local
install:
	@cp bolt.sh bolt
	@chmod 755 bolt
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@mv bolt ${DESTDIR}${PREFIX}/bin
	@echo Done installing executable files to ${DESTDIR}${PREFIX}/bin
uninstall:
	@rm -f ${DESTDIR}${PREFIX}/bin/bolt
	@echo Done removing executable files from ${DESTDIR}${PREFIX}/bin
