class UserModel {
    var id,image, name, email, dob, house, street, town, province, zip, country,about,businessDetails,type,createdAt,rating,idVerification;

    UserModel(
        {this.id,
            this.image,
            this.name,
            this.email,
            this.dob,
            this.house,
            this.street,
            this.town,
            this.province,
            this.zip,
            this.country,
            this.about,
            this.businessDetails,
            this.type,
            this.createdAt,this.rating,this.idVerification});

    Map<String, dynamic> toMap() {
        Map<String, dynamic> map = <String, dynamic>{};
        map['id'] = id;
        map['image']=image;
        map['Name'] = name;
        map['Email'] = email;
        map['DOB'] = dob;
        map['House_name_number'] = house;
        map['Street'] = street;
        map['Town'] = town;
        map['Province'] = province;
        map['Zip'] = zip;
        map['Country'] = country;
        map['About'] = about;
        map['Business details'] = businessDetails;
        map['Type'] = type;
        map['Created at']=createdAt;
        map['Rating']=rating;
        map['Verified']=idVerification;
        return map;
    }

    factory UserModel.fromMap(var map) {
        return UserModel(
            id: map['id'],
            image: map['image'],
            name: map['Name'],
            email: map['Email'],
            dob: map['DOB'],
            house: map['House_name_number'],
            street: map['Street'],
            town: map['Town'],
            province: map['Province'],
            type: map['Type'],
            zip: map['Zip'],
            country: map['Country'],
            about: map['About'],
            businessDetails: map['Business details'],
            createdAt: map['Created at'],
            rating: map['Rating'],
            idVerification: map['Verified'],
        );
    }
}