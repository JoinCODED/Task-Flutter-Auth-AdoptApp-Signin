# Pets Adoption App Auth 🦄

## Instructions

- If you need a starting point, fork and clone [this repository](https://github.com/JoinCODED/Task-Flutter-Auth-AdoptApp-Signin) to your `Development` folder.

### Signin

1. Create your `signin` function that returns a future `String` and takes `user` as an argument.
2. Create the `signin` function in your `auth_provider` with a type of `void` and call our `signin` function from `auth_services.dart`.
3. Create a Signin page in your `pages` folder and add the page to our routes in `main.dart`.
4. Link the page in the signin button in our `Drawer`.
5. Call the `signin` function on the submit button in your signin page.
6. Check your code, you should see the token in the console.

### Decoding The Token

1. In your `auth_provider.dart`, Create a `bool` getter that tells us if the user is authenticated or not based on the token availability.
2. Install the `jwt_decode` package in your project:

```dart
import 'package:jwt_decode/jwt_decode.dart';
```

3. Use this package to check the expiry date of the token in your `isAuth` getter.
4. If the token is not expired, decode the token and map the values to the `user` object using `fromJson` constructor.
5. In your `Drawer` widget, use a `Consumer` widget and check the `isAuth` getter, if there is a user, show a signout button, else show the signin/up buttons we already have.
6. Create a signout function in your provider that clears the token from the provider and link it to the signout button.
7. In the drawer header, show a welcome message with the username.

### Persistent Login

1. Install `shared_preferences` package into your project.

```dart
flutter pub add shared_preferences
```

2. Import it into your auth provider:

```dart
import 'package:shared_preferences/shared_preferences.dart';
```

3. In your auth provider, create a `setToken` method, that takes a string token as an argument and stores that token in the `shared_preferences`.
4. Call this method in both `signin` and `signup` function.
5. Create another function `getToken` that gets the token from the `shared_preferences` and assign it to the `token` property in the provider.
6. Call this function in the `isAuth` getter.
7. In your `signout` function, remove the token from the `shared_preferences`, and call this function in `isAuth` if the token is expired.

### Adding Headers

1. In your `isAuth` getter, after you check for the token validity, add the token to the dio client headers.
