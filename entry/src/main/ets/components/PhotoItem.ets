//TODO:条件渲染，长按再显示删除按钮，抖动效果
/**
 * @author:reverie
 * @description:
 * 照片选取后的展示组件
 */
@Component
export default struct PhotoItem {
  public item:string
  @Link public photoArr: Array<string>
  build() {
    Stack() {
      Image(this.item)
        .width("80vp")
        .height("80vp")
      Button()
        .width("25vp")
        .height("25vp")
        .offset({ x: "50vp", y: "-40vp" })
        .backgroundImage($r("app.media.cancel"))
        .backgroundColor(Color.Transparent)
        .backgroundImageSize(ImageSize.Contain)
        .type(ButtonType.Circle)
        .onClick(() => {
          this.photoArr.splice(this.photoArr.indexOf(this.item), 1);
          console.log(this.photoArr.length.toString())
        })

    }
    .offset({ x: 0, y: 10 })
  }
}