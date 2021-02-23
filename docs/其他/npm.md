正常运行的项目，突然报错权限不足；想到大概率是node_modules包出错，执行代码如下：
$ rm -rf node_modules 
$ npm install 

npm ERR! code EINTEGRITY
npm ERR! sha512-bBs0V4EANm2dbcA5zntChfFWns4/jM/b8Cp8WzRvoeaOUTrkD5R1cH20oLTCvwN60ZLIlcREtbkah4sP+uLhWg== integrity checksum failed when using sha512: wanted sha512-bBs0V4EANm2dbcA5zntChfFWns4/jM/b8Cp8WzRvoeaOUTrkD5R1cH20oLTCvwN60ZLIlcREtbkah4sP+uLhWg== but got sha512-p7BY/cf7/LvoFHFSMxU9PQMPi/qvcrkVnKubzTcw8WmgqdpQ/rHPieG4ChAdlv+Nt2+sTGxDB4bB+dw1mYpclQ==. (138743 bytes)
```
npm install 报错
为了防止字节内容不匹配、数据损坏、恶意内容操作，并保证所下载内容的完整性package-lock.json文件还将包括SHA-512校验和每次下载期间下载的所有对象的值npm install,NPM将比较并校验下载对象与保存在文件中的这些校验和值。

如果任何此类npm包中的内容在远程和本地之间被更改（由于有意或者无意的尝试），其校验和值也将不同，这将导致一个npm包完整性错误。

