should = require("should")
util = require("../lib/util")

describe "util test download page", ()->
    it "should download page", (done)->
        url = "http://www.zhihu.com/question/23797702"
        util.download url, (err, content)->
            should(err).not.exist
            content.should.be.a.String.and.not.be.empty
            done()
    it "should response error", (done)->
        url = "http://zhuanlan.zhihu.com/sulian/19747989"
        util.download url, (err)->
            should(err).exist
            done()
