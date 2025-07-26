import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/Responsive/UiComponents/InfoWidget.dart';
import '../../../../core/Responsive/models/DeviceInfo.dart';
import '../../../../core/helper/cherryToast/CherryToastMsgs.dart';
import '../../../../core/routing/routs.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/widgets/search_text_field.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/item_card.dart';
import '../../data/models/menu_item.dart';
import '../cubit/menu_cubit.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/cubit/cart_state.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final TextEditingController _searchController = TextEditingController();
  List<MenuItem> _filteredMenuItems = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Fetch menu items when the page loads
    context.read<MenuCubit>().fetchMenuItems();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterMenuItems(List<MenuItem> menuItems, String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredMenuItems = menuItems;
        _isSearching = false;
      });
    } else {
      setState(() {
        _filteredMenuItems = menuItems.where((item) {
          return item.name.toLowerCase().contains(query.toLowerCase()) ||
              (item.description?.toLowerCase().contains(query.toLowerCase()) ??
                  false) ||
              (item.category?.toLowerCase().contains(query.toLowerCase()) ??
                  false);
        }).toList();
        _isSearching = true;
      });
    }
  }

  void _updateFilteredItems(List<MenuItem> menuItems) {
    if (_searchController.text.isEmpty) {
      setState(() {
        _filteredMenuItems = menuItems;
        _isSearching = false;
      });
    } else {
      _filterMenuItems(menuItems, _searchController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<CartCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Our Menu'),
          leading: IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push(Routes.profileScreen),
            tooltip: 'Profile',
          ),
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          actions: [
            BlocBuilder<CartCubit, CartState>(
              builder: (context, cartState) {
                int itemCount = 0;
                if (cartState is CartLoaded) {
                  itemCount = cartState.items.fold(
                    0,
                    (sum, item) => sum + item.quantity,
                  );
                }

                return Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart),
                      onPressed: () => context.push(Routes.cartScreen),
                    ),
                    if (itemCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '$itemCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppTheme.backgroundColor, AppTheme.surfaceColor],
            ),
          ),
          child: BlocListener<MenuCubit, MenuState>(
            listener: (context, state) {
              if (state is MenuSuccess) {
                _updateFilteredItems(state.menuItems);
              }
            },
            child: BlocBuilder<MenuCubit, MenuState>(
              builder: (context, state) {
                return _buildBody(state);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(MenuState state) {
    if (state is MenuLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryColor),
      );
    }

    if (state is MenuFailure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppTheme.errorColor),
            const SizedBox(height: 16),
            Text(
              'Failed to load menu',
              style: AppTheme.headline4.copyWith(color: AppTheme.errorColor),
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              style: AppTheme.bodyText2.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<MenuCubit>().fetchMenuItems(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state is MenuSuccess) {
      return _buildMenuContent(state.menuItems, state);
    }

    // Initial state
    return const LoadingWidget(
      color: AppTheme.primaryColor,
      message: 'Loading menu items...',
    );
  }

  Widget _buildMenuContent(List<MenuItem> menuItems, MenuState state) {
    return RefreshIndicator(
      onRefresh: () => context.read<MenuCubit>().fetchMenuItems(),
      color: AppTheme.primaryColor,
      child: InfoWidget(
        builder: (context, deviceinfo) => Padding(
          padding: EdgeInsets.all(deviceinfo.screenWidth * 0.05),
          child: Column(
            children: [
              SizedBox(height: deviceinfo.screenHeight * 0.01),
              SearchTextField(
                controller: _searchController,
                hintText: 'Search menu items...',
                onChanged: (query) {
                  _filterMenuItems(menuItems, query);
                },
                onClear: () {
                  _filterMenuItems(menuItems, '');
                },
                contentPadding: EdgeInsets.symmetric(
                  vertical: deviceinfo.screenHeight * 0.01,
                  horizontal: deviceinfo.screenWidth * 0.04,
                ),
              ),

              SizedBox(height: deviceinfo.screenHeight * 0.02),
              Expanded(
                child: menuItems.isEmpty
                    ? _buildEmptyState(deviceinfo)
                    : _filteredMenuItems.isEmpty &&
                          _searchController.text.isNotEmpty
                    ? _buildNoSearchResults(deviceinfo)
                    : _buildMenuItemsList(_filteredMenuItems, deviceinfo),
              ),

              SizedBox(height: deviceinfo.screenHeight * 0.02),

              // View Cart Button
              SizedBox(
                width: double.infinity,
                height: deviceinfo.screenHeight * 0.07,
                child: ElevatedButton.icon(
                  onPressed: () => context.push(Routes.cartScreen),
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text('View Cart'),
                  style: AppTheme.primaryButtonStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(Deviceinfo deviceinfo) {
    return EmptyStateWidget(
      icon: Icons.restaurant_menu,
      title: 'No menu items available',
      subtitle: 'Check back later for our delicious menu',
      iconSize: deviceinfo.screenHeight * 0.1,
    );
  }

  Widget _buildNoSearchResults(Deviceinfo deviceinfo) {
    return EmptyStateWidget(
      icon: Icons.search_off,
      title: 'No items found',
      subtitle: 'Try adjusting your search terms',
      iconSize: deviceinfo.screenWidth * 0.15,
    );
  }

  Widget _buildMenuItemsList(List<MenuItem> menuItems, Deviceinfo deviceinfo) {
    return ListView.builder(
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final menuItem = menuItems[index];
        return _buildMenuItemCard(menuItem, deviceinfo);
      },
    );
  }

  Widget _buildMenuItemCard(MenuItem menuItem, Deviceinfo deviceinfo) {
    return ItemCard(
      font: deviceinfo.screenWidth * 0.037,
      imageUrl: menuItem.imageUrl ?? '',
      title: menuItem.name,
      description: menuItem.description ?? '',
      category: menuItem.category,
      price: menuItem.price,
      cacheKey: 'menu_${menuItem.id}',
      imageWidth: deviceinfo.screenWidth * 0.2,
      imageHeight: deviceinfo.screenWidth * 0.2,
      borderRadius: deviceinfo.screenWidth * 0.04,
      margin: EdgeInsets.only(bottom: deviceinfo.screenHeight * 0.02),
      padding: EdgeInsets.all(deviceinfo.screenWidth * 0.04),
      trailing: IconButton(
        onPressed: () {
          getIt<CartCubit>().addMenuItemToCart(
            id: menuItem.id,
            name: menuItem.name,
            price: menuItem.price,
            imageUrl: menuItem.imageUrl,
          );

          CherryToastMsgs.CherryToastSuccess(
            context: context,
            title: 'Added to Cart',
            description: '${menuItem.name} has been added to your cart.',
            info: deviceinfo,
          ).show(context);
        },
        icon: Icon(
          Icons.add_shopping_cart,
          color: AppTheme.primaryColor,
          size: deviceinfo.screenWidth * 0.08,
        ),
      ),
    );
  }
}
