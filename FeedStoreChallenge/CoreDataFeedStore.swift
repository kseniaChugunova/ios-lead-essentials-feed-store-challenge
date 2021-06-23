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
				      let feedObjects = cache.images?.array else {
					completion(.empty)
					return
				}

				let feed = feedObjects.map { ($0 as! FeedImage).local }
				completion(.found(feed: feed, timestamp: cache.timestamp!))
			} catch {
				completion(.failure(error))
			}
		}
	}

	public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
		context.performAndWait {
			deleteCachedFeed { [weak self] error in
				guard let self = self else {
					completion(error)
					return
				}

				if let error = error {
					completion(error)
				} else {
					do {
						let dtos = try feed.compactMap { try FeedImage(context: self.context, local: $0) }
						let _ = try Cache(context: self.context, images: dtos, timestamp: timestamp)

						try self.context.save()
						completion(nil)
					} catch {
						self.context.rollback()
						completion(error)
					}
				}
			}
		}
	}

	public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cache")
		let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)

		do {
			try context.execute(deleteRequest)
			try context.save()
			completion(nil)
		} catch {
			completion(error)
		}
	}
}
