import Foundation

let arguments: [String] = CommandLine.arguments
let deeplinkHelper = DeeplinkHelper()

if arguments.count > 1 {
    let link = arguments[1]
    if let url = deeplinkHelper.getDeeplinkURL(link) {
        print("The deeplink is generated!\n\(url.absoluteString)")
    } else {
        print("Failed to generate")
    }
    
} else {
    print("No arguments")
}
