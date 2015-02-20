require 'rubygems'
require 'streamio-ffmpeg'
require 'wavefile'
include WaveFile

# 1-save all text in mp3 files; 2-convert all files to wave; 3-append all files

text_1 = "Olá, tudo bem?"
text_2 = "Tudo! E você?"
text_3 = "Também!"

array_text = [text_1, text_2, text_3]

for text in 0 .. 2
  system("wget", "-q", "-U", "Mozilla", "-O", text.to_s+".mp3", "http://translate.google.com/translate_tts?ie=UTF-8&tl=pt-br&q=" + array_text[text].to_s)
  system("ffmpeg","-i",text.to_s+".mp3",text.to_s+".wav")
  system("rm",text.to_s+".mp3")
end

#ffmpeg -i oh_darling.wav output.mp3

FILES_TO_APPEND = ["0.wav","1.wav","2.wav"]

SAMPLES_PER_BUFFER = 4096

Writer.new("append.wav", Format.new(:stereo, :pcm_16, 16000)) do |writer|
  FILES_TO_APPEND.each do |file_name|
    Reader.new(file_name).each_buffer(SAMPLES_PER_BUFFER) do |buffer|
      writer.write(buffer)
    end
  end
end
