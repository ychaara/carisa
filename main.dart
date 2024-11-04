//memasukkan package yang di butuhkan oleh aplikasi
import 'package:english_words/english_words.dart';
//paket bahasa inggris
import 'package:flutter/material.dart';
//paket untuk tampilan UI(material UI)
import 'package:provider/provider.dart';
//paket untuk interaksi aplikasi

//fungsi main (fungsi utama)
void main() {
  runApp(MyApp());//memangggil fungsi runApp (yang menjalankan keseluruhan aplikasi di dalam runApp)
}

//membuat abtrak aplikasi dari statelesswidget (template aplikasi), aplikasi bernama MyApp
class MyApp extends StatelessWidget {
  const MyApp({super.key}); //menunjukakan bahawa aplikasi ini akan tetap, tidak berubah setelah di-build

  @override //mengganti nilai lama yang sudah ada di template, dengan niali yang baru (replace / overwrite)
  Widget build(BuildContext context) {
    //fungsi build adalah fungsi yang membangun UI (mengatut posisi widget, dst)
    //changenotifierprovider mendengarkan / mendeteksi semua interaksi yang terjadi di aplikasi
    return ChangeNotifierProvider(
      create: (context) => MyAppState(), //membuat satu state bernama MyAppState
      child: MaterialApp( //pada state ini menggunakan style desain material UI
        title: 'Namer App',//diberi judul Namer App
        theme: ThemeData( // data tema aplikasi diberi warna DeepOrange
          useMaterial3: true, // versi material UI yang di pakai versi 3
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 4, 194, 20)),
        ),
        home: MyHomePage(), //nama halaman "MyHomePage" yang menggunakan state "MyAppState"
      ),
    );
  }
}

// mendefinisikan isi MyAppState
class MyAppState extends ChangeNotifier {
  //state MyAppState di isi dengan 2 kata random yang di gabung. kata random tsb di simpan di variable wordpair
  var current = WordPair.random();
    void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
    var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

      IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BigCard(pair: pair),
            SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,//memposisikan button saya 
              children: [

                // ↓ And this.
                ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite();
                  },
                  icon: Icon(icon),
                  label: Text('Like'),
                ),
                SizedBox(width: 10),

                ElevatedButton(
                  onPressed: () {
                    appState.getNext();
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

 
 

    @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); //menambahkan tema pada card
    //membuat style untuk teks,diberi nama style.stle warna mengikuti parrent
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      //
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),

        // ↓ Make the following change.
        child: Text(
          //mengubah kata dalam pair menjadi huruf kecil
          pair.asLowerCase,
          style: style,//menerapkan style dengan nama style yang sudah dibuat ke dalam text
          //memberi label pada masing masing kata,supaya text terbaca dengan benar oleh aplikasi
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}