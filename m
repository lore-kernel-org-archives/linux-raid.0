From: Federico Foschini <undicizeri@gmail.com>
Subject: I've made a bit of a mess in my raid setup
Date: Sat, 8 Mar 2014 11:33:01 +0100
Message-ID: <CAFRU1XuCKyfL7uMa0wJj0dUjHyhBDp933_O4+TsQk33KM6brUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm using ubuntu 12.04.4 Server and this is my current setup:

My hard disks:

    wax@petra:~$ sudo fdisk -l /dev/sda
    Disk /dev/sda: 1500.3 GB, 1500301910016 bytes
    255 testine, 63 settori/tracce, 182401 cilindri, totale 2930277168
settori
    Unita  = settori di 1 * 512 = 512 byte
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Identificativo disco: 0x00000000

    Dispositivo Boot      Start         End      Blocks   Id  System
    /dev/sda1   *          63  2930272064  1465136001   fd  Autorilevamento
raid di Linux

    wax@petra:~$ sudo fdisk -l /dev/sdb
    Disk /dev/sdb: 1500.3 GB, 1500301910016 bytes
    255 testine, 63 settori/tracce, 182401 cilindri, totale 2930277168
settori
    Unita  = settori di 1 * 512 = 512 byte
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Identificativo disco: 0x00000000

    Dispositivo Boot      Start         End      Blocks   Id  System
    /dev/sdb1              63  2930272064  1465136001   fd  Autorilevamento
raid di Linux

    wax@petra:~$ sudo fdisk -l /dev/sdc
    Disk /dev/sdc: 163.9 GB, 163928604672 bytes
    255 testine, 63 settori/tracce, 19929 cilindri, totale 320173056 settori
    Unita  = settori di 1 * 512 = 512 byte
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Identificativo disco: 0x8f8000b1

    Dispositivo Boot      Start         End      Blocks   Id  System
    /dev/sdc1            2048     3905535     1951744   82  Linux swap /
Solaris
    /dev/sdc2         3907582   320172031   158132225    5  Esteso
    /dev/sdc5   *     3907584   320172031   158132224   83  Linux

    wax@petra:~$ sudo fdisk -l /dev/sdd
    Disk /dev/sdd: 3000.6 GB, 3000592982016 bytes
    255 testine, 63 settori/tracce, 364801 cilindri, totale 5860533168
settori
    Unita  = settori di 1 * 512 = 512 byte
    Sector size (logical/physical): 512 bytes / 4096 bytes
    I/O size (minimum/optimal): 4096 bytes / 4096 bytes
    Identificativo disco: 0x00000000
    Il disco /dev/sdd non contiene una tabella delle partizioni valida

This is the mdadm output:

    wax@petra:~$ cat /proc/mdstat
    Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
    md1 : active raid1 sdd[3] md0[2]
          2930135360 blocks super 1.2 [2/2] [UU]
    md0 : active linear sdb[0] sda[1]
          2930277152 blocks super 1.2 0k rounding
    unused devices: <none>

Why sda1 and sdb1 are market as boot? My boot disk is sdc. Also grub is
installed in sdc AND in sda I think that's an error right?

Why sda and sdb have partitions while sdd doesn't?

Is there something wrong with my setup?


-- 
Federico Foschini.
