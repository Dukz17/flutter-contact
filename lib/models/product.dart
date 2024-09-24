class Product{
  //for product entity
  late String? Code;
  late String? Name;
  late String? Line;
  late String? Scale;
  late String? Vendor;
  late String? Description;
  late int? quantityInStock;
  late double? buyPrice;
  late double? MSRP;

  Product
  (
    {
      required this.Code,
      required this.Name,
      required this.Line,
      required this.Scale,
      required this.Vendor,
      required this.Description,
      required this.quantityInStock,
      required this.buyPrice,
      required this.MSRP,
    }
  );

  Map<String, dynamic> toJson()
  {
    return
    {
      "Code" : Code,
      "Name" : Name,
      "Line" : Line,
      "Scale" : Scale,
      "Vendor" : Vendor,
      "Description" : Description,
      "quantityInStock" : quantityInStock,
      "buyPrice" : buyPrice,
      "MSRP" : MSRP,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json)
  {
    return Product
    (
      Code: json['productCode'],
      Name: json['productName'],
      Line: json['productLine'],
      Scale: json['productScale'],
      Vendor: json['productVendor'],
      Description: json['productDescription'],
      quantityInStock: json['quantityInStock'],
      buyPrice: json['buyPrice'],
      MSRP: json['MSRP'],
    );
  }
}