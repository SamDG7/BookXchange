<a name="readme-top"></a>

<br />
<div align="center">
  <a href="">
    <img src="https://github.com/SamDG7/BookXchange/blob/main/bookxchange_flutter/assets/logo_no_text.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">BookXChange</h3>

  <p align="center">
    An iOS and Android mobile app that allows users to meet up, discuss, and Xchange books!
    <br />
  </p>
</div>

## About The Project
The BookXChange platforms provides users with a personalized feed of books in a tinder-like interface that allows users to swipe left on books they do not like and right on those they do. From this, they can match with other users and communicate with them to meet up to discuss and Xchange their books. 

BookXChange allows user to upload their own books manually, via ISBN, or via UPC to their personal library, making the books available for others to swipe on. In the user's profile, they can change the bio, display name, and other personal information that will be made available to their matches to futher conversation. Additionally, a public and safe meet-up spot is suggested to each matching pair to maintain personal safety.

To further safety, the app also includes the ability to remove specific users from appearing in your feed via blocking or simply removing a single match. If a user further breaks guidelines you are able to contact the developers by submitting a "Report a User" ticket within the app.

The personalized feed employs machine learning classifiers to create a fully functional reccomendation algorithm, analyzing the user's taste with each swipe.

For futher information view the project backlog and planning documents in the "documents" folder.

### Built With
* Flutter
* Python
* Flask
* MongoDB
* Firebase Authentication
* Cloud Firestore
* Google Books API


## Getting Started

_Follow the instructions below to launch the application._

1. Install Flutter: [Flutter](https://docs.flutter.dev/get-started/install)
2. Install Emulator of Choice: [iOS](https://medium.com/@abrisad_it/how-to-launch-ios-simulator-and-android-emulator-on-mac-cd198295532e) or [Android](https://developer.android.com/studio)
3. Clone the repo
  ```sh
  git clone https://github.com/SamDG7/BookXchange.git
  ```
4. Install Required packages:
  ```sh
  pip3 install -r requirements.txt
  ```
5. Run Front-end via Flutter:
  ```sh
  cd bookxchange_flutter
  flutter run
  ```
6. Run the back-end:
   ```sh
   cd bookxchange_backend
   python3 app.py
   ```


