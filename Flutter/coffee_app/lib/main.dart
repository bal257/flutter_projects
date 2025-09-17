import 'package:flutter/material.dart';

void main() {
  runApp(const CoffeeShopApp());
}

class CoffeeShopApp extends StatelessWidget {
  const CoffeeShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffeeko',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        fontFamily: 'Roboto',
      ),
      home: const CoffeeMenuScreen(),
      debugShowCheckedModeBanner: false, // Hide debug banner
    );
  }
}
class MyStatelessSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  const MyStatelessSearchBar({
    super.key,
    required this.onChanged,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Search...',
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
        onChanged: onChanged,
        onSubmitted: onSubmitted,
      ),
    );
  }
}

class CoffeeMenuScreen extends StatefulWidget {
  const CoffeeMenuScreen({super.key});

  @override
  State<CoffeeMenuScreen> createState() => _CoffeeMenuScreenState();
}

class _CoffeeMenuScreenState extends State<CoffeeMenuScreen> {
  String searchQuery = '';

  static const coffeeItems = [
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
      'description': 'Equal parts espresso, steamed milk, and foam.',
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

  List<Map<String, dynamic>> get filteredItems {
    if (searchQuery.isEmpty) return coffeeItems;
    return coffeeItems
        .where((item) =>
            item['name'].toString().toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Coffeeko',
          style: TextStyle(
            fontFamily: 'Pacifico',
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 35,
            height: 150,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 181, 135, 121),
      ),
      backgroundColor: Colors.brown[50],
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hot and Cold Brew',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A2B1B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.42, //adjust card size
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      for (final item in filteredItems)
                        CoffeeMenuItem(
                          name: item['name'] as String,
                          price: item['price'] as double,
                          description: item['description'] as String,
                          imagePath: item['imagePath'] as String,
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
    );
  }
}

class CoffeeMenuItem extends StatefulWidget {
  final String name;
  final double price;
  final String description;
  final String imagePath;

  const CoffeeMenuItem({
    super.key,
    required this.name,
    required this.price,
    required this.description,
    required this.imagePath,
  });

  @override
  State<CoffeeMenuItem> createState() => _CoffeeMenuItemState();
}

class _CoffeeMenuItemState extends State<CoffeeMenuItem> {
  bool isFavorite = false;
  int orderCount = 0;

  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  void _orderCoffee(BuildContext context) {
    setState(() {
      orderCount++;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You ordered ${widget.name}!'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown.withOpacity(0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    widget.imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.brown[100],
                      child: const Icon(Icons.local_cafe, size: 40, color: Colors.brown),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A2B1B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.brown,
                  ),
                  onPressed: _toggleFavorite,
                  tooltip: isFavorite ? 'Unfavorite' : 'Favorite',
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '₱${widget.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B4226),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              widget.description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
           Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
            ElevatedButton.icon
            (
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A2B1B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              ),
              onPressed: () => _orderCoffee(context),
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Order'),
            ),
    if (orderCount > 0)
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.brown[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'Ordered: $orderCount',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF4A2B1B),
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