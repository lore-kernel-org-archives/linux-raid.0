From: Charles Bertsch <cbertsch@cox.net>
Subject: Re: Problems with bdev_write_page().
Date: Mon, 25 May 2015 14:19:42 -0700
Message-ID: <556391EE.7000106@cox.net>
References: <Uv2G1q00k0LXzhv01v2JnY>
Reply-To: bertschc@acm.org
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040902040604040403060901"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Uv2G1q00k0LXzhv01v2JnY>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-raid@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, "BertschC@acm.org" <BertschC@acm.org>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------040902040604040403060901
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 05/17/2015 12:02 AM, NeilBrown wrote:
>
>
> Hi Matthew,
>   I've just been looking at bdev_write_page().
> You can read about why here:
>
>    http://marc.info/?t=142984068300001&r=1&w=2
....
>
> Can you propose a fix for Charles, who can trigger this bug and nicely
> bisected it for us - thanks Charles!!!
>
This problem still occurs with 4.1.0-rc5 -- three stack traces attached.

Charles Bertsch



--------------040902040604040403060901
Content-Type: text/plain; charset=UTF-8;
 name="linprob.stktrace.0525a.4.1-rc5.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="linprob.stktrace.0525a.4.1-rc5.txt"

# date
Mon May 25 13:23:04 MST 2015
# 
# cat /proc/version
Linux version 4.1.0-rc5 (cbertsch@haxe) (gcc version 4.8.2 (GCC) ) #1 SMP Mon May 25 13:00:21 MST 2015
# 
# cat /etc/zerv*
1.1.10x 2015-May-25 13:07
# 
# cat /proc/partitions
major minor  #blocks  name

   1        0      81920 ram0
   1        1      81920 ram1
   1        2      81920 ram2
   1        3      81920 ram3
   3        0  156290904 hda
   8        0  312571224 sda
   8       16     126976 sdb
   8       17     126852 sdb1
   8       48  156290904 sdd
   8       49  156289927 sdd1
   8       32 2930266584 sdc
   8       33 2930265591 sdc1
   8       64 2930266584 sde
   9        0 3086293374 md0
# 
# df
Filesystem     1K-blocks   Used Available Use% Mounted on
/dev/root          35328  35328         0 100% /
devtmpfs         1002560      0   1002560   0% /dev
/dev/ram1           7745    347      7398   5% /hd
tmpfs            1021248      0   1021248   0% /dev/shm
/dev/sdb1         122708 107784     14924  88% /flash
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
md0,41,112499,0,sdc,122,112492,1,sdd,68,0,0,1432585456,2015-05-25,13:24:16
md0,0,133651,0,sdc,0,133657,0,sdd,0,0,0,1432585466,2015-05-25,13:24:26
md0,0,132249,0,sdc,0,132243,1,sdd,0,0,0,1432585476,2015-05-25,13:24:36
md0,0,131897,0,sdc,0,131897,1,sdd,0,0,0,1432585486,2015-05-25,13:24:46
md0,0,131974,0,sdc,0,131974,1,sdd,0,0,0,1432585497,2015-05-25,13:24:57
md0,0,132486,0,sdc,0,132486,1,sdd,0,0,0,1432585507,2015-05-25,13:25:07
md0,0,131968,0,sdc,0,131968,1,sdd,0,0,0,1432585517,2015-05-25,13:25:17
md0,0,132051,0,sdc,0,132051,1,sdd,0,0,0,1432585527,2015-05-25,13:25:27
md0,0,131788,0,sdc,0,131788,1,sdd,0,0,0,1432585537,2015-05-25,13:25:37
md0,0,131404,0,sdc,0,131404,1,sdd,0,0,0,1432585547,2015-05-25,13:25:47
md0,0,131968,0,sdc,0,131968,1,sdd,0,0,0,1432585557,2015-05-25,13:25:57
md0,0,131705,0,sdc,0,131705,1,sdd,0,0,0,1432585567,2015-05-25,13:26:07
md0,0,131552,0,sdc,0,131552,1,sdd,0,0,0,1432585577,2015-05-25,13:26:17
md0,0,131680,0,sdc,0,131680,1,sdd,0,0,0,1432585587,2015-05-25,13:26:27
md0,0,131328,0,sdc,0,131328,1,sdd,0,0,0,1432585597,2015-05-25,13:26:37
md0,0,131532,0,sdc,0,131532,1,sdd,0,0,0,1432585607,2015-05-25,13:26:47
md0,0,131577,0,sdc,0,131577,1,sdd,0,0,0,1432585617,2015-05-25,13:26:57
md0,0,131289,0,sdc,0,131296,0,sdd,0,0,0,1432585627,2015-05-25,13:27:07
md0,0,131398,0,sdc,0,131398,0,sdd,0,0,0,1432585637,2015-05-25,13:27:17
md0,0,131200,0,sdc,0,131193,1,sdd,0,0,0,1432585647,2015-05-25,13:27:27
md0,0,131276,0,sdc,0,131276,1,sdd,0,0,0,1432585658,2015-05-25,13:27:38
md0,0,131360,0,sdc,0,131366,0,sdd,0,0,0,1432585668,2015-05-25,13:27:48
md0,0,131142,0,sdc,0,131136,1,sdd,0,0,0,1432585678,2015-05-25,13:27:58
md0,0,131379,0,sdc,0,131379,1,sdd,0,0,0,1432585688,2015-05-25,13:28:08
md0,0,131571,0,sdc,0,131571,1,sdd,0,0,0,1432585698,2015-05-25,13:28:18
md0,0,131328,0,sdc,0,131328,1,sdd,0,0,0,1432585708,2015-05-25,13:28:28
md0,0,131136,0,sdc,0,131136,1,sdd,0,0,0,1432585718,2015-05-25,13:28:38
md0,0,130924,0,sdc,0,130924,1,sdd,0,0,0,1432585728,2015-05-25,13:28:48
md0,0,131315,0,sdc,0,131315,1,sdd,0,0,0,1432585738,2015-05-25,13:28:58
md0,0,131091,0,sdc,0,131091,1,sdd,0,0,0,1432585748,2015-05-25,13:29:08
md0,0,131008,0,sdc,0,131008,1,sdd,0,0,0,1432585758,2015-05-25,13:29:18
md0,0,130963,0,sdc,0,130963,1,sdd,0,0,0,1432585768,2015-05-25,13:29:28
md0,0,130950,0,sdc,0,130950,1,sdd,0,0,0,1432585778,2015-05-25,13:29:38
md0,0,130950,0,sdc,0,130950,1,sdd,0,0,0,1432585788,2015-05-25,13:29:48
md0,0,130636,0,sdc,0,130636,1,sdd,0,0,0,1432585798,2015-05-25,13:29:58
------------[ cut here ]------------
kernel BUG at /home/cbertsch/NZdev/nz218/othersrc/linux-git/fs/buffer.c:3220!
invalid opcode: 0000 [#1] SMP 
Modules linked in: linear md_mod ipv6 nfsd auth_rpcgss oid_registry exportfs lockd grace sunrpc af_packet sd_mod ide_gd_mod ata_generic pata_amd sata_nv libata i2c_dev amd74xx k8temp ide_pci_generic forcedeth ide_core skge ehci_pci ohci_pci ehci_hcd ohci_hcd i2c_nforce2 rtc_cmos
CPU: 0 PID: 1162 Comm: kworker/u8:0 Not tainted 4.1.0-rc5 #1
Hardware name: BIOSTAR Group N61PB-M2S/N61PB-M2S, BIOS 6.00 PG 02/27/2009
Workqueue: writeback bdi_writeback_workfn (flush-1:1)
task: ffff88007ea7a890 ti: ffff88000f384000 task.ti: ffff88000f384000
RIP: 0010:[<ffffffff8112109f>]  [<ffffffff8112109f>] try_to_free_buffers+0xaf/0xc0
RSP: 0018:ffff88000f3878f8  EFLAGS: 00010246
RAX: 001000000000086c RBX: ffffea00019e59a0 RCX: ffff88007a352160
RDX: 0000000000000004 RSI: 0000000000000001 RDI: ffffea00019e59a0
RBP: ffff88007d4818b0 R08: 0000000000000000 R09: 0000000000017448
R10: ffff88007cc47600 R11: 000000000000001a R12: ffffea00019e59a0
R13: 0000000000001000 R14: ffff88000f387b78 R15: 0000000000001034
FS:  00007f427c084740(0000) GS:ffff88007ca00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007ff515a600a8 CR3: 000000007eb3f000 CR4: 00000000000006f0
Stack:
 0000000000000000 0000000000000000 0000000000000000 ffff88007a003040
 ffffea00019e59a0 ffffffff8112a277 0000000400000000 ffff880000000004
 0000000000000004 0000000000000000 ffff88000f387c50 ffff88007d4818b0
Call Trace:
 [<ffffffff8112a277>] ? __mpage_writepage+0x4f7/0x5f0
 [<ffffffff810e0234>] ? rmap_walk+0xe4/0x230
 [<ffffffff810e04e3>] ? page_mkclean+0x63/0x80
 [<ffffffff810df250>] ? page_referenced_one+0xb0/0xb0
 [<ffffffff8111903a>] ? inode_to_bdi+0x1a/0x60
 [<ffffffff810bf51c>] ? write_cache_pages+0x1cc/0x390
 [<ffffffff81129d80>] ? clean_buffers+0x60/0x60
 [<ffffffff8116d1f0>] ? ext2_get_blocks+0x990/0x990
 [<ffffffff81129ce3>] ? mpage_writepages+0x53/0x90
 [<ffffffff8116d1f0>] ? ext2_get_blocks+0x990/0x990
 [<ffffffff8111933a>] ? __writeback_single_inode+0x2a/0x180
 [<ffffffff811197ab>] ? writeback_sb_inodes+0x1ab/0x3f0
 [<ffffffff81119a7e>] ? __writeback_inodes_wb+0x8e/0xc0
 [<ffffffff81119c7b>] ? wb_writeback+0x1cb/0x1e0
 [<ffffffff8110c005>] ? get_nr_inodes+0x45/0x60
 [<ffffffff810bf98d>] ? global_dirty_limits+0xd/0xf0
 [<ffffffff8111a1f8>] ? bdi_writeback_workfn+0x158/0x340
 [<ffffffff8105ab44>] ? process_one_work+0x124/0x320
 [<ffffffff8105ae56>] ? worker_thread+0x116/0x460
 [<ffffffff8105ad40>] ? process_one_work+0x320/0x320
 [<ffffffff81060255>] ? kthread+0xc5/0xe0
 [<ffffffff81060190>] ? kthread_create_on_node+0x170/0x170
 [<ffffffff813efc12>] ? ret_from_fork+0x42/0x70
 [<ffffffff81060190>] ? kthread_create_on_node+0x170/0x170
Code: 04 72 09 eb c6 0f 1f 80 00 00 00 00 48 89 ee 48 89 df e8 05 e1 f9 ff eb b2 0f 1f 00 48 8d 74 24 08 e8 d6 ea ff ff 41 89 c4 eb a5 <0f> 0b 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 48 8b 07 53 
RIP  [<ffffffff8112109f>] try_to_free_buffers+0xaf/0xc0
 RSP <ffff88000f3878f8>
---[ end trace 83b8fe6acbe88f4a ]---
BUG: unable to handle kernel paging request at ffffffffffffffd8
IP: [<ffffffff81060747>] kthread_data+0x7/0x10
PGD 160c067 PUD 160e067 PMD 0 
Oops: 0000 [#2] SMP 
Modules linked in: linear md_mod ipv6 nfsd auth_rpcgss oid_registry exportfs lockd grace sunrpc af_packet sd_mod ide_gd_mod ata_generic pata_amd sata_nv libata i2c_dev amd74xx k8temp ide_pci_generic forcedeth ide_core skge ehci_pci ohci_pci ehci_hcd ohci_hcd i2c_nforce2 rtc_cmos
CPU: 0 PID: 1162 Comm: kworker/u8:0 Tainted: G      D         4.1.0-rc5 #1
Hardware name: BIOSTAR Group N61PB-M2S/N61PB-M2S, BIOS 6.00 PG 02/27/2009
task: ffff88007ea7a890 ti: ffff88000f384000 task.ti: ffff88000f384000
RIP: 0010:[<ffffffff81060747>]  [<ffffffff81060747>] kthread_data+0x7/0x10
RSP: 0018:ffff88000f387680  EFLAGS: 00010002
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000012fcbcb79f
RDX: ffffffffffd23940 RSI: 0000000000000000 RDI: ffff88007ea7a890
RBP: ffff88007ea7a890 R08: ffff88007eaa7550 R09: 0000000000000001
R10: ffffffff81904f04 R11: 000000000000001a R12: ffff88007ea7b078
R13: 0000000000000000 R14: 0000000000014480 R15: 0000000000000000
FS:  00007f427c084740(0000) GS:ffff88007ca00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000028 CR3: 000000007eb3f000 CR4: 00000000000006f0
Stack:
 ffffffff8105b8c8 ffff88007ca14480 ffffffff813ec6e3 ffff88007ea7a890
 0000000000000000 ffff88007ea7a890 ffff88000f388000 ffff88007ea7af70
 ffff88000f387728 0000000000000000 ffff88007c3aab30 ffff88007ea7a890
Call Trace:
 [<ffffffff8105b8c8>] ? wq_worker_sleeping+0x8/0x90
 [<ffffffff813ec6e3>] ? __schedule+0x343/0x750
 [<ffffffff813ecb1a>] ? schedule+0x2a/0x80
 [<ffffffff81048384>] ? do_exit+0x664/0xa80
 [<ffffffff81005bc7>] ? oops_end+0x67/0xa0
 [<ffffffff81002c8b>] ? do_error_trap+0x6b/0xd0
 [<ffffffff8112109f>] ? try_to_free_buffers+0xaf/0xc0
 [<ffffffff81230b0c>] ? percpu_counter_set+0x5c/0x80
 [<ffffffff813f0a68>] ? invalid_op+0x18/0x20
 [<ffffffff8112109f>] ? try_to_free_buffers+0xaf/0xc0
 [<ffffffff81123bb8>] ? bdev_write_page+0x68/0xa0
 [<ffffffff8112a277>] ? __mpage_writepage+0x4f7/0x5f0
 [<ffffffff810e0234>] ? rmap_walk+0xe4/0x230
 [<ffffffff810e04e3>] ? page_mkclean+0x63/0x80
 [<ffffffff810df250>] ? page_referenced_one+0xb0/0xb0
 [<ffffffff8111903a>] ? inode_to_bdi+0x1a/0x60
 [<ffffffff810bf51c>] ? write_cache_pages+0x1cc/0x390
 [<ffffffff81129d80>] ? clean_buffers+0x60/0x60
 [<ffffffff8116d1f0>] ? ext2_get_blocks+0x990/0x990
 [<ffffffff81129ce3>] ? mpage_writepages+0x53/0x90
 [<ffffffff8116d1f0>] ? ext2_get_blocks+0x990/0x990
 [<ffffffff8111933a>] ? __writeback_single_inode+0x2a/0x180
 [<ffffffff811197ab>] ? writeback_sb_inodes+0x1ab/0x3f0
 [<ffffffff81119a7e>] ? __writeback_inodes_wb+0x8e/0xc0
 [<ffffffff81119c7b>] ? wb_writeback+0x1cb/0x1e0
 [<ffffffff8110c005>] ? get_nr_inodes+0x45/0x60
 [<ffffffff810bf98d>] ? global_dirty_limits+0xd/0xf0
 [<ffffffff8111a1f8>] ? bdi_writeback_workfn+0x158/0x340
 [<ffffffff8105ab44>] ? process_one_work+0x124/0x320
 [<ffffffff8105ae56>] ? worker_thread+0x116/0x460
 [<ffffffff8105ad40>] ? process_one_work+0x320/0x320
 [<ffffffff81060255>] ? kthread+0xc5/0xe0
 [<ffffffff81060190>] ? kthread_create_on_node+0x170/0x170
 [<ffffffff813efc12>] ? ret_from_fork+0x42/0x70
 [<ffffffff81060190>] ? kthread_create_on_node+0x170/0x170
Code: 00 00 00 00 65 48 8b 04 25 00 a9 00 00 48 8b 80 90 07 00 00 48 8b 40 c8 48 c1 e8 02 83 e0 01 c3 0f 1f 40 00 48 8b 87 90 07 00 00 <48> 8b 40 d8 c3 0f 1f 40 00 48 83 ec 18 48 8b b7 90 07 00 00 ba 
RIP  [<ffffffff81060747>] kthread_data+0x7/0x10
 RSP <ffff88000f387680>
CR2: ffffffffffffffd8
---[ end trace 83b8fe6acbe88f4b ]---
Fixing recursive fault but reboot is needed!

--------------040902040604040403060901
Content-Type: text/plain; charset=UTF-8;
 name="linprob.stktrace.0525b.4.1-rc5.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="linprob.stktrace.0525b.4.1-rc5.txt"


# 
# date
Mon May 25 13:35:21 MST 2015
# 
# cat /proc/version
Linux version 4.1.0-rc5 (cbertsch@haxe) (gcc version 4.8.2 (GCC) ) #1 SMP Mon May 25 13:00:21 MST 2015
# 
# cat /etc/zerv*
1.1.10x 2015-May-25 13:07
# 
# cat /proc/partitions
major minor  #blocks  name

   1        0      81920 ram0
   1        1      81920 ram1
   1        2      81920 ram2
   1        3      81920 ram3
   3        0  156290904 hda
   8        0  312571224 sda
   8       16     126976 sdb
   8       17     126852 sdb1
   8       48  156290904 sdd
   8       49  156289927 sdd1
   8       32 2930266584 sdc
   8       33 2930265591 sdc1
   8       64 2930266584 sde
   9        0 3086293374 md0
# 
# df
Filesystem     1K-blocks   Used Available Use% Mounted on
/dev/root          35328  35328         0 100% /
devtmpfs         1002560      0   1002560   0% /dev
/dev/ram1           7745    343      7402   5% /hd
tmpfs            1021248      0   1021248   0% /dev/shm
/dev/sdb1         122708 107784     14924  88% /flash
# 
# cat /proc/mdstat
Personalities : [linear] 
md0 : active linear sdc1[0] sdd1[1]
      3086293374 blocks super 1.2 0k rounding
      
unused devices: <none>
# 
# dd bs=16384 if=/dev/zero of=/dev/md0 count=32M &
# 
# monirw 10 md0 sdc sdd
/sbin/monirw sec=10 file=/proc/diskstats itemset=md0 sdc sdd
md0,41,102201,0,sdc,121,102201,0,sdd,68,0,0,1432586189,2015-05-25,13:36:29
md0,0,131808,0,sdc,0,131801,1,sdd,0,0,0,1432586199,2015-05-25,13:36:39
md0,0,131980,0,sdc,0,131987,0,sdd,0,0,0,1432586209,2015-05-25,13:36:49
md0,0,131795,0,sdc,0,131788,1,sdd,0,0,0,1432586219,2015-05-25,13:36:59
md0,0,131206,0,sdc,0,131206,1,sdd,0,0,0,1432586229,2015-05-25,13:37:09
md0,0,131315,0,sdc,0,131315,1,sdd,0,0,0,1432586239,2015-05-25,13:37:19
md0,0,131238,0,sdc,0,131238,1,sdd,0,0,0,1432586250,2015-05-25,13:37:30
md0,0,131404,0,sdc,0,131404,1,sdd,0,0,0,1432586260,2015-05-25,13:37:40
md0,0,130828,0,sdc,0,130828,1,sdd,0,0,0,1432586270,2015-05-25,13:37:50
md0,0,130611,0,sdc,0,130611,1,sdd,0,0,0,1432586280,2015-05-25,13:38:00
md0,0,130694,0,sdc,0,130694,1,sdd,0,0,0,1432586290,2015-05-25,13:38:10
md0,0,130560,0,sdc,0,130560,1,sdd,0,0,0,1432586300,2015-05-25,13:38:20
md0,0,130329,0,sdc,0,130329,1,sdd,0,0,0,1432586310,2015-05-25,13:38:30
md0,0,130579,0,sdc,0,130579,1,sdd,0,0,0,1432586320,2015-05-25,13:38:40
md0,0,130195,0,sdc,0,130195,1,sdd,0,0,0,1432586330,2015-05-25,13:38:50
md0,0,130566,0,sdc,0,130566,1,sdd,0,0,0,1432586340,2015-05-25,13:39:00
md0,0,130201,0,sdc,0,130201,1,sdd,0,0,0,1432586350,2015-05-25,13:39:10
md0,0,130278,0,sdc,0,130284,0,sdd,0,0,0,1432586360,2015-05-25,13:39:20
md0,0,130675,0,sdc,0,130668,1,sdd,0,0,0,1432586370,2015-05-25,13:39:30
md0,0,130636,0,sdc,0,130636,1,sdd,0,0,0,1432586380,2015-05-25,13:39:40
md0,0,130220,0,sdc,0,130220,1,sdd,0,0,0,1432586390,2015-05-25,13:39:50
md0,0,130201,0,sdc,0,130201,1,sdd,0,0,0,1432586400,2015-05-25,13:40:00
md0,0,130310,0,sdc,0,130310,1,sdd,0,0,0,1432586411,2015-05-25,13:40:11
md0,0,130464,0,sdc,0,130464,1,sdd,0,0,0,1432586421,2015-05-25,13:40:21
md0,0,129734,0,sdc,0,129734,1,sdd,0,0,0,1432586431,2015-05-25,13:40:31
md0,0,130214,0,sdc,0,130220,0,sdd,0,0,0,1432586441,2015-05-25,13:40:41
md0,0,130163,0,sdc,0,130156,1,sdd,0,0,0,1432586451,2015-05-25,13:40:51
md0,0,130252,0,sdc,0,130252,1,sdd,0,0,0,1432586461,2015-05-25,13:41:01
md0,0,129792,0,sdc,0,129792,1,sdd,0,0,0,1432586471,2015-05-25,13:41:11
md0,0,130227,0,sdc,0,130227,1,sdd,0,0,0,1432586481,2015-05-25,13:41:21
md0,0,130144,0,sdc,0,130144,1,sdd,0,0,0,1432586491,2015-05-25,13:41:31
md0,0,129984,0,sdc,0,129984,1,sdd,0,0,0,1432586501,2015-05-25,13:41:41
md0,0,129689,0,sdc,0,129689,1,sdd,0,0,0,1432586511,2015-05-25,13:41:51
md0,0,130022,0,sdc,0,130022,1,sdd,0,0,0,1432586521,2015-05-25,13:42:01
md0,0,129830,0,sdc,0,129830,1,sdd,0,0,0,1432586531,2015-05-25,13:42:11
------------[ cut here ]------------
kernel BUG at /home/cbertsch/NZdev/nz218/othersrc/linux-git/fs/buffer.c:3220!
invalid opcode: 0000 [#1] SMP 
Modules linked in: linear md_mod ipv6 nfsd auth_rpcgss oid_registry exportfs lockd grace sunrpc af_packet sd_mod ide_gd_mod ata_generic pata_amd sata_nv libata i2c_dev amd74xx k8temp ide_pci_generic forcedeth ide_core skge ehci_pci ohci_pci ehci_hcd ohci_hcd i2c_nforce2 rtc_cmos
CPU: 0 PID: 139 Comm: kworker/u8:2 Not tainted 4.1.0-rc5 #1
Hardware name: BIOSTAR Group N61PB-M2S/N61PB-M2S, BIOS 6.00 PG 02/27/2009
Workqueue: writeback bdi_writeback_workfn (flush-1:1)
task: ffff88007975c110 ti: ffff880077498000 task.ti: ffff880077498000
RIP: 0010:[<ffffffff8112109f>]  [<ffffffff8112109f>] try_to_free_buffers+0xaf/0xc0
RSP: 0018:ffff88007749b8f8  EFLAGS: 00010246
RAX: 001000000000086c RBX: ffffea0001b3f090 RCX: ffff880073e0dec8
RDX: 0000000000000004 RSI: 0000000000000001 RDI: ffffea0001b3f090
RBP: ffff88007a309e70 R08: 0000000000000002 R09: 0000000000017448
R10: ffff88007cc47600 R11: 000000000000001a R12: ffffea0001b3f090
R13: 0000000000001000 R14: ffff88007749bb78 R15: 0000000000002838
FS:  00007fa82f7e6740(0000) GS:ffff88007ca00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fd1cdf0dffc CR3: 000000007972a000 CR4: 00000000000006f0
Stack:
 0000000000000000 0000000000000000 0000000000000000 ffff88007a003040
 ffffea0001b3f090 ffffffff8112a277 0000000400000002 ffff880000000004
 0000000000000004 0000000000000000 ffff88007749bc50 ffff88007a309e70
Call Trace:
 [<ffffffff8112a277>] ? __mpage_writepage+0x4f7/0x5f0
 [<ffffffff810e0234>] ? rmap_walk+0xe4/0x230
 [<ffffffff810e04e3>] ? page_mkclean+0x63/0x80
 [<ffffffff810df250>] ? page_referenced_one+0xb0/0xb0
 [<ffffffff8111903a>] ? inode_to_bdi+0x1a/0x60
 [<ffffffff810bf51c>] ? write_cache_pages+0x1cc/0x390
 [<ffffffff81129d80>] ? clean_buffers+0x60/0x60
 [<ffffffff811213cb>] ? __getblk_gfp+0x1b/0x50
 [<ffffffff8116d1f0>] ? ext2_get_blocks+0x990/0x990
 [<ffffffff81129ce3>] ? mpage_writepages+0x53/0x90
 [<ffffffff8116d1f0>] ? ext2_get_blocks+0x990/0x990
 [<ffffffff8111933a>] ? __writeback_single_inode+0x2a/0x180
 [<ffffffff811197ab>] ? writeback_sb_inodes+0x1ab/0x3f0
 [<ffffffff81119a7e>] ? __writeback_inodes_wb+0x8e/0xc0
 [<ffffffff81119c7b>] ? wb_writeback+0x1cb/0x1e0
 [<ffffffff8110c005>] ? get_nr_inodes+0x45/0x60
 [<ffffffff810bf98d>] ? global_dirty_limits+0xd/0xf0
 [<ffffffff8111a1f8>] ? bdi_writeback_workfn+0x158/0x340
 [<ffffffff8105ab44>] ? process_one_work+0x124/0x320
 [<ffffffff8105ae56>] ? worker_thread+0x116/0x460
 [<ffffffff8105ad40>] ? process_one_work+0x320/0x320
 [<ffffffff81060255>] ? kthread+0xc5/0xe0
 [<ffffffff81060190>] ? kthread_create_on_node+0x170/0x170
 [<ffffffff813efc12>] ? ret_from_fork+0x42/0x70
 [<ffffffff81060190>] ? kthread_create_on_node+0x170/0x170
Code: 04 72 09 eb c6 0f 1f 80 00 00 00 00 48 89 ee 48 89 df e8 05 e1 f9 ff eb b2 0f 1f 00 48 8d 74 24 08 e8 d6 ea ff ff 41 89 c4 eb a5 <0f> 0b 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 48 8b 07 53 
RIP  [<ffffffff8112109f>] try_to_free_buffers+0xaf/0xc0
 RSP <ffff88007749b8f8>
---[ end trace 02a1bb501c316a0b ]---
May 25 13:42:19 ZigZag kernel: kernel BUG at /home/cbertsch/NZdev/nz218/othersrc/linux-git/fs/buffer.c:3220!
BUG: unable to handle kernel paging request at ffffffffffffffd8
IP: [<ffffffff81060747>] kthread_data+0x7/0x10
PGD 160c067 PUD 160e067 PMD 0 
Oops: 0000 [#2] SMP 
Modules linked in: linear md_mod ipv6 nfsd auth_rpcgss oid_registry exportfs lockd grace sunrpc af_packet sd_mod ide_gd_mod ata_generic pata_amd sata_nv libata i2c_dev amd74xx k8temp ide_pci_generic forcedeth ide_core skge ehci_pci ohci_pci ehci_hcd ohci_hcd i2c_nforce2 rtc_cmos
CPU: 0 PID: 139 Comm: kworker/u8:2 Tainted: G      D         4.1.0-rc5 #1
Hardware name: BIOSTAR Group N61PB-M2S/N61PB-M2S, BIOS 6.00 PG 02/27/2009
task: ffff88007975c110 ti: ffff880077498000 task.ti: ffff880077498000
RIP: 0010:[<ffffffff81060747>]  [<ffffffff81060747>] kthread_data+0x7/0x10
RSP: 0018:ffff88007749b680  EFLAGS: 00010002
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000135064379a
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88007975c110
RBP: ffff88007975c110 R08: ffff8800774888d0 R09: 0000000000000001
R10: 0000000000000001 R11: 000000000000001a R12: ffff88007975c8f8
R13: 0000000000000000 R14: 0000000000014480 R15: 0000000000000000
FS:  00007fa82f7e6740(0000) GS:ffff88007ca00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000028 CR3: 000000007972a000 CR4: 00000000000006f0
Stack:
 ffffffff8105b8c8 ffff88007ca14480 ffffffff813ec6e3 ffff88007975c110
 0000000000000000 ffff88007975c110 ffff88007749c000 ffff88007975c7f0
 ffff88007749b728 0000000000000000 ffff88007c3aab30 ffff88007975c110
Call Trace:
 [<ffffffff8105b8c8>] ? wq_worker_sleeping+0x8/0x90
 [<ffffffff813ec6e3>] ? __schedule+0x343/0x750
 [<ffffffff813ecb1a>] ? schedule+0x2a/0x80
 [<ffffffff81048384>] ? do_exit+0x664/0xa80
 [<ffffffff81005bc7>] ? oops_end+0x67/0xa0
 [<ffffffff81002c8b>] ? do_error_trap+0x6b/0xd0
 [<ffffffff8112109f>] ? try_to_free_buffers+0xaf/0xc0
 [<ffffffff81216cbb>] ? radix_tree_insert+0x2b/0xe0
 [<ffffffff813f0a68>] ? invalid_op+0x18/0x20
 [<ffffffff8112109f>] ? try_to_free_buffers+0xaf/0xc0
 [<ffffffff81123bb8>] ? bdev_write_page+0x68/0xa0
 [<ffffffff8112a277>] ? __mpage_writepage+0x4f7/0x5f0
 [<ffffffff810e0234>] ? rmap_walk+0xe4/0x230
 [<ffffffff810e04e3>] ? page_mkclean+0x63/0x80
 [<ffffffff810df250>] ? page_referenced_one+0xb0/0xb0
 [<ffffffff8111903a>] ? inode_to_bdi+0x1a/0x60
 [<ffffffff810bf51c>] ? write_cache_pages+0x1cc/0x390
 [<ffffffff81129d80>] ? clean_buffers+0x60/0x60
 [<ffffffff811213cb>] ? __getblk_gfp+0x1b/0x50
 [<ffffffff8116d1f0>] ? ext2_get_blocks+0x990/0x990
 [<ffffffff81129ce3>] ? mpage_writepages+0x53/0x90
 [<ffffffff8116d1f0>] ? ext2_get_blocks+0x990/0x990
 [<ffffffff8111933a>] ? __writeback_single_inode+0x2a/0x180
 [<ffffffff811197ab>] ? writeback_sb_inodes+0x1ab/0x3f0
 [<ffffffff81119a7e>] ? __writeback_inodes_wb+0x8e/0xc0
 [<ffffffff81119c7b>] ? wb_writeback+0x1cb/0x1e0
 [<ffffffff8110c005>] ? get_nr_inodes+0x45/0x60
 [<ffffffff810bf98d>] ? global_dirty_limits+0xd/0xf0
 [<ffffffff8111a1f8>] ? bdi_writeback_workfn+0x158/0x340
 [<ffffffff8105ab44>] ? process_one_work+0x124/0x320
 [<ffffffff8105ae56>] ? worker_thread+0x116/0x460
 [<ffffffff8105ad40>] ? process_one_work+0x320/0x320
 [<ffffffff81060255>] ? kthread+0xc5/0xe0
 [<ffffffff81060190>] ? kthread_create_on_node+0x170/0x170
 [<ffffffff813efc12>] ? ret_from_fork+0x42/0x70
 [<ffffffff81060190>] ? kthread_create_on_node+0x170/0x170
Code: 00 00 00 00 65 48 8b 04 25 00 a9 00 00 48 8b 80 90 07 00 00 48 8b 40 c8 48 c1 e8 02 83 e0 01 c3 0f 1f 40 00 48 8b 87 90 07 00 00 <48> 8b 40 d8 c3 0f 1f 40 00 48 83 ec 18 48 8b b7 90 07 00 00 ba 
RIP  [<ffffffff81060747>] kthread_data+0x7/0x10
 RSP <ffff88007749b680>
CR2: ffffffffffffffd8
---[ end trace 02a1bb501c316a0c ]---
Fixing recursive fault but reboot is needed!

--------------040902040604040403060901
Content-Type: text/plain; charset=UTF-8;
 name="linprob.stktrace.0525c.4.1-rc5.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="linprob.stktrace.0525c.4.1-rc5.txt"


# 
# date
Mon May 25 13:46:02 MST 2015
# 
# cat /proc/zerv        version
Linux version 4.1.0-rc5 (cbertsch@haxe) (gcc version 4.8.2 (GCC) ) #1 SMP Mon May 25 13:00:21 MST 2015
# 
# cat /etc/zerv*
1.1.10x 2015-May-25 13:07
# 
# cat /proc/partitions
major minor  #blocks  name

   1        0      81920 ram0
   1        1      81920 ram1
   1        2      81920 ram2
   1        3      81920 ram3
   3        0  156290904 hda
   8        0  312571224 sda
   8       16     126976 sdb
   8       17     126852 sdb1
   8       48  156290904 sdd
   8       49  156289927 sdd1
   8       32 2930266584 sdc
   8       33 2930265591 sdc1
   8       64 2930266584 sde
   9        0 3086293374 md0
# 
# df
Filesystem     1K-blocks   Used Available Use% Mounted on
/dev/root          35328  35328         0 100% /
devtmpfs         1002560      0   1002560   0% /dev
/dev/ram1           7745    343      7402   5% /hd
tmpfs            1021248      0   1021248   0% /dev/shm
/dev/sdb1         122708 107784     14924  88% /flash
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
# 
# ps
  PID TTY          TIME CMD
  193 ttyS0    00:00:00 sh
  832 ttyS0    00:00:00 dd
  833 ttyS0    00:00:00 ps
# 
# #### do not run monirw to monitor disk activity .....
# 
# date
Mon May 25 13:47:30 MST 2015
# 
# date
Mon May 25 13:48:13 MST 2015
# 
# 
# date
Mon May 25 13:51:02 MST 2015
# 
# 
# date
Mon May 25 13:53:36 MST 2015
# 
# ------------[ cut here ]------------
kernel BUG at /home/cbertsch/NZdev/nz218/othersrc/linux-git/fs/buffer.c:3220!
invalid opcode: 0000 [#1] SMP 
Modules linked in: linear md_mod ipv6 nfsd auth_rpcgss oid_registry exportfs lockd grace sunrpc af_packet sd_mod ide_gd_mod ata_generic pata_amd sata_nv libata i2c_dev amd74xx k8temp ide_pci_generic forcedeth ide_core skge ehci_pci ohci_pci ehci_hcd ohci_hcd i2c_nforce2 rtc_cmos
CPU: 0 PID: 148 Comm: kworker/u8:2 Not tainted 4.1.0-rc5 #1
Hardware name: BIOSTAR Group N61PB-M2S/N61PB-M2S, BIOS 6.00 PG 02/27/2009
Workqueue: writeback bdi_writeback_workfn (flush-1:1)
task: ffff8800774881d0 ti: ffff8800775a8000 task.ti: ffff8800775a8000
RIP: 0010:[<ffffffff8112109f>]  [<ffffffff8112109f>] try_to_free_buffers+0xaf/0xc0
RSP: 0018:ffff8800775ab8f8  EFLAGS: 00010246
RAX: 001000000000086c RBX: ffffea0001148a80 RCX: ffff88004f740230
RDX: 0000000000000004 RSI: 0000000000000001 RDI: ffffea0001148a80
RBP: ffff88007d0a38b0 R08: 0000000000000002 R09: 0000000000017448
R10: ffff88007cc47600 R11: 000000000000001a R12: ffffea0001148a80
R13: 0000000000001000 R14: ffff8800775abb78 R15: 0000000000000c5a
FS:  00007fb059391740(0000) GS:ffff88007ca00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f87330b4ffc CR3: 000000007e8c7000 CR4: 00000000000006f0
Stack:
 0000000000000000 0000000000000000 0000000000000000 ffff88007a003040
 ffffea0001148a80 ffffffff8112a277 0000000400000002 ffff880000000004
 0000000000000004 0000000000000000 ffff8800775abc50 ffff88007d0a38b0
Call Trace:
 [<ffffffff8112a277>] ? __mpage_writepage+0x4f7/0x5f0
 [<ffffffff810e0234>] ? rmap_walk+0xe4/0x230
 [<ffffffff810e04e3>] ? page_mkclean+0x63/0x80
 [<ffffffff810df250>] ? page_referenced_one+0xb0/0xb0
 [<ffffffff8111903a>] ? inode_to_bdi+0x1a/0x60
 [<ffffffff810bf51c>] ? write_cache_pages+0x1cc/0x390
 [<ffffffff81129d80>] ? clean_buffers+0x60/0x60
 [<ffffffff811f4673>] ? blk_flush_plug_list+0xe3/0x260
 [<ffffffff8116d1f0>] ? ext2_get_blocks+0x990/0x990
 [<ffffffff81129ce3>] ? mpage_writepages+0x53/0x90
 [<ffffffff8116d1f0>] ? ext2_get_blocks+0x990/0x990
 [<ffffffff8111933a>] ? __writeback_single_inode+0x2a/0x180
 [<ffffffff811197ab>] ? writeback_sb_inodes+0x1ab/0x3f0
 [<ffffffff81119a7e>] ? __writeback_inodes_wb+0x8e/0xc0
 [<ffffffff81119c7b>] ? wb_writeback+0x1cb/0x1e0
 [<ffffffff8110c005>] ? get_nr_inodes+0x45/0x60
 [<ffffffff810bf98d>] ? global_dirty_limits+0xd/0xf0
 [<ffffffff8111a1f8>] ? bdi_writeback_workfn+0x158/0x340
 [<ffffffff8105ab44>] ? process_one_work+0x124/0x320
 [<ffffffff8105ae56>] ? worker_thread+0x116/0x460
 [<ffffffff8105ad40>] ? process_one_work+0x320/0x320
 [<ffffffff81060255>] ? kthread+0xc5/0xe0
 [<ffffffff81060190>] ? kthread_create_on_node+0x170/0x170
 [<ffffffff813efc12>] ? ret_from_fork+0x42/0x70
 [<ffffffff81060190>] ? kthread_create_on_node+0x170/0x170
Code: 04 72 09 eb c6 0f 1f 80 00 00 00 00 48 89 ee 48 89 df e8 05 e1 f9 ff eb b2 0f 1f 00 48 8d 74 24 08 e8 d6 ea ff ff 41 89 c4 eb a5 <0f> 0b 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 48 8b 07 53 
RIP  [<ffffffff8112109f>] try_to_free_buffers+0xaf/0xc0
 RSP <ffff8800775ab8f8>
---[ end trace bc092d5328429ae1 ]---
May 25 13:54:19 ZigZag kernel: kernel BUG at /home/cbertsch/NZdev/nz218/othersrc/linux-git/fs/buffer.c:3220!
BUG: unable to handle kernel paging request at ffffffffffffffd8
IP: [<ffffffff81060747>] kthread_data+0x7/0x10
PGD 160c067 PUD 160e067 PMD 0 
Oops: 0000 [#2] SMP 
Modules linked in: linear md_mod ipv6 nfsd auth_rpcgss oid_registry exportfs lockd grace sunrpc af_packet sd_mod ide_gd_mod ata_generic pata_amd sata_nv libata i2c_dev amd74xx k8temp ide_pci_generic forcedeth ide_core skge ehci_pci ohci_pci ehci_hcd ohci_hcd i2c_nforce2 rtc_cmos
CPU: 0 PID: 148 Comm: kworker/u8:2 Tainted: G      D         4.1.0-rc5 #1
Hardware name: BIOSTAR Group N61PB-M2S/N61PB-M2S, BIOS 6.00 PG 02/27/2009
task: ffff8800774881d0 ti: ffff8800775a8000 task.ti: ffff8800775a8000
RIP: 0010:[<ffffffff81060747>]  [<ffffffff81060747>] kthread_data+0x7/0x10
RSP: 0018:ffff8800775ab680  EFLAGS: 00010002
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000016382baaed
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8800774881d0
RBP: ffff8800774881d0 R08: ffff8800774da990 R09: 0000000000000001
R10: 0000000000000001 R11: 000000000000001a R12: ffff8800774889b8
R13: 0000000000000000 R14: 0000000000014480 R15: 0000000000000000
FS:  00007fb059391740(0000) GS:ffff88007ca00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000028 CR3: 000000007e8c7000 CR4: 00000000000006f0
Stack:
 ffffffff8105b8c8 ffff88007ca14480 ffffffff813ec6e3 ffff8800774881d0
 0000000000000000 ffff8800774881d0 ffff8800775ac000 ffff8800774888b0
 ffff8800775ab728 0000000000000000 ffff88007c3aab30 ffff8800774881d0
Call Trace:
 [<ffffffff8105b8c8>] ? wq_worker_sleeping+0x8/0x90
 [<ffffffff813ec6e3>] ? __schedule+0x343/0x750
 [<ffffffff813ecb1a>] ? schedule+0x2a/0x80
 [<ffffffff81048384>] ? do_exit+0x664/0xa80
 [<ffffffff81005bc7>] ? oops_end+0x67/0xa0
 [<ffffffff81002c8b>] ? do_error_trap+0x6b/0xd0
 [<ffffffff8112109f>] ? try_to_free_buffers+0xaf/0xc0
 [<ffffffff8106c690>] ? update_curr+0x50/0xb0
 [<ffffffff81216cbb>] ? radix_tree_insert+0x2b/0xe0
 [<ffffffff813f0a68>] ? invalid_op+0x18/0x20
 [<ffffffff8112109f>] ? try_to_free_buffers+0xaf/0xc0
 [<ffffffff81123bb8>] ? bdev_write_page+0x68/0xa0
 [<ffffffff8112a277>] ? __mpage_writepage+0x4f7/0x5f0
 [<ffffffff810e0234>] ? rmap_walk+0xe4/0x230
 [<ffffffff810e04e3>] ? page_mkclean+0x63/0x80
 [<ffffffff810df250>] ? page_referenced_one+0xb0/0xb0
 [<ffffffff8111903a>] ? inode_to_bdi+0x1a/0x60
 [<ffffffff810bf51c>] ? write_cache_pages+0x1cc/0x390
 [<ffffffff81129d80>] ? clean_buffers+0x60/0x60
 [<ffffffff811f4673>] ? blk_flush_plug_list+0xe3/0x260
 [<ffffffff8116d1f0>] ? ext2_get_blocks+0x990/0x990
 [<ffffffff81129ce3>] ? mpage_writepages+0x53/0x90
 [<ffffffff8116d1f0>] ? ext2_get_blocks+0x990/0x990
 [<ffffffff8111933a>] ? __writeback_single_inode+0x2a/0x180
 [<ffffffff811197ab>] ? writeback_sb_inodes+0x1ab/0x3f0
 [<ffffffff81119a7e>] ? __writeback_inodes_wb+0x8e/0xc0
 [<ffffffff81119c7b>] ? wb_writeback+0x1cb/0x1e0
 [<ffffffff8110c005>] ? get_nr_inodes+0x45/0x60
 [<ffffffff810bf98d>] ? global_dirty_limits+0xd/0xf0
 [<ffffffff8111a1f8>] ? bdi_writeback_workfn+0x158/0x340
 [<ffffffff8105ab44>] ? process_one_work+0x124/0x320
 [<ffffffff8105ae56>] ? worker_thread+0x116/0x460
 [<ffffffff8105ad40>] ? process_one_work+0x320/0x320
 [<ffffffff81060255>] ? kthread+0xc5/0xe0
 [<ffffffff81060190>] ? kthread_create_on_node+0x170/0x170
 [<ffffffff813efc12>] ? ret_from_fork+0x42/0x70
 [<ffffffff81060190>] ? kthread_create_on_node+0x170/0x170
Code: 00 00 00 00 65 48 8b 04 25 00 a9 00 00 48 8b 80 90 07 00 00 48 8b 40 c8 48 c1 e8 02 83 e0 01 c3 0f 1f 40 00 48 8b 87 90 07 00 00 <48> 8b 40 d8 c3 0f 1f 40 00 48 83 ec 18 48 8b b7 90 07 00 00 ba 
RIP  [<ffffffff81060747>] kthread_data+0x7/0x10
 RSP <ffff8800775ab680>
CR2: ffffffffffffffd8
---[ end trace bc092d5328429ae2 ]---
Fixing recursive fault but reboot is needed!

--------------040902040604040403060901--
