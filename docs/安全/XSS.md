# XSS攻击
## XSS[介绍](https://baike.baidu.com/item/XSS%E6%94%BB%E5%87%BB/954065?fr=aladdin)
>XSS攻击通常指的是通过利用网页开发时留下的漏洞，通过巧妙的方法注入恶意指令代码到网页，使用户加载并执行攻击者恶意制造的网页程序。这些恶意网页程序通常是JavaScript，但实际上也可以包括Java、 VBScript、ActiveX、 Flash 或者甚至是普通的HTML。攻击成功后，攻击者可能得到包括但不限于更高的权限（如执行一些操作）、私密网页内容、会话和cookie等各种内容。(内容摘自百度百科)

xss攻击类型可分为两种，**反射型**和**存储型**，顾名思义一种是保存进了数据库，另一种是在url中直接触发，没保存进数据库，下面一一介绍。
## 反射型
>url参数直接注入

场景说明：在网站的搜索框内直接输入攻击脚本
```js
// 搜索框搜索
http://localhost/?keyWord=<script>alert(111)</script>
```
## 存储型
>存储到DB后读取时注入
场景说明：攻击脚本作为留言内容，提交给后台保存，刷新页面后端返回攻击脚本给前端
```js
// 留言板插入数据库
留言测试<script>alert(222)</script>//留言内容
```

* HTML节点内容

攻击脚本通过接口存入数据库中，当页面刷新时，插入的脚本替换页面HTML节点内容，脚本随即执行，引发漏洞攻击
```html
<!-- content变量被攻击脚本替换 -->
<div>
    {{content}}
</div>
<div>
    <script>
    </script>
</div>

```


* HTML属性 

通过修改或者添加HTML属性，触发攻击事件
```html
<!-- 图片地址异常后，引发错误事件 -->
<img src="#{image}"/>
<img src=" 1"onerror="alert(1)" />
```
* JavaScript代码  
通过获取用户输入的变量或者其他保存的变量，在脚本中打印
```js
<script>
    var data = params;
    console.log(data)
    // 输入内容
    params = "hello":alert(1)
</script>
```
* 富文本  
富文本需要保留HTML   
HTML有XSS攻击风险


# 处理方法

整体思路：**转义**  
* HTML->[HTML实体](https://www.w3school.com.cn/html/html_entities.asp)  
* js->JSON_encode

转义时机：  
1. 存入数据库时转义
2. 返回给前端时转义

转义方式更倾向于**第一种**：因为输入是一次性性能消费，而输出会是多次，造成性能浪费，本文的示例代码内容由于个人编译、演示方便原因是采用第二种方式-返回时转义，请各位读者知晓

## HTML节点内容  
处理思路：转义`< >`,使之不能以`html`标签的形式保存或者返回给前端
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

## HTML属性  
处理思路：转义`"`引号，使标签内属性不能自闭合，引起触发事件  
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
那么问题来了，转义了`HTML`属性中的大于号、小于号，会对元素产生其他影响吗？转义了`HTML`节点内容中的单引号、双引号、空格，会对元素产生其他影响吗？  
答案是不会产生影响的，读者可以自行验证。  
此时可以合并上面的两个函数，整体处理`HTML`节点和属性,合并函数如下：  
```js
// 转义函数
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
## JavaScript代码
处理思路：转义双引号或者JSON_encode
```js
//转义函数
var escapeForJs =function(str){
	if(!str)return '';
	str = str.replace(/"/g,'\\"');//js中双引号的转义和HTML中不同，不能使用HTML转义方法
	return str;
}
```
```js
原函数：
<script>
var str = "!{keyWord}";
console.log(str)
</script>

//hello world";alert(1);"
//转义前
<script>
hello world
alert(1)已经被弹出
</script>

//转义后
hello world";alert(1);"
```
然而这样就安全了吗？  
答案肯定不是！  
单引号、script标签、双引号、空格...都可以引发攻击，更为安全的方式-**JSON_encode转义** 
## JavaScript代码_JSON_encode转义
JSON_encode转义-**JSON.stringify**  
演示代码：
```js
// 转义函数
JSON.stringify(参数)
```  
```js
//转义前
hello world";alert(1);"
//转义后
hello world";alert(1);"
```

## 富文本  
处理思路：**过滤** 
1. 黑名单过滤
>比如 `script`标签、`onerror`标签...全部过滤掉  
* 利：实现简单-正则表达式就可处理
* 弊：HTML标签过于庞杂，难免会留有漏洞
2. 白名单过滤  
>按照白名单过滤保留部分标签和属性,只允许保留名单内的标签、属性
* 利：比较彻底，只允许指定的标签、属性存在  
* 弊：实现起来相对麻烦，将HTML完全解析成数据结构，再对数据结构过滤，再组装成HTML  

### 黑名单过滤：  
示例攻击代码：  
```html
<!-- 可能输入的攻击脚本 -->
<font color=\"red\">这是红色字</font><script>alert('富文本')</script>
<a href=\"javascript:alert(1)\"></a>
<img src=\"abc\" onerror=\"alert(1)\">
..onfocus,
..onmounseover,
..onmenucontext,
...
```
```js
//过滤函数
var xssFilter = function (html) {
	if (!html) return '';
	html = html.replace(/<\s*\/?script\s*>/g,'');
	html = html.replace(/javascript:[^'"]*/g,'');
	html = html.replace(/onerror\s*=\s*['"]?[^'"]*['"]?/g,'');
    ...
	return html
}
```
HTML中带有事件触发的都有可能成为攻击的突破口，面对这种情况，怎么防御呢？下面介绍白名单过滤。  
### 白名单过滤：  
处理思路：整理富文本中所有的标签属性，过滤只允许这些属性通过，其他属性则不允许通过  
处理方式：将HTML解析成树状结构，和浏览器解析HTML过程类似，再去遍历树状结构元素，在过滤范围内的允许通过，没在过滤范围内的，则去掉   

示例攻击代码：  
```html
//可能输入的攻击脚本
<font color=\"red\">这是红色字</font><script>alert('富文本')</script>
<a href=\"javascript:alert(1)\"></a>
<img src=\"abc\" onerror=\"alert(1)\">
..onfocus,
..onmounseover,
..onmenucontext,
...
```
```js
//过滤代码
var xssFilter = function (html) {
	if (!html) return '';
	//白名单 
	var whiteList = {
		'img': ['src'],
		'font':['color','size'],
		'a':['href']
	};
	var cheerio = require('cheerio');
	var $ = cheerio.load(html);
	$('*').each(function (index, elem) {
		if (!whiteList[elem.name]) {
			$(elem).remove();
			return;
		}
		for (var attr in elem.attribs) {
			if (whiteList[elem.name].indexOf(attr) === -1) {
				$(elem).attr(attr, null);
			}
		}
	})
	return $.html()
}
```
# cheerio介绍  

> cheerio是为服务器特别定制的，快速、灵活、实施的以jQuery为核心实现的对DOM操作方案
```js
//基础用法
const cheerio = require('cheerio');
const $ = cheerio.load('<h2 class="title">Hello world</h2>');

$('h2.title').text('Hello there!');
$('h2').addClass('welcome');

$.html();
//=> <html><head></head><body><h2 class="title welcome">Hello there!</h2></body></html>

```
安装方式、语法等此处不过多介绍，需要的读者请跳转[官网](https://cheerio.js.org/)阅读  
代码中主要使用它把`HTML`结构转换成可直接使用的数据结构，再循环去比较、移除。  
那有没有现有的可直接使用的第三方框架吗？答案是肯定的

# js-XSS

`xss`是一个用于对用户输入的内容进行过滤，以避免遭受 XSS 攻击的模块。主要用于论坛、博客、网上商店等等一些可允许用户录入页面排版、格式控制相关的 HTML 的场景，xss模块通过白名单来控制允许的标签及相关的标签属性，另外还提供了一系列的接口以便用户扩展，比其他同类模块更为灵活[中文官网地址](https://github.com/leizongmin/js-xss/blob/master/README.zh.md)  
示例代码：  
```js
//过滤函数
var xssFilter = function (html) {
	if (!html) return '';
	var xss = require('xss');
	var ret = xss(html);
	return ret;
}
```
就是如此的简单，当然还需要调整，此处就不过多介绍了，下面介绍下`xss`模块的特性及基本使用方法。
## 特性  
* 白名单控制允许的 HTML 标签及各标签的属性
* 通过自定义处理函数，可对任意标签及其属性进行处理  
## 使用方法：  

在`Node.js`中使用  
```js
var xss = require("xss");
var html = xss('<script>alert("xss");</script>');
console.log(html);
```
在浏览器端使用  
```js
<script src="https://rawgit.com/leizongmin/js-xss/master/dist/xss.js"></script>
<script>
// 使用函数名 filterXSS，用法一样
var html = filterXSS('<script>alert("xss");</scr' + 'ipt>');
alert(html);
</script>
```  
其他使用模式及用法请参考[官网](https://github.com/leizongmin/js-xss/blob/master/README.zh.md)案例  

如果需要简单、快速、安全的开发选用第三方的库当然更好，但是使用过程可能会有这样或者那样的问题，达不到业务的要求等等，相较于第三方的库自己设置白名单去处理的话，就更容易控制、定制化效果明显，相对问题可能会更少，仁者见仁智者见智，读者根据实际情况可自行选择。  

# CSP 
>内容安全策略   (CSP) 是一个额外的安全层，用于检测并削弱某些特定类型的攻击，包括跨站脚本 (XSS) 和数据注入攻击等。无论是数据盗取、网站内容污染还是散发恶意软件，这些攻击都是主要的手段。 
* Content Security Policy
* 内容安全策略
* 用于指定那些内容可执行
## 使用方法： 
配置内容安全策略涉及到添加 Content-Security-Policy  HTTP头部到一个页面，并配置相应的值，以控制用户代理（浏览器等）可以为该页面获取哪些资源。

## 常见用例：
### 示例1 
一个网站管理者想要所有内容均来自站点的同一个源 (不包括其子域名)  
```js
Content-Security-Policy: default-src 'self'
```
### 示例2  
 一个在线邮箱的管理者想要允许在邮件里包含HTML，同样图片允许从任何地方加载，但不允许JavaScript或者其他潜在的危险内容(从任意位置加载)。  
 ```js
 Content-Security-Policy: default-src 'self' *.mailsite.com; img-src *
 ```
 更多示例及用法请参考[MDN-CSP](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/CSP)  
 # 结语  
 安全作为系统的壁垒，重要程度不用多说。
 XSS攻击更是安全防御的重中之中。  
 本文记录的是笔者在开发过程中遇到的问题及处理的思路。可供有类似问题的读者参考。   
 其他安全方面的文章笔者会持续更新,欢迎各位读者提出意见和建议。
















