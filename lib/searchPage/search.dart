import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../Models/stock.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final FocusNode _focusNode = FocusNode();
  final GlobalKey _searchKey = GlobalKey();
  String addString(list){
    String result = '';
    for (var element in list) {
      result+=element+'/';
    }
    return result.substring(0, result.length-1);
  }
  _getSize(){
    if(_searchKey.currentContext != null){
      final RenderBox renderBox = _searchKey.currentContext!.findRenderObject() as RenderBox;
      Size size = renderBox.size;
      return size.height;
    }
  }
  double? searchHeight = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      setState(() {
        searchHeight = _getSize();
      });
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _focusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    context.read<StorePrice>().getStockRanking();
    if (context
        .watch<StorePrice>()
        .stockList
        .length != 10) {
      return Center(child: CircularProgressIndicator(),);
    } else {
      return GestureDetector(
        onTap: (){
          if(!currentFocus.hasPrimaryFocus){
            currentFocus.unfocus();
          }
        },
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: searchHeight ?? 40),
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      physics: AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 15, 8, 0),
                          child: Text("일일 거래량 top 10", style: TextStyle(
                              fontSize: 25,
                              letterSpacing: -1.0,
                              fontWeight: FontWeight.bold
                          )),
                        ),
                        Divider(thickness: 0.9, color: Colors.grey.withOpacity(0.8),),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: 10,
                            itemBuilder: (c, i) {
                              return StockRank(count: i);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                children: [
                  TextField(
                    focusNode: _focusNode,
                    onChanged: (text){
                      context.read<StorePrice>().getInfoByName(text);
                    },
                    key: _searchKey,
                    textInputAction: TextInputAction.search,
                    cursorColor: Colors.white,
                    style: TextStyle(
                        color: Colors.white, fontSize: 17, height: 1.3),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                        prefixIcon: Icon(FontAwesomeIcons.magnifyingGlass, size: 20,
                          color: Colors.white,),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none
                        ),
                        fillColor: Color(0xffCECECE),
                        filled: true,
                        hintText: '종목 검색...',
                        hintStyle: TextStyle(
                          color: Colors.white, letterSpacing: 1.3,)
                    ),
                  ),
                  context.watch<StorePrice>().searchList.isNotEmpty ? Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 1,
                          offset: const Offset(2,4)
                        )
                      ],
                    ),
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: context.watch<StorePrice>().searchList.length,
                      itemBuilder: (c, i){
                        // String name = context.watch<StorePrice>().searchList[i]['name'];
                        return GestureDetector(
                          onTap: (){
                            if(!currentFocus.hasPrimaryFocus){
                              currentFocus.unfocus();
                            }
                            GoRouter.of(context).push("/mainTab/1/stockDetail/${context.read<StorePrice>().searchList[i]['ticker']}");
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 13, bottom: 3, top: 3),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                i == 0 ? Container() : Divider(height: 1, thickness: 0.6,),
                                Container(
                                  padding: EdgeInsets.only(bottom: 4),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${context.watch<StorePrice>().searchList[i]['name']}', style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: -1.2,
                                          fontSize: 17
                                      ),),
                                      Text(addString(context.watch<StorePrice>().searchList[i]['index']), style: TextStyle(
                                          letterSpacing: -1.2,
                                          color: Colors.grey
                                      ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ) : Container()
                ],
              ),
            ),

          ]
        ),
      );
    }
  }
}

class StockRank extends StatelessWidget {
  const StockRank({Key? key, this.count}) : super(key: key);
  final count;
  final TextStyle textStyle = const TextStyle(
      fontSize: 20,
      letterSpacing: -1.2
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        children: [
          TextButton(
            style: TextButton.styleFrom(
                primary: Colors.black
            ),
            onPressed: (){
              GoRouter.of(context).go('/mainTab/1/stockDetail/${context.read<StorePrice>().stockList[count]['ticker']}');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${count+1}. ', style: textStyle,),
                Text('${context.watch<StorePrice>().stockList[count]['name']}', style: textStyle,)
              ],
            ),
          ),
          Divider(thickness: 0.5, color: Colors.grey.withOpacity(0.5),)
        ],
      ),
    );
  }
}


