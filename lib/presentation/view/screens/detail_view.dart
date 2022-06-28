import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/home_controller/home_page_controller.dart';
import '../../model/item_model.dart';
import '../widgets/custom_button.dart';
import '../widgets/dot_widget.dart';

class ItemDetailPage extends StatefulWidget {
  final int itemId;

  const ItemDetailPage({Key? key, required this.itemId}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  late PageController pageController;
  int active = 0;
  String image =
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRc_R7jxbs8Mk2wjW9bG6H9JDbyEU_hRHmjhr3EYn-DYA99YU6zIw";

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
  }

  Widget buildDot(int index, int num) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        height: 10.0,
        width: 10.0,
        decoration: BoxDecoration(
            color: (num == index) ? Colors.black38 : Colors.grey[200],
            shape: BoxShape.circle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    HomePageController controller = Get.find<HomePageController>();
    ShopItemModel model = controller.getItem(widget.itemId);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade300,
              width: 1.0,
            ),
          ),
        ),
        child: ListView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 280.0,
                  padding: const EdgeInsets.only(top: 10.0),
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 200.0,
                        child: PageView(
                          controller: pageController,
                          onPageChanged: (index) {
                            debugPrint("$index");
                            setState(() {
                              active = index;
                            });
                          },
                          children: <Widget>[
                            Image.network(
                              model.image,
                              height: 150.0,
                            ),
                            Image.network(
                              model.image,
                              height: 150.0,
                            ),
                            Image.network(
                              model.image,
                              height: 150.0,
                            ),
                            Image.network(
                              model.image,
                              height: 150.0,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          DotWidget(
                            activeIndex: active,
                            dotIndex: 0,
                          ),
                          DotWidget(
                            activeIndex: active,
                            dotIndex: 1,
                          ),
                          DotWidget(
                            activeIndex: active,
                            dotIndex: 2,
                          ),
                          DotWidget(
                            activeIndex: active,
                            dotIndex: 3,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GetBuilder<HomePageController>(builder: (value) {
                  return Container(
                      height: 270.0,
                      alignment: const Alignment(1.0, 1.0),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Column(
                          verticalDirection: VerticalDirection.down,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                controller.setToFav(model.id, !model.fav);
                                var msg = "";
                                if (model.fav) {
                                  msg = "${model.name} marked as favourite";
                                } else {
                                  msg = "${model.name} removed from favourite";
                                }
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text(msg)));
                              },
                              child: model.fav
                                  ? const Icon(
                                      Icons.favorite,
                                      size: 20.0,
                                      color: Colors.red,
                                    )
                                  : const Icon(
                                      Icons.favorite_border,
                                      size: 20.0,
                                    ),
                            )
                          ],
                        ),
                      ));
                })
              ],
            ),
            Divider(
              color: Colors.grey[300],
              height: 1.0,
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    model.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 19.0),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                        "Flutter: Bubble tab indicator for TabBar. Using a Stack Widget and then adding elements to stack on different levels(stacking components like Tabs, above"),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
          margin: const EdgeInsets.only(bottom: 18.0),
          height: 60.0,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  top: BorderSide(color: Colors.grey.shade300, width: 1.0))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 60.0,
                    child: const Text(
                      "Total Amount",
                      style: TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                  ),
                  Text("\$${model.price.toString()}",
                      style: const TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.w600)),
                ],
              ),
              GetBuilder<HomePageController>(builder: (_) {
                bool isAdded = controller.isAlreadyInCart(model.id);
                if (isAdded) {
                  return CustomButton(
                    name: "REMOVE CART",
                    onTap: () async {
                      try {
                        controller.removeFromCart(model.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Item removed from cart successfully")));
                      } catch (e) {
                        debugPrint("$e");
                      }
                    },
                  );
                }
                return CustomButton(
                  name: "ADD TO CART",
                  onTap: controller.isLoading
                      ? null
                      : () async {
                          try {
                            controller.getCardList();
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Item added in cart successfully")));
                          } catch (e) {
                            debugPrint("$e");
                          }
                        },
                );
              })
            ],
          )),
    );
  }
}
