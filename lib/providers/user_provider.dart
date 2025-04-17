import 'package:flutter/foundation.dart';
import 'package:ecommerce_app/models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  
  UserProvider() {
    // Initialize with a mock user for demo
    _user = User.mock();
  }
  
  // Getter
  User? get user => _user;
  
  // In a real app, you would have methods to fetch user data from an API
  // and update the user profile. For this demo, we'll simulate that
  // functionality with a mock user.
  
  // Update user profile (in a real app, this would call an API)
  Future<void> updateUserProfile({
    String? name,
    String? email,
    String? phone,
    Address? address,
  }) async {
    if (_user == null) return;
    
    _user = User(
      id: _user!.id,
      name: name ?? _user!.name,
      email: email ?? _user!.email,
      avatar: _user!.avatar,
      phone: phone ?? _user!.phone,
      address: address ?? _user!.address,
    );
    
    notifyListeners();
  }
}
