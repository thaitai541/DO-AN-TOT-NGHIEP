import 'dart:convert';
import 'dart:io';

import 'package:beauty_hub_admin/models/category.dart';
import 'package:beauty_hub_admin/models/detail_brand.dart';
import 'package:beauty_hub_admin/models/product.dart';
import 'package:beauty_hub_admin/shared/constants/app_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/brand.dart';
import '../../models/order.dart';
import '../../models/product_detail.dart';
import '../../models/user_info.dart' as models;

class FirebaseService {
  static final _auth = FirebaseAuth.instance;
  static final _database = FirebaseDatabase.instance;
  static final _storage = FirebaseStorage.instance;

  static final _dbRef = _database.refFromURL(AppConstants.dbUrl);
  static final _storeRef = _storage.refFromURL(AppConstants.stoRef);

  //Auth
  static Future<UserCredential?> loginWithEmailPassword(
    String email,
    String password,
    Function(String) onError,
  ) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential;
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'invalid-email':
          onError('Email không hợp lệ');
          break;
        case 'invalid-credential':
          onError('Tài khoản không tồn tại');
          break;
        case 'wrong-password':
          onError('Mật khẩu không đúng');
          break;
        default:
          onError('Đã có lỗi xảy ra. Vui lòng đăng nhập lại');
          break;
      }
      return null;
    }
  }

  static void signOut(Function() onSuccess, Function(String) onFailure) {
    _auth.signOut().then((value) {
      onSuccess();
    }).onError((error, stackTrace) => onFailure(error.toString()));
  }

  //Product Manage
  static Future<void> fetchProducts(
    Function(List<Product>) onComplete,
    Function(String) onError,
  ) async {
    List<Product> products = [];
    final prefs = Get.find<SharedPreferences>();
    String idUser = prefs.getString(AppConstants.idUser) ?? '';
    _dbRef.child('Products').get().then((snapshot) {
      for (DataSnapshot dataSnapshot in snapshot.children) {
        final data =
            jsonDecode(jsonEncode(dataSnapshot.value)) as Map<String, dynamic>;
        Product product = Product.fromJson(data);
        if (product.brand.idBrand == idUser) {
          products.add(product);
        }
      }
      onComplete(products);
    }).onError((error, stackTrace) => onError(error.toString()));
  }

  static void deleteProduct(String idProduct) async {
    _dbRef.child('Products').child(idProduct).remove();
    EasyLoading.showToast('Xóa sản phẩm thành công');
  }

  static void uploadImageProduct(
    String id,
    File imageFile,
    Function(String) onSuccess,
    Function(String) onFailure,
  ) {
    _storeRef
        .child('products')
        .child(id)
        .putFile(imageFile)
        .then((taskSnapshot) async {
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      if (imageUrl.isNotEmpty) {
        onSuccess(imageUrl);
      }
    }).onError((error, stackTrace) => onFailure(error.toString()));
  }

  static void writeProductToDb(Product product) {
    _dbRef
        .child('Products')
        .child(product.idProduct)
        .set(product.convertToJson());
  }

  static void writeDetailProductToDb(ProductDetail detail) {
    _dbRef
        .child('DetailProducts')
        .child(detail.idProduct)
        .set(detail.convertToJson());
  }

  //Order Manage
  static Future<void> fetchOrders(Function(List<Order>) onComplete) async {
    List<Order> orders = [];
    _dbRef.child('Orders').get().then((snapshot) {
      for (DataSnapshot dataSnapshot in snapshot.children) {
        final data =
            jsonDecode(jsonEncode(dataSnapshot.value)) as Map<String, dynamic>;
        Order order = Order.fromJson(data);
        orders.add(order);
      }
      onComplete(orders);
    });
  }

  static void fetchProductInfoById(
      String id, Function(Product) onComplete, Function(String) onError) {
    _dbRef.child('Products').child(id).get().then((snapshot) {
      final data =
          jsonDecode(jsonEncode(snapshot.value)) as Map<String, dynamic>;
      Product product = Product.fromJson(data);
      onComplete(product);
    }).onError((error, stackTrace) => onError(error.toString()));
  }

  static void fetchProductDetailInfoById(
      String id, Function(ProductDetail) onComplete, Function(String) onError) {
    _dbRef.child('DetailProducts').child(id).get().then((snapshot) {
      final data =
          jsonDecode(jsonEncode(snapshot.value)) as Map<String, dynamic>;
      ProductDetail detail = ProductDetail.fromJson(data);
      onComplete(detail);
    }).onError((error, stackTrace) => onError(error.toString()));
  }

  static void fetchUserInfo(String id, Function(models.UserInfo) onComplete,
      Function(String) onError) {
    _dbRef.child('Users').child(id).get().then((snapshot) {
      final data =
          jsonDecode(jsonEncode(snapshot.value)) as Map<String, dynamic>;
      models.UserInfo userInfo = models.UserInfo.fromJson(data);
      onComplete(userInfo);
    }).onError((error, stackTrace) => onError(error.toString()));
  }

  static void confirmOrder(String id, Function(String) onError) {
    _dbRef.child('Orders').child(id).update({"status": "SUCCESS"}).onError(
        (error, stackTrace) => onError(error.toString()));
  }

  static void cancelOrder(String id, Function(String) onError) {
    _dbRef.child('Orders').child(id).update({"status": "CANCEL"}).onError(
        (error, stackTrace) => onError(error.toString()));
  }

  static Future<void> fetchCategories(
      Function(List<Category>) onComplete) async {
    List<Category> categories = [];
    _dbRef.child('Categories').get().then((snapshot) {
      for (DataSnapshot dataSnapshot in snapshot.children) {
        final data =
            jsonDecode(jsonEncode(dataSnapshot.value)) as Map<String, dynamic>;
        Category order = Category.fromJson(data);
        categories.add(order);
      }
      onComplete(categories);
    });
  }

  static void fetchBrandWithAccount(
    Function(bool) onComplete,
    Function(String) onError,
  ) {
    final prefs = Get.find<SharedPreferences>();
    final idBrand = prefs.getString(AppConstants.idUser);
    if (idBrand != null) {
      _dbRef.child('Brands').child(idBrand).get().then((snapshot) {
        onComplete(snapshot.exists);
      }).onError((error, stackTrace) => onError(error.toString()));
    }
  }

  static Future<void> fetchBrandInfo(Function(Brand) onComplete) async {
    final prefs = Get.find<SharedPreferences>();
    final idBrand = prefs.getString(AppConstants.idUser);
    if (idBrand != null) {
      _dbRef.child('Brands').child(idBrand).get().then((snapshot) {
        final data =
            jsonDecode(jsonEncode(snapshot.value)) as Map<String, dynamic>;
        Brand brand = Brand.fromJson(data);
        onComplete(brand);
      });
    }
  }

  static void updateProduct(
    String id,
    Map<String, dynamic> data,
    Function() onComplete,
    Function(String) onError,
  ) {
    _dbRef.child('Products').child(id).update(data);
  }

  static void updateDetailProduct(
    String id,
    Map<String, dynamic> data,
    Function() onComplete,
    Function(String) onError,
  ) {
    _dbRef.child('DetailProducts').child(id).update(data);
  }

  static void createStore(
    Brand brand,
    Function() onComplete,
    Function(String) onError,
  ) {
    final prefs = Get.find<SharedPreferences>();
    final idBrand = prefs.getString(AppConstants.idUser);
    if (idBrand != null) {
      _dbRef
          .child('Brands')
          .child(idBrand)
          .set(brand.toJson())
          .then((value) => onComplete())
          .onError((error, stackTrace) => onError(error.toString()));
    }
  }

  static void writeDetailToStore(DetailBrand detailBrand) {
    final prefs = Get.find<SharedPreferences>();
    final idBrand = prefs.getString(AppConstants.idUser);
    if (idBrand != null) {
      _dbRef.child('DetailBrands').child(idBrand).set(detailBrand.toJson());
    }
  }

  static void uploadLogoBrand(
    File imageFile,
    Function(String) onSuccess,
    Function(String) onFailure,
  ) {
    EasyLoading.show(status: 'Đang upload hình ảnh cửa hàng');
    final prefs = Get.find<SharedPreferences>();
    final idBrand = prefs.getString(AppConstants.idUser);
    if (idBrand != null) {
      _storeRef
          .child('brands')
          .child(idBrand)
          .putFile(imageFile)
          .then((taskSnapshot) async {
        String imageUrl = await taskSnapshot.ref.getDownloadURL();
        if (imageUrl.isNotEmpty) {
          EasyLoading.dismiss();
          onSuccess(imageUrl);
        }
      }).onError((error, stackTrace) => onFailure(error.toString()));
    }
  }
}
