import 'package:bitirme_projesi/pages/about_page.dart';
import 'package:bitirme_projesi/pages/appoinment_entry.dart';
import 'package:bitirme_projesi/pages/blood_advertisement_page.dart';
import 'package:bitirme_projesi/pages/blood_donation_page.dart';
import 'package:bitirme_projesi/pages/blood_need_page.dart';
import 'package:bitirme_projesi/pages/donation_list_page.dart';
import 'package:bitirme_projesi/pages/feedback_page.dart';
import 'package:bitirme_projesi/pages/firebase_api.dart';
import 'package:bitirme_projesi/pages/inform_page.dart';
import 'package:bitirme_projesi/pages/password_update_page.dart';
import 'package:bitirme_projesi/pages/splash_page.dart';
import 'package:bitirme_projesi/pages/user_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bitirme_projesi/firebase_options.dart';
import 'package:bitirme_projesi/routes.dart';
import 'package:bitirme_projesi/pages/login_page.dart';
import 'package:bitirme_projesi/pages/register_page.dart';
import 'package:bitirme_projesi/pages/information_page.dart';
import 'package:bitirme_projesi/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: splashPageRoute, // Set the initial route
      routes: {
        splashPageRoute: (context) => const SplashScreen(),
        loginPageRoute: (context) => const LoginUserPage(),
        passwordPageRoute: (context) => const PasswordUpdatePage(),
        registerPageRoute: (context) => const RegisterUser(),
        informationPageRoute: (context) => const InformationPage(),
        homePageRoute: (context) => const HomePage(),
        bloodDonationPageRoute: (context) => const BloodDonationPage(),
        bloodNeedPageRoute: (context) => const BloodNeedPage(),
        donationListPageRoute: (context) => const DonationListPage(),
        bloodAdvertisementPageRoute: (context) =>
            const BloodAdvertisementPage(),
        userProfilePageRoute: (context) => const UserProfilePage(),
        appoinmentPageRoute: (context) => const AppointmentEntryPage(),
        informPageRoute: (context) => const InformPage(),
        feedbackPageRoute: (context) => const FeedbackPage(),
        aboutPageRoute: (context) => const AboutPage(),
      },
    );
  }
}
