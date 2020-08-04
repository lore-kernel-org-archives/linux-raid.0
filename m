From: "H. Morala (HyD)" <h.morala@hospedajeydominios.com>
Subject: mdadm: Insufficient head-space for reshape on /dev/sda2
Date: Tue, 4 Aug 2020 13:18:56 +0200
Message-ID: <22661ED5-CF01-4414-B1DF-6A73D5EC5B63@hospedajeydominios.com>
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

We tried to do:

	mdadm --grow /dev/md126 --raid-devices=3D4=20

and we get:

	mdadm: Insufficient head-space for reshape on /dev/sda2


This is the present  configuration:

# mdadm --misc --detail /dev/md126
/dev/md126:
          Version : 1.0
    Creation Time : Fri May 27 12:40:54 2016
       Raid Level : raid10
       Array Size : 512960 (500.94 MiB 525.27 MB)
    Used Dev Size : 512960 (500.94 MiB 525.27 MB)
     Raid Devices : 2
    Total Devices : 4
      Persistence : Superblock is persistent

      Update Time : Mon Aug  3 17:33:04 2020
            State : clean=20
   Active Devices : 2
  Working Devices : 4
   Failed Devices : 0
    Spare Devices : 2

           Layout : near=3D2
       Chunk Size : 64K

Consistency Policy : resync

             Name : boot
             UUID : 5fc23b3c:93ecd502:0fbf3b82:adc7ad2d
           Events : 746

   Number   Major   Minor   RaidDevice State
      0       8        2        0      active sync set-A   /dev/sda2
      4       8       50        1      active sync set-B   /dev/sdd2

      2       8       18        -      spare   /dev/sdb2
      3       8       34        -      spare   /dev/sdc2



# cat /etc/mdadm.conf=20
ARRAY /dev/md/boot_0 metadata=3D1.0 spares=3D2 name=3Dboot =
UUID=3D5fc23b3c:93ecd502:0fbf3b82:adc7ad2d

# cat /proc/mdstat=20
Personalities : [raid1] [raid10] [raid0]=20
md126 : active raid10 sdd2[4] sdc2[3](S) sdb2[2](S) sda2[0]
     512960 blocks super 1.0 2 near-copies [2/2] [UU]

# fdisk /dev/sda

The device presents a logical sector size that is smaller than
the physical sector size. Aligning to a physical sector (or optimal
I/O) size boundary is recommended, or performance may be impacted.
Welcome to fdisk (util-linux 2.23.2).

Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Orden (m para obtener ayuda): p

Disk /dev/sda: 500.1 GB, 500107862016 bytes, 976773168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk label type: dos
Identificador del disco: 0x0005ff1f

Disposit. Inicio    Comienzo      Fin      Bloques  Id  Sistema
/dev/sda1            2048     8265727     4131840   8e  Linux LVM
/dev/sda2   *     8265728     9291775      513024   fd  Linux raid =
autodetect
/dev/sda3         9291776   974243839   482476032   fd  Linux raid =
autodetect


# parted /dev/sda
GNU Parted 3.1
Usando /dev/sda
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) print free
Model: ATA Crucial_CT500MX2 (scsi)
Disk /dev/sda: 500GB
Sector size (logical/physical): 512B/4096B
Partition Table: msdos
Disk Flags:=20

Numero  Inicio  Fin     Tama=C3=B1o  Typo     Sistema de ficheros  =
Banderas
       32,3kB  1049kB  1016kB           Free Space
1      1049kB  4232MB  4231MB  primary                       lvm
2      4232MB  4757MB  525MB   primary  xfs                  arranque, =
raid
3      4757MB  499GB   494GB   primary                       raid
       499GB   500GB   1295MB           Free Space=
