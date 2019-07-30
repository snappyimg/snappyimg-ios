# SnappyImg

[![CI Status](https://img.shields.io/travis/vytick/SnappyImg.svg?style=flat)](https://travis-ci.org/vytick/SnappyImg)
[![Version](https://img.shields.io/cocoapods/v/SnappyImg.svg?style=flat)](https://cocoapods.org/pods/SnappyImg)
[![License](https://img.shields.io/cocoapods/l/SnappyImg.svg?style=flat)](https://cocoapods.org/pods/SnappyImg)
[![Platform](https://img.shields.io/cocoapods/p/SnappyImg.svg?style=flat)](https://cocoapods.org/pods/SnappyImg)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

SnappyImg is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SnappyImg'
```

## Author

Martin vytick Vytrhlík, dev@mangoweb.cz

## License

SnappyImg is available under the MIT license. See the LICENSE file for more info.


## usage

You need to have `appToken` and `appSecret` in order to get correct url

`stage` is for testing and production:
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

`gravity` of image (where to focus)
```swift
enum Gravity {
  case north, south, east, west, center, smart
}
```

`width` an `height` is in pixels

`shouldEnlarge` lets you decide if you want to make it bigger if it is too small

and decide the `extensionType`
```swift
enum ExtensionType: String {
  case jpg, png, webp
}
```


and this is the example uf usage
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
