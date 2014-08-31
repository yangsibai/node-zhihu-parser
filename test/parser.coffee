nodeParser = require("../lib/index")
should = require("should")
_=require("underscore")

describe "parser test", ()->
	it "should parser", (done)->
		url = "http://www.zhihu.com/question/23797702"
		console.dir nodeParser
		nodeParser.parse url, (err, article)->
			should(err).not.exist
			done()