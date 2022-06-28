import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/home_controller/home_page_controller.dart';
import '../../model/item_model.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  Widget generateCart(BuildContext context, ShopItemModel d) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white12,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade100, width: 1.0),
              top: BorderSide(color: Colors.grey.shade100, width: 1.0),
            )),
        height: 100.0,
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              height: 100.0,
              width: 100.0,
              decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 5.0)
                  ],
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)),
                  image: DecorationImage(
                      image: NetworkImage(d.image), fit: BoxFit.fitHeight)),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          d.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15.0),
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        child: InkResponse(
                          onTap: () {
                            Get.find<HomePageController>()
                                .removeFromCart(d.shopId ?? 0);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Item removed from cart successfully")));
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text("Price ${d.price.toString()}"),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  getItemTotal(List<ShopItemModel> items) {
    double sum = 0.0;
    for (var e in items) {
      sum += e.price;
    }
    return "\$$sum";
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    HomePageController controller = Get.find<HomePageController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart list"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: GetBuilder<HomePageController>(
                builder: (_) {
                  if (controller.cartItems.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: size.height * 0.2,
                          // foregroundDecoration: const BoxDecoration(boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.white,
                          //     blurRadius: 10,
                          //   )
                          // ]),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Center(
                            child: ListTile(
                              leading: Container(
                                height: size.height * 0.02,
                                width: size.width * 0.02,
                                color: Colors.black,
                              ),
                              title: Text(
                                "${data.map((e) => Text("${e.entries.length}")).toList()}",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return ListView(
                    shrinkWrap: true,
                    children: controller.cartItems
                        .map((d) => generateCart(context, d))
                        .toList(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(child: GetBuilder<HomePageController>(
                builder: (_) {
                  return RichText(
                    text: TextSpan(
                        text: "Total  ",
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18),
                        children: <TextSpan>[
                          TextSpan(
                              text:
                                  getItemTotal(controller.cartItems).toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold))
                        ]),
                  );
                },
              )),
              Container(
                alignment: Alignment.centerLeft,
                height: 50,
                color: Colors.white,
                child: ElevatedButton(
                    onPressed: () {},
                    child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: 100,
                      child: const Text(
                        "Checkout",
                        style: TextStyle(fontSize: 18),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
