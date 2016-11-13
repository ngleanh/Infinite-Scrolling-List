# Infinite Scrolling List View

The purpose of this example is to demonstrate an infinite list view, which can handle memory effectively when having large unit of model. 

Some challenges in this example:
  - Swift is commonly using struct on model, which can not adapt NSCoding for data persistent.
  - Multi-thread handling
  - Unidirectional data flow for data consistency.

I decided to use Realm database for data persistent and manager data flow. The Realm API is [optimized for performance and low memory use](https://realm.io/news/realm-api-optimized-for-performance-and-low-memory-use/), which is very great for project's requirement.

Open source libraries are being using in the example:
  - [Alamofire](https://github.com/Alamofire/Alamofire) for network data fetching
  - [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) for data parsing
  - [RealmSwift](https://github.com/realm/realm-cocoa) for data persistent and manage data flow.
