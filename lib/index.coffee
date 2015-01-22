util = require("./util")
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
        else if util.isZhihuTopic(url)
            _parseTopic url, cb
        else
            cb new Error("url #{url} isn't zhihu daily or zhihu question")
    else
        cb new Error("must have a url")

###
    parse zhihu tags
    @param {String} url
    @param {Function} cb callback function
###
_parseTopic = (url, cb)->
    util.download url, (err, content)->
        return cb(err) if err
        $ = cheerio.load(content)

        title = util.getTopicTitle($('#zh-topic-title'))
        followerCount = util.getFollowerCount($('#zh-topic-side-head'))
 
        tagsArr = util.getTags($, $("#zh-topic-side-children-list .zm-item-tag"))
        questionsArr = util.getTopicQuestions($, $('.question_link'))

        topic =
            title: title
            followerCount: followerCount
            questions: questionsArr
            childTags: tagsArr

        cb null, topic

###
    parse zhihu question
    @param {String} url
    @param {Function} cb callback function
###
_parseQuestion = (url, cb)->
    util.download url, (err, content)->
        return cb(err) if err
        $ = cheerio.load(content)

        title = $('#zh-question-title').text().trim()
        followerCount = util.getFollowerCount($('#zh-question-side-header-wrap'))
        question = $("#zh-question-detail").html().trim()
        tagElems = $(".zm-item-tag")

        tags = []
        tagElems.each (i, el)->
            tags.push $(el).text().trim()

        answersArr = []
        answers = $('.zm-item-answer')
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
            followerCount: followerCount
            question: question
            tags: tags
            answers: answersArr

        cb null, article

###
    parse zhihu daily page
    @param {String} url
    @param {Function} cb callback function
###
_parseDaily = (url, cb)->
    util.download url, (err, content)->
        return cb(err) if err
        $ = cheerio.load(content)
        title = $('title').text()
        imgSrc = $('.img-wrap img').attr('src').trim()

        question = $('.question-title').text()

        answers = $('.answer')

        answersArr = []

        answers.each ()->
            node = $(this)
            author = node.find('.meta').text()
            answerDetail = node.find('.content')

            util.pullOutRealPath(answerDetail)
            util.trimAttrs(answerDetail)

            answersArr.push
                author: util.getAuthor(author.trim())
                content: answerDetail.html().trim()

        article =
            title: title
            question: question
            image: imgSrc
            answers: answersArr
        cb null, article
