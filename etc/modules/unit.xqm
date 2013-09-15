(:~
 : This <a href="http://docs.basex.org/wiki/Module_Library">XQuery Module</a> contains annotations and functions for performing Unit tests with XQuery.
 : 
 : @author BaseX Team
 : @see http://docs.basex.org/wiki/Module_Library
 :)
module namespace unit = "http://basex.org/modules/unit";

(:~
 : Asserts that the effective boolean value of the specified <code>$test</code> is true and returns an empty sequence. Otherwise, raises an error.
 : If the optional error <code>$message</code> can be specified as second argument.
 :
 : @error :UNIT0001 the assertion failed, or an error was raised.
 :)
declare function unit:assert($test as item()*) as empty-sequence() external;

(:~
 : Asserts that the effective boolean value of the specified <code>$test</code> is true and returns an empty sequence. Otherwise, raises an error.
 : If the optional error <code>$message</code> can be specified as second argument.
 :
 : @error :UNIT0001 the assertion failed, or an error was raised.
 :)
declare function unit:assert($test as item()*, $message as xs:string) as empty-sequence() external;

(:~
 : Raises a unit error with the specified message.
 :
 : @error :UNIT0001 default error raised by this function.
 :)
declare function unit:fail($message as xs:string) as empty-sequence() external;

(:~
 : Runs all functions, or the specified <code>$functions</code> , in the current query context that have <code>unit</code> annotations.
 : A test report is generated and returned, which resembles the format returned by other xUnit testing frameworks, such as the Maven Surefire Plugin.
 :
 : @error :UNIT0002 a test function must have no arguments.
 : @error :UNIT0003 a test function must not be updating.
 : @error :UNIT0004 an annotation was declared twice.
 : @error :UNIT0005 an annotation has invalid arguments.
 :)
declare function unit:test() as element(testsuite)* external;

(:~
 : Runs all functions, or the specified <code>$functions</code> , in the current query context that have <code>unit</code> annotations.
 : A test report is generated and returned, which resembles the format returned by other xUnit testing frameworks, such as the Maven Surefire Plugin.
 :
 : @error :UNIT0002 a test function must have no arguments.
 : @error :UNIT0003 a test function must not be updating.
 : @error :UNIT0004 an annotation was declared twice.
 : @error :UNIT0005 an annotation has invalid arguments.
 :)
declare function unit:test($functions as function(*)*) as element(testsuite)* external;

(:~
 : Runs all functions in the specified modules that have <code>unit</code> annotations.
 : A test report is generated and returned, which resembles the format returned by other xUnit testing frameworks, such as the Maven Surefire Plugin.
 :
 : @error :UNIT0002 a test function must have no arguments.
 : @error :UNIT0003 a test function must not be updating.
 : @error :UNIT0004 an annotation was declared twice.
 : @error :UNIT0005 an annotation has invalid arguments.
 :)
declare function unit:test-uris($uris as xs:string*) as element(testsuites) external;



