# IE 调试
## 背景说明  
chrome本地正常调试的web项目，在IE浏览器中输入调试地址无响应  
## 解决思路 

配置IE浏览器的局域网配置脚本地址
1. 进入internet选项  
    ![打开Internet选项](https://github.com/doubone/blog/blob/master/docs/images/IE_debug_1.png "打开Internet选项")
2. 点击连接选项卡，打开局域网设置  
    ![选择连接选项卡，打开局域网设置](https://github.com/doubone/blog/blob/master/docs/images/IE_debug_2.png "选择连接选项卡，打开局域网设置")
3. 勾选使用自动配置脚本选项，输入web项目调试地址，确定  
    ![勾选脚本配置选项，输入调试地址](https://github.com/doubone/blog/blob/master/docs/images/IE_debug_3.png "勾选脚本配置选项，输入调试地址")
4. 保存配置项，重新输入调试地址  

# 结语：  
工欲善其事必先利其器，调试能力对于开发来说更是重中之重。本文记录的是如何利用IE浏览器进行本地web项目调试。
