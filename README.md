##zhihu-parser

parse zhihu question page and zhihu daily.

NB: it's beta version now, more test required.

###Start

	var zhihuParser = require("zhihu-parser")
	var url = "http://www.zhihu.com/question/23797702"
	zhihuParser.parse(url,function(err,result){
		console.dir(result);
	});

###install

	npm install zhihu-parser