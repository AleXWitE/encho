class Words {
  int id;
  String enWord;
  String enTrans;
  String ruWord;
  String ruTrans;

  Words(this.id, this.enWord, this.enTrans, this.ruWord, this.ruTrans);
}

List<Words> wordList = [
  Words(1, "Hello", "həˈləʊ", "Привет", "пр’ив’`эт"),
  Words(2, "Morning", "ˈmɔːnɪŋ", "Утро", "`утра"),
  Words(3, "Through", "θruː", "Сквозь", "скв`ос’"),
  Words(4, "Air", "eə(r)", "Воздух", "в`оздух"),
  Words(5, "Armageddon", "ˌɑː.məˈɡed.ən", "Великое побоище", "в’ил’`икай’э паб`оищ’э"),
  Words(6, "Train", "treɪn", "Поезд", "п`ой’изт"),
  Words(7, "Afternoon", "ˌɑːftəˈnuːn", "После полудня", "п`осл’э пал`удн’а"),
  Words(8, "Morningstar", "ˈmɔːnɪŋstər", "Утренняя звезда", "`утр’ин’ий’а зв’изда"),
  Words(9, "Summer", "ˈsʌmə(r)", "Лето", "л’`эта"),
  Words(10, "Rain wizard", "reɪn ˈwɪzəd", "Волшебник дождя", "валш`эбн’ик дажд’а"),
];

class Languages {
  int id;
  String lang;

  Languages(this.id, this.lang);
}

List<String> langs = [
  "en",
  "ru",
];

