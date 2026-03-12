import 'package:flutter/material.dart';
import '../models/product.dart';
import '../pages/sepet_page.dart';

class DetailPage extends StatefulWidget {
  final Product product;
  final List<Product> cart;
  final VoidCallback? onCartChanged;

  const DetailPage({
    super.key,
    required this.product,
    required this.cart,
    this.onCartChanged,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int cartCount = 0;

  @override
  void initState() {
    super.initState();
    // Sepette ürün varsa sayacı başlat
    cartCount = widget.cart.where((p) => p == widget.product).length;
  }

  void addToCart() {
    setState(() {
      widget.cart.add(widget.product); // sadece bir kez ekle
      cartCount = widget.cart.where((p) => p == widget.product).length;
    });
    if (widget.onCartChanged != null) widget.onCartChanged!();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${widget.product.name} sepete eklendi!"),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        actions: [
          // Sağ üst sayaçlı sepet butonu
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SepetPage(
                      cart: widget.cart,
                      onCartChanged: widget.onCartChanged,
                    ),
                  ),
                ).then((_) {
                  setState(() {}); // sayacı güncelle
                  if (widget.onCartChanged != null) widget.onCartChanged!();
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.shopping_cart, size: 30),
                  if (widget.cart.isNotEmpty)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          widget.cart.length.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ürün resmi
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    widget.product.image,
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.product.name,
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(widget.product.description),
              const SizedBox(height: 20),
              Text(
                "\$${widget.product.price}",
                style: const TextStyle(fontSize: 20, color: Colors.green),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: addToCart,
                      child: const Text("Sepete Ekle"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Sepette: $cartCount",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}