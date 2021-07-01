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
		context.perform { [weak self] in
			guard let self = self else { return }
			do {
				guard let cache = try Cache.find(in: self.context),
				      let feedObjects = cache.images.array as? [FeedImage] else {
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
		context.perform { [weak self] in
			guard let self = self else { return }
			let previousCache = try? Cache.find(in: self.context)

			do {
				if let previousCache = previousCache {
					self.context.delete(previousCache)
				}

				let dtos = feed.compactMap { FeedImage(context: self.context, local: $0) }
				let _ = Cache(context: self.context, images: dtos, timestamp: timestamp)

				try self.context.save()

				completion(nil)
			} catch {
				self.context.rollback()
				completion(error)
			}
		}
	}

	public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
		context.perform { [weak self] in
			guard let self = self else { return }
			do {
				let previousCache = try Cache.find(in: self.context)

				if let cache = previousCache {
					self.context.delete(cache)
					try self.context.save()
				}

				completion(nil)
			} catch {
				self.context.rollback()
				completion(error)
			}
		}
	}
}
