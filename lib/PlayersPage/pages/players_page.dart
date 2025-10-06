import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:iism/PlayersPage/widgets/PlayerCard.dart';
import 'package:iism/api.dart';
import 'package:iism/utils.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import '../../SchedulePage/pages/schedule_page.dart';
import '../../SchedulePage/widgets/widgets.dart';
import '../../widgets/widgets.dart';
import '../models/PlayerModel.dart';

class PlayersPage extends StatefulWidget {
  const PlayersPage({super.key});

  @override
  _PlayersPageState createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  bool hasMore = true;
  bool isLoading = false;
  String chipValue = "All";
  final List<dynamic> players = [];
  bool isSearching = false;


  int page = 1;
  final int limit = 10; // Default limit
  String chipSportValue = "Cricket";

  @override
  void initState() {
    super.initState();
    _fetchPlayers();
  }

  Future<void> onChipTap(String sport) async {
    setState(() {
      chipValue = sport;
      players.clear();
      page = 1;
      hasMore = true;
    });
    await _fetchPlayers();
  }

  Future<void> searchFun(String value) async {
    setState(() {
      searchQuery = value;
      players.clear();
      page = 1;
      hasMore = true;
    });
    await _fetchPlayers();
  }

  Future<void> _fetchPlayers() async {
    if (isLoading|| !hasMore) return;
    setState(() {
      isLoading = true;
    });
    String sport = (chipValue=="All")? "":chipValue.toLowerCase();
    String isStaffUrl = isStaff? "playersStaff": "players";
    final String apiUrl = '$apiBaseUrl/$isStaffUrl?page=$page&limit=$limit&search=$searchQuery&sport=$sport';

    // final String apiUrl = '$apiBaseUrl/${apiUrls[currentIndex]}?page=${pages[currentIndex]}&limit=$_limit&sortBy=time&order=ASC&search=$_searchQuery&sportTableName=$sportTableName';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          players.addAll(data['players']);
          page++;
          if (data['players'].length < limit) {
            hasMore = false;
          }
        });
      } else {
        print('Failed to load matches');
      }
    } catch (e) {
      print('Error fetching matches: $e');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: dark? Colors.black : Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            backgroundColor: dark ? Colors.black : Colors.white,
            flexibleSpace: SizedBox(
              height: 80,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  AnimatedPositioned(
                    right: isSearching ? 0 : -size.width,
                    top: 0,
                    bottom: 0,
                    left: isSearching ? -size.width : 0,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: SizedBox(
                            width: size.width-32,
                            child: Row(
                              children: [
                                pageTitleText('Players'),
                                SizedBox(width: size.width-228.5,),
                                OctagonalIconButton(
                                  onTap: () {
                                    setState(() {
                                      HapticFeedback.lightImpact();
                                      isSearching = !isSearching;
                                      searchController.clear();
                                    });
                                  },
                                  icon: Icons.search,
                                  iconColor: blueColor,
                                  bgColor: blueColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: SizedBox(
                            width: size.width-32,
                            child: Row(
                              children: [
                                Expanded(child: search()),
                                const SizedBox(width: 15,),
                                OctagonalIconButton(
                                  onTap: () async {
                                    if(searchController.text.isNotEmpty) await searchFun('');
                                    setState(() {
                                      HapticFeedback.lightImpact();
                                      isSearching = !isSearching;
                                      searchController.clear();
                                    });
                                  },
                                  icon: Icons.close_rounded,
                                  iconColor: Colors.red,
                                  bgColor: Colors.red.shade500,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ),
                ],
              ),
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              players.clear();
              page = 1;
              hasMore = true;
            });
            await _fetchPlayers();
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 10, top: 10, right: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      sportChip('All', Icons.spoke),
                      sportChip('BasketBall', Icons.sports_basketball),
                      if(isStaff) sportChip('Football', Icons.sports_soccer),
                      sportChip('VolleyBall', Icons.sports_volleyball),
                      sportChip('Table Tennis', Icons.sports_tennis),
                      sportChip('Lawn Tennis', Icons.sports_tennis),
                      sportChip('Cricket', Icons.sports_cricket),
                      if(isStaff) sportChip('Badminton', MingCute.badminton_fill),
                      if(isStaff) sportChip('Squash', Icons.sports_tennis),
                      if(isStaff) sportChip('Athletics', Icons.directions_walk),
                      if(isStaff) sportChip('Chess', MingCute.chess_fill),
                      if(!isStaff) sportChip('Hockey', Icons.sports_hockey),
                    ],
                  ),
                ),
              ),
              (players.isEmpty)
                  ? Center(child: Column(
                    children: [
                      Lottie.asset('assets/lottie/loading/3.json', width: 300),
                      customText("Players are warming up...",14, FontWeight.w800, Colors.grey, 1)
                    ],
                  ),)
                  : Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && !isLoading) {
                      _fetchPlayers();
                      // return true;
                    }
                    return false;
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: players.length + (hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= players.length) {
                        return Container();
                      }
                      var player = players[index];
                      if(index==players.length-1) {
                        return Column(
                          children: [
                            PlayerCard(playerModel: PlayerModel.fromJson(player)),
                            const SizedBox(height: 70.0),
                          ],
                        );
                      }
                      PlayerModel playerModel = PlayerModel.fromJson(player);
                      return PlayerCard(playerModel: playerModel);
                    },
                  ),
                ),
              ),
            ],
          ),
        )
        ,
      ),
    );
  }

  Widget search() {
    return ClipPath(
      clipper: OctagonClipper(padding: 10),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          border: Border.all(color: blueColor),
          color: blueColor,
        ),
        child: ClipPath(
          clipper: OctagonClipper(padding: 10),
          child: Container(
            width: 100,
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onSubmitted: (val) async {
                      await searchFun(searchController.text);
                    },
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: "Search...",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(6.0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: OctagonalIconButton(
                      onTap: () async {await searchFun(searchController.text);},
                      icon: Icons.check_rounded,
                      iconColor: yellowColor,
                      bgColor: yellowColor
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget sportChip(String sport, IconData icon){
    return Padding(
      padding: const EdgeInsets.only(right:8),
      child: customChip2(sport, icon, chipValue == sport, () async {
        await onChipTap(sport);
      }),
    );
  }
}
