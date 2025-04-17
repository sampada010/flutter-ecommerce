
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:ecommerce_app/widgets/app_scaffold.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';
  
  const ProfileScreen({Key? key}) : super(key: key);
  
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _streetController;
  late TextEditingController _cityController;
  late TextEditingController _zipcodeController;
  late TextEditingController _countryController;
  
  @override
  void initState() {
    super.initState();
    _initControllers();
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _zipcodeController.dispose();
    _countryController.dispose();
    super.dispose();
  }
  
  void _initControllers() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;
    
    if (user != null) {
      _nameController = TextEditingController(text: user.name);
      _emailController = TextEditingController(text: user.email);
      _phoneController = TextEditingController(text: user.phone);
      _streetController = TextEditingController(text: user.address.street);
      _cityController = TextEditingController(text: user.address.city);
      _zipcodeController = TextEditingController(text: user.address.zipcode);
      _countryController = TextEditingController(text: user.address.country);
    } else {
      _nameController = TextEditingController();
      _emailController = TextEditingController();
      _phoneController = TextEditingController();
      _streetController = TextEditingController();
      _cityController = TextEditingController();
      _zipcodeController = TextEditingController();
      _countryController = TextEditingController();
    }
  }
  
  void _toggleEditMode() {
    if (_isEditing) {
      _saveChanges();
    }
    
    setState(() {
      _isEditing = !_isEditing;
    });
  }
  
  Future<void> _saveChanges() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    final updatedAddress = Address(
      street: _streetController.text,
      city: _cityController.text,
      zipcode: _zipcodeController.text,
      country: _countryController.text,
    );
    
    await userProvider.updateUserProfile(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      address: updatedAddress,
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final theme = Theme.of(context);
    
    if (user == null) {
      return const AppScaffold(
        title: 'Profile',
        body: Center(child: Text('No user data available')),
      );
    }
    
    return AppScaffold(
      title: 'My Profile',
      actions: [
        IconButton(
          icon: Icon(_isEditing ? Icons.save : Icons.edit),
          tooltip: _isEditing ? 'Save' : 'Edit',
          onPressed: _toggleEditMode,
        ),
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  Hero(
                    tag: 'profile-avatar',
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: theme.colorScheme.primary,
                      backgroundImage: NetworkImage(user.avatar),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _isEditing
                      ? TextField(
                          controller: _nameController,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                        )
                      : Text(
                          user.name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Contact Information Section
            _SectionTitle(title: 'Contact Information'),
            const SizedBox(height: 16),
            
            // Email
            _ProfileField(
              icon: Icons.email,
              label: 'Email',
              value: user.email,
              controller: _emailController,
              isEditing: _isEditing,
            ),
            const SizedBox(height: 16),
            
            // Phone
            _ProfileField(
              icon: Icons.phone,
              label: 'Phone',
              value: user.phone,
              controller: _phoneController,
              isEditing: _isEditing,
            ),
            const SizedBox(height: 24),
            
            // Address Section
            _SectionTitle(title: 'Address'),
            const SizedBox(height: 16),
            
            // Street
            _ProfileField(
              icon: Icons.home,
              label: 'Street',
              value: user.address.street,
              controller: _streetController,
              isEditing: _isEditing,
            ),
            const SizedBox(height: 16),
            
            // City
            _ProfileField(
              icon: Icons.location_city,
              label: 'City',
              value: user.address.city,
              controller: _cityController,
              isEditing: _isEditing,
            ),
            const SizedBox(height: 16),
            
            // Zipcode
            _ProfileField(
              icon: Icons.pin_drop,
              label: 'Zip Code',
              value: user.address.zipcode,
              controller: _zipcodeController,
              isEditing: _isEditing,
            ),
            const SizedBox(height: 16),
            
            // Country
            _ProfileField(
              icon: Icons.flag,
              label: 'Country',
              value: user.address.country,
              controller: _countryController,
              isEditing: _isEditing,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  
  const _SectionTitle({
    Key? key,
    required this.title,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Divider(
          color: Theme.of(context).colorScheme.primary,
          thickness: 2,
        ),
      ],
    );
  }
}

class _ProfileField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final TextEditingController controller;
  final bool isEditing;
  
  const _ProfileField({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    required this.controller,
    required this.isEditing,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              isEditing
                  ? TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    )
                  : Text(
                      value,
                      style: theme.textTheme.bodyLarge,
                    ),
            ],
          ),
        ),
      ],
    );
  }
}