From: Stone <stone@heisl.org>
Subject: Re: Brocken Raid & LUKS
Date: Fri, 22 Feb 2013 23:42:39 +0100
Message-ID: <5127F45F.5020608@heisl.org>
References: <5123A1CC.2000003@heisl.org> <51262CE0.3000809@heisl.org> <51263785.2010001@turmel.org> <51263D9D.1080002@heisl.org> <51263F7E.7040207@turmel.org> <5126421E.3040702@turmel.org> <51264C18.8000201@heisl.org> <51264E26.9050100@turmel.org> <51264EBF.9090000@heisl.org> <51264F7F.3020508@turmel.org> <512650A1.7070103@heisl.org> <51265132.7070706@turmel.org> <512656B5.4090505@heisl.org> <51265824.4030407@heisl.org> <51265B0B.9020108@turmel.org> <51265DA7.2030209@heisl.org> <512660B9.8090609@turmel.org> <5126629A.1090002@heisl.org> <51266360.9030402@turmel.org> <5126678D.9030101@heisl.org> <51266D73.5020700@turmel.org> <51267192.6090205@heisl.org> <51267467.9040603@turmel.org> <512675A6.1000801@heisl.org> <5126797C.8090105@heisl.org> <51269DE0.5070905@heisl.org> <512748FA.2000709@heisl
 .org> <51277876.30008@turmel.org> <51278793.80904@heisl.org> <512790AE.2080102@turmel.org> <5127B64A.3000808@heisl.org> <5127D857.9090204@heisl.org> <5127F2B8.4050601@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5127F2B8.4050601@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Am 22.02.2013 23:35, schrieb Phil Turmel:
> On 02/22/2013 03:43 PM, Stone wrote:
>> so hello again.
>> the script was running and i looked at my logs.
>>
>> this results i have
>> with chunk-size 8,16,32,64,128 i have always the same error: Enter
>> passphrase for /dev/md2: No key available with this passphrase.
>>
>> the first time to open it is possible with chunk 256
>>
>> i send you some logs from 256 and 512
>>
>> at 512 i get the first results with checksum errors.
>> i think the right size is 512?! but the filesystem is brocken?!
> Damage near the beginning of your filesystem is expected, remember?
> Lots of damage further in is not expected, once we have the right settings.
>
> Very interesting.  Especially this with sdb-sdc-missing-sde:
>
>> The filesystem size (according to the superblock) is 1465134336 blocks
>> The physical size of the device is 1465133568 blocks
>> Either the superblock or the partition table is likely to be corrupt!
>> Abort? no
>
> I think this is the right device order, and the right chunk size.  It
> also best matches what we know of your original setup.  But the total
> size of the array device is 768 blocks smaller than it should be.  This
> should be solved.
>
> Please recreate the array with this combination, then show:
>
> mdadm -D /dev/md2
> mdadm -E /dev/sd[bce]1
> cat /proc/partitions
> for x in /dev/sd[bce] ; do fdisk -l $x ; done
>
> Phil

i dont know what chunk do you what but i think you mean 512k

mdadm --create /dev/md2 --assume-clean --chunk=512 --verbose --level=5 
--raid-devices=4 /dev/sdb1 /dev/sdc1 missing /dev/sde1
mdadm: layout defaults to left-symmetric
mdadm: layout defaults to left-symmetric
mdadm: layout defaults to left-symmetric
mdadm: /dev/sdb1 appears to be part of a raid array:
     level=raid5 devices=4 ctime=Fri Feb 22 21:30:55 2013
mdadm: layout defaults to left-symmetric
mdadm: /dev/sdc1 appears to be part of a raid array:
     level=raid5 devices=4 ctime=Fri Feb 22 21:30:55 2013
mdadm: layout defaults to left-symmetric
mdadm: /dev/sde1 appears to be part of a raid array:
     level=raid5 devices=4 ctime=Fri Feb 22 21:30:55 2013
mdadm: size set to 1953511936K
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md2 started


mdadm -E /dev/sd[bce]1
/dev/sdb1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 63da1137:ee45cd1f:72935645:398569ae
            Name : ubuntu:2  (local to host ubuntu)
   Creation Time : Fri Feb 22 23:40:12 2013
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 3907027037 (1863.02 GiB 2000.40 GB)
      Array Size : 11721071616 (5589.04 GiB 6001.19 GB)
   Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 76d36328:32020f15:893f4962:f1cf0e7a

     Update Time : Fri Feb 22 23:40:12 2013
        Checksum : 225b2e91 - correct
          Events : 0

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 0
    Array State : AA.A ('A' == active, '.' == missing)
/dev/sdc1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 63da1137:ee45cd1f:72935645:398569ae
            Name : ubuntu:2  (local to host ubuntu)
   Creation Time : Fri Feb 22 23:40:12 2013
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 3907024896 (1863.01 GiB 2000.40 GB)
      Array Size : 11721071616 (5589.04 GiB 6001.19 GB)
   Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 5bb7b565:81820027:695dad8b:e3d97352

     Update Time : Fri Feb 22 23:40:12 2013
        Checksum : 7367b23b - correct
          Events : 0

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 1
    Array State : AA.A ('A' == active, '.' == missing)
/dev/sde1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 63da1137:ee45cd1f:72935645:398569ae
            Name : ubuntu:2  (local to host ubuntu)
   Creation Time : Fri Feb 22 23:40:12 2013
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 3907027037 (1863.02 GiB 2000.40 GB)
      Array Size : 11721071616 (5589.04 GiB 6001.19 GB)
   Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : e016452e:6e86b9fa:27b46b87:08484e32

     Update Time : Fri Feb 22 23:40:12 2013
        Checksum : eb48e2ef - correct
          Events : 0

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 3
    Array State : AA.A ('A' == active, '.' == missing)


/proc/partitions
major minor  #blocks  name

    8        0  244198584 sda
    8        1     248832 sda1
    8        2          1 sda2
    8        5  243947520 sda5
  252        0  235589632 dm-0
  252        1    8351744 dm-1
    8       16 1953514584 sdb
    8       17 1953514542 sdb1
    8       32 1953514584 sdc
    8       33 1953513472 sdc1
    8       48 1953514584 sdd
    8       49 1953514542 sdd1
    8       64 1953514584 sde
    8       65 1953514542 sde1
    9        2 5860535808 md2



for x in /dev/sd[bce] ; do fdisk -l $x ; done

WARNING: GPT (GUID Partition Table) detected on '/dev/sdb'! The util 
fdisk doesn't support GPT. Use GNU Parted.


Disk /dev/sdb: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

    Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1  3907029167  1953514583+  ee  GPT

WARNING: GPT (GUID Partition Table) detected on '/dev/sdc'! The util 
fdisk doesn't support GPT. Use GNU Parted.


Disk /dev/sdc: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

    Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1  3907029167  1953514583+  ee  GPT

WARNING: GPT (GUID Partition Table) detected on '/dev/sde'! The util 
fdisk doesn't support GPT. Use GNU Parted.


Disk /dev/sde: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

    Device Boot      Start         End      Blocks   Id  System
/dev/sde1               1  3907029167  1953514583+  ee  GPT

