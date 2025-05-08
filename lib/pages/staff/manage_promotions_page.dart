import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../widgets/app_drawer.dart';
import '../../models/promotionModel.dart';
import '../../services/promotion_service.dart';

class ManagePromotionsPage extends StatefulWidget {
  static const String routeName = '/manage-promotions';
  
  const ManagePromotionsPage({super.key});

  @override
  State<ManagePromotionsPage> createState() => _ManagePromotionsPageState();
}

class _ManagePromotionsPageState extends State<ManagePromotionsPage> {
  final PromotionService _promotionService = PromotionService();
  
  List<PromotionModel> _promotions = [];
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
      final promotions = await _promotionService.getAllPromotions();
      
      setState(() {
        _promotions = promotions;
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
        title: const Text("Manage Promotions"),
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
      drawer: const AppDrawer(currentRoute: '/manage-promotions'),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPromotionDialog(),
        backgroundColor: Colors.brown[700],
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.brown))
          : _buildPromotionsList(),
    );
  }

  Widget _buildPromotionsList() {
    if (_promotions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.campaign,
              size: 64,
              color: Colors.brown[300],
            ),
            const SizedBox(height: 16),
            Text(
              'No promotions found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.brown[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to add a new promotion',
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
      itemCount: _promotions.length,
      itemBuilder: (context, index) {
        final promotion = _promotions[index];
        
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: promotion.isActive ? Colors.brown[600] : Colors.brown[300],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Row(
                children: [
                  Icon(Icons.campaign, color: Colors.amber[300], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      promotion.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.amber[200], size: 16),
                      const SizedBox(width: 4),
                      Text(
                        promotion.time,
                        style: TextStyle(
                          color: Colors.brown[100],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    promotion.description,
                    style: TextStyle(
                      color: Colors.brown[100],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.amber[200],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Valid: ${DateFormat('MMM dd').format(promotion.startDate)}${promotion.endDate != null ? ' - ${DateFormat('MMM dd').format(promotion.endDate!)}' : ' onwards'}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.brown[100],
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
                    value: promotion.isActive,
                    onChanged: (value) => _togglePromotionStatus(promotion, value),
                    activeColor: Colors.green,
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    color: Colors.white,
                    onPressed: () => _showPromotionDialog(promotion: promotion),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.red[300],
                    onPressed: () => _confirmDeletePromotion(promotion),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _togglePromotionStatus(PromotionModel promotion, bool isActive) async {
    try {
      await _promotionService.togglePromotionStatus(promotion.id, isActive);
      _loadData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${promotion.title} is now ${isActive ? 'active' : 'inactive'}'),
          backgroundColor: isActive ? Colors.green : Colors.orange,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating status: ${e.toString()}')),
      );
    }
  }

  Future<void> _confirmDeletePromotion(PromotionModel promotion) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete "${promotion.title}"?'),
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
                _deletePromotion(promotion);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deletePromotion(PromotionModel promotion) async {
    try {
      await _promotionService.deletePromotion(promotion.id);
      _loadData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${promotion.title} deleted successfully'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting promotion: ${e.toString()}')),
      );
    }
  }

  Future<void> _showPromotionDialog({PromotionModel? promotion}) async {
    final isEditing = promotion != null;
    final TextEditingController titleController = TextEditingController(text: isEditing ? promotion.title : '');
    final TextEditingController timeController = TextEditingController(text: isEditing ? promotion.time : 'All Day');
    final TextEditingController descriptionController = TextEditingController(text: isEditing ? promotion.description : '');
    
    DateTime startDate = isEditing ? promotion.startDate : DateTime.now();
    DateTime? endDate = isEditing ? promotion.endDate : null;
    bool isActive = isEditing ? promotion.isActive : true;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('${isEditing ? 'Edit' : 'Add'} Promotion'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Promotion Title',
                        hintText: 'Enter promotion title',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: timeController,
                      decoration: const InputDecoration(
                        labelText: 'Time',
                        hintText: 'e.g., 2 PM - 5 PM or All Day',
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
                    _savePromotion(
                      id: isEditing ? promotion.id : '',
                      title: titleController.text,
                      time: timeController.text,
                      description: descriptionController.text,
                      startDate: startDate,
                      endDate: endDate,
                      isActive: isActive,
                      createdAt: isEditing ? promotion.createdAt : DateTime.now(),
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

  Future<void> _savePromotion({
    required String id,
    required String title,
    required String time,
    required String description,
    required DateTime startDate,
    DateTime? endDate,
    required bool isActive,
    required DateTime createdAt,
  }) async {
    if (title.isEmpty || time.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    try {
      final promotion = PromotionModel(
        id: id,
        title: title,
        time: time,
        description: description,
        isActive: isActive,
        startDate: startDate,
        endDate: endDate,
        createdAt: createdAt,
        updatedAt: DateTime.now(),
      );

      bool success;
      if (id.isEmpty) {
        success = await _promotionService.addPromotion(promotion);
      } else {
        success = await _promotionService.updatePromotion(promotion);
      }

      if (success) {
        _loadData();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Promotion ${id.isEmpty ? 'added' : 'updated'} successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save promotion'),
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