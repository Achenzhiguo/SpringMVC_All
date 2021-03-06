<%--
  Created by IntelliJ IDEA.
  User: chenzhiguo
  Date: 2022/5/8
  Time: 18:10
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <style>
        .progress{
            width: 200px;
            height: 5px;
            border: 1px solid #ccc;
            border-radius: 10px;
            margin: 10px 0px;
            overflow: hidden;
        }
        /* 初始状态设置进度条宽度为0px */
        .progress > div {
            width: 0px;
            height: 100%;
            background-color: yellowgreen;
            transition: all .3s ease;
        }

    </style>

    <script type="text/javascript" src="js/jquery.js"></script>
    <script type="text/javascript">
        $(function(){
            $("#uploadFile").click(function(){
                // 获取要上传的文件
                var photoFile =$("#photo")[0].files[0]
                if(photoFile==undefined){
                    alert("您还未选中文件")
                    return;
                }
                // 将文件装入FormData对象
                var formData =new FormData();
                formData.append("headPhoto",photoFile)
                // ajax向后台发送文件
                $.ajax({
                    type:"post",
                    data:formData,
                    url:"fileUpload.do",
                    processData:false,
                    contentType:false,
                    success:function(result) {
                        // 接收后台响应的信息
                        alert(result.message);
                        // 图片回显
                        $("#headImg").attr("src", "http://192.168.1.101:8090/upload/" + result.newFileName);
                        //将文件类型和文件名称放入form表单
                        $("#photoinput").val(result.newFileName)
                        $("#filetypeinput").val(result.filetype)
                    },
                    xhr: function() {
                        var xhr = new XMLHttpRequest();
                        //使用XMLHttpRequest.upload监听上传过程，注册progress事件，打印回调函数中的event事件
                        xhr.upload.addEventListener('progress', function (e) {
                            //loaded代表上传了多少
                            //total代表总数为多少
                            var progressRate = (e.loaded / e.total) * 100 + '%';
                            //通过设置进度条的宽度达到效果
                            $('.progress > div').css('width', progressRate);
                        })
                        return xhr;
                    }

                })
            })
        });
    </script>
</head>
<body>
<center>
    <form action="addIuser" method="get">
        <p>头像
            <br/>
            <input id="photo" type="file">
            <br/>
            <img id="headImg" style="width: 100px;height: 100px">
            <br/>
            <%--进度条--%>
        <div class="progress">
            <div></div>
        </div>
        <a id="uploadFile" href="javascript:void(0)">立即上传</a>
        </p>
        <p>账号<input type="text" name="iname"></p>
        <p>密码<input type="text" name="ipwd"></p>
        <p>昵称<input type="text" name="nickname"></p>
        <%--使用隐藏的输入框储存文件名称和文件类型--%>
        <input id="photoinput" type="hidden" name="photo">
        <input id="filetypeinput" type="hidden" name="filetype">

        <p><input type="submit" value="注册"></p>
    </form>
</center>
</body>
</html>