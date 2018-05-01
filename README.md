YMTVersionAlert
====

This framework compares the latest application version of AppStore with the application version of the terminal and displays a warning prompting for update.

## Description
People always want to deliver the latest value, but some people do not update.  
Developers need to inform those who do not know that the latest version has been released.   
Howeverm obtaining a version from the App Store and comparing it with the version installed on the terminal is not a difficult implementation, but it will take a while.  
Therefore we created a framework to easily compare application versions and display alerts to prompt for updates.

## Installation
Just add YMTVersionAlert foloder to your project  

or use CocoaPods with Podfile:
```
pod 'YMTVersionAlert'
```

## Usage
Import 

```ViewController.swift
import YMTVersionAlert
```

Set Option Parameters

```ViewController.swift
let versionAlert = YMTVersionAlert()

//Always display an alert for Debug
//Default:false

versionAlert.setDebugFlg(true)

//Change the alert sentence to an arbitrary one
//Defaults
//Alert title : "New version released"
//Alert Body  : "To use the application comfortably please update it."
//Install Btn : "Now install"
//Later Btn   : "Later"

versionAlert.setAlertText(setTitle: "***", setBody: "***", setNowInstall: "***", setLaterInstall: "***")


```

OpenAlert  
※Run it after viewDidAppear.

```ViewController.swift
override func viewDidAppear(_ animated: Bool) {
	super.viewDidAppear(animated)
	let versionAlert = YMTVersionAlert()
	versionAlert.openVersionAlert(self, storeId: "StoreId", forceUpdate: false, callback: nil)
}
```

## Licence

[MIT](https://github.com/MasamiYamate/YMTVersionAlert/blob/master/LICENSE)
