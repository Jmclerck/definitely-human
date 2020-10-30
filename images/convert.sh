# directories
mkdir -p tmp
mkdir -p out

# originals
list=$(ls | rg -o "(\S*).jpeg" -r '$1')

# convert
for file in $list; do
  cwebp -q 50 $file.jpeg -o "./out/$file.webp"
done

# resize
for file in $list; do
  ffmpeg -i $file.jpeg -vf "scale=iw/3:ih/3"      "./tmp/$file@1x.jpeg" # 320x320 @1x
  ffmpeg -i $file.jpeg -vf "scale=iw/1.5:ih/1.5"  "./tmp/$file@2x.jpeg" # 640x640 @2x
  ffmpeg -i $file.jpeg -vf "scale=iw/1:ih/1"      "./tmp/$file@3x.jpeg" # 960x960 @3x
done

# copy / optimize
for file in $(ls tmp | rg -o "(\S*@\dx).jpeg" -r '$1'); do
  cjpeg -quality 50 "./tmp/$file.jpeg" > "./out/$file.jpeg"
done

# cleanup
rm -rf tmp
