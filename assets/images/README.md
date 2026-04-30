# Running CENTI4.PAS in v86.sh

The images are built from already-existing online resources, and our Pascal file is added at the end.

We will use four image files on disk, and we set their filenames:

```shell
DOS_IMAGE=msdos622.img
TP6_IMAGE=turbo_pascal_6.img
BLANK_IMAGE=bootable-blank-dos.img
FINAL_IMAGE=teepee.img
```

Those are:
- Microsoft DOS 6.22 Installer
- Borland Turbo Pascal 6.6 installer (Disk 1)
- A bootable blank/minimal DOS image
- The final image we run in the browser

Download the images from the Internet Archive:

```shell
curl -LsS "https://archive.org/download/dos-622/DOS622-Disk1.img" -o $DOS_IMAGE

# TIL about `funzip`, and also TIL that `unzip` won't take a zip file from STDIN, but `funzip` (barely) works here, because the `.imz` zip archive only has one file: the disk image

curl -LsS "https://archive.org/download/borland-turbo-pascal-6.0-1990/Borland%20Turbo%20Pascal%206.0%201990%20Install.imz" |
    funzip > $TP6_IMAGE
```

The DOS image is an MS DOS 6.22 installer, but rather than running it, we'll just reuse the fact that it's bootable. We copy the base image, and then remove everything _except_ the files needed to boot: `IO.SYS`, `MSDOS.SYS`, and `COMMAND.COM`. Then we populate an `AUTOEXEC.BAT` file to have fun.

```shell
cp $DOS_IMAGE $BLANK_IMAGE
mdel -i $BLANK_IMAGE $(mdir -i $BLANK_IMAGE -b :: | grep -v '\(IO.SYS\|MSDOS.SYS\|COMMAND.COM\)')
echo -e "@echo off\r\necho Vintage hand-crafted bootable DOS image" | mcopy -i $BLANK_IMAGE - ::/AUTOEXEC.BAT
mdir -i $BLANK_IMAGE ::
```

Lastly, we make the image we want to run by taking the bootable blank image and the Turbo Pascal files extracted from the installer disk. We copy out `TURBO.ZIP` — which contains the files we need — then `unzip` (TIL `unzip` takes a `-p` param to output the extracted file to `STDOUT`) and `mcopy` into the image.

```shell
cp $BLANK_IMAGE $FINAL_IMAGE

mcopy -i $TP6_IMAGE ::/TURBO.ZIP .
unzip -p TURBO.ZIP TURBO.EXE | mcopy -Do -i $FINAL_IMAGE - ::/TURBO.EXE
unzip -p TURBO.ZIP TURBO.TPL | mcopy -Do -i $FINAL_IMAGE - ::/TURBO.TPL
unzip -p TURBO.ZIP TPC.EXE | mcopy -Do -i $FINAL_IMAGE - ::/TPC.EXE

mdir -i $FINAL_IMAGE ::
```

Very-lastly, we copy the source files in, and replace `AUTOEXEC.BAT` with invoking the IDE on the source file on boot.

```shell
mcopy -i $FINAL_IMAGE ../CENTI4.PAS ::/CENTI4.PAS
mcopy -i $FINAL_IMAGE ../CURSOR.BLK ::/CURSOR.BLK

echo -e "@echo off\r\nTURBO CENTI4.PAS" | mcopy -i $FINAL_IMAGE -D o - ::/AUTOEXEC.BAT
```

Ultimately-lastly, clone the source file, and enable starting in "demo" mode. Then, change the `AUTOEXEC.BAT` to compile and run that modified file on boot instead, so the image now loads directly into the game running in demo mode.

```shell
mcopy -i teepee.img ::/CENTI4.PAS - |
  LC_ALL=C sed -E 's/S_Demo([[:space:]]+)= False/S_Demo\1= True/ig' |
  mcopy -i teepee.img - ::/CENTDEMO.PAS

echo -e "@echo off\r\nTPC CENTDEMO.PAS\r\nCENTDEMO" | mcopy -i teepee.img -D o - ::/AUTOEXEC.BAT
```

Supercedingly-lastly, we use more images to hack-together the ability to change the behaviour from the browser. Specifically, query-string parameters can modify which image is mounted as the B: drive, and then we can switch execution based on the contents of that drive.

We have certain "tags", for different behaviour: running the original game as-is (`RUN` or `PLAY`), editing the source file (`EDIT`), or running the (modified-source) game in "demo mode" (`DEMO`).

Create the image files, using `dd`/`mformat` settings to minimise the image size (apparently 160kb is the minimal _reliable_ size for a FAT volume); creating a file named after the tag (e.g. `DEMO.TAG`) in the root:
```shell
for tag in run play edit demo; do
  name=tag_${tag}
  dd if=/dev/zero of=${name}.img bs=512 count=320
  mformat -i ${name}.img -f 160 ::
  echo -n "" | mcopy -i ${name}.img - ::${tag:u}.TAG
done
```

Then we use the pre-baked `AUTOEXEC.BAT` to switch execution based on which image is mounted. Shortened sample, below:

```shell
IF EXIST B:EDIT.TAG GOTO EDIT
IF EXIST B:DEMO.TAG GOTO DEMO
GOTO DEMO

:EDIT
TURBO CENTI4.PAS
GOTO END

:DEMO
TPC CENTDEMO.PAS
CENTDEMO.EXE
GOTO END

:END
```

So we copy it in, and then we can use `?demo` and `?edit`, etc., in the URL:
```shell
mcopy -i $FINAL_IMAGE -D o TAGGED_AUTOEXEC.BAT ::/AUTOEXEC.BAT
```
