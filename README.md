# SnappyImg

[![Version](https://img.shields.io/cocoapods/v/SnappyImg.svg?style=flat)](https://cocoapods.org/pods/SnappyImg)
[![License](https://img.shields.io/cocoapods/l/SnappyImg.svg?style=flat)](https://cocoapods.org/pods/SnappyImg)
[![Platform](https://img.shields.io/cocoapods/p/SnappyImg.svg?style=flat)](https://cocoapods.org/pods/SnappyImg)

Scale, crop and optimize images on-the-fly, with all the benefits of a CDN.

SnappyImg is a swift library from [manGoweb](https://www.mangoweb.cz/) to use with https://www.snappyimg.com


## Installation

SnappyImg is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SnappyImg'
```

## Author

Martin Vytrhlík ([manGoweb](https://mangoweb.cz)), dev@mangoweb.cz

## License

SnappyImg is available under the MIT license. See the LICENSE file for more info.


## usage

You need to have `appToken` and `appSecret` in order to get correct urls. This is validated on server and prevents others from using your [SnappyImg](https://www.snappyimg.com) account. Get these on the [site](https://www.snappyimg.com).

`stage` is for demo and production url:
```swift
enum StageType {
  case demo
  case serve
}
```

decide how to resize the image
```swift
enum ResizeType {
  case fit, fill, crop   
}
```

`gravity` of image (where to focus after fill or crop)
```swift
enum Gravity {
  case north, south, east, west, center, smart
}
```

`width` an `height` is in pixels

`shouldEnlarge` lets you decide if you want to make it bigger if it is too small

and decide what `extensionType` of final image you want
```swift
enum ExtensionType {
  case jpg, png, webp
}
```


and this is the example how to use [SnappyImg](https://www.snappyimg.com) to get your image scaled, sized, cropped and in the format you need and not to think how big it was originally:
```swift
import SnappyImg

let yourImageUrlString = "https://www.snappyimg.com/demo.jpg"

let snappyImg = SnappyImg(stage: .demo, appToken: "yourAppToken", appSecret: "yourAppSecret")
        
let encodedUrlString: String? = snappyImg.encode(urlString: yourImageUrlString, 
    resizeType: .fill, 
    width: 300, 
    height: 300, 
    gravity: .smart, 
    shouldEnlarge: true, 
    extensionType: .jpg)
        
```
