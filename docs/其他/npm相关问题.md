### 正常运行的项目，突然启动报错；报错信息提示运行操作文件操作权限不足；   
>猜测大概率是node_modules包出错，处理思路：删除根目录下node_modules文件夹，重新安装依赖；

执行脚本如下：   
```shell
$ rm -rf node_modules 
$ npm cache clean --force
$ npm install 
```
执行报错如下：  
```shell
npm ERR! code EINTEGRITY
npm ERR! sha512-bBs0V4EANm2dbcA5zntChfFWns4/jM/b8Cp8WzRvoeaOUTrkD5R1cH20oLTCvwN60ZLIlcREtbkah4sP+uLhWg== integrity checksum failed when using sha512: wanted sha512-bBs0V4EANm2dbcA5zntChfFWns4/jM/b8Cp8WzRvoeaOUTrkD5R1cH20oLTCvwN60ZLIlcREtbkah4sP+uLhWg== but got sha512-p7BY/cf7/LvoFHFSMxU9PQMPi/qvcrkVnKubzTcw8WmgqdpQ/rHPieG4ChAdlv+Nt2+sTGxDB4bB+dw1mYpclQ==. (138743 bytes) 
```  
查资料后发现，这个报错原因， 为了防止包字节内容不匹配、数据损坏、恶意内容操作，并保证所下载内容的完整性`package-lock.json`文件还将包括SHA-512校验和每次下载期间下载的所有对象的值,NPM将比较并校验下载对象与保存在文件中的这些校验和值。

如果任何此类npm包中的内容在远程和本地之间被更改（由于有意或者无意的尝试），其校验和值也将不同，就会导致npm包下载错误。
按照错误提示，此种错误或者类似错误的处理删除`package-lock.json`文件重新安装依赖即可。  
整理思路继续执行如下代码：  
```shell
$ rm -rf package-lock.json  node_modules
$ npm cache clean --force
$ npm cache verify
$ npm install --verbose
```
代码执行完毕依赖包提示已经安装成功，并且没有报错，启动项目时，意外提示错误如下：    
![安装依赖报错](https://github.com/doubone/javascript/blob/master/docs/images/%E4%BE%9D%E8%B5%96%E7%BC%BA%E5%A4%B1.png "安装报错") 

分析错误信息提示是`node`中的流操作依赖包没安装上，按照错误提示，整理思路继续执行：    
```shell
$ npm install -g readable-stream/duplex.js 
                 readable-stream/passthrough.js 
                 readable-stream/writable.js 
                 throttle-debounce/debounce 
                 throttle-debounce/throrrle
```  
安装过程直接报错，报错信息如下图：  
![安装缺失依赖报错](https://github.com/doubone/javascript/blob/master/docs/images/%E5%AE%89%E8%A3%85%E7%BC%BA%E5%A4%B1%E4%BE%9D%E8%B5%96%E6%8A%A5%E9%94%99.png "安装缺失依赖报错")

github建立链接失败报错,但是本地的公钥是在github-ssh上添加过的，  
测试链接：  
```shell
$ ssh -T git@github.com  
```
依旧报错Permission denied (publickey) 
 

`cnpm` 重新跑了一遍上述步骤，依然是安装正常，启动异常，报错如下：  
```shell
$ npm install -g readable-stream/duplex.js 
                 readable-stream/passthrough.js 
                 readable-stream/writable.js 
                 throttle-debounce/debounce 
                 throttle-debounce/throrrle
```  
**切换淘宝镜像和原镜像，打开vpn**方式实际测试后后，依旧安装正常，启动异常报错同上。 

安装依赖按照开发的角度讲，是项目开发的基础，这么复杂或者这么容易收到影响吗？  
简单的问题被复杂化了，解决思路或许是很简单的！  
回过头来思考刚开始遇到的错误，依赖包校验失败，到底是什么原因尼？  
依赖包校验失败，并不是依赖缺失，是不是可以不删除`package-lock.json`来安装尼？  
继续执行代码如下：  
```shell
$ rm -rf  node_modules
$ npm cache clean --force
$ npm cache verify
$ npm install --verbose

```
安装依赖成功，启动无异常。 窃喜加疑惑...   
再去回忆，每次更新依赖包确实是会更新并增加`package-lock.json`里的部分校验信息。

## 结论：
网络原因、`node`版本原因、权限原因、依赖包失效原因等等都会导致依赖包安装失败，但是分析问题的来源就会显得尤为重要。 
如果读者也有遇到类似安装依赖包出错的问题，根据错误提示选择性的删除 package-lock.json文件，其他代码不用修改，多执行几遍试试。  


```shell
# 删除node_modules包文件
$ rm -rf  node_modules
# 清空本地缓存
# 多用在npm运行报错后 提示信息 Cannot find module 'XXXX'
# verify和clean --force的区别在于是否会验证缓存数据的有效性和完整性从而进行有效cache clean.
$ npm cache clean --force  
$ npm cache verify 

# npm install 正常安装依赖
# npm install --verbose 展示安装过程的进度百分比
$ npm install --verbose

```
笔者在现有能力基础上确实不能给出问题出现的根本原因和解决问题最好的办法，只能是记录犯错和修改错误的过程，以期从中有所领悟。







