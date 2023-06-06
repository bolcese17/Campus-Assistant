import 'package:campus_assistant/colors.dart';
import 'package:campus_assistant/firebase_code/database.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:campus_assistant/widgets.dart';

class ProfessorRatingsPage extends StatefulWidget {
  final String professorId;
  const ProfessorRatingsPage(BuildContext context,
      {super.key, required this.professorId});

  @override
  State<StatefulWidget> createState() => _ProfessorRatingsPageState();
}

class _ProfessorRatingsPageState extends State<ProfessorRatingsPage> {
  bool _isLoading = true;
  List<Map<String, dynamic>> reviewItems = [];
  String professorName = '';
  num averageRating = 0.0;
  String dept = '';

  void getFirebaseData(String professorId) async {
    _isLoading = true;
    await DatabaseFunct().getProfessorById(widget.professorId).then((value) {
      setState(() {
        professorName = value['name'];
        averageRating = value['avg_rating'] as num;
        dept = value['department'];
      });
    });
    await DatabaseFunct().getProfessorReviews(professorId).then((value) {
      //Temporary list to store the reviews while they're being parsed
      setState(() {
        reviewItems = value;
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    getFirebaseData(widget.professorId);
    super.initState();
  }

  num _rating = 0;
  final TextEditingController _reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //debugPrint("professor ID $args");
    return Scaffold(
      backgroundColor: backgroundGray,
      drawer: drawerWidget(context),
      appBar: appBarWidget(context, Icons.rate_review),
      body: Column(
        children: [
          (_isLoading == true)
              ? const ListTile(title: Text(""))
              : ListTile(
                  title: Text(professorName,
                      style: const TextStyle(
                          fontFamily: "Times New Roman",
                          color: textBlue,
                          fontSize: 30,
                          fontWeight: FontWeight.w500)),
                  subtitle: Text("Department: $dept",
                      style: const TextStyle(
                          fontFamily: "Times New Roman",
                          color: textBlue,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                  trailing: CircleAvatar(
                    backgroundColor: backgroundBlue,
                    child: Text(
                        (averageRating == 0) ? '?' : averageRating.toString(),
                        style: const TextStyle(
                            fontFamily: "Times New Roman",
                            color: Colors.white,
                            fontSize: 16)),
                  ),
                ),
          SizedBox(
              height: 100,
              child: Container(
                padding: const EdgeInsets.fromLTRB(
                    10, 5, 10, 5), // left right top bottom are the parameters
                child: TextFormField(
                  maxLines: null,
                  controller: _reviewController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                      fillColor: Colors.white,
                      hintText: "Write a rating...",
                      hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: "Times New Roman"),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: backgroundBlue, width: 2)),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: backgroundBlue, width: 2)),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: backgroundBlue, width: 2))),
                ),
              )),
          starsInputWidget(),
          const Divider(
              color: backgroundBlue, thickness: 2, indent: 10, endIndent: 10),
          (_isLoading == true)
              ? const CircularProgressIndicator(color: backgroundBlue)
              : (reviewItems.isEmpty)
                  ? Container(
                      alignment: Alignment.center,
                      child: const Text('No Reviews',
                          style: TextStyle(
                              fontFamily: "Times New Roman",
                              color: textBlue,
                              fontSize: 30,
                              fontWeight: FontWeight.w500)))
                  : Expanded(child: reviewItemWidget(reviewItems))
        ],
      ),
      floatingActionButton: backButtonWidget(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  ListTile starsInputWidget() {
    return ListTile(
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            child: Icon(
              Icons.star,
              color: (_rating >= 1) ? iconBlue : Colors.grey,
              size: 30,
            ),
            onTap: () {
              updateRating(1);
            },
          ),
          GestureDetector(
            child: Icon(
              Icons.star,
              color: (_rating >= 2) ? iconBlue : Colors.grey,
              size: 30,
            ),
            onTap: () {
              updateRating(2);
            },
          ),
          GestureDetector(
            child: Icon(
              Icons.star,
              color: (_rating >= 3) ? iconBlue : Colors.grey,
              size: 30,
            ),
            onTap: () {
              updateRating(3);
            },
          ),
          GestureDetector(
            child: Icon(
              Icons.star,
              color: (_rating >= 4) ? iconBlue : Colors.grey,
              size: 30,
            ),
            onTap: () {
              updateRating(4);
            },
          ),
          GestureDetector(
            child: Icon(
              Icons.star,
              color: (_rating >= 5) ? iconBlue : Colors.grey,
              size: 30,
            ),
            onTap: () {
              updateRating(5);
            },
          ),
        ],
      ),
      trailing: ElevatedButton(
          onPressed: () {
            debugPrint(widget.professorId);
            createRating();
          },
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(backgroundBlue)),
          child: const Text('Submit')),
    );
  }

  void updateRating(num r) {
    setState(() {
      _rating = r;
    });
  }

  void createRating() {
    try {
      if (_reviewController.text.isNotEmpty) {
        DatabaseFunct().addProfessorReview(
            widget.professorId,
            _reviewController.text,
            _rating,
            FirebaseAuth.instance.currentUser!.uid,
            DateTime.now().millisecondsSinceEpoch.toString());
        setState(() {
          _reviewController.clear();
        });
        updateRating(0);
        getFirebaseData(widget.professorId);
      }
    } on Error catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteReviewDialog(String professorId, String reviewId,
      String userId, String reviewText) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              'Are you sure you want to delete \'${reviewText.substring(0, (reviewText.length < 25) ? reviewText.length : 25)}...\'?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[Text("Please click to confirm.")],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Close',
                style: TextStyle(color: textBlue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Confirm',
                style: TextStyle(color: textBlue),
              ),
              onPressed: () {
                deleteReview(professorId, reviewId, userId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void deleteReview(String professorId, String reviewId, String userId) async {
    debugPrint('$professorId and $reviewId, and $userId');
    await DatabaseFunct().deleteProfessorReview(professorId, reviewId, userId);
    getFirebaseData(widget.professorId);
    debugPrint('DONE');
  }

  ListView reviewItemWidget(List<Map<String, dynamic>> data) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Card(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(title: Text(data[index]['review_text'])),
                Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        stars(data[index]['rating'] as num),
                        //Text(data[index]['user_id']),
                      ],
                    )),
                (isAdmin)
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            //const Expanded(child: Spacer()),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: buttonBlue),
                                onPressed: () {
                                  deleteReviewDialog(
                                    //String foodStoreId, String reviewId, String userId, String reviewText
                                    data[index]['professor_id'] as String,
                                    data[index]['id'] as String,
                                    data[index]['user_id'] as String,
                                    data[index]['review_text'] as String,
                                  );
                                },
                                child: const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: Text(
                                    "Delete ",
                                  ),
                                ))
                          ],
                        ))
                    : Container()
              ],
            ));
      },
    );
  }
}
