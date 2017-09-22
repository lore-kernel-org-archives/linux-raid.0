From: Joseba Ibarra <wajalotnet@gmail.com>
Subject: Can't mount /dev/md0 Raid5
Date: Fri, 22 Sep 2017 11:13:46 +0200
Message-ID: <59C4D44A.7080302@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi.I have a RAID5 using 4 drives in a HO Proliant G8 Microserver

I got a Proxmox installed and the disks for RAID are associated with a 
specific VM with Debian 9. It worked like a charm.

But, some days ago i broke a proccess giving some permissions (sudo 
chmod....) to some folders into of the mounted /dev/md0. Then after 
restart the VM the RAID din't mount again. The raid contents very 
important data for me, so i'm not very sure what to do in order don't 
lose the data. So, i´m getting bit panic.

I need some guide to rebuild the system without losing the content.

mdadm version is 3.4-4+b1


This is the result of the fdisk -l related with the RAID

root@grafico:/# fdisk -l
Disco /dev/sdb: 931,5 GiB, 1000204886016 bytes, 1953525168 sectores
Unidades: sectores de 1 * 512 = 512 bytes
Tamaño de sector (lógico/físico): 512 bytes / 512 bytes
Tamaño de E/S (mínimo/óptimo): 512 bytes / 512 bytes
Tipo de etiqueta de disco: dos
Identificador del disco: 0x087383f0

Disposit.  Inicio Comienzo      Final   Sectores Tamaño Id Tipo
/dev/sdb1             2048 1953523711 1953521664 931,5G fd Linux raid 
autodetect


Disco /dev/sdd: 931,5 GiB, 1000204886016 bytes, 1953525168 sectores
Unidades: sectores de 1 * 512 = 512 bytes
Tamaño de sector (lógico/físico): 512 bytes / 512 bytes
Tamaño de E/S (mínimo/óptimo): 512 bytes / 512 bytes
Tipo de etiqueta de disco: dos
Identificador del disco: 0x8b48be4a

Disposit.  Inicio Comienzo      Final   Sectores Tamaño Id Tipo
/dev/sdd1             2048 1953523711 1953521664 931,5G fd Linux raid 
autodetect


Disco /dev/sdc: 931,5 GiB, 1000204886016 bytes, 1953525168 sectores
Unidades: sectores de 1 * 512 = 512 bytes
Tamaño de sector (lógico/físico): 512 bytes / 512 bytes
Tamaño de E/S (mínimo/óptimo): 512 bytes / 512 bytes
Tipo de etiqueta de disco: dos
Identificador del disco: 0x87ea0d19

Disposit.  Inicio Comienzo      Final   Sectores Tamaño Id Tipo
/dev/sdc1             2048 1953523711 1953521664 931,5G fd Linux raid 
autodetect


Disco /dev/sde: 931,5 GiB, 1000204886016 bytes, 1953525168 sectores
Unidades: sectores de 1 * 512 = 512 bytes
Tamaño de sector (lógico/físico): 512 bytes / 512 bytes
Tamaño de E/S (mínimo/óptimo): 512 bytes / 512 bytes
Tipo de etiqueta de disco: dos
Identificador del disco: 0xa69b0d7f

Disposit.  Inicio Comienzo      Final   Sectores Tamaño Id Tipo
/dev/sde1             2048 1953523711 1953521664 931,5G fd Linux raid 
autodetect


Disco /dev/md0: 2,7 TiB, 3000206622720 bytes, 5859778560 sectores
Unidades: sectores de 1 * 512 = 512 bytes
Tamaño de sector (lógico/físico): 512 bytes / 512 bytes
Tamaño de E/S (mínimo/óptimo): 524288 bytes / 1572864 bytes
Tipo de etiqueta de disco: gpt
Identificador del disco: A87C8BBF-5876-4FA6-83F6-46DAF1BDCF75

Disposit.  Comienzo      Final   Sectores Tamaño Tipo
/dev/md0p1     2048 5859776511 5859774464 2,7T Sistema de ficheros de Linux




And here some more information (as you can see the /dev/sde drive have 
some bad blocks)

root@grafico:/# mdadm --examine /dev/sdb
/dev/sdb:
    MBR Magic : aa55
Partition[0] :   1953521664 sectors at         2048 (type fd)
root@grafico:/# mdadm --examine /dev/sdc
/dev/sdc:
    MBR Magic : aa55
Partition[0] :   1953521664 sectors at         2048 (type fd)
root@grafico:/# mdadm --examine /dev/sdd
/dev/sdd:
    MBR Magic : aa55
Partition[0] :   1953521664 sectors at         2048 (type fd)
root@grafico:/# mdadm --examine /dev/sde
/dev/sde:
    MBR Magic : aa55
Partition[0] :   1953521664 sectors at         2048 (type fd)

root@grafico:/# mdadm --examine /dev/sdb1
/dev/sdb1:
Magic : a92b4efc
Version : 1.2
Feature Map : 0x1
Array UUID : 0b44a3b8:83eafabc:644afc87:bdb5b1f3
Name : servidor:0
    Creation Time : Sat Aug 5 23:10:50 2017
    Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 1953259520 (931.39 GiB 1000.07 GB)
  Array Size : 2929889280 (2794.16 GiB 3000.21 GB)
  Data Offset : 262144 sectors
  Super Offset : 8 sectors
  Unused Space : before=262056 sectors, after=0 sectors
  State : clean
  Device UUID : ddc94c8e:aab339df:2233112a:5c938bab

Internal Bitmap : 8 sectors from superblock
Update Time : Tue Sep 19 01:36:51 2017
Bad Block Log : 512 entries available at offset 72 sectors
Checksum : 626e25ae - correct
Events : 3106

Layout : left-symmetric
Chunk Size : 512K

Device Role : Active device 0
Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)

root@grafico:/# mdadm --examine /dev/sdc1
/dev/sdc1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 0b44a3b8:83eafabc:644afc87:bdb5b1f3
            Name : servidor:0
   Creation Time : Sat Aug 5 23:10:50 2017
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 1953259520 (931.39 GiB 1000.07 GB)
      Array Size : 2929889280 (2794.16 GiB 3000.21 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=0 sectors
           State : clean
     Device UUID : 32271db0:38a5220c:c19968af:8fe1a3fb

Internal Bitmap : 8 sectors from superblock
     Update Time : Tue Sep 19 01:36:51 2017
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 86971d3c - correct
          Events : 3106

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 1
    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
root@grafico:/# mdadm --examine /dev/sdd1
/dev/sdd1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 0b44a3b8:83eafabc:644afc87:bdb5b1f3
            Name : servidor:0
   Creation Time : Sat Aug 5 23:10:50 2017
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 1953259520 (931.39 GiB 1000.07 GB)
      Array Size : 2929889280 (2794.16 GiB 3000.21 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=0 sectors
           State : clean
     Device UUID : 9014cf8b:ea7e22e2:9274be9d:9aeee689

Internal Bitmap : 8 sectors from superblock
     Update Time : Tue Sep 19 01:36:51 2017
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : b4e1cc29 - correct
          Events : 3106

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 2
    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
root@grafico:/# mdadm --examine /dev/sde1
/dev/sde1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x9
      Array UUID : 0b44a3b8:83eafabc:644afc87:bdb5b1f3
            Name : servidor:0
   Creation Time : Sat Aug 5 23:10:50 2017
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 1953259520 (931.39 GiB 1000.07 GB)
      Array Size : 2929889280 (2794.16 GiB 3000.21 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=0 sectors
           State : clean
     Device UUID : f95affb4:138bca63:d10df091:1f20af37

Internal Bitmap : 8 sectors from superblock
     Update Time : Tue Sep 19 01:36:51 2017
   Bad Block Log : 512 entries available at offset 72 sectors - bad 
blocks present.
        Checksum : 1b3e988 - correct
          Events : 3106

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 3
    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)




root@grafico:/# mdadm --detail /dev/md0
/dev/md0:
         Version : 1.2
   Creation Time : Sat Aug 5 23:10:50 2017
      Raid Level : raid5
      Array Size : 2929889280 (2794.16 GiB 3000.21 GB)
   Used Dev Size : 976629760 (931.39 GiB 1000.07 GB)
    Raid Devices : 4
   Total Devices : 4
     Persistence : Superblock is persistent

   Intent Bitmap : Internal

     Update Time : Tue Sep 19 01:36:51 2017
           State : clean
  Active Devices : 4
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 512K

            Name : servidor:0
            UUID : 0b44a3b8:83eafabc:644afc87:bdb5b1f3
          Events : 3106

     Number   Major   Minor   RaidDevice State
        0       8       17        0      active sync   /dev/sdb1
        1       8       33        1      active sync   /dev/sdc1
        2       8       49        2      active sync   /dev/sdd1
        3       8       65        3      active sync   /dev/sde1




root@grafico:/# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0] 
[raid1] [raid10]
md0 : active (auto-read-only) raid5 sdb1[0] sde1[3] sdc1[1] sdd1[2]
       2929889280 blocks super 1.2 level 5, 512k chunk, algorithm 2 
[4/4] [UUUU]
       bitmap: 0/8 pages [0KB], 65536KB chunk


Joseba Ibarra
