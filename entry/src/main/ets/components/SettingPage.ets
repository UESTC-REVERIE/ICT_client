import Setting from '../common/Setting';
@CustomDialog
export default struct SettingPage {
  @Link textValue: string
  @Link inputValue: string
  controller: CustomDialogController

  onCancel() {
    console.info('Callback when the first button is clicked')
  }

  onAccept() {
    Setting.SERVER_ADDR = 'http://'+this.inputValue+'/'
    console.log('Setting IP: '+Setting.SERVER_ADDR)
  }

  build() {
    Column() {
      Text('设置服务器IP和端口号').fontSize(16).margin({ top: 10, bottom: 10 })
      TextInput({ placeholder: '', text: this.textValue }).height(60).width('90%')
        .onChange((value: string) => {
          this.textValue = value
        })
      Text('例如：127.0.0.1:5000').fontSize(14).margin({top:10, bottom: 10 })
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('取消')
          .onClick(() => {
            this.controller.close()
            this.onCancel()
          }).backgroundColor(0xffffff).fontColor(Color.Black)
        Button('确认')
          .onClick(() => {
            this.inputValue = this.textValue
            this.controller.close()
            this.onAccept()
          }).backgroundColor(0xffffff).fontColor(Color.Red)
      }.margin({ bottom: 10 })
    }
  }
}
