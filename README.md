I migrated [CSStickyHeaderFlowLayout](https://github.com/jamztang/CSStickyHeaderFlowLayout) library (Obj-C) to swift3.0


# IOStickyHeader

[![CI Status](http://img.shields.io/travis/BenjaminPrieur/IOStickyHeader.svg?style=flat)](https://travis-ci.org/BenjaminPrieur/IOStickyHeader)
[![Version](https://img.shields.io/cocoapods/v/IOStickyHeader.svg?style=flat)](http://cocoapods.org/pods/IOStickyHeader)
[![License](https://img.shields.io/cocoapods/l/IOStickyHeader.svg?style=flat)](http://cocoapods.org/pods/IOStickyHeader)
[![Platform](https://img.shields.io/cocoapods/p/IOStickyHeader.svg?style=flat)](http://cocoapods.org/pods/IOStickyHeader)
[![](https://img.shields.io/badge/Carthage-Compatible-green.svg)](http://cocoapods.org/pods/IOStickyHeader)

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

- Swift 4.2
- iOS 9

## Installation

### CococaPods
IOStickyHeader is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
use_frameworks!
pod "IOStickyHeader"
```

### Carthage
[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate IOStickyHeader into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "BenjaminPrieur/IOStickyHeader"
```

Run `carthage update` to build the framework and drag the built `IOStickyHeader.framework` into your Xcode project.

## Author

Benjamin Prieur

## License

IOStickyHeader is available under the MIT license. See the LICENSE file for more info.
