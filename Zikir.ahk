;ONEXİT EKLE ÇIKIŞTA OTOMATİK KAYDEDİLSİN VE KAYIT VARSA OTOMATİK O SAYIDAN BAŞLASIN
DetectHiddenWindows, On
SetKeyDelay, -1
#SingleInstance, ignore
#Persistent
SetWorkingDir, %A_ScriptDir%
Menu, Tray, Icon, % A_WinDir "\system32\shell32.dll",246
global BaslamaSayisi,SimdikiSayi,goster,gorunur
gorunur=1

BaslamaSayisi=0
Uyarı=5000
;inputbox, Başlangıç,, Başlangıç sayısını giriniz,,,,,,,,0



	;ARAYÜZ ZİKİR
Gui, -Caption -Border +E0x08000000
Gui,Margin,3,3
Gui, +AlwaysOnTop ;TUŞLA GÖSTERMEYİ İSTERSEN BUNU "Winset, AlwaysOnTop,Off,Zikir" DEVRE DIŞI BIRAK
Gui, Color, Green
Gui, font, s15, Arial

	;GUİ ZİKİR METNİ
Gui, Add, text, w100 cLime left vSayi gdragger,%BaslamaSayisi%
SendLevel 1

	;Gui Ekran Konumunu, değişen ekran yüksekliklerine göre ayarla
Yukseklik:=A_ScreenHeight
while (Yukseklik != 68)
{	Yukseklik-- ; Değişkenden bir çıkart
	Çıkartılan++ ; Çıkartılan değişkenini bir artır
}	konum:="x"A_ScreenWidth - 71 " y"A_ScreenHeight - Çıkartılan

	;GÖSTER ZİKİR
Gui, Show,NA %konum% w70 h30, Zikir
WinWait,Zikir
WinSet, Transparent, 130,  Zikir

	;ARAYÜZE TIKLAMALARI ALGILA
OnMessage(0x0203, "WM_LBUTTONDBLCLK")
OnMessage(0x205,"RButtonUp")

	;GUİ AYAR
Gui,ayar: Color,silver,white
Gui,ayar: Font, s10 Bold cGreen,Arial
gui,ayar: -caption
Gui,ayar: +AlwaysOnTop 

	;GUİ AYAR
	;EDİT
Gui,ayar: Add, Edit, w100 h30 Center -VScroll Limit6  Number vBaslamaSayisi
	;DROPLİST
Gui,ayar: Add, DropDownList, w100 varteksil Choose1, Artsın|Eksilsin
	;TAMAM
Gui,ayar: Add, Button, w100 h30 gTamam vTamam, TAMAM 
GuiControlGet, hwndTAMAM, ayar: Hwnd,TAMAM
DllCall("uxtheme\SetWindowTheme", "ptr", hwndTamam, "str", "DarkMode_Explorer", "ptr", 0)

	
	;GÖSTER AYAR
Gui,ayar: Show,Autosize,Ayarlar
RETURN

;----------------------------------------------İŞLEVLER------------------------------------------------------------------------


Tamam:
Gui, Submit, NoHide
Gui,ayar: Submit, NoHide
	;Boşsa...
if BaslamaSayisi =
{BaslamaSayisi=0
Guicontrol,, Sayi, %BaslamaSayisi%
Gui,Ayar:Hide
Return
} 	Else	;Boş değilse...
Guicontrol,, Sayi, %BaslamaSayisi%
Gui,Ayar:Hide
RETURN





	;SÜRÜKLENEBİLİRLİK
dragger:
Winactivate,Zikir
 PostMessage, 0xA1, 2,,, A 
RETURN


	;SAYAÇ İŞLEV
numpadEnter::
Gui,Submit, Nohide
KeyWait,numpadEnter,T0.4 ;  X saniye içinde tekrar basılırsa devam et
	;GÖSTER: 350ms'den uzun basılırsa sayıyı göster
	    If ErrorLevel  ; Eğer X saniyeden uzun süre basılı tutulursa
{
WinGetTitle, Baslik, A
	if gorunur=0
{ Gui,Show,NA
Gui, Font, cRed
Guicontrol,Font,Sayi
;WinWaitActive,Zikir
;Winset, AlwaysOnTop,On,Zikir
gorunur=1
;WinActivate,%Baslik%
sleep 700
Gui, Font, cLime
Guicontrol,Font,Sayi
	return
}if gorunur=1
{Gui,Hide
gorunur=0
sleep 700
return
}
;WinActivate, %Baslik%
;WinWaitActive,%Baslik%
;Winset, AlwaysOnTop,Off,Zikir
Return
}	;ARTTIR: 350ms'den kısa basılırsa sayıyı arttır
	ELSE
if arteksil=Artsın
BaslamaSayisi++
if arteksil=Eksilsin
BaslamaSayisi--
KeyWait,numpadEnter,T0.3
Guicontrol,, Sayi, %BaslamaSayisi%
SimdikiSayi:=BaslamaSayisi
Return




	; ÇİFT TIKLAMA  (Gui ayarları aç)
WM_LBUTTONDBLCLK() {
Gui,Ayar:Show
if SimdikiSayi =
{Guicontrol,ayar:,BaslamaSayisi,%BaslamaSayisi%
MouseMove,104,30,0
RETURN
}
Guicontrol,ayar:,BaslamaSayisi,%SimdikiSayi%
MouseMove,104,30,0
RETURN
}


	; SAĞ TIKLAMA (Çıkış)   ;••• MENÜ EKLE ••• GİZLE - SIFIRLA - DÜZENLE - KAYDET(KapatAçta Kalınandan Devam) - ÇIKIŞ
RButtonUp(w,l,msg,hwnd) {
MsgBox, 36,, Çıkmak istediğinize emin misiniz?
IfMsgBox Yes
{ExitApp
}RETURN
Return
}


	#IfWinActive, Ayarlar
*~ESC::
Gui, Submit, NoHide
Gui,ayar: Submit, NoHide
{Gui,Ayar:Hide
	if BaslamaSayisi =
{BaslamaSayisi=0
}	Return
}
	#IfWinActive, Ayarlar
*~Enter::
{Gui,Ayar:Hide
GoSub,Tamam
Return
}