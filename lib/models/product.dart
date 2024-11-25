class Products {
  final String id;
  final String name;
  final String categoryId;
  final String price;
  final String qty;
  final String image;
  final String description;
  final String createAT;
  // New field for description

  // Constructor
  Products({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.price,
    required this.qty,
    required this.image,
    required this.description, // Include description in constructor
    required this.createAT, // Include description in constructor
  });

  // Factory constructor to create Product from Firestore document
  factory Products.fromFirestore(
      Map<String, dynamic> firestoreData, String docId) {
    return Products(
      id: docId,
      name: firestoreData['name'] ?? '',
      categoryId: firestoreData['category_id'] ?? '',
      price: firestoreData['price'] ?? '',
      qty: firestoreData['qty'] ?? '',
      image: firestoreData['image'] ?? '',
      description: firestoreData['description'] ?? '', // Extract description
      createAT: firestoreData['createAT'] ?? '', // Extract description
    );
  }
}
