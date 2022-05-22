### Signin

1. Create your `signin` function that returns a future `String` and takes `user` as an argument.

```dart
  Future<String> signin({required User user}) async {
    late String token;
    try {
      Response response =
          await Client.dio('/signin', data: user.toJson());
      token = response.data["token"];
    } on DioError catch (error) {
      print(error);
    }
    return token;
  }
```

2. Create the `signin` function in your `auth_provider` with a type of `void` and call our `signin` function from `auth_services.dart`.

```dart
  void signin({required User user}) async {
    token = await AuthServices().signin(user: user);
    print(token);
  }
```

3. Create a Signin page in your `pages` folder and add the page to our routes in `main.dart`.

```dart
      GoRoute(
        path: '/signin',
        builder: (context, state) => SigninPage(),
      ),
```

4. Link the page in the signin button in our `Drawer`.

```dart
ListTile(
    title: const Text("Signin"),
    trailing: const Icon(Icons.login),
        onTap: () {
            GoRouter.of(context).push('/signin');
            },
    ),
```

5. Call the `signin` function on the submit button in your signin page.

```dart
    ElevatedButton(
        onPressed: () {
            Provider.of<AuthProvider>(context, listen: false).signin(
                user: User(
                username: usernameController.text,
                password: passwordController.text));
        },
        child: const Text("Sign In"),
    )
```

6. Check your code, you should see the token in the console.

### Decoding The Token

1. In your `auth_provider.dart`, Create a `bool` getter that tells us if the user is authenticated or not based on the token availability.

```dart
  bool get isAuth {
    if (token.isNotEmpty) {
      return true;
    }
    return false;
  }
```

2. Install the `jwt_decode` package in your project:

```dart
import 'package:jwt_decode/jwt_decode.dart';
```

3. Use this package to check the expiry date of the token in your `isAuth` getter.

```dart
  bool get isAuth {
    if (token.isNotEmpty && Jwt.getExpiryDate(token)!.isAfter(DateTime.now())) {
      return true;
    }
    return false;
  }
```

4. If the token is not expired, decode the token and map the values to the `user` object using `fromJson` constructor.

```dart
  bool get isAuth {
    if (token.isNotEmpty && Jwt.getExpiryDate(token)!.isAfter(DateTime.now())) {
      user = User.fromJson(Jwt.parseJwt(token));
      return true;
    }
    return false;
  }
```

5. In your `Drawer` widget, use a `Consumer` widget and check the `isAuth` getter, if there is a user, show a signout button, else show the signin/up buttons we already have.

```dart
 drawer: Drawer(
        child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) => authProvider.isAuth
                ? ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      DrawerHeader(
                        child: Text("Welcome ${authProvider.user.username}"),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                        ),
                      ),
                      ListTile(
                        title: const Text("Logout"),
                        trailing: const Icon(Icons.logout),
                        onTap: () {},
                      ),
                    ],
                  )
                : ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      const DrawerHeader(
                        child: Text("Sign in please"),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                        ),
                      ),
                      ListTile(
                        title: const Text("Signin"),
                        trailing: const Icon(Icons.login),
                        onTap: () {
                          GoRouter.of(context).push('/signin');
                        },
                      ),
                      ListTile(
                        title: const Text("Signup"),
                        trailing: const Icon(Icons.how_to_reg),
                        onTap: () {
                          GoRouter.of(context).push('/signup');
                        },
                      )
                    ],
                  ),
                ),
      ),
```

6. Create a signout function in your provider that clears the token from the provider and link it to the signout button.

```dart
  void logout() {
    token = "";
    notifyListeners();
  }
```

```dart
ListTile(
        title: const Text("Logout"),
        trailing: const Icon(Icons.logout),
        onTap: () {
                Provider.of<AuthProvider>(context, listen: false).logout();
                },
    ),
```

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

```dart
  void setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }
```

4. Call this method in both `signin` and `signup` function.

```dart
  void signup({required User user}) async {
    token = await AuthServices().signup(user: user);
    setToken(token);
    notifyListeners();
  }

  void signin({required User user}) async {
    token = await AuthServices().signin(user: user);
    setToken(token);
    notifyListeners();
  }
```

5. Create another function `getToken` that gets the token from the `shared_preferences` and assign it to the `token` property in the provider.

```dart
  void getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? "";
    notifyListeners();
  }
```

6. Call this function in the `isAuth` getter.

```dart
  bool get isAuth {
    getToken();
    if (token.isNotEmpty && Jwt.getExpiryDate(token)!.isAfter(DateTime.now())) {
      user = User.fromJson(Jwt.parseJwt(token));
      return true;
    }
    return false;
  }
```

7. In your `signout` function, remove the token from the `shared_preferences`, and call this function in `isAuth` if the token is expired.

```dart
  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    token = "";
    notifyListeners();
  }
```

```dart
  bool get isAuth {
    getToken();
    if (token.isNotEmpty && Jwt.getExpiryDate(token)!.isAfter(DateTime.now())) {
      user = User.fromJson(Jwt.parseJwt(token));
      return true;
    }
    logout();
    return false;
  }
```

### Adding Headers

1. In your `isAuth` getter, after you check for the token validity, add the token to the dio client headers.

```dart
bool get isAuth {
    getToken();
    if (token.isNotEmpty && Jwt.getExpiryDate(token)!.isAfter(DateTime.now())) {
      user = User.fromJson(Jwt.parseJwt(token));
      Client.dio.options.headers = {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      };
      return true;
    }
    logout();
    return false;
  }
```
