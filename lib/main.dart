import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:youtube_downloader/layouts/cubit/cubit.dart';
import 'package:youtube_downloader/layouts/youtube_layout.dart';
import 'package:youtube_downloader/shared/components/constants.dart';
import 'package:youtube_downloader/shared/components/notifications.dart';
import 'package:youtube_downloader/shared/networks/local/cache_helper.dart';
import 'package:youtube_downloader/shared/styles/themes.dart';
import 'bloc_observer.dart';
import 'layouts/dark_mode_cubit/dark_mode_cubit.dart';
import 'layouts/dark_mode_cubit/dark_mode_states.dart';
import 'modules/on_boarding_screen.dart';

void main() {
  BlocOverrides.runZoned(
        () async {
      WidgetsFlutterBinding.ensureInitialized();
      LocalNotificationService.intialize();
      await CacheHelper.init();
      isDark = CacheHelper.getData(key: 'isDark');
      Widget widget;
      bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
      if(onBoarding != null)
      {
        widget = YoutubeLayout();
      } else
      {
        widget = OnBoardingScreen();
      }
      runApp(MyApp(
        isDark: isDark,
        startWidget: widget,
      ));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {

  bool? isDark;
  Widget startWidget;

  MyApp({
    required this.isDark,
    required this.startWidget,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => YoutubeCubit()),
        BlocProvider(create: (context) => DarkModeCubit()..changeAppMode(fromShared: isDark)),
      ],
      child: BlocConsumer<DarkModeCubit, DarkStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme:lightTheme,
            darkTheme:darkTheme,
            themeMode:DarkModeCubit.get(context).isDark == true ? ThemeMode.dark:ThemeMode.light,
            home: startWidget,
          );
        },
      ),
    );

  }

}