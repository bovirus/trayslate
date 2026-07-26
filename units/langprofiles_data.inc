  //-----------------------------------------------------------------------------------
  //  Trayslate © 2026 by Alexander Tverskoy
  //  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
  //  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
  //-----------------------------------------------------------------------------------
  //  langprofiles_data.inc
  //  Built-in language profiles (30 languages) for uLangDetect.
  //  Expanded to 100 trigrams/n-grams each for balanced precision.
  // ============================================================================

procedure InitDefaultProfiles;
const
  // ----- English (100 trigrams) -----
  EN: array[0..99] of string = (
    'the', 'and', 'ing', 'ion', 'ent', 'tio', 'for', 'tha', 'thi', 'hat',
    'his', 'you', 'wit', 'are', 'not', 'ter', 'was', 'all', 'eth', 'hes',
    'her', 'ate', 'ver', 'ere', 'out', 'ati', 'oth', 'res', 'pro', 'con',
    'art', 'eco', 'whi', 'ove', 'per', 'ave', 'eac', 'fro', 'hav', 'int',
    'man', 'one', 'can', 'we ', 'rea', 'she', ' a ', ' i ', 'it ', 'to ',
    'of ', 'in ', 'he ', 'on ', 'as ', 'be ', 'at ', 'or ', 'by ', 'an ',
    'my ', 'do ', 'so ', 'up ', 'if ', 'go ', 'no ', 'us ', 'me ', 'am ',
    'is ', 'how', 'who', 'wha', 'whe', 'why', 'any', 'som', 'now', 'too',
    'see', 'our', 'day', 'may', 'has', 'him', 'two', 'way', 'new', 'use',
    'own', 'did', 'say', 'boy', 'old', 'get', 'put', 'let', 'had', 'its');

  // ----- Russian (100 trigrams) -----
  RU: array[0..99] of string = (
    'ого', 'его', 'ств', 'ние', 'енн', 'ост', 'вал', 'про', 'как', 'что',
    'ать', 'ити', 'был', 'это', 'тог', 'кот', 'тор', 'все', 'так', 'при',
    'нас', 'они', 'мне', 'нам', 'вас', 'вам', 'под', 'над', 'из ', 'от ',
    'за ', 'до ', 'по ', 'об ', 'со ', 'ли ', 'же ', 'бы ', 'да ', 'не ',
    'ни ', 'ну ', 'он ', 'ты ', 'вы ', 'мы ', 'я ', 'а ', 'и ', 'в ',
    'с ', 'к ', 'у ', 'о ', 'но ', 'тут', 'там', 'где', 'кто', 'чей',
    'раз', 'два', 'три', 'год', 'день', 'час', 'чел', 'век', 'лет', 'мож',
    'быт', 'сказа', 'дел', 'себ', 'теб', 'сво', 'мой', 'твой', 'наш', 'ваш',
    'их ', 'ему', 'ней', 'ним', 'ому', 'ами', 'ими', 'ями', 'ыми', 'ых ',
    'ях ', 'ах ', 'ой ', 'ий ', 'ый ', 'ая ', 'яя ', 'ее ', 'ию ', 'ую ');

  // ----- German (100 trigrams) -----
  DE: array[0..99] of string = (
    'der', 'die', 'und', 'ein', 'sch', 'ich', 'che', 'den', 'ten', 'ung',
    'das', 'ist', 'zu ', 'in ', 'mit', 'auf', 'von', 'für', 'sich', 'des',
    'dem', 'nicht', 'als', 'daß', 'dass', 'sie', 'er ', 'es ', 'wir', 'ihr',
    'aus', 'bei', 'an ', 'am ', 'um ', 'im ', 'so ', 'wie', 'nur', 'oder',
    'aber', 'noch', 'nach', 'vor', 'zum', 'zur', 'über', 'unter', 'war', 'wird',
    'wurde', 'sein', 'haben', 'hat', 'mich', 'mir', 'dich', 'dir', 'uns', 'euch',
    'ihnen', 'einige', 'viele', 'alle', 'jede', 'dies', 'diese', 'jen', 'welch', 'kann',
    'muss', 'soll', 'darf', 'will', 'mag', 'mehr', 'sehr', 'oft', 'nie', 'immer',
    'heute', 'morgen', 'gestern', 'hier', 'dort', 'dann', 'wann', 'warum', 'weil', 'ä',
    'ö', 'ü', 'ß', 'eit', 'keit', 'lich', 'isch', 'haft', 'bar', 'sst');

  // ----- French (100 trigrams) -----
  FR: array[0..89] of string = (
    'ent', 'les', 'des', 'que', 'ion', 'tio', 'ans', 'our', 'men', 'dan',
    'par', 'est', 'une', 'qui', 'sur', 'pou', 'pas', 'vou', 'nou', 'ont',
    'le ', 'la ', 'de ', 'du ', 'un ', 'et ', 'à ', 'en ', 'au ', 'aux',
    'ce ', 'ces', 'cet', 'son', 'sa ', 'ses', 'mon', 'ma ', 'mes', 'ton',
    'ta ', 'tes', 'not', 'vot', 'leu', 'je ', 'tu ', 'il ', 'ell', 'on ',
    'ils', 'me ', 'te ', 'se ', 'lui', 'y ', 'quo', 'don', 'où ', 'mai',
    'ou ', 'car', 'ni ', 'com', 'sou', 'ver', 'ave', 'san', 'fai', 'dir',
    'all', 'é', 'è', 'ê', 'à', 'â', 'ç', 'ù', 'û', 'î',
    'ô', 'eux', 'eau', 'çai', 'êtr', 'ien', 'eur', 'ais', 'ait', 'ant');

  // ----- Spanish (100 trigrams) -----
  ES: array[0..89] of string = (
    'que', 'los', 'las', 'del', 'por', 'con', 'ción', 'dad', 'aba', 'ía ',
    'el ', 'la ', 'un ', 'una', 'uno', 'de ', 'a ', 'al ', 'en ', 'sin',
    'par', 'sobr', 'ent', 'hast', 'haci', 'y ', 'o ', 'u ', 'ni ', 'per',
    'aun', 'porq', 'com', 'si ', 'yo ', 'tú ', 'él ', 'ell', 'nos', 'vos',
    'me ', 'te ', 'se ', 'lo ', 'le ', 'les', 'mi ', 'tu ', 'su ', 'nue',
    'vue', 'sus', 'est', 'es ', 'son', 'era', 'fue', 'ser', 'hab', 'tie',
    'hac', 'dec', 'pod', 'ir ', 'ver', 'dar', 'sab', 'pas', 'cre', 'más',
    'muy', 'muc', 'poc', 'tod', 'nad', 'alg', 'bie', 'mal', 'hoy', 'á',
    'é', 'í', 'ó', 'ú', 'ñ', 'ü', '¿', '¡', 'mente', 'ado');

  // ----- Italian (100 trigrams) -----
  IT: array[0..99] of string = (
    'che', 'chi', 'gli', 'zio', 'zza', 'gge', 'cci', 'sci', 'one', 'tto',
    'il ', 'lo ', 'la ', 'i ', 'le ', 'un ', 'uno', 'una', 'di ', 'a ',
    'da ', 'in ', 'con', 'su ', 'per', 'tra', 'fra', 'e ', 'o ', 'ma ',
    'se ', 'poic', 'fin', 'io ', 'tu ', 'lui', 'lei', 'noi', 'voi', 'lor',
    'mi ', 'ti ', 'si ', 'ci ', 'vi ', 'li ', 'ne ', 'mio', 'tuo', 'suo',
    'nos', 'vos', 'que', 'ess', 'son', 'è ', 'era', 'sta', 'ave', 'ha ',
    'han', 'far', 'dir', 'pot', 'vol', 'sap', 'dov', 'ved', 'and', 'ven',
    'dar', 'par', 'tro', 'più', 'mol', 'poc', 'tut', 'nes', 'alc', 'ben',
    'mal', 'ogg', 'ier', 'à', 'è', 'é', 'ì', 'ò', 'ù', 'zion',
    'ment', 'anch', 'dell', 'all', 'ato', 'non', 'del', 'sul', 'nel', 'col');

  // ----- Portuguese (100 trigrams) -----
  PT: array[0..99] of string = (
    'que', 'ção', 'ões', 'dos', 'das', 'com', 'não', 'são', 'mém', 'lhe',
    'o ', 'a ', 'os ', 'as ', 'um ', 'uma', 'de ', 'do ', 'da ', 'em ',
    'no ', 'na ', 'nos', 'nas', 'por', 'pel', 'par', 'sem', 'sob', 'ent',
    'até', 'e ', 'ou ', 'mas', 'se ', 'eu ', 'tu ', 'ele', 'ela', 'nós',
    'vós', 'me ', 'te ', 'nos', 'vos', 'meu', 'teu', 'seu', 'est', 'é ',
    'era', 'foi', 'ser', 'ter', 'tem', 'têm', 'hav', 'faz', 'diz', 'pod',
    'ir ', 'ver', 'dar', 'sab', 'mai', 'mui', 'pou', 'tod', 'nad', 'alg',
    'bem', 'mal', 'hoj', 'ont', 'ã', 'õ', 'ç', 'á', 'é', 'í',
    'ó', 'ú', 'ê', 'ô', 'ado', 'ida', 'nte', 'men', 'pre', 'ist',
    'ara', 'nto', 'res', 'des', 'era', 'uma', 'os ', ' de', 'con', 'uma');

  // ----- Dutch (100 trigrams) -----
  NL: array[0..99] of string = (
    'een', 'het', 'van', 'sch', 'ij ', 'lijk', 'heid', 'zijn', 'voor', 'dat',
    'de ', 'en ', 'in ', 'op ', 'te ', 'met', 'voo', 'aan', 'uit', 'bij',
    'tot', 'doo', 'om ', 'ove', 'ond', 'naa', 'ach', 'ik ', 'jij', 'hij',
    'zij', 'wij', 'jul', 'mij', 'jou', 'hem', 'haa', 'ons', 'hun', 'mijn',
    'haar', 'jull', 'dit', 'dez', 'die', 'wie', 'wat', 'wel', 'is ', 'was',
    'heb', 'heef', 'had', 'wor', 'wer', 'kun', 'kan', 'moe', 'zull', 'zal',
    'wil', 'mag', 'doen', 'doe', 'gaan', 'gaa', 'zien', 'zie', 'krij', 'zeg',
    'kom', 'mak', 'mee', 'vee', 'wei', 'all', 'nie', 'iem', 'goe', 'sle',
    'vaa', 'soms', 'ee', 'aa', 'oo', 'uu', 'ie', 'oe', 'eu', 'ui',
    'ei', 'ij', 'cht', 'aar', 'eer', 'uur', 'tie', 'ren', 'sen', 'den');

  // ----- Polish (100 trigrams) -----
  PL: array[0..99] of string = (
    'nie', 'prz', 'sz', 'cz', 'rz', 'dz', 'ch', 'się', 'ów', 'wsp',
    'w ', 'z ', 'na ', 'do ', 'dla', 'o ', 'za ', 'po ', 'od ', 'prze',
    'pod', 'nad', 'obok', 'mied', 'i ', 'a ', 'ale', 'lub', 'czy', 'że ',
    'jes', 'jak', 'bo ', 'gdy', 'ja ', 'ty ', 'on ', 'ona', 'ono', 'my ',
    'wy ', 'oni', 'one', 'mnie', 'tob', 'jemu', 'jej', 'nam', 'wam', 'im ',
    'mój', 'twó', 'jeg', 'nas', 'was', 'ich', 'ten', 'ta ', 'to ', 'ci ',
    'te ', 'kto', 'co ', 'któ', 'być', 'są ', 'był', 'będ', 'mie', 'ma ',
    'maj', 'mia', 'móc', 'moż', 'mus', 'chc', 'rob', 'bar', 'duż', 'mał',
    'wsz', 'nic', 'coś', 'dob', 'źle', 'dzi', 'jut', 'ą', 'ć', 'ę',
    'ł', 'ń', 'ó', 'ś', 'ź', 'ż', 'ych', 'ego', 'wsp', 'wst');

  // ----- Ukrainian (100 trigrams) -----
  UK: array[0..99] of string = (
    'ого', 'ння', 'сті', 'про', 'що ', 'як ', 'та ', 'на ', 'до ', 'від',
    'іст', 'ати', 'іти', 'був', 'це ', 'тог', 'яки', 'тор', 'все', 'так',
    'при', 'нас', 'вон', 'мен', 'нам', 'вас', 'вам', 'під', 'над', 'із ',
    'за ', 'по ', 'об ', 'зі ', 'чи ', 'же ', 'би ', 'да ', 'не ', 'ні ',
    'ну ', 'він', 'ти ', 'ви ', 'ми ', 'я ', 'а ', 'і ', 'в ', 'з ',
    'к ', 'у ', 'о ', 'але', 'тут', 'там', 'де ', 'хто', 'чий', 'раз',
    'два', 'три', 'рік', 'ден', 'час', 'люд', 'вік', 'рок', 'мож', 'бут',
    'сказ', 'спра', 'себ', 'теб', 'сво', 'мій', 'тві', 'наш', 'ваш', 'їх ',
    'йом', 'ній', 'ним', 'ому', 'ами', 'ими', 'ями', 'їх ', 'их ', 'ях ',
    'ах ', 'ій ', 'ий ', 'ая ', 'яя ', 'є ', 'ї ', 'іче', 'ают', 'єст');

  // ----- Swedish (100 trigrams) -----
  SV: array[0..99] of string = (
    'och', 'att', 'det', 'som', 'en ', 'är ', 'för', 'till', 'med', 'den',
    'kan', 'har', 'inte', 'på ', 'av ', 'om ', 'ett', 'vi ', 'de ', 'från',
    'jag', 'du ', 'han', 'hon', 'ni ', 'mig', 'dig', 'hän', 'oss', 'er ',
    'dem', 'min', 'din', 'hen', 'vår', 'der', 'des', 'vil', 'vad', 'hur',
    'när', 'var', 'vem', 'bli', 'ska', 'kom', 'gör', 'ta ', 'få ', 'se ',
    'ge ', 'gå ', 'säg', 'vet', 'tror', 'tyck', 'finn', 'lig', 'stå', 'sit',
    'myc', 'lit', 'all', 'ing', 'nåy', 'mång', 'bra', 'dål', 'ida', 'igå',
    'ä', 'ö', 'å', 'ss', 'll', 'kk', 'tt', 'nn', 'mm', 'gg',
    'ch', 'ck', 'sch', 'sj', 'tj', 'kj', 'stj', 'skj', 'oo', 'ee',
    'aa', 'uu', 'yy', 'ää', 'öö', 'åå', 'ng', 'nk', 'sk', 'ar ');

  // ----- Danish (120 trigrams) -----
  DA: array[0..109] of string = (
    'og ', 'det', 'til', 'at ', 'en ', 'for', 'af ', 'der', 'med', 'som',
    'kan', 'har', 'ikke', 'på ', 'om ', 'et ', 'vi ', 'de ', 'fra', 'jeg',
    'du ', 'han', 'hun', 'den', 'i ', 'mig', 'dig', 'ham', 'hen', 'os ',
    'jer', 'dem', 'min', 'din', 'vor', 'hvor', 'hvad', 'når', 'vil ', 'skal',
    'gør', 'gøre', 'blev', 'bliv', 'blive', 'vær', 'stå', 'sid', 'kom', 'få ',
    'se ', 'gå ', 'sig', 'ved', 'tro', 'syn', 'lig', 'igt', 'hed', 'els',
    'ende', 'erne', 'ere ', 'est ', 'tion', 'else', 'lige', 'mege', 'meget', 'også',
    'efte', 'efter', 'ford', 'fordi', 'unde', 'inde', 'blæ', 'læs', 'æse', 'sæt',
    'ætt', 'tte', 'vej', 'ejr', 'jre', 'him', 'iml', 'mle', 'len', 'tag',
    'age', 'ger', 'ege', 'get', 'etr', 'træ', 'mås', 'åsk', 'ske', 'dag',
    'god', 'man', 'alt', 'nog', 'fin', 'liv', 'lig ', 'hed ', 'æ ', 'ø '
    );

  // ----- Norwegian Bokmål (120 trigrams) -----
  NO: array[0..109] of string = (
    'mell', 'mmel', 'skal', 'sett', 'ette', 'hver', 'tur ', 'igje', 'ikke', 'blir',
    'og ', 'det', 'til', 'er ', 'som', 'en ', 'på ', 'for', 'av ', 'med',
    'kan', 'har', 'ikke', 'om ', 'et ', 'vi ', 'de ', 'fra', 'jeg', 'du ',
    'han', 'hun', 'den', 'dere', 'meg', 'deg', 'ham', 'hen', 'oss', 'dem',
    'min', 'din', 'vår', 'der', 'hvor', 'hva ', 'når', 'vil ', 'blir', 'ble ',
    'være', 'vært', 'skal', 'kom', 'gjør', 'gjøre', 'få ', 'se ', 'gå ', 'si ',
    'vet', 'tror', 'syn', 'fin', 'lig', 'stå', 'sitt', 'mye', 'lite', 'alt',
    'ing', 'noen', 'mange', 'god', 'dag', 'idag', 'også', 'ette', 'etter', 'ford',
    'fordi', 'unde', 'inne', 'hete', 'heten', 'else', 'ning', 'ende', 'eren', 'ige ',
    'lig ', 'ere ', 'est ', 'rer ', 'ske ', 'gjø', 'meg ', 'deg ', 'bli', 'vær',
    'æ ', 'ø ', 'å ', 'oss ', 'dere', 'mye', 'lite', 'ette', 'ning', 'heter'
    );

  // ----- Finnish (100 trigrams) -----
  FI: array[0..99] of string = (
    'sta', 'aan', 'lla', 'ksi', 'ssa', 'tta', 'den', 'tai', 'hän', 'ett',
    'kun', 'ja ', 'on ', 'oli', 'sek', 'mut', 'vai', 'jos', 'vaik', 'kos',
    'nin', 'min', 'sin', 'se ', 'me ', 'te ', 'he ', 'sen', 'mei', 'tei',
    'hei', 'täm', 'tuo', 'näm', 'nuo', 'ne ', 'kuk', 'mik', 'jok', 'oll',
    'ole', 'tul', 'tek', 'saa', 'ant', 'nä', 'men', 'san', 'tie', 'usk',
    'luu', 'löy', 'maka', 'sei', 'ist', 'pal', 'väh', 'kai', 'ei ', 'mon',
    'hyv', 'huo', 'tän', 'eil', 'ä', 'ö', 'aa', 'ee', 'ii', 'oo',
    'uu', 'yy', 'ää', 'öö', 'ss', 'll', 'kk', 'tt', 'nn', 'is',
    'ta', 'an ', 'st', 'pp', 'mm', 'rr', 'va', 'ma', 'sa', 'la',
    'ka', 'ha', 'na', 'ra', 'pa', 'si', 'mi', 'ti', 'ni', 'li');

  // ----- Hungarian (100 trigrams) -----
  HU: array[0..99] of string = (
    'hog', 'nem', 'egy', 'meg', 'azt', 'sze', 'tek', 'nek', 'ben', 'val',
    'ban', 'es ', 'ha ', 'vagy', 'de ', 'is ', 'mint', 'még', 'hogy', 'mert',
    'én ', 'te ', 'ő ', 'mi ', 'ti ', 'ők ', 'eng', 'tég', 'őt ', 'min',
    'tit', 'őke', 'eny', 'tie', 'övé', 'mie', 'ez ', 'az ', 'eze', 'azo',
    'ki ', 'ami', 'len', 'van', 'vol', 'les', 'tud', 'fog', 'aka', 'kell',
    'leh', 'csi', 'tes', 'ad ', 'kap', 'lát', 'mon', 'gon', 'his', 'tal',
    'fek', 'áll', 'ül ', 'sok', 'kev', 'sem', 'jók', 'ros', 'ma ', 'teg',
    'á', 'é', 'í', 'ó', 'ö', 'ő', 'ú', 'ü', 'ű', 'sz',
    'cs', 'zs', 'gy', 'ny', 'ly', 'ty', 'a ', 'e ', 'o ', 'ba',
    'be', 'ra', 're', 'la', 'le', 'ka', 'ke', 'ta', 'na', 'ne');

  // ----- Romanian (100 trigrams) -----
  RO: array[0..99] of string = (
    ' de', ' in', ' la', ' si', ' cu', ' pe', ' un', 'din', 'mai', 'sau',
    'est', 'și ', 'în ', 'la ', 'cu ', 'pe ', 'un ', 'o ', 'dar', 'că ',
    'dacă', 'eu ', 'tu ', 'el ', 'ea ', 'noi', 'voi', 'ei ', 'ele', 'mă ',
    'te ', 'îl ', 'ne ', 'vă ', 'îi ', 'le ', 'meu', 'tău', 'său', 'nos',
    'vos', 'lor', 'ace', 'cin', 'ce ', 'car', 'fi ', 'era', 'a f', 'ave',
    'are', 'fac', 'put', 'vre', 'tre', 'ști', 'ved', 'mer', 'da ', 'zic',
    'gân', 'cre', 'găs', 'mul', 'puț', 'tot', 'nim', 'cev', 'bun', 'rău',
    'azi', 'ier', 'ă', 'â', 'î', 'ș', 'ț', 'ul ', 're ', 'at ',
    'ți ', 'ea ', 'ii ', 'ții', 'rea', 'ate', 'ste', 'ere', 'ire', 'eșt',
    ' de ', 'lor', 'a ', 'e ', 'i ', 'o ', 'u ', 'ci', 'ge', 'gi');

  // ----- Czech (100 trigrams) -----
  CS: array[0..99] of string = (
    'pro', 'pre', 'jak', 'tak', 'kdy', 'kte', 'byl', 'jse', 'nez', 'co ',
    'kvi', 'a ', 'i ', 'nebo', 'ale', 'že ', 'zda', 'když', 'já ', 'ty ',
    'on ', 'ona', 'ono', 'my ', 'vy ', 'oni', 'ony', 'mě ', 'tě ', 'ho ',
    'ji ', 'to ', 'nás', 'vás', 'je ', 'můj', 'tvů', 'jeh', 'jej', 'náš',
    'váš', 'ten', 'ta ', 'tí ', 'ty ', 'kdo', 'být', 'bud', 'mít', 'má ',
    'měl', 'můž', 'mus', 'cht', 'děl', 'dát', 'dos', 'vid', 'jít', 'řík',
    'věd', 'mys', 'naj', 'lež', 'stá', 'sed', 'moc', 'mál', 'vše', 'nic',
    'něc', 'dob', 'špa', 'dne', 'vče', 'á', 'é', 'í', 'ó', 'ú',
    'ý', 'č', 'ď', 'ě', 'ň', 'ř', 'š', 'ť', 'ž', 'ů',
    'en ', 'st', 'ní', ' je', ' po', ' pr', ' se', ' na', ' do', ' za');

  // ----- Bulgarian (100 trigrams) -----
  BG: array[0..99] of string = (
    'на ', 'за ', 'от ', 'да ', 'се ', 'ще ', 'че ', 'по ', 'кат', 'същ',
    'тов', 'и ', 'а ', 'но ', 'или', 'ако', 'защ', 'аз ', 'ти ', 'той',
    'тя ', 'то ', 'ние', 'вие', 'те ', 'мен', 'теб', 'го ', 'я ', 'нас',
    'вас', 'ги ', 'мой', 'тво', 'нег', 'ней', 'наш', 'ваш', 'тех', 'тоз',
    'таз', 'тез', 'кой', 'как', 'кащ', 'съм', 'е ', 'бе ', 'има', 'мог',
    'тря', 'иск', 'пра', 'дам', 'пол', 'вид', 'ойд', 'каз', 'зна', 'мис',
    'нам', 'леж', 'сто', 'сед', 'мно', 'мал', 'вси', 'нищ', 'нещ', 'доб',
    'лош', 'дне', 'вче', 'ат ', 'та ', 'те ', 'ст ', 'ка ', 'не ', 'ра ',
    'ва ', 'ти ', 'ко ', 'ма ', 'ре ', 'ли ', 'ри ', 'ла ', 'си ', 'ми ',
    'ни ', 'ки ', 'чи ', 'зи ', 'ци ', 'пи ', 'ви ', 'фи ', 'ги ', 'хи ');

  // ----- Turkish (120 trigrams) -----
  TR: array[0..119] of string = (
    'bir', 've ', 'ici', 'ler', 'lar', 'da ', 'de ', 'den', 'dan', 'ile',
    'ama', 'vey', 'ki ', 'gibi', 'içi', 'içi', 'ben', 'sen', 'biz', 'siz',
    'onu', 'bu ', 'şu ', 'bun', 'şun', 'kim', 'ne ', 'han', 'nas', 'var',
    'yok', 'olm', 'yap', 'gel', 'git', 'gör', 'al ', 'ver', 'bil', 'bul',
    'dur', 'kal', 'gir', 'çık', 'baş', 'bit', 'çok', 'hep', 'hiç', 'iyi',
    'köt', 'bug', 'dün', 'mak', 'mek', 'yor', 'iyo', 'aca', 'ece', 'yor',
    'mış', 'miş', 'muş', 'müş', 'dır', 'dir', 'dur', 'dür', 'dı ', 'di ',
    'du ', 'dü ', 'tı ', 'ti ', 'tu ', 'tü ', 'lik', 'lık', 'luk', 'lük',
    'siz', 'sız', 'suz', 'süz', 'nin', 'nın', 'nun', 'nün', 'ın ', 'in ',
    'un ', 'ün ', 'ıp ', 'ip ', 'up ', 'üp ', 'maz', 'mez', 'ken', 'her',
    'ise', 'hem', 'olan', 'olar', 'içi', 'içi', 'içi', 'çin', 'ara', 'son',
    'kad', 'gel', 'git', 'gör', 'şek', 'üze', 'üzer', 'ile', 'dan', 'den'
    );

  // ----- Arabic (120 trigrams) -----
  AR: array[0..98] of string = (
    'في ', 'من ', 'على', 'إلى', 'أن ', 'الت', 'هذه', 'ذلك', 'الذ', 'وال',
    'الل', 'لل ', 'عن ', 'كان', 'ليس', 'لقد', 'كما', 'عند', 'بعد', 'قبل',
    'قال', 'ذهب', 'جاء', 'وجد', 'أخذ', 'أعط', 'عرف', 'رأى', 'فكر', 'جلس',
    'قام', 'نام', 'كتب', 'قرأ', 'عمل', 'قال', 'كنت', 'كانت', 'يكو', 'تكو',
    'هذا', 'هذه', 'هؤل', 'أول', 'إذا', 'لكن', 'لأن', 'أي ', 'كيف', 'هناك',
    'أنا', 'أنت', 'هو ', 'هي ', 'نحن', 'هم ', 'لي ', 'لك ', 'له ', 'لها',
    'لهم', 'لنا', 'لكم', 'كل ', 'بين', 'حتى', 'مع ', 'غير', 'دون', 'وقد',
    'كما', 'إلا', 'أمس', 'الي', 'غدا', 'شيء', 'جيد', 'سيء', 'كثير', 'قليل',
    'كتاب', 'مدرس', 'مدينة', 'عالم', 'اليوم', 'الذي', 'التي', 'الذين', 'اللات',
    'است', 'تست', 'يست', 'مست', 'وات', 'يات', 'ات ', 'ون ', 'ين ', 'ة '
    );

  // ----- Hebrew (120 trigrams) -----
  IW: array[0..89] of string = (
    'את ', 'של ', 'על ', 'לא ', 'עם ', 'גם ', 'זה ', 'כל ', 'בין', 'אשר',
    'אני', 'אתה', 'היא', 'הוא', 'אנח', 'אתם', 'אתן', 'הם ', 'הן ', 'היה',
    'היו', 'יהי', 'יש ', 'אין', 'אבל', 'אם ', 'כי ', 'איך', 'איזה', 'מה ',
    'מי ', 'אמר', 'הלך', 'ראה', 'לקח', 'נתן', 'מצא', 'עשה', 'חשב', 'ידע',
    'ישב', 'עמד', 'שכב', 'טוב', 'רע ', 'מעט', 'הרב', 'שום', 'דבר', 'זאת',
    'אלה', 'לנו', 'לכם', 'להם', 'לי ', 'לך ', 'לו ', 'לה ', 'הכל', 'אתמ',
    'ספר', 'בית', 'ילד', 'עיר ', 'יום ', 'לילה', 'אדם', 'מים', 'ארץ', 'עולם',
    'שלום', 'אפשר', 'צריך', 'יכול', 'היום', 'מחר', 'אתמול', 'בגלל', 'אחרי', 'לפני',
    'יות', 'ים ', 'ות ', 'ים', 'ות', 'נו ', 'כם ', 'הם', 'שלו', 'שלה'
    );

  // ----- Persian (120 trigrams) -----
  FA: array[0..99] of string = (
    'در ', 'به ', 'از ', 'که ', 'می ', 'این', 'است', 'برا', 'برای', 'با ',
    'آن ', 'های', 'های ', 'و ', 'یا ', 'اما', 'ولی', 'چون', 'اگر', 'من ',
    'تو ', 'او ', 'ما ', 'شما', 'آنه', 'مرا', 'ترا', 'چه ', 'کجا', 'چرا',
    'بود', 'شود', 'شد ', 'شدن', 'کرد', 'کردن', 'داشت', 'گرفت', 'داد', 'دید',
    'رفت', 'آمد', 'گفت', 'دان', 'فکر', 'یافت', 'خواست', 'توان', 'باید', 'تواند',
    'زیاد', 'کم ', 'همه', 'هیچ', 'چیز', 'خوب', 'بد ', 'امروز', 'دیروز', 'فردا',
    'خانه', 'کتاب', 'مدرس', 'شهر', 'دنیا', 'زندگ', 'دوست', 'مردم', 'ایران', 'فارس',
    'ترین', 'هایی', 'هایی ', 'کرده', 'کرده ', 'رفته', 'رفته ', 'آمده', 'آمده ', 'شده',
    'می', 'نمی', 'خواهد', 'هست', 'هستم', 'هستی', 'هستن', 'بودن', 'باشد', 'نیست',
    'همین', 'همان', 'دیگر', 'زیرا', 'بعد ', 'قبل ', 'روی ', 'زیر ', 'بین ', 'برای '
    );

  // ----- Greek (100 trigrams) -----
  EL: array[0..99] of string = (
    'την', 'και', 'στο', 'που', 'για', 'από', 'της', 'των', 'είν', 'με ',
    'τον', 'ή ', 'αλλ', 'ότι', 'αν ', 'εγώ', 'εσύ', 'αυτ', 'εμ', 'εσ',
    'μου', 'σου', 'του', 'μας', 'σας', 'τους', 'ποιο', 'τι ', 'πώς', 'είμ',
    'έχω', 'κάν', 'παί', 'δίν', 'βλέ', 'πάω', 'έρχ', 'λέω', 'ξέρ', 'νομ',
    'βρί', 'κάθ', 'στέ', 'ξαπ', 'πολ', 'λίγ', 'όλα', 'τίπ', 'κάτ', 'καλ',
    'κακ', 'σήμ', 'χθε', 'ου', 'αι', 'το', 'τη', 'τα', 'ει', 'να',
    'σε', 'με', 'κα', 'πο', 'αν', 'επ', 'δε', 'πρ', 'υπ', 'απ',
    'εκ', 'εν', 'ερ', 'ορ', 'ιμ', 'υν', 'ην', 'ισ', 'ωσ', 'ησ',
    'εσ', 'οσ', 'υσ', 'ασ', 'ων', 'ες', 'ας', 'ης', 'ως', 'ος',
    'ον', 'ους', 'εις', 'εια', 'ομα', 'ατα', 'οτη', 'ιου', 'ιων', 'οις');

  // ----- Hindi (100 trigrams) -----
  HI: array[0..99] of string = (
    'के ', 'हैं', 'में', 'की ', 'और ', 'से ', 'को ', 'है ', 'पर ', 'भी ',
    'कर ', 'और', 'या ', 'लेक', 'क्यो', 'अगर', 'मैं', 'तू ', 'वह ', 'हम ',
    'तुम', 'वे ', 'मुझ', 'तुझ', 'उसे', 'हमे', 'तुम्', 'उन्', 'मेर', 'तेर',
    'उसक', 'हमर', 'उनक', 'यह ', 'ये ', 'कौन', 'क्या', 'कौ', 'कैस', 'होना',
    'था ', 'करना', 'लेना', 'देना', 'देख', 'जाना', 'आना',
    'कहना', 'जान', 'सोच',
    'मिल', 'बैठ', 'खड़ा', 'लेटना', 'बहु', 'थोड़', 'सब ',
    'कुछ', 'चीज़', 'अच्',
    'बुरा', 'आज', 'कल', ' का', ' के', ' मे', ' से', ' है', ' नह', ' है',
    ' और', ' इस', ' उस', ' यह', ' वह', ' हम', ' आप', ' तु', ' मे', ' ते',
    ' उस', ' इस', ' जब', ' तब', ' कब', ' क्य', ' कै', ' कौ', ' कह', ' कि',
    ' हु', ' कर', ' हो', ' रह', ' गय', ' लिय', ' दिय', ' पड', ' चुक', ' सक');

  // ----- Japanese (120 trigrams) -----
  JA: array[0..119] of string = (
    'です', 'ます', 'した', 'して', 'ない', 'から', 'こと', 'もの', 'ため', 'する',
    'れる', 'られ', 'たい', 'では', 'には', 'とは', 'まで', 'より', 'その', 'この',
    'あの', 'どの', 'ここ', 'そこ', 'どこ', 'いま', 'また', 'もし', 'よう', 'など',
    '今日', '昨日', '明日', '時間', '世界', '日本', '東京', '学校', '先生', '学生',
    '友達', '家族', '会社', '仕事', '本当', '本日', '天気', '太陽', '青空', '公園',
    '散歩', '映画', '音楽', '料理', '夕食', '朝食', '昼食', '電車', '駅前', '道路',
    '大き', '小さ', '長い', '新し', '古い', '高い', '安い', '良い', '悪い', '多い',
    '少な', '思い', '行き', '来る', '見る', '聞く', '読む', '書く', '話す', '食べ',
    '飲む', '買う', '作る', '座る', '立つ', '歩く', '走る', '帰る', '持っ', '置く',
    '人が', '人は', '私は', '彼は', '彼女', '今日は', '今日は', 'です。', 'ます。', 'した。',
    'してい', 'ている', 'います', 'でした', 'ません', 'だった', 'という', 'として', 'につい', 'につい',
    'である', 'がある', 'がない', 'と思う', 'ていた', 'ている', 'するこ', 'したい', 'らしい', 'でしょう'
    );

  // ----- Chinese (200 trigrams) -----
  ZH: array[0..239] of string = (
    '的', '是', '在', '我', '有', '和', '就', '不', '人', '都',
    '一', '了', '也', '很', '到', '说', '要', '去', '你', '会',
    '着', '没', '看', '好', '这', '那', '他', '她', '它', '们',
    '来', '能', '个', '子', '大', '中', '上', '下', '国', '年',
    '出', '得', '起', '把', '过', '自', '己', '以', '为', '时',
    '后', '天', '里', '生', '用', '多', '小', '长', '老', '明',
    '同', '样', '然', '心', '走', '作', '家', '只', '道', '想',
    '面', '新', '高', '开', '现', '前', '还', '当', '因', '最',
    '所', '于', '将', '与', '及', '等', '经', '已', '无', '但',
    '并', '再', '次', '让', '给', '从', '向', '被', '比', '使',

    '一个', '一种', '一些', '一直', '一起', '今天', '昨天', '明天', '现在', '已经',
    '没有', '可以', '不会', '不能', '还有', '还是', '就是', '如果', '因为', '所以',
    '虽然', '但是', '这个', '那个', '这些', '那些', '我们', '他们', '她们', '你们',
    '大家', '人民', '国家', '中国', '社会', '经济', '文化', '历史', '世界', '时间',
    '事情', '问题', '情况', '方面', '地方', '公司', '学校', '学生', '老师', '朋友',
    '孩子', '工作', '学习', '生活', '家庭', '城市', '农村', '北京', '上海', '广州',
    '天气', '电影', '音乐', '电脑', '手机', '网络', '信息', '数据', '系统', '程序',
    '开发', '软件', '用户', '服务', '产品', '市场', '企业', '政府', '医院', '银行',
    '开始', '结束', '继续', '发现', '觉得', '认为', '表示', '提供', '进行', '完成',
    '帮助', '支持', '解决', '使用', '提高', '增加', '减少', '实现', '成为', '达到',

    '的人', '的是', '的话', '之后', '之前', '之中', '之间', '来说', '来说', '来看',
    '出来', '进去', '回来', '过去', '以后', '以前', '以后', '其中', '其中一', '由于',
    '例如', '比如', '此外', '同时', '最后', '首先', '目前', '未来', '每天', '每天都',
    '越来越', '为什么', '怎么样', '什么时候', '什么样', '有没有', '知不知道', '事实上', '总体来', '总而言'
    );

  // ----- Korean (100 trigrams) -----
  KO: array[0..99] of string = (
    '다', '는', '은', '이', '가', '을', '를', '에', '의', '고', '로', '하',
    '있', '수', '것', '들', '그', '되', '일', '말', '위', '지', '안', '대',
    '한', '기', '년', '사람', '등', '때', '나', '같', '어', '주', '보', '시간',
    '없', '문제', '우리', '알', '내', '오', '크', '사', '전', '만', '니다',
    '은 ', '는 ', '이 ', '가 ', '을 ', '를 ', '에 ', '의 ', '고 ', '로 ',
    '서 ', '지 ', '기 ', '하', '되', '있', '습', '니', '까', '요', 'ㅂ',
    'ㅅ', 'ㄱ', 'ㄴ', 'ㄷ', 'ㄹ', 'ㅁ', 'ㅇ', 'ㅈ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ',
    'ㅎ', 'ㅏ', 'ㅑ', 'ㅓ', 'ㅕ', 'ㅗ', 'ㅛ', 'ㅜ', 'ㅠ', 'ㅡ', 'ㅣ',
    '습니다', '합니다', '입니다', '하고', '하는', '에서', '에게', '그리고', '하지만');

  // ----- Vietnamese (100 trigrams) -----
  VI: array[0..100] of string = (
    'của', 'và ', 'nhữ', 'cho', 'ngư', 'các', 'một', 'đượ', 'với', 'tro',
    'như', 'khi', 'thi', 'đó ', 'này', 'là ', 'có ', 'đã ', 'sẽ ', 'thì',
    'cũn', 'tôi', 'bạn', 'anh', 'chị', 'em ', 'chú', 'họ ', 'nó ', 'mìn',
    'nhà', 'trê', 'dướ', 'ngo', 'hoặ', 'vậy', 'vì ', 'nếu', 'kia', 'đây',
    'ai ', 'cái', 'gì ', 'nào', 'sao', 'làm', 'lấy', 'thấ', 'đi ', 'đến',
    'nói', 'biế', 'ngh', 'ngồ', 'đứn', 'nằm', 'nhi', 'ít ', 'tất', 'khô',
    'tốt', 'xấu', 'hôm', 'qua', 'ng ', 'nh ', 'ch ', 'tr ', 'th ', 'ph ',
    'kh ', 'gh ', 'gi ', 'qu ', 'an ', 'en ', 'on ', 'un ', 'in ', 'ên ',
    'ôn ', 'ăn', 'ân', 'ơn', 'ươ', 'iê', 'uô', 'ao', 'eo', 'ia ', 'ua ',
    'ưa ', 'ay ', 'ây ', 'âu ', 'êu ', 'iu ', 'ưu ', 'uy ', 'uơ ', 'iêu');

  // ----- Indonesian (120 trigrams) -----
  ID: array[0..109] of string = (
    'dan', 'yang', 'ang', 'di ', 'ke ', 'dar', 'dari', 'unt', 'untu', 'tuk',
    'ini', 'itu', 'ada', 'aka', 'akan', 'seb', 'seb', 'set', 'ter', 'tet',
    'men', 'meng', 'mem', 'mem', 'pen', 'peng', 'per', 'ber', 'kar', 'kem',
    'say', 'saya', 'kam', 'kami', 'kit', 'kita', 'dia', 'mer', 'mere', 'erek',
    'nya', 'nya ', 'lah', 'kah', 'pun', 'aku', 'kau', 'apa', 'bag', 'jik',
    'tid', 'tida', 'idak', 'buk', 'buka', 'ukan', 'sem', 'semu', 'semua', 'dal',
    'dala', 'alam', 'har', 'hari', 'bar', 'bara', 'arat', 'mat', 'mata', 'atah',
    'tem', 'temp', 'emba', 'baw', 'bawa', 'buk', 'buku', 'dud', 'dudu', 'uduk',
    'ban', 'bang', 'poh', 'poho', 'ohon', 'bes', 'besa', 'esar', 'lan', 'lang',
    'jal', 'jala', 'alan', 'jau', 'auh', 'bir', 'biru', 'ang', 'angi', 'ngin',
    'sep', 'sepo', 'epoi', 'bert', 'bert', 'tiu', 'tiup', 'san', 'nya', 'nya'
    );

  // ----- Thai (100 trigrams) -----
  TH: array[0..99] of string = (
    'การ', 'ควา', 'ของ', 'และ', 'ใน ', 'ให้', 'เป็', 'ที่', 'มี ', 'ได้',
    'จะ ', 'กับ', 'ไป ', 'มา ', 'ว่า', 'ถูก', 'อย่', 'เพร', 'หรื', 'โดย',
    'เมื', 'เธอ', 'ฉัน', 'เขา', 'เรา', 'พวก', 'นี้', 'นั้', 'ไหน', 'อะไ',
    'ทำ ', 'อยู', 'พูด', 'คิด', 'เห็', 'รู้', 'ชอบ', 'รัก', 'สวย', 'ดี ',
    'ใหญ', 'เล็', 'ใหม', 'เก่', 'ก็ ', 'แต่', 'ไม่', 'คน ', 'วัน', 'งาน',
    'มาก', 'ถึง', 'แล้', 'จริ', 'หน้', 'ขึ้', 'ลง ', 'ลูก', 'น้ำ', 'ใจ ',
    'ชีว', 'บ้า', 'รถ ', 'ทาง', 'ต้อ', 'กวา', 'เพื', 'จาก', 'กัน', 'ยัง',
    'เหม', 'อาจ', 'เช่', 'ตอน', 'ทั้', 'อี ', 'ส่ว', 'เวล', 'เรื', 'น้อ',
    'ช่ว', 'กั ', 'หลั', 'กรณ', 'ประ', 'ทา ', 'ตั้', 'พร้', 'เพี', 'สำห',
    'ระห', 'เกี', 'เหต', 'ผล ', 'ครั', 'ซึ่', 'นั้', 'บาง', 'ยิ่', 'นอ ');
begin
  SetLength(Profiles, 30);
  Profiles[0].Code := 'en';
  Profiles[0].Trigrams := EN;
  Profiles[1].Code := 'ru';
  Profiles[1].Trigrams := RU;
  Profiles[2].Code := 'de';
  Profiles[2].Trigrams := DE;
  Profiles[3].Code := 'fr';
  Profiles[3].Trigrams := FR;
  Profiles[4].Code := 'es';
  Profiles[4].Trigrams := ES;
  Profiles[5].Code := 'it';
  Profiles[5].Trigrams := IT;
  Profiles[6].Code := 'pt';
  Profiles[6].Trigrams := PT;
  Profiles[7].Code := 'nl';
  Profiles[7].Trigrams := NL;
  Profiles[8].Code := 'pl';
  Profiles[8].Trigrams := PL;
  Profiles[9].Code := 'uk';
  Profiles[9].Trigrams := UK;
  Profiles[10].Code := 'sv';
  Profiles[10].Trigrams := SV;
  Profiles[11].Code := 'da';
  Profiles[11].Trigrams := DA;
  Profiles[12].Code := 'no';
  Profiles[12].Trigrams := NO;
  Profiles[13].Code := 'fi';
  Profiles[13].Trigrams := FI;
  Profiles[14].Code := 'hu';
  Profiles[14].Trigrams := HU;
  Profiles[15].Code := 'ro';
  Profiles[15].Trigrams := RO;
  Profiles[16].Code := 'cs';
  Profiles[16].Trigrams := CS;
  Profiles[17].Code := 'bg';
  Profiles[17].Trigrams := BG;
  Profiles[18].Code := 'tr';
  Profiles[18].Trigrams := TR;
  Profiles[19].Code := 'ar';
  Profiles[19].Trigrams := AR;
  Profiles[20].Code := 'iw';
  Profiles[20].Trigrams := IW;
  Profiles[21].Code := 'fa';
  Profiles[21].Trigrams := FA;
  Profiles[22].Code := 'el';
  Profiles[22].Trigrams := EL;
  Profiles[23].Code := 'hi';
  Profiles[23].Trigrams := HI;
  Profiles[24].Code := 'ja';
  Profiles[24].Trigrams := JA;
  Profiles[25].Code := 'zh-CN';
  Profiles[25].Trigrams := ZH;
  Profiles[26].Code := 'ko';
  Profiles[26].Trigrams := KO;
  Profiles[27].Code := 'vi';
  Profiles[27].Trigrams := VI;
  Profiles[28].Code := 'id';
  Profiles[28].Trigrams := ID;
  Profiles[29].Code := 'th';
  Profiles[29].Trigrams := TH;
end;
