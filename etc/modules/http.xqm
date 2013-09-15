(:~
 : This <a href="http://docs.basex.org/wiki/Module_Library">XQuery Module</a> contains a single function to send HTTP requests and handle HTTP responses. The function <code>send-request</code> is based on the <a href="http://expath.org/spec/http-client">EXPath HTTP Client Module</a> . It gives full control over the available request and response parameters. For simple GET requests, the <a href="http://docs.basex.org/wiki/Fetch_Module">Fetch Module</a> may be sufficient.
 : 
 : @author BaseX Team
 : @see http://docs.basex.org/wiki/Module_Library
 :)
module namespace http = "http://expath.org/ns/http-client";
declare namespace exerr = "http://expath.org/ns/error";

(:~
 : Sends an HTTP request and interprets the corresponding response. <code>$request</code> contains the parameters of the HTTP request such as HTTP method and headers. In addition to this it can also contain the URI to which the request will be sent and the body of the HTTP method. If the URI is not given with the parameter <code>$href</code> , its value in <code>$request</code> is used instead. The structure of <code>http:request</code> element follows the <a href="http://expath.org/spec/http-client">EXPath</a> specification.
 :
 : @error exerr:HC0001 an HTTP error occurred.
 : @error exerr:HC0002 error parsing the entity content as XML or HTML.
 : @error exerr:HC0003 with a multipart response, the override-media-type must be either a multipart media type or application/octet-stream.
 : @error exerr:HC0004 the src attribute on the body element is mutually exclusive with all other attribute (except the media-type).
 : @error exerr:HC0005 the request element is not valid.
 : @error exerr:HC0006 a timeout occurred waiting for the response.
 :)
declare function http:send-request($request as element(http:request)?, $href as xs:string?, $bodies as item()*) as item()+ external;

(:~
 : Sends an HTTP request and interprets the corresponding response. <code>$request</code> contains the parameters of the HTTP request such as HTTP method and headers. In addition to this it can also contain the URI to which the request will be sent and the body of the HTTP method. If the URI is not given with the parameter <code>$href</code> , its value in <code>$request</code> is used instead. The structure of <code>http:request</code> element follows the <a href="http://expath.org/spec/http-client">EXPath</a> specification.
 :
 : @error exerr:HC0001 an HTTP error occurred.
 : @error exerr:HC0002 error parsing the entity content as XML or HTML.
 : @error exerr:HC0003 with a multipart response, the override-media-type must be either a multipart media type or application/octet-stream.
 : @error exerr:HC0004 the src attribute on the body element is mutually exclusive with all other attribute (except the media-type).
 : @error exerr:HC0005 the request element is not valid.
 : @error exerr:HC0006 a timeout occurred waiting for the response.
 :)
declare function http:send-request($request as element(http:request)) as item()+ external;

(:~
 : Sends an HTTP request and interprets the corresponding response. <code>$request</code> contains the parameters of the HTTP request such as HTTP method and headers. In addition to this it can also contain the URI to which the request will be sent and the body of the HTTP method. If the URI is not given with the parameter <code>$href</code> , its value in <code>$request</code> is used instead. The structure of <code>http:request</code> element follows the <a href="http://expath.org/spec/http-client">EXPath</a> specification.
 :
 : @error exerr:HC0001 an HTTP error occurred.
 : @error exerr:HC0002 error parsing the entity content as XML or HTML.
 : @error exerr:HC0003 with a multipart response, the override-media-type must be either a multipart media type or application/octet-stream.
 : @error exerr:HC0004 the src attribute on the body element is mutually exclusive with all other attribute (except the media-type).
 : @error exerr:HC0005 the request element is not valid.
 : @error exerr:HC0006 a timeout occurred waiting for the response.
 :)
declare function http:send-request($request as element(http:request)?, $href as xs:string?) as item()+ external;



