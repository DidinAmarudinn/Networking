import UIKit
import SystemConfiguration

func isNEtworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    let canConnectAutmatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
    let canConnectWithoutUserInteraction = canConnectAutmatically && !flags.contains(.interventionRequired)
    return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
}

let reachability = SCNetworkReachabilityCreateWithName(nil, "www.dicoding.com")
var flags = SCNetworkReachabilityFlags()
SCNetworkReachabilityGetFlags(reachability!, &flags)

if !isNEtworkReachable(with: flags) {
    print("DEvice doesn't have internet connection")
} else {
    print("Host www.dicoding.com is reachable")
}

#if os(iOS)
if flags.contains(.isWWAN) {
    print("Device is using mobile data")
}
#endif
