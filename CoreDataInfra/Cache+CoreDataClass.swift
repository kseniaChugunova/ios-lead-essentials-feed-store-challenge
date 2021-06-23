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
public class Cache: NSManagedObject {
	@objc
	private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
		super.init(entity: entity, insertInto: context)
	}

	init?(context: NSManagedObjectContext, images: [FeedImage], timestamp: Date) throws {
		guard let entity = NSEntityDescription.entity(forEntityName: "Cache",
		                                              in: context) else { return nil }

		super.init(entity: entity, insertInto: context)

		self.images = NSOrderedSet(array: images)
		self.timestamp = timestamp
	}
}
