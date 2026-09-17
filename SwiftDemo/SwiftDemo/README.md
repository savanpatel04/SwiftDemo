# SwiftDemo

A native iOS app built with Swift and SwiftUI that searches and displays characters from the Rick and Morty API.

## Features

* Search characters by name
* Search updates as the user types
* 300ms search debounce to avoid unnecessary API requests
* Loading indicator during API requests
* Character list with name, species, and image
* Character detail screen with:

  * Name
  * Image
  * Species
  * Status
  * Origin
  * Type when available
  * Formatted creation date
* Error handling and retry support
* Handles no-results responses
* Image caching using `NSCache`
* Native character sharing
* VoiceOver accessibility support
* Dynamic Type support
* Portrait and landscape support
* Unit tests
* UI tests

## Architecture

The app follows a simple MVVM structure with dependency injection for the networking layer.

```text
SwiftDemo
├── Constants
│   ├── APIConstants.swift
│   └── SearchConstants.swift
├── Models
│   └── Character.swift
├── Networking
│   ├── CharacterService.swift
│   └── CharacterServiceProtocol.swift
├── ViewModels
│   └── CharacterListViewModel.swift
├── Views
│   ├── CharacterListView.swift
│   ├── CharacterRowView.swift
│   ├── CharacterDetailView.swift
│   ├── CharacterImageView.swift
│   └── ShareSheet.swift
├── SwiftDemoApp.swift
├── SwiftDemoTests
│   ├── SwiftDemoTests.swift
│   └── MockCharacterService.swift
└── SwiftDemoUITests
    ├── SwiftDemoUITests.swift
    └── SwiftDemoUITestsLaunchTests.swift
```

### MVVM

* **Model:** Represents API data such as characters and their origin.
* **View:** SwiftUI screens responsible for displaying the UI.
* **ViewModel:** Handles search state, loading state, errors, and communication with the service.
* **Service:** Handles API requests and JSON decoding.

The ViewModel depends on `CharacterServiceProtocol` rather than the concrete API service. This allows a mock service to be injected during unit tests without making real network requests.

## API

This project uses the [Rick and Morty API](https://rickandmortyapi.com/).

Character search endpoint:

```text
https://rickandmortyapi.com/api/character/?name=<search>
```

No API key is required.

## Image Loading

Character images are loaded asynchronously using `URLSession`.

An `NSCache`-based image cache is used to avoid downloading the same character images repeatedly while navigating through the app.

## Error Handling

The app handles:

* Invalid URLs
* Invalid HTTP responses
* HTTP errors
* JSON decoding errors
* Empty search input
* No matching characters
* Failed image loading

A user-friendly retry option is provided when a search request fails.

## Testing

The project includes both unit tests and UI tests.

### Unit Tests

Unit tests cover:

* Character JSON decoding
* Successful character fetching using a mock service
* Verifying the search text passed to the service
* Handling a 404 response with no results

The ViewModel uses dependency injection through `CharacterServiceProtocol`, allowing tests to use `MockCharacterService` instead of making real API requests.

### UI Tests

UI tests cover:

* Searching for a character
* Opening the character detail screen
* Verifying character information is displayed

## Accessibility

Accessibility support includes:

* VoiceOver labels and hints
* Accessible search field
* Accessible character rows
* Accessible character images
* Dynamic Type support

## Requirements

* Xcode 26.5
* iOS 17.6+
* Swift
* SwiftUI

## Running the Project

1. Clone the repository.
2. Open `SwiftDemo.xcodeproj` in Xcode.
3. Select an iPhone simulator.
4. Build and run with `⌘ + R`.

No API key or additional configuration is required.
