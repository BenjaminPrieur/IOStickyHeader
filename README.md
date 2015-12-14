I migrated [CSStickyHeaderFlowLayout](https://github.com/jamztang/CSStickyHeaderFlowLayout) library (Obj-C) to swift2.1


# IOStickyHeader

[![CI Status](http://img.shields.io/travis/Benjamin Prieur/IOStickyHeader.svg?style=flat)](https://travis-ci.org/Benjamin Prieur/IOStickyHeader)
[![Version](https://img.shields.io/cocoapods/v/IOStickyHeader.svg?style=flat)](http://cocoapods.org/pods/IOStickyHeader)
[![License](https://img.shields.io/cocoapods/l/IOStickyHeader.svg?style=flat)](http://cocoapods.org/pods/IOStickyHeader)
[![Platform](https://img.shields.io/cocoapods/p/IOStickyHeader.svg?style=flat)](http://cocoapods.org/pods/IOStickyHeader)

<img src="https://github.com/BenjaminPrieur/IOStickyHeader/blob/master/Example/exemple.png" width="320"/>

Parallax, Sticky Headers, Growing image heading, done right in one UICollectionViewLayout.

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

Don't forget to set your flow layout with IOStickyHeader in your storyboard

<img src="https://github.com/BenjaminPrieur/IOStickyHeader/blob/master/Example/tuto1.png"/>

Register that nib file to your collection view controller in code:

```Swift
import IOStickyHeader

  let headerNib = UINib(nibName: "IOGrowHeader", bundle: NSBundle.mainBundle())
  override func viewDidLoad() {
      super.viewDidLoad()
        
      self.collectionView.registerNib(self.headerNib, forSupplementaryViewOfKind: IOStickyHeaderParallaxHeader, withReuseIdentifier: "header")
  }
```

Implement `func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView`

```Swift
func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
    switch kind {
    case IOStickyHeaderParallaxHeader:
        let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "header", forIndexPath: indexPath) as! IOGrowHeader
        return cell
    default:
        assert(false, "Unexpected element kind")
    }
}
```

## Requirements

- Xcode 7
- Swift 2.1
- iOS 8 (I haven't really test on iOS 7 but it should work if you're using iOS 7 compatible Storyboard)

## Installation

IOStickyHeader is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
use_frameworks!
pod "IOStickyHeader"
```

## Author

Benjamin Prieur

## License

IOStickyHeader is available under the MIT license. See the LICENSE file for more info.
