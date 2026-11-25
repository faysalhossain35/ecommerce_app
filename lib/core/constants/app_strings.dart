/// All string constants: app name, API endpoints, tokens and static copy.
class AppStrings {
  AppStrings._();

  // --- App ---
  static const String appName = 'CraftyBay';
  static const String appVersion = 'Version 1.0';

  // --- Network ---
  static const String authorizationToken = '';
  static const String networkTimeoutError =
      'The request timed out. Please try again.';
  static const String networkNoInternetError =
      'No internet connection. Please check your connection.';
  static const String networkUnexpectedError =
      'An unexpected network error occurred.';
  static const String networkServerError = 'Server error:';

  // --- Login ---
  static const String welcomeBack = 'Welcome Back';
  static const String enterEmailPrompt = 'Please Enter Your Email Address';
  static const String emailAddress = 'Email Address';
  static const String password = 'Password';
  static const String passwordRequired = 'Please enter your password';
  static const String passwordTooShort =
      'Password must be at least 6 characters';
  static const String next = 'Next';
  static const String emailRequired = 'Please enter your email';
  static const String emailInvalid = 'Please enter a valid email';

  // --- OTP ---
  static const String enterOtpCode = 'Enter OTP Code';
  static const String otpSentMessage = 'A 4 Digit OTP Code has been Sent';
  static const String otpIncomplete = 'Please enter the 4 digit code';
  static const String codeExpiresIn = 'This code will expire in ';
  static const String resendCode = 'Resend Code';

  // --- Complete profile ---
  static const String completeProfile = 'Complete Profile';
  static const String completeProfileSubtitle =
      'Get started with us with your details';
  static const String firstName = 'First Name';
  static const String lastName = 'Last Name';
  static const String mobile = 'Mobile';
  static const String city = 'City';
  static const String shippingAddress = 'Shipping Address';
  static const String complete = 'Complete';
  static const String fieldRequired = 'This field is required';

  // --- Create review ---
  static const String createReview = 'Create Review';
  static const String reviews = 'Reviews';
  static const String addReview = 'Add review';
  static const String writeReview = 'Write Review';
  static const String submit = 'Submit';

  // --- Cart ---
  static const String cart = 'Cart';
  static const String totalPrice = 'Total Price';
  static const String checkout = 'Checkout';
  static const String cartEmpty = 'Your cart is empty';
  static const String removeFromCart = 'Remove from cart';
  static const String decreaseQuantity = 'Decrease quantity';
  static const String increaseQuantity = 'Increase quantity';
  static const String checkoutUnavailable = 'Checkout is not set up yet.';

  // --- Product details ---
  static const String productDetails = 'Product Details';
  static const String productColor = 'Color';
  static const String productSize = 'Size';
  static const String productDescription = 'Description';
  static const String price = 'Price';
  static const String addToCart = 'Add To Cart';
  static const String addToCartUnavailable = 'Add to cart is not set up yet.';
  static const String addedToCart = 'Added to cart';

  // --- Common copy ---
  static const String search = 'Search';
  static const String seeAll = 'See All';
  static const String allCategories = 'All Categories';
  static const String popular = 'Popular';
  static const String brands = 'Brands';
  static const String special = 'Special';
  static const String newArrival = 'New';

  // --- Home ---
  static const String bannerTitle = 'Happy New Year\nSpecial Deal\nSave 30%';
  static const String buyNow = 'Buy Now';
  static const String wishList = 'Wish List';
  static const String wishListEmpty = 'Your wish list is empty';
  static const String categories = 'Categories';
}
