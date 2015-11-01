## Description:
##   general reply to questions
##
## Commands:
##   hubot --?


TALK_API_SERVER = 'http://YOUR.TALK.SERVER.IP:PORT'

module.exports = (robot) ->

    robot.respond /(.*)(\?|？)$/i, (msg) ->
        #
        # 文末にクエスチョンマークをつけてメンションすると返答
        #

        console.log "fetching..."
        keyword = msg.match[1] + "？"
        console.log(keyword)
        request = msg.http(TALK_API_SERVER)
                          .query(q: keyword)
                          .get()
        request (err, res, body) ->
            if err
                message = "エラーっぽい"
            else
                console.log("done.")
                json = JSON.parse body
                console.log(json)
                message = json.output

                # 発言内容が自然に感じられるように長さを調整する
                message = cleanupConversationText message
            msg.send message



    robot.hear /(.*)/i, (msg) ->
        #
        # @のついていない普通の会話に対して、10%の確率で返答する。
        #

        respond = Math.floor(Math.random() * 10) + 1
        if respond == 10
            keyword = msg.match[1]
            if keyword.indexOf("@") == -1
                console.log "fetching..."
                console.log(keyword)
                request = msg.http(TALK_API_SERVER)
                                  .query(q: keyword)
                                  .get()
                request (err, res, body) ->
                    if err
                        message = "エラーっぽい"
                    else
                        console.log("done.")
                        json = JSON.parse body
                        message = json.output

                        # talk serverではqueryの続きが返されるので、
                        # 2文目からをhubotの発言として採用する。
                        message = getNextSentence message

                        # 発言内容が自然に感じられるように長さを調整する
                        message = cleanupConversationText message

                    msg.send message


getNextSentence = (raw_text) ->
    #
    # 句点とそれに準ずる記号までを1文として、2文目以降を返す。
    #

    period_like_characters = [
        "\\.", "!", "\\?", "。", "！", "？",
        "☆", "\\)", "）", "】", "\\n"
    ]
    slice_start = 0
    re = new RegExp(period_like_characters.join("|"), "ig");
    result = re.exec(raw_text)
    if result != null then slice_start = result.index + 1
    result = re.exec(raw_text)
    if result == null then slice_start = 0

    return raw_text.substring(slice_start)


cleanupConversationText = (raw_text) ->
    #
    # 発言は短いほうが自然に感じられるので、
    # 句点とそれに準ずる記号までを1文として最大でも2文とする。
    # 1文か2文かはランダムに選択。
    #

    period_like_characters = [
        "\\.", "!", "\\?", "。", "！", "？",
        "☆", "\\)", "）", "】"
    ]

    # 1文か2文かをランダムで選択
    period_count_max = Math.floor(Math.random() * 2)

    max_length = raw_text.length
    re = new RegExp(period_like_characters.join("|"), "ig");
    for i in [0..period_count_max]
        result = re.exec(raw_text)
        if result != null then max_length = result.index + 1

    return raw_text.substring(0, max_length)

