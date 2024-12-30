import Setting from '../common/Setting';
@CustomDialog
export default struct ModelNamePage {
  @Link input_name_value:string
  @Link text_name_value:string
  @Link input_describe_value:string
  @Link text_describe_value:string
  @Link confirmed:string
  controller: CustomDialogController
  cancel:()=>void
  confirm:()=>void

  build() {
    Column() {
      Text('设置上传模型名称').fontSize(16).margin({ top: 10, bottom: 10 })
      TextInput({ placeholder: '', text: this.text_name_value }).height(60).width('90%')
        .onChange((value: string) => {
          this.text_name_value = value
        })
      Text('请使用英文命名').fontSize(14).margin({top:10, bottom: 10 })
      Text('填写模型描述').fontSize(16).margin({ top: 10, bottom: 10 })
      TextInput({ placeholder: '', text: this.text_describe_value }).height(60).width('90%')
        .onChange((value: string) => {
          this.text_describe_value = value
        })
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('取消')
          .onClick(() => {
            this.controller.close()
            this.cancel()
            this.confirmed = 'no'
          }).backgroundColor(0xffffff).fontColor(Color.Black)
        Button('确认')
          .onClick(() => {
            this.input_name_value = this.text_name_value
            this.input_describe_value = this.text_describe_value
            this.controller.close()
            // this.confirm()
            this.confirmed = 'yes'
          }).backgroundColor(0xffffff).fontColor(Color.Red)
      }.margin({ bottom: 10 })
    }
  }
}
