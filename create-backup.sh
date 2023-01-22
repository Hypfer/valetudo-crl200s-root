#!/bin/bash -e

backup_folder="backup"

mkdir -p $backup_folder
pushd $backup_folder

adb pull /proc/partitions

partitions=$(awk -F ' ' 'NR>2 {print $4}' partitions)
partition_count=$(< partitions wc -l)

echo "Pulling ${partition_count} partition/s:"
for partition in $partitions; do
	partition_path="/dev/${partition}"
	echo "Pulling partition: $partition_path"
	adb pull "$partition_path"
done

popd

tarfile="${backup_folder}.tar.gz"

echo "Archiving backup/ folder into ${tarfile}"
tar -czvf $tarfile $backup_folder