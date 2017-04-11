<script>
var blog=document.getElementById('blog');
blog.onclick=function(){
    window.webkit.messageHandlers.AppModel.postMessage({body:'系统提示'})
};
var header = document.getElementById('header');
header.onclick=function(){
    window.webkit.messageHandlers.AppModel.postMessage({header:'系统提示'})
};
</script>


