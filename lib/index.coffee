util = require("./util")
request = require("request")
cheerio = require("cheerio")

###
    zhihu parser
    @param {String} url
    @param {Function} cb callback function
###
exports.parse = (url, cb)->
	if url
		if util.isZhihuDaily(url)
			_parseDaily url, cb
		else if util.isZhihuQuestion(url)
			_parseQuestion url, cb
		else
			cb new Error("url #{url} isn't zhihu daily or zhihu question")
	else
		cb new Error("must have a url")

###
    parse zhihu question
    @param {String} url
    @param {Function} cb callback function
###
_parseQuestion = (url, cb)->
	if util.isZhihuQuestion(url)
		util.download url, (err, content)->
			if err
				cb err
			else
				$ = cheerio.load(content)
				page = [];

				title = $('#zh-question-title').text().trim();
				question = $("#zh-question-detail").html().trim();
				page.push('<div>' + question + '</div>');
				page.push('<hr>');

				answersArr = []
				answers = $('.zm-item-answer');
				answers.each ()->
					node = $(this)
					authorInfo = node.find('.zm-item-answer-author-wrap').text().trim()
					node.find('.toggle-expand').remove()
					answerDetail = node.find('.zm-editable-content')

					util.pullOutRealPath(answerDetail)
					util.trimAttrs(answerDetail)

					answersarr.push
						author: util.getAuthor(authorInfo)
						content: answerDetail.html().trim()

				article =
					title: title
					question: question
					answers: answersArr

				cb null, article
	else
		cb new Error("url #{url} isn't zhihu question page")

###
    parse zhihu daily page
    @param {String} url
    @param {Function} cb callback function
###
_parseDaily = (url, cb)->
	if util.isZhihuDaily(url)
		util.download url, (err, content)->
			if err
				cb err
			else
				$ = cheerio.load(content)
				title = $('title').text();
				imgSrc = $('.img-wrap img').attr('src').trim();

				question = $('.question-title').text();

				answers = $('.answer');

				answersArr = []

				answers.each ()->
					node = $(this);
					author = node.find('.meta').text();
					answerDetail = node.find('.content');

					solveHelper.zhihuImg(answerDetail);
					solveHelper.trimAttrs(answerDetail);

					answersArr.push
						author: util.getAuthor(author.trim())
						content: answerDetail.html().trim()

				article =
					title: title
					question: question
					image: imgSrc
					answers: answersArr
				cb null, article
	else
		cb new Error("url #{url} isn't zhihu daily page")