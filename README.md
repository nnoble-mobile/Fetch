# Fetch Take Home Project

### Steps to Run the App

- Use Xcode 16+ with iOS 18.1+
- Open the project and run on any iOS simulator

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?

- Production-ready code
  - My job is to produce production-ready code, and I wanted to show how well I can do that. My code is clean, readable, well-structured, and well-documented. I used separation-of-concerns and dependency injection to make my code modular and highly testable. My SwiftUI previews show every state, and use mocks to avoid live network calls.
- Testing
  - Unit testing is the most important part of production-ready code. I wrote clear and detailed unit tests that average 99% coverage across my files with logical code.

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?

- I spent about 6 hours total.
  - 1 hour on rapid prototyping
  - 2 hours on refining and refactoring
  - 2 hours on unit testing
  - 1 hour on UI/UX embellishments 

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?

- No significant tradeoffs, although with more time I could improve the UX even further.

### Weakest Part of the Project: What do you think is the weakest part of your project?

- The UX is pretty basic. I use some neat animations and the list is searchable, but it still looks pretty plain.

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.

Requirements:

- Swift Concurrency ✅ 
  - Used `async/await` for for all asynchronous operations
- No External Dependencies ✅ 
  - No third-party libraries used or imported
- Efficient Network Usage ✅ 
  - Custom-implemented cache to avoid downloading images more than once
- Testing ✅ 
  - ~100% coverage on every file that includes logic

Show Off Your Skills:
- Architecture
  - Used MVVM using the modern `@Observable` instead of `@ObservableObject`
  - Dependency injection used to maximize testability with mocks
- Concurrency
  - Used `async/await` for for all asynchronous operations
- UI/UX
  - Supports Light/Dark mode
  - Supports Landscape
  - Searchable recipes list
  - Pull-to-refresh
  - Animated symbols for error and empty states (using `ContentUnavailableView` and SFSymbol animations)
- Performance Optimization
  - SwiftUI previews show multiple states for each view, and use mock data to avoid live network requests
  - Preview and Mock data/files are kept in the `Preview Content` directory, so they are not included in the final app bundle on distribution. 

Screenshots:
![fetch](https://github.com/user-attachments/assets/e15c035a-bee0-48b0-85f7-9df417378575)
![Simulator Screenshot - iPhone 16 - 2024-12-12 at 16 27 24](https://github.com/user-attachments/assets/0e41bb69-ee07-47b4-88d6-7bbeedb0dc26)
![Simulator Screen Recording - iPhone 16 - 2024-12-12 at 16 27 35](https://github.com/user-attachments/assets/53271e60-be35-4ce4-8af2-4bbf611d31bf)
![Simulator Screen Recording - iPhone 16 - 2024-12-12 at 16 27 35](https://github.com/user-attachments/assets/fecf7fab-bee5-4601-aa6e-e9cfd11b285a)



