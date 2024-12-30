import router from '@ohos.router';
import webview from '@ohos.web.webview';
import http from '@ohos.net.http';
import Constants from '../common/Constants';
import Setting from '../common/Setting';
import HistoryItem from '../components/HistoryItem';
import SettingPage from '../components/SettingPage';
import Fetch from '@system.fetch';
@Entry
@Component
struct Index {
  @State textValue: string = ''
  @State inputValue: string = ''
  webController: webview.WebviewController = new webview.WebviewController()
  //接受返回的JSON数据
  @State requestData: {[key:string]:{[key:string]:string}}[]= []
  // @State requestData: {[key:string]:{[key:string]:string}}[]= [
  //   {
  //     "myName1":{
  //       "alias":"myAlias",
  //       "date":"currentDate",
  //       "totalImages":"999"
  //     }
  //   },
  //   {
  //     "myName2":{
  //       "alias":"myAlias",
  //       "date":"currentDate",
  //       "totalImages":"999"
  //     }
  //   }
  // ]

  dialogController: CustomDialogController = new CustomDialogController({
    builder: SettingPage({
      textValue: $textValue,
      inputValue: $inputValue
    }),
    autoCancel: true,
    alignment: DialogAlignment.Default,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    customStyle: false
  })
  // onPageShow(){
  //   let json_data = '{"name": {"alias": "test", "date": "2022-2-2"}, "name2": {"alias": "test2", "date": "2022-3-3"}}';
  //   let parsedData = JSON.parse(json_data.toString())
  //   this.requestData = Object.keys(parsedData).map((key) => {
  //     return {[key]: parsedData[key]};
  //   });
  //
  //   this.requestData.forEach(item => {
  //     const name = Object.keys(item)[0];
  //     console.log("reverie1: "+name)
  //     // Object.keys(item[name]).forEach((innerKey) => {
  //     //   console.log(` ${innerKey}: ${item[name][innerKey]}`);
  //     // });
  //     console.log("reverie2: "+item[name]['alias'])
  //     console.log("reverie3: "+item[name]['date'])
  //     console.log("reverie4: "+item[name]['totalImages'])
  //   });
  //
  // }

  onPageShow() {
    let httpRequest = http.createHttp();
    httpRequest.request(
      // 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。请求的参数可以在extraData中指定
      Setting.SERVER_ADDR + Constants.SERVER_HISTORY_LIST,
      {
        method: http.RequestMethod.GET, // 可选，默认为http.RequestMethod.GET
        expectDataType: http.HttpDataType.STRING, // 可选，指定返回数据的类型
      },
      (err, data) => {
      if (!err) {
        // JSON.parse(this.requestData)
        // 解析得到JSONObject
        // this.requestData = JSON.parse(data.result.toString())
        console.log('reverie http request: '+data.result.toString())
        let parsedData = JSON.parse(data.result.toString())
        this.requestData = Object.keys(parsedData).map((key) => {
          return {[key]: parsedData[key]};
        });
        // data.result为HTTP响应内容，可根据业务需要进行解析
        console.log('reverie Result:' + JSON.stringify(data.result));
        console.info('code:' + JSON.stringify(data.responseCode));
        // data.header为HTTP响应头，可根据业务需要进行解析
        console.info('header:' + JSON.stringify(data.header));
        console.info('cookies:' + JSON.stringify(data.cookies));
      } else {
        console.log('reverie error:' + JSON.stringify(err));
        // 取消订阅HTTP响应头事件
        httpRequest.off('headersReceive');
        // 当该请求使用完毕时，调用destroy方法主动销毁
        httpRequest.destroy();
      }
    }
    )

  }

  build() {
    Column(){
      //页面上部
      Column(){
        //标题行
        Row(){
          Image($r('app.media.title_0'))
            .objectFit(ImageFit.Contain)
            // .border({ width: 3 ,color:"#517bff",radius:15})
            .width('35%')

          Web({
            src:Setting.SERVER_ADDR + Constants.SERVER_PREVIEW_URL + 'icon',controller:this.webController
          })
            .height('100%')
            .width('30%')
            .horizontalScrollBarAccess(false)


          Image($r('app.media.title_1'))
            .objectFit(ImageFit.Contain)
            // .border({ width: 3 ,color:"#517bff",radius:15})
            // .width('30%')
            .height('30%')

            // .width(this.mesh_view_size)
            // .height(this.mesh_view_size)


        }
        .width('100%')
        .height('80%')
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
        //头像行
        Row() {
          Image($r('app.media.avatar_0'))
            .objectFit(ImageFit.Contain)
            .margin(2)
            .border({radius: 15 })
            // .border({ width: 3, color: "#517bff", radius: 15 })
          Image($r('app.media.avatar_1'))
            .objectFit(ImageFit.Contain)
            .margin(2)
            .border({radius: 15 })
          Image($r('app.media.avatar_2'))
            .objectFit(ImageFit.Contain)
            .margin(2)
            .border({radius: 15 })
        }
        .offset({ x: "5vp", y: "0vp" })
        .width('10%')
        .height('20%')
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.SpaceEvenly)


        // .border({ width: 3 ,color:"#517bff",radius:15})


        Divider()
          .width("100%")
          .height("1.5vp")
          .color(Color.Gray)
      }
      .height("20%")
      .width("100%")
      .alignItems(HorizontalAlign.Start) //列内左对齐
      .justifyContent(FlexAlign.SpaceBetween) //填充占满列

      // .border({ width: 3 ,color:"#517bff",radius:15})

      //页面中部
      List(){
        // ListItem(){
        //   HistoryItem({itemName:'test',alias:'alias',createDate:'2000-2-2',imageUrl:Setting.SERVER_ADDR + Constants.SERVER_HISTORY_ICON + 'test'})
        // }
        ForEach(this.requestData,(item,index)=>{
          ListItem(){
            HistoryItem({
              itemName:Object.keys(item)[0],
              alias:item[Object.keys(item)[0]]['alias'],
              createDate:item[Object.keys(item)[0]]['date'],
              totalImages:item[Object.keys(item)[0]]['totalImages'],
              imageUrl:Setting.SERVER_ADDR + Constants.SERVER_HISTORY_ICON + Object.keys(item)[0]
            })
          }
        })

      }
      .width("100%")
      .height("60%")
      .scrollBar(BarState.Auto)
      Divider()
        .width("100%")
        .height("1.5vp")
        .color(Color.Gray)
      //页面下部
      Row(){
        // Button("新建模型", { stateEffect: false })
        //   .width("50%")
        //   .height("40%")
        //   .offset({ x: "10vp", y: "10vp" })
        //   .backgroundImage($r('app.media.upload'))
        //   .backgroundImageSize(ImageSize.Contain)
        //   .backgroundColor(Color.Transparent)
        //   .fontSize(18)
        //   .fontWeight(FontWeight.Bold)
        //   .fontColor('#C00000')
        //   .onClick(() => {
        //     router.pushUrl({ url: 'pages/Upload' });
        //   })
        Button("新建模型")
          .width("125vp")
          .height("50vp")
          .type(ButtonType.Capsule)
          .offset({ x: "0vp", y: "0vp" })
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#ffeee8e8')
          .backgroundImageSize(ImageSize.Contain)
          .backgroundColor('#ff199403')
          .onClick(()=>{
              router.pushUrl({ url: 'pages/Upload' });
          })
        Button()
          .width("40vp")
          .height("40vp")
          .offset({ x: "50vp", y: "0vp" })
          .backgroundImage($r('app.media.setting_black'))
          .backgroundImageSize(ImageSize.Contain)
          .backgroundColor(Color.Transparent)
          .onClick(()=>{
            if (this.dialogController != undefined) {
              this.dialogController.open()
            }
          })
      }
      .height("20%")
      .width("100%")
      .offset({ x: "15vp", y: "-5vp" })
      .justifyContent(FlexAlign.Center)

      // .alignItems(HorizontalAlign.Center)
    }
    .width("100%")
    .height("100%")
  }
}