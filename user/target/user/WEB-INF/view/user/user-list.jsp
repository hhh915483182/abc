
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <jsp:include page="../common/static.jsp" />
    <script>

        //用于存放新增用户DIV的HTML代码的全局变量
        var addUserDivHTML;
        //用于存放修改用户DIV的HTML代码的全局变量
        var updateUserDivHTML;


        $(function(){
            addUserDivHTML = $("#addUserDiv").html();

            updateUserDivHTML = $("#updateUserDiv").html();


            //初始化查询条件面板中的注册时间
            initDateTimePicker("#minRegisterTime");
            initDateTimePicker("#maxRegisterTime");
            //初始化查询条件面板中地区下拉框
            initAreaSelect();
            //初始化用户表格
            initUserTable();

        });

        function search(){
            userTable.ajax.reload();
        }

        function initDateTimePicker(selector,abc){
            abc = abc == undefined ? "YYYY-MM-DD HH:mm:ss" : abc;
            $(selector).datetimepicker({
                format:abc,
                locale:"zh-CN",
                showClear:true
            });
        }


        //用于存放所有地区的数组
        var areaArr;
        function initAreaSelect(){
            $.ajax({
                url:"<%=request.getContextPath()%>/UserController/queryAreaList.do",
                dataType:"json",
                success:function(result){
                    if(result.code == 200){
                        areaArr = result.data;
                        var optionsHTML = "";
                        for(var i = 0 ; i < result.data.length ; i ++ ){
                            optionsHTML += "<option value='" + result.data[i].areaId + "'>" + result.data[i].areaName + "</option>";
                        }
                        $("#areaId").append(optionsHTML);
                    }else{
                        alert("查询所有地区失败!");
                    }
                },
                error:function(){
                    alert("查询所有地区失败!");
                }
            });
        }


        var userTable;
        function initUserTable(){
            userTable = $("#userTable").DataTable({
                searching:false,
                ordering:false,
                serverSide:true, //开启服务端模式
                lengthMenu:[3,5,10,15],
                processing:true,//是否显示正在处理中
                language:chinese,
                ajax:{
                    url:"<%=request.getContextPath()%>/UserController/queryUserList.do",
                    data:function(param){
                        //DataTables在发送ajax请求的时候会发送一些自己的参数，比如说每页显示条数，起始条数等等。。。
                        //通过param这个参数咱们可以设置自己需要传递的参数，比如说条件查询的值
                        param.userName = $("#userName").val();
                        param.minRegisterTime = $("#minRegisterTime").val();
                        param.maxRegisterTime = $("#maxRegisterTime").val();
                        param.sex = $("[name=sex]:checked").val();

                    }
                },
                columns:[
                    {
                        data:"id",
                        render:function(data){
                            return "<input type='checkbox' name='id' value='"+data+"'/>";
                        }
                    },
                    {data:"userName"},
                    {data:"password"},
                    {
                        data:"sex",
                        render:function(data){
                            return data==1?"男":"女";
                        }
                    },
                    {data:"areaName"},

                    {
                        data:"registerTime",
                        render:function(data){
                            return datetimeFormat_2(data);
                        }
                    },
                    {
                        data:"id",
                        render:function(data){
                            return '<div class="btn-group btn-group-xs">'+
                                '<button type="button" onclick="showUpdateUserDialog(' + data + ')" class="btn btn-primary">'+
                                '<span class="glyphicon glyphicon-pencil"></span>&nbsp;修改'+
                                '</button>'+
                                '<button type="button" onclick="deleteUser(' + data + ')" class="btn btn-danger">'+
                                '<span class="glyphicon glyphicon-trash"></span>&nbsp;删除'+
                                '</button>'+
                                '</div>';
                        }}
                ]
            });
        }

        //Dialog是对话框的意思
        function showAddUserDialog(){
            abc();
            //初始化新增用户表单中地区下拉框
            var areaOptionsHTML = "";
            for(var i = 0 ; i < areaArr.length ; i ++ ){
                areaOptionsHTML += "<option value='" + areaArr[i].areaId + "'>" + areaArr[i].areaName + "</option>";
            }
            $("#addArea").append(areaOptionsHTML);
            //初始化新增用户表单中的注册时间
            initDateTimePicker("#addRegisterTime");

            //使用bootbox弹框插件弹出新增用户的对话框
            bootbox.confirm({
                title:"新增用户",
                message:$("#addUserDiv").children(),
                buttons:{
                    confirm:{
                        label:"确认"
                    },
                    cancel:{
                        label:"取消",
                        className:"btn btn-danger"
                    }
                },
                callback:function(result){
                    //如果点击了确认按钮
                    if(result){
                        var param = {};
                        //获取新增用户表单中的数据
                        param.userName = $("#addUserName").val();
                        param.password = $("#addPassword").val();
                        param.sex = $("[name=addSex]:checked").val();
                        param.registerTime = $("#addRegisterTime").val();
                        var userSelectArr = $("#addAreaDiv [name=def]");
                        param.areaId = userSelectArr.eq(1).val();
                        alert(userSelectArr.eq(1).val());
                        //发起一个新增用户的ajax请求
                        $.ajax({
                            url:"<%=request.getContextPath()%>/UserController/addUser.do",
                            type:"post",
                            data:param,
                            dataType:"json",
                            success:function(result){
                                if(result.code == 200){
                                    search();
                                }else{
                                    alert("新增用户失败!");
                                }
                            },
                            error:function(){
                                alert("新增用户失败!");
                            }
                        });
                    }
                    $("#addUserDiv").html(addUserDivHTML);

                }
            });
        }

        function deleteUser(id){
            //弹出一个确认框
            bootbox.confirm({
                title:"删除提示",
                message:"您确定要删除吗?",
                buttons:{
                    //設置確定按鈕的文字和樣式
                    confirm:{
                        label:"確認",
                        className:"btn btn-success"
                    },
                    //設置取消按鈕的文字和樣式
                    cancel:{
                        label:"取消",
                        className:"btn btn-danger"
                    }
                },
                callback:function(result){
                    //如果用户点击了确认按钮
                    if(result){
                        //发起一个删除服装的ajax请求
                        $.ajax({
                            url:"<%=request.getContextPath()%>/UserController/deleteUser.do",
                            type:"post",
                            data:{id:id},
                            dataType:"json",
                            success:function(result){
                                if(result.code == 200){
                                    //重新加载表格中的数据
                                    search();
                                }else{
                                    alert("删除用户失败!");
                                }
                            },
                            error:function(){
                                alert("删除用户失败!");
                            }
                        });
                    }
                }
            });
        }

        function batchDeleteUser(){
            var idCheckboxes = $("[name=id]:checked");
            if(idCheckboxes.length > 0){
                //弹出一个确认框
                bootbox.confirm({
                    title:"删除提示",
                    message:"您确定要删除吗?",
                    buttons:{
                        //設置確定按鈕的文字和樣式
                        confirm:{
                            label:"確認",
                            className:"btn btn-success"
                        },
                        //設置取消按鈕的文字和樣式
                        cancel:{
                            label:"取消",
                            className:"btn btn-danger"
                        }
                    },
                    callback:function(result){
                        if(result){
                            var idArr = [];
                            idCheckboxes.each(function(){
                                idArr.push(this.value);
                            });

                            //发起一个批量删除用户的ajax请求
                            $.ajax({
                                url:"<%=request.getContextPath()%>/UserController/batchDeleteUser.do",
                                type:"post",
                                data:{ids:idArr},
                                dataType:"json",
                                success:function(result){
                                    if(result.code == 200){
                                        //重新加载表格中的数据
                                        search();
                                    }else{
                                        alert("批量删除用户失败!");
                                    }
                                },
                                error:function(){
                                    alert("批量删除用户失败!");
                                }
                            });
                        }
                    }
                });

            }else{
                alert("请先选择要删除的用户!");
            }
        }

        function showUpdateUserDialog(id){
            alert(id);
            //发起一个通过id查询单个用户信息的ajax请求
            $.ajax({
                url:"<%=request.getContextPath()%>/UserController/getUserById.do",
                data:{id:id},
                dataType:"json",
                success:function(result){
                    if(result.code == 200){
                        //初始化修改用户表单中地区下拉框
                        var areaOptionsHTML = "";
                        for(var i = 0 ; i < areaArr.length ; i ++ ){
                            areaOptionsHTML += "<option value='" + areaArr[i].areaId + "'>" + areaArr[i].areaName + "</option>";
                        }
                        $("#updateArea").append(areaOptionsHTML);


                        //初始化修改用户表单中的过期时间
                        initDateTimePicker("#updateRegisterTime","YYYY-MM-DD");

                        var user = result.data;

                        //回显修改用户表单中的数据了
                        $("#updateUserName").val(user.userName);
                        $("#updatePassword").val(user.password);
                        $("[name=updateSex][value=" + user.sex + "]").prop("checked",true);
                        $("#updateRegisterTime").val(datetimeFormat_2(user.registerTime));
                        initUserSelect(1,user.areaPid);
                        initUserSelect(user.areaPid,user.areaId);

                        //弹出修改用户对话框
                        bootbox.confirm({
                            title:"修改用户",
                            message:$("#updateUserDiv").children(),
                            buttons:{
                                //設置確定按鈕的文字和樣式
                                confirm:{
                                    label:"確認",
                                    className:"btn btn-success"
                                },
                                //設置取消按鈕的文字和樣式
                                cancel:{
                                    label:"取消",
                                    className:"btn btn-danger"
                                }
                            },
                            callback:function(result){
                                if(result){
                                    var param = {};
                                    //获取修改用户表单中的数据
                                    param.id = user.id;
                                    param.userName = $("#updateUserName").val();
                                    param.password = $("#updatePassword").val();
                                    param.sex = $("[name=sex]:checked").val();
                                    param.registerTime = $("#updateRegisterTime").val();
                                    var userSelectArr = $("#updateAreaDiv [name=def]");
                                    param.areaId = userSelectArr.eq(1).val();
                                    //发起一个修改用户的ajax请求
                                    $.ajax({
                                        url:"<%=request.getContextPath()%>/UserController/updateUser.do",
                                        type:"post",
                                        data:param,
                                        dataType:"json",
                                        success:function(result){
                                            if(result.code == 200){
                                                //重新加载表格中的数据
                                                search();
                                            }else{
                                                alert("修改用户失败!");
                                            }
                                        },
                                        error:function(){
                                            alert("修改用户失败!");
                                        }
                                    });
                                }
                                $("#updateUserDiv").html(updateUserDivHTML);
                            }
                        });

                    }else{
                        alert("查询用户失败!");
                    }
                },
                error:function(){
                }
            });
        }
        function abc(obj){
            if(obj){
                $(obj).parent().nextAll().remove();
                var level = $(obj).parent().prevAll().length + 1;
            }
            var pid = obj == undefined ? 1 : obj.value;
            $.ajax({
                url:"<%=request.getContextPath()%>/UserController/queryAreaListByPid.do",
                type:"get",
                data:{pid:pid},
                dataType:"json",
                success:function(result){
                    if(result.data.length < 1){
                        return;
                    }
                    if(result.code == 200){
                        var userSelectHTML = "<div class='col-sm-4'><select onchange='abc(this)' name='def' style='width:100px' class='form-control'><option value='-1'>请选择</option>";
                        for(var i = 0 ; i < result.data.length ; i ++ ){
                            userSelectHTML += "<option value='" + result.data[i].areaId + "'>" + result.data[i].areaName + "</option>"
                        }
                        userSelectHTML += "</select></div>";
                        $("#updateAreaDiv").append(userSelectHTML);
                        $("#addAreaDiv").append(userSelectHTML);
                    }else{
                        alert("查询地区失败!");
                    }
                },
                error:function(){
                    alert("查询地区失败!");
                }
            });
        }

        function initUserSelect(pid,selectedId){
            $.ajax({
                url:"<%=request.getContextPath()%>/UserController/queryAreaListByPid.do",
                type:"get",
                data:{pid:pid},
                async:false,
                dataType:"json",
                success:function(result){
                    if(result.data.length < 1){
                        return;
                    }
                    if(result.code == 200){
                        var userSelectHTML = "<div class='col-sm-4'><select onchange='abc(this)' name='def' style='width:100px' class='form-control'><option value='-1'>请选择</option>";
                        for(var i = 0 ; i < result.data.length ; i ++ ){
                            userSelectHTML += "<option " + (selectedId == result.data[i].areaId ? "selected" : "") + " value='" + result.data[i].areaId + "'>" + result.data[i].areaName + "</option>"
                        }
                        userSelectHTML += "</select></div>";
                        $("#updateAreaDiv").append(userSelectHTML);
                        $("#addAreaDiv").append(userSelectHTML);
                    }else{
                        alert("查询地区失败!");
                    }
                },
                error:function(){
                    alert("查询地区失败!");
                }
            });
        }
    </script>
</head>
<body>
<!--修改用户的DIV-->
<div id="updateUserDiv" style="display: none">
    <!--修改用户的form表单-->
    <form id="updateUserForm" class="form-horizontal">
        <div class="form-group">
            <label class="col-sm-2 control-label">用户名称</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" id="updateUserName" placeholder="请输⼊用户名称">
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">用户密码</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" id="updatePassword" placeholder="请输⼊用户密码">
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">性别</label>
            <div class="col-sm-10">
                <label class="radio-inline">
                    <input type="radio" name="updateSex" value="1"> 男
                </label>
                <label class="radio-inline">
                    <input type="radio" name="updateSex" value="2"> 女
                </label>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">地区分类</label>
            <div class="col-sm-10" id="updateAreaDiv">
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">注册时间</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" id="updateRegisterTime">
            </div>
        </div>
    </form>
</div>

<!--新增用户的DIV-->
<div id="addUserDiv" style="display: none">
    <form id="addUserForm" class="form-horizontal">
        <div class="form-group">
            <label class="col-sm-2 control-label">用户名称</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" id="addUserName" placeholder="请输⼊用户名称">
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">密码</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" id="addPassword" placeholder="请输⼊用户密码">
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">性别</label>
            <div class="col-sm-10">
                <label class="radio-inline">
                    <input type="radio" name="addSex" value="1"> 男
                </label>
                <label class="radio-inline">
                    <input type="radio" name="addSex" value="2"> 女
                </label>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">地区分类</label>
            <div class="col-sm-10" id="addAreaDiv">
            </div>
        </div>

        <div class="form-group">
            <label class="col-sm-2 control-label">注册时间</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" id="addRegisterTime" placeholder="请输⼊注册时间">
            </div>
        </div>
    </form>
</div>

<!-- 引入导航栏 -->
<jsp:include page="../common/nav.jsp" />

<!-- 查询条件面板 -->
<div class="panel panel-primary">
    <div class="panel-heading">
        <h3 class="panel-title">
            查询条件
        </h3>
    </div>
    <div class="panel-body">
        <form class="form-horizontal" role="form">
            <div class="container">
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="col-sm-2 control-label">用户名称:</label>
                            <div class="col-sm-10">
                                <input type="text" class="form-control" id="userName" placeholder="请输⼊用户名称">
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="col-sm-2 control-label">性别:</label>
                            <div class="col-sm-10">
                                <label class="radio-inline">
                                    <input type="radio" name="sex" value="1"> 男
                                </label>
                                <label class="radio-inline">
                                    <input type="radio" name="sex" value="2"> 女
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="col-sm-2 control-label">注册时间:</label>
                            <div class="col-sm-10">
                                <div class="input-group">
                                    <input type="text" id="minRegisterTime" class="form-control" placeholder="请输⼊开始注册时间">
                                    <span class="input-group-addon">--</span>
                                    <input type="text" id="maxRegisterTime" class="form-control" placeholder="请输⼊结束注册时间  ">
                                </div>
                            </div>
                        </div>
                </div>
                </div>
                <div class="row">
                    <div class="col-md-12" style="text-align:center">
                        <button type="button" class="btn btn-primary" onclick="search()">
                            <span class="glyphicon glyphicon-search"></span>&nbsp;查询
                        </button>
                        &nbsp;&nbsp;&nbsp;&nbsp;
                        <button type="reset" class="btn btn-danger">
                            <span class="glyphicon glyphicon-refresh"></span>&nbsp;重置
                        </button>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>

<!--用户列表面板 -->
<div class="panel panel-primary">
    <div class="panel-heading">
        <h3 class="panel-title">
            用户列表
        </h3>
    </div>
    <div class="panel-body">
        <div style="margin-bottom:10px">
            <button onclick="showAddUserDialog()" type="button" class="btn btn-primary">
                <span class="glyphicon glyphicon-plus"></span>&nbsp;新增
            </button>
            &nbsp;&nbsp;&nbsp;&nbsp;
            <button onclick="batchDeleteUser()" type="reset" class="btn btn-danger">
                <span class="glyphicon glyphicon-minus"></span>&nbsp;批量删除
            </button>
        </div>

        <table id="userTable" class="table table-striped table-bordered table-hover table-condensed">
            <thead>
            <tr>
                <th>
                    <input type="checkbox" />
                </th>
                <th>用户名称</th>
                <th>密码</th>
                <th>性别</th>
                <th>地区</th>
                <th>注册时间</th>
                <th>操作</th>
            </tr>
            </thead>
        </table>
    </div>
</div>
</body>
</html>
