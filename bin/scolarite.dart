import 'dart:convert';

import 'package:scolarite/modeles.dart';
import 'package:scolarite/statistiques.dart';
import 'package:scolarite/resultats.dart';

const String jsonString = '''
[
  {
    "matricule": "21A0001",
    "nom": "Awa KONAN",
    "email": "awa@gmail.com",
    "notes": {
      "INF351": 14.5,
      "INF352": 16.0,
      "INF353": 13.0
    }
  },
  {
    "matricule": "21A0002",
    "nom": "Koffi KOUAME",
    "email": null,
    "notes": {
      "INF351": 12.0,
      "INF352": 13.5,
      "INF353": 11.0
    }
  },
  {
    "matricule": "21A0003",
    "nom": "Yao TRAORE",
    "email": "yao@gmail.com",
    "notes": {
      "INF351": 9.0,
      "INF352": 8.0,
      "INF353": 10.0
    }
  }
]
''';

List<Etudiant> chargerEtudiants() {
  final data = jsonDecode(jsonString) as List;

  return data
      .map(
        (e) => Etudiant.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList();
}

Future<List<Etudiant>> chargerPromo() async {
  await Future.delayed(
    const Duration(seconds: 2),
  );

  final promo = chargerEtudiants();

  if (promo.any(
    (e) => e.matricule.startsWith('X'),
  )) {
    throw const FormatException(
      'Un matricule commence par X',
    );
  }

  return promo;
}

Future<UE> chargerUE(String code) async {
  await Future.delayed(
    const Duration(milliseconds: 500),
  );

  return UE(
    code,
    'UE $code',
    1,
  );
}

Stream<String> journal() async* {
  final promo = chargerEtudiants();

  for (final etudiant in promo) {
    await Future.delayed(
      const Duration(seconds: 1),
    );

    yield 'Calcul de la moyenne de ${etudiant.nom}';
  }
}

Future<void> main() async {
  print('==============================');
  print('       TP 2 - SCOLARITE');
  print('==============================');

  print('\n--- ETAPE 1 : ETUDIANTS ---');

  final promo = chargerEtudiants();

  for (final etudiant in promo) {
    print(etudiant);
  }

  print('\n--- ETAPE 2 : STATISTIQUES ---');

  final ues = [
    const UE(
      'INF351',
      'Programmation',
      2,
    ),
    const UE(
      'INF352',
      'Base de données',
      2,
    ),
    const UE(
      'INF353',
      'Réseaux',
      1,
    ),
  ];

  print('\nMoyennes :');

  for (final etudiant in promo) {
    final m = moyenne(etudiant, ues);

    print(
      '${etudiant.nom} : ${m.toStringAsFixed(2)}',
    );
  }

  print('\nClassement :');

  final classementPromo = classement(
    promo,
    ues,
  );

  for (var i = 0; i < classementPromo.length; i++) {
    final etudiant = classementPromo[i];

    final m = moyenne(
      etudiant,
      ues,
    );

    print(
      '${i + 1}. ${etudiant.nom}  ${m.toStringAsFixed(2)}',
    );
  }

  print('\nMoyenne par UE :');

  final moyennesUE = moyenneParUE(promo);

  moyennesUE.forEach(
    (code, moyenne) {
      print(
        '$code : ${moyenne.toStringAsFixed(2)}',
      );
    },
  );

  print('\nExtrêmes :');

  final valeurs = promo
      .map((e) => moyenne(e, ues))
      .toList();

  final ext = extremes(valeurs);

  print(
    'Minimum : ${ext.$1.toStringAsFixed(2)}',
  );

  print(
    'Maximum : ${ext.$2.toStringAsFixed(2)}',
  );

  print('\n--- ETAPE 3 : DELIBERATION ---');

  for (final etudiant in promo) {
    final resultat = deliberer(
      etudiant,
      ues,
    );

    print(
      '${etudiant.nom} : ${message(resultat)}',
    );
  }

  print('\n--- ETAPE 4.1 : CHARGEMENT PROMO ---');

  try {
    final promoChargee = await chargerPromo();

    print(
      '${promoChargee.length} étudiants chargés.',
    );
  } on FormatException catch (e) {
    print('Erreur : $e');
  }

  print('\n--- ETAPE 4.2 : CHARGEMENT DES UE ---');

  final stopwatch = Stopwatch()..start();

  final uesChargees = await Future.wait([
    chargerUE('INF351'),
    chargerUE('INF352'),
    chargerUE('INF353'),
    chargerUE('INF354'),
    chargerUE('INF355'),
  ]);

  stopwatch.stop();

  print(
    '${uesChargees.length} UE chargées.',
  );

  print(
    'Durée : ${stopwatch.elapsedMilliseconds} ms',
  );

  print('\n--- ETAPE 4.3 : JOURNAL ---');

  await for (final messageJournal in journal()) {
    print(messageJournal);
  }

  print('\n==============================');
  print('       FIN DU TP 2');
  print('==============================');
}