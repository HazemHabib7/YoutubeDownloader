import 'package:flutter/material.dart';
import 'package:youtube_downloader/shared/components/components.dart';
import 'package:youtube_downloader/shared/styles/colors.dart';

void showUrl(BuildContext context,dynamic url){
showDialog(
  context: context,
  barrierDismissible: false,
  builder:(_)=>WillPopScope(
    onWillPop: _willPopCallback,
    child: Center(
      child: SingleChildScrollView(
        child: AlertDialog(
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0)),
             content: Column(
               mainAxisSize: MainAxisSize.min,
               crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Download URL:',style: Theme.of(context).textTheme.bodyMedium),
                      SizedBox(height: 10.0,),
                      SelectableText('$url',style: TextStyle(color: Colors.grey),),
                      Row(
                        children: [
                          Spacer(),
                          defaultTextButton(function: (){Navigator.pop(context);}, text: 'Ok', color: defaultColor),
                        ],
                      ),
                    ],
                  ),
        ),
      ),
    ),
  )
  );
}
Future<bool> _willPopCallback() async {
  return false;
}