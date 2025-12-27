import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hungry_app/features/cart/data/cart_model.dart';
import 'package:hungry_app/features/cart/data/cart_repo.dart';
import 'package:hungry_app/features/cart/widgets/cart_item.dart';
import 'package:hungry_app/features/checkout/views/checkout_view.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_button.dart';
import '../../../shared/custom_text.dart';
import '../../auth/data/auth_repo.dart';
import '../../auth/data/user_model.dart';
import '../../auth/views/login_view.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  List<int> quantities = [];
  bool isLoading = false;
  bool isGuest = false;
  bool isLoadingRemove = false;
  GetCartResponse? cartResponse;

  CartRepo cartRepo = CartRepo();

  UserModel? userModel;
  AuthRepo authRepo = AuthRepo();

  Future<void> getCartData() async {
    try {
      if (!mounted) return;
      setState(() => isLoading = true);
      final response = await cartRepo.getCartData();
      if (!mounted) return;
      final count = response?.cartData.items.length ?? 0;
      setState(() {
        cartResponse = response;
        quantities = List.generate(count, (_) => 1);
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  Future<void> removeCartItem(int id) async {
    try {
      setState(() {
        isLoadingRemove = true;
      });
      await cartRepo.removeCartItem(id);
      getCartData();
      setState(() {
        isLoadingRemove = false;
      });
    } catch (e) {
      setState(() {
        isLoadingRemove = false;
      });
      print(e.toString());
    }
  }

  Future<void> autoLogin() async {
    final user = await authRepo.autoLogin();

    setState(() {
      isGuest = authRepo.isGuest;
    });

    if (user != null) {
      userModel = user;
    }
  }

  @override
  void initState() {
    super.initState();
    autoLogin();
    getCartData();
  }

  void onAdd(int index) {
    setState(() => quantities[index]++);
  }

  void onMin(int index) {
    setState(() {
      if (quantities[index] > 1) quantities[index]--;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isGuest) {
      return RefreshIndicator(
        displacement: 20,
        backgroundColor: AppColors.primary,
        color: Colors.white,
        onRefresh: () async {
          if (authRepo.isGuest) return;

          setState(() {
            userModel = null;
          });
          await getCartData();
        },
        child: Skeletonizer(
          enabled: cartResponse == null,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              toolbarHeight: 0,
              backgroundColor: Colors.white,
              scrolledUnderElevation: 0,
            ),
            body: isLoading
                ? const Center(child: CupertinoActivityIndicator())
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 15, bottom: 140),
                      itemCount: cartResponse?.cartData.items.length ?? 0,
                      itemBuilder: (context, index) {
                        final item = cartResponse!.cartData.items[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: CartItem(
                            image: item.image,
                            text: item.name,
                            desc: 'Spicy ${item.spicy}',
                            isLoading: isLoadingRemove,
                            onRemove: () {
                              removeCartItem(item.itemId);
                            },
                            number: quantities[index],
                            onAdd: () => onAdd(index),
                            onMin: () => onMin(index),
                          ),
                        );
                      },
                    ),
                  ),
            bottomSheet: SafeArea(
              child: Container(
                height: 90,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CustomText(text: 'Total', size: 16),
                        CustomText(
                          text:
                              '\$ ${cartResponse?.cartData.totalPrice}' ??
                              '0.0',
                          size: 24,
                          weight: FontWeight.bold,
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomButton(
                        text: 'Checkout',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CheckoutView(
                                totalPrice:
                                    cartResponse?.cartData.totalPrice ?? '0.0',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else if (isGuest) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No Cart Data\n You Are In Guest Mode',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => LoginView()),
                  );
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      );
    }
    return SizedBox.shrink();
  }
}
