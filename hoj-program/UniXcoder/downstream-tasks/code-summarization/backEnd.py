from tokenize import tokenize
import urllib.request
import urllib.parse
import json

import requests
import torch
from flask import Flask,request
from transformers import RobertaModel, RobertaTokenizer, RobertaConfig
from model import Seq2Seq
import argparse
app = Flask(__name__)
# build model
tokenizer = RobertaTokenizer.from_pretrained("microsoft/unixcoder-base")
config = RobertaConfig.from_pretrained("microsoft/unixcoder-base")
# import！！！you must set is_decoder as True for generation
config.is_decoder = True
encoder = RobertaModel.from_pretrained("microsoft/unixcoder-base",config=config)
model = Seq2Seq(encoder=encoder,decoder=encoder,config=config,
                  beam_size=10,max_length=128,
                  sos_id=tokenizer.convert_tokens_to_ids(["<mask0>"])[0],eos_id=tokenizer.sep_token_id)
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
model.to(device)
model_to_load = model.module if hasattr(model, 'module') else model


def translation(content):
    url = 'http://fanyi.youdao.com/translate?smartresult=dict&smartresult=rule'
    data = {}
    data['i'] = content
    data['from'] = 'AUTO'
    data['to'] = 'AUTO'
    data['smartresult'] = 'dict'
    data['client'] = 'fanyideskweb'
    data['salt'] = '16216671697475'
    data['sign'] = '4b12fe85554d481a2d40331d2b07847f'
    data['ts'] = '1621667169747'
    data['bv'] = 'cda1e53e0c0eb8dd4002cefc117fa588'
    data['doctype'] = 'json'
    data['version'] = '2.1'
    data['keyfrom'] = 'fanyi.web'
    data['action'] = 'FY_BY_REALTlME'
    data = urllib.parse.urlencode(data).encode('utf-8')  # data信息要和发送的信息格式一致
    response = urllib.request.urlopen(url, data)
    html = response.read().decode('utf-8')
    target = json.loads(html)
    return (target['translateResult'][0][0]['tgt'])  # [0]的作用是定位‘tgt’在片中的位置


def decode(source_ids):
    """ Convert token ids to string """
    predictions = []
    for x in source_ids:
        prediction = []
        for y in x:
            t = y.cpu().numpy()
            t = list(t)
            if 0 in t:
                t = t[:t.index(0)]
            text = tokenizer.decode(t, clean_up_tokenization_spaces=False)
            prediction.append(text)
        predictions.append(prediction)
    return predictions

def tokenize(inputs, mode="<encoder-only>", max_length=512, padding=False):
    """
    Convert string to token ids

    Parameters:

    * `inputs`- list of input strings.
    * `max_length`- The maximum total source sequence length after tokenization.
    * `padding`- whether to pad source sequence length to max_length.
    * `mode`- which mode the sequence will use. i.e. <encoder-only>, <decoder-only>, <encoder-decoder>
    """
    assert mode in ["<encoder-only>", "<decoder-only>", "<encoder-decoder>"]
    assert max_length < 1024


    tokens_ids = []
    for x in inputs:
        tokens = tokenizer.tokenize(x)
        if mode == "<encoder-only>":
            tokens = tokens[:max_length - 4]
            tokens = [tokenizer.cls_token, mode, tokenizer.sep_token] + tokens + [tokenizer.sep_token]
        elif mode == "<decoder-only>":
            tokens = tokens[-(max_length - 3):]
            tokens = [tokenizer.cls_token, mode, tokenizer.sep_token] + tokens
        else:
            tokens = tokens[:max_length - 5]
            tokens = [tokenizer.cls_token, mode, tokenizer.sep_token] + tokens + [tokenizer.sep_token]

        tokens_id = tokenizer.convert_tokens_to_ids(tokens)
        if padding:
            tokens_id = tokens_id + [config.pad_token_id] * (max_length - len(tokens_id))
        tokens_ids.append(tokens_id)
    return tokens_ids
@app.route("/codeAI/unixcoder", methods=['POST'])
def HelloWorld():
    subdata = request.json
    code=subdata['code']
    language = subdata['language']
    if(language =='Python3' or language =='Python2'):
        model_to_load.load_state_dict(torch.load('./saved_models/python/checkpoint-best-bleu/pytorch_model.bin'))
        suffix = 'py'
    if(language =='Java'):
        model_to_load.load_state_dict(torch.load('./saved_models/java/checkpoint-best-bleu/pytorch_model.bin'))
        suffix = 'java'
    if(language == 'C'):
        suffix = 'c'
    if(language =='C++'):
        suffix = 'cpp'
    path = './code/code.' + suffix
    f = open(path, 'w')
    f.write(code)
    f.close()
    context = code
    tokens_ids = tokenize([context], max_length=512, mode="<encoder-decoder>")
    source_ids = torch.tensor(tokens_ids).to(device)
    prediction_ids = model.generate(source_ids)
    predictions = decode(source_ids=prediction_ids)
    res = [x.replace("<mask0>", "").strip() for x in predictions[0]]
    longest_element = ""
    for element in res:
        if len(element) > len(longest_element):
            longest_element = element
    chinese = "这段代码的注释为: "+translation(longest_element)
    english = "The comments to this code are： "+longest_element+"\n"
    ranslated_text = [english,chinese]
    return ranslated_text
app.run(host='127.0.0.1',port=7777)