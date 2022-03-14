import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:health/utils/constants/colors.dart';
import 'package:health/utils/constants/helpers.dart';
import 'package:health/view/widget/custom_history_Tile.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider_architecture/_viewmodel_provider.dart';
import 'booking_history_vm.dart';

class BookingHistory extends StatefulWidget {
  final bool isCritical;
  final String title;
  BookingHistory({this.isCritical, this.title});
  @override
  _BookingHistoryState createState() => _BookingHistoryState();
}

class _BookingHistoryState extends State<BookingHistory>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  int _mainPageIndex = 0;
  int get mainPageIndex => _mainPageIndex;
  int selectedIndex = 0;
  setMainPageIndex(int value) {
    setState(() {
      _mainPageIndex = value;
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setMainPageIndex(tabController.index);
      selectedIndex = tabController.index;
    });
  }

  List<NavItem> items = [
    NavItem(title: 'Approved', color: AppColors.primaryColor),
    NavItem(title: 'Not Approved', color: AppColors.primaryColor)
  ];
  Widget _buildItem(NavItem option, bool isSelected) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: 30,
        width: 100,
        alignment: Alignment.center,
        decoration: isSelected
            ? BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black12)])
            : null,
        child: Text(
          option.title,
          style: TextStyle(
              fontSize: 12, color: isSelected ? option.color : AppColors.grey),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<BookingHistoryVm>.withConsumer(
        viewModelBuilder: () => BookingHistoryVm(),
        builder: (context, model, child) {
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: AppColors.primaryColor,
                automaticallyImplyLeading: false,
                leading: IconButton(
                  onPressed: () {
                    model.pop();
                  },
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                ),
                title: Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                centerTitle: true,
                bottom: TabBar(
                    // isScrollable: true,
                    //  indicatorColor: AppColors.white,
                    indicatorWeight: 0.1,
                    controller: tabController,
                    onTap: (value) {
                      setState(() {
                        setMainPageIndex(tabController.index);
                        selectedIndex = tabController.index;
                      });
                    },
                    tabs: [
                      new Tab(
                        child: _buildItem(items.elementAt(0),
                            selectedIndex == items.indexOf(items.elementAt(0))),
                      ),
                      new Tab(
                        child: _buildItem(items.elementAt(1),
                            selectedIndex == items.indexOf(items.elementAt(1))),
                      )
                    ]),
              ),
              body: Container(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: tabController,
                  children: [
                    StreamBuilder<dynamic>(
                        stream: widget.isCritical
                            ? model.getSuccessC()
                            : model.getSuccessNC(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data.docs.isEmpty) {
                            print('it has error');
                            return Center(
                              child: Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'You have no Appointmnet records',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  )),
                            );
                          } else if (snapshot.hasData &&
                              snapshot.data.docs.isNotEmpty) {
                            print('it has data');

                            return ListView.builder(
                              itemCount: snapshot.data.docs.length,
                              padding: EdgeInsets.only(top: 8),
                              itemBuilder: (context, i) {
                                var data = snapshot.data.docs[i].data();
                                var id = snapshot.data.docs[i].id;
                                print(data["dateTime"].toString());
                                return new CustomHistoryTile(
                                  arrivalStatus: data["arrivalStatus"],
                                  importance: data["priority"],
                                  purpose: data["purpose"],
                                  isApproved: true,
                                  docId: id,
                                  scheduledTime: formatTimeOnly(
                                          data["dateTime"].toString())
                                      .toString(),
                                  snapshot: data,
                                  isCritical: widget.isCritical,
                                );
                              },
                            );
                          }
                             else if (snapshot.hasError) {
                            print('it has error');
                            return Center(
                              child: Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 200,
                                        child: Text(
                                          'Error fetching Data',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  )),
                            );
                          }
                          
                           else
                            return Align(
                                alignment: Alignment.center,
                                child: SpinKitFadingCircle(
                                  color: AppColors.loadingColor200,
                                  size: 50,
                                  duration: Duration(seconds: 2),
                                ));
                        }),
                    StreamBuilder<dynamic>(
                        stream: widget.isCritical
                            ? model.getpendingC()
                            : model.getpendingNC(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data.docs.isEmpty) {
                            print('it has error');
                            return Center(
                              child: Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 200,
                                        child: Text(
                                          'You have no pending ${widget.title} appointments',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  )),
                            );
                          } else if (snapshot.hasData && snapshot.data.docs.isNotEmpty) {
                            print('it has data');
                            return ListView.builder(
                              itemCount: snapshot.data.docs.length,
                              padding: EdgeInsets.only(top: 8),
                              itemBuilder: (context, i) {
                                var data = snapshot.data.docs[i].data();
                                var id = snapshot.data.docs[i].id;
                                return new CustomHistoryTile(
                                  arrivalStatus: data["arrivalStatus"],
                                  importance: data["priority"],
                                  purpose: data["purpose"],
                                  isApproved: false,
                                  isCritical: widget.isCritical,
                                  docId: id,
                                  scheduledTime: 'pending',
                                  snapshot: data,
                                );
                              },
                            );
                          } 
                           else if (snapshot.hasError) {
                            print('it has error');
                            return Center(
                              child: Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 200,
                                        child: Text(
                                          'Error fetching Data',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  )),
                            );
                          }
                          
                          else
                            return Align(
                                alignment: Alignment.center,
                                child: SpinKitFadingCircle(
                                  color: AppColors.loadingColor200,
                                  size: 50,
                                  duration: Duration(seconds: 2),
                                ));
                        }),
                  ],
                ),
              ));
        });
  }
}

class NavItem {
  String title;
  Color color;
  NavItem({this.color, this.title});
}
