# CSRF攻击  
* Cross-site request forgery
* 跨站请求伪造  
## 场景模拟  
在用户登录某个网站后，看到某篇文章高兴之余，挥手打字，突然有人发来一个链接，登录者打开链接后什么都没有操作或者只是好奇的点击了某个按钮，在原登录网站评论页多出了一条自己的评论记录？？？what happened?   
如果您或者您的朋友发生了这样的事情，那么请第一时间邮件反馈给网站维护者，您大概率可能是被攻击了，而这种攻击就是CSRF,下面逐步介绍其攻击原理和防范措施。
## 攻击原理    
1. 用户登录A网站
2. A网站登录成功后返回用户身份信息
3. B网站获取A网站的用户登录身份信息向A网站发起请求，并且携带了A网站的用户身份信息

![CSRF 攻击原理](https://github.com/doubone/javascript/blob/master/docs/images/CSRF%E6%94%BB%E5%87%BB%E5%8E%9F%E7%90%86.png "CSRF 攻击原理示意图")
## 攻击危害
* 利用用户登录态
* 用户不知情
* 完成业务请求
* ...

* 盗取用户资金（转账、消费）
* 冒充用户发帖背锅
* 个人隐私泄露

# CSRF 攻击防御
## 禁止第三方网站带Cookies
### sameSite
`samesite`是HTTP响应头`Set-Cookie`的属性之一。它允许您声明该Cookie是否仅限于第一方或者同一站点的访问。  
`SameSite`接受下面三个值:  
* Lax   
Cookies允许与当前网页的URL与请求目标一致时发送，并且与第三方网站发起的GET请求也会发送。浏览器默认值。
 ```shell
 Set-Cookie: userId=123; SameSite=Lax;
```
* Strict  
Cookies只会在当前网页的URL与请求目标一致时发送，不会与第三方网站发起的请求一起发送。
```shell
Set-Cookie:userId=123;SameSite=Strict
```
* None  
Cookie将在所有上下文中发送，即允许跨域发送。  
使用`None`时，必须同时设置`Secure`属性（Cookie只能通过HTTPS协议发送），否则无效。  

以下的设置无效：
```shell
Set-Cookie: userId=123; SameSite=None
```
下面的设置有效：
```shell
Set-Cookie: userId=123; SameSite=None;Secure
```
更多用法可以参考[阮一峰老师SameSite属性介绍](http://www.ruanyifeng.com/blog/2019/09/cookie-samesite.html)、[MDN-SameSite](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie/SameSite),到此读者可能会疑惑
sameSite难道可以解决所有的CSRF攻击吗？  
答案：当然不是，sameSite受浏览器兼容性的影响，并不能解决防御所有攻击。兼容性列表在MDN的链接中。  
再按照攻击原理所理解，CSRF的攻击是不经过目标网站的前端的，那么我们是不是可以在此处“动手脚”尼？ 
## 在前端页面加入验证信息  
### 验证码
***  

处理思路：后端生成验证码保存并传递给前端；在前端提交表单数据中加入验证码并提交，在后端校验验证码存在和正确与否；
  
```js
//验证码生成
var captcha = {};
var cache = {};
captcha.captcha = async function (ctx, next) {
    var ccpa = require('ccap');//验证码生成模块
    var capt = ccpa();
    var data = capt.get();
    captcha.setCache(ctx.cookies.get('userId'), data[0]);
    ctx.body = data[1]
}
captcha.setCache = function (uid, data) {
    cache[uid] = data;
}
captcha.validCache = function (uid, data) {
    return cache[uid] === data;
}
module.exports = captcha;
```
```js
//验证码校验
...
const data = ctx.request.body;
if(!data.captcha){
	throw new Error('验证码错误')
}
var captcha = require('../tools/captcha')
var resultCaptche = captcha.validCache(ctx.cookies.get('userId'),data.captche);
if(!resultCaptche){
	throw new Error('验证码错误')
}
...
```
加入图形验证码对防御攻击可以起到很好的作用，但是每个表单都需要输入图形验证码且还要保证每次输入的验证码都正确。这对于用户来说是非常痛苦的一件事，由此可见这种方式在实际的使用中并不受用，那么有没有其他的更好的方案尼？
### token验证  
***
token其实是一段随机的字符串，它的作用是让攻击者发起请求时没有办法获取这个字符串，也就是必须要经过我们的页面，经过目标网站的前端。
* 在 HTTP 请求中以參数的形式添加一个随机产生的 token，并在服务器端验证这个 token，假设请求中没有token 或者 token 内容不对，拒绝该请求。
* 在HTTP请求头中，通过axios的配置参数，给所有的fetch请求全部加上Token这个HTTP请求头属性，并把Token值也放入请求头中。  
```js
//fetch.js
import axios from 'axios';

function getToken() {
    return localStorage.getItem('Token') ||'';
}
const fetch = axios.create({
    timeout: 60000 
});
fetch.interceptors.request.use(
    config => {
        config.headers['X-Token'] = getToken(); 
        return config;
    },
    error => {
        closeLoding();
        Promise.reject(error);
    }
);
...
export default fetch;
```
### 关于Token  
1. Token可以保存在localStorage中
2. Token加密且签名
3. Token生成与过期机制
3. 将 JSON Web Tokens 应用到 OAuth 2

## Referer  
* 验证referer
* 禁止第三方网站的请求
```js
// 校验代码
const referer = ctx.request.headers.referer;
// 简易防御
if(referer.indexOf('localhost')=== -1){
	throw new Error('非法请求')
}
上面的防御对这个地址是无效的：http:xx.xx.xx?name="张三"&uid='112'&localhost=='哈哈哈'
// 正则表达式防御
if(!/^https?:\/\/localhost/.test(referer)){
	throw new Error('非法请求')
}
```
当然这里还要考虑没有referer的情况哈

# 结语  
 安全作为系统的壁垒，重要程度不用多说。  
 CSRF攻击更是安全防御的重中之中。  
 本文记录的是笔者在开发过程中遇到的问题及处理的思路。可供有类似问题的读者参考。   
 其他安全方面的文章笔者会持续更新,欢迎各位读者提出意见和建议。