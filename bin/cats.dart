import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

List<String> favoriteFacts = [];
String currentLanguage = 'ru';

Map<String, Map<String, String>> translations = {
  'ru': {
    'Cat Fact': 'Факт о кошке',
    'Saved': 'Сохранить',
    'Next': 'Следующий',
    'List': 'Список',
    'Clear': 'Очистить',
    'Exit': 'Выход',
    'Select action': 'Выберите действие',
    'Empty': 'Список пуст',
    'Welcome': 'Добро пожаловать в факты о кошках!',
    'Change language': 'Сменить язык',
    'Show': 'Показать',
    'Choose language': 'Выберите язык',
    'Unknown': 'Неизвестная команда. Попробуйте снова.',
    'Fact': 'Факт',
  },
  'en': {
    'Cat Fact': 'Cat Fact',
    'Saved': 'Save',
    'Next': 'Next',
    'List': 'List',
    'Clear': 'Clear',
    'Exit': 'Exit',
    'Select action': 'Select action',
    'Empty': 'List is empty',
    'Welcome': 'Welcome to Cat Facts!',
    'Change language': 'Change language',
    'Show': 'Show',
    'Choose language': 'Choose a language',
    'Unknown': 'Unknown command. Try again.',
    'Fact': 'Fact',
  },
  'es': {
    'Cat Fact': 'Dato de gato',
    'Saved': 'Guardar',
    'Next': 'Siguiente',
    'List': 'Lista',
    'Clear': 'Limpiar',
    'Exit': 'Salir',
    'Select action': 'Selecciona una acción',
    'Empty': 'La lista está vacía',
    'Welcome': '¡Bienvenido a los datos sobre gatos!',
    'Change language': 'Cambiar idioma',
    'Show': 'Mostrar',
    'Choose language': 'Elige un idioma',
    'Unknown': 'Comando desconocido. Inténtalo de nuevo.',
    'Fact': 'Hecho',
  },
  'fr': {
    'Cat Fact': 'Fait sur le chat',
    'Saved': 'Sauvegarder',
    'Next': 'Suivant',
    'List': 'Liste',
    'Clear': 'Effacer',
    'Exit': 'Quitter',
    'Select action': 'Sélectionnez une action',
    'Empty': 'La liste est vide',
    'Welcome': 'Bienvenue dans les faits sur les chats !',
    'Change language': 'Changer de langue',
    'Show': 'Afficher',
    'Choose language': 'Choisissez une langue',
    'Unknown': 'Commande inconnue. Veuillez réessayer.',
    'Fact': 'Fait',
  },
  'ko': {
    'Cat Fact': '고양이 사실',
    'Saved': '저장',
    'Next': '다음',
    'List': '목록',
    'Clear': '지우기',
    'Exit': '종료',
    'Select action': '작업 선택',
    'Empty': '목록이 비어 있습니다',
    'Welcome': '고양이 사실에 오신 것을 환영합니다!',
    'Change language': '언어 변경',
    'Show': '보기',
    'Choose language': '언어 선택',
    'Unknown': '알 수 없는 명령어입니다. 다시 시도하세요.',
    'Fact': '사실',
  },
};

void main() async {
  chooseLanguage();
  print('🐱 ${_translate("Welcome")}');

  while (true) {
    String fact = await fetchCatFact();
    print('\n📢 ${_translate("Cat Fact")}: $fact\n');

    print('🔘 ${_translate("Select action")} :');
    print('1. ✅ ${_translate("Saved")} + ${_translate("Next")} ${_translate("Fact")}');
    print('2. 🔁 ${_translate("Next")} ${_translate("Fact")}');
    print('3. 📃 ${_translate("Show")} ${_translate("List")}');
    print('4. 🧹 ${_translate("Clear")} ${_translate("List")}');
    print('5. 🌍 ${_translate("Change language")}');
    print('6. ❌ ${_translate("Exit")}');

    String? choice = stdin.readLineSync();

    if (choice == '1') {
      favoriteFacts.add(fact);
    } else if (choice == '2') {
      continue;
    } else if (choice == '3') {
      if (favoriteFacts.isEmpty) {
        print('\n📭 ${_translate("Empty")}');
      } else {
        print('\n📚 ${_translate("List")}:');
        for (int i = 0; i < favoriteFacts.length; i++) {
          print('${i + 1}. ${favoriteFacts[i]}');
        }
      }
    } else if (choice == '4') {
      favoriteFacts.clear();
      print('\n✅ ${_translate("Clear")} ${_translate("List")}!');
    } else if (choice == '5') {
      chooseLanguage();
    } else if (choice == '6') {
      print('\n👋 ${_translate("Exit")}...');
      break;
    } else {
      print('❗ ${_translate("Unknown")}');
    }
  }
}

void chooseLanguage() {
  print('\n🌍 ${_translate("Choose language")}:');
  print('1. Русский');
  print('2. English');
  print('3. Español');
  print('4. Français');
  print('5. 한국어');

  String? langChoice = stdin.readLineSync();

  switch (langChoice) {
    case '1':
      currentLanguage = 'ru';
      break;
    case '2':
      currentLanguage = 'en';
      break;
    case '3':
      currentLanguage = 'es';
      break;
    case '4':
      currentLanguage = 'fr';
      break;
    case '5':
      currentLanguage = 'ko';
      break;
    default:
      print('❗ ${_translate("Unknown")}');
      currentLanguage = 'en';
  }

  print('✅ ${_translate("Change language")}: $currentLanguage');
}

Future<String> fetchCatFact() async {
  final url = Uri.parse('https://catfact.ninja/fact');
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['fact'] ?? 'Факт не найден';
    } else {
      return 'Факт не найден';
    }
  } catch (_) {
    return 'Факт не найден';
  }
}

String _translate(String text) {
  return translations[currentLanguage]?[text] ?? text;
}