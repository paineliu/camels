# CAMELS
多粒度分词的CQL解析器系统(CQL Analyzer with Multi-lEvel Lexical System, CAMELS)

✨ 简介
CCL 2024 论文 面向CQL的语料库检索引擎的高效实现 的官方仓库。

语料库检索工具在语言学研究领域具有举足轻重的地位，对于高效获取信息至关重要。然而，当前国内语料库检索工具在检索语言上缺乏统一标准，尤其支持语料库查询语言（CQL）的中文语料库检索工具相对稀缺。在使用不同分词粒度的语料库工具进行中文语料库检索时，会遇到噪声或数据召回难问题。为应对这些挑战，我们研发了多粒度分词的偃偑偌 解析器系统CAMELS：一款支持CQL语句检索，且兼容多粒度分词，支持非词典词检索的语料库检索引擎。经过多种分词器的测试，该引擎展现出了优异的召回率，并在性能上超越了BlackLab的检索速度，为语言学工作者提供了更加易用、精准的检索工具。这是我们探索语料库检索的一项基础性工作，期望能为今后的研究提供参考。

论文地址：https://

工具

在语料库构建和测试过程中使用了：BlackLab、stanford-corenlp、THULAC、jsslib等工具

数据

采用《人民日报》文本语料，通过JSSLIB创建语料库。

数据格式

所有文件均为纯文本格式。在经过分词处理后，生成connlu格式数据文件。

数据示例

1	新华社	新华社	_	multiword-expression	_	_	_	_
2	北京	北京	_	noun	_	_	_	_
3	12月	12月	_	time-word	_	_	_	_
4	31日	31日	_	time-word	_	_	_	_
5	电	电	_	noun	_	_	_	_

🛠️ 语料库构建

1、使用分词工具对语料进行预处理
若您使用 CAMELS 建立语料库，您应该先将语料转换为connlu格式。

2、编辑jss配置文件
```
{
  "table_name": "rmrb",
  "record_format": "segpos",

  "contect": {
    "id": "id",
    "filename": "filename",
    "sentence": "sentence",
    "seg": "seg",
    "pos": "pos",
    "segpos": "segpos"
  },

  "index": {
    "kv": [
      "pos"
    ],

    "number": [
      "id"
    ],

    "affix": [
      "seg"
    ],

    "bm25": [
      "seg"
    ]
  }
}
```

3、生成索引数据

```
jss = jsslib.JSS()
jss.CreateTable('./config/rmrb.json', './data/rmrb-json-stanford', './data/rmrb-table-stanford')
```

4、执行CQL查询

```
cql = JSSCql('./data/rmrb-table-stanford')
total, result = jssCql.cql_search(statement)
```

🧪 相关实验
我们采用斯坦福分词工具以及清华分词工具，对数据分词生成BlackLab语料库以及CAMELS语料库，进行速度和召回率比较。

作者
如果您有任何问题，或对我们的相关研究感兴趣，欢迎联系我们！

刘廷超：（liutingchao@hotmail.com）

鲁鹿鸣：（lulm410402@foxmail.com）

引用
如果使用本文的研究成果，请您引用：
