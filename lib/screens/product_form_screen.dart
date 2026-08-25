import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/product.dart';
import '../services/api_service.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;
  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  late final TextEditingController _nameController;
  late final TextEditingController _codeController;
  late final TextEditingController _imgController;
  late final TextEditingController _qtyController;
  late final TextEditingController _unitPriceController;

  bool _isLoading = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _isEditing = p != null;
    _nameController = TextEditingController(text: p?.productName ?? '');
    _codeController =
        TextEditingController(text: p?.productCode.toString() ?? '');
    _imgController = TextEditingController(text: p?.img ?? '');
    _qtyController = TextEditingController(text: p?.qty.toString() ?? '');
    _unitPriceController =
        TextEditingController(text: p?.unitPrice.toString() ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _imgController.dispose();
    _qtyController.dispose();
    _unitPriceController.dispose();
    super.dispose();
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final product = Product(
      id: widget.product?.id ?? '',
      productName: _nameController.text.trim(),
      productCode: int.parse(_codeController.text.trim()),
      img: _imgController.text.trim(),
      qty: int.parse(_qtyController.text.trim()),
      unitPrice: int.parse(_unitPriceController.text.trim()),
      totalPrice:
          int.parse(_qtyController.text.trim()) *
          int.parse(_unitPriceController.text.trim()),
    );

    setState(() => _isLoading = true);

    try {
      if (_isEditing) {
        await _apiService.updateProduct(product.id, product);
        if (!mounted) return;
        _showMessage('Product updated successfully!');
      } else {
        await _apiService.createProduct(product);
        if (!mounted) return;
        _showMessage('Product created successfully!');
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      _showMessage('Error: ${e.toString().replaceFirst('Exception: ', '')}',
          isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Product' : 'Add Product'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.sell),
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Product name is required'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Product Code',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.tag),
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Product code is required'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imgController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Image URL',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.image),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _qtyController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.inventory_2),
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Quantity is required'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _unitPriceController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Unit Price',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Unit price is required'
                    : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton.icon(
                        onPressed: _submit,
                        icon: Icon(_isEditing ? Icons.save : Icons.add),
                        label: Text(_isEditing ? 'Update Product' : 'Add Product'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
