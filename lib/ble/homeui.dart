import 'package:flutter/material.dart';
import 'package:flutter_ble_app/constant.dart';
import 'package:sizer/sizer.dart';

class HomeUI extends StatefulWidget {
  final double sum_data;
  final double RML_data;
  final double RAP_data;

  const HomeUI(
      {Key? key,
      required this.sum_data,
      required this.RML_data,
      required this.RAP_data})
      : super(key: key);

  @override
  _HomeUIState createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  var _textEditingController = TextEditingController();
  double weigth_user = 0;
  double RSUM_SPMS = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: size.width,
                    height: size.height / 2.9,
                    child: Container(
                      decoration: BoxDecoration(
                          color: weightBG,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(70),
                            bottomRight: Radius.circular(70),
                          )),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.13),
                        child: Form(
                            child: Column(
                          children: [
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              "Sitting Posture Monitoring",
                              style: TextStyle(
                                fontSize: 23.sp,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Text(
                              "Enter your body weight",
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(0, 10),
                                      blurRadius: 50,
                                      color:
                                          Colors.amberAccent.withOpacity(0.5),
                                    ),
                                  ],
                                ),
                                child: SizedBox(
                                  width: 85.w,
                                  height: 5.h,
                                  child: TextField(
                                    controller: _textEditingController,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: "Body Weight : Kg",
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            SizedBox(
                              width: 20.w,
                              height: 5.h,
                              child: RaisedButton(
                                  onPressed: () async {
                                    weigth_user = double.parse(
                                        _textEditingController.text);
                                    // RSUM_SPMS = (widget.RML_data / weigth_user);

                                    // if ((0.4 <= widget.RML_data) &&
                                    //     (widget.RML_data <= 0.6)) {
                                    //   if ((0.2 <=
                                    //           (widget.RML_data /
                                    //               weigth_user)) &&
                                    //       ((widget.RML_data / weigth_user) <=
                                    //           0.8)) {
                                    //     if ((0.55 <= widget.RAP_data) &&
                                    //         (widget.RAP_data <= 1.0)) {
                                    //       print("True sitting");
                                    //     }
                                    //   }
                                    // } else {
                                    //   print("False sitting");
                                    // }
                                  },
                                  color: Colors.white,
                                  child: Text(
                                    'OK',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 10.sp),
                                  )),
                            ),
                            SizedBox(height: 2.h),
                          ],
                        )),
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.13),
                        child: Form(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 2.h,
                            ),
                            Text(
                              "Ratio of SPMS to body weight",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            Container(
                              width: 85.w,
                              height: 7.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24.0),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(0, 3)),
                                  ]),
                              child: Center(
                                  child: Text(
                                      "${(widget.sum_data / weigth_user).toStringAsFixed(2)}")),
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            Text(
                              "Ratio of medial-lateral",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            Container(
                              width: 85.w,
                              height: 7.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24.0),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(0, 3)),
                                  ]),
                              child: Center(child: Text("${widget.RML_data}")),
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            Text(
                              "Ratio of anterior-posterior",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            Container(
                              width: 85.w,
                              height: 7.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24.0),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(0, 3)),
                                  ]),
                              child: Center(child: Text("${widget.RAP_data}")),
                            ),
                            SizedBox(
                              height: 4.5.h,
                            ),
                            Container(
                              width: 85.w,
                              height: 20.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24.0),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.red.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                    ),
                                  ]),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if ((0.4 <= widget.RML_data) &&
                                      (widget.RML_data <= 0.6)) ...[
                                    if (((widget.sum_data / weigth_user) <
                                        0.20)) ...[
                                      Text(
                                        "Stand",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                    if ((0.20 <=
                                            (widget.sum_data / weigth_user)) &&
                                        ((widget.sum_data / weigth_user) <=
                                            0.8)) ...[
                                      if ((widget.RAP_data < 0.55)) ...[
                                        Text(
                                          "Front sitting with backrest",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ] else ...[
                                        Text(
                                          "Upright sitting with backrest",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            color: Colors.black,
                                          ),
                                        )
                                      ]
                                    ] else ...[
                                      if ((widget.RAP_data < 0.55)) ...[
                                        Text(
                                          "Front sitting without backrest",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            color: Colors.black,
                                          ),
                                        )
                                      ] else ...[
                                        Text(
                                          "Upright sitting without backrest",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ]
                                    ]
                                  ] else ...[
                                    if ((widget.RML_data < 0.40)) ...[
                                      Text(
                                        "left sitting",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          color: Colors.black,
                                        ),
                                      )
                                    ] else ...[
                                      Text(
                                        "Right sitting",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          color: Colors.black,
                                        ),
                                      )
                                    ]
                                  ]
                                ],
                              ),
                            ),
                          ],
                        )),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ));
    });
  }
}
