From: Chris Murphy <lists@colorremedies.com>
Subject: no automatic resync after device disconnect then reconnect
Date: Wed, 9 Jul 2014 16:44:27 -0600
Message-ID: <883F6A2C-C8F6-4A27-B7BF-2FB98F395592@colorremedies.com>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is in a VM, no data at risk.

Two problems:

1. I intentionally removed one of two md raid1 member devices, boot degraded succeeds, clean power off, reconnect the removed md member device, boot succeeds but an automatic resync does not occur for the previously disconnect md members. Maybe this is expected, I'm not sure, but I'd think a better user experience would be autoresync perhaps with a notification?

2. For the raid set with a bitmap, this command succeeds
 # mdadm --manage /dev/md126 --re-add /dev/sdb3

However, for the raid set without bitmap (seems the same otherwise, same metadata version), it fails:
 # mdadm --manage /dev/md127 --re-add /dev/sdb2
mdadm: --re-add for /dev/sdb2 to /dev/md127 is not possible
# dmesg
[ 3907.162757] md: export_rdev(sdb2)



Configuration details:

-UEFI
- mdadm-3.3-4.fc20.x86_64
- kernel 3.11.10-301.fc20.x86_64
-Two drives (VDI's)
- Idea is to create a resiliently bootable (degraded) system by having duplicate generic EFI System partitions which point to a /boot/grub2/grub.cfg which is on ext4 on md raid1. This part does work, and seems unrelated.

- PARTITIONS
(gdisk, condensed output)
Disk /dev/sda: 167772160 sectors, 80.0 GiB
Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048          411647   200.0 MiB   EF00  EFI System
   2          411648         1845247   700.0 MiB   FD00  
   3         1845248       165898239   78.2 GiB    FD00  

Disk /dev/sdb: 167772160 sectors, 80.0 GiB
Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048          411647   200.0 MiB   EF00  EFI System
   2          411648         1845247   700.0 MiB   FD00  
   3         1845248       165898239   78.2 GiB    FD00  


- MDSTAT

Personalities : [raid1] 
md126 : active raid1 sdb3[1] sda3[0]
      81960960 blocks super 1.2 [2/2] [UU]
      bitmap: 1/1 pages [4KB], 65536KB chunk

md127 : active raid1 sda2[0]
      716224 blocks super 1.2 [2/1] [U_]


- DETAIL

[root@localhost ~]# mdadm -D /dev/md127
/dev/md127:
        Version : 1.2
  Creation Time : Wed Jul  9 14:41:07 2014
     Raid Level : raid1
     Array Size : 716224 (699.55 MiB 733.41 MB)
  Used Dev Size : 716224 (699.55 MiB 733.41 MB)
   Raid Devices : 2
  Total Devices : 1
    Persistence : Superblock is persistent

    Update Time : Wed Jul  9 15:31:08 2014
          State : clean, degraded 
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           Name : localhost:boot
           UUID : 21743918:8aeb5370:7142e135:aee85500
         Events : 41

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/sda2
       2       0        0        2      removed


- EXAMINE

[root@localhost ~]# mdadm -E /dev/sda2
/dev/sda2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 21743918:8aeb5370:7142e135:aee85500
           Name : localhost:boot
  Creation Time : Wed Jul  9 14:41:07 2014
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 1432544 (699.60 MiB 733.46 MB)
     Array Size : 716224 (699.55 MiB 733.41 MB)
  Used Dev Size : 1432448 (699.55 MiB 733.41 MB)
    Data Offset : 1056 sectors
   Super Offset : 8 sectors
   Unused Space : before=968 sectors, after=96 sectors
          State : clean
    Device UUID : 7ede7423:80dca499:cf5d3c4d:d0d1493f

    Update Time : Wed Jul  9 16:14:38 2014
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 9d336f14 - correct
         Events : 43


   Device Role : Active device 0
   Array State : A. ('A' == active, '.' == missing, 'R' == replacing)


[root@localhost ~]# mdadm -E /dev/sdb2
/dev/sdb2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 21743918:8aeb5370:7142e135:aee85500
           Name : localhost:boot
  Creation Time : Wed Jul  9 14:41:07 2014
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 1432544 (699.60 MiB 733.46 MB)
     Array Size : 716224 (699.55 MiB 733.41 MB)
  Used Dev Size : 1432448 (699.55 MiB 733.41 MB)
    Data Offset : 1056 sectors
   Super Offset : 8 sectors
   Unused Space : before=968 sectors, after=96 sectors
          State : clean
    Device UUID : a0391710:4c6c3f97:6b3eb23d:779d6e87

    Update Time : Wed Jul  9 14:57:13 2014
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : c00df40e - correct
         Events : 25


   Device Role : Active device 1
   Array State : AA ('A' == active, '.' == missing, 'R' == replacing)




- MDADM.CONF

[root@localhost ~]# cat /etc/mdadm.conf 
# mdadm.conf written out by anaconda
MAILADDR root
AUTO +imsm +1.x -all
ARRAY /dev/md/boot level=raid1 num-devices=2 UUID=21743918:8aeb5370:7142e135:aee85500
ARRAY /dev/md/pv01 level=raid1 num-devices=2 UUID=1183f7d0:de03bccc:59d6747d:fa2e8a59



Chris Murphy

