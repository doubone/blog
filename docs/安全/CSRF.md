# CSRF  
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
* 损坏网站名誉

# CSRF 攻击防御
## 禁止第三方网站带Cookies
## sameSite
`samesite`是HTTP响应头`Set-Cookie`的属性之一。它允许您声明该Cookie是否仅限于第一方或者同一站点的访问。`SameSite`接受下面三个值:  
* Lax   
Cookies允许与当前网页的URL与请求目标一致时发送，并且与第三方网站发起的GET请求也会发送。浏览器默认值。
 
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

