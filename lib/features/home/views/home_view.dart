import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/features/home/data/models/product_model.dart';
import 'package:hungry_app/features/home/data/repo/product_repo.dart';
import 'package:hungry_app/features/home/widgets/card_item.dart';
import 'package:hungry_app/features/home/widgets/search_field.dart';
import 'package:hungry_app/features/home/widgets/user_header.dart';
import 'package:hungry_app/features/product/views/product_details_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/network/api_error.dart';
import '../../../shared/custom_snack.dart';
import '../../auth/data/auth_repo.dart';
import '../../auth/data/user_model.dart';
import '../widgets/food_category.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final List<String> category = ['All', 'Combo', 'Sliders', 'Classic'];
  int selectedIndex = 0;

  List<ProductModel>? products;
  List<ProductModel>? allProducts;

  final ProductRepo productRepo = ProductRepo();
  final AuthRepo authRepo = AuthRepo();

  UserModel? userModel;
  final TextEditingController controller = TextEditingController();

  Future<void> getProfileData() async {
    try {
      final user = await authRepo.getProfileData();
      setState(() {
        userModel = user;
      });
    } catch (e) {
      String errorMsg = "Error In Profile";
      if (e is ApiError) {
        errorMsg = e.message;
      }
      ScaffoldMessenger.of(context).showSnackBar(customSnack(errorMsg));
    }
  }

  Future<void> getProducts() async {
    final response = await productRepo.getProducts();
    setState(() {
      allProducts = response;
      products = response;
    });
  }

  @override
  void initState() {
    super.initState();
    getProducts();
    getProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        displacement: 20,
        backgroundColor: AppColors.primary,
        color: Colors.white,
        onRefresh: () async {
          if (authRepo.isGuest) return;

          setState(() {
            userModel = null;
          });

          await getProducts();
          await getProfileData();
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Skeletonizer(
            enabled: products == null,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // ================= APP BAR =================
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  automaticallyImplyLeading: false,
                  expandedHeight: 190,
                  flexibleSpace: FlexibleSpaceBar(
                    background: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(30),
                      ),
                      child: Container(
                        color: Colors.white.withOpacity(0.1),
                        child: SafeArea(
                          bottom: false,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                UserHeader(
                                  userName: userModel?.name ?? 'Guest',
                                  userImage: userModel?.image ?? '',
                                ),
                                const Gap(16),
                                SearchField(
                                  controller: controller,
                                  onChanged: (value) {
                                    final query = value.toLowerCase();
                                    setState(() {
                                      products = allProducts
                                          ?.where(
                                            (p) => p.name
                                                .toLowerCase()
                                                .contains(query),
                                          )
                                          .toList();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // ================= CATEGORY =================
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: FoodCategory(
                      selectedIndex: selectedIndex,
                      category: category,
                    ),
                  ),
                ),

                // ================= GRID =================
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      childCount: products?.length ?? 6,
                      (context, index) {
                        final product = products?[index];
                        if (product == null) {
                          return const CupertinoActivityIndicator();
                        }

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductDetailsView(
                                  productId: product.id,
                                  productImage: product.image,
                                  productPrice: product.price,
                                ),
                              ),
                            );
                          },
                          child: CardItem(
                            text: product.name,
                            image: product.image,
                            desc: product.desc,
                            rate: product.rate,
                          ),
                        );
                      },
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.72,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 9,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
