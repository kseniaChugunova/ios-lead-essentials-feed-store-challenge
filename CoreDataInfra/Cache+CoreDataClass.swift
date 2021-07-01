//
//  Cache+CoreDataClass.swift
//  FeedStoreChallenge
//
//  Created by Ksenia on 23.06.2021.
//  Copyright © 2021 Essential Developer. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Cache)
final class Cache: NSManagedObject {
	convenience init(context: NSManagedObjectContext, images: [FeedImage], timestamp: Date) {
		self.init(context: context)
		self.images = NSOrderedSet(array: images)
		self.timestamp = timestamp
	}
}
