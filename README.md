##zhihu-parser

parse zhihu question page and zhihu daily.

[![NPM](https://nodei.co/npm/zhihu-parser.png?downloads=true&downloadRank=true&stars=true)](https://nodei.co/npm/zhihu-parser/)

###Start

	var zhihuParser = require("zhihu-parser")
	var url = "http://www.zhihu.com/question/23797702"
	zhihuParser.parse(url,function(err,result){
		console.dir(result);
	});

###install

	npm install zhihu-parser
