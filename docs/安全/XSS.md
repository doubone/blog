# XSS漏洞
## 反射型
>url参数直接注入
```js
http://localhost/?from=<script>alert(111)</script>
```
## 存储型
>存储到DB后读取时注入
```js
// 留言板
留言测试<script>alert(222)</script>//留言内容
```

* HTML节点内容
```html
<div>
    #{content}
</div>

<div>
    <script>
    </script>
</div>
```
* HTML属性
```html
<img src="#{image}"/>
<img src=" 1"onerror="alert(1)" />
```
* JavaScript代码
```js
<script>
    var data = "#{data}";
    var data = "hello":alert(1)
</script>
```
* 富文本
富文本需要保留HTML
HTML有XSS攻击风险


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
