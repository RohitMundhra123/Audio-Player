import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:soundplayer/utils/routes.dart';

class ListAudio extends StatefulWidget {
  const ListAudio({super.key});

  @override
  State<ListAudio> createState() => _ListAudioState();
}

class _ListAudioState extends State<ListAudio> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      permissionStorage();
    });
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.black,
            title: const Text(
              'Are you sure?',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'Do you want to exit the app?',
              style: TextStyle(color: Colors.grey),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'No',
                  style: TextStyle(color: Colors.yellow),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.yellow),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Audio List'),
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
        body: !_hasPermission
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : FutureBuilder<List<SongModel>>(
                future: _audioQuery.querySongs(
                    sortType: null,
                    orderType: OrderType.ASC_OR_SMALLER,
                    uriType: UriType.EXTERNAL,
                    ignoreCase: false),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No songs found'),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          snapshot.data![index].title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          snapshot.data![index].displayName,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        leading: QueryArtworkWidget(
                          id: snapshot.data![index].id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: const Icon(
                            Icons.music_note,
                            size: 30.0,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          final data = snapshot.data;
                          Navigator.pop(context);
                          Navigator.pushNamed(context, MyRoutes.sound,
                              arguments: [data, index]);
                        },
                      );
                    },
                  );
                },
              ),
      ),
    );
  }

  void permissionStorage() async {
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        // Show a dialog box to request permission
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.black,
            title: const Text(
              'Storage Permission',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'This app needs access to your local storage to display audio files.',
              style: TextStyle(color: Colors.grey),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  bool granted = await _audioQuery.permissionsRequest();
                  if (!granted) {
                  } else {
                    setState(() {
                      _hasPermission = true;
                    });
                  }
                },
                child: const Text(
                  'Allow',
                  style: TextStyle(color: Colors.yellow),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Deny',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
      } else {
        setState(() {
          _hasPermission = true;
        });
      }
    }
  }
}

