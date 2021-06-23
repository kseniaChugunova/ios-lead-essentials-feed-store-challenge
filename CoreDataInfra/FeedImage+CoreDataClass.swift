//
//  FeedImage+CoreDataClass.swift
//  FeedStoreChallenge
//
//  Created by Ksenia on 23.06.2021.
//  Copyright © 2021 Essential Developer. All rights reserved.
//
//

import Foundation
import CoreData

@objc(FeedImage)
public class FeedImage: NSManagedObject {
	@objc
	private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
		super.init(entity: entity, insertInto: context)
	}

	init?(context: NSManagedObjectContext, local: LocalFeedImage) throws {
		guard let entity = NSEntityDescription.entity(forEntityName: "FeedImage",
		                                              in: context) else { return nil }

		super.init(entity: entity, insertInto: context)

		self.id = local.id
		self.objectDescription = local.description
		self.location = local.location
		self.url = local.url
	}
}
