# Flutter Signup App

## MAD 4360 - In-Class Activity 10

## 1. Project Description

For this assignment, we created a signup application using Flutter and Dart. The app allows users to enter their full name, email, and password. It checks the information before showing a successful signup message.

We also added a Signup Coach that gives users helpful tips about passwords, emails, and account safety. The app uses preset tips instead of connecting to a real AI service.

## 2. Features

Our app includes the following features:

- Full name, email, and password fields
- Input validation
- Confirm password field
- Password strength indicator
- Signup button
- Green success message
- Local AI Signup Coach simulation
- Loading indicator
- Error message and retry button
- Purple theme and simple design

## 3. Task A - Local AI Signup Coach

We created a Signup Coach that provides helpful tips during signup. Users can choose a category, such as password help, email help, or account safety.

When the user clicks the Get a Signup Tip button, the app shows a loading indicator for one second. After that, it displays a preset tip based on the selected category.

We also included a Test Error category to check how the app handles missing tip information. When an error happens, the app displays an error message and a retry button.

All tips are stored locally in the app. There are no network requests, and the feature does not collect personal information.

## 4. Task B - Password Coach

We added a password strength indicator to help users create better passwords.

The app checks the password length and displays different messages.

- Empty password: No password entered
- Less than 8 characters: Weak
- 8 or more characters: Good

The app also gives a simple suggestion to improve the password.

This feature works locally and does not share the password with the Signup Coach.

## 5. Task C - Confirm Password

We added a confirm password field to make sure users enter the correct password.

If the passwords do not match, the app shows an error message.

If all fields are valid, the app displays a green success message with the user's name.

This helps users check their information before completing the demo signup.

## 6. Testing

The app includes validation and error-handling features for different situations.

| Test | Expected Result |
|---|---|
| Empty name | Name error message |
| Invalid email | Email error message |
| Password less than 6 characters | Password error message |
| Different passwords | Password mismatch message |
| Valid signup information | Green success message |
| Short password | Weak password indicator |
| Password with 8 or more characters | Good password indicator |
| Get a signup tip | Loading indicator and preset tip |
| Select Test Error | Error message and retry button |
| Change category and retry | Selected tip appears |

We also built the Android release APK successfully using the following command:

`flutter build apk --release`

## 7. Reflection

### Question 1: Identify one privacy boundary in the local tip feature. What information does it keep out of the feature, and why?

The Signup Coach does not use the user's name, email, or password. It only uses the selected category to display a tip. We kept personal information separate because the tips do not need user data. This also helps protect user privacy.

### Question 2: How would you evaluate whether the preset tips are useful, safe, and consistent? Name a small test set and at least one failure metric.

I would test the password help, email help, and account safety categories. Each category should display the correct tip without using personal information. I would also test the missing tip category to make sure the error message appears correctly. One failure metric would be the number of times the app shows an incorrect or empty tip when a valid category is selected.

### Question 3: What should the UI do when local tip data is empty or missing? Explain your error and retry behavior.

When the tip data is missing, the app should show an error message instead of displaying an empty result. In our app, the user sees a retry button when the selected tip is unavailable. The user can choose another category and press the button again. This makes the app easier to understand and use.

### Question 4: Describe one trade-off in your local design and a practical improvement.

One trade-off is that the Signup Coach only has a few preset tips. This makes the app simple and keeps user information private, but it also limits the advice users can receive. One improvement would be adding more categories and tips while keeping everything stored locally.

### Question 5: Why should preset tips be clearly labeled and kept separate from form validation?

Preset tips should be labeled because they are not real AI-generated responses. Users should understand that the messages are already stored in the app. We kept the Signup Coach separate from form validation because tips should not decide whether signup is successful. Only the form validators check the entered information.

## 8. How the App Works

The app starts with a signup form containing name, email, password, and confirm password fields.

When the user presses Sign Up, the form checks all the fields. If something is missing or incorrect, an error message appears below the field.

If everything is valid, a green success message appears with the user's name.

The Signup Coach works separately from the signup form. Users can select a category and receive a preset tip without entering personal information.

## 9. Technologies Used

- Flutter
- Dart
- Material Design
- Visual Studio Code
- GitHub

## 10. How to Run

First, open the Flutter project in Visual Studio Code.

Open the terminal and run:

`flutter pub get`

Then run:

`flutter run`

To generate the Android APK, run:

`flutter build apk --release`

The generated APK can be found in:

`build/app/outputs/flutter-apk/app-release.apk`

## 11. Limitations

Our app is a demo and does not create real accounts or save information in a database.

The Signup Coach does not use a real AI model. It only displays preset tips that are stored in the application.

The password strength indicator is also basic because it mainly checks password length.

In the future, we could add more signup tips, improve password checking, and make the design better.

## 12. Conclusion

This project helped us practice creating forms in Flutter, checking user input, and managing state with StatefulWidget.

We also learned how to create a simple local feature that shows loading, success, and error states.

Overall, this assignment helped us understand Flutter forms, validation, and user interface design.
