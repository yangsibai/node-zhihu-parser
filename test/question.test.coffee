nodeParser = require("../lib/index")
should = require("should")
_ = require("underscore")

describe "parser test", ()->
	it "should parser", (done)->
		url = "http://www.zhihu.com/question/23797702"
		nodeParser.parse url, (err, article)->
			should(err).not.exist
			_validParserResult(article)
			done()
	it "should parse ok", (done)->
		url = "http://www.zhihu.com/question/25066430"
		nodeParser.parse url, (err, article)->
			should(err).not.exist
			article.title.should.be.a.String.and.not.be.empty.and.be.exactly("被迫参加莫名其妙的亲戚聚会和人情往来，如何礼貌地打发时间？")
			_validParserResult(article)
			done()

_validParserResult = (article)->
	should(article).be.exist
	article.title.should.be.a.String.and.not.be.empty
	article.question.should.be.a.String.and.not.be.empty
	article.answers.should.be.an.Array
	article.answers.should.matchEach (ans)->
		validAuthor = ans.author.should.have.keys("name", "about")
		validAuthorName = ans.author.name.should.be.a.String.and.not.be.empty
		validAuthorAbout = ans.author.about.should.be.a.String
		hasContent = ans.content.should.be.a.String.and.not.be.empty
		return validAuthor and validAuthorName and validAuthorAbout and hasContent
	article.tags.should.be.an.Array
	article.tags.should.matchEach (tag)->
		return tag.should.be.a.String.and.not.be.empty