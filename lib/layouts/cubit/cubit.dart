import 'dart:async';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_downloader/layouts/cubit/states.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../../modules/home_screen.dart';
import '../../modules/more_screen.dart';
import '../../shared/components/notifications.dart';

class YoutubeCubit extends Cubit<YoutubeStates> {
  YoutubeCubit() : super(InitialState());

  static YoutubeCubit get(context) => BlocProvider.of(context);
  bool isBottomSheet = false;
  int currentIndex = 0;
  int count = 0;

  List<Widget> screens = [
    HomeScreen(),
    MoreScreen(),
  ];

  final pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  void changeBottomNavBar(int index) {
    currentIndex = index;
    pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
    emit(ChangeBottomNavBarState());
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  var yt = YoutubeExplode();
  StreamManifest? manifest;
  late Video video;
  bool downloading = false;

  Future getVideoInfo({required String url}) {
    emit(GetVideoInfoLoadingState());
    return yt.videos.get(url).then((value) {
      video = value;
      emit(GetVideoInfoSuccessState());
    }).catchError((onError) {
      print(onError.toString());
      emit(GetVideoInfoErrorState());
    });
  }

  Future getVideoSizeInfo() {
    emit(GetVideoSizeInfoLoadingState());
    return yt.videos.streamsClient.getManifest(video.id).then((value) {
      manifest = value;
      emit(GetVideoInfoSuccessState());
    }).catchError((onError) {
      print(onError.toString());
      emit(GetVideoSizeInfoErrorState());
    });
  }

  Future downloadMp3(VideoId videoId, String name) async {
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          print("Permission Granted !\n");
          var manifest =
          await yt.videos.streamsClient.getManifest(videoId);

          var streamInfo = manifest.audioOnly;
          int count = 0;
          if (streamInfo != null) {
            var totalSize = manifest.audioOnly.withHighestBitrate().size.totalBytes;

            var stream = yt.videos.streamsClient
                .get(streamInfo.withHighestBitrate());

            createAudioDirectory().then((value) async {
              emit(DownloadAudioLoadingState());
              var file =
              File("$value/$name-${DateTime.now().millisecond}.mp3");

              var fileStream = file.openWrite(mode: FileMode.writeOnlyAppend);

              // Pipe all the content of the stream into the file.
              // await stream.pipe(fileStream);
              await for (final data in stream) {
                count += data.length;

                var progress = ((count / totalSize) * 100).ceil();
                print("$progress%");
                fileStream.add(data);


                LocalNotificationService.showProgressNotification(
                  progrss: progress,
                  maxProgress: 100,
                  title: "Downlaoding...",
                  body: name,
                );
              }
              Future.delayed(const Duration(milliseconds: 1500));
              await LocalNotificationService.cancelAllNotifications();

              // Close the file.
              await fileStream.flush();
              await fileStream.close();
              await LocalNotificationService.showNotification(
                  title: "Audio Downloaded !", body: name).then((value) {
                    emit(DownloadAudioSuccessState());
              });
              print("Audio Downloaded");
            }).catchError((onError){
              emit(DownloadAudioErrorState());
            });
            //Directory('/storage/emulated/0/Download');

          } else {
            throw "Stream Info is Null";
          }
        }
      }
    } catch (e) {
      print("downloadMp3 Method Error! = $e");
    }
  }

  downloadMp4(VideoId videoId, String name,context) async {
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          print("Permission Granted !\n");

          var streamInfo = manifest?.muxed;

          if (streamInfo != null) {
            var stream = yt.videos.streamsClient
                .get(streamInfo.withHighestBitrate());
            createVideoDirectory().then((value) async {
              emit(DownloadVideoLoadingState());
              var file =
              File("$value/$name-${DateTime.now().millisecond}.mp4");
              var fileStream = file.openWrite(mode: FileMode.writeOnlyAppend);
              int count = 0;
              var totalSize =
                  manifest?.videoOnly.withHighestBitrate().size.totalBytes;
              // Pipe all the content of the stream into the file.
              //await stream.pipe(fileStream);
              await for (final data in stream) {
                count += data.length;

                var progress = ((count / totalSize!) * 100).ceil();
                print("$progress%");
                //Show Notification
                LocalNotificationService.showProgressNotification(
                  progrss: progress,
                  maxProgress: 100,
                  title: "Downlaoding...",
                  body: name,
                );
                fileStream.add(data);
              }
              Future.delayed(const Duration(milliseconds: 1500));
              await LocalNotificationService.cancelAllNotifications();

              // Close the file.
              await fileStream.flush();
              await fileStream.close();
              await LocalNotificationService.showNotification(
                  title: "Video Downloaded !", body: name).then((value) {
                    emit(DownloadVideoSuccessState());
              });
              print("Video Downloaded");
            }).catchError((onError){
              emit(DownloadVideoErrorState());
            });

          } else {
            throw "Stream Info is Null";
          }
        }
      }
    } catch (e) {
      print("downloadMp4 Method Error! = $e");
    }
  }


  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  Future<String> createAppDirectory() async {
    var status = Permission.manageExternalStorage.status;
    if (await status.isDenied) {
      Permission.manageExternalStorage.request();
    }
    String name = "yt_downloader";
    final path = Directory("/storage/emulated/0/$name");
    if (await path.exists()) {
      print(path.path);
      return path.path;
    }

    path.create();
    print(path.path);

    return path.path;
  }

  Future<String> createAudioDirectory() async {
    String directory = await createAppDirectory();
    String name = "Audio";
    var status = Permission.manageExternalStorage.status;
    if (await status.isDenied) {
      Permission.manageExternalStorage.request();
    }
    final path = Directory("$directory/$name");
    if (await path.exists()) {
      return path.path;
    }

    path.create();
    return path.path;
  }

  Future<String> createVideoDirectory() async {
    String directory = await createAppDirectory();
    String name = "Video";
    var status = Permission.manageExternalStorage.status;
    if (await status.isDenied) {
      Permission.manageExternalStorage.request();
    }
    final path = Directory("$directory/$name");
    if (await path.exists()) {
      return path.path;
    }
    path.create();
    return path.path;
  }
}
