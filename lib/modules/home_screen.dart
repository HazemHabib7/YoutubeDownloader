import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_downloader/show_url.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../layouts/cubit/cubit.dart';
import '../layouts/cubit/states.dart';
import '../shared/components/components.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController urlController = TextEditingController();

  var scaffoldKey = GlobalKey<ScaffoldState>();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<YoutubeCubit, YoutubeStates>(
      listener: (context, state) {
        if(state is DownloadVideoLoadingState || state is DownloadAudioLoadingState)
          defaultToast(message: "Download started", state: ToastStates.WARNING);
        if(state is DownloadVideoSuccessState || state is DownloadAudioSuccessState)
          defaultToast(message: "Download successfully", state: ToastStates.SUCCESS);
        if(state is DownloadVideoErrorState || state is DownloadAudioErrorState)
          defaultToast(message: "Download failed", state: ToastStates.ERROR);
      },
      builder: (context, state) {
        YoutubeCubit cubit = YoutubeCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter the Youtube video URL:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    SizedBox(height: 18.0),
                    defaultTextFormField(
                        validateText: 'URL field must not be empty !',
                        controller: urlController,
                        keyboardType: TextInputType.url,
                        label: 'URL',
                        prefixIcon: Icon(Icons.link_outlined)),
                    SizedBox(height: 12.0),
                    defaultButton(
                        function: () {
                          if (formKey.currentState!.validate()) {
                            if (urlController.text.contains('youtu')) {
                              cubit
                                  .getVideoInfo(url: urlController.text)
                                  .then((value) {
                                cubit.getVideoSizeInfo().then((value) {
                                  showModalBottomSheet(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    context: context,
                                    builder: (context) {
                                      return Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Container(
                                          width: double.infinity,
                                          height: 405.0,
                                          child: Column(
                                            children: [
                                              Container(
                                                child: Image(
                                                  image: NetworkImage(cubit
                                                      .video
                                                      .thumbnails
                                                      .highResUrl
                                                      .toString()),
                                                  fit: BoxFit.cover,
                                                ),
                                                height: 200.0,
                                                width: double.infinity,
                                              ),
                                              SizedBox(height: 4.0),
                                              Text(
                                                cubit.video!.title,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20.0),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    cubit.video.author,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16.0,
                                                        color: Colors.blue),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      "${cubit.video.duration.toString().split('.').first.padLeft(8, "0")}"),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Stack(
                                                children: [
                                                  defaultButton(
                                                      function: () {
                                                        cubit.downloadMp3(cubit.video.id, cubit.video.title);
                                      },
                                                      text: 'Download MP3 (${cubit.manifest?.audioOnly.withHighestBitrate().size.totalMegaBytes.toStringAsFixed(2)} MB)',
                                                      color: Colors.green,
                                                      height: 40.0,
                                                      radius: 25.0),
                                                  CircleAvatar(child: IconButton(onPressed: (){
                                                    showUrl(context,YoutubeCubit.get(context).manifest?.audioOnly.withHighestBitrate().url);
                                                  }, icon: Icon(Icons.link_rounded),color: Colors.white,),backgroundColor: Colors.blue.withOpacity(0.6),)
                                                ],
                                                alignment: Alignment.bottomRight,
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Stack(
                                                children: [
                                                  defaultButton(
                                                      function: () {
                                                        cubit.downloadMp4(cubit.video.id, cubit.video.title,context);
                                                      },
                                                      text:
                                                          'Download MP4 (${ cubit.manifest?.muxed.withHighestBitrate().qualityLabel}: ${cubit.manifest?.videoOnly.withHighestBitrate().size.totalMegaBytes.toStringAsFixed(2)} MB)',
                                                      color: Colors.purple,
                                                      height: 40.0,
                                                      radius: 25.0),
                                                CircleAvatar(child: IconButton(onPressed: (){
                                                  showUrl(context,YoutubeCubit.get(context).manifest?.muxed.withHighestBitrate().url);
                                                }, icon: Icon(Icons.link_rounded),color: Colors.white,),backgroundColor: Colors.blue.withOpacity(0.4),)
                                                ],
                                                alignment: Alignment.bottomRight,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                });
                              });
                            }
                          }
                        },
                        text: 'Download',
                        radius: 25.0),
                    if (state is GetVideoInfoLoadingState ||
                        state is GetVideoSizeInfoLoadingState)
                      SizedBox(
                        height: 16.0,
                      ),
                    if (state is GetVideoInfoLoadingState ||
                        state is GetVideoSizeInfoLoadingState)
                      Center(
                          child: Text(
                        'Getting Info...',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      )),
                    if (state is GetVideoInfoLoadingState ||
                        state is GetVideoSizeInfoLoadingState)
                      SizedBox(
                        height: 8.0,
                      ),
                    if (state is GetVideoInfoLoadingState ||
                        state is GetVideoSizeInfoLoadingState)
                      Center(child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: LinearProgressIndicator(),
                      )),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
