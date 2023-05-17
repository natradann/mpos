import 'package:flutter/material.dart';
import 'package:pos_van/constants/decorations/colors.dart';
import 'package:pos_van/modules/sale/sale_model.dart';
import 'package:pos_van/modules/sale/sale_view_model.dart';

class SearchResultOverlay extends StatefulWidget {
  const SearchResultOverlay({
    Key? key,
    required this.viewmodel,
    required this.onChange,
    required this.searchText,
  }) : super(key: key);

  final SaleViewModel viewmodel;
  final Function(String?) onChange;
  final TextEditingController searchText;
  @override
  State<SearchResultOverlay> createState() => _SearchResultOverlayState();
}

class _SearchResultOverlayState extends State<SearchResultOverlay> {
  final focusNode = FocusNode();
  final layerLink = LayerLink();

  OverlayEntry? entry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      hideOverlay();
    });

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        showOverlay();
      } else {
        hideOverlay();
      }
    });
  }

  void showOverlay() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    entry = OverlayEntry(
        builder: (context) => Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height),
              child: buildOverlay(),
            )));
    overlay.insert(entry!);
  }

  void hideOverlay() {
    entry?.remove();
    entry = null;
  }

  GestureDetector searchResultProduct({required ProductModel product}) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: kFadedTextColor),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(product.title),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product.barcode,
                  style: const TextStyle(color: kFadedTextColor),
                ),
                Text(
                  '${product.price} บาท',
                  style: const TextStyle(color: kFadedTextColor),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildOverlay() => Material(
          //elevation: 8,
          child: Container(
        padding: const EdgeInsets.all(8),
        color: kCardBackgroundColor,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: widget.viewmodel.filteredProduct.length,
          itemBuilder: (context, int index) {
            ProductModel product = widget.viewmodel.filteredProduct[index];
            return searchResultProduct(
              product: product,
            );
          },
        ),
      ));

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
        link: layerLink,
        child: TextFormField(
          onChanged: (value) {
            setState(() {
              widget.viewmodel.filteredForSearch(searchText: widget.searchText.text);
            });
          },
          focusNode: focusNode,
          controller: widget.searchText,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                width: 2,
                color: kPrimaryLightColor,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                width: 2,
                color: kPrimaryDarkColor,
              ),
            ),
            hintText: 'ชื่อสินค้า หรือ บาร์โค้ด',
          ),
        ));
  }
}
