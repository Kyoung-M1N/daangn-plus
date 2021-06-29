const { default: axios } = require('axios');
var express = require('express');
var router = express.Router();

const urlencode = require("urlencode")
const cheerio = require('cheerio')
var cron = require('node-cron');
var TelegramBot = require('node-telegram-bot-api')

var secret = require('../secret')

// https://velog.io/@filoscoder/Node%EB%A1%9C-%EA%B0%84%EB%8B%A8%ED%95%9C-telegram-bot-%EC%83%9D%EC%84%B1%ED%95%98%EA%B8%B0
// TODO: /로 등록 시 자동응답봇 만들기
const telegramToken = secret.telegramToken
const bot = new TelegramBot(telegramToken)

const pageCount = secret.pageCount


// POST
// /api/keyword
router.post('/keyword', async (req, res, next) => {

  // Body 확인
  if(!Object.keys(req.body).includes("name") || !Object.keys(req.body).includes("telegram_id")){
    res.statusCode = 400
    res.json({
      "result" : false
    })
    return
  }

  // 변수 초기화
  global.keyword = ""
  global.telegramId = ""

  // 목록 초기화 후 다시 저장
  // global.list = await getList(req.body.name)
  global.sendArticleList = []

  global.keyword = req.body.name
  global.telegramId = req.body.telegram_id


  res.json({
    "result" : true
  })

})



// GET
// /api/search?name=""
router.get('/search', async (req, res, next) => {
  
  // Query 확인
  if(!Object.keys(req.query).includes("name")){
    res.statusCode = 400
    res.json({
      "result" : false
    })
    return;
  }
  const targetName = req.query.name
  
  global.list = await getList(targetName)
  res.json(global.list)

});





var getList = (keyword) => new Promise(async (resolve) => {

  var result = []
  var articleIndex = 0
  for(var n = 1; n <= pageCount; n++){

    const targetEncoded = urlencode(keyword);
    var resultHtml = await axios.get(`https://www.daangn.com/search/${targetEncoded}/more/flea_market?page=${n}`)
    
    var $ = cheerio.load(resultHtml.data)

    $('.flea-market-article-link').each(
      (_, el) => {
        result.push({
          "article": Number($(el).attr('href').split('/')[2]),
        })
      }
    )
  
    $('.card-photo').each(
      (index, el) => {
        result[articleIndex + index].photo = $(el).children()[0].attribs.src
      }
    )
  
    $('.article-title').each(
      (index, el) => {
        result[articleIndex + index].title = $(el).text()
      }
    )
    
  
    $('.article-region-name').each(
      (index, el) => {
        result[articleIndex + index].location = $(el).text().split('\n')[1].trim()
      }
    )
  
    $('.article-price').each(
      (index, el) => {
        result[articleIndex + index].price = $(el).text().split('\n')[1].trim()
      }
    )

    articleIndex = result.length

  }


  var getArticle = (n, number) => new Promise(async (resolve) => {
    resultHtml = await axios.get(`https://www.daangn.com/articles/${number}`)
    $ = cheerio.load(resultHtml.data)
    result[n].status = $('meta[name="product:availability"]').attr('content')
    var countsTmp = $('#article-counts').text()
    
    // 채팅, 관심, 조회
    result[n].chats = Number( countsTmp.split("채팅")[1].split('∙')[0] )
    result[n].likes = Number( countsTmp.split("관심")[1].split('∙')[0] )
    result[n].views = Number( countsTmp.split("조회")[1].split('∙')[0] )

    // 올린 시간
    result[n].time = $('#article-category').children().text().split('\n')[1].trim()

    resolve(true)
  })

  var articles = []
  for(var i = 0; i < result.length; i++){
    articles.push(getArticle(i, result[i].article))
  }
  await Promise.all(articles)

  // 중복 삭제
  for(var n = 0; n < result.length - 1; n++){
    for(var m = n+1; m < result.length; m++){
      if(result[n].article == result[m].article) {
        result.splice(n, 1)
        n--;
      }
    }
  }

  resolve(result)

});





// https://miiingo.tistory.com/180
// second minute hour day-of-month month day-of-week
cron.schedule('* * * * *', async () => {

  // 기존 키워드가 없는 경우
  if(global.keyword == ""){
    console.log("-")
  } else {
    // 등록된 키워드가 있는 경우


    var targetArticleList = []
    var result = await getList(global.keyword)
    
    for(var i of result){
      // 시간 비교
      var splited = i.time.split('끌올')
      var timeTarget = splited[splited.length-1].trim()
      var timed = 0
      if(timeTarget.includes('초')){
        timed = Number(timeTarget.split('초')[0])
      } else if(timeTarget.includes('분')){
        timed = Number(timeTarget.split('분')[0]) * 60
      } else {
        timed = 3600
      }

      if(timed < 3600)
        targetArticleList.push(i.article)
      
    }


    // 59분 이내에 등록된 경우(targetArticleList)
    // sendArticleList.length != 0 인 경우
    // 이전에 안 보낸 메시지의 경우
    //  -> telegram 메시지 발송

    if(targetArticleList.length == 0){
      console.log("대상 없음")
    }
    else if(global.sendArticleList.length == 0){
      console.log("리스트가 비어있음")
      global.sendArticleList = targetArticleList
    } else {
      var targets = targetArticleList.filter(x => !global.sendArticleList.includes(x))
      
      // 새로운 매물이 있을 경우
      if(targets.length != 0){
        console.log("새로운 매물")

        var sendArticles = []
        for(var n of targets){
          for(var m of result){
            if(m.article == n)
              sendArticles.push(m)
          }
        }


        var sendStr = `[[${global.keyword}]] 새로운 매물이 ${sendArticles.length}건 있습니다!\n\n`
        
        for(var k of sendArticles)
          sendStr += ` · ${k.title}\n   ${k.time} / ${k.price}\n   ${k.location}\n   [→ 앱에서 확인하기](https://www.daangn.com/articles/${k.article})\n\n`

        bot.sendMessage(global.telegramId, sendStr, {"parse_mode": "Markdown"})


        global.sendArticleList = targetArticleList
      } else {
        console.log("새로운 매물 없음")
      }
      
    }
    
    global.list = result

  }

});


module.exports = router;
