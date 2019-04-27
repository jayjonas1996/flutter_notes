import 'package:flutter/material.dart';
//import 'package:flutter/src/rendering/sliver.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../Views/StaggeredTiles.dart';
import '../Models/Note.dart';
import '../Models/SqliteHandler.dart';
import 'dart:convert';
import '../Models/Utility.dart';
import 'HomePage.dart';

//enum viewType {
//  List,
//  Staggered
//}


class StaggeredGridPage extends StatefulWidget {

  final notesViewType;

  const StaggeredGridPage({Key key, this.notesViewType}) : super(key: key);

  @override
  _StaggeredGridPageState createState() => _StaggeredGridPageState();


}



class _StaggeredGridPageState extends State<StaggeredGridPage> {




  var  noteDB = NotesDBHandler();
  var _allNotesInDict = [];
  List<Map<String, dynamic>> _allNotesInQueryResult = [];
  viewType notesViewType ;

@override
  void initState() {

    super.initState();
    this.notesViewType = widget.notesViewType;
  }


@override void setState(fn) {
    // TODO: implement setState

    super.setState(fn);
    this.notesViewType = widget.notesViewType;
  }

  @override
  Widget build(BuildContext context) {

    var shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600 ;
GlobalKey _stagKey = GlobalKey();
    
    print("update needed?: ${CentralStation.updateNeeded}");
    if(CentralStation.updateNeeded) {
      retrieveAllNotesFromDatabase();
    }
    return OrientationBuilder(
        builder: (context, orientation) {
      return Container(child: Padding(padding:  _paddingForView(context)/*EdgeInsets.all(8.0)*/ , child:

      new StaggeredGridView.count(key: _stagKey,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        crossAxisCount: _colForStaggeredView(context,orientation),
        children: List.generate(_allNotesInQueryResult.length/*_allNotesInDict.length*/, (i){ return _tileGenerator(i) ; }),//_tilesFromAllData(),
//        staggeredTiles:  List.generate(_allNotesInDict.length, (i){ return StaggeredTile.fit(widget.notesViewType == viewType.List ? 1 : 2); })  /*_tilesSize*/,)
      staggeredTiles: _tilesForView() ,
          ),
      ) );

        } );

  }

  int _colForStaggeredView(BuildContext context,Orientation orient) {

      if (widget.notesViewType == viewType.List)
        {          return 1;        }
      // for width larger than 600, return 6 irrelevant of the orientation
      if(MediaQuery.of(context).size.width > 600){
        return 6;
      }
      return 4;
      //  return orient == Orientation.landscape ? 6 : 4 ;
  }

 List<StaggeredTile> _tilesForView() {
  return List.generate(_allNotesInQueryResult.length/*_allNotesInDict.length*/,(index){ return StaggeredTile.fit( widget.notesViewType == viewType.List ? 1 : 2 ); }
  ) ;
}


EdgeInsets _paddingForView(BuildContext context){
  double width = MediaQuery.of(context).size.width;
  print(MediaQuery.of(context).size);
  double padding ;
  double top_bottom = 8;
  int cols ;
  if (width > 500) {
    cols = 4;
    padding = ( width ) * 0.05 ; // 10% on both side
  } else if (width > 600) {
    cols = 6;
    padding = ( width ) * 0.05 ;
  } else {
    cols = 4;
    padding = 8;
  }
  return EdgeInsets.only(left: padding, right: padding, top: top_bottom, bottom: top_bottom);

}


  MyStaggeredTile _tileGenerator(int i){

 return MyStaggeredTile(  Note(
      _allNotesInQueryResult[i]["id"],
      _allNotesInQueryResult[i]["title"] == null ? "" : utf8.decode(_allNotesInQueryResult[i]["title"]),
      _allNotesInQueryResult[i]["content"] == null ? "" : utf8.decode(_allNotesInQueryResult[i]["content"]),
     DateTime.fromMillisecondsSinceEpoch(_allNotesInQueryResult[i]["date_created"] * 1000),
     DateTime.fromMillisecondsSinceEpoch(_allNotesInQueryResult[i]["date_last_edited"] * 1000),
      Color(_allNotesInQueryResult[i]["note_color"] ))
  );



//    return MyStaggeredTile( Note(_allNotesInDict[i].id,   // later when selestAll will be returning "List<Map<String,dynamic>>" use ["id"] instead of .id
//        _allNotesInDict[i].title,
//        _allNotesInDict[i].content,
//        _allNotesInDict[i].date_created,
//        _allNotesInDict[i].date_last_edited,
//        _allNotesInDict[i].note_color,
//         ) ) ;
  }



  void retrieveAllNotesFromDatabase() {   // queries for all the notes from the database ordered by latest edited note. excludes archived notes.
    //var _data =  noteDB.selectAllNotes();

    var _testData = noteDB.testSelect();


    _testData.then((value){
        setState(() {
          this._allNotesInQueryResult = value;
          CentralStation.updateNeeded = false;
        });


    });

//    _data.then((value) {
//      setState(() {
//        _allNotesInDict = value;
//        CentralStation.updateNeeded = false;
//      });
//
//    });
  }





}




