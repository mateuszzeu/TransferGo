## TransferGo Currency Converter App
This project is an iOS mobile application (SwiftUI) that implements a currency converter using the TransferGo public FX rates API.

The app is built with MVVM and modern SwiftUI components. Key features include:

- API Integration: https://my.transfergo.com/api/fx-rates for real-time exchange rates.
- Two-Way Conversion: Allows the user to change the sending amount (FROM) or the receiving amount (TO), triggering the necessary API call for conversion or reverse conversion.
- Currency Swap: A dedicated button swaps the FROM and TO currencies, updating all amounts and rates.
- Limit Validation: Checks the sending amount against the mocked currency limits (e.g., 20000 PLN) and displays a warning.
- Concurrency: Utilizes async/await and Task cancellation to ensure only the most recent request is processed, preventing race conditions during rapid input changes.
- Quality Assurance: Includes comprehensive Unit Tests for the ViewModel logic, using mock services for isolated testing of network and data flow.

### 🛠 Run Instructions
- Clone the Repository
- Open the project file: TransferGo.xcodeproj
- Select the TransferGo scheme
- Choose a target simulator (e.g., iPhone 15)
- Press Run (Cmd + R)
