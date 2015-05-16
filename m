From: Charles Bertsch <cbertsch@cox.net>
Subject: Re: PROBLEM: write to jbod with 3TB and 160GB drives hits BUG/oops
Date: Fri, 15 May 2015 20:46:32 -0700
Message-ID: <5556BD98.1020106@cox.net>
References: <55398462.1000202@cox.net> <KdvS1q00X1hjKLY01dvTMG> <553AA35A.5050300@cox.net> <LpCG1q00n1hjKLY01pCHNM>
Reply-To: bertschc@acm.org
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020307010904060005090009"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <LpCG1q00n1hjKLY01pCHNM>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, "BertschC@acm.org" <BertschC@acm.org>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------020307010904060005090009
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 04/26/2015 06:11 PM, NeilBrown wrote:
> Thanks for the details.
> On the whole, I don't think it is likely that your problem is directly
> related to md - just a coincidence that it happened when you were using md
> things.  But one never knows until that actual cause is found.
>
>> >
>> >  > Is there any chance you could use "git bisect" to find out exactly which
>> >  > commit introduced the problem?  That is the mostly likely path to a
>> >solution.
>> >  >
>> >

Neil,
I went through the steps, and at the last git bisect got this report --


a72132c31d580969a38972aaf925915e861cd342 is the first bad commit
commit a72132c31d580969a38972aaf925915e861cd342
Author: Matthew Wilcox <matthew.r.wilcox@intel.com>
Date:   Wed Jun 4 16:07:49 2014 -0700

     brd: add support for rw_page()

     Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
     Cc: Dave Chinner <david@fromorbit.com>
     Cc: Dheeraj Reddy <dheeraj.reddy@intel.com>
     Cc: Hugh Dickins <hughd@google.com>
     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

:040000 040000 181578588b2fd2a8d59f56f9bcb945169db9bbea 
f294ca33674881ab6bc0c43ac24b43a251204793 M	drivers

Attached are the stack-traces from the three instances built with this 
step.  After begin of the command -- dd bs=16384 if=/dev/zero 
of=/dev/md0 count=32M -- the failure would occur between 3 and 6 
minutes.  Other test builds in the sequence hit the failure as quickly 
as a few seconds and as long as 10 minutes.  Two of these instances had 
a little script monirw running, checking /proc/diskstats for reads, 
writes, and in-progress values.  In one, monirw is not running, to show 
that its presence is independent of the problem.

The linear raid-group was built using linux-4.0.0 using two of the five 
attached drives, and used throughout, and worked fine with lin-3.3.5, 
3.10, 3.14, and 3.15 in tests up to 16 and 17 hours.  Those drives were 
used as part of a test script that created striped (5 drives), linear (1 
drive), linear (2 drives), mirror (2 drives), raid-5 (5 drives), raid-6 
(5 drives), raid-10-2X (5 drives), and raid-10-3X (5 drives).  The 
linear raid-groups were created with ext3 but otherwise unused.  All of 
the others had ext3 file-systems with 20GB of data written, and multiple 
operations such as file-system check performed.  Only the linear-2-drive 
test ran into this problem.

I still have not figured out what part of this system would be writing 
to an ext2 file-system.

What else can I do to help with this problem ?

Thanks

Charles Bertsch


--------------020307010904060005090009
Content-Type: text/plain; charset=UTF-8;
 name="linprob.stktrace.1.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="linprob.stktrace.1.txt"


# 
# 
# cat /proc/version
Linux version 3.15.0-rc8+ (cbertsch@haxe) (gcc version 4.8.2 (GCC) ) #1 SMP Thu May 14 17:42:51 MST 2015
# 
# cat /etc/zerv*
1.1.10x 2015-May-14 17:49
# 
# cat /proc/partitions
major minor  #blocks  name

   3        0  156290904 hda
   8        0  312571224 sda
   8       16     126976 sdb
   8       17     126852 sdb1
   8       32 2930266584 sdc
   8       33 2930265591 sdc1
   8       48  156290904 sdd
   8       49  156289927 sdd1
   8       64 2930266584 sde
   9        0 3086293374 md0
# 
# df
Filesystem     1K-blocks   Used Available Use% Mounted on
/dev/root          34816  34816         0 100% /
devtmpfs         1002784      0   1002784   0% /dev
/dev/ram1           7745    343      7402   5% /hd
tmpfs            1021396      0   1021396   0% /dev/shm
/dev/sdb1         122708 106436     16272  87% /flash
# 
# cat /proc/mdstat
Personalities : [linear] 
md0 : active linear sdc1[0] sdd1[1]
      3086293374 blocks super 1.2 0k rounding
      
unused devices: <none>
# 
# 
# dd bs=16384 if=/dev/zero of=/dev/md0 count=32M &
# 
# monirw 10 md0 sdc sdd
/sbin/monirw sec=10 file=/proc/diskstats itemset=md0 sdc sdd
md0,33,148473,0,sdc,109,147532,147,sdd,74,0,0,1431651487,2015-05-14,17:58:07
md0,0,156467,0,sdc,0,156550,134,sdd,0,0,0,1431651497,2015-05-14,17:58:17
md0,0,154009,0,sdc,0,153990,137,sdd,0,0,0,1431651507,2015-05-14,17:58:27
md0,0,155219,0,sdc,0,155270,129,sdd,0,0,0,1431651518,2015-05-14,17:58:38
md0,0,156672,0,sdc,0,156614,138,sdd,0,0,0,1431651528,2015-05-14,17:58:48
md0,0,155852,0,sdc,0,155846,139,sdd,0,0,0,1431651538,2015-05-14,17:58:58
md0,0,153804,0,sdc,0,153817,137,sdd,0,0,0,1431651548,2015-05-14,17:59:08
md0,0,154009,0,sdc,0,154022,135,sdd,0,0,0,1431651558,2015-05-14,17:59:18
md0,0,153395,0,sdc,0,153408,133,sdd,0,0,0,1431651568,2015-05-14,17:59:28
md0,0,154763,0,sdc,0,154777,131,sdd,0,0,0,1431651578,2015-05-14,17:59:38
md0,0,156122,0,sdc,0,156102,134,sdd,0,0,0,1431651588,2015-05-14,17:59:48
md0,0,155648,0,sdc,0,155660,132,sdd,0,0,0,1431651598,2015-05-14,17:59:58
md0,0,153395,0,sdc,0,153369,136,sdd,0,0,0,1431651609,2015-05-14,18:00:09
md0,0,154009,0,sdc,0,154041,131,sdd,0,0,0,1431651619,2015-05-14,18:00:19
md0,0,155033,0,sdc,0,154976,140,sdd,0,0,0,1431651629,2015-05-14,18:00:29
md0,0,153804,0,sdc,0,153824,137,sdd,0,0,0,1431651639,2015-05-14,18:00:39
md0,0,156262,0,sdc,0,156217,144,sdd,0,0,0,1431651649,2015-05-14,18:00:49
md0,0,155648,0,sdc,0,155648,144,sdd,0,0,0,1431651659,2015-05-14,18:00:59
md0,0,155648,0,sdc,0,155641,145,sdd,0,0,0,1431651669,2015-05-14,18:01:09
------------[ cut here ]------------
kernel BUG at /home/cbertsch/NZdev/nz218/othersrc/linux-git/fs/buffer.c:3220!
invalid opcode: 0000 [#1] SMP 
Modules linked in: linear md_mod ipv6 nfsd auth_rpcgss oid_registry exportfs lockd sunrpc af_packet sd_mod ide_gd_mod ata_generic pata_amd sata_nv libata i2c_dev amd74xx k8temp ide_pci_generic forcedeth ide_core skge ehci_pci ohci_pci ehci_hcd ohci_hcd i2c_nforce2 rtc_cmos
CPU: 0 PID: 140 Comm: kworker/u8:2 Not tainted 3.15.0-rc8+ #1
Hardware name: BIOSTAR Group N61PB-M2S/N61PB-M2S, BIOS 6.00 PG 02/27/2009
Workqueue: writeback bdi_writeback_workfn (flush-1:1)
task: ffff88007d342150 ti: ffff88007d4a0000 task.ti: ffff88007d4a0000
RIP: 0010:[<ffffffff8110f17d>]  [<ffffffff8110f17d>] try_to_free_buffers+0x9d/0xa0
RSP: 0018:ffff88007d4a3998  EFLAGS: 00010246
RAX: 001000000000086c RBX: ffffea0000210480 RCX: ffff88000c7e2028
RDX: 0000000000000004 RSI: 0000000000000001 RDI: ffffea0000210480
RBP: ffff88007d89a5f8 R08: 2400000000000000 R09: a800008412000000
R10: 57ffe97bee210480 R11: 000000000000001a R12: ffffea0000210480
R13: 0000000000001000 R14: ffff88007d4a3bf0 R15: 0000000000000456
FS:  00007f301703c740(0000) GS:ffff88007ca00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fea47ba5ffc CR3: 000000007d237000 CR4: 00000000000007f0
Stack:
 0000000000000000 0000000000000000 ffff88007a003380 ffffea0000210480
 ffffffff81118767 000000048103b333 0000000000000004 0000000000000004
 0000000000000000 ffff88007d4a3cc0 ffff88007d89a5f8 0000000000000001
Call Trace:
 [<ffffffff81118767>] ? __mpage_writepage+0x4d7/0x5c0
 [<ffffffff810cf756>] ? page_mkclean_one+0x66/0x80
 [<ffffffff810d0c12>] ? rmap_walk+0x272/0x2a0
 [<ffffffff810d0da5>] ? page_mkclean+0x65/0x80
 [<ffffffff810cf6f0>] ? page_referenced_one+0xb0/0xb0
 [<ffffffff810afee3>] ? write_cache_pages+0x1c3/0x380
 [<ffffffff81118290>] ? clean_buffers+0x60/0x60
 [<ffffffff81069f58>] ? __dequeue_entity+0x28/0x40
 [<ffffffff8115adf0>] ? ext2_get_blocks+0x970/0x970
 [<ffffffff811181ec>] ? mpage_writepages+0x5c/0xa0
 [<ffffffff8115adf0>] ? ext2_get_blocks+0x970/0x970
 [<ffffffff81107778>] ? __writeback_single_inode+0x28/0x100
 [<ffffffff811081bb>] ? writeback_sb_inodes+0x19b/0x390
 [<ffffffff8110843e>] ? __writeback_inodes_wb+0x8e/0xc0
 [<ffffffff8110863b>] ? wb_writeback+0x1cb/0x1e0
 [<ffffffff81108bf7>] ? bdi_writeback_workfn+0x157/0x340
 [<ffffffff810558f2>] ? process_one_work+0x132/0x380
 [<ffffffff81056536>] ? worker_thread+0x116/0x3a0
 [<ffffffff81056420>] ? manage_workers.isra.24+0x290/0x290
 [<ffffffff8105c251>] ? kthread+0xc1/0xe0
 [<ffffffff8105c190>] ? kthread_create_on_node+0x170/0x170
 [<ffffffff813b93fc>] ? ret_from_fork+0x7c/0xb0
 [<ffffffff8105c190>] ? kthread_create_on_node+0x170/0x170
Code: 44 89 e0 48 83 c4 08 5b 5d 41 5c c3 66 90 be 00 10 00 00 48 89 df e8 33 40 fa ff eb bc 90 48 89 e6 e8 48 ec ff ff 41 89 c4 eb b6 <0f> 0b 90 41 57 41 56 41 89 d6 41 55 41 54 49 89 f4 55 48 89 fd 
RIP  [<ffffffff8110f17d>] try_to_free_buffers+0x9d/0xa0
 RSP <ffff88007d4a3998>
---[ end trace a1fddf154ab6e51e ]---
May 14 18:01:17 ZigZag kernel: kernel BUG at /home/cbertsch/NZdev/nz218/othersrcBUG: unable to handle kernel paging request at ffffffffffffffd8
IP: [<ffffffff8105c737>] kthread_data+0x7/0x10
PGD 1611067 PUD 1613067 PMD 0 
Oops: 0000 [#2] SMP 
Modules linked in: linear md_mod ipv6 nfsd auth_rpcgss oid_registry exportfs lockd sunrpc af_packet sd_mod ide_gd_mod ata_generic pata_amd sata_nv libata i2c_dev amd74xx k8temp ide_pci_generic forcedeth ide_core skge ehci_pci ohci_pci ehci_hcd ohci_hcd i2c_nforce2 rtc_cmos
CPU: 0 PID: 140 Comm: kworker/u8:2 Tainted: G      D       3.15.0-rc8+ #1
Hardware name: BIOSTAR Group N61PB-M2S/N61PB-M2S, BIOS 6.00 PG 02/27/2009
task: ffff88007d342150 ti: ffff88007d4a0000 task.ti: ffff88007d4a0000
RIP: 0010:[<ffffffff8105c737>]  [<ffffffff8105c737>] kthread_data+0x7/0x10
RSP: 0018:ffff88007d4a36b0  EFLAGS: 00010002
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000f067272f1
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88007d342150
RBP: ffff88007d4a37b8 R08: ffff88007d349950 R09: 0000000000000001
R10: 000000000000bd41 R11: 0000000000000000 R12: ffff88007d3428f0
R13: 0000000000000000 R14: 0000000000000000 R15: ffff88007d342150
FS:  00007f301703c740(0000) GS:ffff88007ca00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000028 CR3: 000000007d237000 CR4: 00000000000007f0
Stack:
 ffffffff810569a8 ffff88007ca11740 ffffffff813b5ed3 ffff88007d342150
 0000000000011740 ffff88007d4a3fd8 0000000000011740 000000000000008c
 ffff8800775a31c0 ffff88007a192b58 ffffffff810facf0 ffff88007d4a373b
Call Trace:
 [<ffffffff810569a8>] ? wq_worker_sleeping+0x8/0x80
 [<ffffffff813b5ed3>] ? __schedule+0x3a3/0x6f0
 [<ffffffff810facf0>] ? d_lookup+0x20/0x40
 [<ffffffff81041b17>] ? do_exit+0x677/0x990
 [<ffffffff81005a56>] ? oops_end+0x66/0x90
 [<ffffffff81002cd1>] ? do_invalid_op+0x81/0xa0
 [<ffffffff8110f17d>] ? try_to_free_buffers+0x9d/0xa0
 [<ffffffff811f75fb>] ? radix_tree_insert+0x2b/0xe0
 [<ffffffff813ba4a8>] ? invalid_op+0x18/0x20
 [<ffffffff8110f17d>] ? try_to_free_buffers+0x9d/0xa0
 [<ffffffff81118767>] ? __mpage_writepage+0x4d7/0x5c0
 [<ffffffff810cf756>] ? page_mkclean_one+0x66/0x80
 [<ffffffff810d0c12>] ? rmap_walk+0x272/0x2a0
 [<ffffffff810d0da5>] ? page_mkclean+0x65/0x80
 [<ffffffff810cf6f0>] ? page_referenced_one+0xb0/0xb0
 [<ffffffff810afee3>] ? write_cache_pages+0x1c3/0x380
 [<ffffffff81118290>] ? clean_buffers+0x60/0x60
 [<ffffffff81069f58>] ? __dequeue_entity+0x28/0x40
 [<ffffffff8115adf0>] ? ext2_get_blocks+0x970/0x970
 [<ffffffff811181ec>] ? mpage_writepages+0x5c/0xa0
 [<ffffffff8115adf0>] ? ext2_get_blocks+0x970/0x970
 [<ffffffff81107778>] ? __writeback_single_inode+0x28/0x100
 [<ffffffff811081bb>] ? writeback_sb_inodes+0x19b/0x390
 [<ffffffff8110843e>] ? __writeback_inodes_wb+0x8e/0xc0
 [<ffffffff8110863b>] ? wb_writeback+0x1cb/0x1e0
 [<ffffffff81108bf7>] ? bdi_writeback_workfn+0x157/0x340
 [<ffffffff810558f2>] ? process_one_work+0x132/0x380
 [<ffffffff81056536>] ? worker_thread+0x116/0x3a0
 [<ffffffff81056420>] ? manage_workers.isra.24+0x290/0x290
 [<ffffffff8105c251>] ? kthread+0xc1/0xe0
 [<ffffffff8105c190>] ? kthread_create_on_node+0x170/0x170
 [<ffffffff813b93fc>] ? ret_from_fork+0x7c/0xb0
 [<ffffffff8105c190>] ? kthread_create_on_node+0x170/0x170
Code: 00 00 00 00 65 48 8b 04 25 80 b8 00 00 48 8b 80 48 07 00 00 48 8b 40 c8 48 c1 e8 02 83 e0 01 c3 0f 1f 40 00 48 8b 87 48 07 00 00 <48> 8b 40 d8 c3 0f 1f 40 00 48 83 ec 08 48 8b b7 48 07 00 00 ba 
RIP  [<ffffffff8105c737>] kthread_data+0x7/0x10
 RSP <ffff88007d4a36b0>
CR2: ffffffffffffffd8
---[ end trace a1fddf154ab6e51f ]---
Fixing recursive fault but reboot is needed!

--------------020307010904060005090009
Content-Type: text/plain; charset=UTF-8;
 name="linprob.stktrace.2.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="linprob.stktrace.2.txt"


# 
# date
Thu May 14 18:05:44 MST 2015
# 
# cat /proc/version
Linux version 3.15.0-rc8+ (cbertsch@haxe) (gcc version 4.8.2 (GCC) ) #1 SMP Thu May 14 17:42:51 MST 2015
# 
# cat /etc/zerv*
1.1.10x 2015-May-14 17:49
# 
# cat /proc/partitions
major minor  #blocks  name

   3        0  156290904 hda
   8        0  312571224 sda
   8       16     126976 sdb
   8       17     126852 sdb1
   8       32 2930266584 sdc
   8       33 2930265591 sdc1
   8       48  156290904 sdd
   8       49  156289927 sdd1
   8       64 2930266584 sde
   9        0 3086293374 md0
# 
# df
Filesystem     1K-blocks   Used Available Use% Mounted on
/dev/root          34816  34816         0 100% /
devtmpfs         1002784      0   1002784   0% /dev
/dev/ram1           7745    343      7402   5% /hd
tmpfs            1021396      0   1021396   0% /dev/shm
/dev/sdb1         122708 106436     16272  87% /flash
# 
# cat /proc/mdstat
Personalities : [linear] 
md0 : active linear sdc1[0] sdd1[1]
      3086293374 blocks super 1.2 0k rounding
      
unused devices: <none>
# 
# 
# dd bs=16384 if=/dev/zero of=/dev/md0 count=32M &
# 
# ------------[ cut here ]------------
kernel BUG at /home/cbertsch/NZdev/nz218/othersrc/linux-git/fs/buffer.c:3220!
invalid opcode: 0000 [#1] SMP 
Modules linked in: linear md_mod ipv6 nfsd auth_rpcgss oid_registry exportfs lockd sunrpc af_packet sd_mod ide_gd_mod ata_generic pata_amd sata_nv libata i2c_dev amd74xx k8temp ide_pci_generic forcedeth ide_core skge ehci_pci ohci_pci ehci_hcd ohci_hcd i2c_nforce2 rtc_cmos
CPU: 0 PID: 111 Comm: kworker/u8:2 Not tainted 3.15.0-rc8+ #1
Hardware name: BIOSTAR Group N61PB-M2S/N61PB-M2S, BIOS 6.00 PG 02/27/2009
Workqueue: writeback bdi_writeback_workfn (flush-1:1)
task: ffff8800775a5270 ti: ffff88007d160000 task.ti: ffff88007d160000
RIP: 0010:[<ffffffff8110f17d>]  [<ffffffff8110f17d>] try_to_free_buffers+0x9d/0xa0
RSP: 0018:ffff88007d163998  EFLAGS: 00010246
RAX: 001000000000086c RBX: ffffea000005dc68 RCX: ffff88004b38bdf8
RDX: 0000000000000004 RSI: 0000000000000001 RDI: ffffea000005dc68
RBP: ffff88007d4afbd8 R08: e340000000000000 R09: a800001771a00000
R10: 57ffe9e88e65dc68 R11: 000000000000001a R12: ffffea000005dc68
R13: 0000000000001000 R14: ffff88007d163bf0 R15: 0000000000000c38
FS:  00007fbebd993740(0000) GS:ffff88007ca00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fa7d2b9effc CR3: 00000000774c1000 CR4: 00000000000007f0
Stack:
 0000000000000000 0000000000000000 ffff88007a003380 ffffea000005dc68
 ffffffff81118767 000000048103b333 0000000000000004 0000000000000004
 0000000000000000 ffff88007d163cc0 ffff88007d4afbd8 0000000000000001
Call Trace:
 [<ffffffff81118767>] ? __mpage_writepage+0x4d7/0x5c0
 [<ffffffff810cf756>] ? page_mkclean_one+0x66/0x80
 [<ffffffff810d0c12>] ? rmap_walk+0x272/0x2a0
 [<ffffffff810d0da5>] ? page_mkclean+0x65/0x80
 [<ffffffff810cf6f0>] ? page_referenced_one+0xb0/0xb0
 [<ffffffff810afee3>] ? write_cache_pages+0x1c3/0x380
 [<ffffffff81118290>] ? clean_buffers+0x60/0x60
 [<ffffffff81069f58>] ? __dequeue_entity+0x28/0x40
 [<ffffffff8115adf0>] ? ext2_get_blocks+0x970/0x970
 [<ffffffff811181ec>] ? mpage_writepages+0x5c/0xa0
 [<ffffffff8115adf0>] ? ext2_get_blocks+0x970/0x970
 [<ffffffff81107778>] ? __writeback_single_inode+0x28/0x100
 [<ffffffff811081bb>] ? writeback_sb_inodes+0x19b/0x390
 [<ffffffff8110843e>] ? __writeback_inodes_wb+0x8e/0xc0
 [<ffffffff8110863b>] ? wb_writeback+0x1cb/0x1e0
 [<ffffffff81108bf7>] ? bdi_writeback_workfn+0x157/0x340
 [<ffffffff810558f2>] ? process_one_work+0x132/0x380
 [<ffffffff81056536>] ? worker_thread+0x116/0x3a0
 [<ffffffff81056420>] ? manage_workers.isra.24+0x290/0x290
 [<ffffffff8105c251>] ? kthread+0xc1/0xe0
 [<ffffffff8105c190>] ? kthread_create_on_node+0x170/0x170
 [<ffffffff813b93fc>] ? ret_from_fork+0x7c/0xb0
 [<ffffffff8105c190>] ? kthread_create_on_node+0x170/0x170
Code: 44 89 e0 48 83 c4 08 5b 5d 41 5c c3 66 90 be 00 10 00 00 48 89 df e8 33 40 fa ff eb bc 90 48 89 e6 e8 48 ec ff ff 41 89 c4 eb b6 <0f> 0b 90 41 57 41 56 41 89 d6 41 55 41 54 49 89 f4 55 48 89 fd 
RIP  [<ffffffff8110f17d>] try_to_free_buffers+0x9d/0xa0
 RSP <ffff88007d163998>
---[ end trace f925040d8cafe7bb ]---
May 14 18:13:23 ZigZag kernel: kernel BUG at /home/cbertsch/NZdeBUG: unable to handle kernel paging request at ffffffffffffffd8
IP: [<ffffffff8105c737>] kthread_data+0x7/0x10
PGD 1611067 PUD 1613067 PMD 0 
Oops: 0000 [#2] SMP 
Modules linked in: linear md_mod ipv6 nfsd auth_rpcgss oid_registry exportfs lockd sunrpc af_packet sd_mod ide_gd_mod ata_generic pata_amd sata_nv libata i2c_dev amd74xx k8temp ide_pci_generic forcedeth ide_core skge ehci_pci ohci_pci ehci_hcd ohci_hcd i2c_nforce2 rtc_cmos
CPU: 0 PID: 111 Comm: kworker/u8:2 Tainted: G      D       3.15.0-rc8+ #1
Hardware name: BIOSTAR Group N61PB-M2S/N61PB-M2S, BIOS 6.00 PG 02/27/2009
task: ffff8800775a5270 ti: ffff88007d160000 task.ti: ffff88007d160000
RIP: 0010:[<ffffffff8105c737>]  [<ffffffff8105c737>] kthread_data+0x7/0x10
RSP: 0018:ffff88007d1636b0  EFLAGS: 00010002
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000001b3c047296
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8800775a5270
RBP: ffff88007d1637b8 R08: ffff8800775a7590 R09: 0000000000000001
R10: 000000000000bc4e R11: 0000000000000000 R12: ffff8800775a5a10
R13: 0000000000000000 R14: 0000000000000000 R15: ffff8800775a5270
FS:  00007fbebd993740(0000) GS:ffff88007ca00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000028 CR3: 00000000774c1000 CR4: 00000000000007f0
Stack:
 ffffffff810569a8 ffff88007ca11740 ffffffff813b5ed3 ffff8800775a5270
 0000000000011740 ffff88007d163fd8 0000000000011740 000000000000006f
 ffff8800793701c0 ffff88007a35c918 ffffffff810facf0 ffff88007d16373b
Call Trace:
 [<ffffffff810569a8>] ? wq_worker_sleeping+0x8/0x80
 [<ffffffff813b5ed3>] ? __schedule+0x3a3/0x6f0
 [<ffffffff810facf0>] ? d_lookup+0x20/0x40
 [<ffffffff81041b17>] ? do_exit+0x677/0x990
 [<ffffffff81005a56>] ? oops_end+0x66/0x90
 [<ffffffff81002cd1>] ? do_invalid_op+0x81/0xa0
 [<ffffffff8110f17d>] ? try_to_free_buffers+0x9d/0xa0
 [<ffffffff811f75fb>] ? radix_tree_insert+0x2b/0xe0
 [<ffffffff813ba4a8>] ? invalid_op+0x18/0x20
 [<ffffffff8110f17d>] ? try_to_free_buffers+0x9d/0xa0
 [<ffffffff81118767>] ? __mpage_writepage+0x4d7/0x5c0
 [<ffffffff810cf756>] ? page_mkclean_one+0x66/0x80
 [<ffffffff810d0c12>] ? rmap_walk+0x272/0x2a0
 [<ffffffff810d0da5>] ? page_mkclean+0x65/0x80
 [<ffffffff810cf6f0>] ? page_referenced_one+0xb0/0xb0
 [<ffffffff810afee3>] ? write_cache_pages+0x1c3/0x380
 [<ffffffff81118290>] ? clean_buffers+0x60/0x60
 [<ffffffff81069f58>] ? __dequeue_entity+0x28/0x40
 [<ffffffff8115adf0>] ? ext2_get_blocks+0x970/0x970
 [<ffffffff811181ec>] ? mpage_writepages+0x5c/0xa0
 [<ffffffff8115adf0>] ? ext2_get_blocks+0x970/0x970
 [<ffffffff81107778>] ? __writeback_single_inode+0x28/0x100
 [<ffffffff811081bb>] ? writeback_sb_inodes+0x19b/0x390
 [<ffffffff8110843e>] ? __writeback_inodes_wb+0x8e/0xc0
 [<ffffffff8110863b>] ? wb_writeback+0x1cb/0x1e0
 [<ffffffff81108bf7>] ? bdi_writeback_workfn+0x157/0x340
 [<ffffffff810558f2>] ? process_one_work+0x132/0x380
 [<ffffffff81056536>] ? worker_thread+0x116/0x3a0
 [<ffffffff81056420>] ? manage_workers.isra.24+0x290/0x290
 [<ffffffff8105c251>] ? kthread+0xc1/0xe0
 [<ffffffff8105c190>] ? kthread_create_on_node+0x170/0x170
 [<ffffffff813b93fc>] ? ret_from_fork+0x7c/0xb0
 [<ffffffff8105c190>] ? kthread_create_on_node+0x170/0x170
Code: 00 00 00 00 65 48 8b 04 25 80 b8 00 00 48 8b 80 48 07 00 00 48 8b 40 c8 48 c1 e8 02 83 e0 01 c3 0f 1f 40 00 48 8b 87 48 07 00 00 <48> 8b 40 d8 c3 0f 1f 40 00 48 83 ec 08 48 8b b7 48 07 00 00 ba 
RIP  [<ffffffff8105c737>] kthread_data+0x7/0x10
 RSP <ffff88007d1636b0>
CR2: ffffffffffffffd8
---[ end trace f925040d8cafe7bc ]---
Fixing recursive fault but reboot is needed!

--------------020307010904060005090009
Content-Type: text/plain; charset=UTF-8;
 name="linprob.stktrace.3.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="linprob.stktrace.3.txt"

# 
# date
Thu May 14 18:17:52 MST 2015
# 
# cat /proc/version
Linux version 3.15.0-rc8+ (cbertsch@haxe) (gcc version 4.8.2 (GCC) ) #1 SMP Thu May 14 17:42:51 MST 2015
# 
# cat /etc/zerv*
1.1.10x 2015-May-14 17:49
# 
# cat /proc/partitions
major minor  #blocks  name

   3        0  156290904 hda
   8        0  312571224 sda
   8       16     126976 sdb
   8       17     126852 sdb1
   8       32 2930266584 sdc
   8       33 2930265591 sdc1
   8       48  156290904 sdd
   8       49  156289927 sdd1
   8       64 2930266584 sde
   9        0 3086293374 md0
# 
# df
Filesystem     1K-blocks   Used Available Use% Mounted on
/dev/root          34816  34816         0 100% /
devtmpfs         1002784      0   1002784   0% /dev
/dev/ram1           7745    343      7402   5% /hd
tmpfs            1021396      0   1021396   0% /dev/shm
/dev/sdb1         122708 106436     16272  87% /flash
# 
# cat /proc/mdstat
Personalities : [linear] 
md0 : active linear sdc1[0] sdd1[1]
      3086293374 blocks super 1.2 0k rounding
      
unused devices: <none>
# 
# 
# dd bs=16384 if=/dev/zero of=/dev/md0 count=32M &
# 
# monirw 10 md0 sdc sdd
/sbin/monirw sec=10 file=/proc/diskstats itemset=md0 sdc sdd
md0,33,143353,0,sdc,109,142444,142,sdd,74,0,0,1431652769,2015-05-14,18:19:29
md0,0,154828,0,sdc,0,154860,137,sdd,0,0,0,1431652779,2015-05-14,18:19:39
md0,0,155033,0,sdc,0,155084,129,sdd,0,0,0,1431652789,2015-05-14,18:19:49
md0,0,154624,0,sdc,0,154534,143,sdd,0,0,0,1431652799,2015-05-14,18:19:59
md0,0,156876,0,sdc,0,156812,153,sdd,0,0,0,1431652809,2015-05-14,18:20:09
md0,0,155443,0,sdc,0,155577,132,sdd,0,0,0,1431652819,2015-05-14,18:20:19
md0,0,155238,0,sdc,0,155244,131,sdd,0,0,0,1431652830,2015-05-14,18:20:30
md0,0,153804,0,sdc,0,153728,143,sdd,0,0,0,1431652840,2015-05-14,18:20:40
md0,0,154624,0,sdc,0,154720,128,sdd,0,0,0,1431652850,2015-05-14,18:20:50
md0,0,154624,0,sdc,0,154489,149,sdd,0,0,0,1431652860,2015-05-14,18:21:00
md0,0,156262,0,sdc,0,156403,127,sdd,0,0,0,1431652870,2015-05-14,18:21:10
md0,0,156262,0,sdc,0,156230,132,sdd,0,0,0,1431652880,2015-05-14,18:21:20
md0,0,153395,0,sdc,0,153356,138,sdd,0,0,0,1431652890,2015-05-14,18:21:30
md0,0,153804,0,sdc,0,153817,136,sdd,0,0,0,1431652900,2015-05-14,18:21:40
md0,0,155852,0,sdc,0,155750,152,sdd,0,0,0,1431652910,2015-05-14,18:21:50
md0,0,154419,0,sdc,0,154451,147,sdd,0,0,0,1431652920,2015-05-14,18:22:00
md0,0,156262,0,sdc,0,156236,151,sdd,0,0,0,1431652931,2015-05-14,18:22:11
md0,0,156262,0,sdc,0,156352,137,sdd,0,0,0,1431652941,2015-05-14,18:22:21
md0,0,156262,0,sdc,0,156243,140,sdd,0,0,0,1431652951,2015-05-14,18:22:31
md0,0,152166,0,sdc,0,152185,137,sdd,0,0,0,1431652961,2015-05-14,18:22:41
md0,0,154828,0,sdc,0,154873,130,sdd,0,0,0,1431652971,2015-05-14,18:22:51
md0,0,154214,0,sdc,0,154150,140,sdd,0,0,0,1431652981,2015-05-14,18:23:01
md0,0,155033,0,sdc,0,155084,132,sdd,0,0,0,1431652991,2015-05-14,18:23:11
md0,0,155852,0,sdc,0,155859,131,sdd,0,0,0,1431653001,2015-05-14,18:23:21
md0,0,156057,0,sdc,0,156038,134,sdd,0,0,0,1431653011,2015-05-14,18:23:31
md0,0,154828,0,sdc,0,154771,143,sdd,0,0,0,1431653021,2015-05-14,18:23:41
md0,0,152371,0,sdc,0,152384,141,sdd,0,0,0,1431653032,2015-05-14,18:23:52
md0,0,155648,0,sdc,0,155660,139,sdd,0,0,0,1431653042,2015-05-14,18:24:02
md0,0,153600,0,sdc,0,153568,144,sdd,0,0,0,1431653052,2015-05-14,18:24:12
md0,0,155443,0,sdc,0,155462,141,sdd,0,0,0,1431653062,2015-05-14,18:24:22
md0,0,155648,0,sdc,0,155712,131,sdd,0,0,0,1431653072,2015-05-14,18:24:32
md0,0,155238,0,sdc,0,155251,129,sdd,0,0,0,1431653082,2015-05-14,18:24:42
md0,0,154009,0,sdc,0,153932,141,sdd,0,0,0,1431653092,2015-05-14,18:24:52
md0,0,153395,0,sdc,0,153376,144,sdd,0,0,0,1431653102,2015-05-14,18:25:02
md0,0,155648,0,sdc,0,155724,132,sdd,0,0,0,1431653112,2015-05-14,18:25:12
md0,0,154009,0,sdc,0,153971,138,sdd,0,0,0,1431653122,2015-05-14,18:25:22
------------[ cut here ]------------
kernel BUG at /home/cbertsch/NZdev/nz218/othersrc/linux-git/fs/buffer.c:3220!
invalid opcode: 0000 [#1] SMP 
Modules linked in: linear md_mod ipv6 nfsd auth_rpcgss oid_registry exportfs lockd sunrpc af_packet sd_mod ide_gd_mod ata_generic pata_amd sata_nv libata i2c_dev amd74xx k8temp ide_pci_generic forcedeth ide_core skge ehci_pci ohci_pci ehci_hcd ohci_hcd i2c_nforce2 rtc_cmos
CPU: 0 PID: 146 Comm: kworker/u8:5 Not tainted 3.15.0-rc8+ #1
Hardware name: BIOSTAR Group N61PB-M2S/N61PB-M2S, BIOS 6.00 PG 02/27/2009
Workqueue: writeback bdi_writeback_workfn (flush-1:1)
task: ffff88007d4a4d70 ti: ffff88007d528000 task.ti: ffff88007d528000
RIP: 0010:[<ffffffff8110f17d>]  [<ffffffff8110f17d>] try_to_free_buffers+0x9d/0xa0
RSP: 0018:ffff88007d52b998  EFLAGS: 00010246
RAX: 001000000000086c RBX: ffffea00013645e0 RCX: ffff880056989e60
RDX: 0000000000000004 RSI: 0000000000000001 RDI: ffffea00013645e0
RBP: ffff88007d8b6bd8 R08: 2f00000000000000 R09: a80004d917800000
R10: 57ffe526e9b645e0 R11: 000000000000001a R12: ffffea00013645e0
R13: 0000000000001000 R14: ffff88007d52bbf0 R15: 000000000000045a
FS:  00007ff7ddf96740(0000) GS:ffff88007ca00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f66423647b0 CR3: 000000007d285000 CR4: 00000000000007f0
Stack:
 0000000000000000 0000000000000000 ffff88007a003380 ffffea00013645e0
 ffffffff81118767 000000048103b333 0000000000000004 0000000000000004
 0000000000000000 ffff88007d52bcc0 ffff88007d8b6bd8 0000000000000001
Call Trace:
 [<ffffffff81118767>] ? __mpage_writepage+0x4d7/0x5c0
 [<ffffffff810cf756>] ? page_mkclean_one+0x66/0x80
 [<ffffffff810d0c12>] ? rmap_walk+0x272/0x2a0
 [<ffffffff810d0da5>] ? page_mkclean+0x65/0x80
 [<ffffffff810cf6f0>] ? page_referenced_one+0xb0/0xb0
 [<ffffffff810afee3>] ? write_cache_pages+0x1c3/0x380
 [<ffffffff81118290>] ? clean_buffers+0x60/0x60
 [<ffffffff81069f58>] ? __dequeue_entity+0x28/0x40
 [<ffffffff8115adf0>] ? ext2_get_blocks+0x970/0x970
 [<ffffffff811181ec>] ? mpage_writepages+0x5c/0xa0
 [<ffffffff8115adf0>] ? ext2_get_blocks+0x970/0x970
 [<ffffffff81107778>] ? __writeback_single_inode+0x28/0x100
 [<ffffffff811081bb>] ? writeback_sb_inodes+0x19b/0x390
 [<ffffffff8110843e>] ? __writeback_inodes_wb+0x8e/0xc0
 [<ffffffff8110863b>] ? wb_writeback+0x1cb/0x1e0
 [<ffffffff81108bf7>] ? bdi_writeback_workfn+0x157/0x340
 [<ffffffff810558f2>] ? process_one_work+0x132/0x380
 [<ffffffff81056536>] ? worker_thread+0x116/0x3a0
 [<ffffffff81056420>] ? manage_workers.isra.24+0x290/0x290
 [<ffffffff8105c251>] ? kthread+0xc1/0xe0
 [<ffffffff8105c190>] ? kthread_create_on_node+0x170/0x170
 [<ffffffff813b93fc>] ? ret_from_fork+0x7c/0xb0
 [<ffffffff8105c190>] ? kthread_create_on_node+0x170/0x170
Code: 44 89 e0 48 83 c4 08 5b 5d 41 5c c3 66 90 be 00 10 00 00 48 89 df e8 33 40 fa ff eb bc 90 48 89 e6 e8 48 ec ff ff 41 89 c4 eb b6 <0f> 0b 90 41 57 41 56 41 89 d6 41 55 41 54 49 89 f4 55 48 89 fd 
RIP  [<ffffffff8110f17d>] try_to_free_buffers+0x9d/0xa0
 RSP <ffff88007d52b998>
---[ end trace 80fdc66ff52e7e58 ]---
May 14 18:25:27 ZigZag kernel: kernel BUG at /home/cbertsch/NZdeBUG: unable to handle kernel paging request at ffffffffffffffd8
IP: [<ffffffff8105c737>] kthread_data+0x7/0x10
PGD 1611067 PUD 1613067 PMD 0 
Oops: 0000 [#2] SMP 
Modules linked in: linear md_mod ipv6 nfsd auth_rpcgss oid_registry exportfs lockd sunrpc af_packet sd_mod ide_gd_mod ata_generic pata_amd sata_nv libata i2c_dev amd74xx k8temp ide_pci_generic forcedeth ide_core skge ehci_pci ohci_pci ehci_hcd ohci_hcd i2c_nforce2 rtc_cmos
CPU: 0 PID: 146 Comm: kworker/u8:5 Tainted: G      D       3.15.0-rc8+ #1
Hardware name: BIOSTAR Group N61PB-M2S/N61PB-M2S, BIOS 6.00 PG 02/27/2009
task: ffff88007d4a4d70 ti: ffff88007d528000 task.ti: ffff88007d528000
RIP: 0010:[<ffffffff8105c737>]  [<ffffffff8105c737>] kthread_data+0x7/0x10
RSP: 0018:ffff88007d52b6b0  EFLAGS: 00010002
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000019f42e6541
RDX: ffffffffffd23940 RSI: 0000000000000000 RDI: ffff88007d4a4d70
RBP: ffff88007d52b7b8 R08: 0000000000000000 R09: 0000000000000001
R10: 000000000000bc0c R11: 0000000000000000 R12: ffff88007d4a5510
R13: 0000000000000000 R14: 0000000000000000 R15: ffff88007d4a4d70
FS:  00007ff7ddf96740(0000) GS:ffff88007ca00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000028 CR3: 000000007d285000 CR4: 00000000000007f0
Stack:
 ffffffff810569a8 ffff88007ca11740 ffffffff813b5ed3 ffff88007d4a4d70
 0000000000011740 ffff88007d52bfd8 0000000000011740 ffffffff8106470d
 ffff88007ca11740 ffffffff8106472d ffff88007d1389d0 0000000000000046
Call Trace:
 [<ffffffff810569a8>] ? wq_worker_sleeping+0x8/0x80
 [<ffffffff813b5ed3>] ? __schedule+0x3a3/0x6f0
 [<ffffffff8106470d>] ? check_preempt_curr+0x7d/0x90
 [<ffffffff8106472d>] ? ttwu_do_wakeup+0xd/0x80
 [<ffffffff81066740>] ? try_to_wake_up+0x1d0/0x270
 [<ffffffff81054e0b>] ? __queue_work+0x10b/0x2a0
 [<ffffffff81041b17>] ? do_exit+0x677/0x990
 [<ffffffff81005a56>] ? oops_end+0x66/0x90
 [<ffffffff81002cd1>] ? do_invalid_op+0x81/0xa0
 [<ffffffff8110f17d>] ? try_to_free_buffers+0x9d/0xa0
 [<ffffffff813b5d6d>] ? __schedule+0x23d/0x6f0
 [<ffffffff811f75fb>] ? radix_tree_insert+0x2b/0xe0
 [<ffffffff813ba4a8>] ? invalid_op+0x18/0x20
 [<ffffffff8110f17d>] ? try_to_free_buffers+0x9d/0xa0
 [<ffffffff81118767>] ? __mpage_writepage+0x4d7/0x5c0
 [<ffffffff810cf756>] ? page_mkclean_one+0x66/0x80
 [<ffffffff810d0c12>] ? rmap_walk+0x272/0x2a0
 [<ffffffff810d0da5>] ? page_mkclean+0x65/0x80
 [<ffffffff810cf6f0>] ? page_referenced_one+0xb0/0xb0
 [<ffffffff810afee3>] ? write_cache_pages+0x1c3/0x380
 [<ffffffff81118290>] ? clean_buffers+0x60/0x60
 [<ffffffff81069f58>] ? __dequeue_entity+0x28/0x40
 [<ffffffff8115adf0>] ? ext2_get_blocks+0x970/0x970
 [<ffffffff811181ec>] ? mpage_writepages+0x5c/0xa0
 [<ffffffff8115adf0>] ? ext2_get_blocks+0x970/0x970
 [<ffffffff81107778>] ? __writeback_single_inode+0x28/0x100
 [<ffffffff811081bb>] ? writeback_sb_inodes+0x19b/0x390
 [<ffffffff8110843e>] ? __writeback_inodes_wb+0x8e/0xc0
 [<ffffffff8110863b>] ? wb_writeback+0x1cb/0x1e0
 [<ffffffff81108bf7>] ? bdi_writeback_workfn+0x157/0x340
 [<ffffffff810558f2>] ? process_one_work+0x132/0x380
 [<ffffffff81056536>] ? worker_thread+0x116/0x3a0
 [<ffffffff81056420>] ? manage_workers.isra.24+0x290/0x290
 [<ffffffff8105c251>] ? kthread+0xc1/0xe0
 [<ffffffff8105c190>] ? kthread_create_on_node+0x170/0x170
 [<ffffffff813b93fc>] ? ret_from_fork+0x7c/0xb0
 [<ffffffff8105c190>] ? kthread_create_on_node+0x170/0x170
Code: 00 00 00 00 65 48 8b 04 25 80 b8 00 00 48 8b 80 48 07 00 00 48 8b 40 c8 48 c1 e8 02 83 e0 01 c3 0f 1f 40 00 48 8b 87 48 07 00 00 <48> 8b 40 d8 c3 0f 1f 40 00 48 83 ec 08 48 8b b7 48 07 00 00 ba 
RIP  [<ffffffff8105c737>] kthread_data+0x7/0x10
 RSP <ffff88007d52b6b0>
CR2: ffffffffffffffd8
---[ end trace 80fdc66ff52e7e59 ]---
Fixing recursive fault but reboot is needed!

--------------020307010904060005090009
Content-Type: text/plain; charset=UTF-8;
 name="Note.bisect.log.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Note.bisect.log.txt"

git bisect start
# good: [1860e379875dfe7271c649058aeddffe5afd9d0d] Linux 3.15
git bisect good 1860e379875dfe7271c649058aeddffe5afd9d0d
# bad: [19583ca584d6f574384e17fe7613dfaeadcdc4a6] Linux 3.16
git bisect bad 19583ca584d6f574384e17fe7613dfaeadcdc4a6
# bad: [7b215de3d0abbc4f6daf2efd19e8809af0564490] Merge branch 'i2c/for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux into next
git bisect bad 7b215de3d0abbc4f6daf2efd19e8809af0564490
# good: [5142c33ed86acbcef5c63a63d2b7384b9210d39f] Merge tag 'staging-3.16-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging into next
git bisect good 5142c33ed86acbcef5c63a63d2b7384b9210d39f
# good: [15b588303155b22edd559672905db8e59a44ef9a] Merge tag 'fbdev-omap-3.16' of git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux into next
git bisect good 15b588303155b22edd559672905db8e59a44ef9a
# bad: [d62cf81524304396276f6aaa5cd7ce62f6f65110] init/main.c: don't use pr_debug()
git bisect bad d62cf81524304396276f6aaa5cd7ce62f6f65110
# good: [a58bdba749b36069ec372da9c9fd16017b6c0b47] Merge branch 'topic/firewire' into for-next
git bisect good a58bdba749b36069ec372da9c9fd16017b6c0b47
# good: [367464362591d89b371e2a690638e9bc899d8ebb] intel-iommu: integrate DMA CMA
git bisect good 367464362591d89b371e2a690638e9bc899d8ebb
# bad: [cfc47a2803db42140167b92d991ef04018e162c7] mm: page_alloc: lookup pageblock migratetype with IRQs enabled during free
git bisect bad cfc47a2803db42140167b92d991ef04018e162c7
# bad: [7c8e0181e6e0b8079c4c2ce902bf52d7a2c6fa5d] mm: replace __get_cpu_var uses with this_cpu_ptr
git bisect bad 7c8e0181e6e0b8079c4c2ce902bf52d7a2c6fa5d
# good: [c96b9e508f3d06ddb601dcc9792d62c044ab359e] mm/compaction: cleanup isolate_freepages()
git bisect good c96b9e508f3d06ddb601dcc9792d62c044ab359e
# good: [11de9927f9dd3cb0a0f18064fa4b6976fc37e79c] mm: numa: add migrated transhuge pages to LRU the same way as base pages
git bisect good 11de9927f9dd3cb0a0f18064fa4b6976fc37e79c
# bad: [a72132c31d580969a38972aaf925915e861cd342] brd: add support for rw_page()
git bisect bad a72132c31d580969a38972aaf925915e861cd342
# good: [90768eee4565adb28ea28b4ac5081c676a8fe1f2] fs/mpage.c: factor clean_buffers() out of __mpage_writepage()
git bisect good 90768eee4565adb28ea28b4ac5081c676a8fe1f2
# good: [47a191fd38ebddb1bd1510ec2bc1085c578c8868] fs/block_dev.c: add bdev_read_page() and bdev_write_page()
git bisect good 47a191fd38ebddb1bd1510ec2bc1085c578c8868
# good: [dd6bd0d9c7dbb3951005db4e424abbd37c4ff801] swap: use bdev_read_page() / bdev_write_page()
git bisect good dd6bd0d9c7dbb3951005db4e424abbd37c4ff801
# first bad commit: [a72132c31d580969a38972aaf925915e861cd342] brd: add support for rw_page()

--------------020307010904060005090009--
