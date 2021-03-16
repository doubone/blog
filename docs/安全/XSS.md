
2. 搜索框中的脚本参数
    {
        condition:{
            params:'keyWord'
        }
    }
    类似此种传参方式不会引入xss攻击
3.富文本编辑器中的输入框
    在富文本编辑器中输入的执行脚本
    发送参数时参数会转码，
    <img style="height: 10em;" src="https://dpsvdv74uwwos.cloudfront.net/statics/img/ogimage/cross-site-scripting-xss.jpg" /">
    <p>&lt;img style="height:10em" src="https://dpsvdv74uwwos.cloudfront.net/statics/img/ogimage/cross-site-scripting-xss.jpg" &gt;</p>
    后端返回如上的数据，浏览器会识别 &lt; 成<,也就是说在浏览器的页面上看到的是

    <img style="height: 10em;" src="https://dpsvdv74uwwos.cloudfront.net/statics/img/ogimage/cross-site-scripting-xss.jpg" /">

    这样的字符串，不是存在于`element`元素中的HTML标签
上述两种情况不会发生XSS攻击
4.通过restAPi方式去注入攻击脚本
