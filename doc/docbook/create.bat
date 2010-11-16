@set NAME=Documentation
@set PROC=c:/Programme/Saxon/saxon9.jar
@java -jar %PROC% -o %NAME%.html %NAME%.xml html\docbook.xsl
@java -jar %PROC% -o %NAME%.fo %NAME%.xml fo\docbook.xsl
@fop.bat -fo %NAME%.fo -pdf %NAME%.pdf
