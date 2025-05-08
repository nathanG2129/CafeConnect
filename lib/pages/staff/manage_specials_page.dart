import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../widgets/app_drawer.dart';
import '../../models/specialModel.dart';
import '../../models/productModel.dart';
import '../../services/special_service.dart';
import '../../services/product_service.dart';

class ManageSpecialsPage extends StatefulWidget {
  static const String routeName = '/manage-specials';
  
  const ManageSpecialsPage({super.key});

  @override
  State<ManageSpecialsPage> createState() => _ManageSpecialsPageState();
}

class _ManageSpecialsPageState extends State<ManageSpecialsPage> {
  final SpecialService _specialService = SpecialService();
  final ProductService _productService = ProductService();
  
  List<SpecialModel> _specials = [];
  List<ProductModel> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final specials = await _specialService.getAllSpecials();
      final products = await _productService.getAllProducts();
      
      setState(() {
        _specials = specials;
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      appBar: AppBar(
        title: const Text("Manage Daily Specials"),
        centerTitle: true,
        backgroundColor: Colors.brown[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      drawer: const AppDrawer(currentRoute: '/manage-specials'),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSpecialDialog(),
        backgroundColor: Colors.brown[700],
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.brown))
          : _buildSpecialsList(),
    );
  }

  Widget _buildSpecialsList() {
    if (_specials.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.coffee,
              size: 64,
              color: Colors.brown[300],
            ),
            const SizedBox(height: 16),
            Text(
              'No specials found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.brown[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to add a new special',
              style: TextStyle(
                color: Colors.brown[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _specials.length,
      itemBuilder: (context, index) {
        final special = _specials[index];
        // Find related product if exists
        ProductModel? relatedProduct;
        if (special.relatedProductId != null && special.relatedProductId!.isNotEmpty) {
          relatedProduct = _products.firstWhere(
            (product) => product.id == special.relatedProductId,
            orElse: () => ProductModel.empty(),
          );
        }
        
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(
              special.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(special.description),
                const SizedBox(height: 4),
                Text(
                  '₱${special.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[700],
                  ),
                ),
                if (relatedProduct != null && relatedProduct.id.isNotEmpty)
                  Text(
                    'Based on: ${relatedProduct.name}',
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Valid: ${DateFormat('MMM dd').format(special.startDate)}${special.endDate != null ? ' - ${DateFormat('MMM dd').format(special.endDate!)}' : ' onwards'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch(
                  value: special.isActive,
                  onChanged: (value) => _toggleSpecialStatus(special, value),
                  activeColor: Colors.green,
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  color: Colors.blue,
                  onPressed: () => _showSpecialDialog(special: special),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                  onPressed: () => _confirmDeleteSpecial(special),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _toggleSpecialStatus(SpecialModel special, bool isActive) async {
    try {
      await _specialService.toggleSpecialStatus(special.id, isActive);
      _loadData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${special.name} is now ${isActive ? 'active' : 'inactive'}'),
          backgroundColor: isActive ? Colors.green : Colors.orange,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating status: ${e.toString()}')),
      );
    }
  }

  Future<void> _confirmDeleteSpecial(SpecialModel special) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete "${special.name}"?'),
                const Text(
                  'This action cannot be undone.',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteSpecial(special);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteSpecial(SpecialModel special) async {
    try {
      await _specialService.deleteSpecial(special.id);
      _loadData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${special.name} deleted successfully'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting special: ${e.toString()}')),
      );
    }
  }

  Future<void> _showSpecialDialog({SpecialModel? special}) async {
    final isEditing = special != null;
    final TextEditingController nameController = TextEditingController(text: isEditing ? special.name : '');
    final TextEditingController descriptionController = TextEditingController(text: isEditing ? special.description : '');
    final TextEditingController priceController = TextEditingController(text: isEditing ? special.price.toString() : '');
    
    String? selectedProductId = isEditing ? special.relatedProductId : null;
    DateTime startDate = isEditing ? special.startDate : DateTime.now();
    DateTime? endDate = isEditing ? special.endDate : null;
    bool isActive = isEditing ? special.isActive : true;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('${isEditing ? 'Edit' : 'Add'} Special'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Special Name',
                        hintText: 'Enter special name',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText: 'Enter description',
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: priceController,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        hintText: 'Enter price',
                        prefixText: '₱',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String?>(
                      decoration: const InputDecoration(
                        labelText: 'Based on Product (Optional)',
                      ),
                      value: selectedProductId,
                      hint: const Text('Select a product'),
                      isExpanded: true,
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('None'),
                        ),
                        ..._products.map((product) {
                          return DropdownMenuItem<String?>(
                            value: product.id,
                            child: Text(product.name),
                          );
                        }).toList(),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedProductId = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Start Date: '),
                        TextButton(
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: startDate,
                              firstDate: DateTime.now().subtract(const Duration(days: 30)),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            );
                            if (picked != null) {
                              setState(() {
                                startDate = picked;
                                if (endDate != null && endDate!.isBefore(startDate)) {
                                  endDate = null;
                                }
                              });
                            }
                          },
                          child: Text(DateFormat('MMM dd, yyyy').format(startDate)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('End Date (Optional): '),
                        TextButton(
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: endDate ?? startDate.add(const Duration(days: 7)),
                              firstDate: startDate,
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            );
                            if (picked != null) {
                              setState(() {
                                endDate = picked;
                              });
                            }
                          },
                          child: Text(
                            endDate != null
                                ? DateFormat('MMM dd, yyyy').format(endDate!)
                                : 'Not Set',
                          ),
                        ),
                        if (endDate != null)
                          IconButton(
                            icon: const Icon(Icons.clear, size: 16),
                            onPressed: () {
                              setState(() {
                                endDate = null;
                              });
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Active: '),
                        Switch(
                          value: isActive,
                          onChanged: (value) {
                            setState(() {
                              isActive = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(isEditing ? 'Update' : 'Add'),
                  onPressed: () {
                    _saveSpecial(
                      id: isEditing ? special.id : '',
                      name: nameController.text,
                      description: descriptionController.text,
                      price: priceController.text,
                      relatedProductId: selectedProductId,
                      startDate: startDate,
                      endDate: endDate,
                      isActive: isActive,
                      createdAt: isEditing ? special.createdAt : DateTime.now(),
                    );
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
        );
      },
    );
  }

  Future<void> _saveSpecial({
    required String id,
    required String name,
    required String description,
    required String price,
    String? relatedProductId,
    required DateTime startDate,
    DateTime? endDate,
    required bool isActive,
    required DateTime createdAt,
  }) async {
    if (name.isEmpty || description.isEmpty || price.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    double? priceValue = double.tryParse(price);
    if (priceValue == null || priceValue <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid price')),
      );
      return;
    }

    try {
      final special = SpecialModel(
        id: id,
        name: name,
        description: description,
        price: priceValue,
        relatedProductId: relatedProductId,
        isActive: isActive,
        startDate: startDate,
        endDate: endDate,
        createdAt: createdAt,
        updatedAt: DateTime.now(),
      );

      bool success;
      if (id.isEmpty) {
        success = await _specialService.addSpecial(special);
      } else {
        success = await _specialService.updateSpecial(special);
      }

      if (success) {
        _loadData();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Special ${id.isEmpty ? 'added' : 'updated'} successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save special'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
} 