<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<meta charset="UTF-8">
<!-- 文档 http://www.materialscss.com -->
<link rel="stylesheet" href="css/materialize.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
<link rel="stylesheet" href="css/myCSS.css">
<!--Import jQuery before materialize.js-->
<script type="text/javascript" src="js/jquery-3.3.1.js"></script>
<script type="text/javascript" src="js/jQueryFormPlugin-4.2.2.js"></script>
<script type="text/javascript" src="js/materialize.js"></script>
<script type="text/javascript" src="js/myJS.js"></script>
<style>
    .dropdown-content .dropdown-content {
        margin-left: 100%;
    }

    #toast-container {
        top: auto !important;
        right: auto !important;
        bottom: 20%;
        left: 50% !important;;
        transform: translate(-50%, -50%);
    }

    .dropdown-nested {
        overflow-y: visible;
    }
</style>

<script>
    function toast(msg) {
        Materialize.toast(msg, 2000, 'rounded');
    }
</script>

<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    // TODO 若本地存在cookie，实现自动登录
%>