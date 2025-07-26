import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import '../../data/repo/menu_repository.dart';
import '../../data/models/menu_item.dart';

part 'menu_state.dart';

@injectable
class MenuCubit extends Cubit<MenuState> {
  final MenuRepository _menuRepository;

  MenuCubit(this._menuRepository) : super(MenuInitial());

  Future<void> fetchMenuItems() async {
    emit(MenuLoading());
    try {
      final menuItems = await _menuRepository.fetchMenuItems();
      emit(MenuSuccess(menuItems));
    } catch (e) {
      emit(MenuFailure(e.toString()));
    }
  }
}
