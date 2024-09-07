import 'package:athletica/models/onboarding_model/onboarding_item_model.dart';
import 'package:athletica/views/color/colors.dart';
import 'package:athletica/views/onboarding_screen/widget/get_started_button.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final controller = OnboardingItems();
  PageController pageController = PageController();

  bool isLastPage = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomSheet: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
          child: isLastPage
              ? const GetStartedButton()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all<Color>(darkOrange),
                        ),
                        onPressed: () => pageController
                            .jumpToPage(controller.items.length - 1),
                        child: const Text(
                          'Skip',
                          style: TextStyle(color: textColor),
                        )),
                    SmoothPageIndicator(
                      controller: pageController,
                      count: controller.items.length,
                      onDotClicked: (index) => pageController.animateToPage(
                          index,
                          duration: const Duration(microseconds: 600),
                          curve: Curves.easeIn),
                      effect: const ScrollingDotsEffect(
                        dotHeight: 8.0,
                        dotWidth: 8.0,
                        dotColor: Colors.grey,
                        activeDotColor: darkOrange,
                      ),
                    ),
                    TextButton(
                      onPressed: () => pageController.nextPage(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeIn),
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(darkOrange),
                      ),
                      child:
                          const Text('Next', style: TextStyle(color: textColor)),
                    )
                  ],
                ),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 2.h),
          child: PageView.builder(
              onPageChanged: (index) {
                setState(() {
                  isLastPage = controller.items.length - 1 == index;
                });
              },
              itemCount: controller.items.length,
              controller: pageController,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                        height: 40.h,
                        child: Image.network(controller.items[index].image)),
                     SizedBox(
                      height: 2.h,
                    ),
                    Text(
                      controller.items[index].title,
                      style:
                          TextStyle(fontSize: 23.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Text(
                      controller.items[index].description,
                      style: TextStyle(color: Colors.grey, fontSize: 17.sp),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              }),
        ));
  }

}

