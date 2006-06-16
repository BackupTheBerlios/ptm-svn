.\" 2000 PTM Przemek Borys <pborys@dione.ids.pl>
.\"  -*- nroff -*-
.\"
.\" scp.1
.\"
.\" Author: Tatu Ylonen <ylo@cs.hut.fi>
.\"
.\" Copyright (c) 1995 Tatu Ylonen <ylo@cs.hut.fi>, Espoo, Finland
.\"                    All rights reserved
.\"
.\" Created: Sun May  7 00:14:37 1995 ylo
.\"
.\" $Id: scp.1.com,v 1.4 2004/06/21 09:37:03 robert Exp $
.\" $Log: scp.1.com,v $
.\" Revision 1.4  2004/06/21 09:37:03  robert
.\" poprawka
.\"
.\" Revision 1.3  2004/06/16 04:44:04  ankry
.\" - reversed: this manpage belongs to a commercial SSH
.\"
.\" Revision 1.1  2000/07/26 13:06:01  pborys
.\" nowe.
.\"
.\" Revision 1.1.1.1  1999/09/02 23:27:08  wiget
.\" - pierwsza porcja oryginalnych manuali
.\"
.\" Revision 1.7  1998/08/07 12:26:35  tri
.\" 	Added flag -1 to force command "scp1" on the remote
.\" 	system instead of "scp".  This is necessary sometimes,
.\" 	if remote side has scp symlinked to scp2.
.\"
.\" Revision 1.6  1998/07/08 00:42:13  kivinen
.\" 	Changed to do similar commercial #ifdef processing than other
.\" 	files. Added -a, -A, -Q, and -L. Added comment about
.\" 	environment variables.
.\"
.\" Revision 1.5  1998/06/11 00:10:08  kivinen
.\" 	Added -q option.
.\"
.\" Revision 1.4  1997/04/27  21:48:37  kivinen
.\" 	Added F-SECURE stuff.
.\"
.\" Revision 1.3  1997/04/23 00:03:28  kivinen
.\" 	Documented -S flag and -o flags.
.\"
.\" Revision 1.2  1997/03/25 05:41:20  kivinen
.\" 	Fixed typo. Changed ylo's email to @ssh.fi.
.\"
.\" Revision 1.1.1.1  1996/02/18 21:38:13  ylo
.\" 	Imported ssh-1.2.13.
.\"
.\" Revision 1.5  1995/08/29  22:30:46  ylo
.\" 	Improved manual pages from Andrew Macpherson.
.\"
.\" Revision 1.4  1995/08/18  22:55:14  ylo
.\" 	Added "-P port" option.
.\"
.\" Revision 1.3  1995/07/13  01:37:06  ylo
.\" 	Removed "Last modified" header.
.\" 	Added cvs log.
.\"
.\" $Endlog$
.\"
.\"
.\"
.\"
.\" #ifndef F_SECURE_COMMERCIAL
.TH SCP 1 "8 listopad 1995" "SSH" "SSH"
.\" #endif F_SECURE_COMMERCIAL

.SH NAZWA
scp \- bezpieczne kopiowanie (program zdalnego kopiowania plików)

.SH SKŁADNIA
.LP
.B scp
[\c
.B \-aAqQprvBCL1\c
]
[\c
.BI \-S "\ ścieżka-do-ssh\c
]
[\c
.BI \-o "\ opcje-ssh\c
]
[\c
.BI \-P "\ port\c
]
[\c
.BI \-c "\ szyfr\c
]
[\c
.BI \-i "\ tożsamość\c
]
.if n .ti +5
[[\c
.B użytkownik@\c
]\c
.B host1:\c
]\c
.B nazwapliku1\c
\&.\|.\|.
[[\c
.B użytkownik@\c
]\c
.B host2:\c
]\c
.B nazwapliku2

.SH OPIS
.LP
.B Scp
kopiuje pliki między hostami sieci. Do transferu danych używa
.B ssh
i wykorzystuje tą samą autoryzację oraz daje takie samo bezpieczeństwo jak
same security as
.B ssh.
W przeciwieństwie do
.BR rcp ",
.B scp
pyta w razie potrzeby o hasła uwierzytelniające.
.LP
Wszelkie nazwy pliku mogą zawierać specyfikacje hosta i użytkownika,
określające że plik jest kopiowany do/z tego hosta. Dozwolone jest
kopiowanie między dwoma zdalnymi hostami.

.SH OPCJE

.TP 0.6i
.B \-a
Włącza wyświetlanie statystyk dla każdego pliku.
.TP
.B \-A
Wyłącza wyświetlanie statystyk dla każdego pliku.
.TP
.BI \-c "\ szyfr
Wybiera szyfr używany do kodowania danych. Opcja ta jest przekazywana
bezpośrednio do
.B ssh.
.TP
.BI \-i "\ plik_tożsamości
Wybiera plik, z którego odczytywana jest tożsamość (klucz prywatny) dla
uwierzytelnienia RSA. Opcja ta jest przekazywana bezpośrednio do
.B ssh.
.TP
.B \-L
Użyj nieuprzywilejowanego portu. Prz użyciu tej opcji nie można używać
autoryzacji rhosts lub rsarhosts, ale umożliwia ona ominąć niektóre zapory
ogniowe, które nie zezwalają na przejście uprzywilejowanych portów
źródłowych. Jest to to samo co wykonanie "-o UsePrivilegdePort=no" lub -P w
ssh; -L zostało użyte z powodu braku odpowiednich liter.
.TP
.B \-1
Wymuś by scp na zdalnym końcu użył zamiast "scp" polecenia "scp1". Może to
być konieczne w pewnych sytuacjach jeśli zdalny system ma dowiązane "scp" do
"scp2".
.TP
.BI \-o "\ opcje-ssh
Opcje ssh przekazywane programowi ssh.
.TP
.B \-p
Zachowuje czasy modyfikacji, dostępu i prawa oryginalnego pliku.
.TP
.B \-q
Wyłącz wyświetlanie statystyk.
.TP
.B \-Q
Włącz wyświetlanie statystyk.
.TP
.B \-r
Kopiuj rekursywnie całe katalogi.
.TP
.B \-v
Tryb gadatliwy. Powoduje, że
.B scp
i
.B ssh
drukują komunikaty debugowe o swoim działaniu. Jest to przydatne w
debugowaniu problemów łączenia, autoryzacji i konfiguracji.
.TP
.B \-B
Wybiera tryb wsadowy (nie pyta o hasła i frazy kodujące).
.TP
.B \-C
Włączenie kompresji. Przekazuje
.B ssh
flagę -C, włączającą kompresję.
.TP
.BI \-P "\ port
Podaje port, do którego podłączyć się na zdalnym hoście. Zauważ, że opcja ta
jest napisana jako duże P, gdyż \-p już jest zarezerwowane dla innej
operacji.
.TP
.BI \-S "\ ścieżka-do-ssh
Określa ścieżkę do programu ssh.

.SH ZMIENNE ŚRODOWISKOWE
.LP
Statystyki scp można przełączać, ustawiając zmienne środowiskowe
.B SSH_SCP_STATS
lub
.BR SSH_NO_SCP_STATS .
Aby przełączać statystyki dla każdego pliku, użyj
.B SSH_ALL_SCP_STATS
lub
.BR SSH_NO_ALL_SCP_STATS .
Domyślne wartości statystyk można ustawić podczas konfiguracji ssh. Potem
scp sprawdza wymienione zmienne środowiskowe, a na końcu opcje linii poleceń.

.SH AUTORZY
.LP
Timo Rinne <tri@iki.fi> i Tatu Ylonen <ylo@ssh.fi>

.SH ŹRÓDŁA
.LP
.B Scp
jest oparty na programie
.BR rcp ,
o kodzie źródłowym z Regentów Uniwersytetu Kalifornijskiego.

.SH ZOBACZ TAKŻE
.LP
.BR ssh (1),
.BR sshd (8),
.BR ssh-keygen (1),
.BR ssh-agent (1),
.BR ssh-add (1),
.BR rcp (1)
