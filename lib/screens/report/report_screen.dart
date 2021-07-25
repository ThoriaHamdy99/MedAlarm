import 'dart:typed_data';
import 'dart:io';
import 'package:ext_storage/ext_storage.dart';
import 'package:med_alarm/screens/report/med_chart_screen.dart';
import 'package:med_alarm/screens/report/pressureChart.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart ' as pw;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:screenshot/screenshot.dart';

class ReportScreen extends StatefulWidget {
  static const id = 'REPORT_SCREEN';

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  ScreenshotController screenshotController = ScreenshotController();


  Uint8List _imageFile;

  @override
  void initState() {
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Report"),
        ),
        body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(15.0),
                    child: Row(children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(width: 2, color: Colors.indigo),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(width: 2, color: Colors.indigo),
                                borderRadius: BorderRadius.circular(20.0)),
                            labelText: "Systolic:",
                            labelStyle:
                            TextStyle(fontSize: 25, color: Colors.blueAccent),
                            hintText: "Enter top number",
                            hintStyle:
                            TextStyle(fontSize: 15, color: Colors.black54),
                          ),
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(width: 2, color: Colors.indigo),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(width: 2, color: Colors.indigo),
                                borderRadius: BorderRadius.circular(20.0)),
                            labelText: "Diastolic:",
                            labelStyle:
                            TextStyle(fontSize: 25, color: Colors.blueAccent),
                            hintText: "Enter bottom number",
                            hintStyle:
                            TextStyle(fontSize: 15, color: Colors.black54),
                          ),
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ]),
                  ),
                  Screenshot(
                    controller: screenshotController,
                    child: Container(
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MedChart(),
                            SizedBox(
                              height: 20,
                            ),
                            PointsLineChart.withSampleData(),
                          ],
                        )),
                  ),
                  const SizedBox(height: 120),

                  // Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 20)),
                    onPressed: () {
                      screenshotController
                          .capture(delay: Duration(milliseconds: 10))
                          .then((Uint8List image) {
                        setState(() {
                          getPdf(image);
                        });
                      }).catchError((onError) {
                        print(onError);
                      });
                    },
                    child: const Text('Send'),
                  ),
                ],
              ),
            )
        )
    );
  }

  Future getPdf(Uint8List screenShot) async {
    pw.Document pdf = pw.Document();
    final image = pw.MemoryImage(
      screenShot, //Uint8List
    );
    // storage permission ask
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    String path = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
    File file = File('$path/example.pdf');
    print(path);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Expanded(
            child: pw.Image(image),
          );
        },
      ),
    );
    File pdfFile = file;
    pdfFile.writeAsBytesSync(await pdf.save());
  }
}
