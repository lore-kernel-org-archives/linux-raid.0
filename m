From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: no resync after hotadd
Date: Tue, 23 Sep 2003 10:43:55 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E5DA6395B8F9614EB7A784D628184B200D9AAA@hdsmsx402.hd.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C381E1.1D2B482B"
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.

------_=_NextPart_001_01C381E1.1D2B482B
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Neil,

I've seen this before, but it is very reproducable on the SuSE/UL system
I am testing on now.
When I hotadd a new/replacement disk (sdb) into the raid device, the
resync doesn't start.
From the superblocks, apparently the active disk still has total =
disks=3D1
so only 1 active, but the new disk superblock was written with total
disks=3D2 and both active. =20

The configuration is raid1 with sda and sdb, and sdb was hot-removed and
hot-added (each partition with mdadm -a).
I've included the resulting superblocks, and the syslog for the add
sequence is attached.

Is this a problem with the md driver? =20

Andy

# uname -a
Linux telcoraid 2.4.21-55-smp #1 SMP Wed Aug 27 19:53:48 UTC 2003 i686
unknown
# cat /proc/mdstat
Personalities : [raid1]=20
read_ahead 1024 sectors
md2 : active raid1 sdb2[2] sda2[1]
      136448 blocks [2/1] [_U]
     =20
md1 : active raid1 sdb1[2] sda1[1]
      80256 blocks [2/1] [_U]
     =20
md0 : active raid1 sdb3[2] sda3[1]
      17518784 blocks [2/1] [_U]
     =20
unused devices: <none>

#
# mdadm -E /dev/sda1
/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 15e24cfe:af2ecf43:9c74fae1:7aabf6f0
  Creation Time : Thu Sep 18 13:12:09 2003
     Raid Level : raid1
    Device Size : 80256 (78.38 MiB 82.18 MB)
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 1

    Update Time : Mon Sep 22 12:58:41 2003
          State : dirty, no-errors
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 43828e3 - correct
         Events : 0.28


      Number   Major   Minor   RaidDevice State
this     1       8        1        1      active sync   /dev/sda1
   0     0       0        0        0      faulty removed
   1     1       8        1        1      active sync   /dev/sda1

/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 15e24cfe:af2ecf43:9c74fae1:7aabf6f0
  Creation Time : Thu Sep 18 13:12:09 2003
     Raid Level : raid1
    Device Size : 80256 (78.38 MiB 82.18 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1

    Update Time : Mon Sep 22 09:37:09 2003
          State : dirty, no-errors
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 437fa2f - correct
         Events : 0.25


      Number   Major   Minor   RaidDevice State
this     0       8       17        0      active sync   /dev/sdb1
   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8        1        1      active sync   /dev/sda1

/dev/sda2:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 16df7960:13fe43ac:ac0cc4ba:42690535
  Creation Time : Thu Sep 18 13:12:56 2003
     Raid Level : raid1
    Device Size : 136448 (133.25 MiB 139.72 MB)
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 2

    Update Time : Mon Sep 22 12:58:41 2003
          State : dirty, no-errors
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 415a7d7f - correct
         Events : 0.30


      Number   Major   Minor   RaidDevice State
this     1       8        2        1      active sync   /dev/sda2
   0     0       0        0        0      faulty removed
   1     1       8        2        1      active sync   /dev/sda2

/dev/sdb2:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 16df7960:13fe43ac:ac0cc4ba:42690535
  Creation Time : Thu Sep 18 13:12:56 2003
     Raid Level : raid1
    Device Size : 136448 (133.25 MiB 139.72 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 2

    Update Time : Mon Sep 22 09:37:09 2003
          State : dirty, no-errors
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 415a4ecc - correct
         Events : 0.27


      Number   Major   Minor   RaidDevice State
this     0       8       18        0      active sync   /dev/sdb2
   0     0       8       18        0      active sync   /dev/sdb2
   1     1       8        2        1      active sync   /dev/sda2

/dev/sda3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 31b4390a:af5afa82:44c73f24:a2a36931
  Creation Time : Thu Sep 18 13:13:12 2003
     Raid Level : raid1
    Device Size : 17518784 (16.71 GiB 17.94 GB)
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 0

    Update Time : Mon Sep 22 12:58:40 2003
          State : dirty, no-errors
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0
       Checksum : f18a0e32 - correct
         Events : 0.28


      Number   Major   Minor   RaidDevice State
this     1       8        3        1      active sync   /dev/sda3
   0     0       0        0        0      faulty removed
   1     1       8        3        1      active sync   /dev/sda3

/dev/sdb3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 31b4390a:af5afa82:44c73f24:a2a36931
  Creation Time : Thu Sep 18 13:13:12 2003
     Raid Level : raid1
    Device Size : 17518784 (16.71 GiB 17.94 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

    Update Time : Mon Sep 22 09:37:08 2003
          State : dirty, no-errors
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : f189df80 - correct
         Events : 0.25


      Number   Major   Minor   RaidDevice State
this     0       8       19        0      active sync   /dev/sdb3
   0     0       8       19        0      active sync   /dev/sdb3
   1     1       8        3        1      active sync   /dev/sda3

------_=_NextPart_001_01C381E1.1D2B482B
Content-Type: application/octet-stream;
	name="syslog"
Content-Transfer-Encoding: base64
Content-Description: syslog
Content-Disposition: attachment;
	filename="syslog"

U2VwIDIzIDEwOjE0OjM4IHRlbGNvcmFpZCBrZXJuZWw6IG1kOiB0cnlpbmcgdG8gaG90LWFkZCBz
ZGIxIHRvIG1kMSAuLi4gClNlcCAyMyAxMDoxNDozOCB0ZWxjb3JhaWQga2VybmVsOiBtZDogYmlu
ZDxzZGIxLDI+ClNlcCAyMyAxMDoxNDozOCB0ZWxjb3JhaWQga2VybmVsOiBSQUlEMSBjb25mIHBy
aW50b3V0OgpTZXAgMjMgMTA6MTQ6MzggdGVsY29yYWlkIGtlcm5lbDogIC0tLSB3ZDoxIHJkOjIg
bmQ6MQpTZXAgMjMgMTA6MTQ6MzggdGVsY29yYWlkIGtlcm5lbDogIGRpc2sgMCwgczowLCBvOjAs
IG46MCByZDowIHVzOjEgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNDozOCB0ZWxjb3JhaWQg
a2VybmVsOiAgZGlzayAxLCBzOjAsIG86MSwgbjoxIHJkOjEgdXM6MSBkZXY6c2RhMQpTZXAgMjMg
MTA6MTQ6MzggdGVsY29yYWlkIGtlcm5lbDogIGRpc2sgMiwgczoxLCBvOjAsIG46MiByZDoyIHVz
OjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNDozOCB0ZWxjb3JhaWQga2VybmVsOiAgZGlz
ayAzLCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE0
OjM4IHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNrIDQsIHM6MCwgbzowLCBuOjAgcmQ6MCB1czowIGRl
djpbZGV2IDAwOjAwXQpTZXAgMjMgMTA6MTQ6MzggdGVsY29yYWlkIGtlcm5lbDogIGRpc2sgNSwg
czowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNDozOCB0
ZWxjb3JhaWQga2VybmVsOiAgZGlzayA2LCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MCBkZXY6W2Rl
diAwMDowMF0KU2VwIDIzIDEwOjE0OjM4IHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNrIDcsIHM6MCwg
bzowLCBuOjAgcmQ6MCB1czowIGRldjpbZGV2IDAwOjAwXQpTZXAgMjMgMTA6MTQ6MzggdGVsY29y
YWlkIGtlcm5lbDogIGRpc2sgOCwgczowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6
MDBdClNlcCAyMyAxMDoxNDozOCB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayA5LCBzOjAsIG86MCwg
bjowIHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE0OjM4IHRlbGNvcmFpZCBr
ZXJuZWw6ICBkaXNrIDEwLCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0K
U2VwIDIzIDEwOjE0OjM4IHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNrIDExLCBzOjAsIG86MCwgbjow
IHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE0OjM4IHRlbGNvcmFpZCBrZXJu
ZWw6ICBkaXNrIDEyLCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0KU2Vw
IDIzIDEwOjE0OjM4IHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNrIDEzLCBzOjAsIG86MCwgbjowIHJk
OjAgdXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE0OjM4IHRlbGNvcmFpZCBrZXJuZWw6
ICBkaXNrIDE0LCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIz
IDEwOjE0OjM4IHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNrIDE1LCBzOjAsIG86MCwgbjowIHJkOjAg
dXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE0OjM4IHRlbGNvcmFpZCBrZXJuZWw6ICBk
aXNrIDE2LCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEw
OjE0OjM4IHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNrIDE3LCBzOjAsIG86MCwgbjowIHJkOjAgdXM6
MCBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE0OjM4IHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNr
IDE4LCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE0
OjM4IHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNrIDE5LCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MCBk
ZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE0OjM4IHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNrIDIw
LCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE0OjM4
IHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNrIDIxLCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MCBkZXY6
W2RldiAwMDowMF0KU2VwIDIzIDEwOjE0OjM4IHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNrIDIyLCBz
OjAsIG86MCwgbjowIHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE0OjM4IHRl
bGNvcmFpZCBrZXJuZWw6ICBkaXNrIDIzLCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MCBkZXY6W2Rl
diAwMDowMF0KU2VwIDIzIDEwOjE0OjM4IHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNrIDI0LCBzOjAs
IG86MCwgbjowIHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE0OjM4IHRlbGNv
cmFpZCBrZXJuZWw6ICBkaXNrIDI1LCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MCBkZXY6W2RldiAw
MDowMF0KU2VwIDIzIDEwOjE0OjM4IHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNrIDI2LCBzOjAsIG86
MCwgbjowIHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE0OjM4IHRlbGNvcmFp
ZCBrZXJuZWw6IFJBSUQxIGNvbmYgcHJpbnRvdXQ6ClNlcCAyMyAxMDoxNDozOCB0ZWxjb3JhaWQg
a2VybmVsOiAgLS0tIHdkOjEgcmQ6MiBuZDoyClNlcCAyMyAxMDoxNDozOCB0ZWxjb3JhaWQga2Vy
bmVsOiAgZGlzayAwLCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MSBkZXY6W2RldiAwMDowMF0KU2Vw
IDIzIDEwOjE0OjM4IHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNrIDEsIHM6MCwgbzoxLCBuOjEgcmQ6
MSB1czoxIGRldjpzZGExClNlcCAyMyAxMDoxNDozOCB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAy
LCBzOjEsIG86MCwgbjoyIHJkOjIgdXM6MSBkZXY6c2RiMQpTZXAgMjMgMTA6MTQ6MzggdGVsY29y
YWlkIGtlcm5lbDogIGRpc2sgMywgczowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6
MDBdClNlcCAyMyAxMDoxNDozOCB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayA0LCBzOjAsIG86MCwg
bjowIHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE0OjM4IHRlbGNvcmFpZCBr
ZXJuZWw6ICBkaXNrIDUsIHM6MCwgbzowLCBuOjAgcmQ6MCB1czowIGRldjpbZGV2IDAwOjAwXQpT
ZXAgMjMgMTA6MTQ6MzggdGVsY29yYWlkIGtlcm5lbDogIGRpc2sgNiwgczowLCBvOjAsIG46MCBy
ZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNDozOCB0ZWxjb3JhaWQga2VybmVs
OiAgZGlzayA3LCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIz
IDEwOjE0OjM4IHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNrIDgsIHM6MCwgbzowLCBuOjAgcmQ6MCB1
czowIGRldjpbZGV2IDAwOjAwXQpTZXAgMjMgMTA6MTQ6MzggdGVsY29yYWlkIGtlcm5lbDogIGRp
c2sgOSwgczowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDox
NDozOCB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAxMCwgczowLCBvOjAsIG46MCByZDowIHVzOjAg
ZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNDozOCB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAx
MSwgczowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNDoz
OCB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAxMiwgczowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2
OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNDozOCB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAxMywg
czowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNDozOCB0
ZWxjb3JhaWQga2VybmVsOiAgZGlzayAxNCwgczowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2Oltk
ZXYgMDA6MDBdClNlcCAyMyAxMDoxNDozOCB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAxNSwgczow
LCBvOjAsIG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNDozOCB0ZWxj
b3JhaWQga2VybmVsOiAgZGlzayAxNiwgczowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2OltkZXYg
MDA6MDBdClNlcCAyMyAxMDoxNDozOCB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAxNywgczowLCBv
OjAsIG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNDozOCB0ZWxjb3Jh
aWQga2VybmVsOiAgZGlzayAxOCwgczowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6
MDBdClNlcCAyMyAxMDoxNDozOCB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAxOSwgczowLCBvOjAs
IG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNDozOCB0ZWxjb3JhaWQg
a2VybmVsOiAgZGlzayAyMCwgczowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6MDBd
ClNlcCAyMyAxMDoxNDozOCB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAyMSwgczowLCBvOjAsIG46
MCByZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNDozOCB0ZWxjb3JhaWQga2Vy
bmVsOiAgZGlzayAyMiwgczowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNl
cCAyMyAxMDoxNDozOCB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAyMywgczowLCBvOjAsIG46MCBy
ZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNDozOCB0ZWxjb3JhaWQga2VybmVs
OiAgZGlzayAyNCwgczowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAy
MyAxMDoxNDozOCB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAyNSwgczowLCBvOjAsIG46MCByZDow
IHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNDozOCB0ZWxjb3JhaWQga2VybmVsOiAg
ZGlzayAyNiwgczowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAx
MDoxNDozOCB0ZWxjb3JhaWQga2VybmVsOiBtZDogdXBkYXRpbmcgbWQxIFJBSUQgc3VwZXJibG9j
ayBvbiBkZXZpY2UKU2VwIDIzIDEwOjE0OjM4IHRlbGNvcmFpZCBrZXJuZWw6IG1kOiBzZGIxIChz
a2lwcGluZyBhbGlhcykKU2VwIDIzIDEwOjE0OjM4IHRlbGNvcmFpZCBrZXJuZWw6IG1kOiBzZGEx
IChza2lwcGluZyBhbGlhcykKU2VwIDIzIDEwOjE0OjM4IHRlbGNvcmFpZCBrZXJuZWw6IG1kOiBy
ZWNvdmVyeSB0aHJlYWQgZ290IHdva2VuIHVwIC4uLgpTZXAgMjMgMTA6MTQ6MzggdGVsY29yYWlk
IGtlcm5lbDogbWQ6IHJlY292ZXJ5IHRocmVhZCBmaW5pc2hlZCAuLi4KU2VwIDIzIDEwOjE0OjUw
IHRlbGNvcmFpZCBrZXJuZWw6IG1kOiB0cnlpbmcgdG8gaG90LWFkZCBzZGIyIHRvIG1kMiAuLi4g
ClNlcCAyMyAxMDoxNDo1MCB0ZWxjb3JhaWQga2VybmVsOiBtZDogYmluZDxzZGIyLDI+ClNlcCAy
MyAxMDoxNDo1MCB0ZWxjb3JhaWQga2VybmVsOiBSQUlEMSBjb25mIHByaW50b3V0OgpTZXAgMjMg
MTA6MTQ6NTAgdGVsY29yYWlkIGtlcm5lbDogIC0tLSB3ZDoxIHJkOjIgbmQ6MQpTZXAgMjMgMTA6
MTQ6NTAgdGVsY29yYWlkIGtlcm5lbDogIGRpc2sgMCwgczowLCBvOjAsIG46MCByZDowIHVzOjEg
ZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNDo1MCB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAx
LCBzOjAsIG86MSwgbjoxIHJkOjEgdXM6MSBkZXY6c2RhMgpTZXAgMjMgMTA6MTQ6NTAgdGVsY29y
YWlkIGtlcm5lbDogIGRpc2sgMiwgczoxLCBvOjAsIG46MiByZDoyIHVzOjAgZGV2OltkZXYgMDA6
MDBdClNlcCAyMyAxMDoxNDo1MCB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAzLCBzOjAsIG86MCwg
bjowIHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE0OjUwIHRlbGNvcmFpZCBr
ZXJuZWw6ICBkaXNrIDQsIHM6MCwgbzowLCBuOjAgcmQ6MCB1czowIGRldjpbZGV2IDAwOjAwXQpT
ZXAgMjMgMTA6MTQ6NTAgdGVsY29yYWlkIGtlcm5lbDogIGRpc2sgNSwgczowLCBvOjAsIG46MCBy
ZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNDo1MCB0ZWxjb3JhaWQga2VybmVs
OiAgZGlzayA2LCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIz
IDEwOjE0OjUwIHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNrIDcsIHM6MCwgbzowLCBuOjAgcmQ6MCB1
czowIGRldjpbZGV2IDAwOjAwXQpTZXAgMjMgMTA6MTQ6NTAgdGVsY29yYWlkIGtlcm5lbDogIGRp
c2sgOCwgczowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDox
NDo1MCB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayA5LCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MCBk
ZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE0OjUwIHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNrIDEw
LCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE0OjUw
IHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNrIDExLCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MCBkZXY6
W2RldiAwMDowMF0KU2VwIDIzIDEwOjE0OjUwIHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNrIDEyLCBz
OjAsIG86MCwgbjowIHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE0OjUwIHRl
bGNvcmFpZCBrZXJuZWw6ICBkaXNrIDEzLCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MCBkZXY6W2Rl
diAwMDowMF0KU2VwIDIzIDEwOjE0OjUwIHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNrIDE0LCBzOjAs
IG86MCwgbjowIHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE0OjUwIHRlbGNv
cmFpZCBrZXJuZWw6ICBkaXNrIDE1LCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MCBkZXY6W2RldiAw
MDowMF0KU2VwIDIzIDEwOjE0OjUwIHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNrIDE2LCBzOjAsIG86
MCwgbjowIHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE0OjUwIHRlbGNvcmFp
ZCBrZXJuZWw6ICBkaXNrIDE3LCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MCBkZXY6W2RldiAwMDow
MF0KU2VwIDIzIDEwOjE0OjUwIHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNrIDE4LCBzOjAsIG86MCwg
bjowIHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE0OjUwIHRlbGNvcmFpZCBr
ZXJuZWw6ICBkaXNrIDE5LCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0K
U2VwIDIzIDEwOjE0OjUwIHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNrIDIwLCBzOjAsIG86MCwgbjow
IHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE0OjUwIHRlbGNvcmFpZCBrZXJu
ZWw6ICBkaXNrIDIxLCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0KU2Vw
IDIzIDEwOjE0OjUwIHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNrIDIyLCBzOjAsIG86MCwgbjowIHJk
OjAgdXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE0OjUwIHRlbGNvcmFpZCBrZXJuZWw6
ICBkaXNrIDIzLCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIz
IDEwOjE0OjUwIHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNrIDI0LCBzOjAsIG86MCwgbjowIHJkOjAg
dXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE0OjUwIHRlbGNvcmFpZCBrZXJuZWw6ICBk
aXNrIDI1LCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEw
OjE0OjUwIHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNrIDI2LCBzOjAsIG86MCwgbjowIHJkOjAgdXM6
MCBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE0OjUwIHRlbGNvcmFpZCBrZXJuZWw6IFJBSUQx
IGNvbmYgcHJpbnRvdXQ6ClNlcCAyMyAxMDoxNDo1MCB0ZWxjb3JhaWQga2VybmVsOiAgLS0tIHdk
OjEgcmQ6MiBuZDoyClNlcCAyMyAxMDoxNDo1MCB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAwLCBz
OjAsIG86MCwgbjowIHJkOjAgdXM6MSBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE0OjUwIHRl
bGNvcmFpZCBrZXJuZWw6ICBkaXNrIDEsIHM6MCwgbzoxLCBuOjEgcmQ6MSB1czoxIGRldjpzZGEy
ClNlcCAyMyAxMDoxNDo1MCB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAyLCBzOjEsIG86MCwgbjoy
IHJkOjIgdXM6MSBkZXY6c2RiMgpTZXAgMjMgMTA6MTQ6NTAgdGVsY29yYWlkIGtlcm5lbDogIGRp
c2sgMywgczowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDox
NDo1MCB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayA0LCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MCBk
ZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE0OjUwIHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNrIDUs
IHM6MCwgbzowLCBuOjAgcmQ6MCB1czowIGRldjpbZGV2IDAwOjAwXQpTZXAgMjMgMTA6MTQ6NTAg
dGVsY29yYWlkIGtlcm5lbDogIGRpc2sgNiwgczowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2Oltk
ZXYgMDA6MDBdClNlcCAyMyAxMDoxNDo1MCB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayA3LCBzOjAs
IG86MCwgbjowIHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE0OjUwIHRlbGNv
cmFpZCBrZXJuZWw6ICBkaXNrIDgsIHM6MCwgbzowLCBuOjAgcmQ6MCB1czowIGRldjpbZGV2IDAw
OjAwXQpTZXAgMjMgMTA6MTQ6NTAgdGVsY29yYWlkIGtlcm5lbDogIGRpc2sgOSwgczowLCBvOjAs
IG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNDo1MCB0ZWxjb3JhaWQg
a2VybmVsOiAgZGlzayAxMCwgczowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6MDBd
ClNlcCAyMyAxMDoxNDo1MCB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAxMSwgczowLCBvOjAsIG46
MCByZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNDo1MCB0ZWxjb3JhaWQga2Vy
bmVsOiAgZGlzayAxMiwgczowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNl
cCAyMyAxMDoxNDo1MCB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAxMywgczowLCBvOjAsIG46MCBy
ZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNDo1MCB0ZWxjb3JhaWQga2VybmVs
OiAgZGlzayAxNCwgczowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAy
MyAxMDoxNDo1MCB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAxNSwgczowLCBvOjAsIG46MCByZDow
IHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNDo1MCB0ZWxjb3JhaWQga2VybmVsOiAg
ZGlzayAxNiwgczowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAx
MDoxNDo1MCB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAxNywgczowLCBvOjAsIG46MCByZDowIHVz
OjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNDo1MCB0ZWxjb3JhaWQga2VybmVsOiAgZGlz
ayAxOCwgczowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDox
NDo1MCB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAxOSwgczowLCBvOjAsIG46MCByZDowIHVzOjAg
ZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNDo1MCB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAy
MCwgczowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNDo1
MCB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAyMSwgczowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2
OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNDo1MCB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAyMiwg
czowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNDo1MCB0
ZWxjb3JhaWQga2VybmVsOiAgZGlzayAyMywgczowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2Oltk
ZXYgMDA6MDBdClNlcCAyMyAxMDoxNDo1MCB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAyNCwgczow
LCBvOjAsIG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNDo1MCB0ZWxj
b3JhaWQga2VybmVsOiAgZGlzayAyNSwgczowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2OltkZXYg
MDA6MDBdClNlcCAyMyAxMDoxNDo1MCB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAyNiwgczowLCBv
OjAsIG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNDo1MCB0ZWxjb3Jh
aWQga2VybmVsOiBtZDogdXBkYXRpbmcgbWQyIFJBSUQgc3VwZXJibG9jayBvbiBkZXZpY2UKU2Vw
IDIzIDEwOjE0OjUwIHRlbGNvcmFpZCBrZXJuZWw6IG1kOiBzZGIyIChza2lwcGluZyBhbGlhcykK
U2VwIDIzIDEwOjE0OjUwIHRlbGNvcmFpZCBrZXJuZWw6IG1kOiBzZGEyIChza2lwcGluZyBhbGlh
cykKU2VwIDIzIDEwOjE0OjUwIHRlbGNvcmFpZCBrZXJuZWw6IG1kOiByZWNvdmVyeSB0aHJlYWQg
Z290IHdva2VuIHVwIC4uLgpTZXAgMjMgMTA6MTQ6NTAgdGVsY29yYWlkIGtlcm5lbDogbWQ6IHJl
Y292ZXJ5IHRocmVhZCBmaW5pc2hlZCAuLi4KU2VwIDIzIDEwOjE1OjEzIHRlbGNvcmFpZCBrZXJu
ZWw6IG1kOiB0cnlpbmcgdG8gaG90LWFkZCBzZGIzIHRvIG1kMCAuLi4gClNlcCAyMyAxMDoxNTox
MyB0ZWxjb3JhaWQga2VybmVsOiBtZDogYmluZDxzZGIzLDI+ClNlcCAyMyAxMDoxNToxMyB0ZWxj
b3JhaWQga2VybmVsOiBSQUlEMSBjb25mIHByaW50b3V0OgpTZXAgMjMgMTA6MTU6MTMgdGVsY29y
YWlkIGtlcm5lbDogIC0tLSB3ZDoxIHJkOjIgbmQ6MQpTZXAgMjMgMTA6MTU6MTMgdGVsY29yYWlk
IGtlcm5lbDogIGRpc2sgMCwgczowLCBvOjAsIG46MCByZDowIHVzOjEgZGV2OltkZXYgMDA6MDBd
ClNlcCAyMyAxMDoxNToxMyB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAxLCBzOjAsIG86MSwgbjox
IHJkOjEgdXM6MSBkZXY6c2RhMwpTZXAgMjMgMTA6MTU6MTMgdGVsY29yYWlkIGtlcm5lbDogIGRp
c2sgMiwgczoxLCBvOjAsIG46MiByZDoyIHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDox
NToxMyB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAzLCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MCBk
ZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE1OjEzIHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNrIDQs
IHM6MCwgbzowLCBuOjAgcmQ6MCB1czowIGRldjpbZGV2IDAwOjAwXQpTZXAgMjMgMTA6MTU6MTMg
dGVsY29yYWlkIGtlcm5lbDogIGRpc2sgNSwgczowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2Oltk
ZXYgMDA6MDBdClNlcCAyMyAxMDoxNToxMyB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayA2LCBzOjAs
IG86MCwgbjowIHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE1OjEzIHRlbGNv
cmFpZCBrZXJuZWw6ICBkaXNrIDcsIHM6MCwgbzowLCBuOjAgcmQ6MCB1czowIGRldjpbZGV2IDAw
OjAwXQpTZXAgMjMgMTA6MTU6MTMgdGVsY29yYWlkIGtlcm5lbDogIGRpc2sgOCwgczowLCBvOjAs
IG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNToxMyB0ZWxjb3JhaWQg
a2VybmVsOiAgZGlzayA5LCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0K
U2VwIDIzIDEwOjE1OjEzIHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNrIDEwLCBzOjAsIG86MCwgbjow
IHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE1OjEzIHRlbGNvcmFpZCBrZXJu
ZWw6ICBkaXNrIDExLCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0KU2Vw
IDIzIDEwOjE1OjEzIHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNrIDEyLCBzOjAsIG86MCwgbjowIHJk
OjAgdXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE1OjEzIHRlbGNvcmFpZCBrZXJuZWw6
ICBkaXNrIDEzLCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIz
IDEwOjE1OjEzIHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNrIDE0LCBzOjAsIG86MCwgbjowIHJkOjAg
dXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE1OjEzIHRlbGNvcmFpZCBrZXJuZWw6ICBk
aXNrIDE1LCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEw
OjE1OjEzIHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNrIDE2LCBzOjAsIG86MCwgbjowIHJkOjAgdXM6
MCBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE1OjEzIHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNr
IDE3LCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE1
OjEzIHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNrIDE4LCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MCBk
ZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE1OjEzIHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNrIDE5
LCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE1OjEz
IHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNrIDIwLCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MCBkZXY6
W2RldiAwMDowMF0KU2VwIDIzIDEwOjE1OjEzIHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNrIDIxLCBz
OjAsIG86MCwgbjowIHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE1OjEzIHRl
bGNvcmFpZCBrZXJuZWw6ICBkaXNrIDIyLCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MCBkZXY6W2Rl
diAwMDowMF0KU2VwIDIzIDEwOjE1OjEzIHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNrIDIzLCBzOjAs
IG86MCwgbjowIHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE1OjEzIHRlbGNv
cmFpZCBrZXJuZWw6ICBkaXNrIDI0LCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MCBkZXY6W2RldiAw
MDowMF0KU2VwIDIzIDEwOjE1OjEzIHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNrIDI1LCBzOjAsIG86
MCwgbjowIHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE1OjEzIHRlbGNvcmFp
ZCBrZXJuZWw6ICBkaXNrIDI2LCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MCBkZXY6W2RldiAwMDow
MF0KU2VwIDIzIDEwOjE1OjEzIHRlbGNvcmFpZCBrZXJuZWw6IFJBSUQxIGNvbmYgcHJpbnRvdXQ6
ClNlcCAyMyAxMDoxNToxMyB0ZWxjb3JhaWQga2VybmVsOiAgLS0tIHdkOjEgcmQ6MiBuZDoyClNl
cCAyMyAxMDoxNToxMyB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAwLCBzOjAsIG86MCwgbjowIHJk
OjAgdXM6MSBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE1OjEzIHRlbGNvcmFpZCBrZXJuZWw6
ICBkaXNrIDEsIHM6MCwgbzoxLCBuOjEgcmQ6MSB1czoxIGRldjpzZGEzClNlcCAyMyAxMDoxNTox
MyB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAyLCBzOjEsIG86MCwgbjoyIHJkOjIgdXM6MSBkZXY6
c2RiMwpTZXAgMjMgMTA6MTU6MTMgdGVsY29yYWlkIGtlcm5lbDogIGRpc2sgMywgczowLCBvOjAs
IG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNToxMyB0ZWxjb3JhaWQg
a2VybmVsOiAgZGlzayA0LCBzOjAsIG86MCwgbjowIHJkOjAgdXM6MCBkZXY6W2RldiAwMDowMF0K
U2VwIDIzIDEwOjE1OjEzIHRlbGNvcmFpZCBrZXJuZWw6ICBkaXNrIDUsIHM6MCwgbzowLCBuOjAg
cmQ6MCB1czowIGRldjpbZGV2IDAwOjAwXQpTZXAgMjMgMTA6MTU6MTMgdGVsY29yYWlkIGtlcm5l
bDogIGRpc2sgNiwgczowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAy
MyAxMDoxNToxMyB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayA3LCBzOjAsIG86MCwgbjowIHJkOjAg
dXM6MCBkZXY6W2RldiAwMDowMF0KU2VwIDIzIDEwOjE1OjEzIHRlbGNvcmFpZCBrZXJuZWw6ICBk
aXNrIDgsIHM6MCwgbzowLCBuOjAgcmQ6MCB1czowIGRldjpbZGV2IDAwOjAwXQpTZXAgMjMgMTA6
MTU6MTMgdGVsY29yYWlkIGtlcm5lbDogIGRpc2sgOSwgczowLCBvOjAsIG46MCByZDowIHVzOjAg
ZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNToxMyB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAx
MCwgczowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNTox
MyB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAxMSwgczowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2
OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNToxMyB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAxMiwg
czowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNToxMyB0
ZWxjb3JhaWQga2VybmVsOiAgZGlzayAxMywgczowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2Oltk
ZXYgMDA6MDBdClNlcCAyMyAxMDoxNToxMyB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAxNCwgczow
LCBvOjAsIG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNToxMyB0ZWxj
b3JhaWQga2VybmVsOiAgZGlzayAxNSwgczowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2OltkZXYg
MDA6MDBdClNlcCAyMyAxMDoxNToxMyB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAxNiwgczowLCBv
OjAsIG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNToxMyB0ZWxjb3Jh
aWQga2VybmVsOiAgZGlzayAxNywgczowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6
MDBdClNlcCAyMyAxMDoxNToxMyB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAxOCwgczowLCBvOjAs
IG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNToxMyB0ZWxjb3JhaWQg
a2VybmVsOiAgZGlzayAxOSwgczowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6MDBd
ClNlcCAyMyAxMDoxNToxMyB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAyMCwgczowLCBvOjAsIG46
MCByZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNToxMyB0ZWxjb3JhaWQga2Vy
bmVsOiAgZGlzayAyMSwgczowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNl
cCAyMyAxMDoxNToxMyB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAyMiwgczowLCBvOjAsIG46MCBy
ZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNToxMyB0ZWxjb3JhaWQga2VybmVs
OiAgZGlzayAyMywgczowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAy
MyAxMDoxNToxMyB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAyNCwgczowLCBvOjAsIG46MCByZDow
IHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNToxMyB0ZWxjb3JhaWQga2VybmVsOiAg
ZGlzayAyNSwgczowLCBvOjAsIG46MCByZDowIHVzOjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAx
MDoxNToxMyB0ZWxjb3JhaWQga2VybmVsOiAgZGlzayAyNiwgczowLCBvOjAsIG46MCByZDowIHVz
OjAgZGV2OltkZXYgMDA6MDBdClNlcCAyMyAxMDoxNToxMyB0ZWxjb3JhaWQga2VybmVsOiBtZDog
dXBkYXRpbmcgbWQwIFJBSUQgc3VwZXJibG9jayBvbiBkZXZpY2UKU2VwIDIzIDEwOjE1OjEzIHRl
bGNvcmFpZCBrZXJuZWw6IG1kOiBzZGIzIChza2lwcGluZyBhbGlhcykKU2VwIDIzIDEwOjE1OjEz
IHRlbGNvcmFpZCBrZXJuZWw6IG1kOiBzZGEzIChza2lwcGluZyBhbGlhcykKU2VwIDIzIDEwOjE1
OjEzIHRlbGNvcmFpZCBrZXJuZWw6IG1kOiByZWNvdmVyeSB0aHJlYWQgZ290IHdva2VuIHVwIC4u
LgpTZXAgMjMgMTA6MTU6MTMgdGVsY29yYWlkIGtlcm5lbDogbWQ6IHJlY292ZXJ5IHRocmVhZCBm
aW5pc2hlZCAuLi4K

------_=_NextPart_001_01C381E1.1D2B482B--
