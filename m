From: "fibreraid@gmail.com" <fibreraid@gmail.com>
Subject: md 3.2.1 and xfs kernel panic on Linux 2.6.38
Date: Sun, 12 Jun 2011 11:50:01 -0700
Message-ID: <BANLkTimCyX=fBuXfuYx30X7M-ninCULq4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>, linux-xfs@vger.kernel.org
Cc: fibre raid <fibreraid@gmail.com>
List-Id: linux-raid.ids

Hi All,

I am benchmarking md RAID with XFS on a server running Linux 2.6.38
kernel. The server has 24 x HDD's, dual 2.4GHz 6-core CPUs, and 24GB
RAM.

I created an md0 array using RAID 5, 64k chunk, 23 active drives, and
1 hot-spare. I then created a LVM2 volume group from this md0, and
created an LV out of it. The volume was formatted XFS as follows:

/sbin/mkfs.xfs =96f =96l lazy-count=3D1 -l size=3D128m -s size=3D4096
/dev/mapper/pool1-vol1

I then mounted it as follows:

/dev/mapper/pool1-vol1 on /volumes/pool1/vol1 type xfs
(rw,_netdev,noatime,nodiratime,osyncisdsync,nobarrier,logbufs=3D8,delay=
log)

Once md synchronization was complete, I removed one of the active 23
drives. After attempting some IO, the md0 array began to rebuild to
the hot-spare. In a few hours, it was complete and the md0 array was
listed as active and healthy again (though now lacking a hot-spare
obviously).

As a test, I removed one more drive to see what would happen. As
expected, mdadm reported the array as active but degraded, and since
there was no hot-spare available, there was no rebuilding happening.

root@TESTBA16:~# mdadm -D /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Sat Jun 11 19:06:46 2011
     Raid Level : raid5
     Array Size : 8595566848 (8197.37 GiB 8801.86 GB)
  Used Dev Size : 390707584 (372.61 GiB 400.08 GB)
   Raid Devices : 23
  Total Devices : 24
    Persistence : Superblock is persistent

    Update Time : Sat Jun 11 23:30:14 2011
          State : active, degraded
 Active Devices : 22
Working Devices : 22
 Failed Devices : 2
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           Name : 00259009BA16:md0  (local to host 00259009BA16)
           UUID : fca4c639:41713d3f:20fa02e3:89b64c95
         Events : 36

    Number   Major   Minor   RaidDevice State
       0      65       81        0      active sync   /dev/sdv1
       1      65       97        1      active sync   /dev/sdw1
       2      65      113        2      active sync   /dev/sdx1
       3      65      129        3      active sync   /dev/sdy1
       4      65       17        4      active sync   /dev/sdr1
       5      65       33        5      active sync   /dev/sds1
       6      65       49        6      active sync   /dev/sdt1
       7      65       65        7      active sync   /dev/sdu1
       8       8      145        8      active sync   /dev/sdj1
       9       8      161        9      active sync   /dev/sdk1
      10       8      177       10      active sync   /dev/sdl1
      11       8      193       11      active sync   /dev/sdm1
      12       8      225       12      active sync   /dev/sdo1
      13       8      241       13      active sync   /dev/sdp1
      14      65        1       14      active sync   /dev/sdq1
      23       8       81       15      faulty spare rebuilding
      16       8       17       16      active sync   /dev/sdb1
      17       8       33       17      active sync   /dev/sdc1
      18       8       49       18      active sync   /dev/sdd1
      19       8       65       19      active sync   /dev/sde1
      20       8       97       20      active sync   /dev/sdg1
      21       8      113       21      active sync   /dev/sdh1
      22       8      129       22      active sync   /dev/sdi1

      15       8      209        -      faulty spare



What surprised me though is that I was no longer able to run IO on the
md0 device. As a test, I am using fio to generate IO to the XFS
mountpoint /volumes/pool1/vol1. However, IO failed. A few minutes
later, I received the following kernel dumps in /var/log/messages. Any
ideas?



Jun 12 11:33:54 TESTBA16 kernel: [59435.936575] fio             D
ffff88060c6e1a50     0 30463      1 0x00000000
Jun 12 11:33:54 TESTBA16 kernel: [59435.936578]  ffff880609887778
0000000000000086 0000000000000001 0000000000000086
Jun 12 11:33:54 TESTBA16 kernel: [59435.936581]  0000000000011e40
ffff88060c6e16c0 ffff88060c6e1a50 ffff880609887fd8
Jun 12 11:33:54 TESTBA16 kernel: [59435.936583]  ffff88060c6e1a58
0000000000011e40 ffff880609886010 0000000000011e40
Jun 12 11:33:54 TESTBA16 kernel: [59435.936586] Call Trace:
Jun 12 11:33:54 TESTBA16 kernel: [59435.936594]  [<ffffffffa025e698>]
make_request+0x138/0x3d0 [raid456]
Jun 12 11:33:54 TESTBA16 kernel: [59435.936602]  [<ffffffff81074d50>]
? autoremove_wake_function+0x0/0x40
Jun 12 11:33:54 TESTBA16 kernel: [59435.936607]  [<ffffffff813da9b5>]
md_make_request+0xd5/0x210
Jun 12 11:33:54 TESTBA16 kernel: [59435.936610]  [<ffffffff813eab1f>]
? _dm_request+0x10f/0x160
Jun 12 11:33:54 TESTBA16 kernel: [59435.936615]  [<ffffffff812760b8>]
generic_make_request+0x218/0x5c0
Jun 12 11:33:54 TESTBA16 kernel: [59435.936617]  [<ffffffff813ea13b>]
? dm_get_live_table+0x4b/0x60
Jun 12 11:33:54 TESTBA16 kernel: [59435.936620]  [<ffffffff813ed3d2>]
? linear_merge+0x52/0x60
Jun 12 11:33:54 TESTBA16 kernel: [59435.936622]  [<ffffffff813ea7e1>]
? dm_merge_bvec+0xc1/0x140
Jun 12 11:33:54 TESTBA16 kernel: [59435.936624]  [<ffffffff812764e6>]
submit_bio+0x86/0x110
Jun 12 11:33:54 TESTBA16 kernel: [59435.936629]  [<ffffffff8118355c>]
dio_bio_submit+0xbc/0xc0
Jun 12 11:33:54 TESTBA16 kernel: [59435.936631]  [<ffffffff811835f5>]
dio_send_cur_page+0x95/0xc0
Jun 12 11:33:54 TESTBA16 kernel: [59435.936633]  [<ffffffff81183685>]
submit_page_section+0x65/0x170
Jun 12 11:33:54 TESTBA16 kernel: [59435.936635]  [<ffffffff81183bb5>]
do_direct_IO+0x375/0x430
Jun 12 11:33:54 TESTBA16 kernel: [59435.936637]  [<ffffffff81183ff4>]
direct_io_worker+0x1c4/0x390
Jun 12 11:33:54 TESTBA16 kernel: [59435.936639]  [<ffffffff8118442d>]
__blockdev_direct_IO+0x26d/0x2d0
Jun 12 11:33:54 TESTBA16 kernel: [59435.936672]  [<ffffffffa0589a80>]
? xfs_get_blocks_direct+0x0/0x20 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.936675]  [<ffffffff81047893>]
? perf_event_task_sched_out+0x33/0x80
Jun 12 11:33:54 TESTBA16 kernel: [59435.936690]  [<ffffffffa05894af>]
xfs_vm_direct_IO+0x11f/0x130 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.936706]  [<ffffffffa0589a80>]
? xfs_get_blocks_direct+0x0/0x20 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.936710]  [<ffffffff810f6d95>]
generic_file_aio_read+0x215/0x230
Jun 12 11:33:54 TESTBA16 kernel: [59435.936724]  [<ffffffffa0567cac>]
? xfs_ilock+0x6c/0xe0 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.936739]  [<ffffffffa0567976>]
? xfs_ilock_demote+0x76/0xb0 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.936754]  [<ffffffffa058fad1>]
xfs_file_aio_read+0x161/0x2d0 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.936769]  [<ffffffffa058f970>]
? xfs_file_aio_read+0x0/0x2d0 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.936772]  [<ffffffff8118d48c>]
aio_rw_vect_retry+0x7c/0x1d0
Jun 12 11:33:54 TESTBA16 kernel: [59435.936775]  [<ffffffff8118ee02>]
aio_run_iocb+0x62/0x190
Jun 12 11:33:54 TESTBA16 kernel: [59435.936777]  [<ffffffff8118f8a0>]
io_submit_one+0x180/0x2f0
Jun 12 11:33:54 TESTBA16 kernel: [59435.936779]  [<ffffffff8118fb4c>]
do_io_submit+0x13c/0x2b0
Jun 12 11:33:54 TESTBA16 kernel: [59435.936781]  [<ffffffff8118fcd0>]
sys_io_submit+0x10/0x20
Jun 12 11:33:54 TESTBA16 kernel: [59435.936784]  [<ffffffff810028ab>]
system_call_fastpath+0x16/0x1b
Jun 12 11:33:54 TESTBA16 kernel: [59435.936789] fio             D
ffff88060b063110     0 30464      1 0x00000000
Jun 12 11:33:54 TESTBA16 kernel: [59435.936791]  ffff8805f70a9778
0000000000000086 0000000000000001 0000000000000001
Jun 12 11:33:54 TESTBA16 kernel: [59435.936793]  0000000000011e40
ffff88060b062d80 ffff88060b063110 ffff8805f70a9fd8
Jun 12 11:33:54 TESTBA16 kernel: [59435.936795]  ffff88060b063118
0000000000011e40 ffff8805f70a8010 0000000000011e40
Jun 12 11:33:54 TESTBA16 kernel: [59435.936798] Call Trace:
Jun 12 11:33:54 TESTBA16 kernel: [59435.936800]  [<ffffffffa025e698>]
make_request+0x138/0x3d0 [raid456]
Jun 12 11:33:54 TESTBA16 kernel: [59435.936803]  [<ffffffff81074d50>]
? autoremove_wake_function+0x0/0x40
Jun 12 11:33:54 TESTBA16 kernel: [59435.936805]  [<ffffffff813da9b5>]
md_make_request+0xd5/0x210
Jun 12 11:33:54 TESTBA16 kernel: [59435.936807]  [<ffffffff813e8d2d>]
? __map_bio+0xad/0x130
Jun 12 11:33:54 TESTBA16 kernel: [59435.936809]  [<ffffffff813eab1f>]
? _dm_request+0x10f/0x160
Jun 12 11:33:54 TESTBA16 kernel: [59435.936811]  [<ffffffff812760b8>]
generic_make_request+0x218/0x5c0
Jun 12 11:33:54 TESTBA16 kernel: [59435.936813]  [<ffffffff813ea13b>]
? dm_get_live_table+0x4b/0x60
Jun 12 11:33:54 TESTBA16 kernel: [59435.936815]  [<ffffffff813ed3d2>]
? linear_merge+0x52/0x60
Jun 12 11:33:54 TESTBA16 kernel: [59435.936817]  [<ffffffff813ea7e1>]
? dm_merge_bvec+0xc1/0x140
Jun 12 11:33:54 TESTBA16 kernel: [59435.936819]  [<ffffffff812764e6>]
submit_bio+0x86/0x110
Jun 12 11:33:54 TESTBA16 kernel: [59435.936821]  [<ffffffff8118355c>]
dio_bio_submit+0xbc/0xc0
Jun 12 11:33:54 TESTBA16 kernel: [59435.936823]  [<ffffffff811835f5>]
dio_send_cur_page+0x95/0xc0
Jun 12 11:33:54 TESTBA16 kernel: [59435.936825]  [<ffffffff81183685>]
submit_page_section+0x65/0x170
Jun 12 11:33:54 TESTBA16 kernel: [59435.936827]  [<ffffffff81183bb5>]
do_direct_IO+0x375/0x430
Jun 12 11:33:54 TESTBA16 kernel: [59435.936829]  [<ffffffff81183ff4>]
direct_io_worker+0x1c4/0x390
Jun 12 11:33:54 TESTBA16 kernel: [59435.936831]  [<ffffffff8118442d>]
__blockdev_direct_IO+0x26d/0x2d0
Jun 12 11:33:54 TESTBA16 kernel: [59435.936847]  [<ffffffffa0589a80>]
? xfs_get_blocks_direct+0x0/0x20 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.936849]  [<ffffffff81047893>]
? perf_event_task_sched_out+0x33/0x80
Jun 12 11:33:54 TESTBA16 kernel: [59435.936864]  [<ffffffffa05894af>]
xfs_vm_direct_IO+0x11f/0x130 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.936879]  [<ffffffffa0589a80>]
? xfs_get_blocks_direct+0x0/0x20 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.936882]  [<ffffffff810f6d95>]
generic_file_aio_read+0x215/0x230
Jun 12 11:33:54 TESTBA16 kernel: [59435.936896]  [<ffffffffa0567cac>]
? xfs_ilock+0x6c/0xe0 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.936910]  [<ffffffffa0567976>]
? xfs_ilock_demote+0x76/0xb0 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.936925]  [<ffffffffa058fad1>]
xfs_file_aio_read+0x161/0x2d0 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.936940]  [<ffffffffa058f970>]
? xfs_file_aio_read+0x0/0x2d0 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.936942]  [<ffffffff8118d48c>]
aio_rw_vect_retry+0x7c/0x1d0
Jun 12 11:33:54 TESTBA16 kernel: [59435.936944]  [<ffffffff8118ee02>]
aio_run_iocb+0x62/0x190
Jun 12 11:33:54 TESTBA16 kernel: [59435.936946]  [<ffffffff8118f8a0>]
io_submit_one+0x180/0x2f0
Jun 12 11:33:54 TESTBA16 kernel: [59435.936948]  [<ffffffff8118fb4c>]
do_io_submit+0x13c/0x2b0
Jun 12 11:33:54 TESTBA16 kernel: [59435.936950]  [<ffffffff8118fcd0>]
sys_io_submit+0x10/0x20
Jun 12 11:33:54 TESTBA16 kernel: [59435.936953]  [<ffffffff810028ab>]
system_call_fastpath+0x16/0x1b
Jun 12 11:33:54 TESTBA16 kernel: [59435.936957] fio             D
ffff88060c679a50     0 30465      1 0x00000000
Jun 12 11:33:54 TESTBA16 kernel: [59435.936959]  ffff8805ad67f778
0000000000000086 0000000000000001 0000000000000086
Jun 12 11:33:54 TESTBA16 kernel: [59435.936961]  0000000000011e40
ffff88060c6796c0 ffff88060c679a50 ffff8805ad67ffd8
Jun 12 11:33:54 TESTBA16 kernel: [59435.936964]  ffff88060c679a58
0000000000011e40 ffff8805ad67e010 0000000000011e40
Jun 12 11:33:54 TESTBA16 kernel: [59435.936966] Call Trace:
Jun 12 11:33:54 TESTBA16 kernel: [59435.936968]  [<ffffffffa025e698>]
make_request+0x138/0x3d0 [raid456]
Jun 12 11:33:54 TESTBA16 kernel: [59435.936971]  [<ffffffff81074d50>]
? autoremove_wake_function+0x0/0x40
Jun 12 11:33:54 TESTBA16 kernel: [59435.936973]  [<ffffffff813da9b5>]
md_make_request+0xd5/0x210
Jun 12 11:33:54 TESTBA16 kernel: [59435.936975]  [<ffffffff813e8d2d>]
? __map_bio+0xad/0x130
Jun 12 11:33:54 TESTBA16 kernel: [59435.936977]  [<ffffffff813eab1f>]
? _dm_request+0x10f/0x160
Jun 12 11:33:54 TESTBA16 kernel: [59435.936979]  [<ffffffff812760b8>]
generic_make_request+0x218/0x5c0
Jun 12 11:33:54 TESTBA16 kernel: [59435.936982]  [<ffffffff8113bbf0>]
? __slab_alloc+0xb0/0x2c0
Jun 12 11:33:54 TESTBA16 kernel: [59435.936984]  [<ffffffff813ea13b>]
? dm_get_live_table+0x4b/0x60
Jun 12 11:33:54 TESTBA16 kernel: [59435.936986]  [<ffffffff813ed3d2>]
? linear_merge+0x52/0x60
Jun 12 11:33:54 TESTBA16 kernel: [59435.936988]  [<ffffffff813ea7e1>]
? dm_merge_bvec+0xc1/0x140
Jun 12 11:33:54 TESTBA16 kernel: [59435.936990]  [<ffffffff812764e6>]
submit_bio+0x86/0x110
Jun 12 11:33:54 TESTBA16 kernel: [59435.936992]  [<ffffffff8118355c>]
dio_bio_submit+0xbc/0xc0
Jun 12 11:33:54 TESTBA16 kernel: [59435.936994]  [<ffffffff811835f5>]
dio_send_cur_page+0x95/0xc0
Jun 12 11:33:54 TESTBA16 kernel: [59435.936996]  [<ffffffff81183685>]
submit_page_section+0x65/0x170
Jun 12 11:33:54 TESTBA16 kernel: [59435.936998]  [<ffffffff81183bb5>]
do_direct_IO+0x375/0x430
Jun 12 11:33:54 TESTBA16 kernel: [59435.937000]  [<ffffffff81183ff4>]
direct_io_worker+0x1c4/0x390
Jun 12 11:33:54 TESTBA16 kernel: [59435.937003]  [<ffffffff8118442d>]
__blockdev_direct_IO+0x26d/0x2d0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937018]  [<ffffffffa0589a80>]
? xfs_get_blocks_direct+0x0/0x20 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937020]  [<ffffffff81047893>]
? perf_event_task_sched_out+0x33/0x80
Jun 12 11:33:54 TESTBA16 kernel: [59435.937035]  [<ffffffffa05894af>]
xfs_vm_direct_IO+0x11f/0x130 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937050]  [<ffffffffa0589a80>]
? xfs_get_blocks_direct+0x0/0x20 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937053]  [<ffffffff810f6d95>]
generic_file_aio_read+0x215/0x230
Jun 12 11:33:54 TESTBA16 kernel: [59435.937067]  [<ffffffffa0567cac>]
? xfs_ilock+0x6c/0xe0 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937081]  [<ffffffffa0567976>]
? xfs_ilock_demote+0x76/0xb0 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937096]  [<ffffffffa058fad1>]
xfs_file_aio_read+0x161/0x2d0 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937111]  [<ffffffffa058f970>]
? xfs_file_aio_read+0x0/0x2d0 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937113]  [<ffffffff8118d48c>]
aio_rw_vect_retry+0x7c/0x1d0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937115]  [<ffffffff8118ee02>]
aio_run_iocb+0x62/0x190
Jun 12 11:33:54 TESTBA16 kernel: [59435.937117]  [<ffffffff8118f8a0>]
io_submit_one+0x180/0x2f0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937119]  [<ffffffff8118fb4c>]
do_io_submit+0x13c/0x2b0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937121]  [<ffffffff8118fcd0>]
sys_io_submit+0x10/0x20
Jun 12 11:33:54 TESTBA16 kernel: [59435.937124]  [<ffffffff810028ab>]
system_call_fastpath+0x16/0x1b
Jun 12 11:33:54 TESTBA16 kernel: [59435.937128] fio             D
ffff88060c525e90     0 30466      1 0x00000000
Jun 12 11:33:54 TESTBA16 kernel: [59435.937130]  ffff8806099ab778
0000000000000082 ffff8806099ab748 0000000000000000
Jun 12 11:33:54 TESTBA16 kernel: [59435.937132]  0000000000011e40
ffff88060c525b00 ffff88060c525e90 ffff8806099abfd8
Jun 12 11:33:54 TESTBA16 kernel: [59435.937134]  ffff88060c525e98
0000000000011e40 ffff8806099aa010 0000000000011e40
Jun 12 11:33:54 TESTBA16 kernel: [59435.937136] Call Trace:
Jun 12 11:33:54 TESTBA16 kernel: [59435.937139]  [<ffffffffa025e698>]
make_request+0x138/0x3d0 [raid456]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937142]  [<ffffffff81074d50>]
? autoremove_wake_function+0x0/0x40
Jun 12 11:33:54 TESTBA16 kernel: [59435.937144]  [<ffffffff813da9b5>]
md_make_request+0xd5/0x210
Jun 12 11:33:54 TESTBA16 kernel: [59435.937146]  [<ffffffff813eab1f>]
? _dm_request+0x10f/0x160
Jun 12 11:33:54 TESTBA16 kernel: [59435.937148]  [<ffffffff812760b8>]
generic_make_request+0x218/0x5c0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937150]  [<ffffffff813ea13b>]
? dm_get_live_table+0x4b/0x60
Jun 12 11:33:54 TESTBA16 kernel: [59435.937152]  [<ffffffff813ed3d2>]
? linear_merge+0x52/0x60
Jun 12 11:33:54 TESTBA16 kernel: [59435.937154]  [<ffffffff813ea7e1>]
? dm_merge_bvec+0xc1/0x140
Jun 12 11:33:54 TESTBA16 kernel: [59435.937156]  [<ffffffff812764e6>]
submit_bio+0x86/0x110
Jun 12 11:33:54 TESTBA16 kernel: [59435.937158]  [<ffffffff8118355c>]
dio_bio_submit+0xbc/0xc0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937160]  [<ffffffff811835f5>]
dio_send_cur_page+0x95/0xc0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937162]  [<ffffffff81183685>]
submit_page_section+0x65/0x170
Jun 12 11:33:54 TESTBA16 kernel: [59435.937164]  [<ffffffff81183bb5>]
do_direct_IO+0x375/0x430
Jun 12 11:33:54 TESTBA16 kernel: [59435.937166]  [<ffffffff81183ff4>]
direct_io_worker+0x1c4/0x390
Jun 12 11:33:54 TESTBA16 kernel: [59435.937168]  [<ffffffff8118442d>]
__blockdev_direct_IO+0x26d/0x2d0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937184]  [<ffffffffa0589a80>]
? xfs_get_blocks_direct+0x0/0x20 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937186]  [<ffffffff81047893>]
? perf_event_task_sched_out+0x33/0x80
Jun 12 11:33:54 TESTBA16 kernel: [59435.937201]  [<ffffffffa05894af>]
xfs_vm_direct_IO+0x11f/0x130 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937216]  [<ffffffffa0589a80>]
? xfs_get_blocks_direct+0x0/0x20 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937219]  [<ffffffff810f6d95>]
generic_file_aio_read+0x215/0x230
Jun 12 11:33:54 TESTBA16 kernel: [59435.937233]  [<ffffffffa0567cac>]
? xfs_ilock+0x6c/0xe0 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937247]  [<ffffffffa0567976>]
? xfs_ilock_demote+0x76/0xb0 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937262]  [<ffffffffa058fad1>]
xfs_file_aio_read+0x161/0x2d0 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937277]  [<ffffffffa058f970>]
? xfs_file_aio_read+0x0/0x2d0 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937279]  [<ffffffff8118d48c>]
aio_rw_vect_retry+0x7c/0x1d0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937281]  [<ffffffff8118ee02>]
aio_run_iocb+0x62/0x190
Jun 12 11:33:54 TESTBA16 kernel: [59435.937283]  [<ffffffff8118f8a0>]
io_submit_one+0x180/0x2f0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937285]  [<ffffffff8118fb4c>]
do_io_submit+0x13c/0x2b0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937287]  [<ffffffff8118fcd0>]
sys_io_submit+0x10/0x20
Jun 12 11:33:54 TESTBA16 kernel: [59435.937290]  [<ffffffff810028ab>]
system_call_fastpath+0x16/0x1b
Jun 12 11:33:54 TESTBA16 kernel: [59435.937294] fio             D
ffff88060b488390     0 30467      1 0x00000000
Jun 12 11:33:54 TESTBA16 kernel: [59435.937296]  ffff8805af683778
0000000000000086 0000000000000001 0000000000000086
Jun 12 11:33:54 TESTBA16 kernel: [59435.937298]  0000000000011e40
ffff88060b488000 ffff88060b488390 ffff8805af683fd8
Jun 12 11:33:54 TESTBA16 kernel: [59435.937300]  ffff88060b488398
0000000000011e40 ffff8805af682010 0000000000011e40
Jun 12 11:33:54 TESTBA16 kernel: [59435.937303] Call Trace:
Jun 12 11:33:54 TESTBA16 kernel: [59435.937305]  [<ffffffffa025e698>]
make_request+0x138/0x3d0 [raid456]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937308]  [<ffffffff81074d50>]
? autoremove_wake_function+0x0/0x40
Jun 12 11:33:54 TESTBA16 kernel: [59435.937310]  [<ffffffff813da9b5>]
md_make_request+0xd5/0x210
Jun 12 11:33:54 TESTBA16 kernel: [59435.937312]  [<ffffffff813eab1f>]
? _dm_request+0x10f/0x160
Jun 12 11:33:54 TESTBA16 kernel: [59435.937314]  [<ffffffff812760b8>]
generic_make_request+0x218/0x5c0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937316]  [<ffffffff813ea13b>]
? dm_get_live_table+0x4b/0x60
Jun 12 11:33:54 TESTBA16 kernel: [59435.937318]  [<ffffffff813ed3d2>]
? linear_merge+0x52/0x60
Jun 12 11:33:54 TESTBA16 kernel: [59435.937320]  [<ffffffff813ea7e1>]
? dm_merge_bvec+0xc1/0x140
Jun 12 11:33:54 TESTBA16 kernel: [59435.937322]  [<ffffffff812764e6>]
submit_bio+0x86/0x110
Jun 12 11:33:54 TESTBA16 kernel: [59435.937324]  [<ffffffff8118355c>]
dio_bio_submit+0xbc/0xc0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937326]  [<ffffffff811835f5>]
dio_send_cur_page+0x95/0xc0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937328]  [<ffffffff81183685>]
submit_page_section+0x65/0x170
Jun 12 11:33:54 TESTBA16 kernel: [59435.937330]  [<ffffffff81183bb5>]
do_direct_IO+0x375/0x430
Jun 12 11:33:54 TESTBA16 kernel: [59435.937332]  [<ffffffff81183ff4>]
direct_io_worker+0x1c4/0x390
Jun 12 11:33:54 TESTBA16 kernel: [59435.937334]  [<ffffffff8118442d>]
__blockdev_direct_IO+0x26d/0x2d0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937350]  [<ffffffffa0589a80>]
? xfs_get_blocks_direct+0x0/0x20 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937352]  [<ffffffff81047893>]
? perf_event_task_sched_out+0x33/0x80
Jun 12 11:33:54 TESTBA16 kernel: [59435.937367]  [<ffffffffa05894af>]
xfs_vm_direct_IO+0x11f/0x130 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937382]  [<ffffffffa0589a80>]
? xfs_get_blocks_direct+0x0/0x20 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937385]  [<ffffffff810f6d95>]
generic_file_aio_read+0x215/0x230
Jun 12 11:33:54 TESTBA16 kernel: [59435.937399]  [<ffffffffa0567cac>]
? xfs_ilock+0x6c/0xe0 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937413]  [<ffffffffa0567976>]
? xfs_ilock_demote+0x76/0xb0 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937428]  [<ffffffffa058fad1>]
xfs_file_aio_read+0x161/0x2d0 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937443]  [<ffffffffa058f970>]
? xfs_file_aio_read+0x0/0x2d0 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937445]  [<ffffffff8118d48c>]
aio_rw_vect_retry+0x7c/0x1d0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937447]  [<ffffffff8118ee02>]
aio_run_iocb+0x62/0x190
Jun 12 11:33:54 TESTBA16 kernel: [59435.937449]  [<ffffffff8118f8a0>]
io_submit_one+0x180/0x2f0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937451]  [<ffffffff8118fb4c>]
do_io_submit+0x13c/0x2b0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937454]  [<ffffffff8118fcd0>]
sys_io_submit+0x10/0x20
Jun 12 11:33:54 TESTBA16 kernel: [59435.937456]  [<ffffffff810028ab>]
system_call_fastpath+0x16/0x1b
Jun 12 11:33:54 TESTBA16 kernel: [59435.937460] fio             D
ffff880608b61a50     0 30468      1 0x00000000
Jun 12 11:33:54 TESTBA16 kernel: [59435.937462]  ffff8805f77c1778
0000000000000082 0000000000000001 0000000000000000
Jun 12 11:33:54 TESTBA16 kernel: [59435.937464]  0000000000011e40
ffff880608b616c0 ffff880608b61a50 ffff8805f77c1fd8
Jun 12 11:33:54 TESTBA16 kernel: [59435.937466]  ffff880608b61a58
0000000000011e40 ffff8805f77c0010 0000000000011e40
Jun 12 11:33:54 TESTBA16 kernel: [59435.937469] Call Trace:
Jun 12 11:33:54 TESTBA16 kernel: [59435.937471]  [<ffffffffa025e698>]
make_request+0x138/0x3d0 [raid456]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937474]  [<ffffffff81074d50>]
? autoremove_wake_function+0x0/0x40
Jun 12 11:33:54 TESTBA16 kernel: [59435.937476]  [<ffffffff813da9b5>]
md_make_request+0xd5/0x210
Jun 12 11:33:54 TESTBA16 kernel: [59435.937478]  [<ffffffff813e8d2d>]
? __map_bio+0xad/0x130
Jun 12 11:33:54 TESTBA16 kernel: [59435.937480]  [<ffffffff813eab1f>]
? _dm_request+0x10f/0x160
Jun 12 11:33:54 TESTBA16 kernel: [59435.937482]  [<ffffffff812760b8>]
generic_make_request+0x218/0x5c0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937484]  [<ffffffff813ea13b>]
? dm_get_live_table+0x4b/0x60
Jun 12 11:33:54 TESTBA16 kernel: [59435.937486]  [<ffffffff813ed3d2>]
? linear_merge+0x52/0x60
Jun 12 11:33:54 TESTBA16 kernel: [59435.937488]  [<ffffffff813ea7e1>]
? dm_merge_bvec+0xc1/0x140
Jun 12 11:33:54 TESTBA16 kernel: [59435.937490]  [<ffffffff812764e6>]
submit_bio+0x86/0x110
Jun 12 11:33:54 TESTBA16 kernel: [59435.937492]  [<ffffffff8118355c>]
dio_bio_submit+0xbc/0xc0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937494]  [<ffffffff811835f5>]
dio_send_cur_page+0x95/0xc0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937496]  [<ffffffff81183685>]
submit_page_section+0x65/0x170
Jun 12 11:33:54 TESTBA16 kernel: [59435.937498]  [<ffffffff81183bb5>]
do_direct_IO+0x375/0x430
Jun 12 11:33:54 TESTBA16 kernel: [59435.937501]  [<ffffffff81043b35>]
? find_busiest_group+0x65/0x340
Jun 12 11:33:54 TESTBA16 kernel: [59435.937503]  [<ffffffff81183ff4>]
direct_io_worker+0x1c4/0x390
Jun 12 11:33:54 TESTBA16 kernel: [59435.937506]  [<ffffffff8118442d>]
__blockdev_direct_IO+0x26d/0x2d0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937521]  [<ffffffffa0589a80>]
? xfs_get_blocks_direct+0x0/0x20 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937523]  [<ffffffff81047893>]
? perf_event_task_sched_out+0x33/0x80
Jun 12 11:33:54 TESTBA16 kernel: [59435.937538]  [<ffffffffa05894af>]
xfs_vm_direct_IO+0x11f/0x130 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937553]  [<ffffffffa0589a80>]
? xfs_get_blocks_direct+0x0/0x20 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937556]  [<ffffffff810f6d95>]
generic_file_aio_read+0x215/0x230
Jun 12 11:33:54 TESTBA16 kernel: [59435.937570]  [<ffffffffa0567cac>]
? xfs_ilock+0x6c/0xe0 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937584]  [<ffffffffa0567976>]
? xfs_ilock_demote+0x76/0xb0 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937599]  [<ffffffffa058fad1>]
xfs_file_aio_read+0x161/0x2d0 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937615]  [<ffffffffa058f970>]
? xfs_file_aio_read+0x0/0x2d0 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937617]  [<ffffffff8118d48c>]
aio_rw_vect_retry+0x7c/0x1d0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937618]  [<ffffffff8118ee02>]
aio_run_iocb+0x62/0x190
Jun 12 11:33:54 TESTBA16 kernel: [59435.937620]  [<ffffffff8118f8a0>]
io_submit_one+0x180/0x2f0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937622]  [<ffffffff8118fb4c>]
do_io_submit+0x13c/0x2b0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937625]  [<ffffffff8118fcd0>]
sys_io_submit+0x10/0x20
Jun 12 11:33:54 TESTBA16 kernel: [59435.937627]  [<ffffffff810028ab>]
system_call_fastpath+0x16/0x1b
Jun 12 11:33:54 TESTBA16 kernel: [59435.937631] fio             D
ffff88060b1cc7d0     0 30469      1 0x00000000
Jun 12 11:33:54 TESTBA16 kernel: [59435.937634]  ffff88060ba3f778
0000000000000086 0000000000000001 00000000ffffffff
Jun 12 11:33:54 TESTBA16 kernel: [59435.937636]  0000000000011e40
ffff88060b1cc440 ffff88060b1cc7d0 ffff88060ba3ffd8
Jun 12 11:33:54 TESTBA16 kernel: [59435.937638]  ffff88060b1cc7d8
0000000000011e40 ffff88060ba3e010 0000000000011e40
Jun 12 11:33:54 TESTBA16 kernel: [59435.937640] Call Trace:
Jun 12 11:33:54 TESTBA16 kernel: [59435.937643]  [<ffffffffa025e698>]
make_request+0x138/0x3d0 [raid456]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937645]  [<ffffffff81074d50>]
? autoremove_wake_function+0x0/0x40
Jun 12 11:33:54 TESTBA16 kernel: [59435.937648]  [<ffffffff813da9b5>]
md_make_request+0xd5/0x210
Jun 12 11:33:54 TESTBA16 kernel: [59435.937650]  [<ffffffff812789ae>]
? __make_request+0x41e/0x4b0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937652]  [<ffffffff813eab1f>]
? _dm_request+0x10f/0x160
Jun 12 11:33:54 TESTBA16 kernel: [59435.937654]  [<ffffffff812760b8>]
generic_make_request+0x218/0x5c0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937656]  [<ffffffff813ea13b>]
? dm_get_live_table+0x4b/0x60
Jun 12 11:33:54 TESTBA16 kernel: [59435.937658]  [<ffffffff813ed3d2>]
? linear_merge+0x52/0x60
Jun 12 11:33:54 TESTBA16 kernel: [59435.937660]  [<ffffffff813ea7e1>]
? dm_merge_bvec+0xc1/0x140
Jun 12 11:33:54 TESTBA16 kernel: [59435.937662]  [<ffffffff812764e6>]
submit_bio+0x86/0x110
Jun 12 11:33:54 TESTBA16 kernel: [59435.937664]  [<ffffffff8118355c>]
dio_bio_submit+0xbc/0xc0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937666]  [<ffffffff811835f5>]
dio_send_cur_page+0x95/0xc0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937668]  [<ffffffff81183685>]
submit_page_section+0x65/0x170
Jun 12 11:33:54 TESTBA16 kernel: [59435.937670]  [<ffffffff81183bb5>]
do_direct_IO+0x375/0x430
Jun 12 11:33:54 TESTBA16 kernel: [59435.937672]  [<ffffffff81183ff4>]
direct_io_worker+0x1c4/0x390
Jun 12 11:33:54 TESTBA16 kernel: [59435.937674]  [<ffffffff8118442d>]
__blockdev_direct_IO+0x26d/0x2d0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937690]  [<ffffffffa0589a80>]
? xfs_get_blocks_direct+0x0/0x20 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937692]  [<ffffffff81047893>]
? perf_event_task_sched_out+0x33/0x80
Jun 12 11:33:54 TESTBA16 kernel: [59435.937707]  [<ffffffffa05894af>]
xfs_vm_direct_IO+0x11f/0x130 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937722]  [<ffffffffa0589a80>]
? xfs_get_blocks_direct+0x0/0x20 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937725]  [<ffffffff810f6d95>]
generic_file_aio_read+0x215/0x230
Jun 12 11:33:54 TESTBA16 kernel: [59435.937739]  [<ffffffffa0567cac>]
? xfs_ilock+0x6c/0xe0 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937753]  [<ffffffffa0567976>]
? xfs_ilock_demote+0x76/0xb0 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937768]  [<ffffffffa058fad1>]
xfs_file_aio_read+0x161/0x2d0 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937784]  [<ffffffffa058f970>]
? xfs_file_aio_read+0x0/0x2d0 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937786]  [<ffffffff8118d48c>]
aio_rw_vect_retry+0x7c/0x1d0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937788]  [<ffffffff8118ee02>]
aio_run_iocb+0x62/0x190
Jun 12 11:33:54 TESTBA16 kernel: [59435.937789]  [<ffffffff8118f8a0>]
io_submit_one+0x180/0x2f0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937792]  [<ffffffff8118fb4c>]
do_io_submit+0x13c/0x2b0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937794]  [<ffffffff8118fcd0>]
sys_io_submit+0x10/0x20
Jun 12 11:33:54 TESTBA16 kernel: [59435.937796]  [<ffffffff810028ab>]
system_call_fastpath+0x16/0x1b
Jun 12 11:33:54 TESTBA16 kernel: [59435.937800] fio             D
ffff88060afe8390     0 30470      1 0x00000000
Jun 12 11:33:54 TESTBA16 kernel: [59435.937802]  ffff8805f74c5778
0000000000000082 0000000000000001 00000000ffffffff
Jun 12 11:33:54 TESTBA16 kernel: [59435.937805]  0000000000011e40
ffff88060afe8000 ffff88060afe8390 ffff8805f74c5fd8
Jun 12 11:33:54 TESTBA16 kernel: [59435.937807]  ffff88060afe8398
0000000000011e40 ffff8805f74c4010 0000000000011e40
Jun 12 11:33:54 TESTBA16 kernel: [59435.937809] Call Trace:
Jun 12 11:33:54 TESTBA16 kernel: [59435.937812]  [<ffffffffa025e698>]
make_request+0x138/0x3d0 [raid456]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937814]  [<ffffffff81074d50>]
? autoremove_wake_function+0x0/0x40
Jun 12 11:33:54 TESTBA16 kernel: [59435.937816]  [<ffffffff813da9b5>]
md_make_request+0xd5/0x210
Jun 12 11:33:54 TESTBA16 kernel: [59435.937818]  [<ffffffff812786a0>]
? __make_request+0x110/0x4b0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937820]  [<ffffffff813eab1f>]
? _dm_request+0x10f/0x160
Jun 12 11:33:54 TESTBA16 kernel: [59435.937822]  [<ffffffff812760b8>]
generic_make_request+0x218/0x5c0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937824]  [<ffffffff8113bbf0>]
? __slab_alloc+0xb0/0x2c0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937826]  [<ffffffff813ea13b>]
? dm_get_live_table+0x4b/0x60
Jun 12 11:33:54 TESTBA16 kernel: [59435.937828]  [<ffffffff813ed3d2>]
? linear_merge+0x52/0x60
Jun 12 11:33:54 TESTBA16 kernel: [59435.937830]  [<ffffffff813ea7e1>]
? dm_merge_bvec+0xc1/0x140
Jun 12 11:33:54 TESTBA16 kernel: [59435.937832]  [<ffffffff812764e6>]
submit_bio+0x86/0x110
Jun 12 11:33:54 TESTBA16 kernel: [59435.937834]  [<ffffffff8118355c>]
dio_bio_submit+0xbc/0xc0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937836]  [<ffffffff811835f5>]
dio_send_cur_page+0x95/0xc0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937838]  [<ffffffff81183685>]
submit_page_section+0x65/0x170
Jun 12 11:33:54 TESTBA16 kernel: [59435.937840]  [<ffffffff81183bb5>]
do_direct_IO+0x375/0x430
Jun 12 11:33:54 TESTBA16 kernel: [59435.937842]  [<ffffffff81183ff4>]
direct_io_worker+0x1c4/0x390
Jun 12 11:33:54 TESTBA16 kernel: [59435.937845]  [<ffffffff8118442d>]
__blockdev_direct_IO+0x26d/0x2d0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937860]  [<ffffffffa0589a80>]
? xfs_get_blocks_direct+0x0/0x20 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937862]  [<ffffffff81047893>]
? perf_event_task_sched_out+0x33/0x80
Jun 12 11:33:54 TESTBA16 kernel: [59435.937877]  [<ffffffffa05894af>]
xfs_vm_direct_IO+0x11f/0x130 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937893]  [<ffffffffa0589a80>]
? xfs_get_blocks_direct+0x0/0x20 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937895]  [<ffffffff810f6d95>]
generic_file_aio_read+0x215/0x230
Jun 12 11:33:54 TESTBA16 kernel: [59435.937909]  [<ffffffffa0567cac>]
? xfs_ilock+0x6c/0xe0 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937924]  [<ffffffffa0567976>]
? xfs_ilock_demote+0x76/0xb0 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937939]  [<ffffffffa058fad1>]
xfs_file_aio_read+0x161/0x2d0 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937954]  [<ffffffffa058f970>]
? xfs_file_aio_read+0x0/0x2d0 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937956]  [<ffffffff8118d48c>]
aio_rw_vect_retry+0x7c/0x1d0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937958]  [<ffffffff8118ee02>]
aio_run_iocb+0x62/0x190
Jun 12 11:33:54 TESTBA16 kernel: [59435.937960]  [<ffffffff8118f8a0>]
io_submit_one+0x180/0x2f0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937962]  [<ffffffff8118fb4c>]
do_io_submit+0x13c/0x2b0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937964]  [<ffffffff8118fcd0>]
sys_io_submit+0x10/0x20
Jun 12 11:33:54 TESTBA16 kernel: [59435.937966]  [<ffffffff810028ab>]
system_call_fastpath+0x16/0x1b
Jun 12 11:33:54 TESTBA16 kernel: [59435.937970] fio             D
ffff88060c4d3110     0 30764      1 0x00000004
Jun 12 11:33:54 TESTBA16 kernel: [59435.937973]  ffff880609307898
0000000000000082 ffffffffffffffff 0000000000000000
Jun 12 11:33:54 TESTBA16 kernel: [59435.937975]  0000000000011e40
ffff88060c4d2d80 ffff88060c4d3110 ffff880609307fd8
Jun 12 11:33:54 TESTBA16 kernel: [59435.937977]  ffff88060c4d3118
0000000000011e40 ffff880609306010 0000000000011e40
Jun 12 11:33:54 TESTBA16 kernel: [59435.937979] Call Trace:
Jun 12 11:33:54 TESTBA16 kernel: [59435.937981]  [<ffffffff813dfe85>]
md_write_start+0xb5/0x1e0
Jun 12 11:33:54 TESTBA16 kernel: [59435.937984]  [<ffffffff81074d50>]
? autoremove_wake_function+0x0/0x40
Jun 12 11:33:54 TESTBA16 kernel: [59435.937987]  [<ffffffffa025e5a1>]
make_request+0x41/0x3d0 [raid456]
Jun 12 11:33:54 TESTBA16 kernel: [59435.937989]  [<ffffffff813da9b5>]
md_make_request+0xd5/0x210
Jun 12 11:33:54 TESTBA16 kernel: [59435.938004]  [<ffffffffa0574ee9>]
? xlog_write+0x489/0x500 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.938006]  [<ffffffff813eab1f>]
? _dm_request+0x10f/0x160
Jun 12 11:33:54 TESTBA16 kernel: [59435.938008]  [<ffffffff812760b8>]
generic_make_request+0x218/0x5c0
Jun 12 11:33:54 TESTBA16 kernel: [59435.938010]  [<ffffffff813ed3d2>]
? linear_merge+0x52/0x60
Jun 12 11:33:54 TESTBA16 kernel: [59435.938012]  [<ffffffff813ea7e1>]
? dm_merge_bvec+0xc1/0x140
Jun 12 11:33:54 TESTBA16 kernel: [59435.938014]  [<ffffffff812764e6>]
submit_bio+0x86/0x110
Jun 12 11:33:54 TESTBA16 kernel: [59435.938030]  [<ffffffffa058bca2>]
_xfs_buf_ioapply+0x192/0x2f0 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.938044]  [<ffffffffa0571a8a>]
? xlog_bdstrat+0x2a/0x60 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.938060]  [<ffffffffa058dc61>]
xfs_buf_iorequest+0x51/0xd0 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.938074]  [<ffffffffa0571a8a>]
xlog_bdstrat+0x2a/0x60 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.938089]  [<ffffffffa0573c18>]
xlog_sync+0x248/0x3f0 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.938104]  [<ffffffffa0573e5b>]
xlog_state_release_iclog+0x9b/0xd0 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.938119]  [<ffffffffa057481b>]
_xfs_log_force_lsn+0x1eb/0x290 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.938135]  [<ffffffffa0581f4d>]
_xfs_trans_commit+0x29d/0x2b0 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.938150]  [<ffffffffa05885a5>]
xfs_change_file_space+0x1e5/0x2e0 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.938154]  [<ffffffff8115e0e1>]
? do_filp_open+0x181/0x770
Jun 12 11:33:54 TESTBA16 kernel: [59435.938170]  [<ffffffffa058f14e>]
xfs_file_fallocate+0xde/0x150 [xfs]
Jun 12 11:33:54 TESTBA16 kernel: [59435.938172]  [<ffffffff8115a515>]
? putname+0x35/0x50
Jun 12 11:33:54 TESTBA16 kernel: [59435.938174]  [<ffffffff8115d50e>]
? do_unlinkat+0x5e/0x1d0
Jun 12 11:33:54 TESTBA16 kernel: [59435.938180]  [<ffffffff812645a8>]
? apparmor_file_permission+0x18/0x20
Jun 12 11:33:54 TESTBA16 kernel: [59435.938183]  [<ffffffff8114e1d3>]
do_fallocate+0x113/0x120
Jun 12 11:33:54 TESTBA16 kernel: [59435.938185]  [<ffffffff8114e22e>]
sys_fallocate+0x4e/0x80
Jun 12 11:33:54 TESTBA16 kernel: [59435.938187]  [<ffffffff810028ab>]
system_call_fastpath+0x16/0x1b



The errors seem to be a combination of XFS and md related messages.
Any insight into this issue would be greatly appreciated. Thanks!


-TG
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
