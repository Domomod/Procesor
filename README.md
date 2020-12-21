# Opis budowy
	
![alt text](https://github.com/Domomod/Procesor/blob/main/Schemat.png?raw=true)
	
Procesor posiada ,,pamięć'' złożoną z kilku rejestrów o adresach od 0 do N-1, w kodzie 1 z N (ponieważ można wtedy od razu użyć adres połączony z sygnałem DINout i Gout do wysterowania multipleksera, połączonego z magistralą danych, w mojej implementacji multiplekser sterowany jest liczbą 1 z N, nie NKB).

Jednostką wykonawczą jest układ sumatora (rozbudowanego o możliwość odejmowania) z dwoma rejestrami. Jeden rejestr przechowuje wartość pierwszego operandu, a drugi zapisuje wartość sumowania, co umożliwia jej dalszy zapis do jednego z rejestrów "pamięci".

Procesor posiada kilka instrukcji swoistego assemblera, odczyt typu instrukcji odbywa się z tej samej linii co dane. Ponieważ dane i typ instrukcji nie muszą pojawiać się jednocześnie. 

Typ wykonywanej instrukcji zapisywany jest w rejestrze na cały czas jej wykonywania.

Z racji, że układ jest sekwencyjny, a instrukcje składją się z kolejnych odczytów i zapisów, trzeba je rozłożyć w czasie. Do kontrolowania na którym etapie przetwarzania jest procesor wprowadzony jest licznik.

Magistrala zrealizowana jest za pomocą multipleksera sterowanego przez układ sterujący. Pozwala on wysłać na wejścia ,,pamięci'', sumatora, rejestru pierwszego operandu, i wyjście układu wartości jednego z: danych wejściowych, rejestru w ,,pamięci'', rejestru wyjściowego sumatora.
Sterowanie tymi wszystkimi elementami odbywa się w układzie sterującym, na podstawie typu instrukcji, wartości licznika, sygnału Run(odpowiedzialnego za uruchomienie instrukcji) i Reset.

# Instrukcje
Każda instrukcja jest rozłożona w czasie, w pierwszym okresie (licznik = 0) do rejestru IR zapisywany jest typ instrukcji i wartość RX i RY. Odczytywana jest wartość sygnału RUN, jeśli jest w stanie wysokim, układ sterujący uruchamia licznik i przechodzi do następnego stanu, zależnego już od typu instrukcji.
## mv
Instrukcja mv polega na przepisaniu wartości z rejestru RY do RX. Realizowane jest to w czasie jednego okresu przez wysterowanie sygnału RYout i RXin, czyli podanie wartości rejestru RY na magsitralę i zapisanie jej do Rejestru RX przy następnym zboczu zegarowym. Dodatkowo synchronicznie resetowany jest licznik, co sygnalizuje koniec przetwarzania, natomiast stan wysoki przyjmuje sygnał Done. 
## mvi
Instrukcja mvi polega na przypisaniu 16 bitowej wartości D do rejestru RX. Wartość RY zatem nie ma znaczenia, natomiast wartość D musi zostać podana w kolejnym okresie (licznik = 1), wysterowanie sygnałów jest podobne RXin = 1 oraz DINout = 1. Zerowanie licznika i sygnał Done analogicznie jak w instrukcji mv.
## add i sub
Instrukcje add i sub są do siebie bardzo podobne, polegają na dodaniu/odjęciu wartości w rejestrze RY od wartości w rejestrze RX i zapisaniu wyniku w rejestrze RX. Ich realizacja wymaga kilku taktów. W drugim okresie (licznik = 1) na magistralę trafia wartość rejestru RX (RXout = 1) i zapisywana jest w rejestrze podręcznym sumatora (Ain = 1).  W trzecim okresie (licznik = 2) AddSub ustawiane jest na: 0 w przypadku add, 1 w przypadku sub. Na wejście rejestru G trafia wynik sumowania, dzięki wysterowaniu Gin = 1 zostaje on zapisany do niego przy kolejnym zboczu. W kolejnym okresie (licznik = 3) wartość wyniku z rejestru G trafia na magistralę (Gout = 1), dzięki temu w tym okresie trafi ona na wejścia rejestrów ,,pamięci'' i zostanie tam zapisana w rejestrze RX z następnym taktem dzięki wysterowaniu RXin = 1. Ponadto zerowany jest licznik i ustawiany jest sygnał Done.
