<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.Book" %>
<%@ page import="service.BookService" %>
<%@ page import="service.impl.BookServiceImpl" %>
<%@ page import="service.impl.UserServiceImpl" %>
<%@ page import="service.UserService" %>
<%
    BookService bookService = new BookServiceImpl();
    UserService userService = new UserServiceImpl();
    String keywords = request.getParameter("keywords");
    String searchType = request.getParameter("search_type");
%>
<%--
  Created by IntelliJ IDEA.
  User: Radiance
  Date: 4/11/18
  Time: 3:15 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="header.jsp" %>
    <title><%=request.getParameter("keywords")%> - 搜索结果 - OurBook</title>
</head>
<body>
<jsp:include page="nav.jsp"/>
<div class="container row" style="margin-top: 100px">
    <%
        if (searchType == null || searchType.equals("book")) {
            for (Book book : bookService.findByKeywords(keywords)) {
    %>
    <div style="margin: 20px auto;display: grid;grid-template-columns: 210px auto;border-radius: 2px;
    box-shadow: 0 2px 2px 0 rgba(0,0,0,0.14), 0 3px 1px -2px rgba(0,0,0,0.12), 0 1px 5px 0 rgba(0,0,0,0.2);">
        <%if (book.getCover() == null || book.getCover().equals("")) {%>
        <div style="width: 210px;height: 257px;background-color: #0D47A1">
            <h4 style="color: white;display: block;position: relative;top: 30%;text-align: center">
                <%=book.getName()%>
            </h4>
        </div>
        <%} else {%>
        <img style="width: 210px;height: 257px"
             src="<%=request.getServletContext().getRealPath(book.getCover())%>">
        <%}%>
        <div style="display: grid;grid-template-rows: 66px 40px 1px 130px">
            <h5 style="margin: 25px 0 0 25px">
                <a style="color: black" href="${pageContext.request.contextPath}/book.jsp?id=<%=book.getID()%>">
                    <%=book.getName()%>
                </a>
            </h5>
            <p style="color: gray;margin: 0 0 0 25px"><%=userService.getNickname(book.getChiefEditor())%>
            </p>
            <hr style="width: 100%;margin: 0;border-top: 1px gray"/>
            <p style="margin: 25px 0 0 25px">
                <%=book.getDescription()%>
            </p>
        </div>
    </div>
    <%
            }
        }%>
</div>
</body>
</html>
