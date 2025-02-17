import 'package:flutter/material.dart';
import 'package:yodha_a/common/widgets/loader.dart';
import 'package:yodha_a/features/account/widgets/single_product.dart';
import 'package:yodha_a/features/admin/home_page/screen/add_event_screen.dart';
import 'package:yodha_a/features/admin/services/admin_services.dart';
import 'package:yodha_a/models/event.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
 List<Event>? eventBox1;

  final AdminServices adminServices = AdminServices();


@override
void initState(){
  super.initState();
  fetchAllEventBox();
}

void fetchAllEventBox() async{
  eventBox1 = await  adminServices.fetchAllEventBox(context);
  setState(() {
  });
}

void deleteEvent(Event eventBox, int index) {
  adminServices.deleteEvent(
    context: context, 
    eventBox: eventBox, 
    onSuccess: (){
      eventBox1!.removeAt(index);
      setState(() { });

    },
    );
}



  void navigateToAddEvent(){
    Navigator.pushNamed(context, AddEventScreen.routeName);

  }




  @override
  Widget build(BuildContext context) {
    return eventBox1 == null 
    ? Loader()
    : Scaffold(
      body: GridView.builder(
        itemCount: eventBox1!.length ,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2), 
        itemBuilder: (context, index){
          final eventData = eventBox1![index];
          return Column(
            children: [
              SizedBox(
                height: 140,
                child: SingleProduct(
                  image: eventData.images[0],
                  borderColor: Colors.black,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: 
                  Text(
                    eventData.eventName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  )),
                  IconButton(
                    onPressed: () => deleteEvent(eventData, index), 
                    icon: const Icon(
                    Icons.delete_outline,)
                    ),
                ],
              )
            ],
          );

        }),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddEvent,
        tooltip: 'Add a Event',
        child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,


    );
  }
}