import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/user_controller.dart';
import '../models/user_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {

  @override
  void initState() {
    ref.read(userController).getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var users = ref.watch(userController);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
        actions: [
          IconButton(
            onPressed: () async => await showDialog(context: context, builder: (context) => AlertDialog(
              title: Text("Logout"),
              content: Text("Are you sure you want to logout?"),
              actions: [
                TextButton(
                  child: Text("Yes"),
                  onPressed: () async => await ref.read(userController).logout(context),
                )
              ],
            ),),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: users.isLoading
          ? const Center(child: CircularProgressIndicator(),)
          : ListView.separated(
        padding: EdgeInsets.all(10),
        itemBuilder: (context, index) {
          UserModel user = users.users[index];
          return Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent.shade200,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.deepPurple,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(user.avatar ?? ""),
                  radius: 25,
                ),
                SizedBox(width: 5,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${user.firstName} ${user.lastName}",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      user.email ?? '', style: TextStyle(color: Colors.white),
                    ),
                  ],
                )
              ],
            ),
          );;
        },
        separatorBuilder: (context, index) => SizedBox(height: 10,),
        itemCount: users.users.length,
      ),
    );
  }
}

final userController = ChangeNotifierProvider((ref) => UserController());