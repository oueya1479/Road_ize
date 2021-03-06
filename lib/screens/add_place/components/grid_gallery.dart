import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:roadize/screens/add_road/custom_gallery.dart';
import 'package:roadize/size_config.dart';

import '../custom_gallery.dart';

class GridGallery extends StatefulWidget {
  GridGallery(this.callback, this.callback2);
  final Function callback;
  final Function callback2;

  @override
  GridGalleryState createState() => GridGalleryState();
}

class GridGalleryState extends State<GridGallery> {
  List<AssetEntity> assets = [];
  List<int> photoIndex = [];
  List<Future<File>> photos = [];
  int number;

  @override
  void initState() {
    super.initState();
    _fetchAssets();
  }

  _fetchAssets() async {
    final albums = await PhotoManager.getAssetPathList(onlyAll: true);
    final recentAlbum = albums.first;

    final recentAssets = await recentAlbum.getAssetListRange(
      start: 0,
      end: 1000000,
    );

    // Update the state and notify UI
    setState(() => assets = recentAssets);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: assets.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemBuilder: (context, index) {
        return FutureBuilder(
          future: assets[index].thumbData,
          builder: (context, snapshot) {
            final bytes = snapshot.data;
            if (bytes == null) return CircularProgressIndicator();
            return GestureDetector(
              onTap: () async {
                if (photoIndex.contains(index) == true) {
                  setState(() {
                    number = photoIndex.indexOf(index);
                    photoIndex.remove(index);
                    photos.removeAt(number);
                  });
                  this.widget.callback2(number);
                  this.widget.callback(photos);
                } else {
                  setState(() {
                    photoIndex.add(index);
                    photos.add(assets[index].file);
                  });
                  this.widget.callback(photos);
                }
                print(photoIndex);
                print(photos);
              },
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: MemoryImage(
                        bytes,
                      ),
                      fit: BoxFit.cover,
                      colorFilter: photoIndex.contains(index) == true
                          ? ColorFilter.mode(
                              Colors.black.withOpacity(0.3), BlendMode.dstIn)
                          : null,
                    )),
                  ),
                  if (photoIndex.contains(index) == true)
                    Center(
                        child: Text(
                      (photoIndex.indexOf(index) + 1).toString(),
                      style: TextStyle(
                          fontSize: SizeConfig.fontSize,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ))
                  else
                    Container()
                ],
              ),
            );
          },
        );
      },
    );
  }
}
