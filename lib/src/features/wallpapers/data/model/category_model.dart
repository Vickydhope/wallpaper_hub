class CategoryModel {
  final String title;
  final String image;

  CategoryModel({required this.title, required this.image});

  static List<CategoryModel> categories() => [
        CategoryModel(
          title: "Street Art",
          image:
              "https://images.pexels.com/photos/1122335/pexels-photo-1122335.jpeg?auto=compress&cs=tinysrgb&w=120&h=60&dpr=2",
        ),
        CategoryModel(
            title: "Wildlife",
            image:
                "https://images.pexels.com/photos/625727/pexels-photo-625727.jpeg?auto=compress&cs=tinysrgb&w=800"),
        CategoryModel(
            title: "Animals",
            image:
                "https://images.pexels.com/photos/3635178/pexels-photo-3635178.jpeg?auto=compress&cs=tinysrgb&w=800"),
        CategoryModel(
            title: "Nature",
            image:
                "https://images.pexels.com/photos/15286/pexels-photo.jpg?auto=compress&cs=tinysrgb&w=800"),
        CategoryModel(
            title: "Cars",
            image:
                "https://images.pexels.com/photos/831475/pexels-photo-831475.jpeg?auto=compress&cs=tinysrgb&w=800"),
        CategoryModel(
            title: "Bikes",
            image:
                "https://images.pexels.com/photos/104842/bmw-vehicle-ride-bike-104842.jpeg?auto=compress&cs=tinysrgb&w=800"),
        CategoryModel(
            title: "Games",
            image:
                "https://images.pexels.com/photos/682933/pexels-photo-682933.jpeg?auto=compress&cs=tinysrgb&w=800"),
        CategoryModel(
            title: "Sci-Fi",
            image:
                "https://images.pexels.com/photos/2007647/pexels-photo-2007647.jpeg?auto=compress&cs=tinysrgb&w=800"),
        CategoryModel(
            title: "Sports",
            image:
                "https://images.pexels.com/photos/257970/pexels-photo-257970.jpeg?auto=compress&cs=tinysrgb&w=800"),
        CategoryModel(
            title: "Art",
            image:
                "https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?auto=compress&cs=tinysrgb&w=800"),
        CategoryModel(
            title: "Dark",
            image:
                "https://images.pexels.com/photos/1406722/pexels-photo-1406722.jpeg?auto=compress&cs=tinysrgb&w=800")
      ];
}
