import 'package:flutter/material.dart';

void main() {
  runApp(const CoffeeShopApp());
}

class CoffeeShopApp extends StatelessWidget 
{
  const CoffeeShopApp({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp(
      title: 'Coffeeko',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        fontFamily: 'Roboto',
      ),
      home: const CoffeeMenuScreen(),
      debugShowCheckedModeBanner: false, 
    );
  }
}
class MyStatelessSearchBar extends StatelessWidget 
{
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  const MyStatelessSearchBar
  ({
    super.key,
    required this.onChanged,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) 
  {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Search...',
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
        ),
        onChanged: onChanged,
        onSubmitted: onSubmitted,
      ),
    );
  }
}

class CoffeeMenuScreen extends StatefulWidget 
{
  const CoffeeMenuScreen({super.key});

  @override
  State<CoffeeMenuScreen> createState() => _CoffeeMenuScreenState();
}

class _CoffeeMenuScreenState extends State<CoffeeMenuScreen> 
{
  String searchQuery = '';
  final List<Map<String, dynamic>> orders = [];
  final Set<String> favorites = {};

  int _selectedIndex = 0;

  static const coffeeItems = 
  [
    {
      'name': 'Espresso',
      'price': 99.00,
      'description': 'A rich and intense shot of pure coffee.',
      'imagePath': 'assets/img/espresso.png',
    },
    {
      'name': 'Mocha',
      'price': 89.00,
      'description': 'Creamy mocha flavor to savor.',
      'imagePath': 'assets/img/mocha.png',
    },
    {
      'name': 'Cappuccino',
      'price': 89.00,
      'description': 'Tasty cappuccino for your liking.',
      'imagePath': 'assets/img/cappuccino.png',
    },
    {
      'name': 'Americano',
      'price': 79.00,
      'description': 'Your classic go-to coffee.',
      'imagePath': 'assets/img/americano.png',
    },
    {
      'name': 'Latte',
      'price': 69.00,
      'description': 'Smooth and creamy coffee on the go.',
      'imagePath': 'assets/img/latte.png',
    },
    {
      'name': 'Frappuccino',
      'price': 79.00,
      'description': 'Creamy, foamy, and yummy cold drink for you.',
      'imagePath': 'assets/img/frappuccino.png',
    },
  ];

  void addOrder(Map<String, dynamic> item, int quantity) {
    setState(() {
      final match = orders.indexWhere((order) => order['name'] == item['name']);
     if (match != -1) {
      orders[match]['quantity'] += quantity;
      } else {
      orders.add({
        ...item,
        'quantity': quantity,
      } );
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You ordered ${item['name']}!')),
    );
  }

  void toggleFavorite(String itemName) {
    setState(() {
      if (favorites.contains(itemName)) {
        favorites.remove(itemName);
      } else {
        favorites.add(itemName);
      }
    });
  }

  // void goToSummary() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => OrderSummaryScreen(orders: orders),
  //     ),
  //   );
  // }
  void goToSummary() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => OrderSummaryScreen(
        orders: orders,
        onCancelOrder: (int index) {
          setState(() {
            orders.removeAt(index);
          });
        },
      ),
    ),
  );
}

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      goToSummary();
    }
  }

  List<Map<String, dynamic>> get filteredItems 
  {
    if (searchQuery.isEmpty) return coffeeItems;
    return coffeeItems
        .where((item) =>
            item['name'].toString().toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
        appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80), 
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.brown,
          ),
          child: AppBar(
            title: const Text(
              'Coffeeko',
              style: TextStyle(
                fontFamily: 'Pacifico',
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontSize: 38,
                height: 150,
              ),
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent, 
            flexibleSpace: null, 
          ),
        ),
      ),
      backgroundColor: Colors.brown[50],
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>
          [
            Container(
              decoration: const BoxDecoration(
                color: Colors.brown,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 16), 
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: MyStatelessSearchBar(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      onSubmitted: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding
            (
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hot and Cold Brew',
                    style: TextStyle(
                      fontSize: 26,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A2B1B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.50, 
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      for (final item in filteredItems)
                        CoffeeMenuItem(
                          name: item['name'] as String,
                          price: item['price'] as double,
                          description: item['description'] as String,
                          imagePath: item['imagePath'] as String,
                          onOrder: () => addOrder(item, 1),
                          onFavorite: () => toggleFavorite(item['name'] as String),
                          isFavorite: favorites.contains(item['name']),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              height: 20,
              thickness: 1,
              indent: 20,
              endIndent: 20,
              color: Colors.brown,
            ),
            const FooterSection(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTapped,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.brown[800],
        unselectedItemColor: Colors.brown[200],
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        iconSize: 30,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.coffee),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
    
        ],
      ),
    );
  }
}

class CoffeeMenuItem extends StatelessWidget 
{
  final String name;
  final double price;
  final String description;
  final String imagePath;
  final VoidCallback onOrder;
  final VoidCallback onFavorite;
  final bool isFavorite;

  const CoffeeMenuItem
  ({
    super.key,
    required this.name,
    required this.price,
    required this.description,
    required this.imagePath,
    required this.onOrder,
    required this.onFavorite,
    required this.isFavorite,
  });

  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: AspectRatio(
                aspectRatio: 2, // 1:1 square
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.brown[100],
                      child: const Icon(Icons.local_cafe,
                          size: 40, color: Colors.brown),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A2B1B),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '\₱${price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B4226),
              ),
            ),
            Flexible( 
            child:Text(
            description,
            style: const TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.normal,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: onFavorite,
                ),
                ElevatedButton(
                  onPressed: onOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    "Order",
                    style: TextStyle(
                      color: Colors.white, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OrderSummaryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> orders;
  final void Function(int) onCancelOrder;

  const OrderSummaryScreen({super.key, required this.orders, required this.onCancelOrder});

  @override
  Widget build(BuildContext context) {
    // Calculate total price of all orders
  final double total = orders.fold(0.0, (sum, order) => sum + (order['price'] as double) * (order['quantity'] ?? 1), );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Summary"),
        titleTextStyle: const TextStyle(
          fontFamily: 'Pacifico',
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          fontSize: 32,
          fontStyle: FontStyle.italic,
          color: Color.fromARGB(255, 218, 210, 181),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.brown
          ),
        ),
      ),
      body: orders.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "No items ordered yet.",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w500,
              ),
               ),
            const SizedBox(height: 12),
            Image.asset(
              'assets/img/coffee.png', 
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
          ],
        ),
      )
        : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Image.asset(order['imagePath']),
                    title: Text('${order['name']} x${order['quantity'] ?? 1}'),
                    // subtitle: Text("₱${order['price'].toStringAsFixed(2)}"),
                    subtitle: Text("₱${(order['price'] * (order['quantity'] ?? 1)).toStringAsFixed(2)}"),
                    trailing: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${order['name']} canceled.')),
                        );
                        onCancelOrder(index);
                        (context as Element);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
           bottomNavigationBar: orders.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              color: Colors.brown[100],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A2B1B),
                    ),
                  ),
                  Text(
                    "₱${total.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6B4226),
                    ),
                  ),
                ],
              ),
          ),
    );
  }
}

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: <Widget>[
          const Text(
            'Find Us at:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A2B1B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Bagong Sikat, Science City of Muñoz\nOpen Mondays-Fridays, 8am-10pm',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.facebook, color: Color(0xFF4A2B1B)),
                onPressed: () {},
                tooltip: 'Facebook',
              ),
              IconButton(
                icon: const Icon(Icons.email, color: Color(0xFF4A2B1B)),
                onPressed: () {},
                tooltip: 'Email',
              ),
              IconButton(
                icon: const Icon(Icons.phone, color: Color(0xFF4A2B1B)),
                onPressed: () {},
                tooltip: 'Phone',
              ),
            ],
          ),
        ],
      ),
    );
  }
}