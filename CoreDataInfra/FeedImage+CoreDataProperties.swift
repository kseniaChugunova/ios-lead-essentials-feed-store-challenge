//
//  FeedImage+CoreDataProperties.swift
//  FeedStoreChallenge
//
//  Created by Ksenia on 23.06.2021.
//  Copyright © 2021 Essential Developer. All rights reserved.
//
//

import Foundation
import CoreData

extension FeedImage {
	@nonobjc public class func fetchRequest() -> NSFetchRequest<FeedImage> {
		return NSFetchRequest<FeedImage>(entityName: "FeedImage")
	}

	@NSManaged var id: UUID
	@NSManaged var objectDescription: String?
	@NSManaged var location: String?
	@NSManaged var url: URL
	@NSManaged var cache: Cache?
}

extension FeedImage {
	var local: LocalFeedImage {
		.init(id: id, description: objectDescription, location: location, url: url)
	}
}
