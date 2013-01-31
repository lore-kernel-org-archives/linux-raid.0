From: Christoph Nelles <evilazrael@evilazrael.de>
Subject: RAID5 with 2 drive failure at the same time
Date: Thu, 31 Jan 2013 11:42:54 +0100
Message-ID: <510A4AAE.6000009@evilazrael.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040905050201020706010905"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------040905050201020706010905
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hi,

i hope somebody on this ML can help me.

My RAID5 died last night during a rebuild when two drives failed (looks
like a sata_mv problem). The RAID5 was rebuilding because one of the two
drives failed before and after running badblocks for 2 days, i re-added
it to the RAID.

The used drives are from /dev/sdb1 to /dev/sdj1 (9 Drives, RAID5), the
failed drives are sdj1 and sdg1
The current situation is that I cannot start the RAID. I wanted to try
readding on of the the drives, so removed it beforehand, making it a
spare :\ The layout is as follows:

    Number   Major   Minor   RaidDevice State
       0       8       33        0      active sync   /dev/sdc1
       1       0        0        1      removed
       2       8      113        2      active sync   /dev/sdh1
       3       8       49        3      active sync   /dev/sdd1
       4       8      129        4      active sync   /dev/sdi1
       5       0        0        5      removed
       6       8       17        6      active sync   /dev/sdb1
       7       8       81        7      active sync   /dev/sdf1
       8       8       65        8      active sync   /dev/sde1

Re-adding fails with a simple message:
# mdadm -v /dev/md0 --re-add /dev/sdg1
mdadm: --re-add for /dev/sdg1 to /dev/md0 is not possible

I tried re-adding both failed drives at the same, with the same result.

When examining the drives, sdj1 has the information from before the crash:
   Device Role : Active device 5
   Array State : AAAAAAAAA ('A' == active, '.' == missing)

sdg1 looks like this
   Device Role : spare
   Array State : A.AAA.AAA ('A' == active, '.' == missing)

The other look like
   Device Role : Active device 6
   Array State : A.AAA.AAA ('A' == active, '.' == missing)

So looks that my repair tries made sdg1 a spare :\ I attached the full
output to this mail.

Is there anyway to restart the RAID from the information contained in
drive sdj1? Perhaps via Incremental Build starting from one drive? Could
that work? If the RAID wouldn't have been rebuilding before the crash, i
would just recreate it with --assume-clean.

Thanks in advance for any help

Regards

Christoph Nelles
-- 
Christoph Nelles

E-Mail    : evilazrael@evilazrael.de
Jabber    : eazrael@evilazrael.net      ICQ       : 78819723

PGP-Key   : ID 0x424FB55B on subkeys.pgp.net
            or http://evilazrael.net/pgp.txt


--------------040905050201020706010905
Content-Type: text/plain;
 name="mdadm_examine_sdg1.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mdadm_examine_sdg1.txt"

# mdadm --examine /dev/sdg1
/dev/sdg1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 6b21b3ed:d39d5a54:d4939113:77851cb6
           Name : router:0  (local to host router)
  Creation Time : Fri Apr 27 20:25:04 2012
     Raid Level : raid5
   Raid Devices : 9

 Avail Dev Size : 5860529039 (2794.52 GiB 3000.59 GB)
     Array Size : 46884229120 (22356.14 GiB 24004.73 GB)
  Used Dev Size : 5860528640 (2794.52 GiB 3000.59 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : a1b16284:321fcdd0:93993ff5:832eee3a

    Update Time : Thu Jan 31 00:50:44 2013
       Checksum : 2391e873 - correct
         Events : 27697

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : spare
   Array State : A.AAA.AAA ('A' == active, '.' == missing)

--------------040905050201020706010905
Content-Type: text/plain;
 name="mdadm_examine_sdj1.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mdadm_examine_sdj1.txt"

mdadm --examine /dev/sdj1
/dev/sdj1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 6b21b3ed:d39d5a54:d4939113:77851cb6
           Name : router:0  (local to host router)
  Creation Time : Fri Apr 27 20:25:04 2012
     Raid Level : raid5
   Raid Devices : 9

 Avail Dev Size : 5860529039 (2794.52 GiB 3000.59 GB)
     Array Size : 46884229120 (22356.14 GiB 24004.73 GB)
  Used Dev Size : 5860528640 (2794.52 GiB 3000.59 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 7023df83:d890ce04:fc28652e:094adffe

    Update Time : Thu Jan 31 00:24:56 2013
       Checksum : 542f70be - correct
         Events : 27691

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 5
   Array State : AAAAAAAAA ('A' == active, '.' == missing)

--------------040905050201020706010905
Content-Type: text/plain;
 name="mdadm_detail.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="mdadm_detail.txt"

IG1kYWRtIC0tZGV0YWlsIC9kZXYvbWQwDQovZGV2L21kMDoNCiAgICAgICAgVmVyc2lvbiA6
IDEuMg0KICBDcmVhdGlvbiBUaW1lIDogRnJpIEFwciAyNyAyMDoyNTowNCAyMDEyDQogICAg
IFJhaWQgTGV2ZWwgOiByYWlkNQ0KICBVc2VkIERldiBTaXplIDogLTENCiAgIFJhaWQgRGV2
aWNlcyA6IDkNCiAgVG90YWwgRGV2aWNlcyA6IDcNCiAgICBQZXJzaXN0ZW5jZSA6IFN1cGVy
YmxvY2sgaXMgcGVyc2lzdGVudA0KDQogICAgVXBkYXRlIFRpbWUgOiBUaHUgSmFuIDMxIDEw
OjM2OjI4IDIwMTMNCiAgICAgICAgICBTdGF0ZSA6IGFjdGl2ZSwgRkFJTEVELCBOb3QgU3Rh
cnRlZA0KIEFjdGl2ZSBEZXZpY2VzIDogNw0KV29ya2luZyBEZXZpY2VzIDogNw0KIEZhaWxl
ZCBEZXZpY2VzIDogMA0KICBTcGFyZSBEZXZpY2VzIDogMA0KDQogICAgICAgICBMYXlvdXQg
OiBsZWZ0LXN5bW1ldHJpYw0KICAgICBDaHVuayBTaXplIDogNjRLDQoNCiAgICAgICAgICAg
TmFtZSA6IHJvdXRlcjowICAobG9jYWwgdG8gaG9zdCByb3V0ZXIpDQogICAgICAgICAgIFVV
SUQgOiA2YjIxYjNlZDpkMzlkNWE1NDpkNDkzOTExMzo3Nzg1MWNiNg0KICAgICAgICAgRXZl
bnRzIDogMjc2OTkNCg0KICAgIE51bWJlciAgIE1ham9yICAgTWlub3IgICBSYWlkRGV2aWNl
IFN0YXRlDQogICAgICAgMCAgICAgICA4ICAgICAgIDMzICAgICAgICAwICAgICAgYWN0aXZl
IHN5bmMgICAvZGV2L3NkYzENCiAgICAgICAxICAgICAgIDAgICAgICAgIDAgICAgICAgIDEg
ICAgICByZW1vdmVkDQogICAgICAgMiAgICAgICA4ICAgICAgMTEzICAgICAgICAyICAgICAg
YWN0aXZlIHN5bmMgICAvZGV2L3NkaDENCiAgICAgICAzICAgICAgIDggICAgICAgNDkgICAg
ICAgIDMgICAgICBhY3RpdmUgc3luYyAgIC9kZXYvc2RkMQ0KICAgICAgIDQgICAgICAgOCAg
ICAgIDEyOSAgICAgICAgNCAgICAgIGFjdGl2ZSBzeW5jICAgL2Rldi9zZGkxDQogICAgICAg
NSAgICAgICAwICAgICAgICAwICAgICAgICA1ICAgICAgcmVtb3ZlZA0KICAgICAgIDYgICAg
ICAgOCAgICAgICAxNyAgICAgICAgNiAgICAgIGFjdGl2ZSBzeW5jICAgL2Rldi9zZGIxDQog
ICAgICAgNyAgICAgICA4ICAgICAgIDgxICAgICAgICA3ICAgICAgYWN0aXZlIHN5bmMgICAv
ZGV2L3NkZjENCiAgICAgICA4ICAgICAgIDggICAgICAgNjUgICAgICAgIDggICAgICBhY3Rp
dmUgc3luYyAgIC9kZXYvc2RlMQ==
--------------040905050201020706010905
Content-Type: text/plain;
 name="mdadm_examine_sdb1.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="mdadm_examine_sdb1.txt"

L2Rldi9zZGIxOg0KICAgICAgICAgIE1hZ2ljIDogYTkyYjRlZmMNCiAgICAgICAgVmVyc2lv
biA6IDEuMg0KICAgIEZlYXR1cmUgTWFwIDogMHgwDQogICAgIEFycmF5IFVVSUQgOiA2YjIx
YjNlZDpkMzlkNWE1NDpkNDkzOTExMzo3Nzg1MWNiNg0KICAgICAgICAgICBOYW1lIDogcm91
dGVyOjAgIChsb2NhbCB0byBob3N0IHJvdXRlcikNCiAgQ3JlYXRpb24gVGltZSA6IEZyaSBB
cHIgMjcgMjA6MjU6MDQgMjAxMg0KICAgICBSYWlkIExldmVsIDogcmFpZDUNCiAgIFJhaWQg
RGV2aWNlcyA6IDkNCg0KIEF2YWlsIERldiBTaXplIDogNTg2MDUyOTAzOSAoMjc5NC41MiBH
aUIgMzAwMC41OSBHQikNCiAgICAgQXJyYXkgU2l6ZSA6IDQ2ODg0MjI5MTIwICgyMjM1Ni4x
NCBHaUIgMjQwMDQuNzMgR0IpDQogIFVzZWQgRGV2IFNpemUgOiA1ODYwNTI4NjQwICgyNzk0
LjUyIEdpQiAzMDAwLjU5IEdCKQ0KICAgIERhdGEgT2Zmc2V0IDogMjA0OCBzZWN0b3JzDQog
ICBTdXBlciBPZmZzZXQgOiA4IHNlY3RvcnMNCiAgICAgICAgICBTdGF0ZSA6IGFjdGl2ZQ0K
ICAgIERldmljZSBVVUlEIDogMjljNjI3NzY6ZTljNThjZTY6MWM2ZTlhYjE6MDQ2YWM0MTEN
Cg0KICAgIFVwZGF0ZSBUaW1lIDogVGh1IEphbiAzMSAxMDozNjoyOCAyMDEzDQogICAgICAg
Q2hlY2tzdW0gOiBiZTQ3M2QwMiAtIGNvcnJlY3QNCiAgICAgICAgIEV2ZW50cyA6IDI3Njk5
DQoNCiAgICAgICAgIExheW91dCA6IGxlZnQtc3ltbWV0cmljDQogICAgIENodW5rIFNpemUg
OiA2NEsNCg0KICAgRGV2aWNlIFJvbGUgOiBBY3RpdmUgZGV2aWNlIDYNCiAgIEFycmF5IFN0
YXRlIDogQS5BQUEuQUFBICgnQScgPT0gYWN0aXZlLCAnLicgPT0gbWlzc2luZyk=
--------------040905050201020706010905--
