import 'package:campus_assistant/user_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseFunct {
  final String? uid;
  DatabaseFunct({this.uid});

  // COLLECTION NAMES
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  final CollectionReference courseCollection =
      FirebaseFirestore.instance.collection("courses");

  final CollectionReference professorCollection =
      FirebaseFirestore.instance.collection("professors");

  final CollectionReference reviewsCollection =
      FirebaseFirestore.instance.collection("reviews");

  final CollectionReference foodStoresCollection =
      FirebaseFirestore.instance.collection("food_stores");

  final CollectionReference resourcesCollection =
      FirebaseFirestore.instance.collection("resources");

  final CollectionReference shuttleCollection =
      FirebaseFirestore.instance.collection("shuttles");

  //// USER CRUDS ////
  // update user info
  Future updateUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "uid": uid,
      "status": true,
      "admin": false
    });
  }

  Future<List<Map<String, dynamic>>> getAllUserData() async {
    List<Map<String, dynamic>> output = [];
    return await userCollection.get().then(
      (querySnap) {
        debugPrint('Success');
        for (var docSnap in querySnap.docs) {
          Map<String, dynamic> temp = docSnap.data() as Map<String, dynamic>;
          temp['id'] = docSnap.id;
          output.add(temp);
        }
        //debugPrint('$output');
        return output;
      },
      onError: (e) {
        debugPrint("Error getting document: $e");
        return [];
      },
    );
  }

  // get user info
  Future gettingUserData(String email) async {
    QuerySnapshot snap =
        await userCollection.where("email", isEqualTo: email).get();
    return snap;
  }

  // if current user is admin
  Future<bool> currentUserIsAdmin() async {
    final userCollection = FirebaseFirestore.instance.collection("users");
    final currentUserDoc = await userCollection.doc(uid).get();
    final currentUserData = currentUserDoc.data();
    //return currentUserData?['admin'];
    final isAdmin = await UserStatus().getUserAdminStatus();
    return isAdmin as bool;
  }

  //// PROFESSOR CRUDS ////
  // getting professor data @kamleenb for all professor
  Future<List<Map<String, dynamic>>> getAllProfessors() async {
    List<Map<String, dynamic>> output = [];
    return await professorCollection.get().then(
      (querySnap) {
        //print('Success');
        for (var docSnap in querySnap.docs) {
          Map<String, dynamic> temp = docSnap.data() as Map<String, dynamic>;
          temp['id'] = docSnap.id;
          output.add(temp);
          /* Testing */
          //Map<String, dynamic> profMap = docSnap.data();
          //print('${docSnap.id} => ${docSnap.data()}');
          //print("Name: ${profMap['name']}");
          //print("Rating ${profMap['rating']}");
          //print("Dept ${profMap['department']}");
        }
        // print("output $output");
        return output;
      },
      onError: (e) {
        debugPrint("Error getting document: $e");
        return [];
      },
    );
  }

  // getting professor data @kamleenb for one  professor
  Future<Map<String, dynamic>> getProfessorById(String id) async {
    return await professorCollection.doc(id).get().then((DocumentSnapshot doc) {
      return doc.data() as Map<String, dynamic>;
    }, onError: (e) => debugPrint('Error getting document $e'));
  }

  Future<void> updateAvgRating(String id, String collectionName) async {
    final collection = FirebaseFirestore.instance.collection(collectionName);
    final reviewsCollection = (collectionName == "food_stores")
        ? FirebaseFirestore.instance.collection('vendorReviews')
        : FirebaseFirestore.instance.collection('reviews');
    final querySnapshot = await reviewsCollection
        .where('${collectionName.substring(0, collectionName.length - 1)}_id',
            isEqualTo: id)
        .get();

    final List<num> reviews = querySnapshot.docs.map((doc) {
      return doc.data()['rating'] as num;
    }).toList();
    num sum = reviews.fold(0, (previous, current) => previous + current);

    if (reviews.isEmpty) {
      await collection.doc(id).update({'avg_rating': 0});
    } else {
      final avgRating = num.parse((sum / reviews.length).toStringAsFixed(2));
      print('avg ratingggggg ${avgRating}');
      await collection.doc(id).update({'avg_rating': avgRating});
    }
  }

  /*
  Bug testing 
  Future<void> getAvgRating(String id) async {
    //final collection = FirebaseFirestore.instance.collection(collectionName);
    final reviewsCollection = FirebaseFirestore.instance.collection('reviews');
    final querySnapshot = await reviewsCollection.get();
    final List<num> reviews = querySnapshot.docs.map((doc) {
      return doc.data()['rating'] as num;
    }).toList();
    num sum = reviews.fold(0, (previous, current) => previous + current);
    print(reviews.toString());
    print(sum);
    print(reviews.length);
    print(sum);
    print(sum / reviews.length);
    print(num.parse((sum / reviews.length).toStringAsFixed(2)));
  }*/

  // add a review for a professor
  Future<void> addProfessorReview(String professorId, String reviewText,
      num rating, String userId, String timestamp) async {
    final reviewsCollection = FirebaseFirestore.instance.collection('reviews');
    await reviewsCollection.add({
      'professor_id': professorId,
      'review_text': reviewText,
      'rating': rating,
      'user_id': userId,
      'time': timestamp
    });
    await updateAvgRating(professorId, "professors");
  }

//get all Professor Reviews
  Future<List<Map<String, dynamic>>> getProfessorReviews(
      String professorId) async {
    //final reviewsCollection = FirebaseFirestore.instance.collection('reviews');
    List<Map<String, dynamic>> output = [];
    //print("professorId in funct $professorId");
    return await reviewsCollection
        .where('professor_id', isEqualTo: professorId)
        //.orderBy('time') // does not work
        .get()
        .then((querySnap) {
      for (var docSnap in querySnap.docs) {
        Map<String, dynamic> temp = docSnap.data() as Map<String, dynamic>;
        temp['id'] = docSnap.id;
        output.add(temp);
        //print('${docSnap.id} -> ${docSnap.data()}');
      }
      //print('output ${output.length}');
      //print('output $output');
      return output;
    }, onError: (e) {
      debugPrint("Error getting document: $e");
    });
  }

  // update a review for a professor
  Future<void> updateProfessorReview(
      String professorId,
      String reviewId,
      String reviewText,
      NumericFocusOrder rating,
      String userId,
      String timestamp) async {
    final reviewsCollection = FirebaseFirestore.instance.collection('reviews');
    final reviewDoc =
        await reviewsCollection.doc(reviewId).get(); // Get the review document
    final reviewData = reviewDoc.data();
    // May be a null error here
    final userIsAdmin = await currentUserIsAdmin();
    if (userIsAdmin ||
        reviewData?['user_id'] == userId &&
            reviewData?['professor_id'] == professorId) {
      // Update the review with the new data
      await reviewsCollection.doc(reviewId).update(
          {'review_text': reviewText, 'rating': rating, 'time': timestamp});
      await updateAvgRating(professorId, "professors");
    } else {
      // Throw an error if the review is not written by the user or not for the specified professor
      throw Exception('Review does not exist or cannot be updated');
    }
  }

  Future<void> deleteProfessorReview(
      String professorId, String reviewId, String userId) async {
    final reviewsCollection = FirebaseFirestore.instance.collection('reviews');
    final reviewDoc = await reviewsCollection.doc(reviewId).get();
    final reviewData = reviewDoc.data();
    final userIsAdmin = await currentUserIsAdmin();
    if (userIsAdmin ||
        reviewData?['user_id'] == userId &&
            reviewData?['professor_id'] == professorId) {
      await reviewsCollection.doc(reviewId).delete();
      await updateAvgRating(professorId, "professors");
    } else {
      throw Exception('Review does not exist or cannot be deleted');
    }
  }

  //// COURSE CRUDS ////
  Future<void> addCourseData(String name, String department, String professorId,
      String description) async {
    await courseCollection.doc().set({
      "name": name,
      "department": department,
      "professor_id": professorId,
      "description": description
    });
  }

  Future updateCourseData(String name, String department, String professorId,
      String description) async {
    await courseCollection.doc().set({
      "name": name,
      "department": department,
      "professor_id": professorId,
      "description": description
    });
  }

  Future<List<Map<String, dynamic>>> gettingCourseData(String name) async {
    QuerySnapshot querySnapshot =
        await courseCollection.where("name", isEqualTo: name).get();

    List<Map<String, dynamic>> courseData = [];

    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> courseMap = doc.data() as Map<String, dynamic>;
      courseData.add(courseMap);
    });

    return courseData;
  }

  Future<List<Map<String, dynamic>>> gettingShuttleData(String id) async {
    QuerySnapshot querySnapshot =
        await shuttleCollection.where("id", isEqualTo: id).get();

    List<Map<String, dynamic>> shuttleData = [];

    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> shuttleMap = doc.data() as Map<String, dynamic>;
      shuttleData.add(shuttleMap);
    });

    return shuttleData;
  }

  //// FOOD STORE CRUDS ////
  //location is the coordinates, might need to change to address. depends on google maps API.
  Future<void> addFoodStore(
      String name, bool veganOption, GeoPoint location, String menu) async {
    await foodStoresCollection.add({
      'name': name,
      'vegan_option': veganOption,
      'location': location,
      'avg_rating': 0,
      'menu': menu
    });
  }

  Future<Map<String, dynamic>> getFoodStoreById(String id) async {
    return await foodStoresCollection.doc(id).get().then(
        (DocumentSnapshot doc) {
      return doc.data() as Map<String, dynamic>;
    }, onError: (e) => debugPrint('Error getting document $e'));
  }

  Future<List<Map<String, dynamic>>> getAllFoodStores() async {
    List<Map<String, dynamic>> output = [];
    return await foodStoresCollection.get().then(
      (querySnap) {
        debugPrint('Success');
        for (var docSnap in querySnap.docs) {
          Map<String, dynamic> temp = docSnap.data() as Map<String, dynamic>;
          temp['id'] = docSnap.id;
          output.add(temp);
        }
        debugPrint('$output');
        return output;
      },
      onError: (e) {
        debugPrint("Error getting document: $e");
        return [];
      },
    );
  }

  Future<void> updateFoodStore(String id, String name, bool veganOption,
      GeoPoint location, String menu) async {
    return foodStoresCollection.doc(id).update({
      'name': name,
      'vegan_option': veganOption,
      'location': location,
      'menu_pic': menu
    });
  }

  Future<void> deleteFoodStore(String id) async {
    await foodStoresCollection.doc(id).delete();
  }

  //// FOOD STORE REVIEW CRUDS ////
// Add a review for a food store
  Future<void> addFoodStoreReview(String foodStoreId, String reviewText,
      num rating, String userId, String timestamp) async {
    final reviewsCollection =
        FirebaseFirestore.instance.collection('vendorReviews');
    await reviewsCollection.add({
      'food_store_id': foodStoreId,
      'review_text': reviewText,
      'rating': rating,
      'user_id': userId,
      'time': timestamp
    });

    await updateAvgRating(foodStoreId, "food_stores");
  }

// Get all reviews for a specific food store ID
  Future<List<Map<String, dynamic>>> getFoodStoreReviews(
      String foodStoreId) async {
    final reviewsCollection =
        FirebaseFirestore.instance.collection('vendorReviews');
    List<Map<String, dynamic>> output = [];
    return await reviewsCollection
        .where('food_store_id', isEqualTo: foodStoreId)
        .get()
        .then((querySnap) {
      for (var docSnap in querySnap.docs) {
        Map<String, dynamic> temp = docSnap.data();
        temp['id'] = docSnap.id;
        output.add(temp);
        print('${docSnap.id} -> ${docSnap.data()}');
      }
      print('output ${output.length}');
      return output;
    }, onError: (e) {
      debugPrint("Error getting document: $e");
    });
  }

// Update a review for a food store
  Future<void> updateFoodStoreReview(String foodStoreId, String reviewId,
      String reviewText, num rating, String userId, String timestamp) async {
    final reviewsCollection =
        FirebaseFirestore.instance.collection('vendorReviews');
    final reviewDoc =
        await reviewsCollection.doc(reviewId).get(); // Get the review document
    final reviewData = reviewDoc.data();
    // Check if the user wrote the review and the review is for the specified food store
    final userIsAdmin = await currentUserIsAdmin();
    if (userIsAdmin ||
        reviewData?['user_id'] == userId &&
            reviewData?['food_store_id'] == foodStoreId) {
      // Update the review with the new data
      await reviewsCollection.doc(reviewId).update(
          {'review_text': reviewText, 'rating': rating, 'time': timestamp});
      await updateAvgRating(foodStoreId, "food_stores");
    } else {
      // Throw an error if the review is not written by the user or not for the specified food store
      throw Exception('Review does not exist or cannot be updated');
    }
  }

  Future<Map<String, dynamic>> getFoodStoreReviewById(String id) async {
    return await FirebaseFirestore.instance
        .collection('vendorReviews')
        .doc(id)
        .get()
        .then((DocumentSnapshot doc) {
      return doc.data() as Map<String, dynamic>;
    }, onError: (e) => debugPrint('Error getting document $e'));
  }

// Delete a review for a food store
  Future<void> deleteFoodStoreReview(
      String foodStoreId, String reviewId, String userId) async {
    final reviewData = await DatabaseFunct().getFoodStoreReviewById(reviewId);
    final userIsAdmin = await currentUserIsAdmin();
    if ((userIsAdmin || reviewData['user_id'] == userId) &&
        reviewData['food_store_id'] == foodStoreId) {
      await FirebaseFirestore.instance
          .collection('vendorReviews')
          .doc(reviewId)
          .delete();
      await updateAvgRating(foodStoreId, "food_stores");
    } else {
      throw Exception('Review does not exist or cannot be deleted');
    }
  }

  // get global reviews, can read by userID, storeID, or profID
  Future<List<Map<String, dynamic>>> getGlobalReviews({
    String? userId,
    String? storeId,
    String? professorId,
  }) async {
    Query<Map<String, dynamic>> query =
        FirebaseFirestore.instance.collection("reviews");

    if (userId != null) {
      query = query.where("user_id", isEqualTo: userId);
    }

    if (storeId != null) {
      query = query.where("store_id", isEqualTo: storeId);
    }

    if (professorId != null) {
      query = query.where("professor_id", isEqualTo: professorId);
    }

    final QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();

    final List<Map<String, dynamic>> output = [];
    for (final doc in snapshot.docs) {
      final Map<String, dynamic> data = doc.data();
      output.add(data);
    }
    return output;
  }

  //// RESOURCE CRUDS ////
  Future<List<Map<String, dynamic>>> getAllResources() async {
    List<Map<String, dynamic>> output = [];
    return await resourcesCollection.get().then(
      (querySnap) {
        debugPrint('Success');
        for (var docSnap in querySnap.docs) {
          Map<String, dynamic> temp = docSnap.data() as Map<String, dynamic>;
          temp['id'] = docSnap.id;
          output.add(temp);
        }
        debugPrint('$output');
        return output;
      },
      onError: (e) {
        debugPrint("Error getting document: $e");
        return [];
      },
    );
  }

  // add resource
  Future<void> addResource(
      String id, String link, String name, String phone, String room) async {
    await resourcesCollection.doc().set(
        {'id': id, 'link': link, 'name': name, 'phone': phone, 'room': room});
  }

  // get resource by resource ID
  Future<Map<String, dynamic>> getResourceById(String id) async {
    return await resourcesCollection.doc(id).get().then((DocumentSnapshot doc) {
      return doc.data() as Map<String, dynamic>;
    }, onError: (e) => debugPrint('Error getting document $e'));
  }

  // update a resouce
  Future<void> updateResource(String resourceId, String link, String name,
      String phone, String room) async {
    final resourcesCollection =
        FirebaseFirestore.instance.collection('resources');
    final resourceDoc = await resourcesCollection
        .doc(resourceId)
        .get(); // Get the resource document
    final resourceData = resourceDoc.data();
    if (resourceData?['resource_id'] == resourceId) {
      // Update the resource with the new data
      await resourcesCollection.doc(resourceId).update({
        'id': resourceId,
        'link': link,
        'name': name,
        'phone': phone,
        'room': room
      });
    } else {
      // Throw an error if the resource is not written by the user or not for the specified resource
      throw Exception('resource does not exist or cannot be updated');
    }
  }

  Future<void> deleteResource(String id) async {
    await resourcesCollection.doc(id).delete();
  }
}
