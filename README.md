# pinyin-typeahead
汉字转拼音 word2pinyin typeahead

很多限制，所以作为特例来看待

首先有个"下拉列表性质"的文本输入区域， 比如城市名称 （当然使用纯下拉列表 如select-option也可以，但是这里不做讨论）
然后希望快捷输入

具体来说
  列表选项为中国的城市（这个是静态的数据 [1])，我想输入：阜新（这是辽宁的一个市）
  阜新 fuxin
  我希望输入 阜 后可以列出所有含有阜的城市，如阜新，阜阳，曲阜等
  我希望输入 fu 后可以列出所有含有fu的城市，如阜阳，富阳，福州等
  我希望输入 fx 后可以列出拼音中含有f和x的城市，并且f在x前面，如阜新 （tx 福喜）
  
  其中 fx 是阜新的拼音首字母， 不过并不强制要求只能输入拼音首字母（虽然可以这样做）， 比如输入 fn 后 可以列出 阜新和福清
  

代码例子中使用了 一些费用类型作为输入源， 如 加班费，评审费，课酬 等。 输入 kc 后回车即可以获得 课酬。


√ https://github.com/twitter/typeahead.js
  使用了typeahead， 未使用动态数据获取的 bloodhunt， 貌似bloodhunt可以指定 提示选项的 format 但是不能自定义 matcher 逻辑
  在matcher中 不仅匹配汉字，也会匹配拼音
√ https://github.com/padolsey-archive/jquery.fn/tree/master/cross-domain-ajax
  这个用来做跨域的...
√ http://string2pinyin.sinaapp.com/?str=
  这个是汉字转拼音的接口，接口返回数据中有doc文档的地址，不知道这个接口会维护多久, 自己搭建汉字拼音转换器课参考 https://github.com/overtrue/pinyin


另外代码中拼音处理部分来源于 https://github.com/hotoo/pinyin
