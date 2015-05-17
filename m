From: Marco Fuckner <marco@die-fuckners.de>
Subject: RAID5 assemble fails after reboot while reshaping
Date: Sun, 17 May 2015 18:44:01 +0200
Message-ID: <5558C551.80203@die-fuckners.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070908060708030504000407"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------070908060708030504000407
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi everybody,

first of all, I'm using mdadm 3.3.2 on linux 4.0.1, all of my disks are
partitioned with the same geometry.

I wanted to grow my 4 disk RAID5 array to 7 disks. After adding the
disks and initiating the grow, the reshape didn't seem to start:

    md0 : active raid5 sdf1[7] sde1[6] sdd1[5] sdg1[3] sdb1[4] sdh1[1]
sdc1[0]
        11720044800 blocks super 1.2 level 5, 256k chunk, algorithm 2
[7/7] [UUUUUUU]
        [>....................]  reshape =  0.0% (0/3906681600)
finish=166847860.0min speed=0K/sec
        bitmap: 0/30 pages [0KB], 65536KB chunk

I waited about three hours and checked again:

    md0 : active raid5 sdf1[7] sde1[6] sdd1[5] sdg1[3] sdb1[4] sdh1[1]
sdc1[0]
        11720044800 blocks super 1.2 level 5, 256k chunk, algorithm 2
[7/7] [UUUUUUU]
        [>....................]  reshape =  0.0% (0/3906681600)
finish=9599856140.0min speed=0K/sec
        bitmap: 0/30 pages [0KB], 65536KB chunk

Unfortunately, I forgot to save the output of the grow command, but it
exited with 0.
/mdadm --misc --detail /dev/md0/ didn't show anything suspicious to me:

/dev/md0:
    Version : 1.2
    Creation Time : Sun Nov  9 02:38:25 2014
    Raid Level : raid5
    Array Size : 11720044800 (11177.11 GiB 12001.33 GB)
    Used Dev Size : 3906681600 (3725.70 GiB 4000.44 GB)
    Raid Devices : 7
    Total Devices : 7
    Persistence : Superblock is persistent

    Intent Bitmap : Internal

    Update Time : Mon May 11 11:55:07 2015
    State : clean, reshaping
    Active Devices : 7
    Working Devices : 7
    Failed Devices : 0
    Spare Devices : 0

    Layout : left-symmetric
    Chunk Size : 256K

    Reshape Status : 0% complete
    Delta Devices : 3, (4->7)

    Name : anaNAS:0  (local to host anaNAS)
    UUID : 33f0604f:46e80f5e:11b1a694:608fd9b3
    Events : 51839

    Number   Major   Minor   RaidDevice   State
        0           8           33        0              active sync  
/dev/sdc1
        1           8           113      1              active sync  
/dev/sdh1
        3           8           97        2              active sync  
/dev/sdg1
        4           8           17        3              active sync  
/dev/sdb1
        7           8           81        4              active sync  
/dev/sdf1
        6           8           65        5              active sync  
/dev/sde1
        5           8           49        6              active sync  
/dev/sdd1

As it looked like it wouldn't be ready until long after my death and I
also wrote a backup file, somehow restarting and continuing afterwards
seemed reasonable to me.
The source I was reading suggested running /mdadm /dev/md0 --continue
--backup-file=$FILE/. Apparently this command was wrong, and I couldn't
reassamble the array:

# mdadm --assemble /dev/md0 --verbose /dev/sd[b-h]1
--backup-file=/root/grow7backup.bak

    mdadm: looking for devices for /dev/md0
    mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 4.
    mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 5.
    mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 6.
    mdadm: /dev/sdg1 is identified as a member of /dev/md0, slot 2.
    mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 3.
    mdadm: /dev/sdh1 is identified as a member of /dev/md0, slot 1.
    mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 0.
    mdadm: :/dev/md0 has an active reshape - checking if critical
section needs to be restored
    mdadm: No backup metadata on /root/grow7backup.bak
    mdadm: No backup metadata on device-4
    mdadm: No backup metadata on device-5
    mdadm: No backup metadata on device-6
    mdadm: Failed to find backup of critical section
    mdadm: Failed to restore critical section for reshape, sorry.

I started searching for answers but didn't find anything helpful except
the hint on the raid.wiki.kernel.org page to send an email here. The
last sentence from mdadm sounds a bit pessimistic, but I hope someone in
here can help me. The output of /mdadm --examine /dev/sd[bh]1 /is in the
attachment.

Thanks in advance,

Marco

--------------070908060708030504000407
Content-Type: text/plain; charset=UTF-8;
 name="raid.status"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="raid.status"

L2Rldi9zZGIxOgogICAgICAgICAgTWFnaWMgOiBhOTJiNGVmYwogICAgICAgIFZlcnNpb24g
OiAxLjIKICAgIEZlYXR1cmUgTWFwIDogMHg1CiAgICAgQXJyYXkgVVVJRCA6IDMzZjA2MDRm
OjQ2ZTgwZjVlOjExYjFhNjk0OjYwOGZkOWIzCiAgICAgICAgICAgTmFtZSA6IGFuYU5BUzow
ICAobG9jYWwgdG8gaG9zdCBhbmFOQVMpCiAgQ3JlYXRpb24gVGltZSA6IFN1biBOb3YgIDkg
MDI6Mzg6MjUgMjAxNAogICAgIFJhaWQgTGV2ZWwgOiByYWlkNQogICBSYWlkIERldmljZXMg
OiA3CgogQXZhaWwgRGV2IFNpemUgOiA3ODEzMzYzMzQzICgzNzI1LjcwIEdpQiA0MDAwLjQ0
IEdCKQogICAgIEFycmF5IFNpemUgOiAyMzQ0MDA4OTYwMCAoMjIzNTQuMjEgR2lCIDI0MDAy
LjY1IEdCKQogIFVzZWQgRGV2IFNpemUgOiA3ODEzMzYzMjAwICgzNzI1LjcwIEdpQiA0MDAw
LjQ0IEdCKQogICAgRGF0YSBPZmZzZXQgOiAyNjIxNDQgc2VjdG9ycwogICBTdXBlciBPZmZz
ZXQgOiA4IHNlY3RvcnMKICAgVW51c2VkIFNwYWNlIDogYmVmb3JlPTI2MjA1NiBzZWN0b3Jz
LCBhZnRlcj0xNDMgc2VjdG9ycwogICAgICAgICAgU3RhdGUgOiBjbGVhbgogICAgRGV2aWNl
IFVVSUQgOiA3MjFmNDdiNjo0Mzc0NDUyYjo4Y2Y0ZDNjNjo2NzJjYWViMwoKSW50ZXJuYWwg
Qml0bWFwIDogOCBzZWN0b3JzIGZyb20gc3VwZXJibG9jawogIFJlc2hhcGUgcG9zJ24gOiAw
CiAgRGVsdGEgRGV2aWNlcyA6IDMgKDQtPjcpCgogICAgVXBkYXRlIFRpbWUgOiBNb24gTWF5
IDExIDE0OjM0OjMzIDIwMTUKICBCYWQgQmxvY2sgTG9nIDogNTEyIGVudHJpZXMgYXZhaWxh
YmxlIGF0IG9mZnNldCA3MiBzZWN0b3JzCiAgICAgICBDaGVja3N1bSA6IGM2YzIwMTc2IC0g
Y29ycmVjdAogICAgICAgICBFdmVudHMgOiA1MTg0MAoKICAgICAgICAgTGF5b3V0IDogbGVm
dC1zeW1tZXRyaWMKICAgICBDaHVuayBTaXplIDogMjU2SwoKICAgRGV2aWNlIFJvbGUgOiBB
Y3RpdmUgZGV2aWNlIDMKICAgQXJyYXkgU3RhdGUgOiBBQUFBQUFBICgnQScgPT0gYWN0aXZl
LCAnLicgPT0gbWlzc2luZywgJ1InID09IHJlcGxhY2luZykKL2Rldi9zZGMxOgogICAgICAg
ICAgTWFnaWMgOiBhOTJiNGVmYwogICAgICAgIFZlcnNpb24gOiAxLjIKICAgIEZlYXR1cmUg
TWFwIDogMHg1CiAgICAgQXJyYXkgVVVJRCA6IDMzZjA2MDRmOjQ2ZTgwZjVlOjExYjFhNjk0
OjYwOGZkOWIzCiAgICAgICAgICAgTmFtZSA6IGFuYU5BUzowICAobG9jYWwgdG8gaG9zdCBh
bmFOQVMpCiAgQ3JlYXRpb24gVGltZSA6IFN1biBOb3YgIDkgMDI6Mzg6MjUgMjAxNAogICAg
IFJhaWQgTGV2ZWwgOiByYWlkNQogICBSYWlkIERldmljZXMgOiA3CgogQXZhaWwgRGV2IFNp
emUgOiA3ODEzMzYzMzQzICgzNzI1LjcwIEdpQiA0MDAwLjQ0IEdCKQogICAgIEFycmF5IFNp
emUgOiAyMzQ0MDA4OTYwMCAoMjIzNTQuMjEgR2lCIDI0MDAyLjY1IEdCKQogIFVzZWQgRGV2
IFNpemUgOiA3ODEzMzYzMjAwICgzNzI1LjcwIEdpQiA0MDAwLjQ0IEdCKQogICAgRGF0YSBP
ZmZzZXQgOiAyNjIxNDQgc2VjdG9ycwogICBTdXBlciBPZmZzZXQgOiA4IHNlY3RvcnMKICAg
VW51c2VkIFNwYWNlIDogYmVmb3JlPTI2MjA1NiBzZWN0b3JzLCBhZnRlcj0xNDMgc2VjdG9y
cwogICAgICAgICAgU3RhdGUgOiBjbGVhbgogICAgRGV2aWNlIFVVSUQgOiA1MjhlYTU3MDoz
NTc4Y2E4Mjo0ZTg2ZDMzMDpiZjMwNjM0YwoKSW50ZXJuYWwgQml0bWFwIDogOCBzZWN0b3Jz
IGZyb20gc3VwZXJibG9jawogIFJlc2hhcGUgcG9zJ24gOiAwCiAgRGVsdGEgRGV2aWNlcyA6
IDMgKDQtPjcpCgogICAgVXBkYXRlIFRpbWUgOiBNb24gTWF5IDExIDE0OjM0OjMzIDIwMTUK
ICBCYWQgQmxvY2sgTG9nIDogNTEyIGVudHJpZXMgYXZhaWxhYmxlIGF0IG9mZnNldCA3MiBz
ZWN0b3JzCiAgICAgICBDaGVja3N1bSA6IGRiNWEwYTVkIC0gY29ycmVjdAogICAgICAgICBF
dmVudHMgOiA1MTg0MAoKICAgICAgICAgTGF5b3V0IDogbGVmdC1zeW1tZXRyaWMKICAgICBD
aHVuayBTaXplIDogMjU2SwoKICAgRGV2aWNlIFJvbGUgOiBBY3RpdmUgZGV2aWNlIDAKICAg
QXJyYXkgU3RhdGUgOiBBQUFBQUFBICgnQScgPT0gYWN0aXZlLCAnLicgPT0gbWlzc2luZywg
J1InID09IHJlcGxhY2luZykKL2Rldi9zZGQxOgogICAgICAgICAgTWFnaWMgOiBhOTJiNGVm
YwogICAgICAgIFZlcnNpb24gOiAxLjIKICAgIEZlYXR1cmUgTWFwIDogMHg1CiAgICAgQXJy
YXkgVVVJRCA6IDMzZjA2MDRmOjQ2ZTgwZjVlOjExYjFhNjk0OjYwOGZkOWIzCiAgICAgICAg
ICAgTmFtZSA6IGFuYU5BUzowICAobG9jYWwgdG8gaG9zdCBhbmFOQVMpCiAgQ3JlYXRpb24g
VGltZSA6IFN1biBOb3YgIDkgMDI6Mzg6MjUgMjAxNAogICAgIFJhaWQgTGV2ZWwgOiByYWlk
NQogICBSYWlkIERldmljZXMgOiA3CgogQXZhaWwgRGV2IFNpemUgOiA3ODEzMzYzMzQzICgz
NzI1LjcwIEdpQiA0MDAwLjQ0IEdCKQogICAgIEFycmF5IFNpemUgOiAyMzQ0MDA4OTYwMCAo
MjIzNTQuMjEgR2lCIDI0MDAyLjY1IEdCKQogIFVzZWQgRGV2IFNpemUgOiA3ODEzMzYzMjAw
ICgzNzI1LjcwIEdpQiA0MDAwLjQ0IEdCKQogICAgRGF0YSBPZmZzZXQgOiAyNjIxNDQgc2Vj
dG9ycwogICBTdXBlciBPZmZzZXQgOiA4IHNlY3RvcnMKICAgVW51c2VkIFNwYWNlIDogYmVm
b3JlPTI2MjA1NiBzZWN0b3JzLCBhZnRlcj0xNDMgc2VjdG9ycwogICAgICAgICAgU3RhdGUg
OiBjbGVhbgogICAgRGV2aWNlIFVVSUQgOiBiNmRmZTRhMjo2ZGIxOTk3NTozNmI1YzQwMDpm
NDcwYWMyOAoKSW50ZXJuYWwgQml0bWFwIDogOCBzZWN0b3JzIGZyb20gc3VwZXJibG9jawog
IFJlc2hhcGUgcG9zJ24gOiAwCiAgRGVsdGEgRGV2aWNlcyA6IDMgKDQtPjcpCgogICAgVXBk
YXRlIFRpbWUgOiBNb24gTWF5IDExIDE0OjM0OjMzIDIwMTUKICBCYWQgQmxvY2sgTG9nIDog
NTEyIGVudHJpZXMgYXZhaWxhYmxlIGF0IG9mZnNldCA3MiBzZWN0b3JzCiAgICAgICBDaGVj
a3N1bSA6IGFjYTMwNDFiIC0gY29ycmVjdAogICAgICAgICBFdmVudHMgOiA1MTg0MAoKICAg
ICAgICAgTGF5b3V0IDogbGVmdC1zeW1tZXRyaWMKICAgICBDaHVuayBTaXplIDogMjU2SwoK
ICAgRGV2aWNlIFJvbGUgOiBBY3RpdmUgZGV2aWNlIDYKICAgQXJyYXkgU3RhdGUgOiBBQUFB
QUFBICgnQScgPT0gYWN0aXZlLCAnLicgPT0gbWlzc2luZywgJ1InID09IHJlcGxhY2luZykK
L2Rldi9zZGUxOgogICAgICAgICAgTWFnaWMgOiBhOTJiNGVmYwogICAgICAgIFZlcnNpb24g
OiAxLjIKICAgIEZlYXR1cmUgTWFwIDogMHg1CiAgICAgQXJyYXkgVVVJRCA6IDMzZjA2MDRm
OjQ2ZTgwZjVlOjExYjFhNjk0OjYwOGZkOWIzCiAgICAgICAgICAgTmFtZSA6IGFuYU5BUzow
ICAobG9jYWwgdG8gaG9zdCBhbmFOQVMpCiAgQ3JlYXRpb24gVGltZSA6IFN1biBOb3YgIDkg
MDI6Mzg6MjUgMjAxNAogICAgIFJhaWQgTGV2ZWwgOiByYWlkNQogICBSYWlkIERldmljZXMg
OiA3CgogQXZhaWwgRGV2IFNpemUgOiA3ODEzMzYzMzQzICgzNzI1LjcwIEdpQiA0MDAwLjQ0
IEdCKQogICAgIEFycmF5IFNpemUgOiAyMzQ0MDA4OTYwMCAoMjIzNTQuMjEgR2lCIDI0MDAy
LjY1IEdCKQogIFVzZWQgRGV2IFNpemUgOiA3ODEzMzYzMjAwICgzNzI1LjcwIEdpQiA0MDAw
LjQ0IEdCKQogICAgRGF0YSBPZmZzZXQgOiAyNjIxNDQgc2VjdG9ycwogICBTdXBlciBPZmZz
ZXQgOiA4IHNlY3RvcnMKICAgVW51c2VkIFNwYWNlIDogYmVmb3JlPTI2MjA1NiBzZWN0b3Jz
LCBhZnRlcj0xNDMgc2VjdG9ycwogICAgICAgICAgU3RhdGUgOiBjbGVhbgogICAgRGV2aWNl
IFVVSUQgOiBlMjMzMjkzYjo5MTlhYmVjYzpkNWQ3ZjBkNDo3YzFiNzQ4YgoKSW50ZXJuYWwg
Qml0bWFwIDogOCBzZWN0b3JzIGZyb20gc3VwZXJibG9jawogIFJlc2hhcGUgcG9zJ24gOiAw
CiAgRGVsdGEgRGV2aWNlcyA6IDMgKDQtPjcpCgogICAgVXBkYXRlIFRpbWUgOiBNb24gTWF5
IDExIDE0OjM0OjMzIDIwMTUKICBCYWQgQmxvY2sgTG9nIDogNTEyIGVudHJpZXMgYXZhaWxh
YmxlIGF0IG9mZnNldCA3MiBzZWN0b3JzCiAgICAgICBDaGVja3N1bSA6IGQzMDAwZTk0IC0g
Y29ycmVjdAogICAgICAgICBFdmVudHMgOiA1MTg0MAoKICAgICAgICAgTGF5b3V0IDogbGVm
dC1zeW1tZXRyaWMKICAgICBDaHVuayBTaXplIDogMjU2SwoKICAgRGV2aWNlIFJvbGUgOiBB
Y3RpdmUgZGV2aWNlIDUKICAgQXJyYXkgU3RhdGUgOiBBQUFBQUFBICgnQScgPT0gYWN0aXZl
LCAnLicgPT0gbWlzc2luZywgJ1InID09IHJlcGxhY2luZykKL2Rldi9zZGYxOgogICAgICAg
ICAgTWFnaWMgOiBhOTJiNGVmYwogICAgICAgIFZlcnNpb24gOiAxLjIKICAgIEZlYXR1cmUg
TWFwIDogMHg1CiAgICAgQXJyYXkgVVVJRCA6IDMzZjA2MDRmOjQ2ZTgwZjVlOjExYjFhNjk0
OjYwOGZkOWIzCiAgICAgICAgICAgTmFtZSA6IGFuYU5BUzowICAobG9jYWwgdG8gaG9zdCBh
bmFOQVMpCiAgQ3JlYXRpb24gVGltZSA6IFN1biBOb3YgIDkgMDI6Mzg6MjUgMjAxNAogICAg
IFJhaWQgTGV2ZWwgOiByYWlkNQogICBSYWlkIERldmljZXMgOiA3CgogQXZhaWwgRGV2IFNp
emUgOiA3ODEzMzYzMzQzICgzNzI1LjcwIEdpQiA0MDAwLjQ0IEdCKQogICAgIEFycmF5IFNp
emUgOiAyMzQ0MDA4OTYwMCAoMjIzNTQuMjEgR2lCIDI0MDAyLjY1IEdCKQogIFVzZWQgRGV2
IFNpemUgOiA3ODEzMzYzMjAwICgzNzI1LjcwIEdpQiA0MDAwLjQ0IEdCKQogICAgRGF0YSBP
ZmZzZXQgOiAyNjIxNDQgc2VjdG9ycwogICBTdXBlciBPZmZzZXQgOiA4IHNlY3RvcnMKICAg
VW51c2VkIFNwYWNlIDogYmVmb3JlPTI2MjA1NiBzZWN0b3JzLCBhZnRlcj0xNDMgc2VjdG9y
cwogICAgICAgICAgU3RhdGUgOiBjbGVhbgogICAgRGV2aWNlIFVVSUQgOiA3YTUxMzk3ZDo5
Nzg1NDMwYTpiYjRlNTAyZDpjMDdjNjM1NwoKSW50ZXJuYWwgQml0bWFwIDogOCBzZWN0b3Jz
IGZyb20gc3VwZXJibG9jawogIFJlc2hhcGUgcG9zJ24gOiAwCiAgRGVsdGEgRGV2aWNlcyA6
IDMgKDQtPjcpCgogICAgVXBkYXRlIFRpbWUgOiBNb24gTWF5IDExIDE0OjM0OjMzIDIwMTUK
ICBCYWQgQmxvY2sgTG9nIDogNTEyIGVudHJpZXMgYXZhaWxhYmxlIGF0IG9mZnNldCA3MiBz
ZWN0b3JzCiAgICAgICBDaGVja3N1bSA6IDc2ZTNlZjVjIC0gY29ycmVjdAogICAgICAgICBF
dmVudHMgOiA1MTg0MAoKICAgICAgICAgTGF5b3V0IDogbGVmdC1zeW1tZXRyaWMKICAgICBD
aHVuayBTaXplIDogMjU2SwoKICAgRGV2aWNlIFJvbGUgOiBBY3RpdmUgZGV2aWNlIDQKICAg
QXJyYXkgU3RhdGUgOiBBQUFBQUFBICgnQScgPT0gYWN0aXZlLCAnLicgPT0gbWlzc2luZywg
J1InID09IHJlcGxhY2luZykKL2Rldi9zZGcxOgogICAgICAgICAgTWFnaWMgOiBhOTJiNGVm
YwogICAgICAgIFZlcnNpb24gOiAxLjIKICAgIEZlYXR1cmUgTWFwIDogMHg1CiAgICAgQXJy
YXkgVVVJRCA6IDMzZjA2MDRmOjQ2ZTgwZjVlOjExYjFhNjk0OjYwOGZkOWIzCiAgICAgICAg
ICAgTmFtZSA6IGFuYU5BUzowICAobG9jYWwgdG8gaG9zdCBhbmFOQVMpCiAgQ3JlYXRpb24g
VGltZSA6IFN1biBOb3YgIDkgMDI6Mzg6MjUgMjAxNAogICAgIFJhaWQgTGV2ZWwgOiByYWlk
NQogICBSYWlkIERldmljZXMgOiA3CgogQXZhaWwgRGV2IFNpemUgOiA3ODEzMzYzMzQzICgz
NzI1LjcwIEdpQiA0MDAwLjQ0IEdCKQogICAgIEFycmF5IFNpemUgOiAyMzQ0MDA4OTYwMCAo
MjIzNTQuMjEgR2lCIDI0MDAyLjY1IEdCKQogIFVzZWQgRGV2IFNpemUgOiA3ODEzMzYzMjAw
ICgzNzI1LjcwIEdpQiA0MDAwLjQ0IEdCKQogICAgRGF0YSBPZmZzZXQgOiAyNjIxNDQgc2Vj
dG9ycwogICBTdXBlciBPZmZzZXQgOiA4IHNlY3RvcnMKICAgVW51c2VkIFNwYWNlIDogYmVm
b3JlPTI2MjA1NiBzZWN0b3JzLCBhZnRlcj0xNDMgc2VjdG9ycwogICAgICAgICAgU3RhdGUg
OiBjbGVhbgogICAgRGV2aWNlIFVVSUQgOiA3YjA4MzJhNzpkYTgxMDhjZDowYmQyNWVlODpj
NmJjMGJhNgoKSW50ZXJuYWwgQml0bWFwIDogOCBzZWN0b3JzIGZyb20gc3VwZXJibG9jawog
IFJlc2hhcGUgcG9zJ24gOiAwCiAgRGVsdGEgRGV2aWNlcyA6IDMgKDQtPjcpCgogICAgVXBk
YXRlIFRpbWUgOiBNb24gTWF5IDExIDE0OjM0OjMzIDIwMTUKICBCYWQgQmxvY2sgTG9nIDog
NTEyIGVudHJpZXMgYXZhaWxhYmxlIGF0IG9mZnNldCA3MiBzZWN0b3JzCiAgICAgICBDaGVj
a3N1bSA6IDZkNTg2NWY0IC0gY29ycmVjdAogICAgICAgICBFdmVudHMgOiA1MTg0MAoKICAg
ICAgICAgTGF5b3V0IDogbGVmdC1zeW1tZXRyaWMKICAgICBDaHVuayBTaXplIDogMjU2SwoK
ICAgRGV2aWNlIFJvbGUgOiBBY3RpdmUgZGV2aWNlIDIKICAgQXJyYXkgU3RhdGUgOiBBQUFB
QUFBICgnQScgPT0gYWN0aXZlLCAnLicgPT0gbWlzc2luZywgJ1InID09IHJlcGxhY2luZykK
L2Rldi9zZGgxOgogICAgICAgICAgTWFnaWMgOiBhOTJiNGVmYwogICAgICAgIFZlcnNpb24g
OiAxLjIKICAgIEZlYXR1cmUgTWFwIDogMHg1CiAgICAgQXJyYXkgVVVJRCA6IDMzZjA2MDRm
OjQ2ZTgwZjVlOjExYjFhNjk0OjYwOGZkOWIzCiAgICAgICAgICAgTmFtZSA6IGFuYU5BUzow
ICAobG9jYWwgdG8gaG9zdCBhbmFOQVMpCiAgQ3JlYXRpb24gVGltZSA6IFN1biBOb3YgIDkg
MDI6Mzg6MjUgMjAxNAogICAgIFJhaWQgTGV2ZWwgOiByYWlkNQogICBSYWlkIERldmljZXMg
OiA3CgogQXZhaWwgRGV2IFNpemUgOiA3ODEzMzYzMzQzICgzNzI1LjcwIEdpQiA0MDAwLjQ0
IEdCKQogICAgIEFycmF5IFNpemUgOiAyMzQ0MDA4OTYwMCAoMjIzNTQuMjEgR2lCIDI0MDAy
LjY1IEdCKQogIFVzZWQgRGV2IFNpemUgOiA3ODEzMzYzMjAwICgzNzI1LjcwIEdpQiA0MDAw
LjQ0IEdCKQogICAgRGF0YSBPZmZzZXQgOiAyNjIxNDQgc2VjdG9ycwogICBTdXBlciBPZmZz
ZXQgOiA4IHNlY3RvcnMKICAgVW51c2VkIFNwYWNlIDogYmVmb3JlPTI2MjA1NiBzZWN0b3Jz
LCBhZnRlcj0xNDMgc2VjdG9ycwogICAgICAgICAgU3RhdGUgOiBjbGVhbgogICAgRGV2aWNl
IFVVSUQgOiBkMTVkNDRmMjoxYzRlZDZkYzowNzI2YTg3NDpiMDQyMmVmMwoKSW50ZXJuYWwg
Qml0bWFwIDogOCBzZWN0b3JzIGZyb20gc3VwZXJibG9jawogIFJlc2hhcGUgcG9zJ24gOiAw
CiAgRGVsdGEgRGV2aWNlcyA6IDMgKDQtPjcpCgogICAgVXBkYXRlIFRpbWUgOiBNb24gTWF5
IDExIDE0OjM0OjMzIDIwMTUKICBCYWQgQmxvY2sgTG9nIDogNTEyIGVudHJpZXMgYXZhaWxh
YmxlIGF0IG9mZnNldCA3MiBzZWN0b3JzCiAgICAgICBDaGVja3N1bSA6IGExYTQ2MTcwIC0g
Y29ycmVjdAogICAgICAgICBFdmVudHMgOiA1MTg0MAoKICAgICAgICAgTGF5b3V0IDogbGVm
dC1zeW1tZXRyaWMKICAgICBDaHVuayBTaXplIDogMjU2SwoKICAgRGV2aWNlIFJvbGUgOiBB
Y3RpdmUgZGV2aWNlIDEKICAgQXJyYXkgU3RhdGUgOiBBQUFBQUFBICgnQScgPT0gYWN0aXZl
LCAnLicgPT0gbWlzc2luZywgJ1InID09IHJlcGxhY2luZykK
--------------070908060708030504000407--
