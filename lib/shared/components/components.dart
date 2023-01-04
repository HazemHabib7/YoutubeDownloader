import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget defaultButton({
  required Function function,
  required String text,
  bool isUpper = true,
  Color color = Colors.blue,
  double radius = 0.0,
  double width = double.infinity,
  double height = 50.0,
}) =>
    Container(
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(radius)),
      height: height,
      width: width,
      child: MaterialButton(
        onPressed: () {
          function();
        },
        child: Text(
          isUpper ? text.toUpperCase() : text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );

Widget defaultOutlinedButton({
  required Function function,
  required String text,
  bool isUpper = true,
  double radius = 0.0,
  double width = double.infinity,
  double height = 50.0,
}) =>
    Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius)),
      height: height,
      width: width,
      child: OutlinedButton(
        onPressed: () {
          function();
        },
        child: Text(
          isUpper ? text.toUpperCase() : text,
        ),
      ),
    );

Widget defaultTextFormField({
  required String validateText,
  required TextEditingController controller,
  required TextInputType keyboardType,
  required String label,
  required Icon prefixIcon,
  Widget? suffixIcon = null,
  bool isPassword = false,
  Function? onSubmit,
  Function? onTap,
  Function? onChange,
  bool readOnly = false,
}) =>
    TextFormField(

      validator: (value) {
        if (value!.isEmpty) {
          return validateText;
        }
      },
      onTap: () {
        onTap!();
      },
      readOnly: readOnly,
      obscureText: isPassword,
      controller: controller,
      onFieldSubmitted: (value) {
        onSubmit!();
      },
      onChanged: (value) {
        onChange!();
      },
      keyboardType: keyboardType,
      decoration: InputDecoration(
        fillColor: Colors.white,

        labelText: label,
        border: new OutlineInputBorder(
      borderRadius: new BorderRadius.circular(25.0),
      borderSide: BorderSide(color: Colors.white),
    ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );


Widget buildDivider(){
  return Padding(
    padding: const EdgeInsets.only(left: 20.0),
    child: Container(
      color: Colors.grey[300],
      height: 1.0,
      width: double.infinity,
    ),
  );
}

Future navigateTo (context,widget){
  return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget
  ));

}

Future navigateAndFinish (context,widget){
  return Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => widget
      ),
    (route) {
      return false;
    },
  );

}

Widget defaultTextButton({
  required Function function,
  required String text,
  required Color color,
  bool isUpper = true,
})
{
  return TextButton(onPressed: (){
    function();
  }, child: Text(isUpper ? text.toUpperCase() : text,style: TextStyle(color: color),));
}

Future<bool?> defaultToast({
  required String message,
  required ToastStates state,
}){
  return Fluttertoast.showToast(
    msg: message,
    backgroundColor: chooseToastColor(state),
  );
}

enum ToastStates{SUCCESS,ERROR,WARNING}

Color chooseToastColor(ToastStates state){
  Color color;
  switch(state){
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;

}