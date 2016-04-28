From: Andread Mayrhoff <repro@spoilbase.eu>
Subject: Re: Help needed: array inactive after grow attempt
Date: Thu, 28 Apr 2016 22:02:39 +0200
Message-ID: <e7110adb04c7319afd4ae4ee856e4bec@spoilbase.eu>
References: <1d5a8c36a6802a9e7e32eb056165f200@spoilbase.eu>
 <7cfbdd22b8c20acdb95fababfa1a04a6@spoilbase.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7cfbdd22b8c20acdb95fababfa1a04a6@spoilbase.eu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Some more info:

/dev/sdb1:
           Magic : a92b4efc
         Version : 1.0
     Feature Map : 0x5
      Array UUID : b120f4d9:d1ba5648:e1359c5d:7a36372e
            Name : n54l:raid5.11111111.eu
   Creation Time : Sat Aug 31 10:09:28 2013
      Raid Level : raid5
    Raid Devices : 6

  Avail Dev Size : 5859448552 (2794.00 GiB 3000.04 GB)
      Array Size : 14648584960 (13969.98 GiB 15000.15 GB)
   Used Dev Size : 5859433984 (2794.00 GiB 3000.03 GB)
    Super Offset : 5859448816 sectors
    Unused Space : before=0 sectors, after=14816 sectors
           State : clean
     Device UUID : 1f97ccdb:5d734f5a:69ec1e62:4b767bd1

Internal Bitmap : -16 sectors from superblock
   Reshape pos'n : 0
   Delta Devices : 1 (5->6)

     Update Time : Thu Apr 28 19:51:47 2016
   Bad Block Log : 512 entries available at offset -8 sectors
        Checksum : 9cee067c - correct
          Events : 60868

          Layout : left-symmetric
      Chunk Size : 128K

    Device Role : Active device 0
    Array State : AAAAAA ('A' == active, '.' == missing, 'R' == 
replacing)
/dev/sdc1:
           Magic : a92b4efc
         Version : 1.0
     Feature Map : 0x5
      Array UUID : b120f4d9:d1ba5648:e1359c5d:7a36372e
            Name : n54l:raid5.11111111.eu
   Creation Time : Sat Aug 31 10:09:28 2013
      Raid Level : raid5
    Raid Devices : 6

  Avail Dev Size : 5859448552 (2794.00 GiB 3000.04 GB)
      Array Size : 14648584960 (13969.98 GiB 15000.15 GB)
   Used Dev Size : 5859433984 (2794.00 GiB 3000.03 GB)
    Super Offset : 5859448816 sectors
    Unused Space : before=0 sectors, after=14816 sectors
           State : clean
     Device UUID : c0d6ef32:c96f2287:c28a747e:3dd7ac5e

Internal Bitmap : -16 sectors from superblock
   Reshape pos'n : 0
   Delta Devices : 1 (5->6)

     Update Time : Thu Apr 28 19:51:47 2016
   Bad Block Log : 512 entries available at offset -8 sectors
        Checksum : ca6b41e2 - correct
          Events : 60868

          Layout : left-symmetric
      Chunk Size : 128K

    Device Role : Active device 1
    Array State : AAAAAA ('A' == active, '.' == missing, 'R' == 
replacing)
/dev/sdd1:
           Magic : a92b4efc
         Version : 1.0
     Feature Map : 0x5
      Array UUID : b120f4d9:d1ba5648:e1359c5d:7a36372e
            Name : n54l:raid5.11111111.eu
   Creation Time : Sat Aug 31 10:09:28 2013
      Raid Level : raid5
    Raid Devices : 6

  Avail Dev Size : 5859448552 (2794.00 GiB 3000.04 GB)
      Array Size : 14648584960 (13969.98 GiB 15000.15 GB)
   Used Dev Size : 5859433984 (2794.00 GiB 3000.03 GB)
    Super Offset : 5859448816 sectors
    Unused Space : before=0 sectors, after=14816 sectors
           State : clean
     Device UUID : 935f90f7:4b0dc9d7:f66aa9d6:20d11f62

Internal Bitmap : -16 sectors from superblock
   Reshape pos'n : 0
   Delta Devices : 1 (5->6)

     Update Time : Thu Apr 28 19:51:47 2016
   Bad Block Log : 512 entries available at offset -8 sectors
        Checksum : 3b5a4242 - correct
          Events : 60868

          Layout : left-symmetric
      Chunk Size : 128K

    Device Role : Active device 2
    Array State : AAAAAA ('A' == active, '.' == missing, 'R' == 
replacing)
/dev/sde1:
           Magic : a92b4efc
         Version : 1.0
     Feature Map : 0x5
      Array UUID : b120f4d9:d1ba5648:e1359c5d:7a36372e
            Name : n54l:raid5.11111111.eu
   Creation Time : Sat Aug 31 10:09:28 2013
      Raid Level : raid5
    Raid Devices : 6

  Avail Dev Size : 5859448552 (2794.00 GiB 3000.04 GB)
      Array Size : 14648584960 (13969.98 GiB 15000.15 GB)
   Used Dev Size : 5859433984 (2794.00 GiB 3000.03 GB)
    Super Offset : 5859448816 sectors
    Unused Space : before=0 sectors, after=14816 sectors
           State : clean
     Device UUID : 8a681fff:9c9fea74:5fa541e0:d3903bfe

Internal Bitmap : -16 sectors from superblock
   Reshape pos'n : 0
   Delta Devices : 1 (5->6)

     Update Time : Thu Apr 28 19:51:47 2016
   Bad Block Log : 512 entries available at offset -8 sectors
        Checksum : 85bed7a3 - correct
          Events : 60868

          Layout : left-symmetric
      Chunk Size : 128K

    Device Role : Active device 3
    Array State : AAAAAA ('A' == active, '.' == missing, 'R' == 
replacing)
/dev/sdf1:
           Magic : a92b4efc
         Version : 1.0
     Feature Map : 0x5
      Array UUID : b120f4d9:d1ba5648:e1359c5d:7a36372e
            Name : n54l:raid5.11111111.eu
   Creation Time : Sat Aug 31 10:09:28 2013
      Raid Level : raid5
    Raid Devices : 6

  Avail Dev Size : 5859448552 (2794.00 GiB 3000.04 GB)
      Array Size : 14648584960 (13969.98 GiB 15000.15 GB)
   Used Dev Size : 5859433984 (2794.00 GiB 3000.03 GB)
    Super Offset : 5859448816 sectors
    Unused Space : before=0 sectors, after=14816 sectors
           State : clean
     Device UUID : 7ab63bf4:aaf2b5fb:7e4ced0f:5942004e

Internal Bitmap : -16 sectors from superblock
   Reshape pos'n : 0
   Delta Devices : 1 (5->6)

     Update Time : Thu Apr 28 19:51:47 2016
   Bad Block Log : 512 entries available at offset -8 sectors
        Checksum : 8116d149 - correct
          Events : 60868

          Layout : left-symmetric
      Chunk Size : 128K

    Device Role : Active device 4
    Array State : AAAAAA ('A' == active, '.' == missing, 'R' == 
replacing)
/dev/sdg1:
           Magic : a92b4efc
         Version : 1.0
     Feature Map : 0x5
      Array UUID : b120f4d9:d1ba5648:e1359c5d:7a36372e
            Name : n54l:raid5.11111111.eu
   Creation Time : Sat Aug 31 10:09:28 2013
      Raid Level : raid5
    Raid Devices : 6

  Avail Dev Size : 5859448552 (2794.00 GiB 3000.04 GB)
      Array Size : 14648584960 (13969.98 GiB 15000.15 GB)
   Used Dev Size : 5859433984 (2794.00 GiB 3000.03 GB)
    Super Offset : 5859448816 sectors
    Unused Space : before=0 sectors, after=14816 sectors
           State : clean
     Device UUID : 49b2e0e8:dff3e0c7:15184780:0ff9f26d

Internal Bitmap : -16 sectors from superblock
   Reshape pos'n : 0
   Delta Devices : 1 (5->6)

     Update Time : Thu Apr 28 19:51:47 2016
   Bad Block Log : 512 entries available at offset -8 sectors
        Checksum : d233509b - correct
          Events : 60868

          Layout : left-symmetric
      Chunk Size : 128K

    Device Role : Active device 5
    Array State : AAAAAA ('A' == active, '.' == missing, 'R' == 
replacing)


> I might add
> 
> ~/tmp # mdadm --stop /dev/md127
> mdadm: stopped /dev/md127
> ~/tmp # mdadm --assemble --scan
> mdadm: Failed to restore critical section for reshape, sorry.
>        Possibly you needed to specify the --backup-file
> 
> Thanks for helping me out of this...
> 
>> Hello,
>> 
>> I believe I need some help from an mdadm expert.
>> 
>> I tried to add a disk to an existing RAID5-array (/dev/md127) that
>> consisted of 5 disks: /dev/sd[bcdef]1
>> The system is a 4.5.2-2-kernel, x86_64-architecture, mdadm 3.3.1.
>> I attempted to add partition /dev/sdg1 to that array, in an attempt to
>> create a 6-disk-RAID5-array.
>> To achieve that goal, I typed "mdadm --add /dev/md127 /dev/sdg1".
>> As I found that working, I attempted to grow the array by typing
>> "mdadm --grow /dev/md127 --raid-devices=6".
>> 
>> I left my machine, and when I returned, I found it had been switched
>> off by my... ahem, anyway, it had been switched off.
>> 
>> I powered it on again, "cat /proc/mdstat" returned
>> 
>>>> 
>> Personalities : [raid6] [raid5] [raid4]
>> md127 : inactive sdg1[9](S) sdf1[8](S) sdc1[5](S) sdb1[6](S)
>> sde1[4](S) sdd1[7](S)
>>       17578345656 blocks super 1.0
>> 
>> unused devices: <none>
>> <<
>> 
>> mdadm --detail /dev/md127 returns
>> 
>>>> 
>> /dev/md127:
>>         Version : 1.0
>>      Raid Level : raid0
>>   Total Devices : 6
>>     Persistence : Superblock is persistent
>> 
>>           State : inactive
>> 
>>   Delta Devices : 1, (-1->0)
>>       New Level : raid5
>>      New Layout : left-symmetric
>>   New Chunksize : 128K
>> 
>>            Name : n54l:raid5.11111111.eu
>>            UUID : b120f4d9:d1ba5648:e1359c5d:7a36372e
>>          Events : 60868
>> 
>>     Number   Major   Minor   RaidDevice
>> 
>>        -       8       17        -        /dev/sdb1
>>        -       8       33        -        /dev/sdc1
>>        -       8       49        -        /dev/sdd1
>>        -       8       65        -        /dev/sde1
>>        -       8       81        -        /dev/sdf1
>>        -       8       97        -        /dev/sdg1
>> <<
>> 
>> Now, before I do anything extreme like unplugging that disk again or
>> forcing a recreate, could an expert suggest the next logical step I
>> should do. I know this sounds pretty defensive, but rather than
>> playing "Raid-hero with an erased set of disks" I'd go along with
>> "Raid-idiot that needed experts' advice which is why he still's got
>> all his data".
>> 
>> Thanks for your advice!
>> 
>> 
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" 
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" 
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

