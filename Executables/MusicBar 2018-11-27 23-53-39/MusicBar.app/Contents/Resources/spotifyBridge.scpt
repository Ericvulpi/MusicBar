FasdUAS 1.101.10   ��   ��    k             l     ��������  ��  ��        l     ��������  ��  ��     	 
 	 h     �� �� 0 spotifybridge spotifyBridge  k             l     ��������  ��  ��        j     �� 
�� 
pare  4     �� 
�� 
pcls  m       �    N S O b j e c t      l     ��������  ��  ��        l     ��������  ��  ��        i  	     I      �������� 0 	isrunning 	isRunning��  ��    l         k           ! " ! l     �� # $��   # N H AppleScript will automatically launch apps before sending Apple events;    $ � % % �   A p p l e S c r i p t   w i l l   a u t o m a t i c a l l y   l a u n c h   a p p s   b e f o r e   s e n d i n g   A p p l e   e v e n t s ; "  & ' & l     �� ( )��   ( N H if that is undesirable, check the app object's `running` property first    ) � * * �   i f   t h a t   i s   u n d e s i r a b l e ,   c h e c k   t h e   a p p   o b j e c t ' s   ` r u n n i n g `   p r o p e r t y   f i r s t '  +�� + L      , , n      - . - 1    ��
�� 
prun . m      / /r                                                                                      @ alis      SSD                            BD ����Spotify.app                                                    ����            ����  
 cu             Applications  /:Applications:Spotify.app/     S p o t i f y . a p p    S S D  Applications/Spotify.app  / ��  ��      () -> NSNumber (Bool)     � 0 0 ,   ( )   - >   N S N u m b e r   ( B o o l )   1 2 1 l     ��������  ��  ��   2  3 4 3 i    5 6 5 I      �������� 0 playerstate playerState��  ��   6 l    J 7 8 9 7 O     J : ; : k    I < <  = > = Z    F ? @���� ? 1    ��
�� 
prun @ k    B A A  B C B r     D E D 1    ��
�� 
pPlS E o      ���� 0 currentstate currentState C  F G F l   �� H I��   H L F ASOC does not bridge AppleScript's 'type class' and 'constant' values    I � J J �   A S O C   d o e s   n o t   b r i d g e   A p p l e S c r i p t ' s   ' t y p e   c l a s s '   a n d   ' c o n s t a n t '   v a l u e s G  K L K r     M N M m    ����  N o      ���� 0 i   L  O�� O X    B P�� Q P k   ) = R R  S T S Z  ) 7 U V���� U =  ) . W X W o   ) *���� 0 currentstate currentState X n   * - Y Z Y 1   + -��
�� 
pcnt Z o   * +���� 0 stateenumref stateEnumRef V L   1 3 [ [ o   1 2���� 0 i  ��  ��   T  \�� \ r   8 = ] ^ ] [   8 ; _ ` _ o   8 9���� 0 i   ` m   9 :����  ^ o      ���� 0 i  ��  �� 0 stateenumref stateEnumRef Q J     a a  b c b m    ��
�� ePlSkPSS c  d e d m    ��
�� ePlSkPSP e  f�� f m    ��
�� ePlSkPSp��  ��  ��  ��   >  g�� g l  G I h i j h L   G I k k m   G H����   i  
 'unknown'    j � l l    ' u n k n o w n '��   ; m      m mr                                                                                      @ alis      SSD                            BD ����Spotify.app                                                    ����            ����  
 cu             Applications  /:Applications:Spotify.app/     S p o t i f y . a p p    S S D  Applications/Spotify.app  / ��   8 #  () -> NSNumber (PlayerState)    9 � n n :   ( )   - >   N S N u m b e r   ( P l a y e r S t a t e ) 4  o p o l     ��������  ��  ��   p  q r q l     ��������  ��  ��   r  s t s i    u v u I      �������� 0 	trackinfo 	trackInfo��  ��   v l    , w x y w O     , z { z Q    + | } ~ | L    !   n      � � � K   
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
pTrk } R      ���� �
�� .ascrerr ****      � ****��   � �� ���
�� 
errn � d       � � m      �������   ~ l  ) + � � � � l  ) + � � � � L   ) + � � m   ) *��
�� 
msng � 
  nil    � � � �    n i l � %  current track is not available    � � � � >   c u r r e n t   t r a c k   i s   n o t   a v a i l a b l e { m      � �r                                                                                      @ alis      SSD                            BD ����Spotify.app                                                    ����            ����  
 cu             Applications  /:Applications:Spotify.app/     S p o t i f y . a p p    S S D  Applications/Spotify.app  / ��   x S M () -> ["trackName":NSString, "trackArtist":NSString, "trackAlbum":NSString]?    y � � � �   ( )   - >   [ " t r a c k N a m e " : N S S t r i n g ,   " t r a c k A r t i s t " : N S S t r i n g ,   " t r a c k A l b u m " : N S S t r i n g ] ? t  � � � l     ��������  ��  ��   �  � � � i    � � � I      �������� 0 trackduration trackDuration��  ��   � l     � � � � O      � � � L     � � n    
 � � � 1    	��
�� 
pDur � 1    ��
�� 
pTrk � m      � �r                                                                                      @ alis      SSD                            BD ����Spotify.app                                                    ����            ����  
 cu             Applications  /:Applications:Spotify.app/     S p o t i f y . a p p    S S D  Applications/Spotify.app  / ��   � #  () -> NSNumber (Double, >=0)    � � � � :   ( )   - >   N S N u m b e r   ( D o u b l e ,   > = 0 ) �  � � � l     ��������  ��  ��   �  � � � l     ��������  ��  ��   �  � � � i    � � � I      �������� 0 soundvolume soundVolume��  ��   � l    
 � � � � O     
 � � � l   	 � � � � L    	 � � 1    ��
�� 
pVol � 5 / ASOC will convert returned integer to NSNumber    � � � � ^   A S O C   w i l l   c o n v e r t   r e t u r n e d   i n t e g e r   t o   N S N u m b e r � m      � �r                                                                                      @ alis      SSD                            BD ����Spotify.app                                                    ����            ����  
 cu             Applications  /:Applications:Spotify.app/     S p o t i f y . a p p    S S D  Applications/Spotify.app  / ��   � $  () -> NSNumber (Int, 0...100)    � � � � <   ( )   - >   N S N u m b e r   ( I n t ,   0 . . . 1 0 0 ) �  � � � l     ��������  ��  ��   �  � � � i     � � � I      �� ����� "0 setsoundvolume_ setSoundVolume_ �  ��� � o      ���� 0 	newvolume 	newVolume��  ��   � l     � � � � k      � �  � � � l     �� � ���   � K E ASOC does not convert NSObject parameters to AS types automatically�    � � � � �   A S O C   d o e s   n o t   c o n v e r t   N S O b j e c t   p a r a m e t e r s   t o   A S   t y p e s   a u t o m a t i c a l l y & �  ��� � O      � � � k     � �  � � � l   �� � ���   � V P �so be sure to coerce NSNumber to native integer before using it in Apple event    � � � � �   & s o   b e   s u r e   t o   c o e r c e   N S N u m b e r   t o   n a t i v e   i n t e g e r   b e f o r e   u s i n g   i t   i n   A p p l e   e v e n t �  ��� � r     � � � c     � � � o    ���� 0 	newvolume 	newVolume � m    ��
�� 
long � 1    
��
�� 
pVol��   � m      � �r                                                                                      @ alis      SSD                            BD ����Spotify.app                                                    ����            ����  
 cu             Applications  /:Applications:Spotify.app/     S p o t i f y . a p p    S S D  Applications/Spotify.app  / ��  ��   �   (NSNumber) -> ()    � � � � "   ( N S N u m b e r )   - >   ( ) �  � � � l     ��������  ��  ��   �  � � � l     ��������  ��  ��   �  � � � i  ! $ � � � I      �������� 0 	playpause 	playPause��  ��   � O    
 � � � I   	������
�� .spfyPlPsnull��� ��� null��  ��   � m      � �r                                                                                      @ alis      SSD                            BD ����Spotify.app                                                    ����            ����  
 cu             Applications  /:Applications:Spotify.app/     S p o t i f y . a p p    S S D  Applications/Spotify.app  / ��   �  � � � l     ��������  ��  ��   �  � � � i  % ( � � � I      ��~�}� 0 play  �~  �}   � O    
 � � � I   	�|�{�z
�| .spfyPlaynull��� ��� null�{  �z   � m      � �r                                                                                      @ alis      SSD                            BD ����Spotify.app                                                    ����            ����  
 cu             Applications  /:Applications:Spotify.app/     S p o t i f y . a p p    S S D  Applications/Spotify.app  / ��   �  � � � l     �y�x�w�y  �x  �w   �  � � � i  ) , � � � I      �v�u�t�v 	0 pause  �u  �t   � O    
 � � � I   	�s�r�q
�s .spfyPausnull��� ��� null�r  �q   � m      � �r                                                                                      @ alis      SSD                            BD ����Spotify.app                                                    ����            ����  
 cu             Applications  /:Applications:Spotify.app/     S p o t i f y . a p p    S S D  Applications/Spotify.app  / ��   �  � � � l     �p�o�n�p  �o  �n   �  � � � i  - 0 � � � I      �m�l�k�m 0 gotonexttrack gotoNextTrack�l  �k   � O    
 � � � I   	�j�i�h
�j .spfyNextnull��� ��� null�i  �h   � m       r                                                                                      @ alis      SSD                            BD ����Spotify.app                                                    ����            ����  
 cu             Applications  /:Applications:Spotify.app/     S p o t i f y . a p p    S S D  Applications/Spotify.app  / ��   �  l     �g�f�e�g  �f  �e    i  1 4 I      �d�c�b�d &0 gotoprevioustrack gotoPreviousTrack�c  �b   O    
 I   	�a�`�_
�a .spfyPrevnull��� ��� null�`  �_   m     		r                                                                                      @ alis      SSD                            BD ����Spotify.app                                                    ����            ����  
 cu             Applications  /:Applications:Spotify.app/     S p o t i f y . a p p    S S D  Applications/Spotify.app  / ��   
�^
 l     �]�\�[�]  �\  �[  �^   
 �Z l     �Y�X�W�Y  �X  �W  �Z       �V�V   �U�U 0 spotifybridge spotifyBridge �T �T 0 spotifybridge spotifyBridge  �S�R
�S misccura
�R 
pcls �  N S O b j e c t �Q�P�Q   �O�N�M�L�K�J�I�H�G�F�E�D
�O 
pare�N 0 	isrunning 	isRunning�M 0 playerstate playerState�L 0 	trackinfo 	trackInfo�K 0 trackduration trackDuration�J 0 soundvolume soundVolume�I "0 setsoundvolume_ setSoundVolume_�H 0 	playpause 	playPause�G 0 play  �F 	0 pause  �E 0 gotonexttrack gotoNextTrack�D &0 gotoprevioustrack gotoPreviousTrack�P   �C �B�A �@�C 0 	isrunning 	isRunning�B  �A       /�?
�? 
prun�@ ��,E �> 6�=�<!"�;�> 0 playerstate playerState�=  �<  ! �:�9�8�: 0 currentstate currentState�9 0 i  �8 0 stateenumref stateEnumRef" 
 m�7�6�5�4�3�2�1�0�/
�7 
prun
�6 
pPlS
�5 ePlSkPSS
�4 ePlSkPSP
�3 ePlSkPSp
�2 
kocl
�1 
cobj
�0 .corecnte****       ****
�/ 
pcnt�; K� G*�,E <*�,E�OkE�O ,���mv[��l kh ���,  �Y hO�kE�[OY��Y hOjU �. v�-�,#$�+�. 0 	trackinfo 	trackInfo�-  �,  #  $  ��*�)�(�'�&�%�$�#�"%�!
�* 
pTrk�) 0 	trackname 	trackName
�( 
pnam�' 0 trackartist trackArtist
�& 
pArt�% 0 
trackalbum 
trackAlbum
�$ 
pAlb�# �"  % � ��
�  
errn��@�  
�! 
msng�+ -� ) *�,�\[�,\�\[�,\�\[�,\Z�EW 	X 	 
�U � ���&'�� 0 trackduration trackDuration�  �  &  '  ���
� 
pTrk
� 
pDur� � 	*�,�,EU � ���()�� 0 soundvolume soundVolume�  �  (  )  ��
� 
pVol� � *�,EU � ���*+�� "0 setsoundvolume_ setSoundVolume_� �,� ,  �� 0 	newvolume 	newVolume�  * �� 0 	newvolume 	newVolume+  ���

� 
long
�
 
pVol� � 	��&*�,FU �	 ���-.��	 0 	playpause 	playPause�  �  -  .  ��
� .spfyPlPsnull��� ��� null� � *j U � ���/0�� 0 play  �  �  /  0  �� 
�  .spfyPlaynull��� ��� null� � *j U �� �����12���� 	0 pause  ��  ��  1  2  ���
�� .spfyPausnull��� ��� null�� � *j U �� �����34���� 0 gotonexttrack gotoNextTrack��  ��  3  4  ��
�� .spfyNextnull��� ��� null�� � *j U ������56���� &0 gotoprevioustrack gotoPreviousTrack��  ��  5  6 	��
�� .spfyPrevnull��� ��� null�� � *j Uascr  ��ޭ