# Valetudo CRL-200S root

This repository contains tooling to help with rooting 3irobotix CRL-200S-based vacuum robots such as

* Viomi V2
* viomi.vacuum.v8
* Cecotec Conga 3*90
* Proscenic M6 pro

**Warning**:<br/>
Unfortunately, there are some unresolved issues with the viomi.vacuum.v8.
If you have that robot, you might want to ask for assistance.

## Prerequisites

* a linux machine with a working `adb` install
* a good micro-USB cable (with data support)

## Usage instructions

⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️<br/>
**NOTE**:<br/>
**Currently, it's not possible to follow this guide as the tooling isn't finished. Please check back later**<br/>
⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️

<details>
  <summary>READ THE TEXT ABOVE</summary>

### 1. Find USB

Your robot has one or even two micro USB ports, which will be used for rooting.

<img src="./img/with_back_usb.jpg"/>

If your robot has a second micro USB port in the back like in the image above please make sure to use that.

<img src="./img/without_back_usb.jpg"/>

If however your robot looks like this then don't worry.
There is a second micro USB port in the battery compartment, which is easily accessible without destroying any warranty seals:

<img src="./img/battery_usb.jpg"/>

### 2. Check if ADB works

Now with the USB port located, turn on the robot and wait for it to boot up.

If you're only seeing the adb device show for a fraction of a second on boot and otherwise get `no devices found`, then step 3.1 is for you.
If you instead are already able to get a login shell using `adb shell` then go to 3.2.

### 3.1. Enable ADB access

Some robots (notably the Viomi V7) disable ADB access right after bootup.

To fix that, please download and run the `enable-adb.sh` found in the root directory of this repo.<br/>
After following its instructions, you should end up with a password-less rootshell via `adb shell`.

### 3.2. Change the root password

If running `adb shell` looks like this:
```
$ adb shell
TinaLinux login:
```

then simply create a file named `adb_shell` with these contents:

```
#!/bin/sh
export ENV='/etc/adb_profile'
exec /bin/sh "$@"
```

`chmod +x` that file and then `adb push ./adb_shell /bin/adb_shell`.

Now, running `adb shell` again should present you with a password-less rootshell.

### 4. Backups!

With a working ADB connection, now is the time to pull a backup of everything.<br/>
For that, simply run the following commands:

```
adb pull /proc/partitions

adb pull /dev/nanda
adb pull /dev/nandb
adb pull /dev/nandc
adb pull /dev/nandd
adb pull /dev/nande
adb pull /dev/nandf
adb pull /dev/nandg
adb pull /dev/nandh
adb pull /dev/nandi
```

If the partitions file contains even more nand partitions then also backup those!

### 5. Install Valetudo

First, head over to [the dustbuilder](https://builder.dontvacuum.me) and build a firmware package built for manual installation.<br/>
After downloading the `tar.gz` from the link in your email, simply push it to the robot like this:<br/>
`adb push ./<rooted_firmware_filename>.tar.gz /tmp/`

You will also need the latest Valetudo binary. Download it from here:<br/>
[https://github.com/Hypfer/Valetudo/releases/latest/download/valetudo-armv7.upx](https://github.com/Hypfer/Valetudo/releases/latest/download/valetudo-armv7.upx)

It is very important that the Valetudo binary is pushed to **the correct location** on the robot:<br/>
`adb push ./valetudo-armv7.upx /mnt/UDISK/valetudo`. 


With that done, the last required file is the convert-robot.sh script that can be found in ths repo:<br/>
`adb push ./convert-robot.sh /tmp/`

To finalize the rooting procedure, connect with `adb shell` and then run the following commands:
```
sh ./convert-robot.sh
tar xzvf ./<rooted_firmware_filename>.tar.gz
sh ./install.sh
```

If everything went well then your robot should now be running Valetudo.

As the next step, press and hold the two buttons until the robot informs you that Wi-Fi has been reset.<br/>
Then, continue with the [getting started guide](https://valetudo.cloud/pages/general/getting-started.html#joining_wifi).

</details>

## Credits

This tooling is based on knowledge and work by

- The initial Viomi research of @rumpeltux [Rooting the Xiaomi STYJ02YM (viomi-v7) Vacuum Robot](https://itooktheredpill.irgendwo.org/2020/rooting-xiaomi-vacuum-robot/)
- The [viomi-root](https://github.com/rumpeltux/viomi-rooting) repository by @rumpeltux and community
- Conga research by [the freeconga community](https://gitlab.com/freeconga/stuff/-/tree/master/docs)
