From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Subject: "md_raid5: page allocation failure" when resyncing on 3.2
Date: Mon, 09 Jan 2012 19:25:23 +0200
Message-ID: <4F0B2303.4080109@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello, i got this kernel message when i was resyncing my md raid 5 array 
on a linux 3.2 machine.

[16309.604375] md127_raid5: page allocation failure: order:1, mode:0x4020
[16309.605038] Pid: 499, comm: md127_raid5 Not tainted 
3.2.0-rc7-00076-gc7f46b7-dirty #1
[16309.605038] Call Trace:
[16309.605038]  <IRQ>  [<ffffffff811084d6>] warn_alloc_failed+0xf6/0x150
[16309.605038]  [<ffffffff81116065>] ? wakeup_kswapd+0xd5/0x190
[16309.605038]  [<ffffffff8110bc03>] __alloc_pages_nodemask+0x673/0x850
[16309.605038]  [<ffffffff8105cf70>] ? try_to_wake_up+0x290/0x290
[16309.605038]  [<ffffffff8104df00>] ? complete_all+0x30/0x60
[16309.605038]  [<ffffffff811444a3>] alloc_pages_current+0xa3/0x110
[16309.605038]  [<ffffffff8114f209>] new_slab+0x2c9/0x2e0
[16309.605038]  [<ffffffff81413464>] __slab_alloc.isra.51+0x494/0x596
[16309.605038]  [<ffffffff813482b4>] ? __netdev_alloc_skb+0x24/0x50
[16309.605038]  [<ffffffff813883e0>] ? ip_local_deliver+0x90/0xa0
[16309.605038]  [<ffffffff81387d11>] ? ip_rcv_finish+0x131/0x380
[16309.605038]  [<ffffffff81151dc4>] __kmalloc_node_track_caller+0x84/0x230
[16309.605038]  [<ffffffff81354c8b>] ? __netif_receive_skb+0x57b/0x630
[16309.605038]  [<ffffffff81347bfb>] ? __alloc_skb+0x4b/0x240
[16309.605038]  [<ffffffff813482b4>] ? __netdev_alloc_skb+0x24/0x50
[16309.605038]  [<ffffffff81347c28>] __alloc_skb+0x78/0x240
[16309.605038]  [<ffffffff813482b4>] __netdev_alloc_skb+0x24/0x50
[16309.605038]  [<ffffffffa018a6a6>] rtl8169_poll+0x1f6/0x570 [r8169]
[16309.605038]  [<ffffffff813556f9>] net_rx_action+0x149/0x300
[16309.605038]  [<ffffffff8106b410>] __do_softirq+0xb0/0x270
[16309.605038]  [<ffffffff8141beac>] call_softirq+0x1c/0x30
[16309.605038]  [<ffffffff81017765>] do_softirq+0x65/0xa0
[16309.605038]  [<ffffffff8106b91e>] irq_exit+0x9e/0xc0
[16309.605038]  [<ffffffff8141c763>] do_IRQ+0x63/0xe0
[16309.605038]  [<ffffffff814193ae>] common_interrupt+0x6e/0x6e
[16309.605038]  <EOI>  [<ffffffff8123f4db>] ? memcpy+0xb/0x120
[16309.605038]  [<ffffffffa006d1c6>] ? async_memcpy+0x1c6/0x254 
[async_memcpy]
[16309.605038]  [<ffffffffa012b950>] async_copy_data+0x90/0x140 [raid456]
[16309.605038]  [<ffffffffa012c090>] __raid_run_ops+0x5d0/0xcc0 [raid456]
[16309.605038]  [<ffffffff810525a8>] ? hrtick_update+0x38/0x40
[16309.605038]  [<ffffffffa012f290>] ? ops_complete_compute+0x50/0x50 
[raid456]
[16309.605038]  [<ffffffffa01328d3>] handle_stripe+0xf93/0x1e00 [raid456]
[16309.605038]  [<ffffffffa0133b6d>] raid5d+0x42d/0x620 [raid456]
[16309.605038]  [<ffffffffa03a0cae>] md_thread+0x10e/0x140 [md_mod]
[16309.605038]  [<ffffffff810868f0>] ? abort_exclusive_wait+0xb0/0xb0
[16309.605038]  [<ffffffffa03a0ba0>] ? md_register_thread+0x110/0x110 
[md_mod]
[16309.605038]  [<ffffffff81085fac>] kthread+0x8c/0xa0
[16309.605038]  [<ffffffff8141bdb4>] kernel_thread_helper+0x4/0x10
[16309.605038]  [<ffffffff81085f20>] ? kthread_worker_fn+0x190/0x190
[16309.605038]  [<ffffffff8141bdb0>] ? gs_change+0x13/0x13
[16309.605038] Mem-Info:
[16309.605038] Node 0 DMA per-cpu:
[16309.605038] CPU    0: hi:    0, btch:   1 usd:   0
[16309.605038] CPU    1: hi:    0, btch:   1 usd:   0
[16309.605038] CPU    2: hi:    0, btch:   1 usd:   0
[16309.605038] CPU    3: hi:    0, btch:   1 usd:   0
[16309.605038] Node 0 DMA32 per-cpu:
[16309.605038] CPU    0: hi:  186, btch:  31 usd: 164
[16309.605038] CPU    1: hi:  186, btch:  31 usd:  30
[16309.605038] CPU    2: hi:  186, btch:  31 usd:  61
[16309.605038] CPU    3: hi:  186, btch:  31 usd: 180
[16309.605038] Node 0 Normal per-cpu:
[16309.605038] CPU    0: hi:  186, btch:  31 usd: 148
[16309.605038] CPU    1: hi:  186, btch:  31 usd: 161
[16309.605038] CPU    2: hi:  186, btch:  31 usd: 119
[16309.605038] CPU    3: hi:  186, btch:  31 usd: 182
[16309.605038] active_anon:151803 inactive_anon:40756 isolated_anon:0
[16309.605038]  active_file:534132 inactive_file:792114 isolated_file:0
[16309.605038]  unevictable:0 dirty:135803 writeback:2049 unstable:0
[16309.605038]  free:109139 slab_reclaimable:212766 slab_unreclaimable:33151
[16309.605038]  mapped:12417 shmem:19158 pagetables:3233 bounce:0
[16309.605038] Node 0 DMA free:15872kB min:136kB low:168kB high:204kB 
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15616kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? yes
[16309.605038] lowmem_reserve[]: 0 3245 7529 7529
[16309.605038] Node 0 DMA32 free:372740kB min:29068kB low:36332kB 
high:43600kB active_anon:94812kB inactive_anon:54704kB 
active_file:539036kB inactive_file:1554956kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:3323072kB mlocked:0kB 
dirty:184924kB writeback:0kB mapped:1184kB shmem:0kB 
slab_reclaimable:607956kB slab_unreclaimable:81988kB kernel_stack:456kB 
pagetables:3500kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:0 all_unreclaimable? no
[16309.605038] lowmem_reserve[]: 0 0 4284 4284
[16309.605038] Node 0 Normal free:47696kB min:38376kB low:47968kB 
high:57564kB active_anon:512400kB inactive_anon:108320kB 
active_file:1597492kB inactive_file:1613796kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:4386816kB mlocked:0kB 
dirty:358216kB writeback:8196kB mapped:48484kB shmem:76632kB 
slab_reclaimable:243108kB slab_unreclaimable:50616kB kernel_stack:1152kB 
pagetables:9432kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:0 all_unreclaimable? no
[16309.605038] lowmem_reserve[]: 0 0 0 0
[16309.605038] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 2*64kB 1*128kB 
1*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15872kB
[16309.605038] Node 0 DMA32: 93061*4kB 0*8kB 0*16kB 0*32kB 0*64kB 
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 372244kB
[16309.605038] Node 0 Normal: 11924*4kB 0*8kB 0*16kB 0*32kB 0*64kB 
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 47696kB
[16309.605038] 1345617 total pagecache pages
[16309.605038] 6 pages in swap cache
[16309.605038] Swap cache stats: add 31, delete 25, find 6/7
[16309.605038] Free swap  = 7815520kB
[16309.605038] Total swap = 7815616kB
[16309.605038] 1966064 pages RAM
[16309.605038] 50197 pages reserved
[16309.605038] 1791343 pages shared
[16309.605038] 591648 pages non-shared
[16309.605038] SLUB: Unable to allocate memory on node -1 (gfp=0x20)
[16309.605038]   cache: kmalloc-8192, object size: 8192, buffer size: 
8192, default order: 3, min order: 1
[16309.605038]   node 0: slabs: 12, objs: 48, free: 0


cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md127 : active raid5 sdc[2] sda[0] sdf[4] sdg[6] sdb[1] sdd[3]
       9767564800 blocks super 1.2 level 5, 512k chunk, algorithm 2 
[6/6] [UUUUUU]
       [=======>.............]  resync = 39.9% (780149784/1953512960) 
finish=238.2min speed=82073K/sec

  mdadm -D /dev/md127
/dev/md127:
         Version : 1.2
   Creation Time : Mon May 23 19:32:50 2011
      Raid Level : raid5
      Array Size : 9767564800 (9315.08 GiB 10001.99 GB)
   Used Dev Size : 1953512960 (1863.02 GiB 2000.40 GB)
    Raid Devices : 6
   Total Devices : 6
     Persistence : Superblock is persistent

     Update Time : Mon Jan  9 19:12:25 2012
           State : active, resyncing
  Active Devices : 6
Working Devices : 6
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 512K

  Rebuild Status : 40% complete

            Name : linuxserver:0  (local to host linuxserver)
            UUID : 5a2a8947:b9ec7d00:5e626838:7718e3b1
          Events : 504

     Number   Major   Minor   RaidDevice State
        0       8        0        0      active sync   /dev/sda
        1       8       16        1      active sync   /dev/sdb
        2       8       32        2      active sync   /dev/sdc
        3       8       48        3      active sync   /dev/sdd
        4       8       80        4      active sync   /dev/sdf
        6       8       96        5      active sync   /dev/sdg

