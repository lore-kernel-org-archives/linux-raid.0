From: =?UTF-8?B?0J/RkdGC0YAg0JEu?= <satnatantas@gmail.com>
Subject: ICH RAID5 delisted and broken after mdadm installation
Date: Mon, 18 Jan 2016 20:10:48 +0300
Message-ID: <CA+Ni7jMa2TSSYbDcZ-HQTp5O42UZ==r7wJ5dikXfytHgHF7pzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=94eb2c0b12ee9bda0105299ed542
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--94eb2c0b12ee9bda0105299ed542
Content-Type: text/plain; charset=UTF-8

Hello guys.

sda, sdb and sdd were a RAID5 array with 64K chunk size and were used
in Windows and were always connected to the ICH9r controller in this
order.

HDD containing the Windows (sdb) was failing, Windows crashed severly
and I booted into Debian (from sde) to backup information (BIOS listed
RAID5 volume correctly). I booted into Debian and installed mdadm, I
told it that all drives are needed for boot in the process (not true
atm).

After I installed mdadm no new partitions appeared in Gnome. After I
rebooted I saw in RAID BIOS output that sda and sdb are "offline
members" and that sdc is non-raid (it's true) and that sdd is non-raid
(it's false). Also, no RAID volumes are detected.

/dev/md/imsm0 is a link for /dev/md127 which is empty
/dev/md/imsm1 is a link for /dev/md128 which is empty

mdadm reports that no RAID superblock information was found on sdd.

"mdadm --assemble md0 sda sdb sdd" fails:
>mdadm: cannot open device sda: Device or resource busy
>mdadm: sda has no superblock - assembly aborted

It outputs the same for whhichever HDD I list first - sda, sdb, sdd.

Linux 2.6.32-5-amd64 #1 SMP Sun Dec 21 18:01:12 UTC 2014 x86_64 GNU/Linux
mdadm - v3.1.4 - 31st August 2010

I won't boot into Windows before I fix this. Please give me some tips.

P.S. What was I doing wrong? Except using ICH RAID (which, as I
learned ATM does not even implies additional hardware unit and is no
better than software RAID) and using Windows on a failing drive of
course.

--94eb2c0b12ee9bda0105299ed542
Content-Type: application/octet-stream; name=raid_status
Content-Disposition: attachment; filename=raid_status
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

c2RhOgogICAgICAgICAgTWFnaWMgOiBJbnRlbCBSYWlkIElTTSBDZmcgU2lnLgogICAgICAgIFZl
cnNpb24gOiAxLjAuMDAKICAgIE9yaWcgRmFtaWx5IDogNjllZTU1ZGMKICAgICAgICAgRmFtaWx5
IDogNjllZTU1ZGMKICAgICBHZW5lcmF0aW9uIDogMDAwMDAwMmYKICAgICAgICAgICBVVUlEIDog
M2EzNWQzYmM6NzZlNzYwZmE6MTg5NjFmYjY6Nzk2MzFhMzIKICAgICAgIENoZWNrc3VtIDogM2Vj
YWY3OGUgY29ycmVjdAogICAgTVBCIFNlY3RvcnMgOiAxCiAgICAgICAgICBEaXNrcyA6IDIKICAg
UkFJRCBEZXZpY2VzIDogMQoKICBEaXNrMDAgU2VyaWFsIDogWjRZNzI1VkMKICAgICAgICAgIFN0
YXRlIDogYWN0aXZlCiAgICAgICAgICAgICBJZCA6IDAwMDIwMDAwCiAgICBVc2FibGUgU2l6ZSA6
IDE5NTM1MjA5MDQgKDkzMS41MSBHaUIgMTAwMC4yMCBHQikKCltWb2x1bWVfMDAwMF06CiAgICAg
ICAgICAgVVVJRCA6IDA1NjMwMDk3OjVjM2NhNDdkOmI5Mjc4ODM1OjAzYzI3YmFjCiAgICAgUkFJ
RCBMZXZlbCA6IDAKICAgICAgICBNZW1iZXJzIDogMgogICAgICAgICAgU2xvdHMgOiBbVVVdCiAg
ICAgIFRoaXMgU2xvdCA6IDAKICAgICBBcnJheSBTaXplIDogMzkwNzA0MTI4MCAoMTg2My4wMiBH
aUIgMjAwMC40MSBHQikKICAgUGVyIERldiBTaXplIDogMTk1MzUyMDkwNCAoOTMxLjUxIEdpQiAx
MDAwLjIwIEdCKQogIFNlY3RvciBPZmZzZXQgOiAwCiAgICBOdW0gU3RyaXBlcyA6IDE1MjYxODgw
CiAgICAgQ2h1bmsgU2l6ZSA6IDY0IEtpQgogICAgICAgUmVzZXJ2ZWQgOiAwCiAgTWlncmF0ZSBT
dGF0ZSA6IGlkbGUKICAgICAgTWFwIFN0YXRlIDogbm9ybWFsCiAgICBEaXJ0eSBTdGF0ZSA6IGNs
ZWFuCgogIERpc2swMSBTZXJpYWwgOiBaNFk4MkZERQogICAgICAgICAgU3RhdGUgOiBhY3RpdmUK
ICAgICAgICAgICAgIElkIDogMDAwMzAwMDAKICAgIFVzYWJsZSBTaXplIDogMTk1MzUyMDkwNCAo
OTMxLjUxIEdpQiAxMDAwLjIwIEdCKQpzZGI6CiAgICAgICAgICBNYWdpYyA6IEludGVsIFJhaWQg
SVNNIENmZyBTaWcuCiAgICAgICAgVmVyc2lvbiA6IDEuMi4wMgogICAgT3JpZyBGYW1pbHkgOiAw
Y2I0OWNkMwogICAgICAgICBGYW1pbHkgOiAwY2I3ZDFlZgogICAgIEdlbmVyYXRpb24gOiAwMDAx
N2JiYQogICAgICAgICAgIFVVSUQgOiA0Yzk1ZmJkOTo5N2Y3MGFlZjpiNGQ3ZGM0MzoyYmM4MzQ1
ZQogICAgICAgQ2hlY2tzdW0gOiA1Y2Q1OWQ5NSBjb3JyZWN0CiAgICBNUEIgU2VjdG9ycyA6IDIK
ICAgICAgICAgIERpc2tzIDogMwogICBSQUlEIERldmljZXMgOiAxCgogIERpc2swMSBTZXJpYWwg
OiBaNFk4MkZERQogICAgICAgICAgU3RhdGUgOiBhY3RpdmUKICAgICAgICAgICAgIElkIDogMDAw
MzAwMDAKICAgIFVzYWJsZSBTaXplIDogMTk1MzUyMDY1NCAoOTMxLjUxIEdpQiAxMDAwLjIwIEdC
KQoKW1JBSUQ1XzY0S106CiAgICAgICAgICAgVVVJRCA6IGIwNDU0NzVlOjUzZTZlMDU2OjYwZWJh
NzdkOmI4MjZkMzcwCiAgICAgUkFJRCBMZXZlbCA6IDUKICAgICAgICBNZW1iZXJzIDogMwogICAg
ICAgICAgU2xvdHMgOiBbVVVVXQogICAgICBUaGlzIFNsb3QgOiAxCiAgICAgQXJyYXkgU2l6ZSA6
IDM5MDcwMzUxMzYgKDE4NjMuMDIgR2lCIDIwMDAuNDAgR0IpCiAgIFBlciBEZXYgU2l6ZSA6IDE5
NTM1MTc4MzIgKDkzMS41MSBHaUIgMTAwMC4yMCBHQikKICBTZWN0b3IgT2Zmc2V0IDogMAogICAg
TnVtIFN0cmlwZXMgOiAxNTI2MTg1NgogICAgIENodW5rIFNpemUgOiA2NCBLaUIKICAgICAgIFJl
c2VydmVkIDogMAogIE1pZ3JhdGUgU3RhdGUgOiBpZGxlCiAgICAgIE1hcCBTdGF0ZSA6IG5vcm1h
bAogICAgRGlydHkgU3RhdGUgOiBjbGVhbgoKICBEaXNrMDAgU2VyaWFsIDogWjRZNzI1VkMKICAg
ICAgICAgIFN0YXRlIDogYWN0aXZlCiAgICAgICAgICAgICBJZCA6IDAwMDIwMDAwCiAgICBVc2Fi
bGUgU2l6ZSA6IDE5NTM1MTg1NDEgKDkzMS41MSBHaUIgMTAwMC4yMCBHQikKCiAgRGlzazAyIFNl
cmlhbCA6IDlRSjgxUlRKCiAgICAgICAgICBTdGF0ZSA6IGFjdGl2ZQogICAgICAgICAgICAgSWQg
OiAwMDA1MDAwMAogICAgVXNhYmxlIFNpemUgOiAxOTUzNTE4NTQxICg5MzEuNTEgR2lCIDEwMDAu
MjAgR0IpCg==
--94eb2c0b12ee9bda0105299ed542--
