import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../models/specialModel.dart';
import '../../models/productModel.dart';
import '../../services/special_service.dart';
import '../../services/product_service.dart';
import '../../widgets/app_drawer.dart';

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
  String _filterOption = 'all'; // all, active, upcoming, expired

  // Variables for special creation/editing
  ProductModel? _selectedProduct;
  DiscountType _selectedDiscountType = DiscountType.fixedPrice;
  double _discountValue = 0.0;
  double _originalPrice = 0.0;
  double _finalPrice = 0.0;

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
      final allSpecials = await _specialService.getAllSpecials();
      final allProducts = await _productService.getAllProducts();
      
      setState(() {
        _specials = allSpecials;
        _products = allProducts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<SpecialModel> get _filteredSpecials {
    final now = DateTime.now();
    
    switch (_filterOption) {
      case 'active':
        return _specials.where((special) => 
          special.isActive && 
          special.startDate.isBefore(now) && 
          special.endDate.isAfter(now)
        ).toList();
      case 'upcoming':
        return _specials.where((special) => 
          special.isActive && 
          special.startDate.isAfter(now)
        ).toList();
      case 'expired':
        return _specials.where((special) => 
          !special.isActive || special.endDate.isBefore(now)
        ).toList();
      default:
        return _specials;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      appBar: AppBar(
        title: const Text("Manage Specials"),
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
        backgroundColor: Colors.brown[700],
        foregroundColor: Colors.white,
        onPressed: () => _showSpecialDialog(),
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.brown))
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        _buildFilterOptions(),
        Expanded(
          child: _filteredSpecials.isEmpty
              ? _buildEmptyState()
              : _buildSpecialsList(),
        ),
      ],
    );
  }

  Widget _buildFilterOptions() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Text(
            'Filter: ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.brown[800],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All', 'all'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Active', 'active'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Upcoming', 'upcoming'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Expired', 'expired'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _filterOption == value;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: Colors.brown[300],
      checkmarkColor: Colors.white,
      backgroundColor: Colors.brown[100],
      onSelected: (selected) {
        setState(() {
          _filterOption = value;
        });
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_offer_outlined,
            size: 80,
            color: Colors.brown[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No specials found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.brown[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add a new special',
            style: TextStyle(
              fontSize: 16,
              color: Colors.brown[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredSpecials.length,
      itemBuilder: (context, index) {
        final special = _filteredSpecials[index];
        return _buildSpecialCard(special);
      },
    );
  }

  Widget _buildSpecialCard(SpecialModel special) {
    final now = DateTime.now();
    final isActive = special.isActive && 
                    special.startDate.isBefore(now) && 
                    special.endDate.isAfter(now);
    final isUpcoming = special.isActive && special.startDate.isAfter(now);
    final isExpired = !special.isActive || special.endDate.isBefore(now);
    
    Color statusColor;
    String statusText;
    
    if (isActive) {
      statusColor = Colors.green;
      statusText = 'Active';
    } else if (isUpcoming) {
      statusColor = Colors.orange;
      statusText = 'Upcoming';
    } else {
      statusColor = Colors.red;
      statusText = 'Expired';
    }

    // Find linked product name if any
    String productName = 'No linked product';
    if (special.productId != null) {
      final product = _products.firstWhere(
        (p) => p.id == special.productId,
        orElse: () => ProductModel.empty(),
      );
      if (product.id.isNotEmpty) {
        productName = product.name;
      }
    }
    
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showSpecialDialog(special: special),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      special.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                special.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              // Price display with discount info
              Row(
                children: [
                  if (special.discountType != DiscountType.fixedPrice)
                    Text(
                      '₱${special.originalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  if (special.discountType != DiscountType.fixedPrice)
                    const SizedBox(width: 8),
                  Text(
                    '₱${special.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[700],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      special.getDiscountDescription(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    '${DateFormat('MM/dd/yyyy').format(special.startDate)} - ${DateFormat('MM/dd/yyyy').format(special.endDate)}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.coffee, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    productName,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Toggle active status
                  TextButton.icon(
                    icon: Icon(
                      special.isActive ? Icons.unpublished : Icons.check_circle,
                      size: 18,
                    ),
                    label: Text(special.isActive ? 'Deactivate' : 'Activate'),
                    onPressed: () => _toggleSpecialStatus(special),
                  ),
                  // Delete button
                  TextButton.icon(
                    icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                    label: const Text('Delete', style: TextStyle(color: Colors.red)),
                    onPressed: () => _confirmDeleteSpecial(special),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _toggleSpecialStatus(SpecialModel special) async {
    final result = await _specialService.toggleSpecialStatus(
      special.id, 
      !special.isActive
    );
    
    if (result) {
      _loadData();
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update special status'))
      );
    }
  }

  Future<void> _confirmDeleteSpecial(SpecialModel special) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Special'),
        content: Text('Are you sure you want to delete "${special.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    
    if (confirm == true) {
      final result = await _specialService.deleteSpecial(special.id);
      
      if (result) {
        _loadData();
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete special'))
        );
      }
    }
  }

  Future<void> _showSpecialDialog({SpecialModel? special}) async {
    final isEditing = special != null;
    final formKey = GlobalKey<FormState>();
    
    // Initialize form values
    String name = isEditing ? special.name : '';
    String description = isEditing ? special.description : '';
    DateTime startDate = isEditing ? special.startDate : DateTime.now();
    DateTime endDate = isEditing ? special.endDate : DateTime.now().add(const Duration(days: 7));
    String? productId = isEditing ? special.productId : null;
    
    // Initialize discount related values
    _selectedDiscountType = isEditing ? special.discountType : DiscountType.fixedPrice;
    _discountValue = isEditing ? special.discountValue : 0.0;
    _originalPrice = isEditing ? special.originalPrice : 0.0;
    _finalPrice = isEditing ? special.price : 0.0;
    
    // Find selected product if productId is available
    _selectedProduct = null;
    if (productId != null) {
      for (var product in _products) {
        if (product.id == productId) {
          _selectedProduct = product;
          if (!isEditing) {
            _originalPrice = product.basePrice;
            _updateFinalPrice();
          }
          break;
        }
      }
    }
    
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('${isEditing ? 'Edit' : 'Add'} Special'),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    TextFormField(
                      initialValue: name,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value?.isEmpty ?? true 
                        ? 'Please enter a name' 
                        : null,
                      onSaved: (value) => name = value ?? '',
                    ),
                    const SizedBox(height: 16),
                    
                    // Description
                    TextFormField(
                      initialValue: description,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                      validator: (value) => value?.isEmpty ?? true 
                        ? 'Please enter a description' 
                        : null,
                      onSaved: (value) => description = value ?? '',
                    ),
                    const SizedBox(height: 16),

                    // Product selection
                    DropdownButtonFormField<String?>(
                      value: productId,
                      decoration: const InputDecoration(
                        labelText: 'Link to Product (Optional)',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('No Product'),
                        ),
                        ..._products.map((product) => DropdownMenuItem<String?>(
                          value: product.id,
                          child: Text('${product.name} (₱${product.basePrice.toStringAsFixed(2)})'),
                        )),
                      ],
                      onChanged: (value) {
                        setState(() {
                          productId = value;
                          
                          // Find the selected product and update original price
                          if (value != null) {
                            for (var product in _products) {
                              if (product.id == value) {
                                _selectedProduct = product;
                                _originalPrice = product.basePrice;
                                _updateFinalPrice();
                                break;
                              }
                            }
                          } else {
                            _selectedProduct = null;
                            // If no product is selected, only fixed price makes sense
                            _selectedDiscountType = DiscountType.fixedPrice;
                            _originalPrice = 0;
                            _finalPrice = _discountValue;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Pricing section
                    Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Pricing',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            
                            // Original price display
                            if (_selectedProduct != null) ...[
                              Text(
                                'Original Price: ₱${_originalPrice.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                            
                            // Discount type selection
                            const Text('Discount Type:'),
                            const SizedBox(height: 4),
                            SegmentedButton<DiscountType>(
                              segments: [
                                ButtonSegment<DiscountType>(
                                  value: DiscountType.fixedPrice,
                                  label: const Text('Fixed Price'),
                                  icon: const Icon(Icons.money),
                                ),
                                if (_selectedProduct != null) ...[
                                  ButtonSegment<DiscountType>(
                                    value: DiscountType.percentOff,
                                    label: const Text('% Off'),
                                    icon: const Icon(Icons.percent),
                                  ),
                                  ButtonSegment<DiscountType>(
                                    value: DiscountType.amountOff,
                                    label: const Text('Amount Off'),
                                    icon: const Icon(Icons.remove),
                                  ),
                                ],
                              ],
                              selected: {_selectedDiscountType},
                              onSelectionChanged: (Set<DiscountType> newSelection) {
                                setState(() {
                                  _selectedDiscountType = newSelection.first;
                                  _updateFinalPrice();
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            
                            // Discount value entry field
                            TextFormField(
                              initialValue: _discountValue.toString(),
                              decoration: InputDecoration(
                                labelText: _getDiscountValueLabel(),
                                border: const OutlineInputBorder(),
                                prefixText: _selectedDiscountType == DiscountType.percentOff ? '' : '₱',
                                suffixText: _selectedDiscountType == DiscountType.percentOff ? '%' : '',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a value';
                                }
                                try {
                                  final discountValue = double.parse(value);
                                  
                                  if (discountValue < 0) {
                                    return 'Value cannot be negative';
                                  }
                                  
                                  if (_selectedDiscountType == DiscountType.percentOff && discountValue > 100) {
                                    return 'Percentage cannot exceed 100%';
                                  }
                                  
                                  if (_selectedDiscountType == DiscountType.amountOff && 
                                      _selectedProduct != null && 
                                      discountValue > _originalPrice) {
                                    return 'Discount cannot exceed original price';
                                  }
                                  
                                  return null;
                                } catch (e) {
                                  return 'Invalid number format';
                                }
                              },
                              onChanged: (value) {
                                setState(() {
                                  _discountValue = double.tryParse(value) ?? 0;
                                  _updateFinalPrice();
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            
                            // Final price display
                            Row(
                              children: [
                                Text(
                                  'Final Price: ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                Text(
                                  '₱${_finalPrice.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[700],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Date range
                    Row(
                      children: [
                        Expanded(
                          child: _buildDateField(
                            label: 'Start Date',
                            selectedDate: startDate,
                            onDateSelected: (date) => setState(() => startDate = date),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDateField(
                            label: 'End Date',
                            selectedDate: endDate,
                            onDateSelected: (date) => setState(() => endDate = date),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    formKey.currentState?.save();
                    
                    // Check if end date is after start date
                    if (endDate.isBefore(startDate)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('End date must be after start date'))
                      );
                      return;
                    }
                    
                    final updatedSpecial = (isEditing ? special : SpecialModel.empty()).copyWith(
                      name: name,
                      description: description,
                      price: _finalPrice,
                      discountType: _selectedDiscountType,
                      discountValue: _discountValue,
                      originalPrice: _originalPrice,
                      startDate: startDate,
                      endDate: endDate,
                      productId: productId,
                      isActive: isEditing ? special.isActive : true,
                    );
                    
                    // Save the special
                    _saveSpecial(updatedSpecial, isEditing);
                    Navigator.pop(context);
                  }
                },
                child: Text(isEditing ? 'Update' : 'Add'),
              ),
            ],
          );
        }
      ),
    );
  }
  
  // Helper method to update the final price based on discount type and value
  void _updateFinalPrice() {
    _finalPrice = SpecialModel.calculatePrice(
      _selectedDiscountType, 
      _originalPrice, 
      _discountValue
    );
  }
  
  // Helper method to get the appropriate label for the discount value field
  String _getDiscountValueLabel() {
    switch (_selectedDiscountType) {
      case DiscountType.percentOff:
        return 'Percentage Off';
      case DiscountType.amountOff:
        return 'Amount Off';
      case DiscountType.fixedPrice:
        return 'Price';
    }
  }

  Future<void> _saveSpecial(SpecialModel special, bool isEditing) async {
    final result = isEditing
        ? await _specialService.updateSpecial(special)
        : await _specialService.addSpecial(special);
    
    if (result) {
      _loadData();
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to ${isEditing ? 'update' : 'add'} special'))
      );
    }
  }

  Widget _buildDateField({
    required String label,
    required DateTime selectedDate,
    required Function(DateTime) onDateSelected,
  }) {
    return InkWell(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        
        if (pickedDate != null) {
          onDateSelected(pickedDate);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: Text(
          DateFormat('MM/dd/yyyy').format(selectedDate),
        ),
      ),
    );
  }
} 