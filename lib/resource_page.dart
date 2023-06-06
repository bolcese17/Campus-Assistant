import 'package:campus_assistant/widgets.dart';
import 'package:campus_assistant/firebase_code/database.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'colors.dart';

class ResourcePage extends StatefulWidget {
  const ResourcePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ResourcePageState();
}

class _ResourcePageState extends State<ResourcePage> {
  bool _isLoading = false;
  List<Map<String, dynamic>> resourceData = [];
  List<Map<String, dynamic>> subsetResourceData = [];
  final TextEditingController _reviewController = TextEditingController();

  @override
  void initState() {
    _isLoading = true;
    super.initState();
    getResourceRawData();
  }

  void getResourceRawData() async {
    await DatabaseFunct().getAllResources().then((value) {
      setState(() {
        resourceData = value;
        subsetResourceData = resourceData;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundGray,
      drawer: drawerWidget(context),
      appBar: appBarWidget(context, Icons.people_outline_outlined),
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
                              _searchResources();
                            },
                            child: const CircleAvatar(
                              backgroundColor: backgroundBlue,
                              radius: 30,
                              child: Icon(Icons.search,
                                  color: Colors.white, size: 30),
                            )),
                        // left right top bottom are the parameters
                        title: TextFormField(
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
                Expanded(child: _resourceList(subsetResourceData)),
              ],
            ),
      floatingActionButton: backButtonWidget(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  void _searchResources() {
    subsetResourceData = List<Map<String, dynamic>>.from(resourceData);
    subsetResourceData.removeWhere((element) => !(element['name']
        .toString()
        .toLowerCase()
        .contains(_reviewController.text.toLowerCase())));
    // the above removes elements where textbox info not in the prof name
    setState(() {
      subsetResourceData; // reloads page
    });
  }

  ListView _resourceList(List<Map<String, dynamic>> data) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.white,
          child: ListTile(
            onTap: () async {
              Uri tileURL = Uri.parse(data[index]['link']);
              if (!await launchUrl(tileURL)) {
                throw Exception('Cannot open URL $tileURL');
              }
            },
            title: Text(data[index]['name'] as String,
                style: const TextStyle(fontFamily: "Times New Roman")),
            subtitle: Text(data[index]['room'] + "\n" + data[index]['phone'],
                style: const TextStyle(fontFamily: "Times New Roman")),
          ),
        );
      },
    );
  }
}
