(:~
 : This <a href="http://docs.basex.org/wiki/Module_Library">XQuery Module</a> contains functions to perform validations against <a href="http://www.w3.org/XML/Schema">XML Schema</a> and <a href="http://en.wikipedia.org/wiki/Document_Type_Declaration">Document Type Declarations</a> . By default, this module uses Java’s standard validators. As an alternative, <a href="http://www.saxonica.com/">Saxon XSLT Processor</a> is used if ( <code>saxon9he.jar</code> , <code>saxon9pe.jar</code> or <code>saxon9ee.jar</code> ) is added to the classpath.
 : 
 : @author BaseX Team
 : @see http://docs.basex.org/wiki/Module_Library
 :)
module namespace validate = "http://basex.org/modules/validate";
declare namespace bxerr = "http://basex.org/errors";

(:~
 : Validates the document specified by <code>$input</code> . Both <code>$input</code> and <code>$schema</code> can be specified as: <ul> <li> <code>xs:string</code>, containing the path to the resource, </li> <li> <code>xs:string</code>, containing the resource in its string representation, or </li> <li> <code>node()</code>, containing the resource itself. </li> </ul>  <p> <code>$schema</code> can be used to specify the schema for validation. If no schema is given, <code>$input</code> is required to contain an <code>xsi:(noNamespace)schemaLocation</code> attribute as defined in <a href="http://www.w3.org/TR/xmlschema-1/#xsi_schemaLocation">W3C XML Schema</a>.
 : </p> 
 :
 : @error bxerr:BXVA0001 the validation fails.
 : @error bxerr:BXVA0002 the validation process cannot be started.
 :)
declare function validate:xsd($input as item()) as empty-sequence() external;

(:~
 : Validates the document specified by <code>$input</code> . Both <code>$input</code> and <code>$schema</code> can be specified as: <ul> <li> <code>xs:string</code>, containing the path to the resource, </li> <li> <code>xs:string</code>, containing the resource in its string representation, or </li> <li> <code>node()</code>, containing the resource itself. </li> </ul>  <p> <code>$schema</code> can be used to specify the schema for validation. If no schema is given, <code>$input</code> is required to contain an <code>xsi:(noNamespace)schemaLocation</code> attribute as defined in <a href="http://www.w3.org/TR/xmlschema-1/#xsi_schemaLocation">W3C XML Schema</a>.
 : </p> 
 :
 : @error bxerr:BXVA0001 the validation fails.
 : @error bxerr:BXVA0002 the validation process cannot be started.
 :)
declare function validate:xsd($input as item(), $schema as item()) as empty-sequence() external;

(:~
 : Validates the document specified by <code>$input</code> and returns warning, errors and fatal errors in a string sequence. <code>$input</code> and <code>$schema</code> can be specified as: <ul> <li> <code>xs:string</code>, containing the path to the resource, </li> <li> <code>xs:string</code>, containing the resource in its string representation, or </li> <li> <code>node()</code>, containing the resource itself. </li> </ul>  <p> <code>$schema</code> can be used to specify the schema for validation. If no schema is given, <code>$input</code> is required to contain an <code>xsi:(noNamespace)schemaLocation</code> attribute as defined in <a href="http://www.w3.org/TR/xmlschema-1/#xsi_schemaLocation">W3C XML Schema</a>.
 : </p> 
 :
 : @error bxerr:BXVA0002 the validation process cannot be started.
 :)
declare function validate:xsd-info($input as item()) as xs:string* external;

(:~
 : Validates the document specified by <code>$input</code> and returns warning, errors and fatal errors in a string sequence. <code>$input</code> and <code>$schema</code> can be specified as: <ul> <li> <code>xs:string</code>, containing the path to the resource, </li> <li> <code>xs:string</code>, containing the resource in its string representation, or </li> <li> <code>node()</code>, containing the resource itself. </li> </ul>  <p> <code>$schema</code> can be used to specify the schema for validation. If no schema is given, <code>$input</code> is required to contain an <code>xsi:(noNamespace)schemaLocation</code> attribute as defined in <a href="http://www.w3.org/TR/xmlschema-1/#xsi_schemaLocation">W3C XML Schema</a>.
 : </p> 
 :
 : @error bxerr:BXVA0002 the validation process cannot be started.
 :)
declare function validate:xsd-info($input as item(), $schema as item()) as xs:string* external;

(:~
 : Validates the document specified by <code>$input</code> . <code>$input</code> can be specified as: <ul> <li> an <code>xs:string</code>, containing the path to the resource, </li> <li> an <code>xs:string</code>, containing the resource in its string representation, or </li> <li> a <code>node()</code>, containing the resource itself. </li> </ul>  <p> <code>$schema</code> can be used to specify the DTD for validation. If no DTD is given, <code>$input</code> is required to contain a DTD doctype declaration.
 : </p> 
 :
 : @error bxerr:BXVA0001 the validation fails.
 : @error bxerr:BXVA0002 the validation process cannot be started.
 :)
declare function validate:dtd($input as item()) as empty-sequence() external;

(:~
 : Validates the document specified by <code>$input</code> . <code>$input</code> can be specified as: <ul> <li> an <code>xs:string</code>, containing the path to the resource, </li> <li> an <code>xs:string</code>, containing the resource in its string representation, or </li> <li> a <code>node()</code>, containing the resource itself. </li> </ul>  <p> <code>$schema</code> can be used to specify the DTD for validation. If no DTD is given, <code>$input</code> is required to contain a DTD doctype declaration.
 : </p> 
 :
 : @error bxerr:BXVA0001 the validation fails.
 : @error bxerr:BXVA0002 the validation process cannot be started.
 :)
declare function validate:dtd($input as item(), $dtd as xs:string) as empty-sequence() external;

(:~
 : Validates the document specified by <code>$input</code> and returns warning, errors and fatal errors in a string sequence. <code>$input</code> can be specified as: <ul> <li> <code>xs:string</code>, containing the path to the resource, </li> <li> <code>xs:string</code>, containing the resource in its string representation, or </li> <li> <code>node()</code>, containing the resource itself. </li> </ul>  <p> <code>$schema</code> can be used to specify the DTD for validation. If no DTD is given, <code>$input</code> is required to contain a DTD doctype declaration.
 : </p> 
 :
 : @error bxerr:BXVA0002 the validation process cannot be started.
 :)
declare function validate:dtd-info($input as item()) as xs:string* external;

(:~
 : Validates the document specified by <code>$input</code> and returns warning, errors and fatal errors in a string sequence. <code>$input</code> can be specified as: <ul> <li> <code>xs:string</code>, containing the path to the resource, </li> <li> <code>xs:string</code>, containing the resource in its string representation, or </li> <li> <code>node()</code>, containing the resource itself. </li> </ul>  <p> <code>$schema</code> can be used to specify the DTD for validation. If no DTD is given, <code>$input</code> is required to contain a DTD doctype declaration.
 : </p> 
 :
 : @error bxerr:BXVA0002 the validation process cannot be started.
 :)
declare function validate:dtd-info($input as item(), $dtd as xs:string) as xs:string* external;



