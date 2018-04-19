<%@ page import="model.Book" %>
<%@ page import="model.User" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <%@ include file="header.jsp" %>
    <%
        Book[] books = (Book[]) request.getAttribute("books");
        User[] followees = (User[]) request.getAttribute("followees");
    %>
    <title>个人主页 - OurBook</title>
</head>

<body>
<%@ include file="nav.jsp" %>
<div class="container">
    <div class="row">
        <h4 id="homepage_username"></h4><!--用户的用户名与昵称-->
        <h6 id="homepage_userDescription"></h6><!--用户的一句话描述-->
        <a class="modal-trigger" data-target="personalInfo" style="display: inline;"><i
                class="material-icons">settings</i></a>
        <!--TODO 修改个人信息 模态框 的后端逻辑-->
        <div id="personalInfo" class="modal"> <!--修改个人信息 模态框-->
            <div class="modal-content">
                <h4>修改个人信息</h4>
                <label for="new_nickname">昵称</label>
                <input type="text" name="new_nickname" id="new_nickname"/>
                <label for="new_description">一句话简介</label>
                <input type="text" name="new_description" id="new_description"/>
            </div>
            <div class="modal-footer">
                <button class="modal-action modal-close waves-effect waves-green btn-flat">取消
                </button>
                <button class="modal-action modal-close waves-effect waves-green btn-flat" id="submit_personal_info">
                    提交
                </button>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col s6"> <!--文章、书目或动态-->
            <h5 style=" margin-right: 30px; text-align: center">我写的书</h5>
            <div> <!-- 我写的书 目录-->
                <%
                    if (books.length == 0) {%>
                <h6 class="grey-text" style="text-align: center; margin-top: 100px"> 你还没有写书 </h6>
                <%
                    }
                    for (Book book : books) {
                %>
                <div style="margin: 20px auto;display: grid;grid-template-columns: 105px auto;border-radius: 2px;width: 100%;
    box-shadow: 0 2px 2px 0 rgba(0,0,0,0.14), 0 3px 1px -2px rgba(0,0,0,0.12), 0 1px 5px 0 rgba(0,0,0,0.2);">
                    <%if (book.getCover() == null || book.getCover().equals("")) {%>
                    <a href="${pageContext.request.contextPath}/book.jsp?id=<%=book.getID()%>"
                       style="border-radius: 2px 0 0 2px">
                        <div style="width: 105px;height: 128px;background-color: #0D47A1; border-radius: 2px 0 0 2px">
                            <h4 style="color: white;display: block;position: relative;top: 30%;text-align: center">
                                <%=book.getName()%>
                            </h4>
                        </div>
                    </a>
                    <%} else {%>
                    <a href="${pageContext.request.contextPath}/book.jsp?id=<%=book.getID()%>">
                        <img style="width: 105px;height: 128px;border-radius: 2px 0 0 2px"
                             src="<%=book.getCover()%>">
                    </a>
                    <%}%>
                    <div style="display: grid;grid-template-rows: 40px 21px 1px 67px">
                        <h6 style="margin: 12px 0 0 12px">
                            <a style="color: black"
                               href="${pageContext.request.contextPath}/book.jsp?id=<%=book.getID()%>">
                                <%=book.getName()%>
                            </a>
                        </h6>
                        <hr style="width: 100%;margin: 0;border-top: 1px gray"/>
                    </div>
                </div>
                <%}%>
            </div>
        </div>

        <div class="col s2">
            <!--不要随便删除它，除非需要改变排版-->
        </div>

        <div class="col s3"> <!--关注列表-->
            <h5 style="text-align: center">我的关注</h5>
            <% if (followees.length == 0) {%>
            <h6 style="text-align: center">你还没有关注任何人</h6>
            <%
                }
                for (User user : followees) {
            %>
            <div style="margin: auto">
                <a href="home?user=<%=user.getUsername()%>"><%=user.getNickname()%>
                </a>
            </div>
            <%}%>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        // 通过 cookie 修改 username_display
        var nickname = getCookie('nickname');
        var username = getCookie('username');
        if (nickname !== "" && username !== "")
            document.getElementById("homepage_username").innerText = nickname + " (" + username + ")";

        // 模态框
        $(document).ready(function () {
            $('.modal').modal();
        });
    });
</script>
</body>
</html>
