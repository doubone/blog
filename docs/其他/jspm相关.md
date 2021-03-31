# jspm 
* jspm init 初始化很慢  
执行下面操作
```shell
npm config get proxy
npm config rm proxy
npm config rm https-proxy
```
[参考资料](https://github.com/jspm/jspm-cli/issues/675)