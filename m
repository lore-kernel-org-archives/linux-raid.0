From: Peter Maloney <peter.maloney@brockmann-consult.de>
Subject: 3.7-rc4 hang with mdadm raid10 near layout, with 4 disks, and an
 internal bitmap
Date: Tue, 13 Nov 2012 19:11:31 +0100
Message-ID: <50A28D53.2080409@brockmann-consult.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am using kernel 3.7-rc4. I have 2 LV on a 4 disk raid10 near layout
mdadm device which I am trying to copy to another LV on the same VG
using dd. The mdadm device has an internal bitmap. When I copy the first
LV, it goes smoothly, but with the 2nd it hangs before it is done.

I don't know if I can reproduce it, so I'll just leave it broken with a
bitmap until this is resolved, and work around by using files for what
I'm trying to do right now. It's my home desktop machine.

Should I start by installing 3.6.6 or 3.7.0-rc5?

When I created my raid, I was probably using kernel 3.1 or 3.4.4. When I
added the bitmap, it was probably 3.7-rc2.

# uname -a
Linux peter 3.7.0-rc4-1-default #7 SMP Sun Nov 4 23:11:57 CET 2012
x86_64 x86_64 x86_64 GNU/Linux

# mdadm -D /dev/md2
/dev/md2:
        Version : 1.2
  Creation Time : Sat Jul  7 10:16:20 2012
     Raid Level : raid10
     Array Size : 1292850176 (1232.96 GiB 1323.88 GB)
  Used Dev Size : 646425088 (616.48 GiB 661.94 GB)
   Raid Devices : 4
  Total Devices : 4
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Tue Nov 13 18:49:12 2012
          State : active
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : near=2
     Chunk Size : 512K

           Name : peter:2  (local to host peter)
           UUID : fa4434c7:96ebd0ca:87b3e34f:e4800a10
         Events : 47371

    Number   Major   Minor   RaidDevice State
       5       8        4        0      active sync   /dev/sda4
       1       8       20        1      active sync   /dev/sdb4
       2       8       52        2      active sync   /dev/sdd4
       4       8       36        3      active sync   /dev/sdc4

# cat /proc/mdstat
Personalities : [raid1] [raid10]
md2 : active raid10 sda4[5] sdc4[4] sdd4[2] sdb4[1]
      1292850176 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
      bitmap: 1/10 pages [4KB], 65536KB chunk

md0 : active raid1 sda1[0] sdc1[3] sdd1[2] sdb1[1]
      524224 blocks [4/4] [UUUU]
     
unused devices: <none>


Symptoms:

1 - iostat shows nothing but avgqu-sz and %util for the device.

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           2.76    0.00    1.00   12.43    0.00   83.81

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0.00     0.00    0.00    0.00     0.00     0.00    
0.00     0.00    0.00    0.00    0.00   0.00   0.00
sdb               0.00     0.00    0.00    0.00     0.00     0.00    
0.00     0.00    0.00    0.00    0.00   0.00   0.00
sdd               0.00     0.00    0.00    0.00     0.00     0.00    
0.00     0.00    0.00    0.00    0.00   0.00   0.00
sdc               0.00     0.00    0.00    0.00     0.00     0.00    
0.00     0.00    0.00    0.00    0.00   0.00   0.00
md0               0.00     0.00    0.00    0.00     0.00     0.00    
0.00     0.00    0.00    0.00    0.00   0.00   0.00
md2               0.00     0.00    0.00    0.00     0.00     0.00    
0.00     0.00    0.00    0.00    0.00   0.00   0.00
dm-0              0.00     0.00    0.00    0.00     0.00     0.00    
0.00     0.00    0.00    0.00    0.00   0.00   0.00
dm-1              0.00     0.00    0.00    0.00     0.00     0.00    
0.00   114.00    0.00    0.00    0.00   0.00 100.00
dm-2              0.00     0.00    0.00    0.00     0.00     0.00    
0.00     0.00    0.00    0.00    0.00   0.00   0.00
dm-3              0.00     0.00    0.00    0.00     0.00     0.00    
0.00     0.00    0.00    0.00    0.00   0.00   0.00
dm-4              0.00     0.00    0.00    0.00     0.00     0.00    
0.00     0.00    0.00    0.00    0.00   0.00   0.00
dm-5              0.00     0.00    0.00    0.00     0.00     0.00    
0.00     0.00    0.00    0.00    0.00   0.00   0.00
dm-6              0.00     0.00    0.00    0.00     0.00     0.00    
0.00     0.00    0.00    0.00    0.00   0.00   0.00
dm-7              0.00     0.00    0.00    0.00     0.00     0.00    
0.00     0.00    0.00    0.00    0.00   0.00   0.00

2 - "ls /backup/" works but "ls /backup/win8-32/" hangs. I haven't found
anything else that hangs.

3 - umount -f fails saying it is in use

4 - on normal shutdown, the system fails to stop the raid device,
eventually giving up


Here is output from alt+sysrq+w right after the hang happens.


Nov 13 18:43:23 peter kernel: EXT4-fs (dm-1): mounted filesystem with
ordered data mode. Opts: (null)
Nov 13 18:51:40 peter kernel: SysRq : Show Blocked State
Nov 13 18:51:40 peter kernel:   task                        PC stack  
pid father
Nov 13 18:51:40 peter kernel: flush-253:1     D ffffffff81823c60     0 
4162      2 0x00000000
Nov 13 18:51:40 peter kernel:  ffff8803cc12d008 0000000000000046
ffff880428118c00 ffff880422a3b5c0
Nov 13 18:51:40 peter kernel:  ffff8803cc12dfd8 ffff8803cc12dfd8
ffff8803cc12dfd8 00000000000141c0
Nov 13 18:51:40 peter kernel:  ffff88042e156480 ffff8803c5f9a7c0
ffff8803cc12d018 ffff880428118e80
Nov 13 18:51:40 peter kernel: Call Trace:
Nov 13 18:51:40 peter kernel:  [<ffffffff815fcd84>] schedule+0x24/0x70
Nov 13 18:51:40 peter kernel:  [<ffffffff814ac09d>] md_super_wait+0x4d/0x80
Nov 13 18:51:40 peter kernel:  [<ffffffff810c3040>] ?
add_wait_queue+0x60/0x60
Nov 13 18:51:40 peter kernel:  [<ffffffff814b2468>]
bitmap_unplug.part.22+0x158/0x160
Nov 13 18:51:40 peter kernel:  [<ffffffff811af427>] ? __kmalloc+0x1e7/0x230
Nov 13 18:51:40 peter kernel:  [<ffffffff814b248d>] bitmap_unplug+0x1d/0x20
Nov 13 18:51:40 peter kernel:  [<ffffffffa057ea50>]
raid10_unplug+0xa0/0x120 [raid10]
Nov 13 18:51:40 peter kernel:  [<ffffffff8130be85>]
blk_flush_plug_list+0xb5/0x230
Nov 13 18:51:40 peter kernel:  [<ffffffff815fce43>] io_schedule+0x73/0xd0
Nov 13 18:51:40 peter kernel:  [<ffffffff8130b011>] get_request+0x141/0x320
Nov 13 18:51:40 peter kernel:  [<ffffffff810c3040>] ?
add_wait_queue+0x60/0x60
Nov 13 18:51:40 peter kernel:  [<ffffffff8130c0cf>] blk_queue_bio+0x7f/0x3a0
Nov 13 18:51:40 peter kernel:  [<ffffffff81308b2f>]
generic_make_request.part.55+0x6f/0xa0
Nov 13 18:51:40 peter kernel:  [<ffffffff81309080>]
generic_make_request+0x60/0x70
Nov 13 18:51:40 peter kernel:  [<ffffffff813090f7>] submit_bio+0x67/0x130
Nov 13 18:51:40 peter kernel:  [<ffffffff811ea37d>] submit_bh+0xed/0x120
Nov 13 18:51:40 peter kernel:  [<ffffffff8124c50a>]
ext4_read_block_bitmap_nowait+0x18a/0x2e0
Nov 13 18:51:40 peter kernel:  [<ffffffff81285e0f>]
ext4_mb_init_cache+0x14f/0x730
Nov 13 18:51:40 peter kernel:  [<ffffffff8128648e>]
ext4_mb_init_group+0x9e/0x100
Nov 13 18:51:40 peter kernel:  [<ffffffff81286989>]
ext4_mb_load_buddy+0x339/0x350
Nov 13 18:51:40 peter kernel:  [<ffffffff81287efb>]
ext4_mb_find_by_goal+0x9b/0x2d0
Nov 13 18:51:40 peter kernel:  [<ffffffff81288899>]
ext4_mb_regular_allocator+0x59/0x420
Nov 13 18:51:40 peter kernel:  [<ffffffffa042694f>] ?
_dm_request.isra.24+0xff/0x150 [dm_mod]
Nov 13 18:51:40 peter kernel:  [<ffffffff811eb5d7>] ?
__find_get_block+0x87/0xe0
Nov 13 18:51:40 peter kernel:  [<ffffffff8128a54d>]
ext4_mb_new_blocks+0x40d/0x4a0
Nov 13 18:51:40 peter kernel:  [<ffffffff8127bf14>] ?
ext4_ext_check_overlap.isra.22+0xb4/0xd0
Nov 13 18:51:40 peter kernel:  [<ffffffff8128130d>]
ext4_ext_map_blocks+0x96d/0xba0
Nov 13 18:51:40 peter kernel:  [<ffffffff81255743>] ?
mpage_da_submit_io+0x313/0x590
Nov 13 18:51:40 peter kernel:  [<ffffffff81253585>]
ext4_map_blocks+0x1f5/0x2c0
Nov 13 18:51:40 peter kernel:  [<ffffffff812576ea>]
mpage_da_map_and_submit+0xba/0x390
Nov 13 18:51:40 peter kernel:  [<ffffffff811654db>] ?
find_get_pages_tag+0xcb/0x170
Nov 13 18:51:40 peter kernel:  [<ffffffff81257a25>]
mpage_add_bh_to_extent+0x65/0xf0
Nov 13 18:51:40 peter kernel:  [<ffffffff81257dc0>]
write_cache_pages_da+0x310/0x450
Nov 13 18:51:40 peter kernel:  [<ffffffff81258248>]
ext4_da_writepages+0x348/0x620
Nov 13 18:51:40 peter kernel:  [<ffffffff8105d58a>] ?
__switch_to+0x12a/0x4a0
Nov 13 18:51:40 peter kernel:  [<ffffffff811706bb>] do_writepages+0x1b/0x30
Nov 13 18:51:40 peter kernel:  [<ffffffff811e135a>]
__writeback_single_inode+0x3a/0x170
Nov 13 18:51:40 peter kernel:  [<ffffffff811e35f8>]
writeback_sb_inodes+0x198/0x330
Nov 13 18:51:40 peter kernel:  [<ffffffff811e3826>]
__writeback_inodes_wb+0x96/0xc0
Nov 13 18:51:40 peter kernel:  [<ffffffff811e3acb>] wb_writeback+0x27b/0x330
Nov 13 18:51:40 peter kernel:  [<ffffffff8105d58a>] ?
__switch_to+0x12a/0x4a0
Nov 13 18:51:40 peter kernel:  [<ffffffff811d4d02>] ?
get_nr_dirty_inodes+0x52/0x80
Nov 13 18:51:40 peter kernel:  [<ffffffff811e3c17>]
wb_check_old_data_flush+0x97/0xa0
Nov 13 18:51:40 peter kernel:  [<ffffffff811e50e9>]
wb_do_writeback+0x149/0x1d0
Nov 13 18:51:40 peter kernel:  [<ffffffff810aeff0>] ? usleep_range+0x40/0x40
Nov 13 18:51:40 peter kernel:  [<ffffffff811e51f3>]
bdi_writeback_thread+0x83/0x280
Nov 13 18:51:40 peter kernel:  [<ffffffff811e5170>] ?
wb_do_writeback+0x1d0/0x1d0
Nov 13 18:51:40 peter kernel:  [<ffffffff810c24bb>] kthread+0xbb/0xc0
Nov 13 18:51:40 peter kernel:  [<ffffffff81050000>] ?
xen_extend_mmuext_op+0x60/0x120
Nov 13 18:51:40 peter kernel:  [<ffffffff810c2400>] ?
flush_kthread_worker+0xa0/0xa0
Nov 13 18:51:40 peter kernel:  [<ffffffff81605f7c>] ret_from_fork+0x7c/0xb0
Nov 13 18:51:40 peter kernel:  [<ffffffff810c2400>] ?
flush_kthread_worker+0xa0/0xa0
Nov 13 18:51:40 peter kernel: jbd2/dm-1-8     D 0000000000000000     0 
4229      2 0x00000000
Nov 13 18:51:40 peter kernel:  ffff8803c359bcb8 0000000000000046
ffff8803c0f9c000 0000000300000001
Nov 13 18:51:40 peter kernel:  ffff8803c359bfd8 ffff8803c359bfd8
ffff8803c359bfd8 00000000000141c0
Nov 13 18:51:40 peter kernel:  ffff8803ddff8680 ffff88042ac303c0
ffff8803c359bcc8 ffff8803c359bdc0
Nov 13 18:51:40 peter kernel: Call Trace:
Nov 13 18:51:40 peter kernel:  [<ffffffff815fcd84>] schedule+0x24/0x70
Nov 13 18:51:40 peter kernel:  [<ffffffff812a0879>]
jbd2_journal_commit_transaction+0x1b9/0x1360
Nov 13 18:51:40 peter kernel:  [<ffffffff810d98cc>] ?
dequeue_entity+0x10c/0x1f0
Nov 13 18:51:40 peter kernel:  [<ffffffff810c3040>] ?
add_wait_queue+0x60/0x60
Nov 13 18:51:40 peter kernel:  [<ffffffff812a5893>] kjournald2+0xb3/0x240
Nov 13 18:51:40 peter kernel:  [<ffffffff810c3040>] ?
add_wait_queue+0x60/0x60
Nov 13 18:51:40 peter kernel:  [<ffffffff812a57e0>] ?
commit_timeout+0x10/0x10
Nov 13 18:51:40 peter kernel:  [<ffffffff810c24bb>] kthread+0xbb/0xc0
Nov 13 18:51:40 peter kernel:  [<ffffffff81050000>] ?
xen_extend_mmuext_op+0x60/0x120
Nov 13 18:51:40 peter kernel:  [<ffffffff810c2400>] ?
flush_kthread_worker+0xa0/0xa0
Nov 13 18:51:40 peter kernel:  [<ffffffff81605f7c>] ret_from_fork+0x7c/0xb0
Nov 13 18:51:40 peter kernel:  [<ffffffff810c2400>] ?
flush_kthread_worker+0xa0/0xa0
Nov 13 18:51:40 peter kernel: tee             D 0000000000000000     0 
4244   4235 0x00000000
Nov 13 18:51:40 peter kernel:  ffff8803853a79e8 0000000000000082
ffff8803b5352cd8 ffff8803c5079870
Nov 13 18:51:40 peter kernel:  ffff8803853a7fd8 ffff8803853a7fd8
ffff8803853a7fd8 00000000000141c0
Nov 13 18:51:40 peter kernel:  ffff8803a3194740 ffff8803853a4700
ffff8803853a79f8 ffff8803c0f9c000
Nov 13 18:51:40 peter kernel: Call Trace:
Nov 13 18:51:40 peter kernel:  [<ffffffff815fcd84>] schedule+0x24/0x70
Nov 13 18:51:40 peter kernel:  [<ffffffff8129dffa>]
start_this_handle.isra.8+0x2aa/0x3b0
Nov 13 18:51:40 peter kernel:  [<ffffffff810c3040>] ?
add_wait_queue+0x60/0x60
Nov 13 18:51:40 peter kernel:  [<ffffffff8129e2f2>]
jbd2__journal_start+0xc2/0x110
Nov 13 18:51:40 peter kernel:  [<ffffffff8129e34e>]
jbd2_journal_start+0xe/0x10
Nov 13 18:51:40 peter kernel:  [<ffffffff81273edf>]
ext4_journal_start_sb+0x6f/0x150
Nov 13 18:51:40 peter kernel:  [<ffffffff81255137>] ?
ext4_da_write_begin+0x77/0x210
Nov 13 18:51:40 peter kernel:  [<ffffffff81255137>]
ext4_da_write_begin+0x77/0x210
Nov 13 18:51:40 peter kernel:  [<ffffffff81164d4a>]
generic_perform_write+0xca/0x210
Nov 13 18:51:40 peter kernel:  [<ffffffff811d7cfd>] ?
mnt_clone_write+0xd/0x30
Nov 13 18:51:40 peter kernel:  [<ffffffff81164ee8>]
generic_file_buffered_write+0x58/0x90
Nov 13 18:51:40 peter kernel:  [<ffffffff811668e6>]
__generic_file_aio_write+0x1b6/0x3b0
Nov 13 18:51:40 peter kernel:  [<ffffffff81166b5a>]
generic_file_aio_write+0x7a/0xf0
Nov 13 18:51:40 peter kernel:  [<ffffffff8124df0b>]
ext4_file_write+0x8b/0xd0
Nov 13 18:51:40 peter kernel:  [<ffffffff811bb493>] do_sync_write+0xa3/0xe0
Nov 13 18:51:40 peter kernel:  [<ffffffff811bbb0e>] vfs_write+0xae/0x180
Nov 13 18:51:40 peter kernel:  [<ffffffff811bbe2d>] sys_write+0x4d/0x90
Nov 13 18:51:40 peter kernel:  [<ffffffff81606029>]
system_call_fastpath+0x16/0x1b


