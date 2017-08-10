From: Mr Typo <euroregistrar@gmail.com>
Subject: md0 device gone, disks busy
Date: Thu, 10 Aug 2017 22:26:06 +0200
Message-ID: <CAHnOR0OrjQD2=o4uSU4N3_W+UvHQzpcW=oYB0cmPU_kPQxzhcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello everyone,

i had a power outage 2 days ago and when i came home i found my linux
box not booting up anymore. After some commands i found out that there
is a problem with a device not beeing mounted because md0 is missing.

I tried to find out what is going on, but i cannot understand what is
going on.  i hope you can help me. Linux is a CentOS7.

I am posting the current status of the box below:

thank you all in advance

kind regards
Andy

[root@quad ~]# mdadm -V
mdadm - v3.4 - 28th January 2016
[root@quad ~]# uname -a
Linux quad 3.10.0-514.26.2.el7.x86_64 #1 SMP Tue Jul 4 15:04:05 UTC
2017 x86_64 x86_64 x86_64 GNU/Linux

[root@quad ~]# cat /proc/mdstat
Personalities :
unused devices: <none>
[root@quad ~]# ls -la /dev/md0
ls: cannot access /dev/md0: No such file or directory

[root@quad ~]# mdadm -Esv
ARRAY /dev/md/0  level=raid5 metadata=1.2 num-devices=4
UUID=9d020f27:c0542472:b95a18d2:5741114d name=quad.:0
   devices=/dev/sda1,/dev/sdb1,/dev/sdc1,/dev/sdd1


[root@quad ~]# mdadm -A -v /dev/md0
mdadm: looking for devices for /dev/md0
mdadm: /dev/sda1 is busy - skipping
mdadm: /dev/sdb1 is busy - skipping
mdadm: /dev/sdc1 is busy - skipping
mdadm: /dev/sdd1 is busy - skipping


[root@quad ~]# cat /proc/partitions  |grep -e sd[a-d]
   8       32 1953514584 sdc
   8       33 1953513560 sdc1
   8        0 1953514584 sda
   8        1 1953513560 sda1
   8       16 1953514584 sdb
   8       17 1953513560 sdb1
   8       48 1953514584 sdd
   8       49 1953513560 sdd1

[root@quad ~]# cat /etc/mdadm.conf
DEVICE /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1
ARRAY /dev/md0 metadata=1.2 name=quad:0 UUID=9d020f27:c0542472:b95a18d2:5741114d

[root@quad ~]# mdadm --examine --scan
ARRAY /dev/md/0  metadata=1.2 UUID=9d020f27:c0542472:b95a18d2:5741114d
name=quad:0
[root@quad ~]# cat /etc/mdadm/mdadm.conf
ARRAY /dev/md/0  metadata=1.2 UUID=9d020f27:c0542472:b95a18d2:5741114d
name=quad:


[root@quad ~]# lsof /dev/sda*
COMMAND   PID USER   FD   TYPE DEVICE SIZE/OFF  NODE NAME
multipath 607 root   10r   BLK    8,0      0t0 14507 /dev/sda


[root@quad ~]# mdadm --examine /dev/sd[a-d]*
/dev/sda:
   MBR Magic : aa55
Partition[0] :   3907027120 sectors at         2048 (type fd)
/dev/sda1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 9d020f27:c0542472:b95a18d2:5741114d
           Name : quad:0  (local to host quad)
  Creation Time : Wed Aug 20 19:28:52 2014
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3906764976 (1862.89 GiB 2000.26 GB)
     Array Size : 5860146816 (5588.67 GiB 6000.79 GB)
  Used Dev Size : 3906764544 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=432 sectors
          State : clean
    Device UUID : cee082b6:e5128634:bbaea65e:e75a2352

    Update Time : Wed Aug  9 22:09:11 2017
       Checksum : 9b6dc518 - correct
         Events : 25456

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 0
   Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdb:
   MBR Magic : aa55
Partition[0] :   3907027120 sectors at         2048 (type fd)
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 9d020f27:c0542472:b95a18d2:5741114d
           Name : quad:0  (local to host quad)
  Creation Time : Wed Aug 20 19:28:52 2014
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3906764976 (1862.89 GiB 2000.26 GB)
     Array Size : 5860146816 (5588.67 GiB 6000.79 GB)
  Used Dev Size : 3906764544 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=432 sectors
          State : clean
    Device UUID : b217daeb:fcebf9a3:8f8fd682:3ce535c6

    Update Time : Wed Aug  9 22:09:11 2017
       Checksum : d87b403e - correct
         Events : 25456

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 1
   Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc:
   MBR Magic : aa55
Partition[0] :   3907027120 sectors at         2048 (type fd)
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 9d020f27:c0542472:b95a18d2:5741114d
           Name : quad:0  (local to host quad)
  Creation Time : Wed Aug 20 19:28:52 2014
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3906764976 (1862.89 GiB 2000.26 GB)
     Array Size : 5860146816 (5588.67 GiB 6000.79 GB)
  Used Dev Size : 3906764544 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=432 sectors
          State : clean
    Device UUID : f1a520b9:0894d2aa:d822db73:8dfd006b

    Update Time : Wed Aug  9 22:09:11 2017
       Checksum : 426a2224 - correct
         Events : 25456

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 2
   Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdd:
   MBR Magic : aa55
Partition[0] :   3907027120 sectors at         2048 (type fd)
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 9d020f27:c0542472:b95a18d2:5741114d
           Name : quad:0  (local to host quad)
  Creation Time : Wed Aug 20 19:28:52 2014
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3906764976 (1862.89 GiB 2000.26 GB)
     Array Size : 5860146816 (5588.67 GiB 6000.79 GB)
  Used Dev Size : 3906764544 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=432 sectors
          State : clean
    Device UUID : 42270e8a:deb45300:a3e5de7e:74345b99

    Update Time : Wed Aug  9 22:09:11 2017
       Checksum : a236c146 - correct
         Events : 25456

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 3
   Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
