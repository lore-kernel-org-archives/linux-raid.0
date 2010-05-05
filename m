From: Tim Small <tim@seoss.co.uk>
Subject: Manually reconstructing a RAID5 array from a Dell PERC3/Di (Adaptec)
Date: Wed, 05 May 2010 23:35:50 +0100
Message-ID: <4BE1F2C6.1070703@seoss.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm trying to reconstruct/recover data from a raid array for a friend of
mine - it's a 5x 36G RAID5 array built using a Dell PERC3/Di (Adaptec
ultra scsi RAID card).  My guess is that it suffered two successive
failures, although none of the drives seem to be 100% dead (only failed
to read 60k on one drive out of 140G+ so-far).

I'm currently taking raw disk images of the 5 drives (with dd_rescue and
a non-RAID SCSI controller), and after that plan to try to reconstruct
the data either using the PERC 3 card itself, or using Linux software RAID.

... However, I've no idea what the metadata format of this HW RAID card
is - it doesn't seem to be ddf, or anything else that's recognised by
either dmraid or mdadm.

Any tips?  Any idea of the RAID5 layout used by these controllers?  I
don't think I've ever used a PERC3 before...  Apart from anything else,
it'd be nice to try to work out which drive failed first, so that I only
use data from it if absolutely-necessary (although I can take a guess at
that from the SMART data).

Anyway to force the controller to consider the array to be good
(although again, there is the problem of which drive failed first....)?

With the 3 of the drives read (and the start of the 4th one read too), I
get this output from the following command:


root@netboot:~# for f in /mnt/tmp/*.raw ; do for i in {0..1000} ; do
echo -n $f $i " - " ; dd if=$f skip=$i | file - ; done | grep -v
'/dev/stdin: data' | grep -v '/dev/stdin: ACB archive data' ; done
/mnt/tmp/scsi-20010b9fd0817563a.raw 128  - /dev/stdin: x86 boot sector;
partition 1: ID=0x4c, active, starthead 1, startsector 131568, 272735517
sectors; partition 2: ID=0x5, starthead 222, startsector 272735505,
11614995 sectors; partition 3: ID=0xcf, starthead 0, startsector
2147615183, 463 sectors, code offset 0x48
/mnt/tmp/scsi-20010b9fd0817563a.raw 129  - /dev/stdin: GRand Unified
Bootloader stage1_5 version 219.3, installed partition 19398653, saved
entry 536870912, identifier 0x2, GRUB version 0.97, configuration file \377
/mnt/tmp/scsi-20010b9fd0817563a.raw 137  - /dev/stdin: SysEx File -
/mnt/tmp/ST336607LC_3JA7621B.raw 128  - /dev/stdin: x86 boot sector;
GRand Unified Bootloader, stage1 version 0x3, stage2 address 0x2000,
stage2 segment 0x200; partition 1: ID=0x83, active, starthead 1,
startsector 63, 272735442 sectors; partition 2: ID=0x5, starthead 254,
startsector 272735505, 11614995 sectors, code offset 0x48
/mnt/tmp/ST336607LC_3JA7621B.raw 129  - /dev/stdin: GRand Unified
Bootloader stage1_5 version 3.2, identifier 0x2, GRUB version 0.97,
configuration file \377
/mnt/tmp/ST336607LC_3JA7621B.raw 137  - /dev/stdin: SysEx File -
/mnt/tmp/ST336607LC_3JA7621B.raw 191  - /dev/stdin: Linux rev 1.0 ext3
filesystem data, UUID=d02fc77c-b6a0-4c40-8e36-c172c7d7d07d (needs
journal recovery) (large files)
/mnt/tmp/ST336607LC_3JA7621B.raw 199  - /dev/stdin: shared library


Here's a diff between the hex-dump of the first 128 sectors of two of
the drives....


--- /tmp/scsi-SSEAGATE_ST336607LC_3JA760WM.raw.hd       2010-05-05
22:18:02.000000000 +0000
+++ /tmp/scsi-SSEAGATE_ST336607LC_3JA763SY.raw.hd       2010-05-05
22:18:02.000000000 +0000
@@ -1,56 +1,54 @@
 00000000  56 19 02 00 1e 00 00 00  10 00 00 00 f6 cd 3c 04
|V.............<.|
-00000010  00 00 02 00 7d d3 9e 6c  00 00 00 00 00 00 00 00
|....}..l........|
+00000010  00 00 02 00 5a 96 f3 61  00 00 00 00 00 00 00 00
|....Z..a........|
 00000020  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
|................|
 *
-000001f0  00 00 00 00 00 00 00 00  00 00 00 00 9e 55 f8 0a
|.............U..|
-00000200  c4 55 00 00 d3 30 04 bd  01 f0 fa fa 33 03 00 00
|.U...0......3...|
+000001f0  00 00 00 00 00 00 00 00  00 00 00 00 14 8f e2 44
|...............D|
+00000200  c4 55 00 00 d3 30 04 bd  01 f0 fa fa 2c 03 00 00
|.U...0......,...|
 00000210  00 00 00 00 2c 00 00 00  00 00 00 00 2c 00 00 00
|....,.......,...|
-00000220  00 00 00 00 32 03 00 00  00 00 00 00 00 00 00 00
|....2...........|
+00000220  00 00 00 00 2b 03 00 00  00 00 00 00 00 00 00 00
|....+...........|
 00000230  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
|................|
 *
-000003f0  00 00 00 00 00 00 00 00  00 00 00 00 72 3c 4f d8
|............r<O.|
+000003f0  00 00 00 00 00 00 00 00  00 00 00 00 72 3c 6f 23
|............r<o#|
 00000400  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
|................|
 *
 00000c00  98 19 13 04 00 00 01 00  d3 30 04 bd 01 f0 fa fa
|.........0......|
 00000c10  ff ff ff ff ff ff ff ff  00 00 00 00 ff ff ff ff
|................|
 00000c20  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff
|................|
 00000c30  ff ff ff ff ff ff ff ff  ff ff ff ff 00 00 00 00
|................|
 00000c40  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
|................|
 *
 00000df0  00 00 00 00 00 00 00 00  00 00 00 00 eb 72 03 35
|.............r.5|
 00000e00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
|................|
 *
 00001200  99 25 03 00 d3 30 04 bd  01 f0 fa fa 2c 00 00 00
|.%...0......,...|
 00001210  14 00 00 00 40 00 00 00  00 00 00 00 40 00 00 00
|....@.......@...|
-00001220  00 00 00 00 32 03 00 00  00 00 00 00 00 04 05 ff
|....2...........|
-00001230  d0 45 97 46 00 00 01 00  02 00 01 00 04 00 00 00
|.E.F............|
+00001220  00 00 00 00 2b 03 00 00  00 00 00 00 00 04 05 ff
|....+...........|
+00001230  d0 45 97 46 00 00 03 00  02 00 01 00 04 00 00 00
|.E.F............|
 00001240  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
|................|
 *
-00001ff0  00 00 00 00 00 00 00 00  00 00 00 00 0b 02 09 e9
|................|
-00002000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
|................|
+00001ff0  00 00 00 00 00 00 00 00  00 00 00 00 0f 02 29 ea
|..............).|
+00002000  00 00 00 00 01 96 01 6c  62 45 43 05 d3 30 04 bd
|.......lbEC..0..|
+00002010  01 f0 fa fa 22 03 00 00  80 00 00 00 00 c5 3c 04
|....".........<.|
+00002020  d3 30 04 bd 01 f0 fa fa  03 00 00 00 03 00 00 00
|.0..............|
+00002030  04 00 00 00 00 00 00 00  05 00 00 00 01 00 00 00
|................|
+00002040  1a 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
|................|
+00002050  00 00 00 00 00 00 00 00  01 00 00 00 80 00 00 00
|................|
+00002060  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
|................|
+00002070  00 00 00 00 00 00 00 00  00 00 00 00 03 00 00 00
|................|
+00002080  00 00 00 00 00 00 00 00  01 01 00 00 ff ff 00 00
|................|
+00002090  52 35 20 53 79 73 74 65  6d 20 20 20 20 20 20 20  |R5 System
      |
+000020a0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
|................|
 *
-00002200  00 00 00 00 01 96 01 6c  62 45 43 05 d3 30 04 bd
|.......lbEC..0..|
-00002210  01 f0 fa fa 33 03 00 00  80 00 00 00 00 c5 3c 04
|....3.........<.|
-00002220  d3 30 04 bd 01 f0 fa fa  02 00 00 00 02 00 00 00
|.0..............|
-00002230  04 00 00 00 00 00 00 00  05 00 00 00 02 00 00 00
|................|
-00002240  1a 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
|................|
-00002250  00 00 00 00 10 00 00 00  01 00 00 00 80 00 00 00
|................|
-00002260  00 00 00 00 00 00 00 00  00 00 00 00 00 00 08 00
|................|
-00002270  01 00 00 00 01 00 00 00  00 a6 03 a0 02 00 00 00
|................|
-00002280  00 00 00 00 00 00 00 00  01 01 00 00 ff ff 00 00
|................|
-00002290  52 35 20 53 79 73 74 65  6d 20 20 20 20 20 20 20  |R5 System
      |
-000022a0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
|................|
-*
-000023f0  00 00 00 00 00 00 00 00  00 00 00 00 0d d4 d2 4b
|...............K|
-00002400  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
|................|
+000021f0  00 00 00 00 00 00 00 00  00 00 00 00 0b d2 88 49
|...............I|
+00002200  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
|................|
 *
 00008000  99 19 01 00 00 00 00 00  05 00 00 00 e3 8c 81 53
|...............S|
-00008010  00 00 00 00 00 b9 1b 7f  01 00 00 00 7d d3 9e 6c
|............}..l|
-00008020  02 00 00 00 00 00 00 00  03 00 00 00 b5 ac e4 8f
|................|
+00008010  00 00 00 00 5a 96 f3 61  01 00 00 00 7d d3 9e 6c
|....Z..a....}..l|
+00008020  02 00 00 00 00 b9 1b 7f  03 00 00 00 b5 ac e4 8f
|................|
 00008030  04 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
|................|
 00008040  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
|................|
 *
-00008ff0  00 00 00 00 00 00 00 00  00 00 00 00 3f 4d d8 d0
|............?M..|
+00008ff0  00 00 00 00 00 00 00 00  00 00 00 00 16 7e ea 44
|.............~.D|
 00009000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
|................|
 *
 00010000



I'll include that as an attachment as well in a following email in case
my mailer makes a serious mess of it (I expect it will).

Cheers,

Tim.


-- 
South East Open Source Solutions Limited
Registered in England and Wales with company number 06134732.
Registered Office: 2 Powell Gardens, Redhill, Surrey, RH1 1TQ
VAT number: 900 6633 53  http://seoss.co.uk/ +44-(0)1273-808309

