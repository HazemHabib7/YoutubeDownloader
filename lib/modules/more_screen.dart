import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_downloader/modules/web_view_screen.dart';
import '../layouts/dark_mode_cubit/dark_mode_cubit.dart';
import '../layouts/dark_mode_cubit/dark_mode_states.dart';
import 'info_screen.dart';

class MoreScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DarkModeCubit,DarkStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 8.0),
                MaterialButton(
                    color: Colors.grey[600],
                    child: Row(
                      children: [
                        Icon(Icons.brightness_4_outlined,color: Colors.white,),
                        SizedBox(width: 10,),
                        Text("Change appearance mode",style: TextStyle(fontSize: 15.0,color: Colors.white),),
                      ],
                    ),
                    height: 53.0,
                    minWidth: double.infinity,
                    onPressed: (){
                      DarkModeCubit.get(context).changeAppMode();
                    }
                ),
                SizedBox(height: 5.0),

                MaterialButton(
                    color: Colors.grey[600],
                    child: Row(
                      children: [
                        Icon(Icons.info_outline_rounded,color: Colors.white,),
                        SizedBox(width: 10,),
                        Text("Terms of Service and Privace Policy",style: TextStyle(fontSize: 15.0,color: Colors.white),),
                      ],
                    ),
                    height: 53.0,
                    minWidth: double.infinity,
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){return InfoScreen();}));
                    }
                ),
                SizedBox(height: 5.0),

                MaterialButton(
                    color: Colors.grey[600],
                    child: Row(
                      children: [
                        Icon(Icons.facebook_outlined,color: Colors.white,),
                        SizedBox(width: 10,),
                        Text("Visit our Facebook page",style: TextStyle(fontSize: 15.0,color: Colors.white),),
                      ],
                    ),
                    height: 53.0,
                    minWidth: double.infinity,
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){return WebViewScreen('https://www.facebook.com/');}));

                    }
                ),
                SizedBox(height: 5.0),

                MaterialButton(
                    color: Colors.grey[600],
                    child: Row(
                      children: [
                        Icon(Icons.perm_device_info_outlined,color: Colors.white,),
                        SizedBox(width: 10,),
                        Text("Version: 1.0.0",style: TextStyle(fontSize: 15.0,color: Colors.white),),
                      ],
                    ),
                    height: 53.0,
                    minWidth: double.infinity,
                    onPressed: (){

                    }
                ),

              ],
            ),
          ),
        );
      },
    );

  }
}