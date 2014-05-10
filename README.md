Emacs的自定义配置包

使用方法

1. 将项目下载到任意未知

2. 添加以下行到.emacs
```
(setq my-config-path "/path/to/config-package")
(add-to-list 'load-path my-config-path)
(load "load-all-configs.el")
```
