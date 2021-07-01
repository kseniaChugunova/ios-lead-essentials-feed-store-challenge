//
//  Cache+CoreDataProperties.swift
//  FeedStoreChallenge
//
//  Created by Ksenia on 23.06.2021.
//  Copyright © 2021 Essential Developer. All rights reserved.
//
//

import Foundation
import CoreData

extension Cache {
	@NSManaged var timestamp: Date
	@NSManaged var images: NSOrderedSet
}

extension Cache {
	static func find(in context: NSManagedObjectContext) throws -> Cache? {
		let request = NSFetchRequest<Cache>(entityName: Cache.entity().name!)
		return try context.fetch(request).first
	}
}
