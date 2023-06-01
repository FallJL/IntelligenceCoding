# 快速开始

运行对应程序以开启服务端口，全部启动代码：(可能需要安装对应的conda环境和python包)

```bash
cd Flowchart
python fc_request.py

cd OnlinePythonTutor/v5-unity
python bottle_server.py

cd UniXcoder/downstream-tasks/code-search
python flask_backend.py
```



- **程序流程图**：运行Flowchart下的fc_request.py文件，**端口5000**
- **单步执行可视化**：运行OnlinePythonTutor/v5-unity 下的bottle_server.py文件，**端口8003**
- **代码搜索**：运行UniXcoder/downstream-tasks/code-search 下的flask_backend.py文件，**端口7777**





# 文件夹简介

## Flowchart
- 师姐提供的**程序流程图**项目, 包括前后端, 后端为Python flask框架



## OnlinePythonTutor

- 开源的**单步执行可视化**项目，本地运行时只支持python
- 官网：https://pythontutor.com/

- 官方GitHub地址：https://github.com/hcientist/OnlinePythonTutor

- 本项目GitHub地址：https://github.com/sineagles/OnlinePythonTutor



## UniXcoder

- **代码搜索** 等代码智能任务的预训练大模型
- ACL 2022 论文
- 官方GitHub地址：https://github.com/microsoft/CodeBERT （包含了CodeBERT系列模型）