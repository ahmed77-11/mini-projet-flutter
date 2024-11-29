import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:complete_flutter_app/Utils/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController calController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  // New controllers for ingredients
  final List<TextEditingController> ingredientNameControllers = [TextEditingController()];
  final List<TextEditingController> ingredientAmountControllers = [TextEditingController()];
  final List<TextEditingController> ingredientImageControllers = [TextEditingController()];

  final CollectionReference recipesCollection =
  FirebaseFirestore.instance.collection("Complete-Flutter-App");

  void _addIngredientField() {
    setState(() {
      ingredientNameControllers.add(TextEditingController());
      ingredientAmountControllers.add(TextEditingController());
      ingredientImageControllers.add(TextEditingController());
    });
  }

  void _removeIngredientField(int index) {
    setState(() {
      ingredientNameControllers.removeAt(index);
      ingredientAmountControllers.removeAt(index);
      ingredientImageControllers.removeAt(index);
    });
  }

  void _showAddRecipeDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add New Recipe'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Recipe Name',
                    hintText: 'Enter recipe name',
                  ),
                ),
                TextField(
                  controller: timeController,
                  decoration: const InputDecoration(
                    labelText: 'Time (minutes)',
                    hintText: 'Enter cooking time',
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: calController,
                  decoration: const InputDecoration(
                    labelText: 'Calories',
                    hintText: 'Enter calories',
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: imageController,
                  decoration: const InputDecoration(
                    labelText: 'Image URL',
                    hintText: 'Enter image URL',
                  ),
                ),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    hintText: 'Enter recipe category',
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Ingredients',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...List.generate(
                    ingredientNameControllers.length,
                        (index) => Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: ingredientNameControllers[index],
                            decoration: const InputDecoration(
                              labelText: 'Ingredient Name',
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: ingredientAmountControllers[index],
                            decoration: const InputDecoration(
                              labelText: 'Amount',
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: ingredientImageControllers[index],
                            decoration: const InputDecoration(
                              labelText: 'Ingredient Image',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: ingredientNameControllers.length > 1
                              ? () => setState(() => _removeIngredientField(index))
                              : null,
                        ),
                      ],
                    )
                ),
                ElevatedButton(
                  onPressed: _addIngredientField,
                  child: const Text('Add Ingredient'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addRecipe();
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _addRecipe() {
    // Collect ingredients data
    List<String> ingredientsName = ingredientNameControllers
        .map((controller) => controller.text)
        .toList();
    List<String> ingredientsAmount = ingredientAmountControllers
        .map((controller) => controller.text)
        .toList();
    List<String> ingredientsImage = ingredientImageControllers
        .map((controller) => controller.text)
        .toList();

    recipesCollection.add({
      'name': nameController.text,
      'time': int.parse(timeController.text),
      'cal': int.parse(calController.text),
      'image': imageController.text,
      'category': categoryController.text,
      'ingredientsName': ingredientsName,
      'ingredientsAmount': ingredientsAmount,
      'ingredientsImage': ingredientsImage,
    });

    // Clear all controllers
    nameController.clear();
    timeController.clear();
    calController.clear();
    imageController.clear();
    categoryController.clear();

    // Clear and reset ingredient controllers
    ingredientNameControllers.forEach((controller) => controller.clear());
    ingredientAmountControllers.forEach((controller) => controller.clear());
    ingredientImageControllers.forEach((controller) => controller.clear());

    // Reset to single ingredient field
    while (ingredientNameControllers.length > 1) {
      ingredientNameControllers.removeLast();
      ingredientAmountControllers.removeLast();
      ingredientImageControllers.removeLast();
    }
  }

  void _showModifyRecipeDialog(DocumentSnapshot recipe) {
    // Pre-fill controllers with existing recipe data
    nameController.text = recipe['name'];
    timeController.text = recipe['time'].toString();
    calController.text = recipe['cal'].toString();
    imageController.text = recipe['image'];
    categoryController.text = recipe['category'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modify Recipe'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Recipe Name',
                  hintText: 'Enter recipe name',
                ),
              ),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(
                  labelText: 'Time (minutes)',
                  hintText: 'Enter cooking time',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: calController,
                decoration: const InputDecoration(
                  labelText: 'Calories',
                  hintText: 'Enter calories',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: imageController,
                decoration: const InputDecoration(
                  labelText: 'Image URL',
                  hintText: 'Enter image URL',
                ),
              ),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  hintText: 'Enter recipe category',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Update the existing recipe
              recipesCollection.doc(recipe.id).update({
                'name': nameController.text,
                'time': int.parse(timeController.text),
                'cal': int.parse(calController.text),
                'image': imageController.text,
                'category': categoryController.text,
              });
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }


  void _deleteRecipe(String docId) {
    recipesCollection.doc(docId).delete();
  }


  @override
  void dispose() {
    nameController.dispose();
    timeController.dispose();
    calController.dispose();
    imageController.dispose();
    categoryController.dispose();

    // Dispose ingredient controllers
    for (var controller in ingredientNameControllers) {
      controller.dispose();
    }
    for (var controller in ingredientAmountControllers) {
      controller.dispose();
    }
    for (var controller in ingredientImageControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        backgroundColor: kbackgroundColor,
        centerTitle: true,
        title: const Text(
          "Recipe Management",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kprimaryColor,
        onPressed: _showAddRecipeDialog,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: recipesCollection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No recipes found"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot recipe = snapshot.data!.docs[index];
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 100,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(recipe['image']),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  recipe['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Icon(
                                      Iconsax.flash_1,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      "${recipe['cal']} Cal",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const Text(
                                      " · ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const Icon(
                                      Iconsax.clock,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      "${recipe['time']} Min",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "Category: ${recipe['category']}",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 25,
                    right: 75,
                    child: GestureDetector(
                      onTap: () => _showModifyRecipeDialog(recipe),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.blue,
                        size: 25,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 25,
                    right: 35,
                    child: GestureDetector(
                      onTap: () => _deleteRecipe(recipe.id),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 25,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}