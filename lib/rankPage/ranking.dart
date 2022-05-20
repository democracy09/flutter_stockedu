import 'package:capstone1/providers/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

final auth = FirebaseAuth.instance;

class Ranking extends StatefulWidget {
  const Ranking({Key? key}) : super(key: key);

  @override
  State<Ranking> createState() => _RankingState();
}

class _RankingState extends State<Ranking> {
  final GlobalKey _myRankKey = GlobalKey();

  _getSize() {
    if (_myRankKey.currentContext != null) {
      final RenderBox renderBox =
          _myRankKey.currentContext!.findRenderObject() as RenderBox;
      Size size = renderBox.size;
      return size.height;
    }
  }

  double? rankHeight = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        rankHeight = _getSize();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
          Container(
            height: rankHeight,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Text(
                'tips',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    letterSpacing: -1.5),
              ),
            ),
          ),
          TopCarousel(),
          TopRank(),
        ],
      ),
      Positioned(
        top: 10,
        left: 0,
        right: 0,
        child: MyRank(key: _myRankKey),
      )
    ]);
  }
}

class MyRank extends StatefulWidget {
  const MyRank({Key? key}) : super(key: key);

  @override
  State<MyRank> createState() => _MyRankState();
}

class _MyRankState extends State<MyRank> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(4, 8),
          )
        ],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '내 순위',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 25, letterSpacing: -1.2),
          ),
          Divider(
            thickness: 1.0,
            color: Colors.grey.withOpacity(0.5),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 5),
                    child: Text(
                      '{num}. ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                          letterSpacing: -1.2),
                    ),
                  ),
                  Expanded(
                      child: Text(
                    '${auth.currentUser!.displayName ?? 'null'}',
                    style: TextStyle(fontSize: 18, letterSpacing: -1.2),
                  )),
                  Text('${context.watch<StoreUser>().profit} %',
                      style: TextStyle(fontSize: 22, letterSpacing: -1.2))
                ]),
          ),
        ],
      ),
    );
  }
}

class TopRank extends StatelessWidget {
  const TopRank({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'top 10',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 30, letterSpacing: -1.2),
          ),
          Divider(
            thickness: 1.0,
            color: Colors.grey.withOpacity(0.5),
          ),
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (c, i) {
                return Column(
                  children: [Rank(count: i), Divider()],
                );
              })
        ],
      ),
    );
  }
}

class Rank extends StatelessWidget {
  const Rank({Key? key, this.count}) : super(key: key);
  final count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
          margin: EdgeInsets.only(right: 5),
          child: Text(
            '${count + 1}. ',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 23, letterSpacing: -1.2),
          ),
        ),
        Expanded(
            child: Text(
          '{name}',
          style: TextStyle(fontSize: 18, letterSpacing: -1.2),
        )),
        Text('{rate}%', style: TextStyle(fontSize: 22, letterSpacing: -1.2))
      ]),
    );
  }
}

class TopCarousel extends StatelessWidget {
  const TopCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> imgList = [
      'https://images.unsplash.com/photo-1554415707-6e8cfc93fe23?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80',
      'https://images.unsplash.com/photo-1590283603385-17ffb3a7f29f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80',
      'https://images.unsplash.com/photo-1642543348745-03b1219733d9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80'
    ];
    final List<String> stringList = [
      '실패없이 투자하는 법',
      '당신이 손해보는 열 가지 이유',
      'PER? EPS? 알아야 할 주식 용어'
    ];

    final List<Widget> imageSliders = imgList
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.network(item, fit: BoxFit.cover, width: 1000.0),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: const [
                                    Color.fromARGB(200, 0, 0, 0),
                                    Color.fromARGB(0, 0, 0, 0)
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              child: Text(
                                stringList[imgList.indexOf(item)],
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                    letterSpacing: -1.1),
                              )),
                        ),
                      ],
                    )),
              ),
            ))
        .toList();
    return Container(
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          enlargeCenterPage: true,
          aspectRatio: 2.0,
        ),
        items: imageSliders,
      ),
    );
  }
}
