#!/bin/bash

function main() {
  for tool in adb; do
    which $tool > /dev/null || (echo "Please install $tool."; exit)
  done

  cat <<EOT

This script will help you enable ADB access to your Mi Vacuum Mop P

Please make sure of the following before starting:
1. Your robot is powered off
2. The battery is disconnected
3. You have a working micro-USB cable plugged into the robot and ready to plug into your computer.

Press [Enter] to continue

EOT
  read

  connect_adb

    cat <<EOT


The ADB shell should be fixed and permanent after the next reboot.
To get a shell, unplug and replug the USB cable once again. It won't say 'kaichi' this time.
After it has booted you should be able to connect via "adb shell".

Please note that the robot won't work in this state as we had to disable the core process to persist the adb shell.
This also means that it will reboot every four minutes which will be fixed after you've installed the rooted firmware image.

EOT

}

function connect_adb() {
  echo "We'll now try to connect to the ADB shell. Please connect the USB cable to your computer."
  echo "If you hear the Robot voice ('kaichi'), wait another two seconds and unplug and reconnect the cable."
  echo "If nothing happens try replugging the USB cable. This may take 10 or more attempts."

  fix_adb_shell
  echo "Shell fixed..."
  
  persist_adb_shell

  echo "Please replug the USB cable again. Do not unplug once you hear the sound."

  wait_for_adb_shell
  echo "Shell is present."
}

function adb_loop() {
  while true; do
    adb $@ | grep -v "no devices/emulators found" && break
  done
}

function fix_adb_shell() {
  cat >adb_shell <<"EOF"
#!/bin/sh
export ENV='/etc/adb_profile'
exec /bin/sh "$@"
EOF
  chmod +x adb_shell
  adb_loop push -a adb_shell /bin/adb_shell
}

function persist_adb_shell() {
  adb_loop shell rm /etc/rc.d/S90robotManager
}

function wait_for_adb_shell() {
  while true; do
    adb shell echo shell_is_ready 2>&1 | grep -v "no devices/emulators found" | grep "shell_is_ready" && break
  done
}

main
