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


## 处理方法
整体思路：转义[HTML实体](https://www.w3school.com.cn/html/html_entities.asp)

* HTML节点内容  
处理思路：转义`<``>`,使之不能以`html`标签的形式保存或者返回给前端
1. 存入数据库时转义
2. 返回给前端时转义
我们更倾向于第二种：返回给前端时转义  
```js
//转义函数
var escapeHtml = function(str){
    str = str.replace(/</g,'&lt;');
    str = str.replace(/>/g,'&gt;')
    return str
}
```
```js
// 转义前
<script>alert(111)</script>
// 转移后
&lt;script&gt;alert(111)&lt;/script&gt;
// 页面dom呈现
<script>alert(111)</script>//字符串类型
||
<span><script>alert(111)</script></span>
```

* HTML属性  
处理思路：转义`"`引号  
```js
// 转义函数
var escapeHtmlProperty = function(str){
    if(!str)return '';
    str = str.replace(/"/g,'&quto;');//替换双引号
    str = str.replace(/'/g,'&#39;');//替换单引号
    str = str.replace(/ /g,'&#32;');//替换空格
    return str;
}
```
```js
// 转义前
<img src=" 1"onerror="alert(1)" />
// 转义后
<img src="1&quto; onerror=&quto;alert(1)" />
// 页面dom呈现
<img src="1&quto; onerror=&quto;alert(1)" />
```
问题来了，转义了`HTML`属性中的`<``>`号，会对元素产生影响吗？转义了`HTML`节点内容中的`"``'`` `尼？  
答案是不会产生影响的，读者可以自行验证。  
此时可以合并上面的两个函数，整体处理`HTML`节点和属性,合并函数如下：  
```js
var escapeHtml = function(str){
    str = str.replace(/&/g,'&amp;');//&符号也需要转义，但是一定放在第一个转
    str = str.replace(/</g,'&lt;');
    str = str.replace(/>/g,'&gt;')
    str = str.replace(/"/g,'&quto;');//替换双引号
    str = str.replace(/'/g,'&#39;');//替换单引号
    // 空格的转义影响其实并不大，可以省略
    // str = str.replace(/ /g,'&#32;');//替换空格 
    return str
}

```


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
