# SwiftUI-AppStore

A sample SwiftUI-based application that integrates with Apple’s iTunes Search API to display search results, detailed app information, screenshots, and reviews. This project demonstrates the use of Swift’s new concurrency features (`async/await`), SwiftUI views, and the `@Observable` macro (available in Xcode 15+).

## Features

- **Search for iOS Apps**  
  Users can search for apps via a search bar, which fetches results from the iTunes Search API.

- **App Detail View**  
  Tapping on a search result navigates to a detailed view of the selected app, including screenshots, release notes, version, and description.

- **Full-Screen Screenshots**  
  Users can tap on screenshots to view them in a full-screen gallery.

- **User Reviews**  
  The app fetches and displays user reviews (title, author, rating, and content) from Apple’s RSS feed.

---

## Technologies Used

1. **SwiftUI** – For building modern, declarative UIs.
2. **Swift Concurrency (`async/await`)** – For asynchronous data fetching with a cleaner, more readable code style.
3. **@Observable** – New macro-based approach to creating observable objects (Xcode 15+).
4. **Combine** – Used for debouncing user input in the search field.
5. **URLSession** – For networking to fetch data from the iTunes Search API and the RSS feed for reviews.
6. **JSONDecoder** – To parse JSON responses into Swift data models.

---

## Project Structure

- **Models**  
  - `SearchResults`, `AppResults` – Model the data returned from the search endpoint.  
  - `ReviewResults`, `ReviewFeed`, `Review`, `Author` – Model the data returned from the reviews RSS feed.  
  - `AppDetailResults`, `AppDetail` – Model for detailed app information.

- **ViewModels**  
  - `SearchViewModel` – Manages the search query and results, using Combine to debounce user input.  
  - `DetailViewModel` – Fetches and stores an app’s detail information.  
  - `ReviewsViewModel` – Fetches and stores an app’s reviews.

- **Views**  
  - `SearchView` – Main view with a search bar. Displays a list of apps matching the user’s query.  
  - `AppDetailView` – Shows details for a selected app, including screenshots and release notes.  
  - `FullScreenshotsView` – Displays screenshots in a full-screen gallery.  
  - `ReviewsView` – Shows a horizontal list of user reviews.

- **Networking**  
  - `APIService` – Contains all networking logic and helper functions for JSON decoding. It fetches search results, app details, and user reviews from Apple’s servers.

---

## Usage

1. **Searching**  
   - Click on the search bar at the top and type a search term (e.g., “Snapchat,” “Instagram”). The search results will appear in a list.

2. **Viewing App Details**  
   - Tap on any search result to open its detail screen, where you’ll see:
     - App icon, title, artist name.
     - “What’s new” section with release notes and version.
     - Screenshot previews in a horizontally scrollable row.
     - Reviews with star ratings.
     - App description.

3. **User Reviews**  
   - Scroll to the “Reviews” section to see user feedback with star ratings, authors, and descriptions.

4. **Full-Screen Screenshots**  
   - Tap on any screenshot to view it in full-screen mode. Swipe horizontally to view others.

---

*Thank you for checking out SwiftUI-AppStore! We hope it serves as a helpful example of combining SwiftUI, async/await, and Apple’s iTunes API.*
