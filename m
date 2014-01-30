From: Yorik <yoriks13@westnet.com.au>
Subject: RAIS5 Rebuild Help - Possible Data Offset
Date: Thu, 30 Jan 2014 22:20:45 +0800
Message-ID: <CAFth78x1SkCEUmETFt+F+79UpjUbhanNLUbZoWa7Hxi3EzsdMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello

Sorry if double post had to remove some HTML.

I've been using "mdadm" for about 8-9 years with a lot of success in
different Array configurations. I am a huge fan of Software RAID. I
recently suffered a failure that was very unfortunate and I now have
an issue with differing Data Offset and other issues preventing my
Array from rebuilding. A brief history follows:

Array originally created as RAID5, 3x 3TB Drives in May 2011 on a
(then) latest Fedora build.
Added more drives in 2012 and 2013 with upgraded Fedora builds.
Recently added another drive and changed to RAID6, 6x6TB Drives.
Suffered a failure shortly after 2 more drives that kicked the last 2
drives off and one of the 6 other that were previously running.
During the RAID rebuild, my computer locked up and then suffered a
Power Failure (having a bad day) that stopped my OS Disk (SSD) from
allowing me to reboot. Eventually rebuilt the OS with Fedora 20,
wiping the majority of the SSD and config files with it.

The RAID6 does not start, stating that it only has 5 of the 8 drives
required. Looking into this, the drives seem to be clean and check
okay, but there is even differences (expected) and Data Offset
difference between drives that I read (Neil Brown Blog date
-20120615073245) was not necessarily good for rebuilding and that I
should ask for a version of mdadm that can handle this as it's
possible that creating with an older version, then adding new drives
is causing an issue. Data Offsets of 2048 and 4096 exist.

Also of note is that I have some drives that are on the Array without
partitions as they would not add to the Array with partitions on them
due to size when they were added. I think that I had version issue
with fdisk, but it seemed to work okay until now.

When I run the following command:

mdadm --create --assume-clean --level=6 --raid-devices=8
--size=2930263552 /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd
/dev/sdi /dev/sde /dev/sdg /dev/sdf

I get:

mdadm: /dev/sda1 is smaller than given size. 2930134016K < 2930263552K
+ metadata
mdadm: /dev/sdb1 is smaller than given size. 2930134016K < 2930263552K
+ metadata
mdadm: /dev/sdc1 is smaller than given size. 2930134016K < 2930263552K
+ metadata
mdadm: /dev/sdd is smaller than given size. 2930135040K < 2930263552K + metadata
mdadm: /dev/sdi is smaller than given size. 2930135040K < 2930263552K + metadata
mdadm: /dev/sde is smaller than given size. 2930135040K < 2930263552K + metadata
mdadm: /dev/sdg is smaller than given size. 2930135040K < 2930263552K + metadata
mdadm: /dev/sdf is smaller than given size. 2930135040K < 2930263552K + metadata
mdadm: create aborted

Which makes me think that there are further issues. Should I be
looking for an older version of mdadm or a different version? Can
anyone offer some advice please or where to look next.

Regards
Derek

Information follows:

--Drive information--
mdadm --examine <Appropriate partitions and drives>
/dev/sda1:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x5
     Array UUID : 80009fa3:a96743bd:f5dbfd87:18a1c52d
           Name : desktop:0
  Creation Time : Tue May 31 01:55:34 2011
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 5860528128 (2794.52 GiB 3000.59 GB)
     Array Size : 17581581312 (16767.10 GiB 18003.54 GB)
  Used Dev Size : 5860527104 (2794.52 GiB 3000.59 GB)
    Data Offset : 2048 sectors
   Super Offset : 0 sectors
   Unused Space : before=1976 sectors, after=1024 sectors
          State : clean
    Device UUID : e27f0cdd:f9ade1a9:069a8d4d:a4e7d767

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 30978048 (29.54 GiB 31.72 GB)
  Delta Devices : 2 (6->8)

    Update Time : Tue Jan 21 23:35:32 2014
       Checksum : 944933 - correct
         Events : 3118496

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAA.A.. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x5
     Array UUID : 80009fa3:a96743bd:f5dbfd87:18a1c52d
           Name : desktop:0
  Creation Time : Tue May 31 01:55:34 2011
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 5860528128 (2794.52 GiB 3000.59 GB)
     Array Size : 17581581312 (16767.10 GiB 18003.54 GB)
  Used Dev Size : 5860527104 (2794.52 GiB 3000.59 GB)
    Data Offset : 2048 sectors
   Super Offset : 0 sectors
   Unused Space : before=1976 sectors, after=1024 sectors
          State : active
    Device UUID : ff0ddbdd:5d3123ae:3b813125:97a96017

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 30978048 (29.54 GiB 31.72 GB)
  Delta Devices : 2 (6->8)

    Update Time : Tue Jan 21 23:35:32 2014
       Checksum : 8cd103dc - correct
         Events : 3118496

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAA.A.. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x5
     Array UUID : 80009fa3:a96743bd:f5dbfd87:18a1c52d
           Name : desktop:0
  Creation Time : Tue May 31 01:55:34 2011
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 5860528128 (2794.52 GiB 3000.59 GB)
     Array Size : 17581581312 (16767.10 GiB 18003.54 GB)
  Used Dev Size : 5860527104 (2794.52 GiB 3000.59 GB)
    Data Offset : 2048 sectors
   Super Offset : 0 sectors
   Unused Space : before=1976 sectors, after=1024 sectors
          State : active
    Device UUID : f4106804:6552a7b0:2a960408:b7ca41ff

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 30978048 (29.54 GiB 31.72 GB)
  Delta Devices : 2 (6->8)

    Update Time : Tue Jan 21 23:35:32 2014
       Checksum : 80965de9 - correct
         Events : 3118496

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAA.A.. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdd:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x5
     Array UUID : 80009fa3:a96743bd:f5dbfd87:18a1c52d
           Name : desktop:0
  Creation Time : Tue May 31 01:55:34 2011
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 5860529072 (2794.52 GiB 3000.59 GB)
     Array Size : 17581581312 (16767.10 GiB 18003.54 GB)
  Used Dev Size : 5860527104 (2794.52 GiB 3000.59 GB)
    Data Offset : 4096 sectors
   Super Offset : 0 sectors
   Unused Space : before=4024 sectors, after=1968 sectors
          State : active
    Device UUID : d9d26a74:100488a7:8841e37a:f84e07b7

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 30978048 (29.54 GiB 31.72 GB)
  Delta Devices : 2 (6->8)

    Update Time : Tue Jan 21 23:35:32 2014
       Checksum : 121e0ccb - correct
         Events : 3118496

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAA.A.. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sde:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x5
     Array UUID : 80009fa3:a96743bd:f5dbfd87:18a1c52d
           Name : desktop:0
  Creation Time : Tue May 31 01:55:34 2011
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 5860529072 (2794.52 GiB 3000.59 GB)
     Array Size : 17581581312 (16767.10 GiB 18003.54 GB)
  Used Dev Size : 5860527104 (2794.52 GiB 3000.59 GB)
    Data Offset : 4096 sectors
   Super Offset : 0 sectors
   Unused Space : before=4024 sectors, after=1968 sectors
          State : active
    Device UUID : a73e6b7b:4791f3d6:b60e1025:0dda98c1

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 30978048 (29.54 GiB 31.72 GB)
  Delta Devices : 2 (6->8)

    Update Time : Tue Jan 21 23:35:32 2014
       Checksum : fd485e13 - correct
         Events : 3118496

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 5
   Array State : AAAA.A.. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdf:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x5
     Array UUID : 80009fa3:a96743bd:f5dbfd87:18a1c52d
           Name : desktop:0
  Creation Time : Tue May 31 01:55:34 2011
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 5860529072 (2794.52 GiB 3000.59 GB)
     Array Size : 17581581312 (16767.10 GiB 18003.54 GB)
  Used Dev Size : 5860527104 (2794.52 GiB 3000.59 GB)
    Data Offset : 4096 sectors
   Super Offset : 0 sectors
   Unused Space : before=4024 sectors, after=1968 sectors
          State : clean
    Device UUID : 25acca8d:45ae78df:77d834cb:b97cfadd

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 30978048 (29.54 GiB 31.72 GB)
  Delta Devices : 2 (6->8)

    Update Time : Tue Jan 21 23:26:20 2014
       Checksum : daba52df - correct
         Events : 3118491

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 7
   Array State : AAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdg:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x5
     Array UUID : 80009fa3:a96743bd:f5dbfd87:18a1c52d
           Name : desktop:0
  Creation Time : Tue May 31 01:55:34 2011
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 5860529072 (2794.52 GiB 3000.59 GB)
     Array Size : 17581581312 (16767.10 GiB 18003.54 GB)
  Used Dev Size : 5860527104 (2794.52 GiB 3000.59 GB)
    Data Offset : 4096 sectors
   Super Offset : 0 sectors
   Unused Space : before=4024 sectors, after=1968 sectors
          State : clean
    Device UUID : c4fca7c8:450ddd64:41aae795:334c9512

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 30978048 (29.54 GiB 31.72 GB)
  Delta Devices : 2 (6->8)

    Update Time : Tue Jan 21 23:26:20 2014
       Checksum : 9a49a3c2 - correct
         Events : 3118491

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 6
   Array State : AAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdi:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x5
     Array UUID : 80009fa3:a96743bd:f5dbfd87:18a1c52d
           Name : desktop:0
  Creation Time : Tue May 31 01:55:34 2011
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 5860529072 (2794.52 GiB 3000.59 GB)
     Array Size : 17581581312 (16767.10 GiB 18003.54 GB)
  Used Dev Size : 5860527104 (2794.52 GiB 3000.59 GB)
    Data Offset : 4096 sectors
   Super Offset : 0 sectors
   Unused Space : before=4024 sectors, after=1968 sectors
          State : clean
    Device UUID : 09f19ee9:414e5ea8:b755a246:a0a2c2f7

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 30978048 (29.54 GiB 31.72 GB)
  Delta Devices : 2 (6->8)

    Update Time : Tue Jan 21 23:26:20 2014
       Checksum : 94a9dae5 - correct
         Events : 3118491

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

--Device ID's vs Device Name--
lrwxrwxrwx 1 root root  9 Jan 27 23:03
ata-HL-DT-ST_DVDRAM_GH22NS70_K0028Q64636 -> ../../sr0
lrwxrwxrwx 1 root root  9 Jan 27 23:03
ata-OCZ-AGILITY3_OCZ-8D0T42404K8H12P6 -> ../../sdh
lrwxrwxrwx 1 root root 10 Jan 27 23:03
ata-OCZ-AGILITY3_OCZ-8D0T42404K8H12P6-part1 -> ../../sdh1
lrwxrwxrwx 1 root root 10 Jan 27 23:03
ata-OCZ-AGILITY3_OCZ-8D0T42404K8H12P6-part2 -> ../../sdh2
lrwxrwxrwx 1 root root  9 Jan 27 23:03 ata-ST3000VX000-1CU166_Z1F47ATC
-> ../../sdg
lrwxrwxrwx 1 root root  9 Jan 27 23:03 ata-ST3000VX000-1CU166_Z1F49MSQ
-> ../../sdf
lrwxrwxrwx 1 root root  9 Jan 27 23:03 ata-ST3000VX000-1CU166_Z1F49MYJ
-> ../../sdi
lrwxrwxrwx 1 root root  9 Jan 27 23:03 ata-ST3000VX000-9YW166_Z1F13TGY
-> ../../sde
lrwxrwxrwx 1 root root  9 Jan 27 23:03 ata-ST33000651AS_9XK0B9RF -> ../../sdb
lrwxrwxrwx 1 root root 10 Jan 27 23:03 ata-ST33000651AS_9XK0B9RF-part1
-> ../../sdb1
lrwxrwxrwx 1 root root  9 Jan 27 23:03 ata-ST33000651AS_9XK0BR4Q -> ../../sda
lrwxrwxrwx 1 root root 10 Jan 27 23:03 ata-ST33000651AS_9XK0BR4Q-part1
-> ../../sda1
lrwxrwxrwx 1 root root  9 Jan 27 23:03 ata-ST33000651AS_9XK0F087 -> ../../sdc
lrwxrwxrwx 1 root root 10 Jan 27 23:03 ata-ST33000651AS_9XK0F087-part1
-> ../../sdc1
lrwxrwxrwx 1 root root  9 Jan 27 23:03 ata-ST33000651AS_9XK0FEHD -> ../../sdd
lrwxrwxrwx 1 root root 10 Jan 27 23:03 dm-name-vg_desktop-lv_home -> ../../dm-1
lrwxrwxrwx 1 root root 10 Jan 27 23:03 dm-name-vg_desktop-lv_root -> ../../dm-0
lrwxrwxrwx 1 root root 10 Jan 27 23:03
dm-uuid-LVM-gPmDONxd0J5Xzhng4nMgLyJywSvcsrFB1bQOUpSoE0SzQ6kHuvqiMzxpkiH0ZgWJ
-> ../../dm-1
lrwxrwxrwx 1 root root 10 Jan 27 23:03
dm-uuid-LVM-gPmDONxd0J5Xzhng4nMgLyJywSvcsrFBsTxjvh7YlYcmxUryNXlejEsR55sjfh9w
-> ../../dm-0
lrwxrwxrwx 1 root root  9 Jan 27 23:03 wwn-0x5000c5002dae3e0a -> ../../sdb
lrwxrwxrwx 1 root root 10 Jan 27 23:03 wwn-0x5000c5002dae3e0a-part1 ->
../../sdb1
lrwxrwxrwx 1 root root  9 Jan 27 23:03 wwn-0x5000c5002dfdfece -> ../../sdc
lrwxrwxrwx 1 root root 10 Jan 27 23:03 wwn-0x5000c5002dfdfece-part1 ->
../../sdc1
lrwxrwxrwx 1 root root  9 Jan 27 23:03 wwn-0x5000c5002e0ff1ce -> ../../sda
lrwxrwxrwx 1 root root 10 Jan 27 23:03 wwn-0x5000c5002e0ff1ce-part1 ->
../../sda1
lrwxrwxrwx 1 root root  9 Jan 27 23:03 wwn-0x5000c5002e10998c -> ../../sdd
lrwxrwxrwx 1 root root  9 Jan 27 23:03 wwn-0x5000c5004e34e5a2 -> ../../sde
lrwxrwxrwx 1 root root  9 Jan 27 23:03 wwn-0x5000c500657e23a6 -> ../../sdi
lrwxrwxrwx 1 root root  9 Jan 27 23:03 wwn-0x5000c500657e27c4 -> ../../sdf
lrwxrwxrwx 1 root root  9 Jan 27 23:03 wwn-0x5000c500657e2888 -> ../../sdg
lrwxrwxrwx 1 root root  9 Jan 27 23:03 wwn-0x5e83a97f6722d623 -> ../../sdh
lrwxrwxrwx 1 root root 10 Jan 27 23:03 wwn-0x5e83a97f6722d623-part1 ->
../../sdh1
lrwxrwxrwx 1 root root 10 Jan 27 23:03 wwn-0x5e83a97f6722d623-part2 ->
../../sdh2

cat /etc/mdadm.conf
ARRAY /dev/md0 devices=/dev/sda3,/dev/sdb3,/dev/sdc3,/dev/sdd3,/dev/sde3,/dev/sdf3,/dev/sdg3,/dev/sdh3

--Other--
# uname -a
Linux desktop.yorik 3.12.8-300.fc20.x86_64 #1 SMP Thu Jan 16 01:07:50
UTC 2014 x86_64 x86_64 x86_64 GNU/Linux

# mdadm -V
mdadm - v3.3 - 3rd September 2013
