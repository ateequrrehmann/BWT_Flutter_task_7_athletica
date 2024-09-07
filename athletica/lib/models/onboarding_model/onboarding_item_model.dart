import 'package:athletica/models/onboarding_model/onboarding_info_model.dart';

class OnboardingItems{
  List<OnboardingInfo> items=[
    OnboardingInfo(
        title: 'Welcome to Athletica',
        description: 'Your all-in-one fitness companion. Track your progress, access expert workout plans, and connect with a community of athletes just like you. Let\'s elevate your fitness journey together!',
        image: 'https://firebasestorage.googleapis.com/v0/b/athletica-39b15.appspot.com/o/onboarding_images%2F1.png?alt=media&token=24f96fd5-a177-44a4-821f-563c486ad272'
    ),

    OnboardingInfo(
        title: 'Explore Features',
        description: 'Unlock custom workout routines, monitor your performance with detailed stats, and stay motivated with our supportive community. Athletica empowers you to achieve your fitness goals, one step at a time.',
        image: 'https://firebasestorage.googleapis.com/v0/b/athletica-39b15.appspot.com/o/onboarding_images%2F2.png?alt=media&token=2130daf0-08df-4aa0-9837-e130af837f10'
    ),

    OnboardingInfo(
        title: 'Set Your Fitness Goals',
        description: 'Personalize your experience to match your fitness aspirations. Whether you\'re aiming to lose weight, build muscle, or boost endurance, Athletica is here to guide you every step of the way.',
        image: 'https://firebasestorage.googleapis.com/v0/b/athletica-39b15.appspot.com/o/onboarding_images%2F3.png?alt=media&token=d3e3d67a-78d3-451f-93dc-e2eedea977f0'
    ),
  ];
}