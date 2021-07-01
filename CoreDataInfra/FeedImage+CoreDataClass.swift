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
final class FeedImage: NSManagedObject {
	convenience init(context: NSManagedObjectContext, local: LocalFeedImage) {
		self.init(context: context)
		self.id = local.id
		self.objectDescription = local.description
		self.location = local.location
		self.url = local.url
	}
}
