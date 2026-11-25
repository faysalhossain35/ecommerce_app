import 'package:ecommerce_app/presentation/pages/brand/providers/brand_provider.dart';
import 'package:ecommerce_app/presentation/pages/category/providers/category_provider.dart';
import 'package:ecommerce_app/presentation/pages/slide/providers/slide_provider.dart';
import 'package:ecommerce_app/presentation/pages/auth/providers/auth_provider.dart';
import 'package:ecommerce_app/presentation/pages/product/providers/product_provider.dart';
import 'package:ecommerce_app/presentation/providers/cart_provider.dart';
import 'package:ecommerce_app/presentation/providers/wishlist_provider.dart';
import 'package:ecommerce_app/presentation/providers/review_provider.dart';
import 'package:ecommerce_app/presentation/providers/order_provider.dart';
import 'package:ecommerce_app/presentation/pages/splash/view/splash_screen.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

class EcommerceApp extends StatefulWidget {
  const EcommerceApp({super.key});

  @override
  State<EcommerceApp> createState() => _EcommerceAppState();
}

class _EcommerceAppState extends State<EcommerceApp> {
  bool _featuresStarted = false;

  Future<void> _loadFeatures(BuildContext context) async {
    final brandProvider = context.read<BrandProvider>();
    final categoryProvider = context.read<CategoryProvider>();
    final slideProvider = context.read<SlideProvider>();
    final productProvider = context.read<ProductProvider>();
    Future<void> safelyLoad(Future<void> Function() operation) async {
      try {
        await operation();
      } catch (_) {}
    }

    await Future.wait([
      safelyLoad(() => brandProvider.fetchBrands()),
      safelyLoad(() => categoryProvider.fetchCategories()),
      safelyLoad(() => slideProvider.fetchSlides()),
      safelyLoad(() => productProvider.fetchProducts()),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BrandProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => SlideProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: Builder(
        builder: (context) {
          if (!_featuresStarted) {
            _featuresStarted = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _loadFeatures(context);
            });
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Ecommerce App',
            theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Poppins'),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
