import 'package:campus_assistant/colors.dart';
import 'package:campus_assistant/firebase_code/database.dart';
import 'package:campus_assistant/professor_ratings.dart';
import 'package:campus_assistant/widgets.dart';
import 'package:flutter/material.dart';

class ProfessorDetailMenu extends StatefulWidget {
  const ProfessorDetailMenu({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfessorDetailMenuState();
}

class _ProfessorDetailMenuState extends State<ProfessorDetailMenu> {
  bool _isLoading = false;
  List<Map<String, dynamic>> professorData = [];
  List<Map<String, dynamic>> subsetProfessorData = [];
  final TextEditingController _reviewController = TextEditingController();
  @override
  void initState() {
    _isLoading = true;
    super.initState();
    getProfRawData();
  }

  void getProfRawData() async {
    await DatabaseFunct().getAllProfessors().then((value) {
      setState(() {
        professorData = value;
        subsetProfessorData = professorData;
        //print(professorData);
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundGray,
      drawer: drawerWidget(context),
      appBar: appBarWidget(context, Icons.school),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: backgroundBlue,
            ))
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: ListTile(
                      trailing: GestureDetector(
                          onTap: () {
                            _searchProfessors();
                          },
                          child: const CircleAvatar(
                            backgroundColor: backgroundBlue,
                            radius: 30,
                            child: Icon(Icons.search,
                                color: Colors.white, size: 30),
                          )),
                      // left right top bottom are the parameters
                      title: SizedBox(
                          height: 100,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: backgroundBlue, width: 2)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: backgroundBlue, width: 2)),
                            ),
                            maxLines: null,
                            controller: _reviewController,
                            style: const TextStyle(color: Colors.black),
                          ))),
                ),
                (_isLoading == true)
                    ? const CircularProgressIndicator(color: backgroundBlue)
                    : (subsetProfessorData.isEmpty)
                        ? const Center(
                            child: Text(
                            "No Professor Found",
                            style: TextStyle(fontSize: 20),
                          ))
                        : Expanded(child: _professorList(subsetProfessorData)),
              ],
            ),
      floatingActionButton: backButtonWidget(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  void _searchProfessors() {
    subsetProfessorData = List<Map<String, dynamic>>.from(professorData);
    subsetProfessorData.removeWhere((element) => !(element['name']
        .toString()
        .toLowerCase()
        .contains(_reviewController.text.toLowerCase())));
    // the above removes elements where textbox info not in the prof name
    setState(() {
      subsetProfessorData; // reloads page
    });
  }

  ListView _professorList(List<Map<String, dynamic>> data) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.white,
          child: ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ProfessorRatingsPage(context,
                    professorId: data[index]['id']);
              }));
            }, //RatingsPage(context, professorId: data[index]['id']) as BuildContext
            title: Text(data[index]['name'] as String,
                style: const TextStyle(fontFamily: "Times New Roman")),
            subtitle: Text(data[index]['department'] as String,
                style: const TextStyle(fontFamily: "Times New Roman")),
            trailing: CircleAvatar(
              backgroundColor: backgroundBlue,
              child: Text(
                  (data[index]['avg_rating'] == 0)
                      ? '?'
                      : data[index]['avg_rating'].toString(),
                  style: const TextStyle(
                      fontFamily: "Times New Roman",
                      color: Colors.white,
                      fontSize: 16)),
            ),
            //subtitle: Text(data[index]['department'] as String,style: const TextStyle(fontFamily: "Times New Roman")),
          ),
        );
      },
    );
  }
}
