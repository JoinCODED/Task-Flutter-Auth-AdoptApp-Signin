### Setup

1. In your `models` folder, create a new file called `user` and create a model with the following properties:

```dart
class User {
  int? id;
  String username;
  String? password;

  User({
    this.id,
    required this.username,
    this.password,
  });
}
```

2. Add `json_serializable` package into your project:

```dart
flutter pub add json_serializable
```

3. Import `json_serializable` package into your user model:

```dart
import 'package:json_annotation/json_annotation.dart';
```

4. Add the `part` file:

```dart
part 'user.g.dart';
```

5. Before your class definition, add this:

```dart
@JsonSerializable()
class User {
[...]
```

6. At the end of your class:

```dart
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
```

7. Install the `build_runner` package:

```dart
flutter pub add build_runner
```

8. Run this command:

```dart
flutter pub run build_runner build
```

9. In your `providers` folder create a file called `auth_provider.dart`.

```dart
class AuthProvider extends ChangeNotifier {}
```

10. Add 2 properties for now, a `String` `token` and initialize it with an empty string, and a `User` `user` property and mark it as `late`.

```dart
class AuthProvider extends ChangeNotifier {
  String token = "";
  late User user;
}
```

11. In your `services` folder, create a new file `client.dart` and initialize a `dio` instance, pass it base url, and create a singleton for it.

```dart
import 'package:dio/dio.dart';

class Client {
  static final Dio dio = Dio(BaseOptions(baseUrl: 'https://coded-pets-api-auth.herokuapp.com'));
}
```

12. Create your `signup` function that returns a future String and takes `user` as an argument.

```dart
  Future<String> signup({required User user}) async {}
```

13. Send a post request to `/signup` and pass the `user` argument using `.toJson` constructor.

```dart
  Future<String> signup({required User user}) async {
    late String token;
    try {
      Response response =
          await Client.dio('/signup', data: user.toJson());
      token = response.data["token"];
    } on DioError catch (error) {
      print(error);
    }
    return token;
  }
```

14. Create the `signup` function in your `auth_provider` with a type of `void` and call our `signup` function from `auth_services.dart`.

```dart
  void signup({required User user}) async {
    await AuthServices().signup(user: user);
  }
```

15. Assign the token coming from the response to your `token` property in the provider, and print the token in the console.

```dart
  void signup({required User user}) async {
    token = await AuthServices().signup(user: user);
    print(token);
  }
```

### Signup

1. In your `pages` folder, create a signup page with two field, username and password.
2. Add this page into your routes in `main.dart`.

```dart
      GoRoute(
        path: '/signup',
        builder: (context, state) => SignupPage(),
      ),
```

3. In your `home_page.dart` create a `Drawer` widget with a header, signup and signin buttons.

```dart
return Scaffold(
      appBar: AppBar(
        title: const Text("Book Store"),
      ),
      drawer: Drawer()
[...]
```

```dart
ListView(
    padding: EdgeInsets.zero,
        children: [
            ListTile(
                title: const Text("Signin"),
                trailing: const Icon(Icons.login),
                onTap: () {},
            ),
            ListTile(
                title: const Text("Signup"),
                trailing: const Icon(Icons.how_to_reg),
                onTap: () {},
            )
            ],
    )
```

4. In your signup button, link it to the `signup` page.

```dart
    ListTile(
            title: const Text("Signup"),
            trailing: const Icon(Icons.how_to_reg),
            onTap: () {
                GoRouter.of(context).push('/signup');
            },
        )
```

5. In `main.dart` change `ChangeNotifierProvider` with `MultiProvider` that takes `providers` array as an argument and add your two providers.

```dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<BooksProvider>(create: (_) => BooksProvider()),
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
      ],
      child: MyApp(),
    ),
  );
}
```

6. In your Signup page, call the auth provider signup function, and pass it the text fields values, then pop the user to the `home_page` again.

```dart
    ElevatedButton(
        onPressed: () {
            Provider.of<AuthProvider>(context, listen: false).signup(
            user: User(
            username: usernameController.text,
            password: passwordController.text));
        },
        child: const Text("Sign Up"),
    )
```

7. Check your code, you should see the token in the console.
