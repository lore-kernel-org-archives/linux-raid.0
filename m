From: Fabian Fischer <raid@fabianfischer.org>
Subject: degraded raid array with bad blocks
Date: Thu, 16 Jul 2015 20:14:21 +0200
Message-ID: <55A7F47D.1020004@fabianfischer.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090600070906040309030608"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------090600070906040309030608
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi,
today I had some problems with my mdadm raid5 (4disks). Firstly I try to
explaine what happened and what the result is:

One disk in my array has some bad blocks. After some hardware-changes
one of the intact disks was thrown out of the array due to a faulty
sata-cable.
I shut down the server and replaced the cable.
After booting, the removed disk wasn't re added to the array (maybe
because of different event count). --re-add doesn't work.
So I used --add.

Because of the bad blocks on one of the remaining disks, the rebuild
stops when reaching the first bad block. The re added disk is declared
as spare, 2 disks active and the disk with bad blocks as faulty.

/dev/md127:
        Version : 1.2
  Creation Time : Tue Apr 19 08:51:32 2011
     Raid Level : raid5
     Array Size : 5860538880 (5589.05 GiB 6001.19 GB)
  Used Dev Size : 1953512960 (1863.02 GiB 2000.40 GB)
   Raid Devices : 4
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Thu Jul 16 19:02:09 2015
          State : clean, FAILED
 Active Devices : 2
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 512K

           Name : FiFa-Server:0
           UUID : 839fb405:d0b1f13a:5a55ee42:fc8a2061
         Events : 107223

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       8       80        1      active sync   /dev/sdf
       5       8       32        2      active sync   /dev/sdc
       6       0        0        6      removed

       4       8       96        -      faulty   /dev/sdg
       6       8       64        -      spare   /dev/sde


In my opinion there a 3 possibilities to get the array back working. I
am not sure whether both possibilities really exist and which one is the
most promising.
	- Using the 'spare'-disk as active disk. The data on the disk
	  should be still there.
	- Ignoring the bad blocks and loose information stored in this
	  blocks
	- force start the array without the 'spare' disk and copy the
	  data to backup-storage, or does the bad block will cause the
	  array to fail when reaching a bad block?

In the attachment you can find the output of --examine.
In can not explain why 3 disk have a Bad Block Log. According to
smart-values only sdg has Reallocated_Sector_Ct >0
Another thing I can't explain is why sdg (which is the disk with known
bad blocks) has a lower event count.


I hope I can get some great ideas how to fix my array.

Fabian


--------------090600070906040309030608
Content-Type: text/plain; charset=UTF-8;
 name="examine.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="examine.txt"

L2Rldi9zZGM6CiAgICAgICAgICBNYWdpYyA6IGE5MmI0ZWZjCiAgICAgICAgVmVyc2lvbiA6
IDEuMgogICAgRmVhdHVyZSBNYXAgOiAweDAKICAgICBBcnJheSBVVUlEIDogODM5ZmI0MDU6
ZDBiMWYxM2E6NWE1NWVlNDI6ZmM4YTIwNjEKICAgICAgICAgICBOYW1lIDogRmlGYS1TZXJ2
ZXI6MAogIENyZWF0aW9uIFRpbWUgOiBUdWUgQXByIDE5IDA4OjUxOjMyIDIwMTEKICAgICBS
YWlkIExldmVsIDogcmFpZDUKICAgUmFpZCBEZXZpY2VzIDogNAoKIEF2YWlsIERldiBTaXpl
IDogMzkwNzAyNzEyMCAoMTg2My4wMiBHaUIgMjAwMC40MCBHQikKICAgICBBcnJheSBTaXpl
IDogNTg2MDUzODg4MCAoNTU4OS4wNSBHaUIgNjAwMS4xOSBHQikKICBVc2VkIERldiBTaXpl
IDogMzkwNzAyNTkyMCAoMTg2My4wMiBHaUIgMjAwMC40MCBHQikKICAgIERhdGEgT2Zmc2V0
IDogMjA0OCBzZWN0b3JzCiAgIFN1cGVyIE9mZnNldCA6IDggc2VjdG9ycwogICBVbnVzZWQg
U3BhY2UgOiBiZWZvcmU9MTk2MCBzZWN0b3JzLCBhZnRlcj0xMjAwIHNlY3RvcnMKICAgICAg
ICAgIFN0YXRlIDogY2xlYW4KICAgIERldmljZSBVVUlEIDogOTdjY2Q1NTE6ODgyMGMwZTM6
NGFiM2Q2N2Q6OTA4YTJmZDkKCiAgICBVcGRhdGUgVGltZSA6IFRodSBKdWwgMTYgMTk6MDI6
MDkgMjAxNQogIEJhZCBCbG9jayBMb2cgOiA1MTIgZW50cmllcyBhdmFpbGFibGUgYXQgb2Zm
c2V0IDcyIHNlY3RvcnMKICAgICAgIENoZWNrc3VtIDogOWQwMThlZWEgLSBjb3JyZWN0CiAg
ICAgICAgIEV2ZW50cyA6IDEwNzIyMwoKICAgICAgICAgTGF5b3V0IDogbGVmdC1zeW1tZXRy
aWMKICAgICBDaHVuayBTaXplIDogNTEySwoKICAgRGV2aWNlIFJvbGUgOiBBY3RpdmUgZGV2
aWNlIDIKICAgQXJyYXkgU3RhdGUgOiAuQUEuICgnQScgPT0gYWN0aXZlLCAnLicgPT0gbWlz
c2luZywgJ1InID09IHJlcGxhY2luZykKL2Rldi9zZGU6CiAgICAgICAgICBNYWdpYyA6IGE5
MmI0ZWZjCiAgICAgICAgVmVyc2lvbiA6IDEuMgogICAgRmVhdHVyZSBNYXAgOiAweDgKICAg
ICBBcnJheSBVVUlEIDogODM5ZmI0MDU6ZDBiMWYxM2E6NWE1NWVlNDI6ZmM4YTIwNjEKICAg
ICAgICAgICBOYW1lIDogRmlGYS1TZXJ2ZXI6MAogIENyZWF0aW9uIFRpbWUgOiBUdWUgQXBy
IDE5IDA4OjUxOjMyIDIwMTEKICAgICBSYWlkIExldmVsIDogcmFpZDUKICAgUmFpZCBEZXZp
Y2VzIDogNAoKIEF2YWlsIERldiBTaXplIDogMzkwNzAyNzEyMCAoMTg2My4wMiBHaUIgMjAw
MC40MCBHQikKICAgICBBcnJheSBTaXplIDogNTg2MDUzODg4MCAoNTU4OS4wNSBHaUIgNjAw
MS4xOSBHQikKICBVc2VkIERldiBTaXplIDogMzkwNzAyNTkyMCAoMTg2My4wMiBHaUIgMjAw
MC40MCBHQikKICAgIERhdGEgT2Zmc2V0IDogMjA0OCBzZWN0b3JzCiAgIFN1cGVyIE9mZnNl
dCA6IDggc2VjdG9ycwogICBVbnVzZWQgU3BhY2UgOiBiZWZvcmU9MTk2MCBzZWN0b3JzLCBh
ZnRlcj0xMjAwIHNlY3RvcnMKICAgICAgICAgIFN0YXRlIDogY2xlYW4KICAgIERldmljZSBV
VUlEIDogNmRiNzU2NmQ6M2M3MDkzNzA6MTI2MzRmNjY6ZjZiZmQ0ZjYKCiAgICBVcGRhdGUg
VGltZSA6IFRodSBKdWwgMTYgMTk6MDI6MDkgMjAxNQogIEJhZCBCbG9jayBMb2cgOiA1MTIg
ZW50cmllcyBhdmFpbGFibGUgYXQgb2Zmc2V0IDcyIHNlY3RvcnMgLSBiYWQgYmxvY2tzIHBy
ZXNlbnQuCiAgICAgICBDaGVja3N1bSA6IDRiNzNhZWFiIC0gY29ycmVjdAogICAgICAgICBF
dmVudHMgOiAxMDcyMjMKCiAgICAgICAgIExheW91dCA6IGxlZnQtc3ltbWV0cmljCiAgICAg
Q2h1bmsgU2l6ZSA6IDUxMksKCiAgIERldmljZSBSb2xlIDogc3BhcmUKICAgQXJyYXkgU3Rh
dGUgOiAuQUEuICgnQScgPT0gYWN0aXZlLCAnLicgPT0gbWlzc2luZywgJ1InID09IHJlcGxh
Y2luZykKL2Rldi9zZGY6CiAgICAgICAgICBNYWdpYyA6IGE5MmI0ZWZjCiAgICAgICAgVmVy
c2lvbiA6IDEuMgogICAgRmVhdHVyZSBNYXAgOiAweDAKICAgICBBcnJheSBVVUlEIDogODM5
ZmI0MDU6ZDBiMWYxM2E6NWE1NWVlNDI6ZmM4YTIwNjEKICAgICAgICAgICBOYW1lIDogRmlG
YS1TZXJ2ZXI6MAogIENyZWF0aW9uIFRpbWUgOiBUdWUgQXByIDE5IDA4OjUxOjMyIDIwMTEK
ICAgICBSYWlkIExldmVsIDogcmFpZDUKICAgUmFpZCBEZXZpY2VzIDogNAoKIEF2YWlsIERl
diBTaXplIDogMzkwNzAyNzEyMCAoMTg2My4wMiBHaUIgMjAwMC40MCBHQikKICAgICBBcnJh
eSBTaXplIDogNTg2MDUzODg4MCAoNTU4OS4wNSBHaUIgNjAwMS4xOSBHQikKICBVc2VkIERl
diBTaXplIDogMzkwNzAyNTkyMCAoMTg2My4wMiBHaUIgMjAwMC40MCBHQikKICAgIERhdGEg
T2Zmc2V0IDogMjA0OCBzZWN0b3JzCiAgIFN1cGVyIE9mZnNldCA6IDggc2VjdG9ycwogICBV
bnVzZWQgU3BhY2UgOiBiZWZvcmU9MTk2OCBzZWN0b3JzLCBhZnRlcj0xMjAwIHNlY3RvcnMK
ICAgICAgICAgIFN0YXRlIDogY2xlYW4KICAgIERldmljZSBVVUlEIDogMjdkZjQyOWY6Yzk2
NjE4Mzg6M2E4MDI0ZTQ6ZDU1MDU1ZTgKCiAgICBVcGRhdGUgVGltZSA6IFRodSBKdWwgMTYg
MTk6MDI6MDkgMjAxNQogICAgICAgQ2hlY2tzdW0gOiBiNDMyN2FhNCAtIGNvcnJlY3QKICAg
ICAgICAgRXZlbnRzIDogMTA3MjIzCgogICAgICAgICBMYXlvdXQgOiBsZWZ0LXN5bW1ldHJp
YwogICAgIENodW5rIFNpemUgOiA1MTJLCgogICBEZXZpY2UgUm9sZSA6IEFjdGl2ZSBkZXZp
Y2UgMQogICBBcnJheSBTdGF0ZSA6IC5BQS4gKCdBJyA9PSBhY3RpdmUsICcuJyA9PSBtaXNz
aW5nLCAnUicgPT0gcmVwbGFjaW5nKQovZGV2L3NkZzoKICAgICAgICAgIE1hZ2ljIDogYTky
YjRlZmMKICAgICAgICBWZXJzaW9uIDogMS4yCiAgICBGZWF0dXJlIE1hcCA6IDB4OAogICAg
IEFycmF5IFVVSUQgOiA4MzlmYjQwNTpkMGIxZjEzYTo1YTU1ZWU0MjpmYzhhMjA2MQogICAg
ICAgICAgIE5hbWUgOiBGaUZhLVNlcnZlcjowCiAgQ3JlYXRpb24gVGltZSA6IFR1ZSBBcHIg
MTkgMDg6NTE6MzIgMjAxMQogICAgIFJhaWQgTGV2ZWwgOiByYWlkNQogICBSYWlkIERldmlj
ZXMgOiA0CgogQXZhaWwgRGV2IFNpemUgOiAzOTA3MDI3MTIwICgxODYzLjAyIEdpQiAyMDAw
LjQwIEdCKQogICAgIEFycmF5IFNpemUgOiA1ODYwNTM4ODgwICg1NTg5LjA1IEdpQiA2MDAx
LjE5IEdCKQogIFVzZWQgRGV2IFNpemUgOiAzOTA3MDI1OTIwICgxODYzLjAyIEdpQiAyMDAw
LjQwIEdCKQogICAgRGF0YSBPZmZzZXQgOiAyMDQ4IHNlY3RvcnMKICAgU3VwZXIgT2Zmc2V0
IDogOCBzZWN0b3JzCiAgIFVudXNlZCBTcGFjZSA6IGJlZm9yZT0xOTYwIHNlY3RvcnMsIGFm
dGVyPTEyMDAgc2VjdG9ycwogICAgICAgICAgU3RhdGUgOiBjbGVhbgogICAgRGV2aWNlIFVV
SUQgOiBiNjc4NmRmZjpjNmJlMDIzNjoxMGQ4Zjk1Zjo2M2FmYWQ5MwoKICAgIFVwZGF0ZSBU
aW1lIDogVGh1IEp1bCAxNiAxOTowMjowMyAyMDE1CiAgQmFkIEJsb2NrIExvZyA6IDUxMiBl
bnRyaWVzIGF2YWlsYWJsZSBhdCBvZmZzZXQgNzIgc2VjdG9ycyAtIGJhZCBibG9ja3MgcHJl
c2VudC4KICAgICAgIENoZWNrc3VtIDogMzk3YjIyYzggLSBjb3JyZWN0CiAgICAgICAgIEV2
ZW50cyA6IDEwNzE5MgoKICAgICAgICAgTGF5b3V0IDogbGVmdC1zeW1tZXRyaWMKICAgICBD
aHVuayBTaXplIDogNTEySwoKICAgRGV2aWNlIFJvbGUgOiBBY3RpdmUgZGV2aWNlIDMKICAg
QXJyYXkgU3RhdGUgOiBBQUFBICgnQScgPT0gYWN0aXZlLCAnLicgPT0gbWlzc2luZywgJ1In
ID09IHJlcGxhY2luZykK
--------------090600070906040309030608--
