From: den Hoog <speedyden@gmail.com>
Subject: Intel Matrix raid recovery with 2 raid volumes in the array
Date: Mon, 30 Dec 2013 10:39:14 +0100
Message-ID: <CANgodhDj6Q2A0B6rnD4hw3tWqg+uS34p7Ck7Gfr-pCwcQZ=JPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7bdc7d5a82160904eebd37f9
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--047d7bdc7d5a82160904eebd37f9
Content-Type: text/plain; charset=ISO-8859-1

Hi,

had a major f-up when being in a hurry after a bios upgrade.
Forgot to turn on the Intel SATA raid, and Windows recovery erased the
first disk of 4.

It is an array of 4x4TB, in a matrix, having 1 RAID0 volume, and 1 RAID5 vol.
Although the array displays a failed array in Windows, 3 disks are
active, and 1 is missing and showing as a non-raid array being
available.

In (my) theory, I should still be able to recover the raid5 vol. with
the remaining 3 disks, however I should specify the specific sector
offset I guess.
I read many articles on this, but none of them address the
'difficulty' of recovering a specific volume when multiple exist in an
array.

Although I've some backups, I really would appreciate your help in
getting this recovered.
sda is the SSD
sdb is the 'missing' and erased drive (serial ending on P82C)
sdc is the second drive in the array
sdd is the 3rd drive in the array
sde is the 4th drive in the array
sdf is the usb stick I'm running Fedora live from

What I've done so far :
- Started Fedora 15 Live from a USB
- installed the mdadm package data_offset and compiled

My plan to work with an offset to recover the [HitR5] volume:
- echo 1 > /sys/module/md_mod/parameters/start_dirty_degraded
- mdadm -C /dev/md/imsm -e imsm -n 4 /dev/sdb /dev/sdc /dev/sdd /dev/sde
- mdadm -C /dev/md0 -l5 -n4 -c 128   /dev/sdb:1073746184s
/dev/sdc:1073746184s /dev/sdd:1073746184s /dev/sde:1073746184s


I'm in doubt about working with missing disks first to start a
degraded array, with -C and missing for the first drive , or choosing
assemble --auto, or as stated above and create the volume with an
offset.

Another thing I'm not certain of: do I need to build a new mdadm with
data_offset, or is it already present in my 3.2.6 version? When I
built a new version with Neils mdadm I ended up with a 3.2.5 18May2012
version.

As I guess I have only one shot at this I have not executed anything yet.

thanks many for your help and advice!

best regards Dennis


=======output mdadm -Evvvvs=============

root@localhost ~]# mdadm -Evvvvs

mdadm: No md superblock detected on /dev/dm-1.

mdadm: No md superblock detected on /dev/dm-0.

/dev/sdf1:

   MBR Magic : aa55

Partition[0] :    432871117 sectors at   3224498923 (type 07)

Partition[1] :   1953460034 sectors at   3272020941 (type 16)

Partition[3] :    924335794 sectors at     50200576 (type 00)

/dev/sdf:

   MBR Magic : aa55

Partition[0] :     15769600 sectors at         2048 (type 0b)

/dev/sde:

          Magic : Intel Raid ISM Cfg Sig.

        Version : 1.3.00

    Orig Family : f3437c9b

         Family : f3437c9d

     Generation : 00002c5f

     Attributes : All supported

           UUID : 47b011c7:4a8531ea:7e94ab93:06034952

       Checksum : 671f5f84 correct

    MPB Sectors : 2

          Disks : 4

   RAID Devices : 2


  Disk03 Serial : PL1321LAG4RXEH

          State : active

             Id : 00000005

    Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)


[HitR0]:

           UUID : 73ecf2cf:fcfd2598:d6523381:71e57931

     RAID Level : 0

        Members : 4

          Slots : [_UUU]

    Failed disk : 1

      This Slot : 3

     Array Size : 4294967296 (2048.00 GiB 2199.02 GB)

   Per Dev Size : 1073742088 (512.00 GiB 549.76 GB)

  Sector Offset : 0

    Num Stripes : 4194304

     Chunk Size : 128 KiB

       Reserved : 0

  Migrate State : idle

      Map State : failed

    Dirty State : clean


[HitR5]:

           UUID : 71626250:b8fc1262:3545d952:69eb329e

     RAID Level : 5

        Members : 4

          Slots : [_UU_]

    Failed disk : 3

      This Slot : 3 (out-of-sync)

     Array Size : 20220831744 (9642.04 GiB 10353.07 GB)

   Per Dev Size : 6740279304 (3214.02 GiB 3451.02 GB)

  Sector Offset : 1073746184

    Num Stripes : 26329208

     Chunk Size : 128 KiB

       Reserved : 0

  Migrate State : idle

      Map State : failed

    Dirty State : clean


  Disk00 Serial : PL2311LAG1P82C:0

          State : active

             Id : ffffffff

    Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)


  Disk01 Serial : PL1321LAG4NMEH

          State : active

             Id : 00000003

    Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)


  Disk02 Serial : PL1321LAG4TH4H

          State : active

             Id : 00000004

    Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)

/dev/sdd:

          Magic : Intel Raid ISM Cfg Sig.

        Version : 1.3.00

    Orig Family : f3437c9b

         Family : f3437c9d

     Generation : 00002c5f

     Attributes : All supported

           UUID : 47b011c7:4a8531ea:7e94ab93:06034952

       Checksum : 671f5f84 correct

    MPB Sectors : 2

          Disks : 4

   RAID Devices : 2


  Disk02 Serial : PL1321LAG4TH4H

          State : active

             Id : 00000004

    Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)


[HitR0]:

           UUID : 73ecf2cf:fcfd2598:d6523381:71e57931

     RAID Level : 0

        Members : 4

          Slots : [_UUU]

    Failed disk : 1

      This Slot : 2

     Array Size : 4294967296 (2048.00 GiB 2199.02 GB)

   Per Dev Size : 1073742088 (512.00 GiB 549.76 GB)

  Sector Offset : 0

    Num Stripes : 4194304

     Chunk Size : 128 KiB

       Reserved : 0

  Migrate State : idle

      Map State : failed

    Dirty State : clean


[HitR5]:

           UUID : 71626250:b8fc1262:3545d952:69eb329e

     RAID Level : 5

        Members : 4

          Slots : [_UU_]

    Failed disk : 3

      This Slot : 2

     Array Size : 20220831744 (9642.04 GiB 10353.07 GB)

   Per Dev Size : 6740279304 (3214.02 GiB 3451.02 GB)

  Sector Offset : 1073746184

    Num Stripes : 26329208

     Chunk Size : 128 KiB

       Reserved : 0

  Migrate State : idle

      Map State : failed

    Dirty State : clean


  Disk00 Serial : PL2311LAG1P82C:0

          State : active

             Id : ffffffff

    Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)


  Disk01 Serial : PL1321LAG4NMEH

          State : active

             Id : 00000003

    Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)


  Disk03 Serial : PL1321LAG4RXEH

          State : active

             Id : 00000005

    Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)

/dev/sdc:

          Magic : Intel Raid ISM Cfg Sig.

        Version : 1.3.00

    Orig Family : f3437c9b

         Family : f3437c9d

     Generation : 00002c5f

     Attributes : All supported

           UUID : 47b011c7:4a8531ea:7e94ab93:06034952

       Checksum : 671f5f84 correct

    MPB Sectors : 2

          Disks : 4

   RAID Devices : 2


  Disk01 Serial : PL1321LAG4NMEH

          State : active

             Id : 00000003

    Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)


[HitR0]:

           UUID : 73ecf2cf:fcfd2598:d6523381:71e57931

     RAID Level : 0

        Members : 4

          Slots : [_UUU]

    Failed disk : 1

      This Slot : 1

     Array Size : 4294967296 (2048.00 GiB 2199.02 GB)

   Per Dev Size : 1073742088 (512.00 GiB 549.76 GB)

  Sector Offset : 0

    Num Stripes : 4194304

     Chunk Size : 128 KiB

       Reserved : 0

  Migrate State : idle

      Map State : failed

    Dirty State : clean


[HitR5]:

           UUID : 71626250:b8fc1262:3545d952:69eb329e

     RAID Level : 5

        Members : 4

          Slots : [_UU_]

    Failed disk : 3

      This Slot : 1

     Array Size : 20220831744 (9642.04 GiB 10353.07 GB)

   Per Dev Size : 6740279304 (3214.02 GiB 3451.02 GB)

  Sector Offset : 1073746184

    Num Stripes : 26329208

     Chunk Size : 128 KiB

       Reserved : 0

  Migrate State : idle

      Map State : failed

    Dirty State : clean


  Disk00 Serial : PL2311LAG1P82C:0

          State : active

             Id : ffffffff

    Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)


  Disk02 Serial : PL1321LAG4TH4H

          State : active

             Id : 00000004

    Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)


  Disk03 Serial : PL1321LAG4RXEH

          State : active

             Id : 00000005

    Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)

mdadm: No md superblock detected on /dev/sdb1.

/dev/sdb:

   MBR Magic : aa55

Partition[0] :   4294967295 sectors at            1 (type ee)

/dev/sda2:

   MBR Magic : aa55

Partition[0] :   1816210284 sectors at   1920221984 (type 72)

Partition[1] :   1953653108 sectors at   1936028192 (type 6c)

Partition[3] :          447 sectors at     27722122 (type 00)

/dev/sda1:

   MBR Magic : aa55

Partition[0] :   1816210284 sectors at   1920221984 (type 72)

Partition[1] :   1953653108 sectors at   1936028192 (type 6c)

Partition[3] :          447 sectors at     27722122 (type 00)

/dev/sda:

   MBR Magic : aa55

Partition[0] :       716800 sectors at         2048 (type 07)

Partition[1] :    499396608 sectors at       718848 (type 07)

mdadm: No md superblock detected on /dev/loop4.

mdadm: No md superblock detected on /dev/loop3.

mdadm: No md superblock detected on /dev/loop2.

mdadm: No md superblock detected on /dev/loop1.

mdadm: No md superblock detected on /dev/loop0.

/dev/md127:

          Magic : Intel Raid ISM Cfg Sig.

        Version : 1.3.00

    Orig Family : f3437c9b

         Family : f3437c9d

     Generation : 00002c5f

     Attributes : All supported

           UUID : 47b011c7:4a8531ea:7e94ab93:06034952

       Checksum : 671f5f84 correct

    MPB Sectors : 2

          Disks : 4

   RAID Devices : 2


  Disk02 Serial : PL1321LAG4TH4H

          State : active

             Id : 00000004

    Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)


[HitR0]:

           UUID : 73ecf2cf:fcfd2598:d6523381:71e57931

     RAID Level : 0

        Members : 4

          Slots : [_UUU]

    Failed disk : 1

      This Slot : 2

     Array Size : 4294967296 (2048.00 GiB 2199.02 GB)

   Per Dev Size : 1073742088 (512.00 GiB 549.76 GB)

  Sector Offset : 0

    Num Stripes : 4194304

     Chunk Size : 128 KiB

       Reserved : 0

  Migrate State : idle

      Map State : failed

    Dirty State : clean


[HitR5]:

           UUID : 71626250:b8fc1262:3545d952:69eb329e

     RAID Level : 5

        Members : 4

          Slots : [_UU_]

    Failed disk : 3

      This Slot : 2

     Array Size : 20220831744 (9642.04 GiB 10353.07 GB)

   Per Dev Size : 6740279304 (3214.02 GiB 3451.02 GB)

  Sector Offset : 1073746184

    Num Stripes : 26329208

     Chunk Size : 128 KiB

       Reserved : 0

  Migrate State : idle

      Map State : failed

    Dirty State : clean


  Disk00 Serial : PL2311LAG1P82C:0

          State : active

             Id : ffffffff

    Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)


  Disk01 Serial : PL1321LAG4NMEH

          State : active

             Id : 00000003

    Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)


  Disk03 Serial : PL1321LAG4RXEH

          State : active

             Id : 00000005

    Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)

--047d7bdc7d5a82160904eebd37f9
Content-Type: application/octet-stream; name="output.log"
Content-Disposition: attachment; filename="output.log"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hpth6cuu0

L2Rldi9zZGYxOgogICBNQlIgTWFnaWMgOiBhYTU1ClBhcnRpdGlvblswXSA6ICAgIDQzMjg3MTEx
NyBzZWN0b3JzIGF0ICAgMzIyNDQ5ODkyMyAodHlwZSAwNykKUGFydGl0aW9uWzFdIDogICAxOTUz
NDYwMDM0IHNlY3RvcnMgYXQgICAzMjcyMDIwOTQxICh0eXBlIDE2KQpQYXJ0aXRpb25bM10gOiAg
ICA5MjQzMzU3OTQgc2VjdG9ycyBhdCAgICAgNTAyMDA1NzYgKHR5cGUgMDApCi9kZXYvc2RmOgog
ICBNQlIgTWFnaWMgOiBhYTU1ClBhcnRpdGlvblswXSA6ICAgICAxNTc2OTYwMCBzZWN0b3JzIGF0
ICAgICAgICAgMjA0OCAodHlwZSAwYikKL2Rldi9zZGU6CiAgICAgICAgICBNYWdpYyA6IEludGVs
IFJhaWQgSVNNIENmZyBTaWcuCiAgICAgICAgVmVyc2lvbiA6IDEuMy4wMAogICAgT3JpZyBGYW1p
bHkgOiBmMzQzN2M5YgogICAgICAgICBGYW1pbHkgOiBmMzQzN2M5ZAogICAgIEdlbmVyYXRpb24g
OiAwMDAwMmM1ZgogICAgIEF0dHJpYnV0ZXMgOiBBbGwgc3VwcG9ydGVkCiAgICAgICAgICAgVVVJ
RCA6IDQ3YjAxMWM3OjRhODUzMWVhOjdlOTRhYjkzOjA2MDM0OTUyCiAgICAgICBDaGVja3N1bSA6
IDY3MWY1Zjg0IGNvcnJlY3QKICAgIE1QQiBTZWN0b3JzIDogMgogICAgICAgICAgRGlza3MgOiA0
CiAgIFJBSUQgRGV2aWNlcyA6IDIKCiAgRGlzazAzIFNlcmlhbCA6IFBMMTMyMUxBRzRSWEVICiAg
ICAgICAgICBTdGF0ZSA6IGFjdGl2ZQogICAgICAgICAgICAgSWQgOiAwMDAwMDAwNQogICAgVXNh
YmxlIFNpemUgOiA3ODE0MDMwODYyICgzNzI2LjAyIEdpQiA0MDAwLjc4IEdCKQoKW0hpdFIwXToK
ICAgICAgICAgICBVVUlEIDogNzNlY2YyY2Y6ZmNmZDI1OTg6ZDY1MjMzODE6NzFlNTc5MzEKICAg
ICBSQUlEIExldmVsIDogMAogICAgICAgIE1lbWJlcnMgOiA0CiAgICAgICAgICBTbG90cyA6IFtf
VVVVXQogICAgRmFpbGVkIGRpc2sgOiAxCiAgICAgIFRoaXMgU2xvdCA6IDMKICAgICBBcnJheSBT
aXplIDogNDI5NDk2NzI5NiAoMjA0OC4wMCBHaUIgMjE5OS4wMiBHQikKICAgUGVyIERldiBTaXpl
IDogMTA3Mzc0MjA4OCAoNTEyLjAwIEdpQiA1NDkuNzYgR0IpCiAgU2VjdG9yIE9mZnNldCA6IDAK
ICAgIE51bSBTdHJpcGVzIDogNDE5NDMwNAogICAgIENodW5rIFNpemUgOiAxMjggS2lCCiAgICAg
ICBSZXNlcnZlZCA6IDAKICBNaWdyYXRlIFN0YXRlIDogaWRsZQogICAgICBNYXAgU3RhdGUgOiBm
YWlsZWQKICAgIERpcnR5IFN0YXRlIDogY2xlYW4KCltIaXRSNV06CiAgICAgICAgICAgVVVJRCA6
IDcxNjI2MjUwOmI4ZmMxMjYyOjM1NDVkOTUyOjY5ZWIzMjllCiAgICAgUkFJRCBMZXZlbCA6IDUK
ICAgICAgICBNZW1iZXJzIDogNAogICAgICAgICAgU2xvdHMgOiBbX1VVX10KICAgIEZhaWxlZCBk
aXNrIDogMwogICAgICBUaGlzIFNsb3QgOiAzIChvdXQtb2Ytc3luYykKICAgICBBcnJheSBTaXpl
IDogMjAyMjA4MzE3NDQgKDk2NDIuMDQgR2lCIDEwMzUzLjA3IEdCKQogICBQZXIgRGV2IFNpemUg
OiA2NzQwMjc5MzA0ICgzMjE0LjAyIEdpQiAzNDUxLjAyIEdCKQogIFNlY3RvciBPZmZzZXQgOiAx
MDczNzQ2MTg0CiAgICBOdW0gU3RyaXBlcyA6IDI2MzI5MjA4CiAgICAgQ2h1bmsgU2l6ZSA6IDEy
OCBLaUIKICAgICAgIFJlc2VydmVkIDogMAogIE1pZ3JhdGUgU3RhdGUgOiBpZGxlCiAgICAgIE1h
cCBTdGF0ZSA6IGZhaWxlZAogICAgRGlydHkgU3RhdGUgOiBjbGVhbgoKICBEaXNrMDAgU2VyaWFs
IDogUEwyMzExTEFHMVA4MkM6MAogICAgICAgICAgU3RhdGUgOiBhY3RpdmUKICAgICAgICAgICAg
IElkIDogZmZmZmZmZmYKICAgIFVzYWJsZSBTaXplIDogNzgxNDAzMDg2MiAoMzcyNi4wMiBHaUIg
NDAwMC43OCBHQikKCiAgRGlzazAxIFNlcmlhbCA6IFBMMTMyMUxBRzROTUVICiAgICAgICAgICBT
dGF0ZSA6IGFjdGl2ZQogICAgICAgICAgICAgSWQgOiAwMDAwMDAwMwogICAgVXNhYmxlIFNpemUg
OiA3ODE0MDMwODYyICgzNzI2LjAyIEdpQiA0MDAwLjc4IEdCKQoKICBEaXNrMDIgU2VyaWFsIDog
UEwxMzIxTEFHNFRINEgKICAgICAgICAgIFN0YXRlIDogYWN0aXZlCiAgICAgICAgICAgICBJZCA6
IDAwMDAwMDA0CiAgICBVc2FibGUgU2l6ZSA6IDc4MTQwMzA4NjIgKDM3MjYuMDIgR2lCIDQwMDAu
NzggR0IpCi9kZXYvc2RkOgogICAgICAgICAgTWFnaWMgOiBJbnRlbCBSYWlkIElTTSBDZmcgU2ln
LgogICAgICAgIFZlcnNpb24gOiAxLjMuMDAKICAgIE9yaWcgRmFtaWx5IDogZjM0MzdjOWIKICAg
ICAgICAgRmFtaWx5IDogZjM0MzdjOWQKICAgICBHZW5lcmF0aW9uIDogMDAwMDJjNWYKICAgICBB
dHRyaWJ1dGVzIDogQWxsIHN1cHBvcnRlZAogICAgICAgICAgIFVVSUQgOiA0N2IwMTFjNzo0YTg1
MzFlYTo3ZTk0YWI5MzowNjAzNDk1MgogICAgICAgQ2hlY2tzdW0gOiA2NzFmNWY4NCBjb3JyZWN0
CiAgICBNUEIgU2VjdG9ycyA6IDIKICAgICAgICAgIERpc2tzIDogNAogICBSQUlEIERldmljZXMg
OiAyCgogIERpc2swMiBTZXJpYWwgOiBQTDEzMjFMQUc0VEg0SAogICAgICAgICAgU3RhdGUgOiBh
Y3RpdmUKICAgICAgICAgICAgIElkIDogMDAwMDAwMDQKICAgIFVzYWJsZSBTaXplIDogNzgxNDAz
MDg2MiAoMzcyNi4wMiBHaUIgNDAwMC43OCBHQikKCltIaXRSMF06CiAgICAgICAgICAgVVVJRCA6
IDczZWNmMmNmOmZjZmQyNTk4OmQ2NTIzMzgxOjcxZTU3OTMxCiAgICAgUkFJRCBMZXZlbCA6IDAK
ICAgICAgICBNZW1iZXJzIDogNAogICAgICAgICAgU2xvdHMgOiBbX1VVVV0KICAgIEZhaWxlZCBk
aXNrIDogMQogICAgICBUaGlzIFNsb3QgOiAyCiAgICAgQXJyYXkgU2l6ZSA6IDQyOTQ5NjcyOTYg
KDIwNDguMDAgR2lCIDIxOTkuMDIgR0IpCiAgIFBlciBEZXYgU2l6ZSA6IDEwNzM3NDIwODggKDUx
Mi4wMCBHaUIgNTQ5Ljc2IEdCKQogIFNlY3RvciBPZmZzZXQgOiAwCiAgICBOdW0gU3RyaXBlcyA6
IDQxOTQzMDQKICAgICBDaHVuayBTaXplIDogMTI4IEtpQgogICAgICAgUmVzZXJ2ZWQgOiAwCiAg
TWlncmF0ZSBTdGF0ZSA6IGlkbGUKICAgICAgTWFwIFN0YXRlIDogZmFpbGVkCiAgICBEaXJ0eSBT
dGF0ZSA6IGNsZWFuCgpbSGl0UjVdOgogICAgICAgICAgIFVVSUQgOiA3MTYyNjI1MDpiOGZjMTI2
MjozNTQ1ZDk1Mjo2OWViMzI5ZQogICAgIFJBSUQgTGV2ZWwgOiA1CiAgICAgICAgTWVtYmVycyA6
IDQKICAgICAgICAgIFNsb3RzIDogW19VVV9dCiAgICBGYWlsZWQgZGlzayA6IDMKICAgICAgVGhp
cyBTbG90IDogMgogICAgIEFycmF5IFNpemUgOiAyMDIyMDgzMTc0NCAoOTY0Mi4wNCBHaUIgMTAz
NTMuMDcgR0IpCiAgIFBlciBEZXYgU2l6ZSA6IDY3NDAyNzkzMDQgKDMyMTQuMDIgR2lCIDM0NTEu
MDIgR0IpCiAgU2VjdG9yIE9mZnNldCA6IDEwNzM3NDYxODQKICAgIE51bSBTdHJpcGVzIDogMjYz
MjkyMDgKICAgICBDaHVuayBTaXplIDogMTI4IEtpQgogICAgICAgUmVzZXJ2ZWQgOiAwCiAgTWln
cmF0ZSBTdGF0ZSA6IGlkbGUKICAgICAgTWFwIFN0YXRlIDogZmFpbGVkCiAgICBEaXJ0eSBTdGF0
ZSA6IGNsZWFuCgogIERpc2swMCBTZXJpYWwgOiBQTDIzMTFMQUcxUDgyQzowCiAgICAgICAgICBT
dGF0ZSA6IGFjdGl2ZQogICAgICAgICAgICAgSWQgOiBmZmZmZmZmZgogICAgVXNhYmxlIFNpemUg
OiA3ODE0MDMwODYyICgzNzI2LjAyIEdpQiA0MDAwLjc4IEdCKQoKICBEaXNrMDEgU2VyaWFsIDog
UEwxMzIxTEFHNE5NRUgKICAgICAgICAgIFN0YXRlIDogYWN0aXZlCiAgICAgICAgICAgICBJZCA6
IDAwMDAwMDAzCiAgICBVc2FibGUgU2l6ZSA6IDc4MTQwMzA4NjIgKDM3MjYuMDIgR2lCIDQwMDAu
NzggR0IpCgogIERpc2swMyBTZXJpYWwgOiBQTDEzMjFMQUc0UlhFSAogICAgICAgICAgU3RhdGUg
OiBhY3RpdmUKICAgICAgICAgICAgIElkIDogMDAwMDAwMDUKICAgIFVzYWJsZSBTaXplIDogNzgx
NDAzMDg2MiAoMzcyNi4wMiBHaUIgNDAwMC43OCBHQikKL2Rldi9zZGM6CiAgICAgICAgICBNYWdp
YyA6IEludGVsIFJhaWQgSVNNIENmZyBTaWcuCiAgICAgICAgVmVyc2lvbiA6IDEuMy4wMAogICAg
T3JpZyBGYW1pbHkgOiBmMzQzN2M5YgogICAgICAgICBGYW1pbHkgOiBmMzQzN2M5ZAogICAgIEdl
bmVyYXRpb24gOiAwMDAwMmM1ZgogICAgIEF0dHJpYnV0ZXMgOiBBbGwgc3VwcG9ydGVkCiAgICAg
ICAgICAgVVVJRCA6IDQ3YjAxMWM3OjRhODUzMWVhOjdlOTRhYjkzOjA2MDM0OTUyCiAgICAgICBD
aGVja3N1bSA6IDY3MWY1Zjg0IGNvcnJlY3QKICAgIE1QQiBTZWN0b3JzIDogMgogICAgICAgICAg
RGlza3MgOiA0CiAgIFJBSUQgRGV2aWNlcyA6IDIKCiAgRGlzazAxIFNlcmlhbCA6IFBMMTMyMUxB
RzROTUVICiAgICAgICAgICBTdGF0ZSA6IGFjdGl2ZQogICAgICAgICAgICAgSWQgOiAwMDAwMDAw
MwogICAgVXNhYmxlIFNpemUgOiA3ODE0MDMwODYyICgzNzI2LjAyIEdpQiA0MDAwLjc4IEdCKQoK
W0hpdFIwXToKICAgICAgICAgICBVVUlEIDogNzNlY2YyY2Y6ZmNmZDI1OTg6ZDY1MjMzODE6NzFl
NTc5MzEKICAgICBSQUlEIExldmVsIDogMAogICAgICAgIE1lbWJlcnMgOiA0CiAgICAgICAgICBT
bG90cyA6IFtfVVVVXQogICAgRmFpbGVkIGRpc2sgOiAxCiAgICAgIFRoaXMgU2xvdCA6IDEKICAg
ICBBcnJheSBTaXplIDogNDI5NDk2NzI5NiAoMjA0OC4wMCBHaUIgMjE5OS4wMiBHQikKICAgUGVy
IERldiBTaXplIDogMTA3Mzc0MjA4OCAoNTEyLjAwIEdpQiA1NDkuNzYgR0IpCiAgU2VjdG9yIE9m
ZnNldCA6IDAKICAgIE51bSBTdHJpcGVzIDogNDE5NDMwNAogICAgIENodW5rIFNpemUgOiAxMjgg
S2lCCiAgICAgICBSZXNlcnZlZCA6IDAKICBNaWdyYXRlIFN0YXRlIDogaWRsZQogICAgICBNYXAg
U3RhdGUgOiBmYWlsZWQKICAgIERpcnR5IFN0YXRlIDogY2xlYW4KCltIaXRSNV06CiAgICAgICAg
ICAgVVVJRCA6IDcxNjI2MjUwOmI4ZmMxMjYyOjM1NDVkOTUyOjY5ZWIzMjllCiAgICAgUkFJRCBM
ZXZlbCA6IDUKICAgICAgICBNZW1iZXJzIDogNAogICAgICAgICAgU2xvdHMgOiBbX1VVX10KICAg
IEZhaWxlZCBkaXNrIDogMwogICAgICBUaGlzIFNsb3QgOiAxCiAgICAgQXJyYXkgU2l6ZSA6IDIw
MjIwODMxNzQ0ICg5NjQyLjA0IEdpQiAxMDM1My4wNyBHQikKICAgUGVyIERldiBTaXplIDogNjc0
MDI3OTMwNCAoMzIxNC4wMiBHaUIgMzQ1MS4wMiBHQikKICBTZWN0b3IgT2Zmc2V0IDogMTA3Mzc0
NjE4NAogICAgTnVtIFN0cmlwZXMgOiAyNjMyOTIwOAogICAgIENodW5rIFNpemUgOiAxMjggS2lC
CiAgICAgICBSZXNlcnZlZCA6IDAKICBNaWdyYXRlIFN0YXRlIDogaWRsZQogICAgICBNYXAgU3Rh
dGUgOiBmYWlsZWQKICAgIERpcnR5IFN0YXRlIDogY2xlYW4KCiAgRGlzazAwIFNlcmlhbCA6IFBM
MjMxMUxBRzFQODJDOjAKICAgICAgICAgIFN0YXRlIDogYWN0aXZlCiAgICAgICAgICAgICBJZCA6
IGZmZmZmZmZmCiAgICBVc2FibGUgU2l6ZSA6IDc4MTQwMzA4NjIgKDM3MjYuMDIgR2lCIDQwMDAu
NzggR0IpCgogIERpc2swMiBTZXJpYWwgOiBQTDEzMjFMQUc0VEg0SAogICAgICAgICAgU3RhdGUg
OiBhY3RpdmUKICAgICAgICAgICAgIElkIDogMDAwMDAwMDQKICAgIFVzYWJsZSBTaXplIDogNzgx
NDAzMDg2MiAoMzcyNi4wMiBHaUIgNDAwMC43OCBHQikKCiAgRGlzazAzIFNlcmlhbCA6IFBMMTMy
MUxBRzRSWEVICiAgICAgICAgICBTdGF0ZSA6IGFjdGl2ZQogICAgICAgICAgICAgSWQgOiAwMDAw
MDAwNQogICAgVXNhYmxlIFNpemUgOiA3ODE0MDMwODYyICgzNzI2LjAyIEdpQiA0MDAwLjc4IEdC
KQovZGV2L3NkYjoKICAgTUJSIE1hZ2ljIDogYWE1NQpQYXJ0aXRpb25bMF0gOiAgIDQyOTQ5Njcy
OTUgc2VjdG9ycyBhdCAgICAgICAgICAgIDEgKHR5cGUgZWUpCi9kZXYvc2RhMjoKICAgTUJSIE1h
Z2ljIDogYWE1NQpQYXJ0aXRpb25bMF0gOiAgIDE4MTYyMTAyODQgc2VjdG9ycyBhdCAgIDE5MjAy
MjE5ODQgKHR5cGUgNzIpClBhcnRpdGlvblsxXSA6ICAgMTk1MzY1MzEwOCBzZWN0b3JzIGF0ICAg
MTkzNjAyODE5MiAodHlwZSA2YykKUGFydGl0aW9uWzNdIDogICAgICAgICAgNDQ3IHNlY3RvcnMg
YXQgICAgIDI3NzIyMTIyICh0eXBlIDAwKQovZGV2L3NkYTE6CiAgIE1CUiBNYWdpYyA6IGFhNTUK
UGFydGl0aW9uWzBdIDogICAxODE2MjEwMjg0IHNlY3RvcnMgYXQgICAxOTIwMjIxOTg0ICh0eXBl
IDcyKQpQYXJ0aXRpb25bMV0gOiAgIDE5NTM2NTMxMDggc2VjdG9ycyBhdCAgIDE5MzYwMjgxOTIg
KHR5cGUgNmMpClBhcnRpdGlvblszXSA6ICAgICAgICAgIDQ0NyBzZWN0b3JzIGF0ICAgICAyNzcy
MjEyMiAodHlwZSAwMCkKL2Rldi9zZGE6CiAgIE1CUiBNYWdpYyA6IGFhNTUKUGFydGl0aW9uWzBd
IDogICAgICAgNzE2ODAwIHNlY3RvcnMgYXQgICAgICAgICAyMDQ4ICh0eXBlIDA3KQpQYXJ0aXRp
b25bMV0gOiAgICA0OTkzOTY2MDggc2VjdG9ycyBhdCAgICAgICA3MTg4NDggKHR5cGUgMDcpCi9k
ZXYvbWQxMjc6CiAgICAgICAgICBNYWdpYyA6IEludGVsIFJhaWQgSVNNIENmZyBTaWcuCiAgICAg
ICAgVmVyc2lvbiA6IDEuMy4wMAogICAgT3JpZyBGYW1pbHkgOiBmMzQzN2M5YgogICAgICAgICBG
YW1pbHkgOiBmMzQzN2M5ZAogICAgIEdlbmVyYXRpb24gOiAwMDAwMmM1ZgogICAgIEF0dHJpYnV0
ZXMgOiBBbGwgc3VwcG9ydGVkCiAgICAgICAgICAgVVVJRCA6IDQ3YjAxMWM3OjRhODUzMWVhOjdl
OTRhYjkzOjA2MDM0OTUyCiAgICAgICBDaGVja3N1bSA6IDY3MWY1Zjg0IGNvcnJlY3QKICAgIE1Q
QiBTZWN0b3JzIDogMgogICAgICAgICAgRGlza3MgOiA0CiAgIFJBSUQgRGV2aWNlcyA6IDIKCiAg
RGlzazAyIFNlcmlhbCA6IFBMMTMyMUxBRzRUSDRICiAgICAgICAgICBTdGF0ZSA6IGFjdGl2ZQog
ICAgICAgICAgICAgSWQgOiAwMDAwMDAwNAogICAgVXNhYmxlIFNpemUgOiA3ODE0MDMwODYyICgz
NzI2LjAyIEdpQiA0MDAwLjc4IEdCKQoKW0hpdFIwXToKICAgICAgICAgICBVVUlEIDogNzNlY2Yy
Y2Y6ZmNmZDI1OTg6ZDY1MjMzODE6NzFlNTc5MzEKICAgICBSQUlEIExldmVsIDogMAogICAgICAg
IE1lbWJlcnMgOiA0CiAgICAgICAgICBTbG90cyA6IFtfVVVVXQogICAgRmFpbGVkIGRpc2sgOiAx
CiAgICAgIFRoaXMgU2xvdCA6IDIKICAgICBBcnJheSBTaXplIDogNDI5NDk2NzI5NiAoMjA0OC4w
MCBHaUIgMjE5OS4wMiBHQikKICAgUGVyIERldiBTaXplIDogMTA3Mzc0MjA4OCAoNTEyLjAwIEdp
QiA1NDkuNzYgR0IpCiAgU2VjdG9yIE9mZnNldCA6IDAKICAgIE51bSBTdHJpcGVzIDogNDE5NDMw
NAogICAgIENodW5rIFNpemUgOiAxMjggS2lCCiAgICAgICBSZXNlcnZlZCA6IDAKICBNaWdyYXRl
IFN0YXRlIDogaWRsZQogICAgICBNYXAgU3RhdGUgOiBmYWlsZWQKICAgIERpcnR5IFN0YXRlIDog
Y2xlYW4KCltIaXRSNV06CiAgICAgICAgICAgVVVJRCA6IDcxNjI2MjUwOmI4ZmMxMjYyOjM1NDVk
OTUyOjY5ZWIzMjllCiAgICAgUkFJRCBMZXZlbCA6IDUKICAgICAgICBNZW1iZXJzIDogNAogICAg
ICAgICAgU2xvdHMgOiBbX1VVX10KICAgIEZhaWxlZCBkaXNrIDogMwogICAgICBUaGlzIFNsb3Qg
OiAyCiAgICAgQXJyYXkgU2l6ZSA6IDIwMjIwODMxNzQ0ICg5NjQyLjA0IEdpQiAxMDM1My4wNyBH
QikKICAgUGVyIERldiBTaXplIDogNjc0MDI3OTMwNCAoMzIxNC4wMiBHaUIgMzQ1MS4wMiBHQikK
ICBTZWN0b3IgT2Zmc2V0IDogMTA3Mzc0NjE4NAogICAgTnVtIFN0cmlwZXMgOiAyNjMyOTIwOAog
ICAgIENodW5rIFNpemUgOiAxMjggS2lCCiAgICAgICBSZXNlcnZlZCA6IDAKICBNaWdyYXRlIFN0
YXRlIDogaWRsZQogICAgICBNYXAgU3RhdGUgOiBmYWlsZWQKICAgIERpcnR5IFN0YXRlIDogY2xl
YW4KCiAgRGlzazAwIFNlcmlhbCA6IFBMMjMxMUxBRzFQODJDOjAKICAgICAgICAgIFN0YXRlIDog
YWN0aXZlCiAgICAgICAgICAgICBJZCA6IGZmZmZmZmZmCiAgICBVc2FibGUgU2l6ZSA6IDc4MTQw
MzA4NjIgKDM3MjYuMDIgR2lCIDQwMDAuNzggR0IpCgogIERpc2swMSBTZXJpYWwgOiBQTDEzMjFM
QUc0Tk1FSAogICAgICAgICAgU3RhdGUgOiBhY3RpdmUKICAgICAgICAgICAgIElkIDogMDAwMDAw
MDMKICAgIFVzYWJsZSBTaXplIDogNzgxNDAzMDg2MiAoMzcyNi4wMiBHaUIgNDAwMC43OCBHQikK
CiAgRGlzazAzIFNlcmlhbCA6IFBMMTMyMUxBRzRSWEVICiAgICAgICAgICBTdGF0ZSA6IGFjdGl2
ZQogICAgICAgICAgICAgSWQgOiAwMDAwMDAwNQogICAgVXNhYmxlIFNpemUgOiA3ODE0MDMwODYy
ICgzNzI2LjAyIEdpQiA0MDAwLjc4IEdCKQo=
--047d7bdc7d5a82160904eebd37f9--
