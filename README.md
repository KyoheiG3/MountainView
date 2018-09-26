![logo](https://user-images.githubusercontent.com/5707132/46053616-9256c400-c17e-11e8-955b-8b06d387302b.png)


[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/MountainView.svg?style=flat)](http://cocoadocs.org/docsets/MountainView)
[![License](https://img.shields.io/cocoapods/l/MountainView.svg?style=flat)](http://cocoadocs.org/docsets/MountainView)
[![Platform](https://img.shields.io/cocoapods/p/MountainView.svg?style=flat)](http://cocoadocs.org/docsets/MountainView)

The animation curve looks like Mountain View.

#### [Appetize's Demo](https://appetize.io/app/4gktrxnmf67ahr6tkpeut4kqvc)

## Over View

It consists of Mountain for visualizing animation and MountainView for graphing it.

![graph](https://user-images.githubusercontent.com/5707132/46053575-6a676080-c17e-11e8-8c1c-73688d5fd6e8.png)

#### Mountain

You can visualize the type and easing of the animation executed.
For example, if you execute as follows, you can output the progress in the log.

```swift
let mountain = Mountain()
UIView.animate(withDuration: 0.3) {
    mountain.climb(retainSelf: true)
        .situation {
            print($0)
        }
}
```

Execution log.

```
begin(Mountain.Information(type: "CABasicAnimation", delay: 0.0, duration: 0.29999999999999999, reverse: false, repeatCount: 0.0, function: Optional(easeInEaseOut)))
on(progress: 0.0641036704182625, curve: 0.0977618917822838)
on(progress: 0.12283568829298, curve: 0.188721746206284)
on(progress: 0.182344779372215, curve: 0.276777744293213)
on(progress: 0.243786245584488, curve: 0.363606035709381)
on(progress: 0.303644210100174, curve: 0.444229960441589)
on(progress: 0.362437427043915, curve: 0.519574403762817)
on(progress: 0.420619368553162, curve: 0.59021383523941)
on(progress: 0.481439799070358, curve: 0.659674882888794)
on(progress: 0.54224693775177, curve: 0.724372625350952)
on(progress: 0.600623190402985, curve: 0.781640827655792)
on(progress: 0.659852802753448, curve: 0.834497272968292)
on(progress: 0.718149065971375, curve: 0.880844235420227)
on(progress: 0.77815580368042, curve: 0.922019064426422)
on(progress: 0.838306427001953, curve: 0.955803155899048)
on(progress: 0.899652481079102, curve: 0.981418073177338)
on(progress: 0.958390593528748, curve: 0.99620121717453)
on(progress: 1.0, curve: 1.0)
```

Since Mountain does not depend on MountainView, it can be used by itself and is lightweight.

#### MountainView

By creating MountainView with Interface Builder, animation can be easily graphed.

```swift
@IBOutlet weak var mountainView: MountainView!

UIView.animate(withDuration: 0.3) {
    self.mountainView.climb()
}
```

## Requirements

- Swift 3.0
- iOS 9.0 or later

## How to Install

MountainView depends on Mountain.

#### CocoaPods

Add the following to your `Podfile`:

```Ruby
pod "Mountain"
```

or

```Ruby
pod "MountainView"
```

#### Carthage

Add the following to your `Cartfile`:

```Ruby
github "KyoheiG3/MountainView"
```

## Usage

### Mountain

#### Climbingable: ClimbDownable (Mountain)

Start and stop get of animation.

```swift
public func climb(retainSelf: Bool = default) -> Climber
public func climbDown()
```

Get can be interrupted by executing `climbDown`.

```swift
let mountain = Mountain()
UIView.animate(withDuration: 0.3) {
    mountain.climb(retainSelf: true)
}
mountain.climbDown()
```

#### Climber: ClimbFinishable

Get the progress of the animation.

```swift
public func situation(_ handler: @escaping (ClimbingSituation) -> Void) -> ClimbFinishable
public func filter(_ handler: @escaping (CGFloat, CGFloat) -> Bool) -> Self
public func map(_ handler: @escaping (CGFloat) -> CGFloat) -> Self
public func finish(_ handler: @escaping (ClimbingSituation) -> Void)
```

You can also filter and change the data.

```swift
let mountain = Mountain()
UIView.animate(withDuration: 0.3) {
    mountain.climb(retainSelf: true)
        .filter { progress, curve -> Bool in
            progress > 0.5
        }
        .map { curve in
            ceil(curve * 100)
        }
        .situation {
            print($0)
        }
        .finish {
            print($0)
        }
}
```

Execution log.

```
begin(Mountain.Information(type: "CABasicAnimation", delay: 0.0, duration: 0.29999999999999999, reverse: false, repeatCount: 0.0, function: Optional(easeInEaseOut)))
on(progress: 0.543500006198883, curve: 73.0)
on(progress: 0.602446019649506, curve: 79.0)
on(progress: 0.661734223365784, curve: 84.0)
on(progress: 0.72049480676651, curve: 89.0)
on(progress: 0.779515981674194, curve: 93.0)
on(progress: 0.841407358646393, curve: 96.0)
on(progress: 0.899605870246887, curve: 99.0)
on(progress: 0.961408495903015, curve: 100.0)
on(progress: 1.0, curve: 100.0)
finished
```

#### ClimbingSituation

An enum to know the progress of animation.

```swift
case begin(info: Information)
case on(progress: CGFloat, curve: CGFloat)
case cancelled
case finished
```

#### Information

It's information about animation.

```swift
public static let `default`: Information
public let type: String
public let delay: CFTimeInterval
public let duration: CFTimeInterval
public let reverse: Bool
public let repeatCount: Float
public let function: CAMediaTimingFunction?
```

#### MountainLayerDelegate

It's also possible to get the progress of the animation with the delegate method.

```swift
public func climbingSituationDidChange(_ layer: MountainLayer, situation: ClimbingSituation)
```

#### MountainLayerHaving: Climbingable

Use it when `UIView` wants to know the progress of animation by itself.

```swift
public func climb() -> Climber
public func climbDown()
```

It's necessary to prepare `MountainLayer` as follows.

```swift
class View: UIView, MountainLayerHaving {
    override class var layerClass: AnyClass {
        return MountainLayer.self
    }
    var mountainLayer: MountainLayer {
        return layer as! MountainLayer
    }
}
```

#### UIView extension

You can get progress from the animation block.

```swift
open class func animate(withDuration duration: TimeInterval, delay: TimeInterval = default, options: UIViewAnimationOptions = default, retain: Bool = default, animations: @escaping () -> Void = default, situation: @escaping (ClimbingSituation) -> Void, completion: ((Bool) -> Void)? = default) -> ClimbDownable?
open class func animate(withDuration duration: TimeInterval, delay: TimeInterval = default, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat, options: UIViewAnimationOptions = default, retain: Bool = default, animations: @escaping () -> Void = default, situation: @escaping (ClimbingSituation) -> Void, completion: ((Bool) -> Void)? = default) -> ClimbDownable?
```

### MountainView

It's a subclass of `UIView` conforming to `MountainLayerHaving`.

You can generate a MountainView with Interface Builder and graph the easing of the animation.

```swift
@IBOutlet weak var mountainView: MountainView!

UIView.animate(withDuration: 0.3) {
    self.mountainView.climb()
}
```

<img width="322" alt="screen" src="https://user-images.githubusercontent.com/5707132/46053627-a0a4e000-c17e-11e8-86e3-1d3bf84df6fd.png">

## LICENSE

Under the MIT license. See LICENSE file for details.
