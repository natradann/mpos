class SaleModel {
  late double valPrice;
  late int allAmount;
  late double totalDiscount;
  late String discountUnit;
  late DateTime timeStamp;
  late List<ProductModel> productList;

  SaleModel({
    required this.valPrice,
    required this.allAmount,
    required this.totalDiscount,
    required this.discountUnit,
    required this.timeStamp,
    required this.productList,
  });
}

class ProductModel {
  //late String sku;
  late String barcode;
  late String title;
  late double price;
  late int amount;
  late int remainStock;
  late PromotionModel promotion;

  ProductModel({
    //sku,
    required this.barcode,
    required this.title,
    required this.price,
    required this.amount,
    required this.remainStock,
    required this.promotion,
  });
}

class PromotionModel {
  late String promotionId;
  late String title;
  late String decription;
  late List<String> listRelatedId;
  late DateTime validDate;
  late DateTime invalidDate;

  PromotionModel(
      {required this.promotionId,
      required this.title,
      required this.decription,
      required this.listRelatedId,
      required this.validDate,
      required this.invalidDate});
}
