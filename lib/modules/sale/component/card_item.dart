import 'package:flutter/material.dart';
import 'package:pos_van/constants/decorations/box_decorations.dart';
import 'package:pos_van/constants/decorations/colors.dart';
import 'package:pos_van/constants/decorations/text_styles.dart';
import 'package:pos_van/components/circular_icon_button.dart';
import 'package:pos_van/components/bordered_text_field.dart';
import 'package:pos_van/modules/sale/component/button_in_sale.dart';
import 'package:pos_van/modules/sale/sale_model.dart';
import 'package:pos_van/modules/sale/sale_view_model.dart';
import 'package:intl/intl.dart';

class CardItem extends StatefulWidget {
  const CardItem({
    Key? key,
    required this.model,
    required this.amountController,
    required this.index,
    required this.viewmodel,
    required this.onUserTappedDelete,
    required this.onUserSetAmount,
    // required this.barcode,
    // required this.title,
    // required this.price,
    // required this.amount,
    // required this.remainStock,
    // this.promotionId,
  }) : super(key: key);

  final ProductModel model;
  final TextEditingController amountController;
  final int index;
  final SaleViewModel viewmodel;
  final Future<void> Function() onUserTappedDelete;
  final Future<void> Function() onUserSetAmount;
  // final String barcode;
  // final String title;
  // final double price;
  // final int amount;
  // final int remainStock;

  @override
  State<CardItem> createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  //TextEditingController amount = TextEditingController(text: widget.amount.toString());
  //final SaleViewModel _viewModel = SaleViewModel();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Container(
          decoration: kCardDecoration,
          padding: const EdgeInsets.all(8),
          child: Row(children: [_productDetail(), _productControl()]),
        ));
  }

  Expanded _productDetail() {
    return Expanded(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          Text(
            widget.model.title,
            style: kTitleTextStyle,
          ),
          _sectionBuffer(height: 4),
          Text(
            widget.model.barcode,
            style: kSecondaryContentTextStyle,
          ),
          _sectionBuffer(),
          Text(
            '${widget.model.price} บาท/ชิ้น',
            style: kHighLightBodyTextStyle,
          ),
          _sectionBuffer(),
          SizedBox(
            child: Row(
              children: [
                CircularIconButton(
                  icon: Icons.card_giftcard_outlined,
                  iconColor: kPrimaryLightColor,
                  onTapped: () async {
                    _promotionPopup();
                  },
                ),
                const SizedBox(width: 10),
                const Text(
                  'โปรโมชั่น',
                  style: kHighLightBodyTextStyle,
                )
              ],
            ),
          )
        ]));
  }

  Expanded _productControl() {
    return Expanded(
        child: Column(
      children: <Widget>[
        SizedBox(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            CircularIconButton(
              icon: Icons.remove,
              iconColor: Colors.white,
              onTapped: () async {
                bool isAmountDecreased = await widget.viewmodel
                    .onUserTappedDecreasedAmount(product: widget.model);
                if (isAmountDecreased) {
                  widget.amountController.text = widget.model.amount.toString();
                  setState(() {});
                  return;
                }
              },
              fillColor: kFadedTextColor,
              size: 40,
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Form(
                    key: _formKey,
                    child: BorderedTextField(
                      controller: widget.amountController,
                      type: TextInputType.number,
                      textalign: TextAlign.center,
                      validate: (value) {
                        if (int.parse(value!) > widget.model.remainStock) {
                          return 'สินค้าเกินจำนวนคงเหลือ';
                        }
                        return null;
                      },
                      onEditingEnd: widget.onUserSetAmount,
                    ),
                  )),
            ),
            CircularIconButton(
              icon: Icons.add,
              iconColor: Colors.white,
              onTapped: () async {
                bool isAmountIncreased = await widget.viewmodel
                    .onUserTappedIncreasedAmount(product: widget.model);
                if (isAmountIncreased) {
                  widget.amountController.text = widget.model.amount.toString();
                  setState(() {});
                  return;
                }
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(content: Text('Processing Data')),
                // );
              },
              fillColor: kPrimaryLightColor,
              size: 40,
            ),
          ]),
        ),
        _sectionBuffer(height: 4),
        Text('เหลือ: ${widget.model.remainStock - widget.model.amount}',
            style: kRedIndicatorTextStyle),
        SizedBox(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('รวม ${widget.model.price * widget.model.amount} บาท',
                style: const TextStyle(
                    color: kPrimaryDarkColor,
                    fontSize: 18.65,
                    fontWeight: FontWeight.bold)),
            GestureDetector(
                child: const Icon(
                  Icons.delete,
                  size: 30,
                  color: Colors.grey,
                ),
                onTap: () {
                  _confirmDeletePopup();
                })
          ],
        )),
      ],
    ));
  }

  Future<void> _promotionPopup(/*BuildContext context*/) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.model.promotion.title,
                style: kSubHeaderTextStyle,
              ),
              const SizedBox(height: 10),
              _promotionDetail(),
              const SizedBox(height: 10),
              _productRelated(),
              const SizedBox(height: 10),
              Text(
                '${DateFormat.yMd().format(widget.model.promotion.validDate)} - ${DateFormat.yMd().format(widget.model.promotion.invalidDate)}',
                style: const TextStyle(
                  color: kFadedTextColor,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Column _productRelated() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text(
        'สินค้าที่เข้าร่วมรายการ',
        style: TextStyle(
          fontSize: 15,
        ),
      ),
      _bulletList(),
      _bulletList(),
    ]);
  }

  Column _promotionDetail() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text(
        'รายละเอียดโปรโมชั่น',
        style: TextStyle(
          fontSize: 15,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        widget.model.promotion.decription,
        style: const TextStyle(
          color: kFadedTextColor,
        ),
      ),
    ]);
  }

  Future<void> _confirmDeletePopup() {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: const Color.fromRGBO(255, 85, 85, 1), width: 2)),
                child: const Icon(
                  Icons.delete_forever,
                  color: Color.fromRGBO(255, 85, 85, 1),
                  size: 50,
                ),
              ),
              _sectionBuffer(),
              const Text(
                'ยืนยันการลบสินค้า',
                style: TextStyle(
                    color: kPrimaryDarkColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              _sectionBuffer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ชื่อสินค้า: ${widget.model.title}'),
                  Text('ชื่อเล่น: ${widget.model.title}'),
                  Text('บาร์โค้ด: ${widget.model.barcode}'),
                  Text('จำนวน: ${widget.model.amount} ชิ้น'),
                  Text(
                      'ราคารวม: ${widget.model.price * widget.model.amount} บาท'),
                ],
              ),
              _sectionBuffer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonInSale(
                    text: 'ยกเลิก',
                    bgColor: const Color.fromRGBO(111, 128, 154, 1),
                    frColor: Colors.white,
                    bdColor: const Color.fromRGBO(111, 128, 154, 1),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 15),
                  ButtonInSale(
                    text: 'ยืนยัน',
                    bgColor: const Color.fromRGBO(190, 222, 252, 1),
                    frColor: kPrimaryDarkColor,
                    bdColor: const Color.fromRGBO(190, 222, 252, 1),
                    onPressed: widget.onUserTappedDelete,
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Row _bulletList() {
    return Row(
      children: const [
        SizedBox(width: 10),
        Text(
          '\u2022',
          style: TextStyle(
            fontSize: 16,
            height: 1.55,
            color: Colors.grey,
          ),
        ),
        SizedBox(width: 10),
        Text(
          'ช้างเล็ก ยกลัง',
          style: TextStyle(
            color: kFadedTextColor,
          ),
        ),
      ],
    );
  }

  SizedBox _sectionBuffer({double height = 8}) {
    return SizedBox(
      height: height,
    );
  }
}
