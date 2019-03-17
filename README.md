# Japanese Talk API

---

# Reccomends to use newer one -> https://github.com/Drunkar/japanese_talk_api_transformer

---

**CAUTION**: Only available with Chainer 1.4.1 (Maybe 1.3.X and 1.4.X).

---

Respond to Japanese (and English and maybe Korean) input by lstm language-model.

Sample model was learned with crawled ask.fm data by yusuketomoto/chainer-char-rnn ( https://github.com/yusuketomoto/chainer-char-rnn ).

A python file tornado/static/CharRNN.py is copied from yusuketomoto/chainer-char-rnn.

## How to use (with docker).

The Easiest way is use my docker image ( https://hub.docker.com/r/drunkar/cuda-caffe-anaconda-chainer/ ).

```
git clone https://github.com/Drunkar/japanese_talk_api.git

docker run --name japanese_talk_api -d -p 80:8787 -v `pwd`/japanese_talk_api:/app drunkar/cuda-caffe-anaconda-chainer1.4.1

docker exec -it japanese_talk_api bash
cd /app/tornado/models
./download_sample_model.sh

cd /app
python tornado/app.py --port=8787 --debug=True
ctrl+p, ctrl+q
```

( Run tornado app takes some times due to loading chainermodel file. )

Then access ```http://localhost/?q=こんにちは```


## hubot interface

* You can use hubot script: https://github.com/Drunkar/japanese_talk_api/tree/master/hubot_script .
* Or npm package: https://github.com/Drunkar/hubot-japanese-talk .
