#!/bin/sh
mac=$(cat /mnt/UDISK/config/device_config.ini | grep device_mac | cut -d"=" -f2 | sed -e "s/://g" | awk '{printf toupper($0)}')
did=$(echo "irrelevant" | awk 'BEGIN{srand();}{printf int(300000000 + 1 + rand() * 10000000)}')
cloudkey=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 16)

controller_ini="[Controller]\n
deep_clean_blower_speed=1.950000e+04\n
deep_clean_roll_speed=6.000000e-01\n
deep_clean_brush_speed=1.000000e+00\n
deep_clean_water_pump_speed=7.500000e-01\n
normal_clean_blower_speed=1.500000e+04\n
normal_clean_roll_speed=5.300000e-01\n
normal_clean_brush_speed=1.000000e+00\n
normal_clean_water_pump_speed=5.500000e-01\n
eco_clean_blower_speed=1.250000e+04\n
eco_clean_roll_speed=5.300000e-01\n
eco_clean_brush_speed=1.000000e+00\n
eco_clean_water_pump_speed=3.500000e-01\n
quiet_clean_blower_speed=1.120000e+04\n
quiet_clean_roll_speed=5.300000e-01\n
quiet_clean_brush_speed=1.000000e+00\n
quiet_clean_water_pump_speed=0.000000e+00\n
default_deep_blower_speed=1.749900e+04\n
default_normal_blower_speed=1.450000e+04\n
default_eco_blower_speed=1.150000e+04\n
default_quiet_blower_speed=0.000000e+00\n
spanish_deep_blower_speed=1.749900e+04\n
spanish_normal_blower_speed=1.550000e+04\n
spanish_eco_blower_speed=1.280000e+04\n
xiaomi_deep_blower_speed=2.065000e+04\n
xiaomi_normal_blower_speed=1.720000e+04\n
xiaomi_eco_blower_speed=1.450000e+04\n
xiaomi_quiet_blower_speed=1.150000e+04\n
max_clean_blower_speed=2.100000e+04\n"


if [ ! -f /mnt/SNN/ULI/factory/mac_value.txt ]; then
        echo "Missing mac_value.txt. Creating with $mac"
        echo -n "$mac" > /mnt/SNN/ULI/factory/mac_value.txt
fi

if [ ! -f /mnt/SNN/ULI/factory/did_value.txt ]; then
        echo "Missing did_value.txt. Creating with $did"
        echo -n "$did" > /mnt/SNN/ULI/factory/did_value.txt
fi

if [ ! -f /mnt/SNN/ULI/factory/device_key.txt ]; then
        echo "Missing device_key.txt. Creating with $cloudkey"
        echo -n "$cloudkey" > /mnt/SNN/ULI/factory/device_key.txt
fi


if [[ $(grep -L "xiaomi_normal_blower_speed" /mnt/UDISK/config/controller.ini) ]]; then
        echo "Missing viomi fan speeds in controller.ini. Creating backup and replacing with known good config"
        if [ -f /mnt/UDISK/config/controller.ini.bak ]; then
                echo "Error: Backup already exists. Aborting";
                exit 1
        fi

        cp /mnt/UDISK/config/controller.ini /mnt/UDISK/config/controller.ini.bak
        echo -e $controller_ini | awk '{$1=$1};1' > /mnt/UDISK/config/controller.ini
fi


if [ ! -f /mnt/UDISK/_root.sh ]; then
        echo "Missing boot hook script. Creating"

        echo '#!/bin/sh' > /mnt/UDISK/_root.sh
        echo " " >> /mnt/UDISK/_root.sh
        echo 'if [[ -f /mnt/UDISK/valetudo ]]; then' >> /mnt/UDISK/_root.sh
        echo -e '\tVALETUDO_CONFIG_PATH=/mnt/UDISK/valetudo_config.json /mnt/UDISK/valetudo > /dev/null 2>&1 &' >> /mnt/UDISK/_root.sh
        echo "fi" >> /mnt/UDISK/_root.sh

        chmod +x /mnt/UDISK/_root.sh
fi

if [ -f /mnt/UDISK/valetudo ]; then
        chmod +x /mnt/UDISK/valetudo
fi
