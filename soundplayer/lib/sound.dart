import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:soundplayer/utils/routes.dart';

class SoundPlayer extends StatefulWidget {
  final List<SongModel> data; // Assuming 'data' is of type dynamic
  final int index; // Assuming 'index' is of type int

  const SoundPlayer({Key? key, required this.data, required this.index})
      : super(key: key);

  @override
  State<SoundPlayer> createState() => _SoundPlayerState();
}

class _SoundPlayerState extends State<SoundPlayer> {
  final player = AudioPlayer();
  String abc = '';
  String def = '';
  double slidervalue = 0.0;
  double endslidervalue = 0.0;
  bool isPlaying = false;
  late QueryArtworkWidget queryArtworkWidget;
  IconData buttonIcon = Icons.play_arrow;
  int? musicindex;
  bool showsystem = true;
  bool showbottomappbar = false;
  String? title;

  @override
  void initState() {
    super.initState();
    queryart(widget.index);
    loadDuration(widget.index);
    getTitle(widget.index);
    _listView = buildListView();
  }

  void queryart(songindex) {
    queryArtworkWidget = QueryArtworkWidget(
      id: widget.data[songindex].id,
      quality: 100,
      type: ArtworkType.AUDIO,
      nullArtworkWidget: const Icon(
        Icons.music_note,
        color: Colors.white,
      ),
    );
  }

  void getTitle(songindex) {
    title = widget.data[songindex].title;
  }

  ListView? _listView;

  ListView buildListView() {
    return ListView.builder(
      itemCount: widget.data.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            widget.data[index].title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            widget.data[index].displayName,
            style: const TextStyle(color: Colors.grey),
          ),
          leading: QueryArtworkWidget(
            id: widget.data[index].id,
            type: ArtworkType.AUDIO,
            nullArtworkWidget: const Icon(
              Icons.music_note,
              size: 30.0,
              color: Colors.white,
            ),
          ),
          onTap: () {
            queryart(index);
            getTitle(index);
            loadDuration(index);
            setState(() {
              showsystem = !showsystem;
              showbottomappbar = !showbottomappbar;
            });
          },
        );
      },
    );
  }

  void loadDuration(songindex) async {
    final duration = await player.setAudioSource(
        AudioSource.uri(Uri.parse(widget.data[songindex].uri as String)));

    final minutes = duration!.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    final minuteSecond =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    setState(() {
      abc = duration.inHours > 0
          ? '${duration.inHours}:$minuteSecond'
          : minuteSecond;
      endslidervalue = duration.inMilliseconds.toDouble();
    });

    player.positionStream.listen((position) {
      final minute = position.inMinutes.remainder(60);
      final second = position.inSeconds.remainder(60);

      final minutesecond2 =
          '${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}';

      setState(() {
        def = position.inHours > 0
            ? '${position.inHours.toString()}:$minutesecond2'
            : minutesecond2;
        slidervalue = position.inMilliseconds.toDouble();
      });
    });
  }

  void toogleSwitch() {
    if (isPlaying) {
      player.pause();
      setState(() {
        isPlaying = false;
        buttonIcon = Icons.play_arrow;
      });
    } else {
      player.play();
      setState(() {
        isPlaying = true;
        buttonIcon = Icons.pause;
      });
    }
  }

  void seekTo(double value) {
    player.seek(Duration(milliseconds: value.toInt()));
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sound Player'),
          titleSpacing: 00.0,
          centerTitle: true,
          toolbarHeight: 60.2,
          toolbarOpacity: 0.8,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(25),
                bottomLeft: Radius.circular(25)),
          ),
          elevation: 2.00,
          backgroundColor: Colors.green,
        ),
        body: showsystem
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showsystem = !showsystem;
                          showbottomappbar = !showbottomappbar;
                        });
                      },
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.black)),
                      child: const Icon(
                        Icons.arrow_drop_down_sharp,
                        size: 40,
                      )),
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: 200, // Desired width of the container
                    height: 200, // Desired height of the container
                    child: Container(child: queryArtworkWidget),
                  ),
                  Slider(
                    activeColor: Colors.green,
                    inactiveColor: const Color.fromARGB(255, 148, 166, 148),
                    thumbColor: const Color.fromARGB(255, 30, 175, 35),
                    overlayColor: const MaterialStatePropertyAll(
                        Color.fromARGB(255, 7, 255, 36)),
                    min: 0.0,
                    max: endslidervalue,
                    value: slidervalue,
                    onChanged: (value) {
                      setState(() {
                        slidervalue = value;
                      });
                    },
                    onChangeEnd: (value) {
                      seekTo(value);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 05, 20, 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(def,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 20)),
                        ),
                        Expanded(
                          child: Text(
                              textAlign: TextAlign.right,
                              abc,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 20)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
                    child: Text(
                      title!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            seekTo(slidervalue - 10000);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green),
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(14)),
                          ),
                          child: const Icon(Icons.fast_rewind),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            toogleSwitch();
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.all(14)),
                          ),
                          child: Icon(buttonIcon),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            seekTo(slidervalue + 10000);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.all(14)),
                          ),
                          child: const Icon(Icons.fast_forward),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (musicindex == null) {
                              musicindex = widget.index;
                            } else {
                              musicindex = musicindex! - 1;
                            }
                            debugPrint(musicindex.toString());
                            queryart(musicindex! - 1);
                            loadDuration(musicindex! - 1);
                            getTitle(musicindex! - 1);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green),
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(14)),
                          ),
                          child: const Icon(Icons.skip_previous),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (musicindex == null) {
                              musicindex = widget.index;
                            } else {
                              musicindex = musicindex! + 1;
                            }
                            queryart(musicindex! + 1);
                            loadDuration(musicindex! + 1);
                            getTitle(musicindex! + 1);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.all(14)),
                          ),
                          child: const Icon(Icons.skip_next),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : _listView!,
        bottomNavigationBar: Visibility(
          visible: showbottomappbar,
          child: BottomAppBar(
            color: Colors.green,
            child: ListTile(
              leading: queryArtworkWidget,
              title: GestureDetector(
                child: Text(title!),
                onTap: () {
                  setState(() {
                    showsystem = !showsystem;
                    showbottomappbar = !showbottomappbar;
                  });
                },
              ),
              textColor: Colors.white,
              trailing: GestureDetector(
                child: Icon(buttonIcon),
                onTap: () {
                  toogleSwitch();
                },
              ),
            ),
          ),
        ),
    );
  }
}
