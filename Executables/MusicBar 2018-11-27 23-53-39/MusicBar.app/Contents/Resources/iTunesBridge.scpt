FasdUAS 1.101.10   ��   ��    k             l     ��������  ��  ��        l     ��������  ��  ��     	 
 	 h     �� �� 0 itunesbridge iTunesBridge  k             l     ��������  ��  ��        j     �� 
�� 
pare  4     �� 
�� 
pcls  m       �    N S O b j e c t      l     ��������  ��  ��        l     ��������  ��  ��        i  	     I      �������� 0 	isrunning 	isRunning��  ��    l         k           ! " ! l     �� # $��   # N H AppleScript will automatically launch apps before sending Apple events;    $ � % % �   A p p l e S c r i p t   w i l l   a u t o m a t i c a l l y   l a u n c h   a p p s   b e f o r e   s e n d i n g   A p p l e   e v e n t s ; "  & ' & l     �� ( )��   ( N H if that is undesirable, check the app object's `running` property first    ) � * * �   i f   t h a t   i s   u n d e s i r a b l e ,   c h e c k   t h e   a p p   o b j e c t ' s   ` r u n n i n g `   p r o p e r t y   f i r s t '  +�� + L      , , n      - . - 1    ��
�� 
prun . m      / /n                                                                                  hook  alis      SSD                            BD ����
iTunes.app                                                     ����            ����  
 cu             Applications  /:Applications:iTunes.app/   
 i T u n e s . a p p    S S D  Applications/iTunes.app   / ��  ��      () -> NSNumber (Bool)     � 0 0 ,   ( )   - >   N S N u m b e r   ( B o o l )   1 2 1 l     ��������  ��  ��   2  3 4 3 l     ��������  ��  ��   4  5 6 5 i    7 8 7 I      �������� 0 playerstate playerState��  ��   8 l    L 9 : ; 9 O     L < = < k    K > >  ? @ ? Z    H A B���� A 1    ��
�� 
prun B k    D C C  D E D r     F G F 1    ��
�� 
pPlS G o      ���� 0 currentstate currentState E  H I H l   �� J K��   J L F ASOC does not bridge AppleScript's 'type class' and 'constant' values    K � L L �   A S O C   d o e s   n o t   b r i d g e   A p p l e S c r i p t ' s   ' t y p e   c l a s s '   a n d   ' c o n s t a n t '   v a l u e s I  M N M r     O P O m    ����  P o      ���� 0 i   N  Q�� Q X    D R�� S R k   + ? T T  U V U Z  + 9 W X���� W =  + 0 Y Z Y o   + ,���� 0 currentstate currentState Z n   , / [ \ [ 1   - /��
�� 
pcnt \ o   , -���� 0 stateenumref stateEnumRef X L   3 5 ] ] o   3 4���� 0 i  ��  ��   V  ^�� ^ r   : ? _ ` _ [   : = a b a o   : ;���� 0 i   b m   ; <����  ` o      ���� 0 i  ��  �� 0 stateenumref stateEnumRef S J     c c  d e d m    ��
�� ePlSkPSS e  f g f m    ��
�� ePlSkPSP g  h i h m    ��
�� ePlSkPSp i  j k j m    ��
�� ePlSkPSF k  l�� l m    ��
�� ePlSkPSR��  ��  ��  ��   @  m�� m l  I K n o p n L   I K q q m   I J����   o  
 'unknown'    p � r r    ' u n k n o w n '��   = m      s sn                                                                                  hook  alis      SSD                            BD ����
iTunes.app                                                     ����            ����  
 cu             Applications  /:Applications:iTunes.app/   
 i T u n e s . a p p    S S D  Applications/iTunes.app   / ��   : #  () -> NSNumber (PlayerState)    ; � t t :   ( )   - >   N S N u m b e r   ( P l a y e r S t a t e ) 6  u v u l     ��������  ��  ��   v  w x w l     ��������  ��  ��   x  y z y i    { | { I      �������� 0 	trackinfo 	trackInfo��  ��   | l    , } ~  } O     , � � � Q    + � � � � L    ! � � n      � � � K   
  � � �� � ��� 0 	trackname 	trackName � 1    ��
�� 
pnam � �� � ��� 0 trackartist trackArtist � 1    ��
�� 
pArt � �� ����� 0 
trackalbum 
trackAlbum � 1    ��
�� 
pAlb��   � 1    
��
�� 
pTrk � R      ���� �
�� .ascrerr ****      � ****��   � �� ���
�� 
errn � d       � � m      �������   � l  ) + � � � � l  ) + � � � � L   ) + � � m   ) *��
�� 
msng � 
  nil    � � � �    n i l � %  current track is not available    � � � � >   c u r r e n t   t r a c k   i s   n o t   a v a i l a b l e � m      � �n                                                                                  hook  alis      SSD                            BD ����
iTunes.app                                                     ����            ����  
 cu             Applications  /:Applications:iTunes.app/   
 i T u n e s . a p p    S S D  Applications/iTunes.app   / ��   ~ S M () -> ["trackName":NSString, "trackArtist":NSString, "trackAlbum":NSString]?     � � � �   ( )   - >   [ " t r a c k N a m e " : N S S t r i n g ,   " t r a c k A r t i s t " : N S S t r i n g ,   " t r a c k A l b u m " : N S S t r i n g ] ? z  � � � l     ��������  ��  ��   �  � � � i    � � � I      �������� 0 trackduration trackDuration��  ��   � l     � � � � O      � � � L     � � n    
 � � � 1    	��
�� 
pDur � 1    ��
�� 
pTrk � m      � �n                                                                                  hook  alis      SSD                            BD ����
iTunes.app                                                     ����            ����  
 cu             Applications  /:Applications:iTunes.app/   
 i T u n e s . a p p    S S D  Applications/iTunes.app   / ��   � #  () -> NSNumber (Double, >=0)    � � � � :   ( )   - >   N S N u m b e r   ( D o u b l e ,   > = 0 ) �  � � � l     ��������  ��  ��   �  � � � l     ��������  ��  ��   �  � � � i    � � � I      �������� 0 soundvolume soundVolume��  ��   � l    
 � � � � O     
 � � � l   	 � � � � L    	 � � 1    ��
�� 
pVol � 5 / ASOC will convert returned integer to NSNumber    � � � � ^   A S O C   w i l l   c o n v e r t   r e t u r n e d   i n t e g e r   t o   N S N u m b e r � m      � �n                                                                                  hook  alis      SSD                            BD ����
iTunes.app                                                     ����            ����  
 cu             Applications  /:Applications:iTunes.app/   
 i T u n e s . a p p    S S D  Applications/iTunes.app   / ��   � $  () -> NSNumber (Int, 0...100)    � � � � <   ( )   - >   N S N u m b e r   ( I n t ,   0 . . . 1 0 0 ) �  � � � l     ��������  ��  ��   �  � � � i     � � � I      �� ����� "0 setsoundvolume_ setSoundVolume_ �  ��� � o      ���� 0 	newvolume 	newVolume��  ��   � l     � � � � k      � �  � � � l     �� � ���   � K E ASOC does not convert NSObject parameters to AS types automatically�    � � � � �   A S O C   d o e s   n o t   c o n v e r t   N S O b j e c t   p a r a m e t e r s   t o   A S   t y p e s   a u t o m a t i c a l l y & �  ��� � O      � � � k     � �  � � � l   �� � ���   � V P �so be sure to coerce NSNumber to native integer before using it in Apple event    � � � � �   & s o   b e   s u r e   t o   c o e r c e   N S N u m b e r   t o   n a t i v e   i n t e g e r   b e f o r e   u s i n g   i t   i n   A p p l e   e v e n t �  ��� � r     � � � c     � � � o    ���� 0 	newvolume 	newVolume � m    ��
�� 
long � 1    
��
�� 
pVol��   � m      � �n                                                                                  hook  alis      SSD                            BD ����
iTunes.app                                                     ����            ����  
 cu             Applications  /:Applications:iTunes.app/   
 i T u n e s . a p p    S S D  Applications/iTunes.app   / ��  ��   �   (NSNumber) -> ()    � � � � "   ( N S N u m b e r )   - >   ( ) �  � � � l     ��������  ��  ��   �  � � � i  ! $ � � � I      �������� 
0 rating  ��  ��   � l     � � � � O      � � � l    � � � � L     � � n    
 � � � 1    	��
�� 
pRte � 1    ��
�� 
pTrk � 5 / ASOC will convert returned integer to NSNumber    � � � � ^   A S O C   w i l l   c o n v e r t   r e t u r n e d   i n t e g e r   t o   N S N u m b e r � m      � �n                                                                                  hook  alis      SSD                            BD ����
iTunes.app                                                     ����            ����  
 cu             Applications  /:Applications:iTunes.app/   
 i T u n e s . a p p    S S D  Applications/iTunes.app   / ��   � $  () -> NSNumber (Int, 0...100)    � � � � <   ( )   - >   N S N u m b e r   ( I n t ,   0 . . . 1 0 0 ) �  � � � l     �������  ��  �   �  � � � i  % ( � � � I      �~ ��}�~ 0 
setrating_ 
setRating_ �  ��| � o      �{�{ 0 	newrating 	newRating�|  �}   � l     � � � � k         l     �z�z   K E ASOC does not convert NSObject parameters to AS types automatically�    � �   A S O C   d o e s   n o t   c o n v e r t   N S O b j e c t   p a r a m e t e r s   t o   A S   t y p e s   a u t o m a t i c a l l y & �y O      k    		 

 l   �x�x   V P �so be sure to coerce NSNumber to native integer before using it in Apple event    � �   & s o   b e   s u r e   t o   c o e r c e   N S N u m b e r   t o   n a t i v e   i n t e g e r   b e f o r e   u s i n g   i t   i n   A p p l e   e v e n t �w r     c     o    �v�v 0 	newrating 	newRating m    �u
�u 
long n       1   
 �t
�t 
pRte 1    
�s
�s 
pTrk�w   m     n                                                                                  hook  alis      SSD                            BD ����
iTunes.app                                                     ����            ����  
 cu             Applications  /:Applications:iTunes.app/   
 i T u n e s . a p p    S S D  Applications/iTunes.app   / ��  �y   �   (NSNumber) -> ()    � � "   ( N S N u m b e r )   - >   ( ) �  l     �r�q�p�r  �q  �p    i  ) , I      �o�n�m�o 0 	playpause 	playPause�n  �m   O    
 I   	�l�k�j
�l .hookPlPsnull��� ��� null�k  �j   m       n                                                                                  hook  alis      SSD                            BD ����
iTunes.app                                                     ����            ����  
 cu             Applications  /:Applications:iTunes.app/   
 i T u n e s . a p p    S S D  Applications/iTunes.app   / ��   !"! l     �i�h�g�i  �h  �g  " #$# i  - 0%&% I      �f�e�d�f 0 play  �e  �d  & O    
'(' I   	�c�b�a
�c .hookPlaynull��� ��� obj �b  �a  ( m     ))n                                                                                  hook  alis      SSD                            BD ����
iTunes.app                                                     ����            ����  
 cu             Applications  /:Applications:iTunes.app/   
 i T u n e s . a p p    S S D  Applications/iTunes.app   / ��  $ *+* l     �`�_�^�`  �_  �^  + ,-, i  1 4./. I      �]�\�[�] 	0 pause  �\  �[  / O    
010 I   	�Z�Y�X
�Z .hookPausnull��� ��� null�Y  �X  1 m     22n                                                                                  hook  alis      SSD                            BD ����
iTunes.app                                                     ����            ����  
 cu             Applications  /:Applications:iTunes.app/   
 i T u n e s . a p p    S S D  Applications/iTunes.app   / ��  - 343 l     �W�V�U�W  �V  �U  4 565 i  5 8787 I      �T�S�R�T 0 gotonexttrack gotoNextTrack�S  �R  8 O    
9:9 I   	�Q�P�O
�Q .hookNextnull��� ��� null�P  �O  : m     ;;n                                                                                  hook  alis      SSD                            BD ����
iTunes.app                                                     ����            ����  
 cu             Applications  /:Applications:iTunes.app/   
 i T u n e s . a p p    S S D  Applications/iTunes.app   / ��  6 <=< l     �N�M�L�N  �M  �L  = >?> i  9 <@A@ I      �K�J�I�K &0 gotoprevioustrack gotoPreviousTrack�J  �I  A O    
BCB I   	�H�G�F
�H .hookPrevnull��� ��� null�G  �F  C m     DDn                                                                                  hook  alis      SSD                            BD ����
iTunes.app                                                     ����            ����  
 cu             Applications  /:Applications:iTunes.app/   
 i T u n e s . a p p    S S D  Applications/iTunes.app   / ��  ? E�EE l     �D�C�B�D  �C  �B  �E   
 F�AF l     �@�?�>�@  �?  �>  �A       �=GH�=  G �<�< 0 itunesbridge iTunesBridgeH �; IJ�; 0 itunesbridge iTunesBridgeI KK �:�9L
�: misccura
�9 
pclsL �MM  N S O b j e c tJ �8N�7OPQRSTUVWXYZ[�8  N �6�5�4�3�2�1�0�/�.�-�,�+�*�)
�6 
pare�5 0 	isrunning 	isRunning�4 0 playerstate playerState�3 0 	trackinfo 	trackInfo�2 0 trackduration trackDuration�1 0 soundvolume soundVolume�0 "0 setsoundvolume_ setSoundVolume_�/ 
0 rating  �. 0 
setrating_ 
setRating_�- 0 	playpause 	playPause�, 0 play  �+ 	0 pause  �* 0 gotonexttrack gotoNextTrack�) &0 gotoprevioustrack gotoPreviousTrack�7  O �( �'�&\]�%�( 0 	isrunning 	isRunning�'  �&  \  ]  /�$
�$ 
prun�% ��,EP �# 8�"�!^_� �# 0 playerstate playerState�"  �!  ^ ���� 0 currentstate currentState� 0 i  � 0 stateenumref stateEnumRef_  s������������
� 
prun
� 
pPlS
� ePlSkPSS
� ePlSkPSP
� ePlSkPSp
� ePlSkPSF
� ePlSkPSR� 
� 
kocl
� 
cobj
� .corecnte****       ****
� 
pcnt�  M� I*�,E >*�,E�OkE�O .������v[��l kh ���,  �Y hO�kE�[OY��Y hOjUQ � |��`a�� 0 	trackinfo 	trackInfo�  �  `  a  ����
�	�����b�
� 
pTrk� 0 	trackname 	trackName
�
 
pnam�	 0 trackartist trackArtist
� 
pArt� 0 
trackalbum 
trackAlbum
� 
pAlb� �  b ��� 
� 
errn��@�   
� 
msng� -� ) *�,�\[�,\�\[�,\�\[�,\Z�EW 	X 	 
�UR �� �����cd���� 0 trackduration trackDuration��  ��  c  d  �����
�� 
pTrk
�� 
pDur�� � 	*�,�,EUS �� �����ef���� 0 soundvolume soundVolume��  ��  e  f  ���
�� 
pVol�� � *�,EUT �� �����gh���� "0 setsoundvolume_ setSoundVolume_�� ��i�� i  ���� 0 	newvolume 	newVolume��  g ���� 0 	newvolume 	newVolumeh  �����
�� 
long
�� 
pVol�� � 	��&*�,FUU �� �����jk���� 
0 rating  ��  ��  j  k  �����
�� 
pTrk
�� 
pRte�� � 	*�,�,EUV �� �����lm���� 0 
setrating_ 
setRating_�� ��n�� n  ���� 0 	newrating 	newRating��  l ���� 0 	newrating 	newRatingm ������
�� 
long
�� 
pTrk
�� 
pRte�� � ��&*�,�,FUW ������op���� 0 	playpause 	playPause��  ��  o  p  ��
�� .hookPlPsnull��� ��� null�� � *j UX ��&����qr���� 0 play  ��  ��  q  r )��
�� .hookPlaynull��� ��� obj �� � *j UY ��/����st���� 	0 pause  ��  ��  s  t 2��
�� .hookPausnull��� ��� null�� � *j UZ ��8����uv���� 0 gotonexttrack gotoNextTrack��  ��  u  v ;��
�� .hookNextnull��� ��� null�� � *j U[ ��A����wx���� &0 gotoprevioustrack gotoPreviousTrack��  ��  w  x D��
�� .hookPrevnull��� ��� null�� � *j U ascr  ��ޭ