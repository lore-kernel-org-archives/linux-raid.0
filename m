From: "Christian P. Schmidt" <schmidt@digadd.de>
Subject: Kernel OOPS with partitioned software raid (+ further questions)
 [PATCH]
Date: Mon, 30 Oct 2006 19:56:17 +0100
Message-ID: <45464AD1.9030407@digadd.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040707050809060908010509"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: mingo@redhat.com, neilb@cse.unsw.edu.au
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------040707050809060908010509
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hi all,

I'm running the following software-raid setup:

two raid 0 with two 250GB disks each (sdd1-sdg1) named md_d2 and md_d3
one raid 5 with three 500GB disks (sda2-sdc2) and the two raid0 as
members named md_d5
one raid 1 with 100MB of each of the 500GB disks (sda1-sdc1) named md_d1

The only raid device that actually has a partition table is md_d5. The
other devices are used unpartitioned, which brings me to the first
question: Is it possible to run partitioned and unpartitioned software
raids at the same time?

Back to the topic now after this question. The resulting problem is: due
to the raid5 layout, the partition table of md_d5 is written to where a
partition table on md_d3 would be as well:

[~]>fdisk -l /dev/md_d3

Disk /dev/md_d3: 500.1 GB, 500113211392 bytes
2 heads, 4 sectors/track, 122097952 cylinders
Units = cylinders of 8 * 512 = 4096 bytes

      Device Boot      Start         End      Blocks   Id  System
/dev/md_d3p1               1      244142      976566   83  Linux
/dev/md_d3p2          244143     5126956    19531256   8e  Linux LVM
/dev/md_d3p3         5126957   488279488  1932610128   8e  Linux LVM

Note that the end of md_d3p3 is way beyond the end of the actual device.
Now during boot udev tries to find out about the content of the devices,
using the vol_id program. It checks the various locations for raid
superblocks, lvm superblocks. What happens show the following strace
excerpts:

execve("./vol_id.bin", ["./vol_id.bin", "-t", "/dev/md_d3p3"], [/* 26
vars */]) = 0
[... Dynamic library setup, etc]
open("/dev/md_d3p3", O_RDONLY)          = 3
[... various brk()]
ioctl(3, BLKGETSIZE64, 0x7fff9ff36948)  = 0
[... drop to nobody/nogroup after lots of nscd interaction]
lseek(3, 1978992689152, SEEK_SET)       = 1978992689152
read(3,
Never returns.

The connection reset of course only happens after reboot. This is what I
can see on a serial console:

 * Letting udev process events ...Unable to handle kernel NULL pointer
dereference
<ffffffff8041a9b3>{raid0_make_request+291}
PGD 3e751067 PUD 3e748067 PMD 0
Oops: 0000 [1]
CPU 0
Modules linked in:
Pid: 1994, comm: vol_id Not tainted 2.6.17-hardened-r1 #2
RIP: 0010:[<ffffffff8041a9b3>] <ffffffff8041a9b3>{raid0_make_request+291}
RSP: 0018:ffff81003e7479d8  EFLAGS: 00010212
RAX: ffff81003facace0 RBX: ffff81003fd17440 RCX: 0000000000000003
RDX: 000000001d156930 RSI: 0000000000000006 RDI: 0000000000000000
RBP: 0000000000000040 R08: 00000000746a36b0 R09: 0000000000000080
R10: ffff81003f503900 R11: 00000000e8d46d60 R12: ffff81003f0c5330
R13: ffff81003e747ad8 R14: 0000000000000001 R15: 0000000000000000
FS:  00002b5b6f634b90(0000) GS:ffffffff806cb000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 000000003e75d000 CR4: 00000000000006e0
Process vol_id (pid: 1994, threadinfo ffff81003e746000, task
ffff81003e5ef5b0)
Stack: 0000000000000008 ffff81003fd17440 0000000000000080 ffffffff80345305
       0000000000000000 0000000000001000 0000000000000000 ffff81003fd17440
       ffff81003fd17440 0000000000000000
Call Trace: <ffffffff80345305>{generic_make_request+357}
       <ffffffff80347458>{submit_bio+200} <ffffffff80268fcb>{submit_bh+251}
       <ffffffff8026bbb2>{block_read_full_page+610}
<ffffffff8026f930>{blkdev_g}
       <ffffffff80353db3>{radix_tree_node_alloc+19}
<ffffffff8035455d>{radix_tr}
       <ffffffff8024dd0d>{__do_page_cache_readahead+509}
<ffffffff80276fbd>{__l}
       <ffffffff8024ddfd>{blockable_page_cache_readahead+109}
       <ffffffff8024e06e>{page_cache_readahead+334}
<ffffffff80247a17>{do_gener}
       <ffffffff80249b40>{file_read_actor+0}
<ffffffff80248682>{__generic_file_}
       <ffffffff802498ec>{generic_file_read+172}
<ffffffff8023bfc0>{autoremove_}
       <ffffffff8025698c>{unmap_region+220} <ffffffff80267dca>{vfs_read+186}
       <ffffffff80268203>{sys_read+83} <ffffffff80209a0e>{system_call+126}

Code: 48 8b 17 48 89 d0 48 03 47 10 49 39 c0 72 06 48 83 c7 28 eb
RIP <ffffffff8041a9b3>{raid0_make_request+291} RSP <ffff81003e7479d8>
CR2: 0000000000000000

The kernel above contains a lot of patches (gentoo's hardened sources),
but the same syndrom can be seen with vanilla 2.6.18 or 2.6.19 rc3.

Even if there are likely a dozend workarounds (create a partition table
on the raid 0s one by one and resync; no not rely on raid=part for
autodetection as the raid5 doesn't come up automatically anyway; don't
use vol_id) this should in my oppinion not happen. The points I'd like
to criticize are:
- The partition table read code, which accepts to create the devices
even though they are obviously wrong,
- The partitioned raid device creation code, which creates subdevices
which are larger than the containing device,
- The layer in the kernel that allows the read beyond end of device down
to the raid driver,
- Most importantly, the raid driver for failing that bad mannered.

I honestly didn't look into the other software raid drivers, which are
likely to produce the same result. The attached patch for raid0.c makes
accesses beyond the end of a device into Buffer I/O errors:

xxxxxx Buffer I/O error on device md_d3p3, logical block 483152512

Regards,
Christian


--------------040707050809060908010509
Content-Type: text/plain;
 name="raid0.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="raid0.patch"

--- raid0.c.orig	2006-10-30 00:12:22.000000000 +0100
+++ raid0.c	2006-10-30 00:14:48.000000000 +0100
@@ -415,6 +415,10 @@
 	chunksize_bits = ffz(~chunk_size);
 	block = bio->bi_sector >> 1;
 	
+	if (block >= mddev->array_size) {
+		bio_endio(bio, bio->bi_size, -EIO);
+		return 0;
+	}
 
 	if (unlikely(chunk_sects < (bio->bi_sector & (chunk_sects - 1)) + (bio->bi_size >> 9))) {
 		struct bio_pair *bp;


--------------040707050809060908010509--
