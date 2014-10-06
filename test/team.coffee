chai = require "chai"
expect = chai.expect
chai.should()

config = require "../config.coffee"
app = require "../app.coffee"
clear = (require "mocha-mongoose")(config.TEST_DB_URI, {noClear: true})
request = (require "supertest").agent(app)

Team = require "../db/models/team.coffee"

describe "团队信息相关", ->
    before (done)->
        # Login to make tests sense.
        request.post("/members/session")
               .send({name: "admin", password: "123456"})
               .end done

    it "保存团队信息", (done)->
        teamData = {"introduction": "SB", "shortIntroduction": "DSB"}
        request.put("/team")
               .send(teamData)
               .expect(200)
               .end (err, res)->
                    res.body.result.should.equal "success"
                    Team.findOne {}, (err, team)->
                        if err then throw err
                        team.introduction.should.equal teamData.introduction
                        team.shortIntroduction.should.equal teamData.shortIntroduction
                        testAfterCreation()
        testAfterCreation = ->
            teamData = {introduction: "cao", shortIntroduction: "hehe"}
            request.put("/team")
                   .send(teamData)
                   .end (err, res)->
                        res.body.result.should.equal "success"
                        Team.findOne {}, (err, team)->
                            if err then throw err
                            team.introduction.should.equal teamData.introduction
                            team.shortIntroduction.should.equal teamData.shortIntroduction
                            done()
