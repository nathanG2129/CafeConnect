import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_activity1/models/productModel.dart';
import 'package:flutter_activity1/services/product_service.dart';

class EditProductPage extends StatefulWidget {
  final ProductModel? product;

  const EditProductPage({super.key, this.product});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final ProductService _productService = ProductService();
  final _formKey = GlobalKey<FormState>();
  
  late ProductModel _product;
  bool _isLoading = false;
  bool _isEditMode = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imagePathController = TextEditingController();
  final TextEditingController _basePriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.product != null;
    _product = widget.product ?? ProductModel.empty();
    
    _nameController.text = _product.name;
    _descriptionController.text = _product.description;
    _imagePathController.text = _product.imagePath;
    _basePriceController.text = _product.basePrice.toString();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _imagePathController.dispose();
    _basePriceController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Update product with form values
      final updatedProduct = _product.copyWith(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        imagePath: _imagePathController.text.trim(),
        basePrice: double.parse(_basePriceController.text),
      );

      bool success;
      if (_isEditMode) {
        success = await _productService.updateProduct(updatedProduct);
      } else {
        success = await _productService.addProduct(updatedProduct);
      }

      setState(() {
        _isLoading = false;
      });

      if (success) {
        if (!mounted) return;
        Navigator.pop(context, true); // Return true to indicate successful operation
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save product'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      appBar: AppBar(
        title: Text(_isEditMode ? "Edit Product" : "Add Product"),
        centerTitle: true,
        backgroundColor: Colors.brown[800],
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.brown))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProductImage(),
                    const SizedBox(height: 24),
                    _buildBasicInfoSection(),
                    const SizedBox(height: 24),
                    _buildSizesSection(),
                    const SizedBox(height: 24),
                    _buildAddOnsSection(),
                    const SizedBox(height: 32),
                    _buildSaveButton(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProductImage() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.brown.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
              image: DecorationImage(
                image: AssetImage(_imagePathController.text),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _imagePathController,
            decoration: const InputDecoration(
              labelText: 'Image Path',
              hintText: 'assets/coffees/example.jpg',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.image),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an image path';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Product Information",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Product Name',
                hintText: 'e.g., Espresso',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a product name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Describe your product',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _basePriceController,
              decoration: const InputDecoration(
                labelText: 'Base Price (₱)',
                hintText: 'e.g., 99.00',
                border: OutlineInputBorder(),
                prefixText: '₱ ',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a base price';
                }
                try {
                  final price = double.parse(value);
                  if (price <= 0) {
                    return 'Price must be greater than zero';
                  }
                } catch (e) {
                  return 'Please enter a valid price';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Available for Purchase'),
              value: _product.isAvailable,
              onChanged: (bool value) {
                setState(() {
                  _product = _product.copyWith(isAvailable: value);
                });
              },
              activeColor: Colors.brown[700],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSizesSection() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Available Sizes",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[800],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  color: Colors.brown[700],
                  onPressed: _addNewSize,
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._buildSizesList(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSizesList() {
    return List.generate(_product.sizes.length, (index) {
      final size = _product.sizes[index];
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                initialValue: size['name'],
                decoration: const InputDecoration(
                  labelText: 'Size Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _product.sizes[index]['name'] = value;
                  });
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: TextFormField(
                initialValue: size['price'].toString(),
                decoration: const InputDecoration(
                  labelText: 'Extra Price',
                  border: OutlineInputBorder(),
                  prefixText: '₱ ',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                onChanged: (value) {
                  setState(() {
                    _product.sizes[index]['price'] = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.red,
              onPressed: () {
                setState(() {
                  _product.sizes.removeAt(index);
                });
              },
            ),
          ],
        ),
      );
    });
  }

  void _addNewSize() {
    setState(() {
      _product.sizes.add({
        'name': '',
        'price': 0.0,
      });
    });
  }

  Widget _buildAddOnsSection() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Available Add-ons",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[800],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  color: Colors.brown[700],
                  onPressed: _addNewAddOn,
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._buildAddOnsList(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAddOnsList() {
    return List.generate(_product.addOns.length, (index) {
      final addOn = _product.addOns[index];
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                initialValue: addOn['name'],
                decoration: const InputDecoration(
                  labelText: 'Add-on Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _product.addOns[index]['name'] = value;
                  });
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: TextFormField(
                initialValue: addOn['price'].toString(),
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                  prefixText: '₱ ',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                onChanged: (value) {
                  setState(() {
                    _product.addOns[index]['price'] = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.red,
              onPressed: () {
                setState(() {
                  _product.addOns.removeAt(index);
                });
              },
            ),
          ],
        ),
      );
    });
  }

  void _addNewAddOn() {
    setState(() {
      _product.addOns.add({
        'name': '',
        'price': 0.0,
      });
    });
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _saveProduct,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.brown[700],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          _isEditMode ? 'Update Product' : 'Add Product',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
} 