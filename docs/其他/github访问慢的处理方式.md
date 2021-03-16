### 问题描述：
  github在国内访问时，非常慢有时甚至访问不了。由于github的网站在美国旧金山，所以初次访问github.com时网络寻址会耗费时间，这也是网站打开速度慢甚至打不开的原因之一。
### 解决方式：
-   mac操作系统：
            hosts文件路径： /etc/hosts
             open terminal->vim /etc/hosts,添加国内的DNS加速地址，如下配置
              # github related website
              13.229.188.59 github.com
              185.60.216.36 github.global.ssl.fastly.net
              或者
              # github related website
              13.229.188.59 github.com
              140.82.114.4	github.com
              199.232.5.194	github.global.ssl.fastly.net
           清除DNS缓  sudo dscacheutil -flushcache
-  window操作系统：
        本地hosts文件路径：C:\Windows\System32\drivers\etc\hosts
        配置和MAC系统相同，windows操作系统可以直接用sublime修改保存
        配置结束后重新访问github.com，访问正常说明问题已经成功处理。但是如果访问和没配置之前没什么区别，那么新问题来了，成功配置国内DNS加速地址后依然不能访问guthub.com???
      先提供解决办法，具体问题或者为什么这么处理笔者目前的能力还解释不清楚，期待后续学习到这方面的知识再更新。
直接挂上vpn访问第一次成功后，以后不用vpn也可以正常访问。
以下是文章用到的工具
1. 国外现在检测网站工具[https://www.ipaddress.com/](url)（原始网站地址查询）
2. 国内DNS查询工具 [http://tool.chinaz.com/dns/](url)(就近访问网站地址查询)
3. vpn（蓝灯）地址 [https://github.com/getlantern/lantern](url) （有免费的流量可以使用）
