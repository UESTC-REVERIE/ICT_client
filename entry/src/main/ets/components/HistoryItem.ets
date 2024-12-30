/**
 * @author:reverie
 * @description:
 * 用于显示历史记录项
 */
import router from '@ohos.router'
import Constants from '../common/Constants'
import Setting from '../common/Setting'
@Component
export default struct HistoryItem {
  public itemName:string = ''
  public alias:string = ''
  public createDate:string = ''
  public totalImages:string = ''
  public imageUrl:string | Resource = ''

  build() {
    Row() {
      Column() {
        Image(this.imageUrl)
          .objectFit(ImageFit.Cover).margin(10) // 保持宽高比进行缩小或者放大，使得图片完全显示在显示边界内。
          // .border({ width: 1 })
          .border({radius: 15 })
          // .margin(10)

          // .height("50%")
        // Text(this.itemName)
        //   .fontSize("18")
        //   .textAlign(TextAlign.Center)
        //   .fontColor("#c7000b")
      }
      .height("100%")
      .width("30%")

      Column() {
        Text(this.itemName)
          .height("30%")
          .width("100%")
          .textAlign(TextAlign.Center)
          .fontSize(20)
          .padding(4)
        // .border({ width: 1 })
        // Divider()
        //   .color(Color.Gray)
        //   .height("1%")
        Text(this.alias)
          // .offset({y:"20%"})
          .height("50%")
            // .border({ width: 1 })
          .width("100%")
          .textOverflow({ overflow: TextOverflow.Clip })
          .textAlign(TextAlign.Center)
          .fontColor(Color.Gray)
          .fontSize(14)
          .padding(4)

        Row(){
          Text("图片数量："+this.totalImages)
            // .offset({y:"20%"})
            .height("100%")
              // .border({ width: 1 })
            // .width("100%")
            // .textAlign(TextAlign.Center)
            .fontColor(Color.Gray)
            .fontSize(8)
            .padding(4)
          Text("创建时间："+this.createDate)
            // .offset({y:"20%"})
            .height("100%")
              // .border({ width: 1 })
            // .width("100%")
            // .textAlign(TextAlign.Center)
            .fontColor(Color.Gray)
            .fontSize(8)
            .padding(4)
        }

        .height('20%')
        .width('100%')
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.SpaceEvenly)

      }
      .width("50%")
      .height("100%")
      .alignItems(HorizontalAlign.Center)
      // .justifyContent(FlexAlign.Start)
      // .border({ width: 1 })
      // .offset({y:"20%"})
      Column() {
        // Text("跳转按钮")
        Button("", { stateEffect: false })
          .width("100%")
          .height("20vp")
          .offset({ x: "30vp", y: "40%" })
          .backgroundImage($r('app.media.seemore'))
          .backgroundImageSize(ImageSize.Contain)
          .backgroundColor(Color.Transparent)
          .fontSize(8)
          .fontWeight(FontWeight.Bold)
          .fontColor('#C00000')
          .onClick(() => {

            router.pushUrl({
              url: 'pages/Show',
              params: {
                modelname: this.itemName,
                state: true
              }
            })

          })
      }
      .width("20%")
      .height("100%")
    }
    .height("20%")
    .margin("2%")
    .border({ width: 3, color: "#517bff", radius: 10 })
  }
}