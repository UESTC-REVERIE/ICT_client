import router from '@ohos.router';
import Constants from '../common/Constants';
import Setting from '../common/Setting';
import common from '@ohos.app.ability.common';
import webview from '@ohos.web.webview';

let context = getContext(this) as common.UIAbilityContext;

@Entry
@Component
struct Show {
  @State displayVideo:boolean = false //默认训练完成后初始展示视频页面
  @State videoUrl:string = Setting.SERVER_ADDR + Constants.SERVER_DOWNLOAD_LOADING_URL //默认视频加载画面
  // @State existModel:boolean = true
  // @State modelname:string = 'base'
  @State modelname:string = router.getParams()['modelname']//展示的模型名称
  @State existModel:boolean = router.getParams()['state'] //是否从历史记录进入当前页面，决定是否加载LoFTR中间图像的展示页面和维持websocket
  @State modelCompleted : boolean= false //后端传来模型训练完成的信号
  @State videoCompleted : boolean= false //后端传来视频渲染完成的信号
  @State test_name:string = 'test_name' //测试代码
  @State preview_window_text:string = ''//当前状态信息
  // 控制窗口大小，保留显示缓存
  @State websocket_view_size:string = '100%'
  @State mesh_view_size:string = '0%'
  @State video_view_size:string = '0%'
  webController: webview.WebviewController = new webview.WebviewController()
  initParams(){
    this.preview_window_text = ''
    // this.webController.onInactive()
    // if(this.webController.)
    // this.webController.runJavaScript('test()')
  }
  onPageShow(){
    // 从历史列表页面进入
    if(this.existModel) {
      this.onVideoCompleted()
      this.onMeshCompleted()
    }
  }
  onVideoCompleted(){
    console.log('reverie: videoCompleted')
    this.videoUrl = Setting.SERVER_ADDR + Constants.SERVER_DOWNLOAD_VIDEO_URL + this.modelname
  }
  onMeshCompleted(){
    console.log('reverie: modelCompleted')
    this.modelCompleted = true
    this.websocket_view_size = '0%'
    if(this.displayVideo){
      this.video_view_size = '100%'
      this.mesh_view_size = '0%'
      this.preview_window_text = '视频预览'
    }
    else{
      this.mesh_view_size = '100%'
      this.video_view_size = '0%'
      this.preview_window_text = '模型预览'
    }
  }
  build() {
    Column(){
      //页面上部
      Column(){
        Row() {
          //返回按钮
          Button("返回", { stateEffect: false })
          // Button(this.test_name, { stateEffect: false })
            .width("100vp")
            .height("20vp")
            .offset({ x: "20vp", y: "0vp" })
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


        }
        .width('100%')
        .height('50%')
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.SpaceBetween)
        Row(){

          Text(this.preview_window_text)
            // .textAlign(TextAlign.Start)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#ff000000')
            .offset({ x: "10vp", y: "10vp" })
          if(this.modelCompleted == true)
          {
            Button("切换视图", { type: ButtonType.Capsule,stateEffect: true })
              .width("100vp")
              .height("40vp")
              .offset({ x: "-20vp", y: "0vp" })
                // .align(Alignment.End)

                // .backgroundImage($r('app.media.button'))
              .backgroundImageSize(ImageSize.Contain)
              .backgroundColor('#517bff')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#ffeee8e8')
              .onClick(() => {
                this.displayVideo = !this.displayVideo
                if(this.displayVideo){
                  this.video_view_size = '100%'
                  this.mesh_view_size = '0%'
                  this.preview_window_text = '视频预览'
                }
                else{
                  this.video_view_size = '0%'
                  this.mesh_view_size = '100%'
                  this.preview_window_text = '模型预览'
                }
              })}
          else{
            Text("训练中...")
              .width("100vp")
              .height("40vp")
              .offset({ x: "-20vp", y: "0vp" })
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#c7000b')
          }
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.SpaceBetween)

        Divider()
          .width("100%")
          .height("1.5vp")
          .color(Color.Gray)
          // .offset({ x: "0vp", y: "65vp" })

      }
      .height("15%")
      .width("100%")
      .alignItems(HorizontalAlign.Start) //列内左对齐
      .justifyContent(FlexAlign.SpaceBetween) //填充占满列

      // .border({ width: 3 ,color:"#517bff",radius:15})

      //页面中部
      Column(){
        //如果从历史页面进入展示页面，则不加载和维持websocket
        if(this.existModel == false){
          //从服务器上要图片,提供websocket连接，接受信号
          Web({
            src:Setting.SERVER_ADDR+Constants.SERVER_PREVIEW_IMAGES_URL,controller:this.webController
          })
            .width(this.websocket_view_size)
            .height(this.websocket_view_size)
            .onRenderExited((reason)=>{
              console.log(`Web_Render_Exited:${reason}`)
            })
            // .onPageEnd(e=>{
            // })
            // .
            .onConsole((message)=>{
              var signal = message.message.getMessage()
              this.test_name = signal
              console.log('reverie: '+signal)
              if(signal == 'videoCompleted'){
                this.onVideoCompleted()
              }
              else if(signal == 'modelCompleted'){
                this.onMeshCompleted()

              }
              return true
            })
        }
          //模型展示模块
          Web({
            src:Setting.SERVER_ADDR + Constants.SERVER_PREVIEW_URL + this.modelname,controller:this.webController
          })
            .width(this.mesh_view_size)
            .height(this.mesh_view_size)
            .onRenderExited((reason)=>{
              console.log(`Web_Render_Exited:${reason}`)
            })

          // Text("true")
          //视频展示模块
          Video({
            src:this.videoUrl
          })
            .loop(true)
            .autoPlay(true)
            .controls(false)
            .width(this.video_view_size)
            .height(this.video_view_size)
            .objectFit(ImageFit.Contain)
            .backgroundColor(Color.White)

        }


      .height("85%")
      .width("100%")
      // .border({ width: 3 ,color:"#517bff",radius:15})


    }
    .width("100%")
    .height("100%")
  }
}