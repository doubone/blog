> 背景:华为云服务器部署前端项目迁移至华为云鲲鹏环境部署，项目启动node-sass异常报错
## node-sass异常报错
### 报错分析：  
1. 同样的代码、同样的node-sass版本
2. 同样的型号、规格、带宽的服务器
3. 同样的部署方式、同一个人在操作  
。。。  

在那焦虑的3分之一天里，笔者真的在怀疑还能不能再搞下去？。。。  
但是所幸有大佬的帮助，找寻了替代方案`dart-sass`,对`dart-sass`之前没有接触过，到底能否替代`node-sass`,还是保持怀疑态度。带着这些疑问和期待，慢慢开始挖掘。
### 替代方案  
根据[dart-sass中文官网](https://sass.bootcss.com/dart-sass)给出的定义：
>Dart Sass 是 Sass 的主要实现版本，这意味着它集成新 功能要早于任何其它的实现版本。Dart Sass 速度快、易于安装，并且 可以被编译成纯 JavaScript 代码，这使得它很容易集成到现代 web 的开发流程中。

Dart Sass 的独立命令行可执行文件是跑在高速的 Dart 虚拟机（VM）上来编译你的样式代码的，如果您在Dart-VM内运行Dart-Sass,它的运行速度很快；而且它可以被**编译成纯JS**并在 npm 上作为 sass 软件包 发布.作为编译版本的dart-sass，相较于node-sass执行速度慢，但是它很容易集成到现有的工作流中来。 
## Sass简单介绍
>Sass是一种CSS的预编译语言。它提供了 变量（variables）、嵌套（nested rules）、 混合（mixins）、 函数（functions）等功能，并且完全兼容 CSS 语法。Sass 能够帮助复杂的样式表更有条理， 并且易于在项目内部或跨项目共享设计。
### 变量（variables）  
变量是存储信息并在将来重复利用的一种方式，在整个样式表中都可访问。 你可以在变量中存储颜色、字体 或任何 CSS 值，并在将来重复利用。Sass 使用 $ 符号 作为变量的标志。例如：  
```css
$font-stack:    Helvetica, sans-serif
$primary-color: #333

body
  font: 100% $font-stack
  color: $primary-color
```
### 嵌套（nested rules）
在编写 HTML 时，您可能已经注意到它有一个清晰的嵌套和可视化层次结构。 而 CSS 则没有。

Sass 允许您嵌套 CSS 选择器，嵌套方式 与 HTML 的视觉层次结构相同。请注意，过度嵌套的规则 将导致过度限定的 CSS，这些 CSS 可能很难维护，并且 通常被认为是不好的做法 。   
示例代码：
```css
nav
  ul
    margin: 0
    padding: 0
    list-style: none

  li
    display: inline-block

  a
    display: block
    padding: 6px 12px
    text-decoration: none

```
### 混合（mixins）
在编写某些CSS时代码冗余很多，特别是CSS3带前缀的样式。混合的组声明方式，能让你使用起来更加的灵活。   
示例代码：
```css
=transform($property)
  -webkit-transform: $property
  -ms-transform: $property
  transform: $property
.box
  +transform(rotate(30deg))
```
### 函数（functions）
在 CSS 中经常需要做数学计算。Sass 支持一些标准的 数学运算符，例如 +、-、*、/ 和 %。
代码示例：
```css
.container
  width: 100%


article[role="main"]
  float: left
  width: 600px / 960px * 100%


aside[role="complementary"]
  float: right
  width: 300px / 960px * 100%
```
更多内容细节感兴趣的读者可点击链接查看详情[dart-sass中文网](https://sass.bootcss.com/dart-sass) 
## 问题解决  
### 解决思路
* 使用dart-sass替换掉node-sass
* 样式的兼容性问题
### 解决方案
1. 移除当前项目node-sass,安装dart-sass
```sh
npm uninstall -S node-sass 
npm install -S -D sass 
```
2. 替换 `node-sass` 之后有一个地方需要注意，就是它不再支持之前 `sass` 的那种 `/deep/` 写法，需要统一改为 `::v-deep` 的写法。相关情况查看：[issue](https://github.com/vuejs/vue-cli/issues/3399)   
示例代码：  
```css
.a {
  /deep/ {
    .b {
      color: red;
    }
  }
}

/* 修改为 */
.a {
  ::v-deep {
    .b {
      color: red;
    }
  }
}
```
不管你是否使用dart-sass，我都是建议你使用::v-deep的写法，它不仅兼容了 css 的>>>写法，还兼容了 sass /deep/的写法。  
全局修改重新启动项目，完美运行。

详情可查看链接[Node Sass to Dart Sass不兼容](https://panjiachen.github.io/vue-element-admin-site/zh/guide/advanced/sass.html#%E5%8D%87%E7%BA%A7%E6%96%B9%E6%A1%88)  


**node-sass**
***
**Warning**: LibSass and Node Sass are deprecated. While they will continue to receive maintenance releases indefinitely, there are no plans to add additional features or compatibility with any new CSS or Sass features. Projects that still use it should move onto Dart Sass.  

这是节选自目前最新版本v5.0.0官方指南给出的说明，大势所趋dart-sass终将会成为主流。  
到此为止，问题已经得以解决，但是问题出现的原因接着来分析，矛头直指华为-鲲鹏云环境。
## 鲲鹏云是什么？
鲲鹏云是以  鲲鹏920 处理器为核心的云服务器 ，鲲鹏920处理器兼容ARM架构，采用7nm工艺制造，可以支持32/48/64个内核，主频可达2.6GHz，支持8通道DDR4、PCIe 4.0和100G RoCE网络。  
相比于 传统X86 服务器，高性能和低功耗成为他突出的特点。  
详情查看[鲲鹏社区](https://www.huaweicloud.com/kunpeng/)

这里遗留了一个点，就是在购买ECS弹性云服务器时，选择的CPU架构鲲鹏环境选择的是鲲鹏计算，也就是说服务器的处理器是ARM架构的鲲鹏920
## CPU架构说明
* x86计算  
x86 CPU架构采用复杂指令集（CISC），CISC指令集的每个小指令可以执行一些较低阶的硬件操作，指令数目多而且复杂，每条指令的长度并不相同。由于指令执行较为复杂所以每条指令花费的时间较长。
* 鲲鹏计算  
鲲鹏CPU架构采用RISC精简指令集（RISC），RISC是一种执行较少类型计算机指令的微处理器，它能够以更快的速度执行操作，使计算机的结构更加简单合理地提高运行速度，相对于X86 CPU架构具有更加均衡的性能功耗比。
鲲鹏CPU架构的优势是高密度低功耗，可以提供更高的性价比，满足重载业务场景使用。


到此问题似乎已经很明显，正是CPU架构不同引起的  ARM VS X86  
查询node-sass v4.14.1 支持环境验证了以上结论  
**Supported Environments**
```
*Linux support refers to Ubuntu, Debian, and CentOS 5+
** Not available on CentOS 5
^ Only available on x64
```
详情可查看[链接](https://github.com/sass/node-sass/releases) 


硬件方面的知识本文不做过多分析，感兴趣的读者可自行查阅相关资料。  
到此问题出现的原因和解决问题的方案，文中都已详细介绍。  
如发现问题或者错误，欢迎随时指正。