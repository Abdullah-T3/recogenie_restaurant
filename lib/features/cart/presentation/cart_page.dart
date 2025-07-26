import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/Responsive/UiComponents/InfoWidget.dart';
import '../../../core/Responsive/models/DeviceInfo.dart';
import '../../../core/helper/cherryToast/CherryToastMsgs.dart';
import '../../../core/routing/routs.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/di/injection.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/quantity_selector.dart';
import '../../../core/widgets/price_display.dart';
import '../../../core/widgets/item_card.dart';
import '../data/models/cart_item.dart';
import 'cubit/cart_cubit.dart';
import 'cubit/cart_state.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<CartCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your Cart'),
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppTheme.backgroundColor, AppTheme.surfaceColor],
            ),
          ),
          child: BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              return InfoWidget(
                builder: (context, deviceinfo) => Padding(
                  padding: EdgeInsets.all(deviceinfo.screenWidth * 0.05),
                  child: Column(
                    children: [
                      Expanded(
                        child: state is CartLoaded && state.items.isNotEmpty
                            ? _buildCartItemsList(
                                context,
                                state.items,
                                deviceinfo,
                              )
                            : _buildEmptyCartState(context, deviceinfo),
                      ),

                      if (state is CartLoaded && state.items.isNotEmpty)
                        _buildCartSummary(context, state, deviceinfo),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCartItemsList(
    BuildContext context,
    List<CartItem> items,
    Deviceinfo deviceinfo,
  ) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildCartItemCard(context, item, deviceinfo);
      },
    );
  }

  Widget _buildCartItemCard(
    BuildContext context,
    CartItem item,
    Deviceinfo deviceinfo,
  ) {
    return ItemCard(
      imageUrl: item.imageUrl ?? '',
      font: deviceinfo.screenWidth * 0.037,
      title: item.name,
      price: item.price,
      cacheKey: 'cart_${item.id}',
      imageWidth: deviceinfo.screenWidth * 0.15,
      imageHeight: deviceinfo.screenWidth * 0.15,
      borderRadius: deviceinfo.screenWidth * 0.05,
      margin: EdgeInsets.only(bottom: deviceinfo.screenHeight * 0.02),
      padding: EdgeInsets.all(deviceinfo.screenWidth * 0.04),
      trailing: Column(
        children: [
          QuantitySelector(
            quantity: item.quantity,
            onQuantityChanged: (newQuantity) {
              context.read<CartCubit>().updateQuantity(item.id, newQuantity);
            },
            showTotalPrice: true,
            itemPrice: item.price,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCartState(BuildContext context, Deviceinfo deviceinfo) {
    return EmptyStateWidget(
      icon: Icons.shopping_cart_outlined,
      title: 'Your cart is empty',
      subtitle: 'Add some delicious items to get started',
      iconSize: deviceinfo.screenWidth * 0.3,
      iconColor: AppTheme.primaryColor,
      titleColor: AppTheme.textPrimaryColor,
      actionButton: SizedBox(
        width: double.infinity,
        height: deviceinfo.screenHeight * 0.06,
        child: ElevatedButton.icon(
          onPressed: () => context.go(Routes.menuScreen),
          icon: const Icon(Icons.restaurant_menu),
          label: const Text('Browse Menu'),
          style: AppTheme.primaryButtonStyle,
        ),
      ),
    );
  }

  Widget _buildCartSummary(
    BuildContext context,
    CartLoaded state,
    Deviceinfo deviceinfo,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(deviceinfo.screenWidth * 0.05),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(deviceinfo.screenWidth * 0.05),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor,
            blurRadius: deviceinfo.screenWidth * 0.02,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Items:',
                style: AppTheme.bodyText1.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              Text(
                '${state.items.fold(0, (sum, item) => sum + item.quantity)}',
                style: AppTheme.headline4.copyWith(
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: deviceinfo.screenHeight * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount:',
                style: AppTheme.bodyText1.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              PriceDisplay(
                price: state.totalPrice,
                color: AppTheme.primaryColor,
              ),
            ],
          ),
          SizedBox(height: deviceinfo.screenHeight * 0.02),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: deviceinfo.screenHeight * 0.06,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.read<CartCubit>().clearCart();
                    },
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear Cart'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.errorColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: deviceinfo.screenWidth * 0.02),
              Expanded(
                child: SizedBox(
                  height: deviceinfo.screenHeight * 0.06,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      CherryToastMsgs.CherryToastError(
                        info: deviceinfo,
                        context: context,
                        title: "Checkout Not Available",
                        description: "This feature is not implemented yet.",
                      ).show(context);
                    },
                    icon: const Icon(Icons.payment),
                    label: const Text('Checkout'),
                    style: AppTheme.primaryButtonStyle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
