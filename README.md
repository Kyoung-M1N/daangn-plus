# 당근 플러스
당근 마켓의 전국 매물 검색

## Environment
 - Front-end
   - Flutter (Application)
 - Back-end
   - Node.js, Express.js
   - osa-imessage


## Context
 - json 타입으로 전국의 매물을 respond
 - 프론트 페이지에서 이를 분석하여 보여줌
 - 서버에서 1분마다 검색어를 크롤링하여 새로운 정보가 있을 시, telegram 으로 알림 발송
 - Database
    - 일단 나 혼자 쓸 목적이므로, 별도의 데이터베이스 연동 X
    - json 파일을 변수에 저장해두었다가 변경점을 그때그때 분석


## 시나리오
 1. `https://www.daangn.com/search/[검색어 한글 유니코드]/more/flea_market?page=[페이지 번호]` 를 통해서 원하는 매물 검색 (페이지 번호: 1~10까지)
    1. `.flea-market-article-link` -> href에서 article 번호 추출
    2. `.card-photo` -> img 태그에서 사진 링크 추출
    3. `.article-title` -> 제목 정보 추출
    4. `.article-region-name` -> 지역 정보 추출
    5. `.article-price` -> 가격 정보 추출
 2. 1-1번에서 추출한 매물번호 -> `https://www.daangn.com/articles/[매물번호]`
    1. `#article-counts` -> 채팅, 관심, 조회 추출
    2. `meta name="product:availability"` -> 현재 상태 추출
 3. json으로 정리
    ```json
    {
      "result" : [
        {
          "title": "link",
          "article" : 000000,
          "photo" : "link",
          "location" : "location",
          "price" : "400,000원",
          "status" : "instock",
          "time" : "1시간 전",
          "likes" : 0,
          "views" : 0,
          "chats" : 0,
        },
        ...
      ]
    }
    ```