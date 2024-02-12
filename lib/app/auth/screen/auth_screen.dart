import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finobadivendor/common/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../../common/dialog.dart';
import '../../../provider/auth_provider.dart';




class PhoneAuthMiddlewareScreen extends StatefulWidget {
  const PhoneAuthMiddlewareScreen({Key? key}) : super(key: key);

  @override
  State<PhoneAuthMiddlewareScreen> createState() => _PhoneAuthMiddlewareScreenState();
}

class _PhoneAuthMiddlewareScreenState extends State<PhoneAuthMiddlewareScreen> {
  OTPTextEditController controller = OTPTextEditController(codeLength: 6);
  TextEditingController phoneController = TextEditingController();

  late OTPInteractor _otpInteractor;
  double height = 260;
  StreamController<ErrorAnimationType>? errorController;
  bool loadingPhoneAuth = false;


  void onSendOtp() {
    controller = OTPTextEditController(
      codeLength: 5,
      onCodeReceive: (code) => print('Your Application receive code - $code'),
    )..startListenUserConsent(
        (code) {
          final exp = RegExp(r'(\d{5})');
          return exp.stringMatch(code ?? '') ?? '';
        },
        // strategies: [
        //   SampleStrategy(),
        // ],
      );
  }

  Future<void> initInteractor() async {
    _otpInteractor = OTPInteractor();

    // You can receive your app signature by using this method.
    final appSignature = await _otpInteractor.getAppSignature();

    if (kDebugMode) {
      print('Your app signature: $appSignature');
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Column(
        children: [
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Text(
                "Welcome",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
              Expanded(
                  child: Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.fitHeight,
              )),
            ],
          )),
          Container(
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18), topRight: Radius.circular(18)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.greenAccent.shade100,
                  Colors.green.shade600,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Provider.of<AuthanticationProvider>(context, listen: true).sendOtp
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                            child: Text(
                          "Verify OTP",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        )),
                        SizedBox(
                          height: 14,
                        ),
                        PinCodeTextField(
                          appContext: context,
                          pastedTextStyle: TextStyle(
                            color: Colors.green.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                          length: 6,
                          animationType: AnimationType.fade,
                          validator: (v) {
                            if (v!.length < 6) {
                              return null;
                            } else {
                              return null;
                            }
                          },
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(8),
                            fieldHeight: 50,
                            fieldWidth: 50,
                            inactiveFillColor: Colors.green,
                            selectedFillColor: Colors.white,
                            activeColor: Colors.white,
                            inactiveColor: Colors.green,
                            activeFillColor: Colors.white,
                          ),
                          cursorColor: Colors.black,
                          animationDuration: const Duration(milliseconds: 300),
                          enableActiveFill: true,
                          errorAnimationController: errorController,
                          controller: controller,
                          keyboardType: TextInputType.number,
                          boxShadows: const [
                            BoxShadow(
                              offset: Offset(0, 1),
                              color: Colors.black12,
                              blurRadius: 10,
                            )
                          ],
                          onCompleted: (v) {
                            debugPrint("Completed");
                          },
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Provider.of<AuthanticationProvider>(context,
                                          listen: false)
                                      .editPhone();
                                },
                                child: Text(
                                    "Edit +91${Provider.of<AuthanticationProvider>(context, listen: true).phoneno}")),
                            ElevatedButton(
                                onPressed: Provider.of<AuthanticationProvider>(context,
                                            listen: true)
                                        .resendOtp
                                    ? () {
                                        loadingDialog(context);
                                        Provider.of<AuthanticationProvider>(context,
                                                listen: false)
                                            .reSendOtp(context);
                                        onSendOtp();
                                      }
                                    : null,
                                child: Text("resend"))
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              loadingDialog(context);

                              Provider.of<AuthanticationProvider>(context, listen: false)
                                  .verifyOtp( context :context, otp :controller.text);
                            },
                            child: Text("Done"))
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                            child: Text(
                          "Phone Number",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        )),
                        SizedBox(
                          height: 14,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Card(
                                surfaceTintColor: Colors.white,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("+91",
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w900)),
                                )),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0.2, 0.2),
                                      blurRadius: 1,
                                      color: Colors.black54,
                                    )
                                  ]),
                              child: TextField(
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                // minLines: 10,
                                controller: phoneController,
                                decoration: InputDecoration(
                                  counterText: '',
                                  hintText: "Phone Number",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        loadingPhoneAuth
                            ? Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                onPressed: ()async{
                                  if (phoneController.text.length < 10) {
                                    Notify.showNotify("Wrong Phone No");
                                  } else {
                                    loadingDialog(context);
                                   QuerySnapshot snap = await FirebaseFirestore.instance.collection("venderMaster").where("phone",isEqualTo: '+91${phoneController.text}').get();
                                  if(snap.docs.isNotEmpty){
                                   Provider.of<AuthanticationProvider>(context,
                                            listen: false)
                                        .verifyPhoneNumber(
                                            context, phoneController.text);
                                    initInteractor();
                                    onSendOtp();
                                  }else{
                                    Navigator.pop(context);
                                    Notify.showNotify("This Phone no is not Registered");
                                  }
                                   
                                  }
                                },
                                child: Text("Next"))
                      ],
                    ),
            ),
          )
        ],
      ),
    );
  }

  
}


// class PhoneAuthMiddlewareScreen extends StatefulWidget {
//   const PhoneAuthMiddlewareScreen({Key? key}) : super(key: key);

//   @override
//   State<PhoneAuthMiddlewareScreen> createState() =>
//       _PhoneAuthMiddlewareScreenState();
// }

// class _PhoneAuthMiddlewareScreenState extends State<PhoneAuthMiddlewareScreen> {
//   OTPTextEditController controller = OTPTextEditController(codeLength: 6);
//   TextEditingController phoneController = TextEditingController();
//   FocusNode _focusNode = FocusNode();
//   late OTPInteractor _otpInteractor;
//   double height = 250;
//   StreamController<ErrorAnimationType>? errorController;
//   bool loadingPhoneAuth = false;

//   void onSendOtp() {
//     controller = OTPTextEditController(
//       codeLength: 5,
//       onCodeReceive: (code) => print('Your Application receive code - $code'),
//     )..startListenUserConsent(
//         (code) {
//           final exp = RegExp(r'(\d{5})');
//           return exp.stringMatch(code ?? '') ?? '';
//         },
//         // strategies: [
//         //   SampleStrategy(),
//         // ],
//       );
//   }

//   Future<void> initInteractor() async {
//     _otpInteractor = OTPInteractor();

//     // You can receive your app signature by using this method.
//     final appSignature = await _otpInteractor.getAppSignature();

//     if (kDebugMode) {
//       print('Your app signature: $appSignature');
//     }
//   }

//   //   @override
//   // void dispose() {
//   //   controller.stopListen();
//   //   super.dispose();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.green,
//         centerTitle: true,
//         title: Text('Finobadi Partners',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 28),),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           // color: Colors.green,
//         image: DecorationImage(image: AssetImage("assets/images/vendorlogin.jpg"))
//       )),
//       floatingActionButton: FloatingActionButton.extended(
//           onPressed: () {
//             showBottomBar(context, _focusNode);
//           },
//           label: Row(
//             children: [
//               Icon(Icons.verified_user_outlined),
//               Text("Verify Vender"),
//             ],
//           )),
//     );
//   }

//   List<Widget> authScreen = [];

//   void showBottomBar(BuildContext context, FocusNode focusNode) {
//     showModalBottomSheet(
//       context: context,
//       enableDrag: false,
//       isScrollControlled: true,
//       elevation: 0,
//       isDismissible: false,
//       barrierColor: Colors.transparent,
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(18), topRight: Radius.circular(18))),
//       backgroundColor: Colors.green.shade200,
//       builder: (context) {
//         return Container(
//           height: _focusNode.hasFocus ? 400 : height,
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Provider.of<AuthanticationProvider>(context,listen: true).sendOtp
//                 ? SingleChildScrollView(
//                   child: Column(
//                       mainAxisAlignment: _focusNode.hasFocus
//                           ? MainAxisAlignment.start
//                           : MainAxisAlignment.spaceEvenly,
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         Center(
//                             child: Text(
//                           "Verify OTP",
//                           style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.w700,
//                               color: Colors.black),
//                         )),
//                         SizedBox(
//                           height: 14,
//                         ),
//                         PinCodeTextField(
//                           appContext: context,
//                           focusNode: _focusNode,
//                           pastedTextStyle: TextStyle(
//                             color: Colors.green.shade600,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           length: 6,
//                           animationType: AnimationType.fade,
//                           validator: (v) {
//                             if (v!.length < 6) {
//                               return null;
//                             } else {
//                               return null;
//                             }
//                           },
//                           pinTheme: PinTheme(
//                             shape: PinCodeFieldShape.box,
//                             borderRadius: BorderRadius.circular(8),
//                             fieldHeight: 50,
//                             fieldWidth: 50,
//                             inactiveFillColor: Colors.green,
//                             selectedFillColor: Colors.white,
//                             activeColor: Colors.white,
//                             inactiveColor: Colors.green,
//                             activeFillColor: Colors.white,
//                           ),
//                           cursorColor: Colors.black,
//                           animationDuration: const Duration(milliseconds: 300),
//                           enableActiveFill: true,
//                           errorAnimationController: errorController,
//                           controller: controller,
//                           keyboardType: TextInputType.number,
//                           boxShadows: const [
//                             BoxShadow(
//                               offset: Offset(0, 1),
//                               color: Colors.black12,
//                               blurRadius: 10,
//                             )
//                           ],
//                           onCompleted: (v) {
//                             debugPrint("Completed");
//                           },
//                         ),
//                         SizedBox(
//                           height: 4,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             TextButton(
//                                 onPressed: () {
//                                   Provider.of<AuthanticationProvider>(context,listen: false).editPhone();setState((){loadingPhoneAuth = false;});
//                                 },
//                                 child: Text("Edit +919560950638")),
//                             ElevatedButton(
//                                 onPressed: Provider.of<AuthanticationProvider>(context,listen: true).resendOtp?  () {
//                                   Provider.of<AuthanticationProvider>(context,listen: false).reSendOtp(context,phoneController.text);
//                                   onSendOtp();
//                                 } : null, child: Text("resend"))
//                           ],
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         ElevatedButton(onPressed: () {
//                           Provider.of<AuthanticationProvider>(context,listen: false).verifyOtp(context: context,otp: controller.text);
//                         }, child: Text("Done"))
//                       ],
//                     ),
//                 )
//                 : SingleChildScrollView(
//                   child: Column(
//                       mainAxisAlignment: _focusNode.hasFocus
//                           ? MainAxisAlignment.start
//                           : MainAxisAlignment.spaceEvenly,
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         Center(
//                             child: Text(
//                           "Phone Number",
//                           style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.w700,
//                               color: Colors.black),
//                         )),
//                         SizedBox(
//                           height: 14,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             Card(
//                                surfaceTintColor: Colors.white,
//                       color: Colors.white,
//                                 child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text("+91",
//                                   style: TextStyle(
//                                       fontSize: 22, fontWeight: FontWeight.w900)),
//                             )),
//                             Container(
//                               width: MediaQuery.of(context).size.width * 0.6,
//                               decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(12),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       offset: Offset(0.2, 0.2),
//                                       blurRadius: 1,
//                                       color: Colors.black54,
//                                     )
//                                   ]),
//                               child: TextField(
//                                 keyboardType: TextInputType.phone,
//                                 maxLength: 10,
//                                 // minLines: 10,
//                                 controller: phoneController,
//                                 focusNode: focusNode,
//                                 decoration: InputDecoration(
//                                   counterText: '',
//                                   hintText: "Phone Number",
//                                   border: InputBorder.none,
//                                   contentPadding: EdgeInsets.all(8),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: 14,
//                         ),
//                        loadingPhoneAuth? Center(child: CircularProgressIndicator()) :ElevatedButton(onPressed: () {
//                           if(phoneController.text.length < 10){ Notify.showNotify("Wrong Phone No"); }else{Provider.of<AuthanticationProvider>(context,listen: false).verifyPhoneNumber(context,phoneController.text);setState((){loadingPhoneAuth = true;});initInteractor();onSendOtp();} 
//                         }, child: Text("Next"))
//                       ],
//                     ),
//                 ),
//           ),
//         );
//       },
//     );
//   }
// }
