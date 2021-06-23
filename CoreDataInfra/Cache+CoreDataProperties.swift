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
	@nonobjc public class func fetchRequest() -> NSFetchRequest<Cache> {
		return NSFetchRequest<Cache>(entityName: "Cache")
	}

	@NSManaged public var timestamp: Date?
	@NSManaged public var images: NSOrderedSet?
}

// MARK: Generated accessors for images
extension Cache {
	@objc(insertObject:inImagesAtIndex:)
	@NSManaged public func insertIntoImages(_ value: FeedImage, at idx: Int)

	@objc(removeObjectFromImagesAtIndex:)
	@NSManaged public func removeFromImages(at idx: Int)

	@objc(insertImages:atIndexes:)
	@NSManaged public func insertIntoImages(_ values: [FeedImage], at indexes: NSIndexSet)

	@objc(removeImagesAtIndexes:)
	@NSManaged public func removeFromImages(at indexes: NSIndexSet)

	@objc(replaceObjectInImagesAtIndex:withObject:)
	@NSManaged public func replaceImages(at idx: Int, with value: FeedImage)

	@objc(replaceImagesAtIndexes:withImages:)
	@NSManaged public func replaceImages(at indexes: NSIndexSet, with values: [FeedImage])

	@objc(addImagesObject:)
	@NSManaged public func addToImages(_ value: FeedImage)

	@objc(removeImagesObject:)
	@NSManaged public func removeFromImages(_ value: FeedImage)

	@objc(addImages:)
	@NSManaged public func addToImages(_ values: NSOrderedSet)

	@objc(removeImages:)
	@NSManaged public func removeFromImages(_ values: NSOrderedSet)
}

extension Cache: Identifiable {}

extension Cache {
	static func find(in context: NSManagedObjectContext) throws -> Cache? {
		let request = NSFetchRequest<Cache>(entityName: "Cache")
		return try context.fetch(request).first
	}
}
