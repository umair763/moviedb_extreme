import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'firebase_options.dart'; // Import generated Firebase options file (from the Firebase CLI)
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:moviesearchapp/ui/screens/navigation.dart';
import 'package:moviesearchapp/ui/screens/signin.dart'; // Import SignIn Page
import 'package:moviesearchapp/ui/screens/signup.dart'; // Import SignUp Page

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with options for current platform
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Hive for local storage
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  await Hive.openBox('bookmarks');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MovieDB',
      debugShowCheckedModeBanner: false,
      initialRoute: '/signin',
      routes: {
        '/signin': (context) => const SignIn(), // Route for SignIn page
        '/signup': (context) => const SignUp(), // Route for SignUp page
        '/home': (context) =>
            Navigation(), // Route for Home (Navigation screen)
      },
    );
  }
}
