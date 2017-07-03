# letterboxd-api-ios
API example client and request signing cocoapod for iOS.

## Request Signing Pod
The cocoapod can be integrated into your project by adding:
`pod 'LetterboxdRequestSigning', :git => 'https://github.com/ryanmaxwell/letterboxd-api-ios'` to your Podfile.

## Example project
Clone project, `cd` into Example directory and run `pod install`. There are unit tests showing unauthenticated API usage, signing in, and authenticated API usage. 
The example project uses standard URLSession based APIs in Swift.