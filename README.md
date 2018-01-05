# Fireshot OSX App Share screenshot to Firebase & Firebase Storage

## Install CocoaPods

```
sudo gem install cocoapods --pre
```

## Run project

```
git clone https://github.com/tabvn/fireshot.git
```
```
cd fireshot
```

```
pod install
```

```
open Fireshot.xcworkspace
```

## Setup Firebase Project

Need an account to access firebase at http://firebase.google.com and setup new project then download GoogleService-Info.plist file drag to your xcode project , see in the <a href="https://www.youtube.com/watch?v=ULagU2U8mJQ">video.</a>

## Apple Security (See in video how to add this )

```
com.apple.security.temporary-exception.mach-register.global-name
com.apple.screencapture.interactive
```

## Video

https://www.youtube.com/watch?v=ULagU2U8mJQ

## Screenshot

<img src="https://raw.githubusercontent.com/tabvn/fireshot/master/screen.png" />
