import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yodha_a/constants/global_variables.dart';
import 'package:yodha_a/models/ruleset.dart';

class RulesetService {

  Future<Ruleset> createRuleset(String category, String content) async {
    final url = Uri.parse('$uri/rulesets/create');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'category': category,
        'content': content,
        'version': 1,
      }),
    );

    if (response.statusCode == 201) {
      return Ruleset.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create ruleset');
    }
  }
  Future<Ruleset> getRulesetByCategory(String category) async {
  final url = Uri.parse('$uri/rulesets/category/$category');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    return Ruleset.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to fetch ruleset for category: $category');
  }
}

 Future<Ruleset> updateRuleset(Ruleset ruleset) async {
    final url = Uri.parse('$uri/rulesets/${ruleset.id}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'category': ruleset.category,
        'content': ruleset.content,
        'version': ruleset.version, // Include version in update
      }),
    );



  if (response.statusCode == 200) {
    return Ruleset.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to update ruleset');
  }
}


  Future<List<Ruleset>> getAllRulesets() async {
    final url = Uri.parse('$uri/rulesets');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List decoded = jsonDecode(response.body);
      return decoded.map((r) => Ruleset.fromJson(r)).toList();
    } else {
      throw Exception('Failed to fetch rulesets');
    }
  }


  Future<Ruleset> getRulesetById(String rulesetId) async {
    final url = Uri.parse('$uri/rulesets/$rulesetId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Ruleset.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch ruleset');
    }
  }


//  Future<void> deleteRuleset(String rulesetId) async {
//   final url = Uri.parse('$uri/rulesets/$rulesetId');
//   final response = await http.delete(url);
//   if (response.statusCode != 200 && response.statusCode != 204) {
//     throw Exception('Failed to delete ruleset');
//   }
// }

}
