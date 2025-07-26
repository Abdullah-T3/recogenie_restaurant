// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:recogenie_restaurant/core/di/firebase_module.dart' as _i210;
import 'package:recogenie_restaurant/features/auth/data/repo/auth_repository.dart'
    as _i818;
import 'package:recogenie_restaurant/features/cart/data/repo/cart_repository.dart'
    as _i569;
import 'package:recogenie_restaurant/features/cart/presentation/cubit/cart_cubit.dart'
    as _i570;
import 'package:recogenie_restaurant/features/menu/data/repo/menu_repository.dart'
    as _i668;
import 'package:recogenie_restaurant/features/menu/presentation/cubit/menu_cubit.dart'
    as _i93;
import 'package:recogenie_restaurant/features/auth/presentation/cubit/auth_cubit.dart'
    as _i415;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final firebaseModule = _$FirebaseModule();
    gh.factory<_i569.CartRepository>(() => _i569.CartRepository());
    gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseModule.firebaseAuth);
    gh.lazySingleton<_i974.FirebaseFirestore>(() => firebaseModule.firestore);
    gh.factory<_i668.MenuRepository>(
      () => _i668.MenuRepository(gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i93.MenuCubit>(
      () => _i93.MenuCubit(gh<_i668.MenuRepository>()),
    );
    gh.factory<_i570.CartCubit>(
      () => _i570.CartCubit(gh<_i569.CartRepository>()),
    );
    gh.factory<_i818.AuthRepository>(
      () => _i818.AuthRepository(gh<_i59.FirebaseAuth>()),
    );
    gh.factory<_i415.AuthCubit>(
      () => _i415.AuthCubit(gh<_i818.AuthRepository>()),
    );
    return this;
  }
}

class _$FirebaseModule extends _i210.FirebaseModule {}
