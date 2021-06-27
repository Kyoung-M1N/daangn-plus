

# API Document

## `GET` /api/search?name=""
 - 전국 단위의 당근 매물 검색
 - Response
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

## `POST` /api/keyword
 - 키워드 등록
 - Request (body)
    ```
    - "name": "매물 이름",
    - "telegram_id": 000000000,
    ```
