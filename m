From: Axel Spallek <axel@spallek.org>
Subject: RAID5 grow interrupted.
Date: Thu, 22 Sep 2016 16:11:28 +0200
Message-ID: <36947ef9-64e2-f084-4949-476107e2771e@spallek.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello there.

I did something wrong.

I tried to get a disk out of a RAID5 with 8 hdds (4TB) to get a Hotspare 
to change to RAID6 afterwards.

The RAID was clean and not rebuilding before I started.

The partition was only 11TB big. Not yet resized, because not created 
with 64Bit, which I wanted to do afterwards.

Therefore I issued the following commands:

mdadm --grow -n7 /dev/md1  <-- just to get the size for the next command.

mdadm --grow /dev/md1 --array-size 23441292288

mdadm --grow -n7 /dev/md1 --backup-file /var/backups/mdadm.backup


The RAID /dev/md1 is mounted on /srv, so the backupfile is safe.

After a some time, someone told me, that seafile does not work. Since I 
was in a hurry, I just rebootet the server and forgot the RAID rebuild.

The server came up again, but without /dev/md1.

I had made a Backup, which is 2 days old. Not so bad, because I have the 
seafile data on several computers. But to get the RAID back to work 
would be better.

How do I restart the rebuild process with the backup-file?

This is what I get in the console:

root@s10:~# cat /proc/mdstat
Personalities :
md1 : inactive sdh1[0](S) sda1[5](S) sdb1[6](S) sdc1[7](S) sdd1[8](S) 
sdf1[4](S) sde1[2](S) sdg1[1](S)
       31255059140 blocks super 1.2

unused devices: <none>


root@s10:~# mdadm -A --scan --verbose
mdadm: looking for devices for further assembly
mdadm: /dev/sdg1 is busy - skipping
mdadm: Cannot assemble mbr metadata on /dev/sdg
mdadm: /dev/sdd1 is busy - skipping
mdadm: Cannot assemble mbr metadata on /dev/sdd
mdadm: /dev/sdc1 is busy - skipping
mdadm: Cannot assemble mbr metadata on /dev/sdc
mdadm: /dev/sda1 is busy - skipping
mdadm: Cannot assemble mbr metadata on /dev/sda
mdadm: /dev/sdb1 is busy - skipping
mdadm: Cannot assemble mbr metadata on /dev/sdb
mdadm: /dev/sdf1 is busy - skipping
mdadm: Cannot assemble mbr metadata on /dev/sdf
mdadm: /dev/sdh1 is busy - skipping
mdadm: Cannot assemble mbr metadata on /dev/sdh
mdadm: /dev/sde1 is busy - skipping
mdadm: Cannot assemble mbr metadata on /dev/sde
mdadm: no recogniseable superblock on /dev/sdj5
mdadm: Cannot assemble mbr metadata on /dev/sdj2
mdadm: no recogniseable superblock on /dev/sdj1
mdadm: Cannot assemble mbr metadata on /dev/sdj
mdadm: no recogniseable superblock on /dev/sdi1
mdadm: Cannot assemble mbr metadata on /dev/sdi
mdadm: No arrays found in config file or automatically


root@s10:~# mdadm --examine --scan
ARRAY /dev/md/1  metadata=1.2 UUID=48f60e15:900f47cc:6c5f42b1:82f01530 
name=s10:1


root@s10:~# mdadm --examine /dev/sd*
/dev/sda:
    MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sda1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x4
      Array UUID : 48f60e15:900f47cc:6c5f42b1:82f01530
            Name : s10:1  (local to host s10)
   Creation Time : Fri Sep 16 06:59:32 2016
      Raid Level : raid5
    Raid Devices : 7

  Avail Dev Size : 7813764785 (3725.89 GiB 4000.65 GB)
      Array Size : 23441292288 (22355.36 GiB 24003.88 GB)
   Used Dev Size : 7813764096 (3725.89 GiB 4000.65 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=689 sectors
           State : clean
     Device UUID : 9fe5980b:be2beb6b:59537ad1:90091564

   Reshape pos'n : 22485531648 (21443.87 GiB 23025.18 GB)
   Delta Devices : -1 (8->7)

     Update Time : Thu Sep 22 14:23:54 2016
        Checksum : 1ea679f3 - correct
          Events : 180344

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 7
    Array State : AAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdb:
    MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdb1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x4
      Array UUID : 48f60e15:900f47cc:6c5f42b1:82f01530
            Name : s10:1  (local to host s10)
   Creation Time : Fri Sep 16 06:59:32 2016
      Raid Level : raid5
    Raid Devices : 7

  Avail Dev Size : 7813764785 (3725.89 GiB 4000.65 GB)
      Array Size : 23441292288 (22355.36 GiB 24003.88 GB)
   Used Dev Size : 7813764096 (3725.89 GiB 4000.65 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=689 sectors
           State : clean
     Device UUID : 370c5540:2d3bdd3e:40a36449:b82309a8

   Reshape pos'n : 22485531648 (21443.87 GiB 23025.18 GB)
   Delta Devices : -1 (8->7)

     Update Time : Thu Sep 22 14:23:54 2016
        Checksum : e2331a09 - correct
          Events : 180344

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 6
    Array State : AAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc:
    MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdc1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x4
      Array UUID : 48f60e15:900f47cc:6c5f42b1:82f01530
            Name : s10:1  (local to host s10)
   Creation Time : Fri Sep 16 06:59:32 2016
      Raid Level : raid5
    Raid Devices : 7

  Avail Dev Size : 7813764785 (3725.89 GiB 4000.65 GB)
      Array Size : 23441292288 (22355.36 GiB 24003.88 GB)
   Used Dev Size : 7813764096 (3725.89 GiB 4000.65 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=689 sectors
           State : clean
     Device UUID : a9e8caf9:4c70d937:50e55bdf:b736cb97

   Reshape pos'n : 22485531648 (21443.87 GiB 23025.18 GB)
   Delta Devices : -1 (8->7)

     Update Time : Thu Sep 22 14:23:54 2016
        Checksum : 1a5e80ac - correct
          Events : 180344

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 5
    Array State : AAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdd:
    MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdd1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x4
      Array UUID : 48f60e15:900f47cc:6c5f42b1:82f01530
            Name : s10:1  (local to host s10)
   Creation Time : Fri Sep 16 06:59:32 2016
      Raid Level : raid5
    Raid Devices : 7

  Avail Dev Size : 7813764785 (3725.89 GiB 4000.65 GB)
      Array Size : 23441292288 (22355.36 GiB 24003.88 GB)
   Used Dev Size : 7813764096 (3725.89 GiB 4000.65 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=689 sectors
           State : clean
     Device UUID : 50a6466d:057b9171:22865989:cabb59ce

   Reshape pos'n : 22485531648 (21443.87 GiB 23025.18 GB)
   Delta Devices : -1 (8->7)

     Update Time : Thu Sep 22 14:23:54 2016
        Checksum : a81e6ef1 - correct
          Events : 180344

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 4
    Array State : AAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sde:
    MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sde1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x4
      Array UUID : 48f60e15:900f47cc:6c5f42b1:82f01530
            Name : s10:1  (local to host s10)
   Creation Time : Fri Sep 16 06:59:32 2016
      Raid Level : raid5
    Raid Devices : 7

  Avail Dev Size : 7813764785 (3725.89 GiB 4000.65 GB)
      Array Size : 23441292288 (22355.36 GiB 24003.88 GB)
   Used Dev Size : 7813764096 (3725.89 GiB 4000.65 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=689 sectors
           State : clean
     Device UUID : 1fd7fdde:3220d053:1cad772f:508ed8a7

   Reshape pos'n : 22485531648 (21443.87 GiB 23025.18 GB)
   Delta Devices : -1 (8->7)

     Update Time : Thu Sep 22 14:23:54 2016
        Checksum : 7bb13e67 - correct
          Events : 180344

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 2
    Array State : AAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdf:
    MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdf1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x4
      Array UUID : 48f60e15:900f47cc:6c5f42b1:82f01530
            Name : s10:1  (local to host s10)
   Creation Time : Fri Sep 16 06:59:32 2016
      Raid Level : raid5
    Raid Devices : 7

  Avail Dev Size : 7813764785 (3725.89 GiB 4000.65 GB)
      Array Size : 23441292288 (22355.36 GiB 24003.88 GB)
   Used Dev Size : 7813764096 (3725.89 GiB 4000.65 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=689 sectors
           State : clean
     Device UUID : b2788315:a75fec1f:1d2681ee:2bba1be7

   Reshape pos'n : 22485531648 (21443.87 GiB 23025.18 GB)
   Delta Devices : -1 (8->7)

     Update Time : Thu Sep 22 14:23:54 2016
        Checksum : 7c9fc44d - correct
          Events : 180344

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 3
    Array State : AAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdg:
    MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdg1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x4
      Array UUID : 48f60e15:900f47cc:6c5f42b1:82f01530
            Name : s10:1  (local to host s10)
   Creation Time : Fri Sep 16 06:59:32 2016
      Raid Level : raid5
    Raid Devices : 7

  Avail Dev Size : 7813764785 (3725.89 GiB 4000.65 GB)
      Array Size : 23441292288 (22355.36 GiB 24003.88 GB)
   Used Dev Size : 7813764096 (3725.89 GiB 4000.65 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=689 sectors
           State : clean
     Device UUID : 4e7223d6:4416983d:7812788b:a2114dec

   Reshape pos'n : 22485531648 (21443.87 GiB 23025.18 GB)
   Delta Devices : -1 (8->7)

     Update Time : Thu Sep 22 14:23:54 2016
        Checksum : fd13b855 - correct
          Events : 180344

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 1
    Array State : AAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdh:
    MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdh1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x4
      Array UUID : 48f60e15:900f47cc:6c5f42b1:82f01530
            Name : s10:1  (local to host s10)
   Creation Time : Fri Sep 16 06:59:32 2016
      Raid Level : raid5
    Raid Devices : 7

  Avail Dev Size : 7813764785 (3725.89 GiB 4000.65 GB)
      Array Size : 23441292288 (22355.36 GiB 24003.88 GB)
   Used Dev Size : 7813764096 (3725.89 GiB 4000.65 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=689 sectors
           State : clean
     Device UUID : c1226e5c:4145cbcf:0bbe6160:4e0da07b

   Reshape pos'n : 22485531648 (21443.87 GiB 23025.18 GB)
   Delta Devices : -1 (8->7)

     Update Time : Thu Sep 22 14:23:54 2016
        Checksum : 79ce3f03 - correct
          Events : 180344

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 0
    Array State : AAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdi:
    MBR Magic : aa55
Partition[0] :    500109312 sectors at         2048 (type 83)
mdadm: No md superblock detected on /dev/sdi1.
/dev/sdj:
    MBR Magic : aa55
Partition[0] :     56143872 sectors at         2048 (type 83)
Partition[1] :      2478082 sectors at     56147966 (type 05)
mdadm: No md superblock detected on /dev/sdj1.
/dev/sdj2:
    MBR Magic : aa55
Partition[0] :      2478080 sectors at            2 (type 82)
mdadm: No md superblock detected on /dev/sdj5.



root@s10:~# mdadm --detail /dev/md1
/dev/md1:
         Version : 1.2
      Raid Level : raid0
   Total Devices : 8
     Persistence : Superblock is persistent

           State : inactive

   Delta Devices : -1, (1->0)
       New Level : raid5
      New Layout : left-symmetric
   New Chunksize : 512K

            Name : s10:1  (local to host s10)
            UUID : 48f60e15:900f47cc:6c5f42b1:82f01530
          Events : 180344

     Number   Major   Minor   RaidDevice

        -       8        1        -        /dev/sda1
        -       8       17        -        /dev/sdb1
        -       8       33        -        /dev/sdc1
        -       8       49        -        /dev/sdd1
        -       8       65        -        /dev/sde1
        -       8       81        -        /dev/sdf1
        -       8       97        -        /dev/sdg1
        -       8      113        -        /dev/sdh1


-- 

Mit freundlichem Gruß,

Axel Spallek
Dipl.-Ing. FH IE

Hochdorfer Straße 34
88477 Schönebürg

Mobil: 01577 7929886
E-Mail: axel@spallek.org

Bankverbindung:
Volksbank Schwendi
IBAN: DE20654913200095195009
BIC: GENODES1VBL

Steuernummer: 5438000091
UST.-ID.:     DE290536647

