<%--
  Created by IntelliJ IDEA.
  User: HeYuan
  Date: 2019/9/6
  Time: 22:00
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib  uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>员工列表</title>
    <%
        request.getContextPath();
    %>
    <!--不以/开始的相对路径，找资源，以当前资源路径为基准，经常容易出问题。
    以/开始的相对路径，找资源，以服务器的路径为标准（http://loachost:3306）;需要加上项目名字
    -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- jQuery (Bootstrap 的所有 JavaScript 插件都依赖 jQuery，所以必须放在前边) -->
    <script src="https://cdn.jsdelivr.net/npm/jquery@1.12.4/dist/jquery.min.js"></script>
    <!-- 加载 Bootstrap 的所有 JavaScript 插件。你也可以根据需要只加载单个插件。 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js"></script>
</head>
<body>
  <!--搭建显示页面-->
  <div class="container">
      <!--标题-->
      <div class="row">
          <div class="col-md-12">
              <h1>SSM-CRUD</h1>
          </div>
      </div>
      <!--按钮-->
      <div class="row">
          <div class="col-md-4 col-md-offset-8">
              <button class="btn btn-primary">新增</button>
              <button class="btn btn-danger">删除</button>
          </div>
      </div>
      <!--显示表格数据-->
      <div class="row">
          <div class="col-md-12">
              <table class="table table-hover">
                  <tr>
                      <th>#</th>
                      <th>empName</th>
                      <th>gender</th>
                      <th>email</th>
                      <th>deptName</th>
                      <th>操作</th>
                  </tr>
                  <c:forEach items="${pageInfo.list}" var="emp">
                      <tr>
                          <th>${emp.empId}</th>
                          <th>${emp.empName}</th>
                          <th>${emp.gender=="M"?"男":"女"}</th>
                          <th>${emp.email}</th>
                          <th>${emp.department.deptName}</th>
                          <th>
                              <button class="btn btn-primary btn-sm">
                                  <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span> 编辑
                              </button>
                              <button class="btn btn-danger btn-sm">
                                  <span class="glyphicon glyphicon-trash " aria-hidden="true"></span>删除
                              </button>
                          </th>
                      </tr>
                  </c:forEach>


              </table>
          </div>
      </div>
      <!--显示分页信息栏-->
      <div class="row">
          <div class="col-md-6">
          当前第${pageInfo.pageNum}页,总${pageInfo.pages}页,总${pageInfo.total}条记录
          </div>
          <!--分页条-->
          <div class="col-md-6">
              <nav aria-label="Page navigation">
                  <ul class="pagination">
                      <li><a href="<% request.getContextPath();%>/emps?pn=1">首页</a></li>
                      <c:if test="${pageInfo.hasPreviousPage}">
                          <li>
                              <a href="<% request.getContextPath();%>/emps?pn=${pageInfo.pageNum-1}" aria-label="Previous">
                                  <span aria-hidden="true">&laquo;</span>
                              </a>
                          </li>
                      </c:if>

                      <c:forEach items="${pageInfo.navigatepageNums}" var="page_Num">
                          <c:if test="${page_Num==pageInfo.pageNum}">
                              <li class="active"><a href="#">${page_Num}</a></li>
                          </c:if>
                          <c:if test="${page_Num!=pageInfo.pageNum}">
                              <li><a href="<% request.getContextPath();%>/emps?pn=${page_Num}">${page_Num}</a></li>
                          </c:if>
                      </c:forEach>

                      <c:if test="${pageInfo.hasNextPage}">
                          <li>
                              <a href="<% request.getContextPath();%>/emps?pn=${pageInfo.pageNum+1}" aria-label="Next">
                                  <span aria-hidden="true">&raquo;</span>
                              </a>
                          </li>
                      </c:if>
                      <li><a href="<% request.getContextPath();%>/emps?pn=${pageInfo.pages}">末页</a></li>
                  </ul>
              </nav>
          </div>
      </div>
  </div>
</body>
</html>
