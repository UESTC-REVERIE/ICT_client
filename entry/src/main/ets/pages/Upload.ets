import router from '@ohos.router';
import Constants from '../common/Constants';
import picker from '@ohos.file.picker';
import request from '@ohos.request';
import common from '@ohos.app.ability.common';
import fs from '@ohos.file.fs';
import http from '@ohos.net.http';
import Setting from '../common/Setting';
import PhotoItem from '../components/PhotoItem'
import SettingPage from '../components/SettingPage'
import ModelName from '../components/ModelName';
import systemDateTime from '@ohos.systemDateTime';
let context = getContext(this) as common.UIAbilityContext;

@Entry
@Component
struct Upload {
  @State photoArr: Array<string> = [];
  @State schedule:number = 0;
  //Setting
  @State textValue: string = ''
  @State inputValue: string = ''
  @State input_name_value:string = ''
  @State text_name_value:string = ''
  @State input_describe_value:string =''
  @State text_describe_value:string = ''
  @State filename_confirm:string = ''
  @State is_upload_button_able:boolean = true
  current_time:string = ''
  dialogController: CustomDialogController = new CustomDialogController({
    builder: SettingPage({
      textValue: $textValue,
      inputValue: $inputValue
    }),
    cancel: this.existApp,
    autoCancel: true,
    alignment: DialogAlignment.Default,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    customStyle: false
  })
  existApp() {
    console.info('Click the callback in the blank area')
  }

  filenameController: CustomDialogController  = new CustomDialogController({
    builder: ModelName({
      input_name_value : $input_name_value,
      text_name_value : $text_name_value,
      input_describe_value : $input_describe_value,
      text_describe_value : $text_describe_value,
      confirmed: $filename_confirm,
      cancel:this.onCancel,
      // confirm:()=>{},
    }),
    autoCancel: true,
    alignment: DialogAlignment.Default,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    customStyle: false
  })
  onCancel(){
    console.info("cancel")
  }
  // onAccept(){
  //   this.pushImage()
  // }
  aboutToDisappear() {
    delete this.dialogController,
    this.dialogController = undefined
  }

  async wait_for_filename_confirm_and_push(){
    while(this.filename_confirm == ''){
      await new Promise((resolve) => {
        setTimeout(() => {
          resolve('Hello, world!');
        }, 1000);
      });
    }
    if(this.filename_confirm = 'yes'){
      systemDateTime.getDate().then(date => {
        //去除时区信息
        this.current_time = date.toString().slice(0,-8)
        this.pushImage()
        console.log('reverie: '+"pushImage once")
      })
      this.is_upload_button_able = false
    }
    this.filename_confirm = ''
  }

  initParams(){
    this.photoArr = []
    this.schedule = 0
    this.filename_confirm = ''
    this.is_upload_button_able = true
  }
  // onDisAppear()
  /*
   *上传完成，Http Request通知服务器开始推演
   * URL:/calculate
   * */
  // completeUpload(){
  //   console.log('finished')
  //   // 每一个httpRequest对应一个HTTP请求任务，不可复用
  //   let httpRequest = http.createHttp();
  //   // 用于订阅HTTP响应头，此接口会比request请求先返回。可以根据业务需要订阅此消息
  //   // 从API 8开始，使用on('headersReceive', Callback)替代on('headerReceive', AsyncCallback)。 8+
  //   httpRequest.on('headersReceive', (header) => {
  //     console.info('header: ' + JSON.stringify(header));
  //   });
  //   httpRequest.request(
  //     // 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。请求的参数可以在extraData中指定
  //     Setting.SERVER_ADDR + Constants.SERVER_CALCULATE_URL,
  //     {
  //       method: http.RequestMethod.POST, // 可选，默认为http.RequestMethod.GET
  //       // 开发者根据自身业务需要添加header字段
  //       header: {
  //         'Content-Type': 'application/json'
  //       },
  //       // 当使用POST请求时此字段用于传递内容
  //       extraData: {
  //         // "data": "data to send",
  //       },
  //       expectDataType: http.HttpDataType.STRING, // 可选，指定返回数据的类型
  //     }, (err, data) => {
  //     if (!err) {
  //       // data.result为HTTP响应内容，可根据业务需要进行解析
  //       console.info('Result:' + JSON.stringify(data.result));
  //       console.info('code:' + JSON.stringify(data.responseCode));
  //       // data.header为HTTP响应头，可根据业务需要进行解析
  //       console.info('header:' + JSON.stringify(data.header));
  //       console.info('cookies:' + JSON.stringify(data.cookies));
  //     } else {
  //       console.info('error:' + JSON.stringify(err));
  //       // 取消订阅HTTP响应头事件
  //       httpRequest.off('headersReceive');
  //       // 当该请求使用完毕时，调用destroy方法主动销毁
  //       httpRequest.destroy();
  //     }
  //   }
  //   );
  // }
  http_new_serve_task(){
    let httpRequest = http.createHttp();
    httpRequest.request(
      // 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。请求的参数可以在extraData中指定
      Setting.SERVER_ADDR + Constants.SERVER_NEW_TASK + this.input_name_value,
      {
        method: http.RequestMethod.POST, // 可选，默认为http.RequestMethod.GET
        // 开发者根据自身业务需要添加header字段
        header: {
          'Content-Type': 'application/json'
        },
        extraData: {
          "alias":this.input_describe_value.toString(),
          "date":this.current_time.toString(),
          "totalImages":this.photoArr.length.toString()
        },
        expectDataType: http.HttpDataType.STRING, // 可选，指定返回数据的类型
      }, (err, data) => {
      if (!err) {
        console.log('reverie: ' + 'start new task' + data.result)
      } else {
        console.info('error:' + JSON.stringify(err));
        // 取消订阅HTTP响应头事件
        httpRequest.off('headersReceive');
        // 当该请求使用完毕时，调用destroy方法主动销毁
        httpRequest.destroy();
      }
    }
    );
  }
  pushImage() {
    this.http_new_serve_task()
    console.log('reverie: Pushing Image');
    this.schedule = 0;
    let cacheDir = context.cacheDir;
    // 上传任务配置项

    // 将本地应用文件上传至网络服务器
    let index = 0;
    // 遍历选中的每张图片，并上传
    this.photoArr.forEach(url => {
      console.log(url)
      let filename = index.toString() + '.jpg'
      let file = fs.openSync(url, fs.OpenMode.CREATE);
      fs.copyFileSync(file.fd, cacheDir + '/'+ filename);
      console.log(cacheDir + '/'+ filename)
      this.submitImage(filename);
      index++;
    });


  }
  /*
   * 从当前文件缓存，通过Http Request提交图片
   * URL:/upload/<string:model_name>
   * 包括进度条逻辑
   * */
  submitImage(filename : string){
    let uploadConfig = {
      url: Setting.SERVER_ADDR + Constants.SERVER_UPLOAD_URL + '/'  + this.input_name_value,

      header: { key1: 'Content-Type', key2: 'multipart/form-data' },
      method: 'POST',
      files: [
        { filename: filename, name: 'file', uri: 'internal://cache/'+filename, type: 'jpg' }
      ],
      data: [
        { name: 'alias', value: this.input_describe_value},
        { name: 'date', value: this.current_time},
        { name: 'totalImages', value: this.photoArr.length.toString()}
      ]
    }
    console.log('reverie: http request to: '+Setting.SERVER_ADDR + Constants.SERVER_UPLOAD_URL + '/'  + this.input_name_value)
    try {
      request.uploadFile(context, uploadConfig)
        .then((uploadTask) => {
          //每次上传任务完成时
          uploadTask.on('complete', (taskStates) => {
            // 这里由于uploadConfig中只添加了一个图片文件，遍历图片的过程在pushImage中完成，所以taskStates应该恒为1
            for (let i = 0; i < taskStates.length; i++) {
              console.info(`xx upload complete taskState: ${JSON.stringify(taskStates[i])}`);
              //每张图片上传完成，进度条加一
              this.schedule++;
              if(this.schedule === this.photoArr.length - 3){
                // 跳转页面
                router.pushUrl({
                  url: 'pages/Show',
                  params:
                  {
                    modelname:this.input_name_value,
                    state:false
                  }


                });
                this.initParams()

                // this.completeUpload()
              }
            }
          });
        })
        .catch((err) => {
          console.error(`xx Invoke uploadFile failed, code is ${err.code}, message is ${err.message}`);
        })
      console.log("UPLOADED")
    } catch (err) {
      console.error(`xx Invoke uploadFile failed, code is ${err.code}, message is ${err.message}`);

    }

  }

  build() {
    Column(){
      //页面上部
      Column(){
        Row(){
          //返回按钮
          Button("返回",{stateEffect:false})
            .width("25%")
            .height("20vp")
            .offset({ x: "-70vp", y: "0vp" })
            .backgroundImage($r('app.media.return'))
            .backgroundImageSize(ImageSize.Contain)
            .backgroundColor(Color.Transparent)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#C00000')
            .onClick(()=>{
              router.pushUrl({url:'pages/Index'});
              this.initParams()
            })
          //设置按钮
          Button("设置",{stateEffect:false})
            .width("25%")
            .height("25vp")
            .offset({ x: "100vp", y: "0vp" })
            .backgroundImage($r('app.media.setting'))
            .backgroundImageSize(ImageSize.Contain)
            .backgroundColor(Color.Transparent)
            .fontSize(18)
            .fontColor('#2E75B6')
            .fontWeight(FontWeight.Bold)
            .onClick(()=>{
              if (this.dialogController != undefined) {
                this.dialogController.open()
              }
            })
        }
        .offset({ x: "0vp", y: "-30vp" })

        Text("待上传图像 - " + this.photoArr.length.toString())
          .fontSize(18)
          .offset({ x: "-105vp", y: "20vp" })
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Start)
        Divider()
          .width("100%")
          .height("1.5vp")
          .color(Color.Gray)
          .offset({ x: "0vp", y: "35vp" })
      }
      .height("20%")
      .width("100%")
      .justifyContent(FlexAlign.Center)

      //页面中部
      Column(){
        Grid(){
          ForEach(this.photoArr,(photo:string)=>{
            GridItem(){
              PhotoItem({ item:photo,photoArr:$photoArr })
            }
          },(item: string, index?: number) => JSON.stringify(item) + index)
        }
        .columnsTemplate(Constants.GRID_COLUMNS_TEMPLATE)
        .rowsGap(Constants.LIST_ITEM_SPACE)
      }
      .height("60%")
      .width("100%")
      //页面下部
      Column(){
        Row(){
          Button()
            .width("50vp")
            .height("50vp")
            .type(ButtonType.Circle)
            .offset({ x: "275vp", y: "0vp" })
            .backgroundImage($r('app.media.upload'))
            .backgroundImageSize(ImageSize.Contain)
            .backgroundColor(Color.Transparent)
            .onClick(()=>{
              console.log("----UPLOAD-----")
              let uris :Array<string> = [];
              let photoSelectOptions = new picker.PhotoSelectOptions();
              photoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE;
              photoSelectOptions.maxSelectNumber = Constants.MAX_SELECT_IMAGES_ONCE;
              let photoPicker = new picker.PhotoViewPicker();
              photoPicker.select(photoSelectOptions)
                .then((photoSelectResult)=>{
                  uris = photoSelectResult.photoUris;
                  this.photoArr = this.photoArr.concat(uris)
                })
                .catch((err) => {
                  console.log('reverie: PhotoViewPicker.select failed with err: ' + err);
                  return err;
                })
            })
          Button("上传")
            .width("100vp")
            .height("50vp")
            .type(ButtonType.Capsule)
            .offset({ x: "80vp", y: "0vp" })
              // .offset({ x: "0vp", y: "0vp" })
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#ffeee8e8')
            .backgroundImageSize(ImageSize.Contain)
            .enabled(this.is_upload_button_able)
            .onClick(()=>{
              console.log("开始上传")

              if (this.filenameController != undefined) {
                this.filenameController.open()
              }
              this.wait_for_filename_confirm_and_push()
            })
          Progress({ value: this.schedule, total: this.photoArr.length, type: ProgressType.Linear })
            .width("80%")
            .height(20)
            .offset({ x: "-110vp", y: "-50vp" })
        }
        .width("100%")
        .height("100%")
      }
      .height("20%")
      .width("100%")

    }
    .width("100%")
    .height("100%")
  }
}