import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../model/item_model.dart';
import '../service/item_service.dart';

class HomePageController extends GetxController {
  ItemServices itemServices = ItemServices();
  List<ShopItemModel> items = [];
  List<ShopItemModel> cartItems = [];
  bool isLoading = true;

  @override
  void onInit() {
    super.onInit();
    loadDB();
  }

  loadDB() async {
    await itemServices.openDB();
    loadItems();
    getCardList();
  }

  getItem(int id) {
    return items.singleWhere((element) => element.id == id);
  }

  bool isAlreadyInCart(id) {
    return cartItems.indexWhere((element) => element.shopId == id) > -1;
  }

  getCardList() async {
    try {
      List list = await itemServices.getCartList();
      cartItems.clear();
      for (var element in list) {
        cartItems.add(ShopItemModel.fromJson(element));
      }
      update();
    } catch (e) {
      debugPrint("$e");
    }
  }

  loadItems() async {
    try {
      isLoading = true;
      update();

      List list = await itemServices.loadItems();
      for (var element in list) {
        items.add(ShopItemModel.fromJson(element));
      }

      isLoading = false;
      update();
    } catch (e) {
      debugPrint("$e");
    }
  }

  setToFav(int id, bool flag) async {
    int index = items.indexWhere((element) => element.id == id);

    items[index].fav = flag;
    update();
    try {
      await itemServices.setItemAsFavourite(id, flag);
    } catch (e) {
      debugPrint("$e");
    }
  }

  Future addToCart(ShopItemModel item) async {
    isLoading = true;
    update();
    var result = await itemServices.addToCart(item);
    isLoading = false;
    update();
    return result;
  }

  removeFromCart(int shopId) async {
    itemServices.removeFromCart(shopId);
    int index = cartItems.indexWhere((element) => element.shopId == shopId);
    cartItems.removeAt(index);
    update();
  }
}
