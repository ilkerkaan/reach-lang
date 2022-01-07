[{"bookPath":"rpc","title":"Specification","titleId":"ref-backends-rpc-proto","hasOtp":true,"hasPageHeader":true},"<p><i id=\"p_0\" class=\"pid\"></i>The Reach RPC Protocol (hereafter, \"the protocol\" or \"it\") is an instance of <a href=\"https://en.wikipedia.org/wiki/JSON\">JSON</a>-based RPC protocol.<a href=\"#p_0\" class=\"pid\">0</a></p>\n<p><i id=\"p_1\" class=\"pid\"></i>It should be transported over <a href=\"https://en.wikipedia.org/wiki/HTTPS\">HTTPS</a> (i.e. HTTP over TLS).<a href=\"#p_1\" class=\"pid\">1</a></p>\n<p>\n  <i id=\"p_2\" class=\"pid\"></i>Requests must include an <code>X-API-Key</code> header whose value is a shared secret between a server instance and an RPC client, referred to as the <span class=\"term\" id=\"term_API%20key\">API key</span>.\n  Typically this value comes from the environment variable <code>REACH_RPC_KEY</code> and is the <a href=\"https://en.wikipedia.org/wiki/Base64\">Base64</a> encoding of 24 random bytes.<a href=\"#p_2\" class=\"pid\">2</a>\n</p>\n<p><i id=\"p_3\" class=\"pid\"></i>Requests must use the <code>POST</code> HTTP method.<a href=\"#p_3\" class=\"pid\">3</a></p>\n<p><i id=\"p_4\" class=\"pid\"></i>Requests specify the RPC method to be invoked via the HTTP request target.<a href=\"#p_4\" class=\"pid\">4</a></p>\n<p>\n  <i id=\"p_5\" class=\"pid\"></i>Requests must include a <a href=\"https://en.wikipedia.org/wiki/JSON\">JSON</a>-encoded array in their body.\n  Requests should indicate this by setting the <code>Content-Type</code> header to <code>application/json; charset=utf-8</code>.\n  This array is interpreted as the arguments to the RPC method.<a href=\"#p_5\" class=\"pid\">5</a>\n</p>\n<p>\n  <i id=\"p_6\" class=\"pid\"></i>Responses must include a <a href=\"https://en.wikipedia.org/wiki/JSON\">JSON</a>-encoded value in their body.\n  Responses should indicate this by setting the <code>Content-Type</code> header to <code>application/json; charset=utf-8</code>.<a href=\"#p_6\" class=\"pid\">6</a>\n</p>\n<p><i id=\"p_7\" class=\"pid\"></i>Responses may include <span class=\"term\" id=\"term_RPC%20handles\">RPC handles</span>, which are strings that represent intermediate resources held on the RPC server that cannot be serialized to JSON.<a href=\"#p_7\" class=\"pid\">7</a></p>\n<p><i id=\"p_8\" class=\"pid\"></i>RPC methods are either synchronous value RPC methods or interactive RPC methods.<a href=\"#p_8\" class=\"pid\">8</a></p>\n<hr>\n<p>\n  <i id=\"p_9\" class=\"pid\"></i><span class=\"term\" id=\"term_Synchronous%20value%20RPC%20methods\">Synchronous value RPC methods</span> consume arguments and produce a single result without further interaction with the client.\n  The result is the body of the response.<a href=\"#p_9\" class=\"pid\">9</a>\n</p>\n<p>\n  <i id=\"p_10\" class=\"pid\"></i>For example, <span class=\"snip\"><span style=\"color: #24292E\">formatCurrency</span></span> is a synchronous value RPC method.\n  A call to <span class=\"snip\"><span style=\"color: #6F42C1\">formatCurrency</span><span style=\"color: #24292E\">(</span><span style=\"color: #032F62\">\"19283.1035819471\"</span><span style=\"color: #24292E\">, </span><span style=\"color: #005CC5\">4</span><span style=\"color: #24292E\">)</span></span> would be represented by the following HTTP session, with request lines indicated by <code>+</code> and response lines indicated by <code>-</code>:<a href=\"#p_10\" class=\"pid\">10</a>\n</p>\n<pre class=\"snippet numbered\"><div class=\"codeHeader\">&nbsp;<a class=\"far fa-copy copyBtn\" data-clipboard-text=\"+ POST /stdlib/formatCurrency HTTP/1.1\n+ X-API-Key: OpenSesame\n+ Content-Type: application/json; charset=utf-8\n+\n+ [ &quot;19283.1035819471&quot;, 4 ]\n\n- HTTP/1.1 200 OK\n- Content-Type: application/json; charset=utf-8\n-\n- &quot;19283.1035&quot;\" href=\"#\"></a></div><ol class=\"snippet\"><li value=\"2\">+ POST /stdlib/formatCurrency HTTP/1.1</li><li value=\"3\">+ X-API-Key: OpenSesame</li><li value=\"4\">+ Content-Type: application/json; charset=utf-8</li><li value=\"5\">+</li><li value=\"6\">+ [ \"19283.1035819471\", 4 ]</li><li value=\"7\"></li><li value=\"8\">- HTTP/1.1 200 OK</li><li value=\"9\">- Content-Type: application/json; charset=utf-8</li><li value=\"10\">-</li><li value=\"11\">- \"19283.1035\"</li></ol></pre>\n<hr>\n<p><i id=\"p_11\" class=\"pid\"></i><span class=\"term\" id=\"term_Interactive%20RPC%20methods\">Interactive RPC methods</span> consume arguments, including a specification of interactive RPC callbacks, and produce an interactive RPC continuation.<a href=\"#p_11\" class=\"pid\">11</a></p>\n<p><i id=\"p_12\" class=\"pid\"></i>An <span class=\"term\" id=\"term_interactive%20RPC%20callback\">interactive RPC callback</span> is a key of a JSON object, bound to <span class=\"snip\"><span style=\"color: #005CC5\">true</span></span>, that indicates that the initiator of an interactive RPC method responds to requests for further data during the execution of this call.<a href=\"#p_12\" class=\"pid\">12</a></p>\n<p><i id=\"p_13\" class=\"pid\"></i>An <span class=\"term\" id=\"term_interactive%20RPC%20continuation\">interactive RPC continuation</span> is a JSON object that matches either:<a href=\"#p_13\" class=\"pid\">13</a></p>\n<ul>\n  <li><i id=\"p_14\" class=\"pid\"></i><span class=\"snip\"><span style=\"color: #24292E\">{</span><span style=\"color: #E36209\">t</span><span style=\"color: #24292E\">: </span><span style=\"color: #032F62\">\"Done\"</span><span style=\"color: #24292E\">, ans}</span></span>, where <span class=\"snip\"><span style=\"color: #24292E\">ans</span></span> is the final result of the original interactive RPC method.<a href=\"#p_14\" class=\"pid\">14</a></li>\n  <li><i id=\"p_15\" class=\"pid\"></i><span class=\"snip\"><span style=\"color: #24292E\">{</span><span style=\"color: #E36209\">t</span><span style=\"color: #24292E\">: </span><span style=\"color: #032F62\">\"Kont\"</span><span style=\"color: #24292E\">, kid, m, args}</span></span>, where <span class=\"snip\"><span style=\"color: #24292E\">kid</span></span> is an RPC handle, <span class=\"snip\"><span style=\"color: #24292E\">m</span></span> is a string naming one of the interactive RPC callback methods, and <span class=\"snip\"><span style=\"color: #24292E\">args</span></span> is an array of the arguments to that method.<a href=\"#p_15\" class=\"pid\">15</a></li>\n</ul>\n<p>\n  <i id=\"p_16\" class=\"pid\"></i>When a <span class=\"snip\"><span style=\"color: #D73A49\">!</span><span style=\"color: #24292E\">js}</span></span>Kont`` value is produced, then the interactive RPC method is suspended until the <code>/kont</code> RPC method is invoked with the continuation RPC handle and the return value of the interactive RPC callback.\n  The result of the <code>/kont</code> RPC method is another interactive RPC continuation.<a href=\"#p_16\" class=\"pid\">16</a>\n</p>\n<p><i id=\"p_17\" class=\"pid\"></i>Clients may perform any RPC methods while an interactive RPC method is suspended.<a href=\"#p_17\" class=\"pid\">17</a></p>\n<p><i id=\"p_18\" class=\"pid\"></i>The server may re-use the same interactive RPC continuation handle many times.<a href=\"#p_18\" class=\"pid\">18</a></p>\n<p>\n  <i id=\"p_19\" class=\"pid\"></i>For example, the execution of a backend is an interactive RPC method.\n  An example interaction might be represented by the following HTTP session, with request lines indicated by <code>+</code> and response lines indicated by <code>-</code>:<a href=\"#p_19\" class=\"pid\">19</a>\n</p>\n<pre class=\"snippet numbered\"><div class=\"codeHeader\">&nbsp;<a class=\"far fa-copy copyBtn\" data-clipboard-text=\"+ POST /backend/Alice HTTP/1.1\n+ X-API-Key: OpenSesame\n+ Content-Type: application/json; charset=utf-8\n+\n+ [ &quot;Contract-42&quot;, { &quot;price&quot;: 10 }, { &quot;showX&quot;: true } ]\n\n- HTTP/1.1 200 OK\n- Content-Type: application/json; charset=utf-8\n-\n- { t: &quot;Kont&quot;, kid: &quot;Kont-A&quot;, m: &quot;showX&quot;, args: [ &quot;19283.1035819471&quot; ] }\n\n+ POST /stdlib/formatCurrency HTTP/1.1\n+ X-API-Key: OpenSesame\n+ Content-Type: application/json; charset=utf-8\n+\n+ [ &quot;19283.1035819471&quot;, 4 ]\n\n- HTTP/1.1 200 OK\n- Content-Type: application/json; charset=utf-8\n-\n- &quot;19283.1035&quot;\n\n+ POST /kont HTTP/1.1\n+ X-API-Key: OpenSesame\n+ Content-Type: application/json; charset=utf-8\n+\n+ [ &quot;Kont-A&quot;, null ]\n\n- HTTP/1.1 200 OK\n- Content-Type: application/json; charset=utf-8\n-\n- { t: &quot;Done&quot;, ans: null }\" href=\"#\"></a></div><ol class=\"snippet\"><li value=\"2\">+ POST /backend/Alice HTTP/1.1</li><li value=\"3\">+ X-API-Key: OpenSesame</li><li value=\"4\">+ Content-Type: application/json; charset=utf-8</li><li value=\"5\">+</li><li value=\"6\">+ [ \"Contract-42\", { \"price\": 10 }, { \"showX\": true } ]</li><li value=\"7\"></li><li value=\"8\">- HTTP/1.1 200 OK</li><li value=\"9\">- Content-Type: application/json; charset=utf-8</li><li value=\"10\">-</li><li value=\"11\">- { t: \"Kont\", kid: \"Kont-A\", m: \"showX\", args: [ \"19283.1035819471\" ] }</li><li value=\"12\"></li><li value=\"13\">+ POST /stdlib/formatCurrency HTTP/1.1</li><li value=\"14\">+ X-API-Key: OpenSesame</li><li value=\"15\">+ Content-Type: application/json; charset=utf-8</li><li value=\"16\">+</li><li value=\"17\">+ [ \"19283.1035819471\", 4 ]</li><li value=\"18\"></li><li value=\"19\">- HTTP/1.1 200 OK</li><li value=\"20\">- Content-Type: application/json; charset=utf-8</li><li value=\"21\">-</li><li value=\"22\">- \"19283.1035\"</li><li value=\"23\"></li><li value=\"24\">+ POST /kont HTTP/1.1</li><li value=\"25\">+ X-API-Key: OpenSesame</li><li value=\"26\">+ Content-Type: application/json; charset=utf-8</li><li value=\"27\">+</li><li value=\"28\">+ [ \"Kont-A\", null ]</li><li value=\"29\"></li><li value=\"30\">- HTTP/1.1 200 OK</li><li value=\"31\">- Content-Type: application/json; charset=utf-8</li><li value=\"32\">-</li><li value=\"33\">- { t: \"Done\", ans: null }</li></ol></pre>","<ul><li class=\"dynamic\"><a href=\"#ref-backends-rpc-proto\">Specification</a></li></ul>"]