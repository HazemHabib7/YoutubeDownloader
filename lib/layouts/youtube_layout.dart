import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class YoutubeLayout extends StatelessWidget {

  TextEditingController urlController = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<YoutubeCubit,YoutubeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        YoutubeCubit cubit = YoutubeCubit.get(context);
        final pageController = PageController(
          initialPage: 0,
        );

        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: cubit.currentIndex == 0 ? Text('Youtube Downloader') : Text('More Option'),
            centerTitle: true,
          ),
          bottomNavigationBar: BottomNavigationBar(
            elevation: 25.0,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.info),
                label: 'More',
              ),
            ],
            type: BottomNavigationBarType.fixed,
            currentIndex: cubit.currentIndex,
            onTap: (index){
              cubit.changeBottomNavBar(index);
            },
          ),
            drawer: Drawer(
              elevation: 25.0,
              child: Column(
                children: [
                  SizedBox(height: 50.0,),
                  MaterialButton(
                      color: Colors.grey[600],
                      child: Row(
                        children: [
                          Icon(Icons.exit_to_app_rounded,color: Colors.white,),
                          SizedBox(width: 10,),
                          Text("Exit App",style: TextStyle(fontSize: 15.0,color: Colors.white),),
                        ],
                      ),
                      height: 53.0,
                      minWidth: double.infinity,
                      onPressed: (){
                        SystemNavigator.pop();
                      }
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text('𝕭𝖞 𝕰𝖓𝖌. 𝕳𝖆𝖟𝖊𝖒',style: TextStyle(color: Colors.red,fontSize: 25),),
                  ),
                ],
              ),
            ),
            body: PageView(
            controller: cubit.pageController,
            physics: BouncingScrollPhysics(),
            children: cubit.screens,
            onPageChanged: (index){
              cubit.changeBottomNavBar(index);
            },
          )
        );
      },
    );
  }
}
