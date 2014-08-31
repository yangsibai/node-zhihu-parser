util = require("./util")
request = require("request")
cheerio = require("cheerio")

exports.parse = (url, cb)->
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

				answersArr.push
					author: util.getAuthor(authorInfo)
					content: answerDetail.html().trim()

			article =
				title: title
				question: question
				answers: answersArr

			cb(null, article);
