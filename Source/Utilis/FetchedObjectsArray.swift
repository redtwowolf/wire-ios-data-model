//
// Wire
// Copyright (C) 2018 Wire Swiss GmbH
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see http://www.gnu.org/licenses/.
//

import Foundation

public final class FetchedObjectsArray<Element: NSFetchRequestResult>: NSObject, Collection, NSFetchedResultsControllerDelegate {
    
    public typealias Index = Int
    
    public var startIndex: Int {
        return 0
    }
    
    public var endIndex: Int = 0
    
    public func index(after i: Int) -> Int {
        return i + 1
    }
    
    public subscript(i: Int) -> Element {
        return fetchResultController.object(at: IndexPath(item: i, section: 0))
    }
    
    private let fetchRequest: NSFetchRequest<Element>
    private let fetchResultController: NSFetchedResultsController<Element>
    
    init(on moc: NSManagedObjectContext, fetchRequest: NSFetchRequest<Element>) throws {
        self.fetchRequest = fetchRequest
        
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                managedObjectContext: moc,
                                                                sectionNameKeyPath: nil,
                                                                cacheName: nil)
        super.init()
        self.fetchResultController.delegate = self
        try fetchResultController.performFetch()
        updateCount()
    }
    
    private func updateCount() {
        endIndex = fetchResultController.fetchedObjects?.count ?? 0
    }
    
    // MARK: - Fetched results controller
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                           didChange anObject: Any,
                           at indexPath: IndexPath?,
                           for type: NSFetchedResultsChangeType,
                           newIndexPath: IndexPath?) {
        
    }
  
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                           didChange sectionInfo: NSFetchedResultsSectionInfo,
                           atSectionIndex sectionIndex: Int,
                           for type: NSFetchedResultsChangeType) {
        
    }
    
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateCount()
    }
}

