<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8" />
        <title>Home</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/app/css/styles.css" />
    </head>
    <body>
        <div class="container">
            <div id="wrapper">
                <h1 id="title">Hello world!</h1>
                <p>The time on the server is ${serverTime}.</p>
            </div>
            <jsp:include page="../layout/footer.jsp" />
        </div>
    </body>
</html>
