import os
import json
import re
from segtool import SegTool


import queue
import threading
 


g_pos = set()
g_doc_line_total = 0

def passage_to_sentences(passage):
    sentences = re.split(r"([.。!！?？\s+])", passage)
    sentences.append("")
    sentences = ["".join(i) for i in zip(sentences[0::2],sentences[1::2])]
    return sentences

def conllu_txt_to_conllu_file(txt_filename, conllu_filename):
    print(txt_filename, conllu_filename)
    segTool = SegTool()
    os.makedirs(os.path.dirname(conllu_filename), exist_ok=True)
    f = open(txt_filename, encoding='utf_8')
    f_c = open(conllu_filename, mode='w', encoding='utf_8')

    for each in f:
        passage = each.strip()
        sentences = passage_to_sentences(passage)
        for sentence in sentences:
            if len(sentence) > 0:
                tokens = segTool.thulac_pos_tag(sentence)
                if len(tokens) > 1:
                    for i, token in enumerate(tokens):
                        conllu_line = '{}\t{}\t{}\t_\t{}\t_\t_\t_\t_\n'.format(i+1, token[0], token[0], token[1].replace(' ', '-'))
                        f_c.write(conllu_line)                        
                    f_c.write('\n')
                    
 

def conv_to_conllu(data_pathname, conllu_pathname):
    # 创建一个队列对象，把数组值放进去
    q = queue.Queue()
    
    # 定义实际操作
    def do_something(map_param):
        conllu_txt_to_conllu_file(map_param['inFile'], map_param['outFile'])
    
    # 从队列中取出值，并调用实际操作
    def f(queue):
        while not queue.empty():
            i = queue.get()
            do_something(i)
    
    # 起10个线程，线程target去执行从队列中取值并进行操作的动作
    
    for parent, dirs, files in os.walk(data_pathname):
        for filename in files:
            fullname = os.path.join(parent, filename)
            out_pathname = conllu_pathname + fullname[len(data_pathname):]
            if filename.endswith('.txt'):
                map_param = { 'inFile':fullname, 'outFile':out_pathname}
                q.put(map_param)

    threads = []
    for t in range(10):
        thread = threading.Thread(target=f, args=(q,))
        threads.append(thread)
        thread.start()
    
    for t in threads:
        t.join()
    print("finished.")

conv_to_conllu('./data/rmrb-text', './data/rmrb-conllu-thulac')
