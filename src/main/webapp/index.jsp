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
    <%--<script src="https://cdn.jsdelivr.net/npm/jquery@1.12.4/dist/jquery.min.js"></script>--%>
    <script src="${pageContext.request.contextPath}/static/js/jquery-3.3.1.min.js"></script>
    <!-- 加载 Bootstrap 的所有 JavaScript 插件。你也可以根据需要只加载单个插件。 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js"></script>
    <script type="text/javascript">

        var totalRecord,currentNum;
        //1.页面加载完成以后，直接发送ajax请求，获取分页数据
        $(function () {

            //点击全部删除,批量删除
            $("#emp_delete_all_btn").click(function () {

                var empNames="";
                var del_idstr="";
                $.each($(".check_item:checked"),function () {
                  empNames=$(this).parents("tr").find("td:eq(2)").text()+",";
                  //组装员工ID字符串
                    del_idstr+=$(this).parents("tr").find("td:eq(1)").text()+"-";
                });
                empNames.substring(0,empNames.length-1);
                del_idstr.substring(0,del_idstr.length-1);
                if (confirm("确认删除【"+empNames+"】吗")){
                    //发送ajax请求删除
                    $.ajax({
                        url:"${pageContext.request.contextPath}/emp/"+del_idstr,
                        type:"DELETE",
                        success:function (result) {
                            alert(result.msg);
                            //回到当前页面
                            to_page(currentNum);
                            
                        }
                    })
                }
            });
            //完成全选和全不选功能
            $("#check_all").click(function () {
                //attr获取check是undefind
                //我们这些dom的属性；attr获取自定义属性得知值
                //prop修改和读取dom原生属性的值
                //alert($(this).prop("checked"));
                $(".check_item").prop("checked",$(this).prop("checked"));

            });
            //去首页
            to_page(1);

            //打开模态框事件方法1
           /* $("#emp_add_modal_btn").click(function () {
                console.log("btn1111")
                $("#empModal").modal(
                    {
                        backdrop:"static"
                    }
                );
            });
            */
           //校验表单数据
            function validate_add_form(){
                //1.拿到表单数据，使用正则表达式
               var empName = $("#empName_add_input").val();
               var regName=/(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
               if (!regName.test(empName)) {
                  // alert("用户名可以是2-5位中文或者6-16位英文和数字的组合");
                   show_validate_msg("#empName_add_input","error","用户名可以是2-5位中文或者6-16位英文和数字的组合");
                  /* $("#empName_add_input").parent().addClass("has-error");
                   $("#empName_add_input").next("span").text("用户名可以是2-5位中文或者6-16位英文和数字的组合");*/
                   return false;
               }else {
                   show_validate_msg("#empName_add_input","success","");
                  /* $("#empName_add_input").parent().addClass("has-success");
                   $("#empName_add_input").next("span").text("");*/
               };
               //2.校验邮箱
                var email=$("#email_add_input").val();
                var regEmail=/^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
                if (!regEmail.test(email)) {
                    //alert("邮箱格式不正确")
                    show_validate_msg("#email_add_input","error","邮箱格式不正确");
                   /* $("#email_add_input").parent().addClass("has-error");
                    $("#email_add_input").next("span").text("邮箱格式不正确");*/
                    return false
                }else {
                    show_validate_msg("#email_add_input","success","");
                   /* $("#email_add_input").parent().addClass("has-success");
                    $("#email_add_input").next("span").text("");*/
                }
               return true;
            }
            function show_validate_msg(ele,status,msg){
                //清楚状态
                $(ele).parent().removeClass("has-success has-error");
                $(ele).next("span").text("");
                if ("success"==status) {
                    $(ele).parent().addClass("has-success");
                    $(ele).next("span").text(msg);

                }else if ("error"==status) {
                    $(ele).parent().addClass("has-error");
                    $(ele).next("span").text(msg);

                }
            }
            //校验用户名是否可用
            $("#empName_add_input").change(function () {
                //发送ajax请求校验用户是否可用
                var empName=this.val();
                $.ajax({
                    url:"${pageContext.request.contextPath}/check",
                    data:"empName"+empName,
                    type:"post",
                    success:function (result) {
                        if (result.code==100){
                            show_validate_msg("#empName_add_input","success","用户名可用");
                            $("#emp_save_btn").attr("ajax-va","success");
                        }else {
                            show_validate_msg("#empName_add_input","error",result.extend.va_msg);
                            $("#emp_save_btn").attr("ajax-va","error");
                        }
                    }
                });
            });

            //点击保存员工
           $("#emp_save_btn").click(function () {
               //1.模态框填写的表单数据提交给服务器进行保存
               //校验表提交给服务器的数据
                if(!validate_add_form()){
                    return false;
            };
                //判断之前的ajax用户名校验是否成功
                if ($(this).attr("ajax-va")=="error") {
                    return false;
                }
               //2.发送ajax请求保存员工
            //$("#empModal form").serialize();
            $.ajax({
                   url:"${pageContext.request.contextPath}/emp",
                   type:"post",
                   data:$("#empModal form").serialize(),
                   success:function (result) {
                       //alert(result.msg);
                       if (result.code==100) {
                       //员工保存成功事件，关闭模态框
                       $("#empModal").modal('hide');
                       //跳转到最后一页
                       //发送ajax请求显示最后一页
                       to_page(totalRecord);
                   }else {
                           //显示失败信息
                           //console.log(result);
                           if (undefined!=result.extend.errorFields.email){
                               //显示邮箱错误信息
                               show_validate_msg("#email_add_input","error",result.extend.errorFields.email);

                           }
                           if (undefined!=result.extend.errorFields.empName) {
                               //显示员工错误信息
                               show_validate_msg("#empName_add_input","error",result.extend.errorFields.empName);

                           }
                       }
                   }
              });
           });

           //点击更新，更新员工信息
            $("#emp_update_btn").click(function () {
                //验证邮箱是否合法
                var email=$("#email_update_input").val();
                var regEmail=/^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
                if (!regEmail.test(email)) {
                    //alert("邮箱格式不正确")
                    show_validate_msg("#email_update_input","error","邮箱格式不正确");
                    return false
                }else {
                    show_validate_msg("#email_update_input","success","");
                }
                //发送ajax请求保存更新的数据
                $.ajax({
                    url:"${pageContext.request.contextPath}/emp/"+$(this).attr("edit-id"),
                    type:"PUT",
                    data:$("#empUpdateModal form").serialize(),
                    success:function (result) {
                        //alert(result.msg);
                        //1.关闭模态框
                       $("#empUpdateModal").modal("hide");
                        //2.回到本页面
                        to_page(currentNum);
                    }
                })
            });
        });

        /*$(function()*/
        function to_page(pn) {
            $.ajax({
                url:"${pageContext.request.contextPath}/emps",
                data:"pn="+pn,
                type:"get",
                cache:false,
                success:function (result) {
                     //console.log(result);

                    //1.解析并显示员工数据
                    build_emps_table(result);
                    //2.解析并显示分页信息
                    build_page_info(result);
                    //3.分页条信息
                    build_page_nav(result)
                }
            });
        };
        function build_emps_table(result) {
            //情况table数据
            $("#emps_table tbody").empty();
            var emps=result.extend.pageInfo.list;
            $.each(emps,function (index,item) {
                //alert(item.empName);
                var  checkBoxId=$("<td><input type='checkbox' class='check_item'/></td>");
                var  empIdTd=$("<td></td>").append(item.empId);
                var  empNameTd=$("<td></td>").append(item.empName);
                var  genderTd=$("<td></td>").append(item.gender=="M"?"男":"女");
                var  emailTd=$("<td></td>").append(item.email);
                var  deptNameTd=$("<td></td>").append(item.department.deptName);
                var  editBtn=$("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
                    .append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
                //为编辑按钮添加一个自定义的属性，表示当前员工的id
                editBtn.attr("edit-id",item.empId);
                var  delBtn=$("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
                    .append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
                delBtn.attr("del-id",item.empId);
                var Btn= $("<td></td>").append(editBtn).append("  ").append(delBtn);
                //append方法执行完成后还是返回原来的元素
                $("<tr></tr>").append(checkBoxId)
                    .append( empIdTd)
                    .append(empNameTd)
                    .append(genderTd)
                    .append(emailTd)
                    .append(deptNameTd)
                    .append(Btn)
                    .appendTo("#emps_table tbody");

            })
            
        }
        //解析显示分页信息
        function build_page_info(result) {
            $("#page_info_area").empty();
            $("#page_info_area").append("当前"+result.extend.pageInfo.pageNum+"页",
                   "总"+result.extend.pageInfo.pages+"页",
                   "总"+result.extend.pageInfo.total+"条记录")
            totalRecord=result.extend.pageInfo.total;
            currentNum=result.extend.pageInfo.pageNum;

        }

        //解析显示分页条
        function build_page_nav(result) {
            $("#build_nav_area").empty();
            //build_page_nav
            var ul = $("<ul></ul>").addClass("pagination");

            var firstPageLi = $("<li></li>").append($("<a/>").append("首页").attr("href", "#"));
            var prePageLi = $("<li></li>").append($("<a/>").append("&laquo;"));
            if (result.extend.pageInfo.hasPreviousPage == false) {
                firstPageLi.addClass("disabled");
                prePageLi.addClass("disabled");
            }
            else {
                firstPageLi.click(function () {
                    to_page(1);
                });
                prePageLi.click(function () {
                    to_page(result.extend.pageInfo.pageNum-1);
                });
            }


            var nextPageLi=$("<li></li>").append($("<a/>").append("&raquo;"));
            var lastPageLi=$("<li></li>").append($("<a/>").append("尾页").attr("href","#"));
            if (result.extend.pageInfo.hasNextPage==false){
               nextPageLi.addClass("disabled");
               lastPageLi.addClass("disabled");
           }
           else {
                nextPageLi.click(function () {
                    to_page(result.extend.pageInfo.pageNum+1);
                });
                lastPageLi.click(function () {
                    to_page(result.extend.pageInfo.pages);
                });
            }


            ul.append(firstPageLi).append(prePageLi);
            //页码号,遍历添加页码提示
            $.each(result.extend.pageInfo.navigatepageNums,function (index,item) {
                var numLi=$("<li></li>").append($("<a/>").append(item));
                if (result.extend.pageInfo.pageNum==item) {
                    numLi.addClass("active");
                }
                numLi.click(function () {
                    to_page(item);
                });
                ul.append(numLi);
            });
            //添加下一页和末页的提示
            ul.append(nextPageLi).append(lastPageLi);
            //ul加入nav中
            var navEle=$("<nav></nav>").append(ul);
            navEle.appendTo("#build_nav_area");
        }

         function rest_from(ele) {
            $(ele)[0].reset();
            //清空表单样式
         $(ele).find("*").removeClass("has-error has-success");
         $(ele).find(".help-block").text("");

       }
        //打开模态框事件方法2
        function emp_modal_show() {
            //清楚表单数据（表单重置)
            rest_from("#empModal form")
           // $("#empModal form")[0].reset();
            //发视ajax请求，获取部门信息显示在下拉列表
            getDepts("#dept_add_select");
            //"extend":{"depts":[{"deptId":1,"deptName":"开发部"},{"deptId":2,"deptName":"测试部"}]}}
            //弹出模态框
            $("#empModal").modal({
                    backdrop:"static"
                });
            
        }
        //查出所有部门信息显示在下拉列表
        function getDepts(ele) {
            $(ele).empty();
            $.ajax({
                url:"${pageContext.request.contextPath}/depts",
                type:"get",
                success:function (result) {
                   // console.log(result)
                    $.each(result.extend.depts,function () {
                        var optinoEle =$("<option></option>").append(this.deptName).attr("value",this.deptId)
                         optinoEle.appendTo(ele);
                    });
                }
            });
        }

        //按钮创建之前就绑定了click,所以绑定不上
        //使用on进行替代
        $(document).on("click",".edit_btn",function () {

            //1.查出部门信息,并显示
            getDepts("#dept_update_select");
            //查出员工信息，并显示
            getEmp($(this).attr("edit-id"));

            //把员工的Id传递给模态框的更新按钮
            $("#emp_update_btn").attr("edit-id",$(this).attr("edit-id"));
            $("#empUpdateModal").modal({
                backdrop:"static"
            });

        });
        function getEmp(id) {
            $.ajax({
                url:"${pageContext.request.contextPath}/emp/"+id,
                type:"Get",
                success:function (result) {
                    var empDate=result.extend.emp;
                    $("#empName_update_static").text(empDate.empName);
                    $("#email_update_input").val(empDate.email);
                    $("#empUpdateModal input[name=gender]").val([empDate.gender]);
                    $("#empUpdateModal select").val([empDate.dId]);
                }
            });
        }
        //单个删除
        $(document).on("click",".delete_btn",function (){
          //弹出是否确认删除对话框
            var empName= $(this).parents("tr").find("td:eq(2)").text();
            var empId=$(this).attr("del-id");
            if (confirm("确认删除【"+empName+"】吗？")){
            $.ajax({
                url:"${pageContext.request.contextPath}/emp/"+empId,
                type:"DELETE",
                success:function (result) {
                    alert(result.msg);
                    //回到本页
                    to_page(currentNum);
                }
            })
        }
        });
        //check_item
        $(document).on("click",".check_item",function () {
           //判断当前选中的元素是否5个
           var flag=$(".check_item:checked").length==$(".check_item");
           $("#check_all").prop("checked",flag);

        });

    </script>
</head>
<body>
<!-- 员工修改 -->
<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" >员工修改</h4>
            </div>
            <div class="modal-body">
                <!--表单-->
                <form class="form-horizontal">
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                           <p class="form-control-static" id="empName_update_static"></p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_update_input" placeholder="email@hy.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_update_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_update_input" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <!--部门提交-->
                            <select class="form-control" name="dId" id="dept_update_select">
                            </select>

                        </div>
                    </div>
                </form>


            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
            </div>
        </div>
    </div>
</div>

<!--员工添加模态框-->
<!-- Modal -->
<div class="modal fade" id="empModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">员工添加</h4>
            </div>
            <div class="modal-body">
                <!--表单-->
                <form class="form-horizontal">
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="empName">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_add_input" placeholder="email@hy.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <!--部门提交-->
                            <select class="form-control" name="dId" id="dept_add_select">
                            </select>

                        </div>
                    </div>
                </form>


            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
            </div>
        </div>
    </div>
</div>

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
            <button class="btn btn-primary"  onclick="emp_modal_show()" >新增</button>
            <button class="btn btn-danger" id="emp_delete_all_btn">删除</button>
        </div>
    </div>
    <!--显示表格数据-->
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id="emps_table">
                <thead>
                <tr>
                    <th>
                        <input type="checkbox" id="check_all"/>
                    </th>
                    <th>#</th>
                    <th>empName</th>
                    <th>gender</th>
                    <th>email</th>
                    <th>deptName</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
    </div>
    <!--显示分页信息栏-->
    <div class="row">
        <div class="col-md-6" id="page_info_area"></div>
        <!--分页条-->
        <div class="col-md-6" id="build_nav_area">

        </div>
    </div>
</div>

</body>
</html>
