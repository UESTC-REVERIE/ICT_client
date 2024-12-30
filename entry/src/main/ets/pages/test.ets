import router from '@ohos.router';
import Constants from '../common/Constants';
import Setting from '../common/Setting';
import webview from '@ohos.web.webview';
import webSocket from '@ohos.net.webSocket';
import common from '@ohos.app.ability.common';
import request from '@ohos.request';

let context = getContext(this) as common.UIAbilityContext;
let ws =  webSocket.createWebSocket();
var defaultIpAddress = "";


@Entry
@Component
struct Show {
  @State modelname:string = router.getParams()['modelname']
  @State existModel:boolean = router.getParams()['state']
  @State displayVEDIO:boolean = false
  @State videoUrl:string = Setting.SERVER_ADDR + Constants.SERVER_DOWNLOAD_LOADING_URL
  webController: webview.WebviewController = new webview.WebviewController()

  onPageShow(){
    ws.connect(defaultIpAddress,(err,value)=>{
      if (!err) {
        console.log("Connected successfully");
      } else {
        console.log("Connection failed. Err:" + JSON.stringify(err));
      }
    });

    ws.on('open', (err, value) => {
      console.log("on open, status:" + JSON.stringify(value));
      // 当收到on('open')事件时，可以通过send()方法与服务器进行通信
      ws.send("Hello, server!", (err, value) => {
        if (!err) {
          console.log("Message sent successfully");
        } else {
          console.log("Failed to send the message. Err:" + JSON.stringify(err));
        }
      });
    });

    ws.on('message', (err, value) => {
      if (typeof value != 'string' ) {
        //传回来的是arraybuffer
        /*
        把arraybuffer先存下来，放到一个临时文件夹里，然后用一个图片切换组件展示当前收到的中间结果
        * 没有办法直接保存，待解决
         */
      }
      else if(value === 'modelCompleted'){
        //模型渲染完成，执行后续加载函数
        /*
        修改变量的值，转向实时渲染页面
         */
        this.existModel = true

      }
      else if(value === 'videoCompleted'){
        /*
         * 视频渲染完成，执行后续加载函数
         * 把视频组件的视频源更改，把下载按钮颜色改变
         */
        this.videoUrl = Setting.SERVER_ADDR + Constants.SERVER_DOWNLOAD_LOADING_URL
      }
      else{
        //报错
        console.log(JSON.stringify(value));
      }
    });
  }
  initParams(){
    var defaultIpAddress = "";
    // this.receivedSize = 0;
    // this.totalSize = 0;
    this.existModel = false;
  }

  build() {
    Column(){
      //页面上部
      Column(){
        Row() {
          //返回按钮
          Button("返回", { stateEffect: false })
            .width("125vp")
            .height("20vp")
            .offset({ x: "10vp", y: "30vp" })
            .backgroundImage($r('app.media.return'))
            .backgroundImageSize(ImageSize.Contain)
            .backgroundColor(Color.Transparent)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#c7000b')
            .onClick(() => {
              router.back();
              this.initParams();
            })

          if(this.existModel == true)
          {
            Button("切换视图", { type: ButtonType.Capsule,stateEffect: true })
              .width("120vp")
              .height("40vp")
              .offset({ x: "100vp", y: "30vp" })
                // .backgroundImage($r('app.media.button'))
              .backgroundImageSize(ImageSize.Contain)
              .backgroundColor('#ff199403')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#ffeee8e8')
              .onClick(() => {
                this.displayVEDIO = !this.displayVEDIO
              })}
          else{
            Text("训练中...")
              .width("120vp")
              .height("40vp")
              .offset({ x: "100vp", y: "30vp" })
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#C00000')
          }
        }
        if(this.existModel == true){
          if (this.displayVEDIO == false){
            Text('模型预览')
              .textAlign(TextAlign.Start)
              .fontSize(18)
              .offset({ x: "10vp", y: "60vp" })

          }
          else{
            Text('视频预览')
              .textAlign(TextAlign.Start)
              .fontSize(18)
              .offset({ x: "10vp", y: "60vp" })
          }
        }
        Divider()
          .width("100%")
          .height("1.5vp")
          .color(Color.Gray)
          .offset({ x: "0vp", y: "65vp" })
      }
      .height("40%")
      .width("100%")

      //页面中部
      Column(){

      }
      .height("60%")
      .width("100%")

    }
    .width("100%")
    .height("100%")
  }
}