from gtts import gTTS
import os

tts1 = gTTS('Menino', lang='pt', tld='com.br')
tts1.save('assets/audios/menino.mp3')

tts2 = gTTS('Menina', lang='pt', tld='com.br')
tts2.save('assets/audios/menina.mp3')

tts3 = gTTS('Arraste a escova até a sílaba correta para escovar o dente.', lang='pt', tld='com.br')
tts3.save('assets/audios/tela_do_jogo_novo.mp3')
