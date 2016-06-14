A Python Client API for BaseX
=============================

BaseX is a light-weight, high-performance and scalable XML Database engine and XPath/XQuery 3.1 Processor, which includes full support for the W3C Update and Full Text extensions. An interactive and user-friendly GUI frontend gives you great insight into your XML documents.

The Python Client provides access to the BaseX features from within python. This enables records to be read and written from/to BaseX. Full support for FLOWR is provided as well as DB admin features.

----

Creating a new database
-----------------------

.. code:: python

    # -*- coding: utf-8 -*-
    # This example shows how new databases can be created.
    #
    # Documentation: http://docs.basex.org/wiki/Clients
    #
    # (C) BaseX Team 2005-12, BSD License

    import BaseXClient

    # create session
    session = BaseXClient.Session('localhost', 1984, 'admin', 'admin')

    try:
        # create new database
        session.create("database", "<x>Hello World!</x>")
        print(session.info())

        # run query on database
        print("\n" + session.execute("xquery doc('database')"))

        # drop database
        session.execute("drop db database")
        print(session.info())

    finally:
        # close session
        if session:
            session.close()



Query Example
-------------

.. code:: python

    # -*- coding: utf-8 -*-
    # This example shows how queries can be executed in an iterative manner.
    # Iterative evaluation will be slower, as more server requests are performed.
    #
    # Documentation: http://docs.basex.org/wiki/Clients
    #
    # (C) BaseX Team 2005-12, BSD License

    import BaseXClient

    # create session
    session = BaseXClient.Session('localhost', 1984, 'admin', 'admin')

    try:
        # create query instance
        input = "for $i in 1 to 10 return <xml>Text { $i }</xml>"
        query = session.query(input)

        # loop through all results
        for typecode, item in query.iter():
            print("typecode=%d" % typecode)
            print("item=%s" % item)

        # close query object
        query.close()

    finally:
        # close session
        if session:
            session.close()

Add Example
-----------

.. code:: python

    # -*- coding: utf-8 -*-
    # This example shows how new databases can be created.
    #
    # Documentation: http://docs.basex.org/wiki/Clients
    #
    # (C) BaseX Team 2005-12, BSD License

    import BaseXClient

    # create session
    session = BaseXClient.Session('localhost', 1984, 'admin', 'admin')

    try:
        # create new database
        session.create("database", "<x>Hello World!</x>")
        print(session.info())

        # run query on database
        print("\n" + session.execute("xquery doc('database')"))

        # drop database
        session.execute("drop db database")
        print(session.info())

    finally:
        # close session
        if session:
            session.close()

Query Bind Example
------------------

.. code:: python

    # -*- coding: utf-8 -*-
    # This example shows how new databases can be created.
    #
    # Documentation: http://docs.basex.org/wiki/Clients
    #
    # (C) BaseX Team 2005-12, BSD License

    import BaseXClient

    # create session
    session = BaseXClient.Session('localhost', 1984, 'admin', 'admin')

    try:
        # create new database
        session.create("database", "<x>Hello World!</x>")
        print(session.info())

        # run query on database
        print("\n" + session.execute("xquery doc('database')"))

        # drop database
        session.execute("drop db database")
        print(session.info())

    finally:
        # close session
        if session:
            session.close()
