class WatchModel {
  var watchId,
      escrow,
      ownerId,
      images,
      displayImage,
      brand,
      model,
      serialNumber,
      condition,
      papers,
      box,
      history,
      location,
      offeredBy,
      forSale,
      createdAt,
      price;

  WatchModel(
      {this.watchId,
      this.escrow,
      this.ownerId,
      this.images,
      this.displayImage,
      this.brand,
      this.model,
      this.serialNumber,
      this.condition,
      this.papers,
      this.box,
      this.history,
      this.location,
      this.offeredBy,
      this.forSale,
      this.createdAt,
      this.price});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map["watchId"] = watchId;
    map["ownerId"] = ownerId;
    map["escrow"]=escrow;
    map["brand"] = brand;
    map["model"] = model;
    map["displayImage"] = displayImage;
    map["serialNumber"] = serialNumber;
    map["condition"] = condition;
    map["papers"] = papers;
    map["box"] = box;
    map["location"] = location;
    map["offeredBy"] = offeredBy;
    map["forSale"] = forSale;
    map["createdAt"] = createdAt;
    map["price"] = price;
    return map;
  }

  factory WatchModel.fromMap(var map) {
    return WatchModel(
      watchId: map['watchId'],
      ownerId: map['ownerId'],
      escrow: map["escrow"],
      brand: map['brand'],
      model: map['model'],
      displayImage: map["displayImage"],
      serialNumber: map['serialNumber'],
      condition: map['condition'],
      papers: map['papers'],
      box: map['box'],
      location: map['location'],
      offeredBy: map['offeredBy'],
      forSale: map['forSale'],
      createdAt: map['createdAt'],
      price: map['price'],
    );
  }
}
