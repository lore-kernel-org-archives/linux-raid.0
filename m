From: maarten van den Berg <maarten@ultratux.net>
Subject: Kernel panic, FS corruption  Was: Re: Call for RAID-6 users
Date: Sun, 1 Aug 2004 15:03:20 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408011503.20452.maarten@ultratux.net>
References: <cds76e$ee7$1@terminus.zytor.com> <200407302338.33823.maarten@ultratux.net> <200407310228.27969.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200407310228.27969.maarten@ultratux.net>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday 31 July 2004 02:28, maarten van den Berg wrote:
> On Friday 30 July 2004 23:38, maarten van den Berg wrote:
> > On Friday 30 July 2004 23:11, maarten van den Berg wrote:
> > > On Saturday 24 July 2004 01:32, H. Peter Anvin wrote:


I eventually got a kernel panic when copying large amounts of data to a 
[degraded] raid6 array, which this time was the full 600 GB size.
Don't know if it is helpful to anyone but info below:

Message from syslogd@agent2 at Sun Aug  1 08:59:28 2004 ...
agent2 kernel: REISERFS: panic (device Null superblock): vs-6025: 
check_internal_block_head: invalid level level=58989, nr_items=6145, 
free_space=39964 rdkey
 
Umount didn't work, neither did shutdown. After reset I have FS corruption, 
according to reiserfsck:

agent2:~ # cat /proc/mdstat
Personalities : [raid1] [raid6]
md1 : active raid6 hdg3[3] hde3[2] hda3[0] sda3[4] sdb3[5]
      618437888 blocks level 6, 64k chunk, algorithm 2 [6/5] [U_UUUU]

md0 : active raid1 sdb1[2] sda1[3] hda1[0] hde1[1] hdg1[4]
      1574272 blocks [3/3] [UUU]

unused devices: <none>
agent2:~ # reiserfsck /dev/md1
reiserfsck 3.6.13 (2003 www.namesys.com)

*************************************************************
** If you are using the latest reiserfsprogs and  it fails **
** please  email bug reports to reiserfs-list@namesys.com, **
** providing  as  much  information  as  possible --  your **
** hardware,  kernel,  patches,  settings,  all reiserfsck **
** messages  (including version),  the reiserfsck logfile, **
** check  the  syslog file  for  any  related information. **
** If you would like advice on using this program, support **
** is available  for $25 at  www.namesys.com/support.html. **
*************************************************************

Will read-only check consistency of the filesystem on /dev/md1
Will put log info to 'stdout'

Do you want to run this program?[N/Yes] (note need to type Yes if you do):Yes
###########
reiserfsck --check started at Sun Aug  1 14:45:08 2004
###########
Replaying journal..
Trans replayed: mountid 10, transid 2171, desc 5755, len 30, commit 5786, next 
trans offset 5769
Trans replayed: mountid 10, transid 2172, desc 5787, len 14, commit 5802, next 
trans offset 5785
Trans replayed: mountid 10, transid 2173, desc 5803, len 23, commit 5827, next 
trans offset 5810
Trans replayed: mountid 10, transid 2174, desc 5828, len 27, commit 5856, next 
trans offset 5839
Trans replayed: mountid 10, transid 2175, desc 5857, len 25, commit 5883, next 
trans offset 5866
Trans replayed: mountid 10, transid 2176, desc 5884, len 27, commit 5912, next 
trans offset 5895
Trans replayed: mountid 10, transid 2177, desc 5913, len 26, commit 5940, next 
trans offset 5923
Trans replayed: mountid 10, transid 2178, desc 5941, len 24, commit 5966, next 
trans offset 5949
Reiserfs journal '/dev/md1' in blocks [18..8211]: 8 transactions replayed
Checking internal tree../  1 (of   2)/  3 (of 128)/ 12 (of 170)block 67043329: 
The level of the node (65534) is not correct, (1) expected
 the problem in the internal node occured (67043329), whole subtree is skipped
/ 14 (of 128)/105 (of 133)block 139100161: The level of the node (65534) is 
not correct, (1) expected
 the problem in the internal node occured (139100161), whole subtree is 
skipped
/ 15 (of 128)/ 23 (of 170)block 5701633: The level of the node (44292) is not 
correct, (1) expected
 the problem in the internal node occured (5701633), whole subtree is skipped
/ 16 (of 128)/ 80 (of 170)block 109215745: The level of the node (65534) is 
not correct, (1) expected

[snip much more of the same...]

 the problem in the internal node occured (4718593), whole subtree is skipped
/120 (of 133)/ 47 (of 170)block 59801637: The level of the node (65534) is not 
correct, (1) expected
 the problem in the internal node occured (59801637), whole subtree is skipped
/123 (of 133)/ 72 (of 169)block 126386304: The level of the node (4828) is not 
correct, (1) expected
 the problem in the internal node occured (126386304), whole subtree is 
skipped
/124 (of 133)block 126386316: The level of the node (58989) is not correct, 
(2) expected
 the problem in the internal node occured (126386316), whole subtree is 
skipped
finished
Comparing bitmaps..vpf-10640: The on-disk and the correct bitmaps differs.
Bad nodes were found, Semantic pass skipped
92 found corruptions can be fixed only when running with --rebuild-tree
###########
reiserfsck finished at Sun Aug  1 14:47:17 2004
###########


Hours before the kernel panic, during a copy, I see tons of this in syslog:

Aug  1 04:15:54 agent2 kernel: ReiserFS: warning: is_tree_node: node level 
65534 does not match to the expected o
ne 1
Aug  1 04:15:54 agent2 kernel: ReiserFS: md1: warning: vs-5150: search_by_key: 
invalid format found in block 6704
3329. Fsck?
Aug  1 04:15:54 agent2 kernel: ReiserFS: md1: warning: vs-13070: 
reiserfs_read_locked_inode: i/o failure occurred
 trying to find stat data of [130 132 0x0 SD]
Aug  1 04:15:54 agent2 kernel: ReiserFS: warning: is_tree_node: node level 
65534 does not match to the expected o
ne 1
Aug  1 04:15:54 agent2 kernel: ReiserFS: md1: warning: vs-5150: search_by_key: 
invalid format found in block 6704
3329. Fsck?
Aug  1 04:15:54 agent2 kernel: ReiserFS: md1: warning: vs-13070: 
reiserfs_read_locked_inode: i/o failure occurred
 trying to find stat data of [130 132 0x0 SD]
Aug  1 04:15:54 agent2 kernel: ReiserFS: warning: is_tree_node: node level 
65534 does not match to the expected o
ne 1
Aug  1 04:15:54 agent2 kernel: ReiserFS: md1: warning: vs-5150: search_by_key: 
invalid format found in block 6704
3329. Fsck?
Aug  1 04:15:54 agent2 kernel: ReiserFS: md1: warning: vs-13070: 
reiserfs_read_locked_inode: i/o failure occurred
 trying to find stat data of [130 132 0x0 SD]
Aug  1 04:15:54 agent2 kernel: ReiserFS: warning: is_tree_node: node level 
65534 does not match to the expected o
ne 1
Aug  1 04:15:54 agent2 kernel: ReiserFS: md1: warning: vs-5150: search_by_key: 
invalid format found in block 6704
3329. Fsck?
Aug  1 04:15:54 agent2 kernel: ReiserFS: md1: warning: vs-13070: 
reiserfs_read_locked_inode: i/o failure occurred
 trying to find stat data of [130 132 0x0 SD]

This lasted about a minute -last entry dated Aug  1 04:16:46- but logged 
thousands of lines during that.  Then syslog is quiet again until the kernel 
panic occurs:

Aug  1 08:49:55 agent2 -- MARK --
Aug  1 08:59:00 agent2 /USR/SBIN/CRON[8553]: (root) CMD ( rm -f /var/spool/
cron/lastrun/cron.hourly)
Aug  1 08:59:28 agent2 kernel: REISERFS: panic (device Null superblock): 
vs-6025: check_internal_block_head: inva
lid level level=58989, nr_items=6145, free_space=39964 rdkey
Aug  1 08:59:28 agent2 kernel: ------------[ cut here ]------------
Aug  1 08:59:28 agent2 kernel: kernel BUG at fs/reiserfs/prints.c:362!
Aug  1 08:59:28 agent2 kernel: invalid operand: 0000 [#1]
Aug  1 08:59:28 agent2 kernel: CPU:    0
Aug  1 08:59:28 agent2 kernel: EIP:    0060:[__crc_ide_end_request
+942296/1608427]    Not tainted
Aug  1 08:59:28 agent2 kernel: EIP:    0060:[<d48ad7c1>]    Not tainted
Aug  1 08:59:28 agent2 kernel: EFLAGS: 00010286   (2.6.5-7.95-default)
Aug  1 08:59:28 agent2 kernel: EIP is at reiserfs_panic+0x31/0x60 [reiserfs]
Aug  1 08:59:28 agent2 kernel: eax: 00000093   ebx: 00000000   ecx: 00000002   
edx: d2181f38
Aug  1 08:59:28 agent2 kernel: esi: d255b000   edi: ccd43d48   ebp: 0000002a   
esp: c3415898
Aug  1 08:59:28 agent2 kernel: ds: 007b   es: 007b   ss: 0068
Aug  1 08:59:28 agent2 kernel: Process cp (pid: 8456, threadinfo=c3414000 
task=d18f4700)
Aug  1 08:59:29 agent2 kernel: Stack: d48c5a0c d48c34fe d48d1520 000003f0 
d48ad85a 00000000 d48c5a54 ccd43d48
Aug  1 08:59:29 agent2 kernel:        000003f0 c3415924 d255b2a8 d48b161e 
d255b000 c4cb9800 00000000 000017d8
Aug  1 08:59:29 agent2 kernel:        ccd43d48 d0a7fa3c 00000000 00000001 
c3415914 c3415924 d0a7fa3c 00000001
Aug  1 08:59:29 agent2 kernel: Call Trace:
Aug  1 08:59:29 agent2 kernel:  [__crc_ide_end_request+942449/1608427] 
check_internal+0x6a/0x80 [reiserfs]
Aug  1 08:59:29 agent2 kernel:  [<d48ad85a>] check_internal+0x6a/0x80 
[reiserfs]
Aug  1 08:59:29 agent2 kernel:  [__crc_ide_end_request+958261/1608427] 
internal_move_pointers_items+0x1be/0x2c0 [
reiserfs]
Aug  1 08:59:29 agent2 kernel:  [<d48b161e>] internal_move_pointers_items
+0x1be/0x2c0 [reiserfs]
Aug  1 08:59:29 agent2 kernel:  [__crc_ide_end_request+958904/1608427] 
internal_shift_right+0xb1/0xd0 [reiserfs]
Aug  1 08:59:29 agent2 kernel:  [<d48b18a1>] internal_shift_right+0xb1/0xd0 
[reiserfs]
Aug  1 08:59:29 agent2 kernel:  [__crc_ide_end_request+959947/1608427] 
balance_internal+0x174/0xae0 [reiserfs]
Aug  1 08:59:29 agent2 kernel:  [<d48b1cb4>] balance_internal+0x174/0xae0 
[reiserfs]
Aug  1 08:59:29 agent2 kernel:  [__crc_ide_end_request+424174/1608427] 
ata_qc_issue+0xf7/0x2a0 [libata]
Aug  1 08:59:29 agent2 kernel:  [<d482efd7>] ata_qc_issue+0xf7/0x2a0 [libata]
Aug  1 08:59:29 agent2 kernel:  [__crc_ide_end_request+985323/1608427] 
get_cnode+0x14/0x70 [reiserfs]
Aug  1 08:59:29 agent2 kernel:  [<d48b7fd4>] get_cnode+0x14/0x70 [reiserfs]
Aug  1 08:59:29 agent2 kernel:  [__crc_ide_end_request+991353/1608427] 
journal_mark_dirty+0x102/0x230 [reiserfs]
Aug  1 08:59:29 agent2 kernel:  [<d48b9762>] journal_mark_dirty+0x102/0x230 
[reiserfs]
Aug  1 08:59:29 agent2 kernel:  [__crc_ide_end_request+950897/1608427] 
leaf_delete_items_entirely+0x15a/0x200 [re
iserfs]
Aug  1 08:59:29 agent2 kernel:  [<d48af95a>] leaf_delete_items_entirely
+0x15a/0x200 [reiserfs]
Aug  1 08:59:29 agent2 kernel:  [__crc_ide_end_request+950259/1608427] 
leaf_paste_in_buffer+0x1fc/0x320 [reiserfs]
Aug  1 08:59:29 agent2 kernel:  [<d48af6dc>] leaf_paste_in_buffer+0x1fc/0x320 
[reiserfs]
Aug  1 08:59:29 agent2 kernel:  [__crc_ide_end_request+859729/1608427] 
do_balance+0x78a/0x3160 [reiserfs]
Aug  1 08:59:29 agent2 kernel:  [<d489953a>] do_balance+0x78a/0x3160 
[reiserfs]
Aug  1 08:59:29 agent2 kernel:  [autoremove_wake_function+0/48] 
autoremove_wake_function+0x0/0x30
Aug  1 08:59:29 agent2 kernel:  [<c011f1c0>] autoremove_wake_function+0x0/0x30
Aug  1 08:59:29 agent2 kernel:  [submit_bh+393/544] submit_bh+0x189/0x220
Aug  1 08:59:29 agent2 kernel:  [<c0159f49>] submit_bh+0x189/0x220
Aug  1 08:59:29 agent2 kernel:  [__bread+81/160] __bread+0x51/0xa0
Aug  1 08:59:29 agent2 kernel:  [<c015d221>] __bread+0x51/0xa0
Aug  1 08:59:29 agent2 kernel:  [__crc_ide_end_request+921709/1608427] 
get_neighbors+0xe6/0x140 [reiserfs]
Aug  1 08:59:29 agent2 kernel:  [<d48a8756>] get_neighbors+0xe6/0x140 
[reiserfs]
Aug  1 08:59:29 agent2 kernel:  [__crc_ide_end_request+921750/1608427] 
get_neighbors+0x10f/0x140 [reiserfs]
Aug  1 08:59:29 agent2 kernel:  [<d48a877f>] get_neighbors+0x10f/0x140 
[reiserfs]
Aug  1 08:59:29 agent2 kernel:  [wake_up_buffer+5/32] wake_up_buffer+0x5/0x20
Aug  1 08:59:29 agent2 kernel:  [<c015b2d5>] wake_up_buffer+0x5/0x20
Aug  1 08:59:29 agent2 kernel:  [__crc_ide_end_request+986558/1608427] 
reiserfs_prepare_for_journal+0x47/0x70 [re
iserfs]
Aug  1 08:59:29 agent2 kernel:  [<d48b84a7>] reiserfs_prepare_for_journal
+0x47/0x70 [reiserfs]
Aug  1 08:59:29 agent2 kernel:  [__crc_ide_end_request+924363/1608427] 
fix_nodes+0x884/0x1ba0 [reiserfs]
Aug  1 08:59:29 agent2 kernel:  [<d48a91b4>] fix_nodes+0x884/0x1ba0 [reiserfs]
Aug  1 08:59:29 agent2 kernel:  [__crc_ide_end_request+975120/1608427] 
reiserfs_paste_into_item+0x1d9/0x220 [reis
erfs]
Aug  1 08:59:29 agent2 kernel:  [<d48b57f9>] reiserfs_paste_into_item
+0x1d9/0x220 [reiserfs]
Aug  1 08:59:29 agent2 kernel:  [__crc_ide_end_request+874042/1608427] 
reiserfs_add_entry+0x293/0x430 [reiserfs]
Aug  1 08:59:29 agent2 kernel:  [<d489cd23>] reiserfs_add_entry+0x293/0x430 
[reiserfs]
Aug  1 08:59:29 agent2 kernel:  [__crc_ide_end_request+878853/1608427] 
reiserfs_create+0x11e/0x1e0 [reiserfs]
Aug  1 08:59:29 agent2 kernel:  [<d489dfee>] reiserfs_create+0x11e/0x1e0 
[reiserfs]
Aug  1 08:59:29 agent2 kernel:  [__crc_ide_end_request+1016040/1608427] 
reiserfs_permission+0x1/0x10 [reiserfs]
Aug  1 08:59:29 agent2 kernel:  [<d48bf7d1>] reiserfs_permission+0x1/0x10 
[reiserfs]
Aug  1 08:59:29 agent2 kernel:  [__crc_ide_end_request+1016046/1608427] 
reiserfs_permission+0x7/0x10 [reiserfs]
Aug  1 08:59:29 agent2 kernel:  [<d48bf7d7>] reiserfs_permission+0x7/0x10 
[reiserfs]
Aug  1 08:59:29 agent2 kernel:  [vfs_create+153/304] vfs_create+0x99/0x130
Aug  1 08:59:29 agent2 kernel:  [<c01656f9>] vfs_create+0x99/0x130
Aug  1 08:59:29 agent2 kernel:  [open_namei+830/1072] open_namei+0x33e/0x430
Aug  1 08:59:29 agent2 kernel:  [<c016772e>] open_namei+0x33e/0x430
Aug  1 08:59:29 agent2 kernel:  [filp_open+78/128] filp_open+0x4e/0x80
Aug  1 08:59:29 agent2 kernel:  [<c0155b8e>] filp_open+0x4e/0x80
Aug  1 08:59:29 agent2 kernel:  [sys_open+131/208] sys_open+0x83/0xd0
Aug  1 08:59:29 agent2 kernel:  [<c0155c43>] sys_open+0x83/0xd0
Aug  1 08:59:29 agent2 kernel:  [sysenter_past_esp+82/121] sysenter_past_esp
+0x52/0x79
Aug  1 08:59:29 agent2 kernel:  [<c0107dc9>] sysenter_past_esp+0x52/0x79
Aug  1 08:59:29 agent2 kernel:
Aug  1 08:59:29 agent2 kernel: Code: 0f 0b 6a 01 0e 35 8c d4 b8 fe 34 8c d4 83 
c4 0c 85 db 74 06
Aug  1 09:09:55 agent2 -- MARK --
Aug  1 09:29:55 agent2 -- MARK --


Maarten


-- 
When I answered where I wanted to go today, they just hung up -- Unknown

