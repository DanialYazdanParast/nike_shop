import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_shop/common/exceptions.dart';
import 'package:nike_shop/data/banner.dart';
import 'package:nike_shop/data/product.dart';
import 'package:nike_shop/data/repo/banner_repository.dart';
import 'package:nike_shop/data/repo/product_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IBannerRepository bannerRepository;
  final IProductRepository productRepository;
  HomeBloc({required this.bannerRepository, required this.productRepository})
      : super(HomeLodingState()) {
    on<HomeEvent>((event, emit) async {
      if (event is HomeStartedEvent || event is HomeRefreshEvent) {
        try {
          emit(HomeLodingState());
          final banners = await bannerRepository.getAll();
          final latestProduct =
              await productRepository.getAll(ProductSort.latest);
          final popularProduct =
              await productRepository.getAll(ProductSort.popular);
          emit(HomeSuccesState(
              banners: banners,
              latestProduct: latestProduct,
              popularProduct: popularProduct));
        } catch (e) {
          emit(HomeErrorState(
              exception: e is AppException ? e : AppException()));
        }
      }
    });
  }
}
