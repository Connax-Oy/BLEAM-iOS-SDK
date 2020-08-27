# BLEAM-iOS-SDK
Bluetooth Low Energy Authentication Module SDK for iOS

### IMPORTANT: This SDK may have issues with bluetooth connections from BLESc. We're working hard to resolve this issue as soon as possible.

## Installation

**Carthage**

Are not supported yet

**CocoaPods**

Are not supported yet

**SPM**

Is not supported yet

**Manually**

Download this repo, unzip BLEAM.framework.zip and put it into your $(PROJECT_DIR)

## Integration

Add

```swift
import BLEAM
```

to get access to SDK components.

Then configure BLEAM by writing in `application(_:didFinishLaunchingWthOptions:)` following code:

```swift
Configuration(companyID: "<your-company-id>", appID: "<your-app-id>", appSecret: "<your-app-secret>").makeCurrent()
```

**Note:** For now `companyID` parameters can have any value you want 

Optionally you can pass `UserIDProvider` and location for SQLite storage that's used by CoreData.

`Factory` provides you access to all other components available in SDK.

Use `GeofencesSynchronizationService` to manage synchronization of geofences in your app. 
You probably need to make first synchronization after app is launched. 
So, write in `application(_:didFinishLaunchingWthOptions:)`

```swift
let syncService = Factory().makeSynchronizationService()
syncService.synchronizeGeofences { result in
   // If result is success, start monitoring
}
```

Next synchronization will be available after 24 hours. You are able to use background fetching to keep your 
app fresh. So, add *Background Modes* capability to your app and enable *Background fetch*. Then use 
`BackgroundTasks` framework in iOS 13 and higher, or implement
 `application(_:performFetchWithCompletionHandler:)` for iOS versions lower than 13.
 
 ```swift
 geofencesSynchronizationService.synchronizeGeofences { result in
    switch result {
       case .success(true):
          completion(.newData)
       case .success(false):
          completion(.noData)
       case .failure:
          completion(.failed)
    }
 }
 ```

`GeofencesMonitoringService` allows you to start and stop monitoring of geofences. You should start 
monitoring in `application(_:didFinishLaunchingWthOptions:)` function.  Probably you want to do it after 
first synchronization.
 
 ```swift
 let monitoringService = Factory().makeMonitoringService()
 monitoringService.startMonitoring(with: launchOptions)
 ```
 
 You're also allowed to add delegate to this service.
 
 ```swift
 monitoringService.addDelegate(<object-you-want-to-use-as-delegate>, delegateQueue: <q>)
 ```
 
 To allow this service work properly, enable *Location updates* in *Background Modes* capability.
 
 The next component allows you to do what it all started for. It's `AccessoryService` that works with BLE. You 
 need to enable *Acts as Bluetooth LE accessory* in *Background Modes* capability. Firstly, add delegate to this
 service. It should be done before service will start.
 
 ```swift
 let accessoryService = Factory().makeAccessoryService()
 accessoryService.delegate = <delegate>
 ```
 
 Service will be started automatically when user will enter geofence satisfying some conditions and stopped 
 upon exit one. In some circumstances you may need to start or stop accessory service manually, so use 
 following functions:
 
 ```swift
 accessoryService.startAdvertising(geofenceID: "<your-geofence-id>")
 accessoryService.stopAdvertising()
 ```
 
 That's it!
