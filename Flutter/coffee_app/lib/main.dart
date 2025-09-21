import 'package:flutter/material.dart';

void main() 
{
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
    return Card
    (
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: TextField
      (
        decoration: const InputDecoration
        (
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
  List<Map<String, dynamic>> favorites = [];

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

  void addOrder(Map<String, dynamic> item, int quantity) 
  {
    setState(() 
    {
      final match = orders.indexWhere((order) => order['name'] == item['name']);
      if (match != -1) 
      {
        final currentQty =
        ((orders[match]['quantity'] ?? 1) as num).toInt();
        orders[match]['quantity'] = currentQty + quantity;
      } 
      else 
      {
        orders.add
        ({
          ...item,
          'quantity': quantity,
        });
      }
    });
    ScaffoldMessenger.of(context).showSnackBar
    (
      SnackBar(content: Text('You ordered ${item['name']}!')),
    );
  }

  void toggleFavorite(Map<String, dynamic> item) 
  {
    setState(() 
    {
      final existingFav = favorites.indexWhere((fav) => fav['name'] == item['name']);
      if (existingFav >= 0) 
      {
        favorites.removeAt(existingFav);
        ScaffoldMessenger.of(context).showSnackBar
        (
          SnackBar(content: Text('${item['name']} removed from favorites.')),
        );
      } 
      else 
      {
        favorites.add(item);
        ScaffoldMessenger.of(context).showSnackBar
        (
          SnackBar(content: Text('${item['name']} added to favorites!')),
        );
      }
    });
  }

void goToFavorites() 
{
  Navigator.push
  (
    context,
    MaterialPageRoute
    (
      builder: (context) => Favorites(favorites: favorites),
    ),
  );
}

// Navigate to summary and refresh parent after returning
void goToSummary() async 
{
    await Navigator.push
    (
      context,
      MaterialPageRoute
      (
        builder: (context) => OrderSummaryScreen(
          orders: orders,
        ),
      ),
    );
    setState(() {});
  }

void _onNavBarTapped(int index) 
{
    setState(() 
    {
      _selectedIndex = index;
    });

    if (index == 1) 
    {
      goToSummary();
    }
    else if (index == 2) 
    {
      goToFavorites();
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
    appBar: PreferredSize
    (
      preferredSize: const Size.fromHeight(80),
      child: Container
      (
        decoration: const BoxDecoration
        (
          color: Colors.brown,
        ),
          child: AppBar
          (
            title: Row
            (
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
            children: 
            [
              Image.asset
              (
                'assets/img/cofeekologo.png', 
                height: 80,
                width: 80,
              ),
              const SizedBox(width: 3),
              const Text
              (
                'Coffeeko',
                style: TextStyle
                (
                  fontFamily: 'Pacifico',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  fontSize: 38,
                  height: 150,
                ),
              ),
            ],
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: null,
          ),
        ),
      ),
      backgroundColor: Colors.brown[50],
      body: SingleChildScrollView
      (
        child: Column
        (
          children: <Widget>[
            Container
            (
              decoration: const BoxDecoration
              (
                color: Colors.brown,
              ),
              child: Column
              (
                children: 
                [
                  const SizedBox(height: 16),
                  Padding
                  (
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: MyStatelessSearchBar
                    (
                      onChanged: (value) 
                      {
                        setState(() 
                        {
                          searchQuery = value;
                        });
                      },
                      onSubmitted: (value) 
                      {
                        setState(() 
                        {
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
              child: Column
              (
                crossAxisAlignment: CrossAxisAlignment.start,
                children: 
                [
                  const Text
                  (
                    'Hot and Cold Brew',
                    style: TextStyle
                    (
                      fontSize: 26,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A2B1B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count
                  (
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.50,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: 
                    [
                      for (final item in filteredItems)
                        CoffeeMenuItem
                        (
                          name: item['name'],
                          price: item['price'],
                          description: item['description'],
                          imagePath: item['imagePath'],
                          onOrder: () => addOrder(item, 1),
                          onFavorite: () => toggleFavorite(item),  
                          isFavorite: favorites.any((fav) => fav['name'] == item['name']),
                          onTap: () async 
                          {
                            final result = await Navigator.push
                            (
                              context,
                              MaterialPageRoute
                              (
                                builder: (context) => CoffeeDetailsPage
                                (
                                  name: item['name'],
                                  price: item['price'],
                                  description: item['description'],
                                  imagePath: item['imagePath'],
                                ),
                              ),
                            );
                            if (result != null && result is Map<String, dynamic>) 
                            {
                              addOrder(result, result['quantity'] ?? 1);
                            }
                      },
                  ),
                  ],
                  ),
                ],
              ),
            ),
            const Divider
            (
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
      bottomNavigationBar: BottomNavigationBar
      (
        currentIndex: _selectedIndex,
        onTap: _onNavBarTapped,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.brown[800],
        unselectedItemColor: Colors.brown[200],
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        iconSize: 30,
        items: const 
        [
          BottomNavigationBarItem
          (
            icon: Icon(Icons.coffee),
            label: 'Menu',
          ),
          BottomNavigationBarItem
          (
            icon: Icon(Icons.shopping_cart),
            label: 'Orders',
          ),
          BottomNavigationBarItem
          (
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
  final VoidCallback? onTap;

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
    this.onTap,
  });

  Widget build(BuildContext context) 
  {
      return InkWell
      (
        onTap: onTap, // Make the whole card clickable
        borderRadius: BorderRadius.circular(12.0),
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>
            [
              Expanded
              (
                child: AspectRatio
                (
                  aspectRatio: 2, // 1:1 square
                  child: ClipRRect
                  (
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset
                    (
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container
                      (
                        color: Colors.brown[100],
                        child: const Icon(Icons.local_cafe, size: 40, color: Colors.brown),
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Text
            (
              name,
              style: const TextStyle
              (
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A2B1B),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text
            (
              '\₱${price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B4226),
              ),
            ),
            Flexible
            (
              child: Text
              (
                description,
                style: const TextStyle
                (
                  fontSize: 13,
                  fontStyle: FontStyle.normal,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 6),
            Row
            (
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: 
              [
                IconButton
                (
                  icon: Icon
                  (
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red ,
                  ),
                  onPressed: onFavorite,
                ),
                ElevatedButton
                (
                  onPressed: onOrder,
                  style: ElevatedButton.styleFrom
                  (
                    backgroundColor: Colors.brown,
                    shape: RoundedRectangleBorder
                    (
                      borderRadius: BorderRadius.circular(8)
                    ),
                  ),
                      child: const Text
                      (
                        "Order",
                        style: TextStyle
                        (
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
      ),
    );
  }
}

class OrderSummaryScreen extends StatefulWidget 
{
  final List<Map<String, dynamic>> orders;

  const OrderSummaryScreen({super.key, required this.orders});

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> 
{
  double get total => widget.orders.fold
  (
    0.0,
    (sum, order) => sum + (order['price'] as double) * (((order['quantity'] ?? 1) as num).toDouble()),
  );

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text("Order Summary"),
        titleTextStyle: const TextStyle
        (
          fontFamily: 'Pacifico',
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          fontSize: 32,
          fontStyle: FontStyle.italic,
          color: Color.fromARGB(255, 218, 210, 181),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container
        (
          decoration: const BoxDecoration
          (
            color: Colors.brown),
        ),
      ),
      body: widget.orders.isEmpty
          ? Center
          (
              child: Column
              (
                mainAxisAlignment: MainAxisAlignment.center,
                children: 
                [
                  const Text
                  (
                    "No items ordered yet.",
                    style: TextStyle
                    (
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Image.asset
                  (
                    'assets/img/coffee.png',
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            )
          : ListView.builder
            (
              itemCount: widget.orders.length,
              itemBuilder: (context, index) 
              {
                final order = widget.orders[index];
                final qty = ((order['quantity'] ?? 1) as num).toInt();
                final name = order['name'] as String;
                final price = (order['price'] as double);

                return Card
                (
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 3,
                  shape: RoundedRectangleBorder
                  (
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile
                  (
                    leading: Image.asset(order['imagePath']),
                    title: Text('$name x$qty'),
                    subtitle: Text("₱${(price * qty).toStringAsFixed(2)}"),
                    trailing: ElevatedButton
                    (
                      onPressed: () 
                      {
                        final capturedName = name;
                        setState(() 
                        {
                          if (index < 0 || index >= widget.orders.length) return;
                          // final currentQty =
                          //     ((widget.orders[index]['quantity'] ?? 1) as num).toInt();
                          // if (currentQty > 1) {
                          //   widget.orders[index]['quantity'] = currentQty - 1;
                          // } else {
                          //   widget.orders.removeAt(index);
                          widget.orders.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar
                        (
                          SnackBar(content: Text('$capturedName canceled.')),
                        );
                     },
                      style: ElevatedButton.styleFrom
                      (
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder
                        (
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      child: const Text
                      (
                        "Cancel",
                        style: TextStyle
                        (
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          bottomNavigationBar: widget.orders.isEmpty
          ? null
          : Container
            (
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              color: Colors.brown[100],
              child: Row
              (
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: 
                [
                  const Text
                  (
                    "Total:",
                    style: TextStyle
                    (
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A2B1B),
                    ),
                  ),
                  Text
                  (
                    "₱${total.toStringAsFixed(2)}",
                    style: const TextStyle
                    (
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

class Favorites extends StatefulWidget 
{
  final List<Map<String, dynamic>> favorites;

  const Favorites({super.key, required this.favorites});

  @override
  State<Favorites> createState() => _Favorites();
}

class _Favorites extends State<Favorites> 
{
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text("Favorites"),
        titleTextStyle: const TextStyle
        (
          fontFamily: 'Pacifico',
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          fontSize: 32,
          fontStyle: FontStyle.italic,
          color: Color.fromARGB(255, 218, 210, 181),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container
        (
          decoration: const BoxDecoration
          (
            color: Colors.brown
          ),
        ),
      ),
      body: widget.favorites.isEmpty
        ? Center
        (
          child: SizedBox
          (
            width: 250,
            height: 250,
            child: Stack
            (
              alignment: Alignment.center,
              children: 
              [
                Opacity
                (
                  opacity: 0.15,
                  child: Image.asset
                  (
                    'assets/img/cofeekologo.png',
                    width: 220,
                    height: 220,
                    fit: BoxFit.contain,
                  ),
                ),
              const Text
              (
                "No favorites yet.",
                style: TextStyle
                (
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      )      
      : ListView.builder
        (
          itemCount: widget.favorites.length,
          itemBuilder: (context, index) 
          {
            final coffee = widget.favorites[index];
            return Card
            (
              margin: const EdgeInsets.all(8),
              child: ListTile
              (
                leading: Image.asset(coffee['imagePath']),
                title: Text(coffee['name']),
                subtitle: Text("₱${coffee['price']}"),
              ),
            ); 
          },
        ),
      );
    }   
}


class FooterSection extends StatelessWidget 
{
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return SizedBox
    (
      height: 180,
      child: Stack
      (
        alignment: Alignment.center,
        children: 
        [
          Opacity
          (
            opacity: 0.10, 
            child: Image.asset
            (
              'assets/img/cofeekologo.png',
              width: 220,
              height: 120,
              fit: BoxFit.contain,
            ),
          ),
          Padding
          (
            padding: const EdgeInsets.all(24.0),
            child: Column
            (
              children: <Widget>
              [
                const Text
                (
                  'Find Us at:',
                  style: TextStyle
                  (
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A2B1B),
                  ),
                ),
                const SizedBox(height: 8),
                const Text
                (
                  'Bagong Sikat, Science City of Muñoz\nOpen Mondays-Fridays, 8am-10pm',
                  textAlign: TextAlign.center,
                  style: TextStyle
                  (
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 3),
                Row
                (
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>
                  [
                    IconButton
                    (
                      icon: const Icon(Icons.facebook, color: Color(0xFF4A2B1B)),
                      onPressed: () {},
                      tooltip: 'Facebook',
                    ),
                    IconButton
                    (
                      icon: const Icon(Icons.email, color: Color(0xFF4A2B1B)),
                      onPressed: () {},
                      tooltip: 'Email',
                    ),
                    IconButton
                    (
                      icon: const Icon(Icons.phone, color: Color(0xFF4A2B1B)),
                      onPressed: () {},
                      tooltip: 'Phone',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CoffeeDetailsPage extends StatefulWidget 
{
  final String name;
  final double price;
  final String description;
  final String imagePath;

  const CoffeeDetailsPage
  ({
    super.key,
    required this.name,
    required this.price,
    required this.description,
    required this.imagePath,
  });

 @override
  State<CoffeeDetailsPage> createState() => _CoffeeDetailsPageState();
}

class _CoffeeDetailsPageState extends State<CoffeeDetailsPage> 
{
  String selectedSize = 'Medium';
  String selectedMilk = 'Whole Milk';
  bool extraShot = false;
  int quantity = 1;

  double get totalPrice 
  {
    double base = widget.price;
    if (selectedSize == 'Small') base -= 10;
    if (selectedSize == 'Large') base += 15;
    if (extraShot) base += 20;
    return base * quantity;
  }
 @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: Text(widget.name),
        backgroundColor: Colors.brown,
      ),
      body: Padding
      (
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView
        (
          child: Column
          (
            children: 
            [
              SizedBox
              (
                height: 750, 
                child: Card(
                  elevation: 5,
                  shape: const RoundedRectangleBorder
                  (
                    borderRadius: BorderRadius.only
                    (
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  color: Colors.brown[50],
                    child: Padding
                    (
                      padding: const EdgeInsets.all(18.0),
                      child: Column
                      (
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: 
                        [
                          Row
                          (
                            children: 
                            [
                              ClipRRect
                              (
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset
                                (
                                  widget.imagePath,
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 16),
                                Expanded
                                (
                                  child: Column
                                  (
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: 
                                    [
                                      Text
                                      (
                                        widget.name,
                                        style: const TextStyle
                                        (
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF4A2B1B),
                                        ),
                                      ),
                                      Text
                                      (
                                        '₱${widget.price.toStringAsFixed(2)}',
                                        style: const TextStyle
                                        (
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF6B4226),
                                        ),
                                      ),
                                      Text
                                      (
                                        widget.description,
                                        style: const TextStyle
                                        (
                                          fontSize: 15,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 28, thickness: 1, color: Colors.brown),
                            Align
                            (
                              alignment: Alignment.centerLeft,
                              child: Text(
                              "Customize your ${widget.name}!",
                              style: TextStyle
                              (
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown[800],
                              ),
                            ),
                            ),
                            const SizedBox(height: 16),
                            // Size
                            Column
                            (
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: 
                              [
                                const Text
                                (
                                  "Size:",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                                ),
                                const SizedBox(height: 8),
                                Row
                                (
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: 
                                  [
                                    for (final size in ['Small', 'Medium', 'Large'])
                                      Padding
                                      (
                                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                        child: ChoiceChip
                                        (
                                          label: Text(size),
                                          selected: selectedSize == size,
                                          selectedColor: Colors.brown[300],
                                          onSelected: (selected) 
                                          {
                                            if (selected) 
                                            {
                                              setState(() 
                                              {
                                                selectedSize = size;
                                              });
                                            }
                                          },
                                          labelStyle: TextStyle
                                          (
                                            fontSize: 16,
                                            color: selectedSize == size ? Colors.white : Colors.brown[800],
                                            fontWeight: FontWeight.bold,
                                          ),
                                          backgroundColor: Colors.brown[100],
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                                      // Milk
                                      Row
                                      (
                                        children: 
                                        [
                                          const Text("Milk: ", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                                          DropdownButton<String>
                                          (
                                            value: selectedMilk,
                                            style: const TextStyle(fontSize: 20, color: Colors.black87),
                                            underline: Container
                                            (
                                              height: 1.5,
                                              color: Colors.brown,
                                            ),
                                            items: const 
                                            [
                                              DropdownMenuItem(value: 'Whole Milk', child: Text('Whole Milk',)),
                                              DropdownMenuItem(value: 'Skim Milk', child: Text('Skim Milk')),
                                              DropdownMenuItem(value: 'Soy Milk', child: Text('Soy Milk')),
                                              DropdownMenuItem(value: 'Oat Milk', child: Text('Oat Milk')),
                                            ],
                                            onChanged: (value) 
                                            {
                                              setState(() 
                                              {
                                                selectedMilk = value!;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 3),
                                      // Extra shot
                                      Row
                                      (
                                        children: 
                                        [
                                          Checkbox
                                          (
                                            value: extraShot,
                                            onChanged: (value) 
                                            {
                                              setState(() 
                                              {
                                                extraShot = value ?? false;
                                              });
                                            },
                                          ),
                                          const Text("Add extra shot (+₱20)"
                                          , style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      const SizedBox(height: 40),
                                      // Quantity
                                      Row
                                      (
                                        children: 
                                        [
                                          const Text
                                          (
                                            "Quantity: ",
                                            style: TextStyle
                                            (
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25,
                                            ),
                                          ),
                                          IconButton
                                          (
                                            icon: const Icon(Icons.remove),
                                            iconSize: 20,
                                            onPressed: quantity > 1
                                                ? () => setState(() => quantity--)
                                                : null,
                                          ),
                                          Text('$quantity',
                                          style: const TextStyle
                                          (
                                            fontSize: 23, fontWeight: FontWeight.bold)),
                                            IconButton
                                            (
                                              icon: const Icon(Icons.add),
                                              iconSize: 20,
                                              onPressed: () => setState(() => quantity++),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 40),
                                        // Total price
                                        Text
                                        (
                                          'Total: ₱${totalPrice.toStringAsFixed(2)}',
                                          style: const TextStyle
                                          (
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                        // --- Spacer to push button to the bottom ---
                                        const Spacer(),
                                        Center
                                        (
                                          child: SizedBox
                                          (
                                            width: double.infinity,
                                            child: ElevatedButton
                                            (
                                              onPressed: () 
                                              {
                                                Navigator.pop(context, 
                                                {
                                                  'name': widget.name,
                                                  'price': totalPrice,
                                                  'description':
                                                  '${widget.description}\nSize: $selectedSize\nMilk: $selectedMilk${extraShot ? '\n+ Extra Shot' : ''}',
                                                  'imagePath': widget.imagePath,
                                                  'quantity': quantity,
                                                });
                                                ScaffoldMessenger.of(context).showSnackBar
                                                (
                                                  SnackBar(content: Text('Added to order!')),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom
                                              (
                                                backgroundColor: Colors.brown,
                                                shape: RoundedRectangleBorder
                                                (
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                padding: const EdgeInsets.symmetric
                                                (
                                                    horizontal: 32, vertical: 18), // taller button
                                              ),
                                              child: const Text
                                              (
                                                "Add to Order",
                                                style: TextStyle
                                                (
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                ),
                              ],

                            ),
                          ),
                        ),
                      );
                    }
                  }