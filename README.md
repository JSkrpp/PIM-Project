# PIM Project  
  
## Projektowanie Interfejsów Webowych - Projekt  

## Autorzy:
  - Jakub Skorupa 272546
  - Konrad Kuleta 272293
  - Mikołaj Lipiński 273024

## Temat zadania projektowego  

Zadanie projektowe polega na zaprojektowaniu i implementacji aplikacji mobilnej. Zakres projektu obejmuje diagramy projektowe, interfejs uzytkownika oraz połączenia z backendem . Aplikacją przez nas realizowowaną jest aplikacja typu "calorie tracker", pozwalająca użytkownikowi śledzenie dziennego spożycia kalorii na podstawie produktów spożywaczych, które zostały przez niego utworzone.

## Mockupy i diagramy projektowe

### Mockupy

![alt text](https://github.com/JSkrpp/PIM-Project/blob/main/Mobilki%20Mocki.jpg)


### Diagramy projektowe

![alt text](https://github.com/JSkrpp/PIM-Project/blob/main/PIM-C4.png)

W finalnej wersji aplikacji, system nie został podłaczony do Google Drive, ponieważ nie było takiej potrzeby w kontekscie zaimplementowanej funkcjonalności. GD mógłby zostać wykorzystany do np. tworzenie i przechowywania codziennych raportów, lecz nie wchodziło to w zakres naszej aplikacji. 

## Zaimplementowane funkcjonalności i serwisy

### 

### Interfejs użytkownika   

Moduł interfejsu użytkownika składa się z plików .dart zawierających implementacje widżetów aplikacji. Każdy ekran, z którego użytkownik może skorzystać jest przechowywany w osobym pliku. Korzeń interjesu (root) inicjalizowany jest w pliku main jako Scaffold, który potem odpowiada za logikę nawigacji pomiędzy poszczególnymi widokami. 

### Serwisy stanu sesji

Zostały zaimpelementowane dwa serwisy: autoryzacji i bazy danych. Pierwszy odpowiada za zarządzanie stanem zalogowania przez użytkownika apliakcji i komunikacją z plikiem main, który na jego podstawie udostępnie odpowiednie funkcjonalności użytkownikowi. Serwis bazy danych odpowiada za komunikację z Firestore, przesyła wszystkie zmiany wykonywane przez użytkowników do bazy NoSQL, gdzie są przechowywane dane, a także pozwala na uzyskiwanie dancyh do aplikacji.

### Konteksty aplikacji

W kontekstach przechowywane są stany o informacjach aplikacji, na które użytkownik może bezpośrednio wpływać, takie jak dzienny postęp, lista produktów i konfiguracja apliakcji. Kontekty udostępniają istotne wartości zmiennych do korzenia aplikacji, który przesyła je do odpowiednich widoków.
