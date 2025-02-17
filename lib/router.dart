import 'package:flutter/material.dart';
import 'package:yodha_a/common/widgets/bottom_bar.dart';
import 'package:yodha_a/features/admin/home_page/screen/add_event_screen.dart';
import 'package:yodha_a/features/admin/home_page/screen/event_category_screen/screen/admin_category_game_box_screen.dart';
import 'package:yodha_a/features/admin/home_page/screen/event_category_screen/screen/update_event_screen.dart';
import 'package:yodha_a/features/admin/home_page/screen/user_search_screen/screen/admin_user_profile_screen.dart';
import 'package:yodha_a/features/home/screens/account_categories_screen/home_contactus_screen.dart';
import 'package:yodha_a/features/home/screens/account_categories_screen/home_profile_screen.dart';
import 'package:yodha_a/features/home/screens/category_game_box_screen.dart';
import 'package:yodha_a/features/home/screens/home_screen.dart';
import 'package:yodha_a/features/auth/screens/auth_screen.dart';
import 'package:yodha_a/features/my_entries/screens/entry_details_screen.dart';
import 'package:yodha_a/features/search/screens/search_userId.dart';
import 'package:yodha_a/features/slot_book/screen/enter_player_details.dart';
import 'package:yodha_a/features/slot_book/screen/slot_screen.dart';
import 'package:yodha_a/models/event.dart';
import 'package:yodha_a/models/users.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );

    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );

    case BottomBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BottomBar(),
      );

    case HomeProfileScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => HomeProfileScreen(),
      );

    // case HomeWallateScreen.routeName:
    //   return MaterialPageRoute(
    //     settings: routeSettings,
    //     builder: (_) => const HomeWallateScreen(),
    //   );

    case HomeContactusScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeContactusScreen(),
      );

    case AddEventScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddEventScreen(),
      );

// Route handling (ensure the case matches UpdateEventScreen.routeName)
    case UpdateEventScreen.routeName:
      final event = routeSettings.arguments as Event;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => UpdateEventScreen(event: event),
      );

    case AdminUserProfileScreen.routeName:
      final user = routeSettings.arguments as User;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AdminUserProfileScreen(user: user),
      );

    case CategoryGameBoxScreen.routeName:
      var category = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => CategoryGameBoxScreen(
          category: category,
        ),
      );

    case AdminCategoryGameBoxScreen.routeName:
      var category = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AdminCategoryGameBoxScreen(
          category: category,
        ),
      );

    case SearchUserid.routeName:
      var searchQuery = routeSettings.arguments as String;
      return MaterialPageRoute(
        builder: (_) => SearchUserid(
          searchQuery: searchQuery,
        ),
      );

  case EntryDetailsScreen.routeName:
  final event = routeSettings.arguments as Event;
  return MaterialPageRoute(
    settings: routeSettings,
    builder: (_) => EntryDetailsScreen(event: event),
  );

    case SlotScreen.routeName:
      var eventId = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SlotScreen(eventId: eventId),
      );

    case EnterPlayerDetails.routeName:
      final args = routeSettings.arguments as Map<String, dynamic>;
      final eventId = args['eventId'] as String;
      final slotId = args['slotId'];
      final isBooked = args['isBooked'] as bool;
      final selectedSlotNumber = args['selectedSlotNumber'] as int;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => EnterPlayerDetails(
          eventId: eventId,
          slotId: slotId,
          isBooked: isBooked,
          selectedSlotNumber: selectedSlotNumber,
        ),
      );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not Exit bro'),
          ),
        ),
      );
  }
}
