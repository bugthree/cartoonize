# 使用docker 因为网络问题基本上配置无法成功,
Dockerfile 重新改写 主要是因为科学上网的原因.
# 使用anadconda3
环境:python3.7
首先:配置 pip 镜像
安装:
- pip install -r requirements_1.txt
- pip install tensorflow-2.1.0-cp37-cp37m-manylinux2010_x86_64.whl # 因为 下载这个很慢,就算加了镜像,所以本地安装
- pip install -r requirements_2.txt

理论上这个项目已经配置好,运行 app.py,依然会出现错误:
1. `network.py` line7 `import tensorflow.compat.v1 as tf`出错
    - 原因:protobuf 版本过高,
    - 解决方法:`pip uninstall protobuf`&& `pip install protobuf==3.20.1`
2. `network.py` 中line11`# import tensorflow.contrib.slim as slim`
    - 错误:`No module named 'tensorflow.contrib'`
    - 原因:tensorflow 高版本无改方法 使用别的替换
    - 解决`pip install  tf_slim`  然后将`# import tensorflow.contrib.slim as slim`改为 `import tf_slim as slim`
3. 还有个错误是处在numpy 上,原因也是因为版本过高
    - 解决`pip install -U numpy==1.19.2` -u 相当与卸载原来numpy

## 运行项目
浏览器中输入`http://0.0.0.0:8080/` (Press CTRL+C to quit)

打开项目可以看到,就是一个网页