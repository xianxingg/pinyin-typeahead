# CoffeeScript

window.PinYinApi = PinYinApi =
  # you should call getRemoteData and get new pinyins, then update StaticDataPinyin
  StaticDataWord: ['其它劳务费', '出差补贴', '加班费', '助教费用', '助管费用', '博士培养费', '口译费', '命题费', '咨询费', '外教补贴',
    '奖学金', '媒体费', '实习津贴', '指导费', '撰写费', '教学奖励费', '演讲费', '监考费', '督导费', '笔译费',
    '答辩费', '论坛主持费', '评审费', '课酬', '辅导费', '速记费', '阅卷费', '面试费']
  StaticDataPinyin: 'qí tā láo wù fèi ,chū chāi bǔ tiē ,jiā bān fèi ,zhù jiào fèi yòng ,zhù guǎn fèi yòng ,bó shì péi yǎng fèi ,kǒu yì fèi ,mìng tí fèi ,zī xún fèi ,wài jiào bǔ tiē ,
    jiǎng xué jīn ,méi tǐ fèi ,shí xí jīn tiē ,zhǐ dǎo fèi ,zhuàn xiě fèi ,jiào xué jiǎng lì fèi ,yǎn jiǎng fèi ,jiān kǎo fèi ,dū dǎo fèi ,bǐ yì fèi ,dá biàn fèi ,lùn tán zhǔ chí fèi ,
    píng shěn fèi ,kè chóu ,fǔ dǎo fèi ,sù jì fèi ,yuè juàn fèi ,miàn shì fèi'
  Initials: "zh,ch,sh,b,p,m,f,d,t,n,l,g,k,h,j,q,x,r,z,c,s,yu,y,w".split ","
  Finals: "ang,eng,ing,ong,an,en,in,un,er,ai,ei,ui,ao,ou,iu,ie,ve,a,o,e,i,u,v".split ","
  PinyinStyle: Normal: 0, Tone: 1, Tones: 2, Initials: 3, FirstLetter: 4
  PhoneticSymbol: 
    "ā": "a1", "á": "a2", "ǎ": "a3", "à": "a4", "ē": "e1", "é": "e2", "ě": "e3", "è": "e4", "ō": "o1", "ó": "o2", "ǒ": "o3", "ò": "o4", "ī": "i1", "í": "i2", "ǐ": "i3", "ì": "i4"
    "ū": "u1", "ú": "u2", "ǔ": "u3", "ù": "u4", "ü": "v0", "ǘ": "v2", "ǚ": "v3", "ǜ": "v4", "ń": "n2", "ň": "n3", "": "m2"
  RegPhoneticSymbol: new RegExp('(["āáǎàēéěèōóǒòīíǐìūúǔùüǘǚǜńň"])', 'g')
  RegTones: /([aeoiuvnm])([0-4])$/
  String2PinYinApiUrl: 'http://string2pinyin.sinaapp.com/?str='
  
  # input StaticDataWord get StaticDataPinyin
  getRemoteData: (arr) ->
    jQuery.get @String2PinYinApiUrl + arr.join(','), (data) ->
      json = JSON.parse(data?.responseText?.replace('<html><head/><body>','').replace('</body></html>',''))
      if json?.status is 'T' and json?.pinyin? then json.pinyin else ''
    ''
  
  # format jiǎng to target format
  format: (pinyin, style = @PinyinStyle.Initials) ->
    switch style
      when @PinyinStyle.Initials
        return initial for initial in @Initials when pinyin.indexOf(initial) is 0
        ''        
      when @PinyinStyle.Tone
        firstLetter = pinyin.charAt 0
        if @PhoneticSymbol.hasOwnProperty firstLetter then @PhoneticSymbol[firstLetter].charAt 0 else firstLetter        
      when @PinyinStyle.Normal
        pinyin.replace @RegPhoneticSymbol, ($0, $1) =>
          @PhoneticSymbol[$1].replace @RegTones, "$1"          
      when @PinyinStyle.Tones
        tone = ''
        pinyin = pinyin.replace @RegPhoneticSymbol, ($0, $1) =>
          tone = @PhoneticSymbol[$1].replace @RegTones, "$2"
          @PhoneticSymbol[$1].replace @RegTones, "$1"
        pinyin + tone        
      when @PinyinStyle.Tone then pinyin
      else pinyin

  # formatted pinyin array
  pinyin2Array: (str = @StaticDataPinyin, want = @PinyinStyle.Normal, splitor = ',', inPhaseSplitor = '') ->
    that = this
    res = []
    if !str or str.length is 0
      return res
    for pys in str.split splitor
      rst = ''
      (rst += that.format(py, want) + inPhaseSplitor) for py in pys.split ' '
      res.push rst
    value: @StaticDataWord[i], ini: ts for ts, i in res

  # search matcher (search both word and pinyin)
  substringMatcher: (strs) ->
    (q, cb) ->
      matches = []
      # strs[n] is {value: , ini:}
      q = '.*' if q is '*' or q is '?'
      q = q.split('').join('.*') if q isnt '.*'
      substrRegex = new RegExp q, 'i'
      $.each strs, (i, str) ->
        matches.push value: str.value if substrRegex.test(str.value) or substrRegex.test(str.ini)
        return
      cb matches
      return

  # get source
  getPinyinSource: ->
    @substringMatcher @pinyin2Array()