# Login Demo
Login demo in RxSwift for the Swift SP #1 Meetup's talk: Beyond Delegates: How to build an app with RxSwift

### Quickstart
1. Clone the repo;
1. Install all dependecies: `pod install`;
1. Use `login-rxswift.xcworkspace` when working on the project. You can do it quickly through the terminal by running: `open login-rxswift.xcworkspace`.

### Xcode
The current Xcode version being used in this project is 8.2 (8C38).

### Dependencies
This project uses Cocoapods as its dependency manager.
The current version being used is 1.1.1. For more info use this [link](https://cocoapods.org/)
If there are any issues related to the version, use this [thread](http://stackoverflow.com/questions/20487849/downgrading-or-installing-older-version-of-cocoapods), which discusses some ways to deal with it.

### Tech Stack
* RXSwift as the reactive programming library;
* RXCocoa to enhance the UIKit components so that it is easier to work in a declarative form instead of the default imperative way full of delegates;
* Snapkit, which is a DSL for autolayouting programatically.
* SwiftyJSON to make it easier to parse JSON files
* Moya as the network abstraction layer

### Argo, Runes and Curry
If you are interested on how the app network layer was implemented with these three libraries, you can roll all the way back to the genesis commit. The reason why they were removed was because the code could be quiet hard to grasp for people that are not used to them.
