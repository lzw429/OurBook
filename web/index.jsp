<%@ page import="model.Book" %>
<%@ page import="model.User" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="zh-cmn-Hans">
<head>
    <%@ include file="header.jsp" %>
    <title>首页 - OurBook</title>
</head>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("/login");
    } else {
        User[] users = (User[]) request.getAttribute("user_recommend");
        Book[] books = (Book[]) request.getAttribute("book_recommend");
        String visit = (String) request.getAttribute("visit");
        if (users == null && books == null && visit == null) response.sendRedirect("/index");
%>
<body>
<%@ include file="nav.jsp" %>
<div class="container row" style="margin-top: 20px; margin-bottom: 0; width: 943px">
    <div class="card" style="padding:  1px 10px">
        <a style="display: inline-block;" href="${pageContext.request.contextPath}/home" class="grey-text"><h6><i
                class="material-icons"
        >home</i>
            我的主页</h6></a>
        <a style="display: inline-block; margin-left: 20px;" href="${pageContext.request.contextPath}/newbook.jsp"
           class="grey-text"><h6><i
                class="material-icons">mode_edit</i>创作新书</h6></a>
    </div>
</div>
<div class="container row" style="width: 943px"><!-- 页面中部 -->
    <div class="col card" style="width: 656px; display: inline;"><!--热门书籍-->
        <h5 class="center-align">热门书籍</h5>
        <%
            if (books != null) {
                for (Book book : books) {
        %>
        <div style="margin: 20px auto;display: grid;grid-template-columns: 192px auto" class="card">
            <%
                if (book.getCover() == null || book.getCover().equals("")) {
                    // 如果无封面
            %>
            <div style="width: 192px;height: 256px;background-color: #0D47A1;border-radius: 2px 0 0 2px">
                <h4 style="color: white;display: block;position: relative;top: 30%;text-align: center">
                    <%=book.getName()%>
                </h4>
            </div>
            <%} else { // 如果有封面%>
            <img style="width: 192px;height: 256px;object-fit: cover"
                 src="<%=book.getCover()%>">
            <%}%>
            <div style="display: grid;grid-template-rows: 66px 40px 1px 130px">
                <div style="margin: 25px 0 0 25px"><!--书名-->
                    <h5 style="float: left;margin: 0">
                        <a style="color: black"
                           href="${pageContext.request.contextPath}/book?id=<%=book.getID()%>"><%=book.getName()%>
                        </a>
                    </h5>
                </div>
                <div><!--作者-->
                    <a href="${pageContext.request.contextPath}/home?user=<%=book.getChiefEditor()%>"
                       style="color: gray;margin: 0 0 0 25px; display: inline-block;">
                        <%=book.getChiefEditor()%>
                    </a>
                    <p class="grey-text" style="margin: 0 25px; display: inline-block">
                        <i class="material-icons">remove_red_eye </i> <%=book.getClicks()%>
                        <i class="material-icons" style="margin-left: 10px">favorite </i> <%=book.getFavorites()%>
                    </p>
                </div>
                <hr style="width: 100%; margin: 0; border-top: 1px gray"/>
                <p style="margin: 15px 25px"><!--简介-->
                    <%=book.getDescription()%>
                </p>
            </div>
        </div>
        <%
                }
            }
        %>
    </div>

    <div class="col card" style="width: 262px; margin-left: 25px;"><!--推荐作者-->
        <h5 class="center-align">推荐作者</h5>
        <%
            if (users != null) {
                for (User user : users) {%>
        <div class="row" style="margin: 25px 5px 10px;">
            <a href="home?user=<%=user.getUsername()%>"><!--用户头像-->
                <img src="<%=user.getAvatar()%>"
                     style="width:40px;height: 40px;border-radius: 5%;            float: left;object-fit: cover;margin-right: 5px">
            </a>
            <div style="float:left;">
                <!--用户名与昵称-->
                <h6 style="margin:0;float: left">
                    <a href="home?user=<%=user.getUsername()%>">
                        <%=user.getNickname()%>
                    </a>
                </h6>
                <h6 class="grey-text" style="margin: 0 10px;float: left">@<%=user.getUsername()%>
                </h6>
                <p class="grey-text" style="margin: 22px 0 0 0">
                    <i class="material-icons">perm_identity</i> <%=user.getFollowers()%>
                </p>
            </div>
        </div>
        <%
                    }
                }
            }
        %>
    </div>
</div>
</body>
</html>