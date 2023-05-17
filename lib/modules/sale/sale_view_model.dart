import 'package:flutter/material.dart';
import 'package:pos_van/modules/sale/sale_model.dart';

class SaleViewModel {
  //required
  SaleModel saleOrder = SaleModel(
      valPrice: 0,
      allAmount: 0,
      timeStamp: DateTime.now(),
      totalDiscount: 0,
      discountUnit: '',
      productList: [
        ProductModel(
            barcode: '8851993613102',
            title: 'ช้างเล็ก ยกลัง',
            price: 792.00,
            amount: 2,
            remainStock: 10,
            promotion: PromotionModel(
                promotionId: '1',
                title: 'ช้างเล็ก ยกลัง',
                decription: 'Lorem',
                listRelatedId: ['123', '234'],
                validDate: DateTime.now(),
                invalidDate: DateTime.now())),
        ProductModel(
            barcode: '8851993613102',
            title: 'ช้างเล็ก ยกขวด',
            price: 792.00,
            amount: 1,
            remainStock: 10,
            promotion: PromotionModel(
                promotionId: '1',
                title: 'ช้างเล็ก ยกลัง',
                decription: 'Lorem',
                listRelatedId: ['123', '234'],
                validDate: DateTime.now(),
                invalidDate: DateTime.now())),
        ProductModel(
            barcode: '8851993613102',
            title: 'ช้างเล็ก ยกแพ็ค',
            price: 792.00,
            amount: 1,
            remainStock: 10,
            promotion: PromotionModel(
                promotionId: '1',
                title: 'ช้างเล็ก ยกลัง',
                decription: 'Lorem',
                listRelatedId: ['123', '234'],
                validDate: DateTime.now(),
                invalidDate: DateTime.now())),
        ProductModel(
            barcode: '8851993613102',
            title: 'ช้างเล็ก ยกแพ็ค',
            price: 792.00,
            amount: 1,
            remainStock: 10,
            promotion: PromotionModel(
                promotionId: '1',
                title: 'ช้างเล็ก ยกลัง',
                decription: 'Lorem',
                listRelatedId: ['123', '234'],
                validDate: DateTime.now(),
                invalidDate: DateTime.now())),
      ]);

  List<ProductModel> allProduct = [
    ProductModel(
        barcode: '8751993613102',
        title: 'ช้างเล็ก ยกลัง',
        price: 792.00,
        amount: 1,
        remainStock: 10,
        promotion: PromotionModel(
            promotionId: '1',
            title: 'ช้างเล็ก ยกลัง',
            decription: 'Lorem',
            listRelatedId: ['123', '234'],
            validDate: DateTime.now(),
            invalidDate: DateTime.now())),
    ProductModel(
        barcode: '8851993613102',
        title: 'ช้างเล็ก ยกแพ็ค',
        price: 792.00,
        amount: 1,
        remainStock: 10,
        promotion: PromotionModel(
            promotionId: '1',
            title: 'ช้างเล็ก ยกลัง',
            decription: 'Lorem',
            listRelatedId: ['123', '234'],
            validDate: DateTime.now(),
            invalidDate: DateTime.now())),
    ProductModel(
        barcode: '8951993613102',
        title: 'ช้างเล็ก ยกขวด',
        price: 792.00,
        amount: 1,
        remainStock: 10,
        promotion: PromotionModel(
            promotionId: '1',
            title: 'ช้างเล็ก ยกลัง',
            decription: 'Lorem',
            listRelatedId: ['123', '234'],
            validDate: DateTime.now(),
            invalidDate: DateTime.now())),
  ];

  List<ProductModel> filteredProduct = [];

  Future<bool> onUserTappedIncreasedAmount(
      {required ProductModel product}) async {
    if (product.amount < product.remainStock) {
      product.amount++;
      //product.remainStock--;
      return true;
    }
    return false;
  }

  Future<bool> onUserTappedDecreasedAmount(
      {required ProductModel product}) async {
    if (product.amount > 0) {
      product.amount--;
      //product.remainStock++;
      return true;
    }
    return false;
  }

  Future<bool> setAmount(
      {required ProductModel product, required String controller}) async {
    if (int.parse(controller) < 0) {
      product.amount = 1;
      return false;
    } else if (int.parse(controller) > 0 &&
        int.parse(controller) < product.remainStock) {
      product.amount = int.parse(controller);
      return true;
    } else if (int.parse(controller) > product.remainStock) {
      product.amount = product.remainStock;
      return false;
    }
    return false;
  }

  Future<void> onUserTappedDeletedProduct(
      {required ProductModel product}) async {
    saleOrder.productList.remove(product);
  }

  Future<void> onUserTappedClearProduct() async {
    saleOrder.productList.clear();
  }

  Future<bool> setTotalDiscount({required String discount}) async {
    if (saleOrder.discountUnit == 'บาท' && double.parse(discount) > 0) {
      saleOrder.totalDiscount = double.parse(discount);
      return true;
    }
    if (saleOrder.discountUnit == '%' &&
        double.parse(discount) > 0 &&
        double.parse(discount) <= 100) {
      saleOrder.totalDiscount = double.parse(discount);
      return true;
    }
    return false;
  }

  Future<void> setDiscountUnit({required String unit}) async {
    saleOrder.discountUnit = unit;
  }

  Future<void> filteredForSearch({required String? searchText}) async {
    if (searchText == null) {
      filteredProduct = allProduct;
    } else {
      filteredProduct = allProduct
        .where((product) =>
            product.title.toLowerCase().contains(searchText.toLowerCase()) ||
            product.barcode.toLowerCase().contains(searchText))
        .toList();
    }
  }
}
