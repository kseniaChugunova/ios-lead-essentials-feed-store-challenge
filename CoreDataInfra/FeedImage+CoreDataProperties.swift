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

	@NSManaged public var id: UUID
	@NSManaged public var objectDescription: String?
	@NSManaged public var location: String?
	@NSManaged public var url: URL
	@NSManaged public var cache: Cache?
}

extension FeedImage: Identifiable {}

extension FeedImage {
	var local: LocalFeedImage {
		.init(id: id, description: objectDescription, location: location, url: url)
	}
}
