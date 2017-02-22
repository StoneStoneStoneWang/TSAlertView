# TSAlertView
关门动画的原理
1.view 转 image
static func getImageWithView(view: UIView) -> UIImage? {
UIGraphicsBeginImageContextWithOptions(view.size, false, UIScreen.mainScreen().scale /* 当前屏幕的分辨率*/)

guard let ctx = UIGraphicsGetCurrentContext() else {

return nil
}

view.layer.renderInContext(ctx)

let image = UIGraphicsGetImageFromCurrentImageContext()

UIGraphicsEndImageContext()

return image
}

2.截图 
static func getImageWithImage(image: UIImage,rect: CGRect) -> UIImage {

let scale = UIScreen.mainScreen().scale

let x = rect.origin.x * scale

let y = rect.origin.y * scale

let wid = rect.size.width * scale

let hei = rect.size.height * scale

let re = CGRectMake(x, y, wid, hei)

let ref = image.CGImage

let newRef = CGImageCreateWithImageInRect(ref!, re)

return UIImage(CGImage: newRef!, scale: scale, orientation: .Up)

}

3. 加入layer层动画
@objc private func closeDoor() {

let image = UIImage.getImageWithView(contentView)

let contentView_Width: CGFloat = TS_Screen_Width - 2 * margin

let leftRect = CGRectMake(0, 0, image!.size.width / 2, image!.size.height)

let leftImage = UIImage.getImageWithImage(image!, rect: leftRect)

let rightRect = CGRectMake(contentView_Width / 2, 0, contentView_Width / 2, contentView.height)

let rightImage = UIImage.getImageWithImage(image!, rect: rightRect)

leftImageView.image = leftImage

rightImageView.image = rightImage

contentView.hidden = true

let leftImageViewAnimation = CABasicAnimation(keyPath: "transform.rotation.y")

leftImageView.layer.anchorPoint = CGPointMake(0, 0.5)

leftImageViewAnimation.duration = 0.5

leftImageViewAnimation.fromValue = M_PI / 2

leftImageViewAnimation.toValue = 0

leftImageViewAnimation.repeatCount = 1

leftImageView.frame = CGRectMake(margin, contentView.y, contentView_Width / 2,contentView.height )

addSubview(leftImageView)

leftImageView.layer.addAnimation(leftImageViewAnimation, forKey: nil)

let rightImageViewAnimation = CABasicAnimation(keyPath: "transform.rotation.y")

rightImageView.layer.anchorPoint = CGPointMake(1, 0.5)

rightImageViewAnimation.duration = 0.5

rightImageViewAnimation.fromValue = -M_PI / 2

rightImageViewAnimation.toValue = 0

rightImageViewAnimation.repeatCount = 1

rightImageView.frame = CGRectMake(margin + contentView_Width / 2, contentView.y, contentView_Width / 2,contentView.height )

rightImageView.backgroundColor = UIColor.purpleColor()

addSubview(rightImageView)

rightImageView.layer.addAnimation(rightImageViewAnimation, forKey: nil)

}
