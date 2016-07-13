# KWDataSourceKit
![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20tvOS-lightgrey.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Compatible](https://img.shields.io/badge/CocoaPods-compatible-blue.svg)](https://cocoapods.org)

KWDataSourceKit is a library containing flexible data sources for `UITableView` and `UICollectionView`. It aims to slim down your view controllers be moving `UITableViewDataSource` and `UICollectionViewDataSource` to a separate object.

## Installation
> **Embedded frameworks require a minimum deployment target of iOS 8.**
>
> KWDataSourceKit is not supported on iOS 7 due to the lack of support for frameworks.

### Carthage
[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

To integrate KWDataSourceKit into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "kupferwerk/KWDataSourceKit"
```

Run `carthage update` to build the framework and drag the built `KWDataSourceKit.framework` into your Xcode project.

Using Carthage is the preferred way of integrating KWDataSourceKit into your project.

### Cocoapods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

> CocoaPods 0.39.0+ is required to build KWDataSourceKit.

To integrate KWDataSourceKit into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'KWDataSourceKit', :git => 'https://github.com/kupferwerk/KWDataSourceKit.git'
```

Then, run the following command:

```bash
$ pod install
```

## Usage

`KWDataSourceKit` aims to slim your view controllers by removing `UITableViewDataSource` and `UICollectionViewDataSource` implementations from them. There is some work to be done in your view controller however. Here is an example:

```swift
private var dataSource: ArrayDataSource<SomeTableViewCell, String>!

override func viewDidLoad() {
    super.viewDidLoad()

    dataSource = ArrayDataSource<TableViewCell, Link>(tableView: tableView) { (cell, item) in
        cell.textLabel?.text = item.title
    }

    dataSource.items = ["Lorem", "ipsum"]
    tableView.dataSource = dataSource
}
```

In this snippet of code we have initialized the `DataSource` object and configured our `UITableView` instance to use it. Depending on the specific type of data source you intend to use, setting everything up may involve some extra work.

### ArrayDataSource

`ArrayDataSource` can be used to power a `UITableView` or `UICollectionView` with a single section. It supports uniform array of *items* which you would like to display in your `UITableView` or `UICollectionView`.

### SectionedDataSource

`SectionedDataSource` is very similar to `ArrayDataSource` but has support for multiple sections. Each section can have a header and a footer. It's `items` property is an array of `Section<ItemType>`. Because of that, items need to be of the same type for all sections.

### CoreDataSource

`CoreDataSource` makes it easy to display `NSManagedObject`s retrieved from **Core Data** in an `UITableView` or `UICollectionView`. It works by utilizing Apple's `NSFetchedResultsController` and can automatically update your `UITableView` or `UICollectionView` once the data in the assigned `NSManagedObjectContext` changes. It supports multiple sections through the `sectionNameKeyPath` property.

Configuring `CoreDataSource` is a little different:

```swift
private var dataSource: CoreDataSource<TableViewCell, EntityType>!

override func viewDidLoad() {
    super.viewDidLoad()

    // The fetchRequest tells the data source which objects
    // it should load from Core Data
    let fetchRequest = NSFetchRequest(entityName: "Entity")
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

    // We initialize a `CoreDataSource` with the previously configured fetch request
    // and a `NSManagedObjectContext` that should be used to execute the fetch
    // request. Typically, this is a main queue context.
    dataSource = CoreDataSource<TableViewCell, Entity>(fetchRequest: fetchRequest,
        inContext: CoreData.sharedController.mainContext,
        tableView: tableView) { (cell, item) -> () in
            cell.textLabel?.text = item.title
    }

    // We assign it to the `UITableView`s `dataSource` property
    tableView.dataSource = dataSource

    // Tell the data source to execute the fetch request and update
    // table view
    dataSource.loadContent()
}
```

## License

```
Copyright 2016 Kupferwerk GmbH

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

**Note**: The [Configuration](Configuration/) folder contains a
third party project [xcconfigs](https://github.com/jspahrsummers/xcconfigs) and
it's README.md. The license in that [README.md](Configuration/README.md) only 
applies to the contents of the [Configuration](Configuration/)
folder that are part of [xcconfigs](https://github.com/jspahrsummers/xcconfigs).
