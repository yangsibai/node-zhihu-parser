request = require("request")

###
    detect url is zhihu question
    @param {String} url
###
_isZhihuQuestion = exports.isZhihuQuestion = (url)->
    pattern = /zhihu\.com\/question/i
    return pattern.test(url)

###
    detect url is zhihu topic
    @param {String} url
###
_isZhihuQuestion = exports.isZhihuTopic = (url)->
    pattern = /zhihu\.com\/topic/i
    return pattern.test(url)

###
    detect url is zhihu daily
###
_isZhihuDaily = exports.isZhihuDaily = (url)->
    pattern = /daily\.zhihu\.com\/story\/\d+/i
    return pattern.test(url)

###
    download page
###
exports.download = (url, cb)->
    request url, (err, response, body)->
        if err
            cb err
        else if response.statusCode isnt 200
            cb new Error("http error,code:#{response.statusCode}")
        else
            cb null, body.toString()

###
    remove attributes
    @param {Object} node
###
exports.trimAttrs = (node)->
    all = node.find("*")
    for n in all
        proAttrs = ['srv']
        if n.name isnt "object" and n.name isnt "embed"
            proAttrs.push 'href'
            proAttrs.push 'width' #TODO:图片的宽度高度应该留一个
        for attr in n.attribs
            $(n).removeAttr(attr) if attr not in proAttrs #TODO:是否可以通过直接 delete 呢

###
    replace relative path with real path
    @param {Object} node
    @param {String} baseUrl
###
exports.pullOutRealPath = (node, baseUrl)->
    if baseUrl
        imgs = node.find('img')
        imgs.each (i, img)->
            realPath = img.attribs['src']
            _.each img.attribs, (value, key)->
                realPath = value if _isUrl(value) and (value isnt realPath or (not realPath))
            img.attribs['src'] = if _isUrl(realPath) then realPath else url.resolve(baseUrl, realPath)

        links = node.find('a')
        links.each (i, link)->
            link.attribs['href'] = url.resolve(baseUrl, link.attribs['href']) if link.attribs['href']

###
   get questions in a topic
###
exports.getTopicQuestions = ($, nodes)->
        questionsArr = []
        seenUrls = []

        nodes.each ()->
            node = $(this)
            qTitle = node.text().trim()
            qUrl = exports.toAbsolute(node.attr('href'))
            if seenUrls.indexOf(qUrl) == -1
                seenUrls.push qUrl
                questionsArr.push
                    title: qTitle
                    url: qUrl
        questionsArr = questionsArr

###
   get questions in a topic
###
exports.getTags = ($, nodes)->
        tags = []
        nodes.each ()->
            node = $(this)
            tags.push
                title: node.text().trim()
                url: exports.toAbsolute(node.attr('href'))
        tags = tags

###
    get title of a topic
###
exports.toAbsolute = (href)->
    absoluteUrl = "http://www.zhihu.com" + href

###
    get title of a topic
###
exports.getTopicTitle = (node)->
    text = node.text().trim()
    pattern = /^([^\n]*)/
    matches = text.match(pattern)
    title = matches[1]

###
    get follower count
###
exports.getFollowerCount = (node)->
    text = node.text().trim().replace(/(\r\n|\n|\r)/gm, ' ')
    console.log text
    pattern = /.*(\d+).*人关注/i
    matches = pattern.exec(text)
    console.log matches
    followerCount = parseInt(matches[1], 10)


###
    get author info
###
exports.getAuthor = (info)->
    arr = info.split("，")
    return {
    name: arr[0]
    about: arr[1] or ""
    }
