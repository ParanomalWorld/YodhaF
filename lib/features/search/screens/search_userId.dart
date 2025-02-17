// ignore: file_names
import 'package:flutter/material.dart';
import 'package:yodha_a/common/widgets/loader.dart';
import 'package:yodha_a/features/search/services/search_services.dart';
import 'package:yodha_a/features/search/widget/search_emailI.dart';
import 'package:yodha_a/models/users.dart';

class SearchUserid extends StatefulWidget {
  static const String routeName = '/search-userId';
  final String searchQuery;

  const SearchUserid({
    super.key,
    required this.searchQuery,
  });

  @override
  State<SearchUserid> createState() => _SearchUseridState();
}

class _SearchUseridState extends State<SearchUserid> {
  List<User>? userList; // Stores the list of users returned from the API
  final SearchServices searchServices = SearchServices();

  @override
  void initState() {
    super.initState();
    fetchSearchResults();
  }

  fetchSearchResults() async {
    userList = await searchServices.fetchUserId(
      context: context,
      searchQuery: widget.searchQuery,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return userList == null
        ? const Loader()
        : Scaffold(
            appBar: AppBar(
              title: const Text("Search Results"),
            ),
            body: userList!.isEmpty
                ? const Center(
                    child: Text(
                      'No results found!',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: userList!.length,
                    itemBuilder: (context, index) {
                      return SearchEmaili(emailId: userList![index]);
                    },
                  ),
          );
  }
}
