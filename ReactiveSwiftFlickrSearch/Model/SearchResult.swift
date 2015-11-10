//
//  FlickrSearchResult.swift
//  ReactiveSwiftFlickrSearch
//
//  Created by Colin Eberhardt on 14/07/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

// Represents the result of a Flickr search
class SearchResults {
  let searchString: String
  let totalResults: Int
  let photos: [Photo]
  
  init(searchString: String, totalResults: Int, photos: [Photo]) {
    self.searchString = searchString;
    self.totalResults = totalResults
    self.photos = photos
  }
}
