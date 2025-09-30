class Product {
  final String id;
  final String name;
  final double price; // sale_price
  final double originalPrice; // mrp
  final double rating; // avg_rating
  final String imageUrl; // featured_image
  final bool isFavorite; // in_wishlist
  final bool variationExists;
  final List<String> images;
  final String description;
  final String caption;
  final int stock;
  final bool isActive;
  final String discount;
  final DateTime? createdDate;
  final String productType;
  final String? variationName;
  final int? category;
  final double? taxRate;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.imageUrl,
    this.isFavorite = false,
    this.variationExists = false,
    this.images = const [],
    this.description = '',
    this.caption = '',
    this.stock = 0,
    this.isActive = true,
    this.discount = '0.00',
    this.createdDate,
    this.productType = '',
    this.variationName,
    this.category,
    this.taxRate,
  });

  Product copyWith({
    String? id,
    String? name,
    double? price,
    double? originalPrice,
    double? rating,
    String? imageUrl,
    bool? isFavorite,
    bool? variationExists,
    List<String>? images,
    String? description,
    String? caption,
    int? stock,
    bool? isActive,
    String? discount,
    DateTime? createdDate,
    String? productType,
    String? variationName,
    int? category,
    double? taxRate,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      rating: rating ?? this.rating,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      variationExists: variationExists ?? this.variationExists,
      images: images ?? this.images,
      description: description ?? this.description,
      caption: caption ?? this.caption,
      stock: stock ?? this.stock,
      isActive: isActive ?? this.isActive,
      discount: discount ?? this.discount,
      createdDate: createdDate ?? this.createdDate,
      productType: productType ?? this.productType,
      variationName: variationName ?? this.variationName,
      category: category ?? this.category,
      taxRate: taxRate ?? this.taxRate,
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'],
      price: (json['sale_price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (json['mrp'] as num?)?.toDouble() ?? 0.0,
      rating: (json['avg_rating'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['featured_image'] ?? '',
      isFavorite: json['in_wishlist'] == true || json['in_wishlist'] == 1,
      variationExists:
          json['variation_exists'] == true || json['variation_exists'] == 1,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          ((json['additional_images'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              []),
      description: json['description'] ?? '',
      caption: json['caption'] ?? '',
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] == true || json['is_active'] == 1,
      discount: json['discount']?.toString() ?? '0.00',
      createdDate: json['created_date'] != null
          ? DateTime.tryParse(json['created_date'].toString())
          : null,
      productType: json['product_type']?.toString() ?? '',
      variationName: json['variation_name']?.toString(),
      category: (json['category'] as num?)?.toInt(),
      taxRate: (json['tax_rate'] as num?)?.toDouble(),
    );
  }
}

class BannerModel {
  final String id;
  final String imageUrl;
  final String? link;
  final Map<String, dynamic>? product;
  final Map<String, dynamic>? category;

  BannerModel({
    required this.id,
    required this.imageUrl,
    this.link,
    this.product,
    this.category,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'].toString(),
      imageUrl: json['image'],
      link: null, // No link in API
      product: json['product'],
      category: json['category'],
    );
  }
}
