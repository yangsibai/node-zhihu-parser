nodeParser = require("../lib/index")
should = require("should")
_ = require("underscore")

describe "daily parse test", ()->
	it "should parse", (done)->
		url = "http://daily.zhihu.com/story/4131277"
		nodeParser.parse url, (err, article)->
			should(err).not.exist
			_validParserResult(article)
			done()
	it "should parse,too", (done)->
		url = "http://daily.zhihu.com/story/4130697"
		nodeParser.parse url, (err, article)->
			should(err).not.exist
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
