SOURCES=BaseXClient/BaseXClient.py

BaseXClient/BaseXClient.py:
	cd BaseXClient && curl -O https://raw.githubusercontent.com/BaseXdb/basex/master/basex-api/src/main/python/BaseXClient.py

all: $(SOURCES)
	python setup.py bdist_wheel
