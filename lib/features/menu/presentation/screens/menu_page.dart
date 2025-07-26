import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:recogenie_restaurant/core/Responsive/UiComponents/InfoWidget.dart';
import 'package:recogenie_restaurant/core/Responsive/models/DeviceInfo.dart';
import 'package:recogenie_restaurant/core/helper/cherryToast/CherryToastMsgs.dart';
import '../../../../core/routing/routs.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/di/injection.dart';
import '../../data/models/menu_item.dart';
import '../cubit/menu_cubit.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/cubit/cart_state.dart';

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
    return BlocProvider(
      create: (context) => getIt<CartCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Our Menu'),
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
    return const Center(
      child: CircularProgressIndicator(color: AppTheme.primaryColor),
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
              TextField(
                onTapOutside: (_) {
                  FocusScope.of(context).unfocus();
                },
                controller: _searchController,
                onChanged: (query) {
                  _filterMenuItems(menuItems, query);
                },
                decoration: InputDecoration(
                  hintText: 'Search menu items...',
                  hintStyle: AppTheme.bodyText2.copyWith(
                    color: AppTheme.textHintColor,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppTheme.textSecondaryColor,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: AppTheme.textSecondaryColor,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            _filterMenuItems(menuItems, '');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: deviceinfo.screenHeight * 0.01,
                    horizontal: deviceinfo.screenWidth * 0.04,
                  ),
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: deviceinfo.screenHeight * 0.1,
            color: AppTheme.textSecondaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            'No menu items available',
            style: AppTheme.headline4.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for our delicious menu',
            style: AppTheme.bodyText2.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNoSearchResults(Deviceinfo deviceinfo) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: deviceinfo.screenWidth * 0.02,
            color: AppTheme.textSecondaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            'No items found',
            style: AppTheme.headline4.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search terms',
            style: AppTheme.bodyText2.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
    return Container(
      margin: EdgeInsets.only(bottom: deviceinfo.screenHeight * 0.02),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(deviceinfo.screenWidth * 0.04),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(deviceinfo.screenWidth * 0.04),
        child: Row(
          children: [
            Container(
              width: deviceinfo.screenWidth * 0.2,
              height: deviceinfo.screenWidth * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  deviceinfo.screenWidth * 0.04,
                ),
                color: AppTheme.backgroundColor,
              ),
              child: menuItem.imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(
                        deviceinfo.screenWidth * 0.04,
                      ),
                      child: CachedNetworkImage(
                        imageUrl: menuItem.imageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppTheme.backgroundColor,
                          child: const Icon(
                            Icons.restaurant,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppTheme.backgroundColor,
                          child: const Icon(
                            Icons.error,
                            color: AppTheme.errorColor,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          deviceinfo.screenWidth * 0.04,
                        ),
                        color: AppTheme.backgroundColor,
                      ),
                      child: const Icon(
                        Icons.restaurant,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
            ),

            SizedBox(width: deviceinfo.screenWidth * 0.04),

            // Food Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    menuItem.name,
                    style: AppTheme.headline4.copyWith(
                      fontSize: deviceinfo.screenWidth * 0.04,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),

                  SizedBox(height: deviceinfo.screenHeight * 0.005),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: deviceinfo.screenWidth * 0.02,
                      vertical: deviceinfo.screenHeight * 0.005,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        deviceinfo.screenWidth * 0.02,
                      ),
                    ),
                    child: Text(
                      menuItem.category!,
                      style: AppTheme.bodyText2.copyWith(
                        fontSize: deviceinfo.screenWidth * 0.035,
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: deviceinfo.screenHeight * 0.005),
                  Text(
                    menuItem.description!,
                    style: AppTheme.bodyText2.copyWith(
                      fontSize: 12,
                      color: AppTheme.textSecondaryColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  Text(
                    '\$${menuItem.price.toStringAsFixed(2)}',
                    style: AppTheme.headline4.copyWith(
                      fontSize: 16,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: deviceinfo.screenWidth * 0.02),
            IconButton(
              onPressed: () {
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
          ],
        ),
      ),
    );
  }
}
