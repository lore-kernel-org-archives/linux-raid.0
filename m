From: "Fredrik Lindgren" <fli@swip.net>
Subject: Memory issues with RAID5?
Date: Sat, 23 Sep 2006 14:37:19 +0200
Message-ID: <828780e3286b7b48b6be48cea9447f9d@swip.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

I have an AMD K7 machine with an 8way RADI5 array on a Marvell based
controller (sata_mv). When data is coming in over the Gigabit nic and
is written to disk, messages like the one below intermittently shows
up on the console. Eventually the machine freezes solid (hardware reset
required).

Kernel is 2.6.18 from kernel.org.

Any idea what is going on?

Regards,
  Fredrik Lindgren

kernel: md0_raid5: page allocation failure. order:0, mode:0x20
kernel:  <c013e17f> __alloc_pages+0x21f/0x310  <c0154415>
kmem_getpages+0x35/0xa0
kernel:  <c0155112> cache_grow+0xa2/0x160  <c01552fe>
cache_alloc_refill+0x12e/0x1c0
kernel:  <c01556e9> __kmalloc+0x69/0x70  <c03067e5>
__alloc_skb+0x55/0x110
kernel:  <c02a805f> skge_poll+0x41f/0x4c0  <c030cb3a>
net_rx_action+0x6a/0xe0
kernel:  <c011bebd> __do_softirq+0x7d/0x90  <c011bef6>
do_softirq+0x26/0x30
kernel:  <c0104ebe> do_IRQ+0x1e/0x30  <c01031be>
common_interrupt+0x1a/0x20
kernel:  <c02e6266> handle_stripe+0x6d6/0x1650  <c036f890>
schedule+0x310/0x5c0
kernel:  <c02e82a6> raid5d+0x86/0xe0  <c02f254e> md_thread+0x5e/0x130
kernel:  <c01297a0> autoremove_wake_function+0x0/0x60  <c01297a0>
autoremove_wake_function+0x0/0x60
kernel:  <c02f24f0> md_thread+0x0/0x130  <c01293b1> kthread+0xb1/0xc0
kernel:  <c0129300> kthread+0x0/0xc0  <c010139d>
kernel_thread_helper+0x5/0x18
kernel: Mem-info:
kernel: DMA per-cpu:
kernel: cpu 0 hot: high 0, batch 1 used:0
kernel: cpu 0 cold: high 0, batch 1 used:0
kernel: DMA32 per-cpu: empty
kernel: Normal per-cpu:
kernel: cpu 0 hot: high 186, batch 31 used:30
kernel: cpu 0 cold: high 62, batch 15 used:55
kernel: HighMem per-cpu: empty
kernel: Free pages:        4240kB (0kB HighMem)
kernel: Active:38133 inactive:139270 dirty:19647 writeback:10 unstable:0
free:1060 slab:12120 mapped:6183 pagetables:236
kernel: DMA free:3032kB min:72kB low:88kB high:108kB active:36kB
inactive:8624kB present:16384kB pages_scanned:0 all_unreclaimable? no
kernel: lowmem_reserve[]: 0 0 751 751
kernel: DMA32 free:0kB min:0kB low:0kB high:0kB active:0kB inactive:0kB
present:0kB pages_scanned:0 all_unreclaimable? no
kernel: lowmem_reserve[]: 0 0 751 751
kernel: Normal free:1208kB min:3468kB low:4332kB high:5200kB
active:152496kB inactive:548456kB present:769984kB pages_scanned:0
all_unreclaimable? no
kernel: lowmem_reserve[]: 0 0 0 0
kernel: HighMem free:0kB min:128kB low:128kB high:128kB active:0kB
inactive:0kB present:0kB pages_scanned:0 all_unreclaimable? no
kernel: lowmem_reserve[]: 0 0 0 0
kernel: DMA: 0*4kB 1*8kB 1*16kB 0*32kB 1*64kB 1*128kB 1*256kB 1*512kB
0*1024kB 1*2048kB 0*4096kB = 3032kB
kernel: DMA32: empty
kernel: Normal: 0*4kB 1*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB
1*1024kB 0*2048kB 0*4096kB = 1208kB
kernel: HighMem: empty
kernel: Swap cache: add 16, delete 16, find 0/0, race 0+0
kernel: Free swap  = 610364kB
kernel: Total swap = 610428kB
kernel: Free swap:       610364kB
kernel: 196592 pages of RAM
kernel: 0 pages of HIGHMEM
kernel: 2725 reserved pages
kernel: 178867 pages shared
kernel: 0 pages swap cached
kernel: 19647 pages dirty
kernel: 10 pages writeback
kernel: 6183 pages mapped
kernel: 12120 pages slab
kernel: 236 pages pagetables

pdflush: page allocation failure. order:0, mode:0x20
 [<c0130aea>] __alloc_pages+0x264/0x276
 [<c012b749>] handle_IRQ_event+0x21/0x49
 [<c014228b>] kmem_getpages+0x37/0x8b
 [<c0142d79>] cache_grow+0x97/0x126
 [<c0142f2f>] cache_alloc_refill+0x127/0x160
 [<c014321b>] __kmalloc+0x56/0x65
 [<c02bef4b>] __alloc_skb+0x49/0xf6
 [<c0261eb3>] skge_poll+0x1d1/0x42f
 [<c02c473a>] net_rx_action+0x5d/0x11b
 [<c0116ecf>] __do_softirq+0x34/0x73
 [<c0116f30>] do_softirq+0x22/0x26
 [<c010417e>] do_IRQ+0x45/0x4d
 [<c0102c76>] common_interrupt+0x1a/0x20
 [<c0273972>] scsi_done+0x0/0x1c
 [<c027391e>] scsi_dispatch_cmd+0x17d/0x1b5
 [<c0277834>] scsi_request_fn+0x1f3/0x255
 [<c01f0c6f>] __generic_unplug_device+0x1e/0x21
 [<c01f0c7c>] generic_unplug_device+0xa/0xd
 [<c02a330b>] unplug_slaves+0x4e/0x81
 [<c029f54f>] get_active_stripe+0x18d/0x242
 [<c0110237>] default_wake_function+0x0/0x12
 [<c02a35aa>] make_request+0x191/0x305
 [<c01225be>] autoremove_wake_function+0x0/0x3a
 [<c01225be>] autoremove_wake_function+0x0/0x3a
 [<c01f2056>] generic_make_request+0xf1/0x103
 [<c0149653>] bio_clone+0x2f/0x36
 [<c02b1c87>] __map_bio+0x39/0x7b
 [<c02b1e88>] __clone_and_map+0xc7/0x2d2
 [<c012f66f>] mempool_alloc+0x21/0xaa
 [<c0262036>] skge_poll+0x354/0x42f
 [<c02b213d>] __split_bio+0xaa/0xd3
 [<c02b21f2>] dm_request+0x8c/0x9b
 [<c01f2056>] generic_make_request+0xf1/0x103
 [<c0149653>] bio_clone+0x2f/0x36
 [<c02b1c87>] __map_bio+0x39/0x7b
 [<c02b1e88>] __clone_and_map+0xc7/0x2d2
 [<c012f66f>] mempool_alloc+0x21/0xaa
 [<c02b213d>] __split_bio+0xaa/0xd3
 [<c02b21f2>] dm_request+0x8c/0x9b
 [<c01f2056>] generic_make_request+0xf1/0x103
 [<c01f2108>] submit_bio+0xa0/0xa8
 [<c014942b>] bio_alloc_bioset+0xaf/0x10c
 [<c0148f29>] submit_bh+0x128/0x155
 [<c018f490>] submit_ordered_buffer+0x28/0x2b
 [<c018f562>] write_ordered_chunk+0x28/0x4d
 [<c018f5c0>] add_to_chunk+0x39/0x3e
 [<c018f857>] write_ordered_buffers+0x113/0x1e0
 [<c018f53a>] write_ordered_chunk+0x0/0x4d
 [<c0116ecf>] __do_softirq+0x34/0x73
 [<c018fb09>] flush_commit_list+0xd9/0x40e
 [<c01102ab>] __wake_up+0x14/0x1e
 [<c0193b85>] do_journal_end+0x881/0x8b7
 [<c0192bae>] journal_end_sync+0x61/0x67
 [<c0184331>] reiserfs_sync_fs+0x2c/0x46
 [<c0184356>] reiserfs_write_super+0xb/0xe
 [<c014a8f4>] sync_supers+0x5c/0xa4
 [<c01315fd>] wb_kupdate+0x21/0xd4
 [<c0131d74>] pdflush+0x0/0x2e
 [<c0131cf2>] __pdflush+0xb2/0x134
 [<c0131d9e>] pdflush+0x2a/0x2e
 [<c01315dc>] wb_kupdate+0x0/0xd4
 [<c0131d74>] pdflush+0x0/0x2e
 [<c01222de>] kthread+0x7c/0xa2
 [<c0122262>] kthread+0x0/0xa2
 [<c01012e9>] kernel_thread_helper+0x5/0xb
Mem-info:
DMA per-cpu:
cpu 0 hot: high 0, batch 1 used:0
cpu 0 cold: high 0, batch 1 used:0
DMA32 per-cpu: empty
Normal per-cpu:
cpu 0 hot: high 186, batch 31 used:30
cpu 0 cold: high 62, batch 15 used:52
HighMem per-cpu: empty
Free pages:        4232kB (0kB HighMem)
Active:38596 inactive:138349 dirty:20575 writeback:18 unstable:0
free:1058 slab:12653 mapped:2553 pagetables:249
DMA free:3032kB min:72kB low:88kB high:108kB active:1152kB
inactive:7268kB present:16384kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 751 751
DMA32 free:0kB min:0kB low:0kB high:0kB active:0kB inactive:0kB
present:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 751 751
Normal free:1200kB min:3468kB low:4332kB high:5200kB active:153232kB
inactive:546128kB present:769984kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
HighMem free:0kB min:128kB low:128kB high:128kB active:0kB inactive:0kB
present:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 0*4kB 1*8kB 1*16kB 0*32kB 1*64kB 1*128kB 1*256kB 1*512kB 0*1024kB
1*2048kB 0*4096kB = 3032kB
DMA32: empty
Normal: 0*4kB 0*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB
1*1024kB 0*2048kB 0*4096kB = 1200kB
HighMem: empty
Swap cache: add 16, delete 16, find 0/0, race 0+0
Free swap  = 610364kB
Total swap = 610428kB
Free swap:       610364kB
196592 pages of RAM
0 pages of HIGHMEM
2660 reserved pages
159429 pages shared
0 pages swap cached
20575 pages dirty
18 pages writeback
2553 pages mapped
12653 pages slab
249 pages pagetables



