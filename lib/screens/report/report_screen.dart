import 'dart:typed_data';
import 'dart:io';
import 'package:ext_storage/ext_storage.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart ' as pw;
import 'package:med_alarm/custom_widgets/charts/med_chart_screen.dart';
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
        body: Center(
          child: Column(
            children: [
              Screenshot(
                controller: screenshotController,
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: MedChart.withSampleData()),
              ),
              Spacer(),
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
        ));
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
