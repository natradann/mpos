import 'package:flutter/material.dart';
import 'package:pos_van/components/bordered_text_field.dart';
import 'package:pos_van/modules/sale/component/button_in_sale.dart';
import 'package:pos_van/constants/decorations/colors.dart';
import 'package:pos_van/constants/decorations/text_styles.dart';
import 'package:pos_van/modules/sale/component/card_item.dart';
import 'package:pos_van/modules/sale/component/search_result_overlay.dart';
import 'package:pos_van/modules/sale/sale_model.dart';
import 'package:pos_van/modules/sale/sale_view_model.dart';

final List<String> list = ['บาท', '%'];

class SaleView extends StatefulWidget {
  const SaleView({super.key});

  @override
  State<SaleView> createState() => _SaleViewState();
}

class _SaleViewState extends State<SaleView> {
  late SaleViewModel _viewModel;
  String dropdownValue = list.first;
  TextEditingController searchtext = TextEditingController();
  TextEditingController discount = TextEditingController();
  bool isDiscountVisible = false;
  final _formKey = GlobalKey<FormState>();
  OverlayEntry? entry;

  @override
  void initState() {
    super.initState();
    _viewModel = SaleViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: _body(),
      ),
    );
  }

  Column _body() {
    return Column(
      children: [
        _sectionBuffer(),
        const Center(
          child: Text(
            'รายการขายเงินสด',
            style: kHeaderTextStyle,
          ),
        ),
        _sectionBuffer(height: 16),
        _search(),
        _categoryButton(),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: _viewModel.saleOrder.productList.length,
            itemBuilder: (context, int index) {
              ProductModel product = _viewModel.saleOrder.productList[index];
              TextEditingController controller =
                  TextEditingController(text: product.amount.toString());
              return CardItem(
                model: product,
                index: index,
                amountController: controller,
                viewmodel: _viewModel,
                onUserTappedDelete: () async {
                  _viewModel.onUserTappedDeletedProduct(product: product);
                  setState(() {});
                  Navigator.pop(context);
                },
                onUserSetAmount: () async {
                  bool isSetAmount = await _viewModel.setAmount(
                      product: product, controller: controller.text);
                  if (isSetAmount) {
                    setState(() {});
                    return;
                  }
                  controller = TextEditingController(text: product.amount.toString());
                },
              );
            },
          ),
        ),
        _buttonBottom(),
      ],
    );
  }

  Padding _search() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(children: [
        Expanded(
            flex: 5,
            child: SearchResultOverlay(
              viewmodel: _viewModel,
              searchText: searchtext,
              onChange: (value) async {
                _viewModel.filteredForSearch(searchText: searchtext.text);
                setState(() {});
              },
            )),
        const SizedBox(width: 10),
        SizedBox(
          height: 50,
          child: ElevatedButton(
              onPressed: () async {},
              child: const Icon(
                Icons.camera_alt_outlined,
                size: 30,
              )),
        )
      ]),
    );
  }

  Padding _categoryButton() {
    return Padding(
      //mainAxisAlignment: MainAxisAlignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: () async {},
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(8),
          backgroundColor: kPrimaryLightColor,
          foregroundColor: Colors.white,
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Icon(
                Icons.category,
                size: 30,
              ),
              SizedBox(width: 10),
              Text(
                'สินค้าขายดีและหมวดหมู่',
                style: TextStyle(
                  fontSize: 19,
                ),
              )
            ]),
      ),
    );
  }

  Container _buttonBottom() {
    return Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            //mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(238, 245, 255, 1),
                    border: Border.all(
                      color: kPrimaryDarkColor,
                    ),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'เพิ่มส่วนลดท้ายบิล',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryDarkColor,
                      ),
                    ),
                    GestureDetector(
                      child: Row(
                        children: [
                          Visibility(
                            visible: isDiscountVisible,
                            child: Text(
                              "${_viewModel.saleOrder.totalDiscount} ${_viewModel.saleOrder.discountUnit}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: kPrimaryDarkColor,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: kPrimaryDarkColor,
                          )
                        ],
                      ),
                      onTap: () async {
                        await discountPopup(discountt: discount);
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
              _sectionBuffer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonInSale(
                    text: 'ยกเลิก',
                    bgColor: Colors.white,
                    frColor: Colors.red,
                    bdColor: Colors.red,
                    onPressed: () async {
                      _confirmDeleteAllPopup();
                    },
                  ),
                  const SizedBox(width: 15),
                  ButtonInSale(
                    text: 'ยืนยันรายการ',
                    bgColor: kPrimaryDarkColor,
                    frColor: Colors.white,
                    bdColor: kPrimaryDarkColor,
                    onPressed: () async {},
                  ),
                ],
              )
            ]));
  }

  Future<void> discountPopup({required TextEditingController discountt}) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                'ส่วนลดท้ายบิล',
                style: kHeaderTextStyle,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(children: [
                    SizedBox(
                      width: 150,
                      child: Form(
                        key: _formKey,
                        child: BorderedTextField(
                          controller: discount,
                          type: TextInputType.number,
                          validate: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onEditingEnd: () async {
                            // isDiscountVisible = await _viewModel.setTotalDiscount(
                            //     discount: discount.text);
                            setState(() {});
                            print('f=${discount.text}');
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: kPrimaryLightColor, width: 2),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          alignment: AlignmentDirectional.center,
                          value: dropdownValue,
                          items: list
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              dropdownValue = value.toString();
                              _viewModel.setDiscountUnit(unit: dropdownValue);
                              print(_viewModel.saleOrder.discountUnit);
                            });
                          },
                          dropdownColor: Colors.white,
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonInSale(
                      text: 'ยกเลิก',
                      bgColor: Colors.white,
                      frColor: Colors.red,
                      bdColor: Colors.red,
                      onPressed: () async {
                        //discount.clear();
                        //isDiscountVisible = false;
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 15),
                    ButtonInSale(
                      text: 'ยืนยัน',
                      bgColor: kPrimaryDarkColor,
                      frColor: Colors.white,
                      bdColor: kPrimaryDarkColor,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          isDiscountVisible = await _viewModel.setTotalDiscount(
                              discount: discount.text);
                          setState(() {});
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ],
                ),
              ],
            );
          });
        });
  }

  Future<void> _confirmDeleteAllPopup() {
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
                'ลบสินค้าทั้งหมด',
                style: TextStyle(
                    color: kPrimaryDarkColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              _sectionBuffer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'สินค้าทั้งหมดจำนวน ${_viewModel.saleOrder.allAmount} ชิ้น')
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
                      onPressed: () async {
                        _viewModel.onUserTappedClearProduct();
                        setState(() {});
                        Navigator.pop(context);
                      }),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  SizedBox _sectionBuffer({double height = 8}) {
    return SizedBox(
      height: height,
    );
  }
}
