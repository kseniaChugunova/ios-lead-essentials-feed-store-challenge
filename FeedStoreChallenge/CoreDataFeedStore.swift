//
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import CoreData

public final class CoreDataFeedStore: FeedStore {
	private static let modelName = "FeedStore"
	private static let model = NSManagedObjectModel(name: modelName, in: Bundle(for: CoreDataFeedStore.self))

	private let container: NSPersistentContainer
	private let context: NSManagedObjectContext

	struct ModelNotFound: Error {
		let modelName: String
	}

	public init(storeURL: URL) throws {
		guard let model = CoreDataFeedStore.model else {
			throw ModelNotFound(modelName: CoreDataFeedStore.modelName)
		}

		container = try NSPersistentContainer.load(
			name: CoreDataFeedStore.modelName,
			model: model,
			url: storeURL
		)
		context = container.newBackgroundContext()
	}

	public func retrieve(completion: @escaping RetrievalCompletion) {
		context.performAndWait {
			do {
				guard let cache = try Cache.find(in: context),
				      let feedObjects = cache.images?.array as? [FeedImage] else {
					completion(.empty)
					return
				}

				let feed = feedObjects.map { $0.local }
				completion(.found(feed: feed, timestamp: cache.timestamp))
			} catch {
				completion(.failure(error))
			}
		}
	}

	public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
		context.performAndWait {
			let previousCache = try? Cache.find(in: context)

			do {
				let dtos = try feed.compactMap { try FeedImage(context: context, local: $0) }
				let _ = try Cache(context: context, images: dtos, timestamp: timestamp)

				try context.save()

				if let previousCache = previousCache {
					context.delete(previousCache)
					try context.save()
				}

				completion(nil)
			} catch {
				context.rollback()
				completion(error)
			}
		}
	}

	public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
		context.performAndWait {
			do {
				let previousCache = try Cache.find(in: context)

				if let cache = previousCache {
					context.delete(cache)
				}

				try context.save()
				completion(nil)
			} catch {
				context.rollback()
				completion(error)
			}
		}
	}
}
