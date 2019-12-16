# wechat-api

https://github.com/lazing/wechat-api

用于微信 api 调用（非服务端推送信息）的处理。

[![Circle CI](https://circleci.com/gh/lazing/wechat-api.svg?style=svg)](https://circleci.com/gh/lazing/wechat-api)
[![Gem Version](https://badge.fury.io/rb/wechat-api.svg)](http://badge.fury.io/rb/wechat-api)

常见的应用场景如：
* 获取关注用户
* 推送模板信息
* 创建二维码
* 创建短链接

远期计划进一步支持微信支付等。

## 为什么不使用其他 gem

* 很多 gem 基于 rails 或其他 web 框架，单独使用过于笨重
* 不够简单，特别是用于多账号管理的时候
* 微信 api 更新频繁，需要易于使用新功能

## 主要功能清单
* 支持微信服务号和订阅号API
* 支持微信js_ticket获取
* 支持微信红包API
* 支持微信企业号主动调用API

## 使用方式

````ruby
gem 'wechat-api'
````

````ruby
require 'wechat-api'

api = Wechat::Api::Client.new 'appid', 'appsecret'

api.get 'user/info', nextopenid: 'xxx'
# 当使用 get 方式时，hash 参数将做个 query params 附在请求后

api.post 'user/info/updateremark', openid；'xxxx', remark: '我是注释'
# 当使用 post 方法时，hash 参数将转换为 json，因此可以支持嵌套的结构
````

微信企业号主动调用API

````ruby
require 'wechat-api'

qy = Wechat::Qy::Client.new 'corpid', 'corpsecret'
qy.text_send 'agentid', 'message', touser: 'UserId1|UserId2' #提供的预定义方法
qy.post 'api/uri', { key: :value} #未提供预定义方法时调用
````

## 一些预定义方法

预定义接口方法可以方便使用。

目前支持如下：

````ruby
# 创建固定二维码
api.create_qrcode(scene_str)

# 创建临时二维码
api.create_qrcode_temp(scene_id)

# 发送模板消息
api.send_template(template_id, openid, url, data = {})
````

以上接口返回微信文档定义的 json 数据转换后的ruby的 hash 对象

````ruby
{
  "ticket"=>"gQHc7zoAAAAAAAAAASxodHRwOi8vd2VpeGluLnFxLmNvbS9xL0NVeGttUnJrOGZhSTdyX2RzR1F3AAIEZKcDVgMEAAAAAA==",
  "url"=>"http://weixin.qq.com/q/CUxkmRrk8faI7r_dsGQw"
}
````

## 关于贡献
功能请求，请直接 fork 并创建 Merge Request
