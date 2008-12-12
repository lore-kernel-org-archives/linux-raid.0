From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: 2.6.27.8: OOM killer: [swapper: page allocation failure]
Date: Fri, 12 Dec 2008 07:14:26 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0812120708080.9826@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

Kernel: 2.6.27.8

I have a RAID-6 volume with 6 disks:
mdadm --create -v /dev/md0 --level=6 -n 6 -e 0.90 /dev/sd[e-j]1

While it is building...

# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md0 : active raid6 sdj1[5] sdi1[4] sdh1[3] sdg1[2] sdf1[1] sde1[0]
       1562834944 blocks level 6, 64k chunk, algorithm 2 [6/6] [UUUUUU]
       [===>.................]  resync = 19.0% (74237440/390708736) 
finish=346.7min speed=15208K/sec

unused devices: <none>

During this time, I am copying files to it at ~60-100MiB/s using 2 
rsyncs over NFS from 2 separate machines => this one [over the 
network] (on a pci-e x1 / built-in to the motherboard).

top output:
top - 07:10:06 up 12:32, 30 users,  load average: 3.46, 4.49, 4.39
Tasks: 316 total,   2 running, 313 sleeping,   1 stopped,   0 zombie
Cpu(s): 12.1%us,  3.7%sy,  0.0%ni, 32.5%id, 49.2%wa,  1.1%hi,  1.2%si,  0.0%st
Mem:   8100836k total,  8057480k used,    43356k free,        0k buffers
Swap: 16787884k total,      144k used, 16787740k free,  6609412k cached

   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
  5349 root      15  -5     0    0    0 R   10  0.0  11:59.94 md0_raid5
     1 root      20   0 10312  748  620 S    0  0.0   0:02.14 init

I see this over and over in the kernel log (maybe it will stop when the RAID6
rebuild is completed)?  So far, my rsyncs are continuing just fine and 
nothing except klogd/swapper processes have been killed.

[44893.846532] swapper: page allocation failure. order:0, mode:0x20
[44893.846538] Pid: 0, comm: swapper Not tainted 2.6.27.8 #2
[44893.846540] 
[44893.846540] Call Trace:
[44893.846542]  <IRQ>  [<ffffffff80279d4d>] __alloc_pages_internal+0x3cd/0x4d0
[44893.846551]  [<ffffffff8029876b>] cache_alloc_refill+0x2fb/0x570
[44893.846553]  [<ffffffff80298abb>] __kmalloc+0xdb/0xe0
[44893.846557]  [<ffffffff8058289d>] __alloc_skb+0x6d/0x150
[44893.846559]  [<ffffffff80583407>] __netdev_alloc_skb+0x17/0x40
[44893.846563]  [<ffffffff804a248b>] e1000_alloc_rx_buffers+0x25b/0x2e0
[44893.846565]  [<ffffffff804a27c0>] e1000_clean_rx_irq+0x240/0x380
[44893.846567]  [<ffffffff804a06bc>] e1000_clean+0x1fc/0x580
[44893.846570]  [<ffffffff80586922>] net_rx_action+0xe2/0x1c0
[44893.846573]  [<ffffffff8024f843>] __do_softirq+0x73/0xf0
[44893.846576]  [<ffffffff80227f6c>] call_softirq+0x1c/0x30
[44893.846578]  [<ffffffff80229f55>] do_softirq+0x35/0x70
[44893.846580]  [<ffffffff8022a041>] do_IRQ+0x81/0x100
[44893.846583]  [<ffffffff80227231>] ret_from_intr+0x0/0xa
[44893.846584]  <EOI>  [<ffffffff8022e6fc>] mwait_idle+0x3c/0x50
[44893.846588]  [<ffffffff80225d6c>] cpu_idle+0x5c/0x90
[44893.846590] 
[44893.846591] Mem-Info:
[44893.846592] DMA per-cpu:
[44893.846594] CPU    0: hi:    0, btch:   1 usd:   0
[44893.846595] CPU    1: hi:    0, btch:   1 usd:   0
[44893.846596] CPU    2: hi:    0, btch:   1 usd:   0
[44893.846597] CPU    3: hi:    0, btch:   1 usd:   0
[44893.846599] DMA32 per-cpu:
[44893.846600] CPU    0: hi:  186, btch:  31 usd: 161
[44893.846601] CPU    1: hi:  186, btch:  31 usd: 147
[44893.846603] CPU    2: hi:  186, btch:  31 usd: 148
[44893.846604] CPU    3: hi:  186, btch:  31 usd:  60
[44893.846605] Normal per-cpu:
[44893.846606] CPU    0: hi:  186, btch:  31 usd: 163
[44893.846608] CPU    1: hi:  186, btch:  31 usd: 133
[44893.846609] CPU    2: hi:  186, btch:  31 usd: 154
[44893.846610] CPU    3: hi:  186, btch:  31 usd: 136
[44893.846613] Active:177512 inactive:1632212 dirty:123783 writeback:12575 unstable:0
[44893.846613]  free:8218 slab:67444 mapped:17064 pagetables:6184 bounce:0
[44893.846616] DMA free:9840kB min:12kB low:12kB high:16kB active:0kB inactive:0kB present:8856kB pages_scanned:0 all_unreclaimable? yes
[44893.846618] lowmem_reserve[]: 0 3246 7980 7980
[44893.846622] DMA32 free:20608kB min:4648kB low:5808kB high:6972kB active:11052kB inactive:2720072kB present:3324312kB pages_scanned:0 all_unreclaimable? no
[44893.846624] lowmem_reserve[]: 0 0 4734 4734
[44893.846627] Normal free:2424kB min:6776kB low:8468kB high:10164kB active:698996kB inactive:3808776kB present:4848000kB pages_scanned:0 all_unreclaimable? no
[44893.846629] lowmem_reserve[]: 0 0 0 0
[44893.846632] DMA: 4*4kB 6*8kB 3*16kB 2*32kB 1*64kB 3*128kB 2*256kB 1*512kB 2*1024kB 1*2048kB 1*4096kB = 9840kB
[44893.846639] DMA32: 103*4kB 67*8kB 118*16kB 64*32kB 25*64kB 13*128kB 16*256kB 0*512kB 0*1024kB 0*2048kB 2*4096kB = 20436kB
[44893.846646] Normal: 1*4kB 0*8kB 1*16kB 1*32kB 0*64kB 0*128kB 0*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 2612kB
[44893.846652] 1650772 total pagecache pages
[44893.846654] 0 pages in swap cache
[44893.846655] Swap cache stats: add 97, delete 97, find 22/29
[44893.846657] Free swap  = 16787740kB
[44893.846658] Total swap = 16787884kB
[44893.847416] 2277376 pages RAM
[44893.847416] 252168 pages reserved
[44893.847416] 1794248 pages shared
[44893.847416] 324800 pages non-shared
[44893.879954] swapper: page allocation failure. order:0, mode:0x20
[44893.879958] Pid: 0, comm: swapper Not tainted 2.6.27.8 #2
[44893.879959] 
[44893.879960] Call Trace:
[44893.879961]  <IRQ>  [<ffffffff80279d4d>] __alloc_pages_internal+0x3cd/0x4d0
[44893.879969]  [<ffffffff8029876b>] cache_alloc_refill+0x2fb/0x570
[44893.879971]  [<ffffffff80298abb>] __kmalloc+0xdb/0xe0
[44893.879974]  [<ffffffff8058289d>] __alloc_skb+0x6d/0x150
[44893.879976]  [<ffffffff80583407>] __netdev_alloc_skb+0x17/0x40
[44893.879980]  [<ffffffff804a248b>] e1000_alloc_rx_buffers+0x25b/0x2e0
[44893.879982]  [<ffffffff804a27c0>] e1000_clean_rx_irq+0x240/0x380
[44893.879984]  [<ffffffff804a06bc>] e1000_clean+0x1fc/0x580
[44893.879987]  [<ffffffff80586922>] net_rx_action+0xe2/0x1c0
[44893.879989]  [<ffffffff8024f843>] __do_softirq+0x73/0xf0
[44893.879992]  [<ffffffff80227f6c>] call_softirq+0x1c/0x30
[44893.879994]  [<ffffffff80229f55>] do_softirq+0x35/0x70
[44893.879996]  [<ffffffff8022a041>] do_IRQ+0x81/0x100
[44893.879999]  [<ffffffff80227231>] ret_from_intr+0x0/0xa
[44893.880000]  <EOI>  [<ffffffff8022e6fc>] mwait_idle+0x3c/0x50
[44893.880004]  [<ffffffff80225d6c>] cpu_idle+0x5c/0x90
[44893.880005] 
[44893.880006] Mem-Info:
[44893.880007] DMA per-cpu:
[44893.880009] CPU    0: hi:    0, btch:   1 usd:   0
[44893.880010] CPU    1: hi:    0, btch:   1 usd:   0
[44893.880012] CPU    2: hi:    0, btch:   1 usd:   0
[44893.880013] CPU    3: hi:    0, btch:   1 usd:   0
[44893.880014] DMA32 per-cpu:
[44893.880015] CPU    0: hi:  186, btch:  31 usd: 161
[44893.880017] CPU    1: hi:  186, btch:  31 usd: 147
[44893.880018] CPU    2: hi:  186, btch:  31 usd: 148
[44893.880019] CPU    3: hi:  186, btch:  31 usd:  60
[44893.880021] Normal per-cpu:
[44893.880022] CPU    0: hi:  186, btch:  31 usd: 163
[44893.880023] CPU    1: hi:  186, btch:  31 usd: 133
[44893.880025] CPU    2: hi:  186, btch:  31 usd: 154
[44893.880026] CPU    3: hi:  186, btch:  31 usd: 136
[44893.880028] Active:177512 inactive:1632212 dirty:123783 writeback:12575 unstable:0
[44893.880029]  free:8218 slab:67444 mapped:17064 pagetables:6184 bounce:0
[44893.880041] DMA free:9840kB min:12kB low:12kB high:16kB active:0kB inactive:0kB present:8856kB pages_scanned:0 all_unreclaimable? yes
[44893.880043] lowmem_reserve[]: 0 3246 7980 7980
[44893.880047] DMA32 free:20608kB min:4648kB low:5808kB high:6972kB active:11052kB inactive:2720072kB present:3324312kB pages_scanned:0 all_unreclaimable? no
[44893.880049] lowmem_reserve[]: 0 0 4734 4734
[44893.880052] Normal free:2424kB min:6776kB low:8468kB high:10164kB active:698996kB inactive:3808776kB present:4848000kB pages_scanned:0 all_unreclaimable? no
[44893.880054] lowmem_reserve[]: 0 0 0 0
[44893.880057] DMA: 4*4kB 6*8kB 3*16kB 2*32kB 1*64kB 3*128kB 2*256kB 1*512kB 2*1024kB 1*2048kB 1*4096kB = 9840kB
[44893.880063] DMA32: 103*4kB 67*8kB 118*16kB 64*32kB 25*64kB 13*128kB 16*256kB 0*512kB 0*1024kB 0*2048kB 2*4096kB = 20436kB
[44893.880070] Normal: 1*4kB 0*8kB 1*16kB 1*32kB 0*64kB 0*128kB 0*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 2612kB
[44893.880076] 1650772 total pagecache pages
[44893.880078] 0 pages in swap cache
[44893.880079] Swap cache stats: add 97, delete 97, find 22/29
[44893.880081] Free swap  = 16787740kB
[44893.880082] Total swap = 16787884kB
[44893.909276] 2277376 pages RAM
[44893.909276] 252168 pages reserved
[44893.909276] 1793705 pages shared
[44893.909276] 324799 pages non-shared
[44917.678986] swapper: page allocation failure. order:0, mode:0x20
[44917.678993] Pid: 0, comm: swapper Not tainted 2.6.27.8 #2
[44917.678995] 
[44917.678995] Call Trace:
[44917.678997]  <IRQ>  [<ffffffff80279d4d>] __alloc_pages_internal+0x3cd/0x4d0
[44917.679016]  [<ffffffff8029876b>] cache_alloc_refill+0x2fb/0x570
[44917.679018]  [<ffffffff80298abb>] __kmalloc+0xdb/0xe0
[44917.679021]  [<ffffffff8058289d>] __alloc_skb+0x6d/0x150
[44917.679023]  [<ffffffff80583407>] __netdev_alloc_skb+0x17/0x40
[44917.679027]  [<ffffffff804a248b>] e1000_alloc_rx_buffers+0x25b/0x2e0
[44917.679029]  [<ffffffff804a27c0>] e1000_clean_rx_irq+0x240/0x380
[44917.679031]  [<ffffffff804a06bc>] e1000_clean+0x1fc/0x580
[44917.679034]  [<ffffffff80586922>] net_rx_action+0xe2/0x1c0
[44917.679037]  [<ffffffff8024f843>] __do_softirq+0x73/0xf0
[44917.679039]  [<ffffffff80227f6c>] call_softirq+0x1c/0x30
[44917.679041]  [<ffffffff80229f55>] do_softirq+0x35/0x70
[44917.679043]  [<ffffffff8022a041>] do_IRQ+0x81/0x100
[44917.679046]  [<ffffffff80227231>] ret_from_intr+0x0/0xa
[44917.679047]  <EOI>  [<ffffffff8022e6fc>] mwait_idle+0x3c/0x50
[44917.679051]  [<ffffffff80225d6c>] cpu_idle+0x5c/0x90
[44917.679053] 
[44917.679054] Mem-Info:
[44917.679055] DMA per-cpu:
[44917.679057] CPU    0: hi:    0, btch:   1 usd:   0
[44917.679058] CPU    1: hi:    0, btch:   1 usd:   0
[44917.679059] CPU    2: hi:    0, btch:   1 usd:   0
[44917.679061] CPU    3: hi:    0, btch:   1 usd:   0
[44917.679071] DMA32 per-cpu:
[44917.679072] CPU    0: hi:  186, btch:  31 usd: 134
[44917.679074] CPU    1: hi:  186, btch:  31 usd: 166
[44917.679075] CPU    2: hi:  186, btch:  31 usd:  38
[44917.679076] CPU    3: hi:  186, btch:  31 usd:  60
[44917.679078] Normal per-cpu:
[44917.679079] CPU    0: hi:  186, btch:  31 usd: 176
[44917.679080] CPU    1: hi:  186, btch:  31 usd: 174
[44917.679082] CPU    2: hi:  186, btch:  31 usd: 166
[44917.679083] CPU    3: hi:  186, btch:  31 usd:  80
[44917.679085] Active:177374 inactive:1632476 dirty:107268 writeback:0 unstable:0
[44917.679086]  free:8229 slab:67289 mapped:17064 pagetables:6184 bounce:0
[44917.679089] DMA free:9840kB min:12kB low:12kB high:16kB active:0kB inactive:0kB present:8856kB pages_scanned:0 all_unreclaimable? yes
[44917.679090] lowmem_reserve[]: 0 3246 7980 7980
[44917.679094] DMA32 free:20536kB min:4648kB low:5808kB high:6972kB active:10384kB inactive:2721396kB present:3324312kB pages_scanned:32 all_unreclaimable? no
[44917.679096] lowmem_reserve[]: 0 0 4734 4734
[44917.679100] Normal free:2540kB min:6776kB low:8468kB high:10164kB active:699112kB inactive:3808508kB present:4848000kB pages_scanned:0 all_unreclaimable? no
[44917.679102] lowmem_reserve[]: 0 0 0 0
[44917.679105] DMA: 4*4kB 6*8kB 3*16kB 2*32kB 1*64kB 3*128kB 2*256kB 1*512kB 2*1024kB 1*2048kB 1*4096kB = 9840kB
[44917.679112] DMA32: 49*4kB 58*8kB 156*16kB 63*32kB 24*64kB 16*128kB 14*256kB 0*512kB 0*1024kB 0*2048kB 2*4096kB = 20532kB
[44917.679118] Normal: 1*4kB 1*8kB 1*16kB 1*32kB 0*64kB 1*128kB 1*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 2492kB
[44917.679125] 1650898 total pagecache pages
[44917.679127] 0 pages in swap cache
[44917.679128] Swap cache stats: add 97, delete 97, find 22/29
[44917.679129] Free swap  = 16787740kB
[44917.679131] Total swap = 16787884kB
[44917.702907] 2277376 pages RAM
[44917.702907] 252168 pages reserved
[44917.702907] 1793569 pages shared
[44917.702907] 324682 pages non-shared
[44924.938137] swapper: page allocation failure. order:0, mode:0x20
[44924.938145] Pid: 0, comm: swapper Not tainted 2.6.27.8 #2
[44924.938147] 
[44924.938147] Call Trace:
[44924.938149]  <IRQ>  [<ffffffff80279d4d>] __alloc_pages_internal+0x3cd/0x4d0
[44924.938160]  [<ffffffff8029876b>] cache_alloc_refill+0x2fb/0x570
[44924.938163]  [<ffffffff80298abb>] __kmalloc+0xdb/0xe0
[44924.938166]  [<ffffffff8058289d>] __alloc_skb+0x6d/0x150
[44924.938168]  [<ffffffff80583407>] __netdev_alloc_skb+0x17/0x40
[44924.938172]  [<ffffffff804a248b>] e1000_alloc_rx_buffers+0x25b/0x2e0
[44924.938174]  [<ffffffff804a27c0>] e1000_clean_rx_irq+0x240/0x380
[44924.938176]  [<ffffffff804a06bc>] e1000_clean+0x1fc/0x580
[44924.938179]  [<ffffffff80586922>] net_rx_action+0xe2/0x1c0
[44924.938183]  [<ffffffff8024f843>] __do_softirq+0x73/0xf0
[44924.938185]  [<ffffffff80227f6c>] call_softirq+0x1c/0x30
[44924.938188]  [<ffffffff80229f55>] do_softirq+0x35/0x70
[44924.938190]  [<ffffffff8022a041>] do_IRQ+0x81/0x100
[44924.938192]  [<ffffffff80227231>] ret_from_intr+0x0/0xa
[44924.938194]  <EOI>  [<ffffffff8022e6fc>] mwait_idle+0x3c/0x50
[44924.938199]  [<ffffffff80225d6c>] cpu_idle+0x5c/0x90
[44924.938200] 
[44924.938201] Mem-Info:
[44924.938203] DMA per-cpu:
[44924.938205] CPU    0: hi:    0, btch:   1 usd:   0
[44924.938206] CPU    1: hi:    0, btch:   1 usd:   0
[44924.938208] CPU    2: hi:    0, btch:   1 usd:   0
[44924.938209] CPU    3: hi:    0, btch:   1 usd:   0
[44924.938210] DMA32 per-cpu:
[44924.938211] CPU    0: hi:  186, btch:  31 usd: 157
[44924.938213] CPU    1: hi:  186, btch:  31 usd: 168
[44924.938214] CPU    2: hi:  186, btch:  31 usd: 182
[44924.938215] CPU    3: hi:  186, btch:  31 usd:  60
[44924.938217] Normal per-cpu:
[44924.938218] CPU    0: hi:  186, btch:  31 usd: 172
[44924.938219] CPU    1: hi:  186, btch:  31 usd: 167
[44924.938221] CPU    2: hi:  186, btch:  31 usd: 155
[44924.938222] CPU    3: hi:  186, btch:  31 usd: 115
[44924.938224] Active:177396 inactive:1632670 dirty:115546 writeback:2 unstable:0
[44924.938225]  free:8215 slab:66903 mapped:17067 pagetables:6207 bounce:0
[44924.938228] DMA free:9840kB min:12kB low:12kB high:16kB active:0kB inactive:0kB present:8856kB pages_scanned:0 all_unreclaimable? yes
[44924.938230] lowmem_reserve[]: 0 3246 7980 7980
[44924.938234] DMA32 free:20576kB min:4648kB low:5808kB high:6972kB active:10632kB inactive:2720344kB present:3324312kB pages_scanned:0 all_unreclaimable? no
[44924.938236] lowmem_reserve[]: 0 0 4734 4734
[44924.938240] Normal free:2444kB min:6776kB low:8468kB high:10164kB active:698952kB inactive:3810336kB present:4848000kB pages_scanned:0 all_unreclaimable? no
[44924.938242] lowmem_reserve[]: 0 0 0 0
[44924.938244] DMA: 4*4kB 6*8kB 3*16kB 2*32kB 1*64kB 3*128kB 2*256kB 1*512kB 2*1024kB 1*2048kB 1*4096kB = 9840kB
[44924.938251] DMA32: 89*4kB 115*8kB 161*16kB 49*32kB 20*64kB 18*128kB 13*256kB 0*512kB 0*1024kB 0*2048kB 2*4096kB = 20524kB
[44924.938258] Normal: 0*4kB 1*8kB 1*16kB 1*32kB 0*64kB 0*128kB 0*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 2616kB
[44924.938265] 1651063 total pagecache pages
[44924.938266] 0 pages in swap cache
[44924.938268] Swap cache stats: add 97, delete 97, find 22/29
[44924.938269] Free swap  = 16787740kB
[44924.938270] Total swap = 16787884kB
[44924.938715] 2277376 pages RAM
[44924.938715] 252168 pages reserved
[44924.938715] 1794949 pages shared
[44924.938715] 324423 pages non-shared
[44924.974122] swapper: page allocation failure. order:0, mode:0x20
[44924.974126] Pid: 0, comm: swapper Not tainted 2.6.27.8 #2
[44924.974127] 
[44924.974128] Call Trace:
[44924.974130]  <IRQ>  [<ffffffff80279d4d>] __alloc_pages_internal+0x3cd/0x4d0
[44924.974139]  [<ffffffff8029876b>] cache_alloc_refill+0x2fb/0x570
[44924.974141]  [<ffffffff80298abb>] __kmalloc+0xdb/0xe0
[44924.974145]  [<ffffffff8058289d>] __alloc_skb+0x6d/0x150
[44924.974148]  [<ffffffff80583407>] __netdev_alloc_skb+0x17/0x40
[44924.974152]  [<ffffffff804a248b>] e1000_alloc_rx_buffers+0x25b/0x2e0
[44924.974154]  [<ffffffff804a27c0>] e1000_clean_rx_irq+0x240/0x380
[44924.974156]  [<ffffffff804a06bc>] e1000_clean+0x1fc/0x580
[44924.974159]  [<ffffffff80586922>] net_rx_action+0xe2/0x1c0
[44924.974162]  [<ffffffff8024f843>] __do_softirq+0x73/0xf0
[44924.974165]  [<ffffffff80227f6c>] call_softirq+0x1c/0x30
[44924.974167]  [<ffffffff80229f55>] do_softirq+0x35/0x70
[44924.974169]  [<ffffffff8022a041>] do_IRQ+0x81/0x100
[44924.974173]  [<ffffffff80227231>] ret_from_intr+0x0/0xa
[44924.974174]  <EOI>  [<ffffffff8022e6fc>] mwait_idle+0x3c/0x50
[44924.974179]  [<ffffffff80225d6c>] cpu_idle+0x5c/0x90
[44924.974180] 
[44924.974181] Mem-Info:
[44924.974182] DMA per-cpu:
[44924.974184] CPU    0: hi:    0, btch:   1 usd:   0
[44924.974185] CPU    1: hi:    0, btch:   1 usd:   0
[44924.974187] CPU    2: hi:    0, btch:   1 usd:   0
[44924.974188] CPU    3: hi:    0, btch:   1 usd:   0
[44924.974189] DMA32 per-cpu:
[44924.974191] CPU    0: hi:  186, btch:  31 usd: 157
[44924.974192] CPU    1: hi:  186, btch:  31 usd: 168
[44924.974193] CPU    2: hi:  186, btch:  31 usd: 182
[44924.974195] CPU    3: hi:  186, btch:  31 usd:  60
[44924.974196] Normal per-cpu:
[44924.974197] CPU    0: hi:  186, btch:  31 usd: 172
[44924.974198] CPU    1: hi:  186, btch:  31 usd: 167
[44924.974200] CPU    2: hi:  186, btch:  31 usd: 155
[44924.974201] CPU    3: hi:  186, btch:  31 usd: 115
[44924.974203] Active:177396 inactive:1632670 dirty:115546 writeback:2 unstable:0
[44924.974204]  free:8215 slab:66903 mapped:17067 pagetables:6207 bounce:0
[44924.974207] DMA free:9840kB min:12kB low:12kB high:16kB active:0kB inactive:0kB present:8856kB pages_scanned:0 all_unreclaimable? yes
[44924.974209] lowmem_reserve[]: 0 3246 7980 7980
[44924.974212] DMA32 free:20576kB min:4648kB low:5808kB high:6972kB active:10632kB inactive:2720344kB present:3324312kB pages_scanned:0 all_unreclaimable? no
[44924.974214] lowmem_reserve[]: 0 0 4734 4734
[44924.974218] Normal free:2444kB min:6776kB low:8468kB high:10164kB active:698952kB inactive:3810336kB present:4848000kB pages_scanned:0 all_unreclaimable? no
[44924.974220] lowmem_reserve[]: 0 0 0 0
[44924.974223] DMA: 4*4kB 6*8kB 3*16kB 2*32kB 1*64kB 3*128kB 2*256kB 1*512kB 2*1024kB 1*2048kB 1*4096kB = 9840kB
[44924.974229] DMA32: 89*4kB 115*8kB 161*16kB 49*32kB 20*64kB 18*128kB 13*256kB 0*512kB 0*1024kB 0*2048kB 2*4096kB = 20524kB
[44924.974236] Normal: 0*4kB 1*8kB 1*16kB 1*32kB 0*64kB 0*128kB 0*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 2616kB
[44924.974243] 1651063 total pagecache pages
[44924.974245] 0 pages in swap cache
[44924.974246] Swap cache stats: add 97, delete 97, find 22/29
[44924.974247] Free swap  = 16787740kB
[44924.974248] Total swap = 16787884kB
[44924.975001] 2277376 pages RAM
[44924.975001] 252168 pages reserved
[44924.975001] 1794042 pages shared
[44924.975001] 324423 pages non-shared
[44963.672563] swapper: page allocation failure. order:0, mode:0x20
[44963.672571] Pid: 0, comm: swapper Not tainted 2.6.27.8 #2
[44963.672574] 
[44963.672575] Call Trace:
[44963.672577]  <IRQ>  [<ffffffff80279d4d>] __alloc_pages_internal+0x3cd/0x4d0
[44963.672589]  [<ffffffff8029876b>] cache_alloc_refill+0x2fb/0x570
[44963.672593]  [<ffffffff80298abb>] __kmalloc+0xdb/0xe0
[44963.672597]  [<ffffffff8058289d>] __alloc_skb+0x6d/0x150
[44963.672601]  [<ffffffff80583407>] __netdev_alloc_skb+0x17/0x40
[44963.672605]  [<ffffffff804a248b>] e1000_alloc_rx_buffers+0x25b/0x2e0
[44963.672609]  [<ffffffff804a2833>] e1000_clean_rx_irq+0x2b3/0x380
[44963.672612]  [<ffffffff804a06bc>] e1000_clean+0x1fc/0x580
[44963.672616]  [<ffffffff80586922>] net_rx_action+0xe2/0x1c0
[44963.672620]  [<ffffffff8024f843>] __do_softirq+0x73/0xf0
[44963.672624]  [<ffffffff80227f6c>] call_softirq+0x1c/0x30
[44963.672627]  [<ffffffff80229f55>] do_softirq+0x35/0x70
[44963.672630]  [<ffffffff8022a041>] do_IRQ+0x81/0x100
[44963.672634]  [<ffffffff80227231>] ret_from_intr+0x0/0xa
[44963.672636]  <EOI>  [<ffffffff8022e6fc>] mwait_idle+0x3c/0x50
[44963.672642]  [<ffffffff80225d6c>] cpu_idle+0x5c/0x90
[44963.672644] 
[44963.672646] Mem-Info:
[44963.672647] DMA per-cpu:
[44963.672650] CPU    0: hi:    0, btch:   1 usd:   0
[44963.672652] CPU    1: hi:    0, btch:   1 usd:   0
[44963.672654] CPU    2: hi:    0, btch:   1 usd:   0
[44963.672656] CPU    3: hi:    0, btch:   1 usd:   0
[44963.672658] DMA32 per-cpu:
[44963.672660] CPU    0: hi:  186, btch:  31 usd: 142
[44963.672662] CPU    1: hi:  186, btch:  31 usd: 163
[44963.672664] CPU    2: hi:  186, btch:  31 usd: 163
[44963.672666] CPU    3: hi:  186, btch:  31 usd:  60
[44963.672667] Normal per-cpu:
[44963.672669] CPU    0: hi:  186, btch:  31 usd: 136
[44963.672671] CPU    1: hi:  186, btch:  31 usd: 177
[44963.672673] CPU    2: hi:  186, btch:  31 usd: 140
[44963.672675] CPU    3: hi:  186, btch:  31 usd:  74
[44963.672678] Active:169921 inactive:1640376 dirty:110482 writeback:385 unstable:0
[44963.672680]  free:8210 slab:66977 mapped:16894 pagetables:6051 bounce:0
[44963.672684] DMA free:9840kB min:12kB low:12kB high:16kB active:0kB inactive:0kB present:8856kB pages_scanned:0 all_unreclaimable? yes
[44963.672686] lowmem_reserve[]: 0 3246 7980 7980
[44963.672692] DMA32 free:20552kB min:4648kB low:5808kB high:6972kB active:3044kB inactive:2728908kB present:3324312kB pages_scanned:128 all_unreclaimable? no
[44963.672695] lowmem_reserve[]: 0 0 4734 4734
[44963.672700] Normal free:2448kB min:6776kB low:8468kB high:10164kB active:676640kB inactive:3832596kB present:4848000kB pages_scanned:0 all_unreclaimable? no
[44963.672703] lowmem_reserve[]: 0 0 0 0
[44963.672707] DMA: 4*4kB 6*8kB 3*16kB 2*32kB 1*64kB 3*128kB 2*256kB 1*512kB 2*1024kB 1*2048kB 1*4096kB = 9840kB
[44963.672717] DMA32: 51*4kB 224*8kB 165*16kB 44*32kB 14*64kB 12*128kB 15*256kB 0*512kB 0*1024kB 0*2048kB 2*4096kB = 20508kB
[44963.672728] Normal: 0*4kB 1*8kB 0*16kB 0*32kB 0*64kB 1*128kB 1*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 2440kB
[44963.672738] 1657643 total pagecache pages
[44963.672740] 0 pages in swap cache
[44963.672742] Swap cache stats: add 97, delete 97, find 22/29
[44963.672744] Free swap  = 16787740kB
[44963.672746] Total swap = 16787884kB
[44963.673416] 2277376 pages RAM
[44963.673416] 252168 pages reserved
[44963.673416] 1800155 pages shared
[44963.673416] 316622 pages non-shared
[44963.705763] swapper: page allocation failure. order:0, mode:0x20
[44963.705766] Pid: 0, comm: swapper Not tainted 2.6.27.8 #2
[44963.705768] 
[44963.705768] Call Trace:
[44963.705770]  <IRQ>  [<ffffffff80279d4d>] __alloc_pages_internal+0x3cd/0x4d0
[44963.705777]  [<ffffffff8029876b>] cache_alloc_refill+0x2fb/0x570
[44963.705780]  [<ffffffff80298abb>] __kmalloc+0xdb/0xe0
[44963.705783]  [<ffffffff8058289d>] __alloc_skb+0x6d/0x150
[44963.705785]  [<ffffffff80583407>] __netdev_alloc_skb+0x17/0x40
[44963.705788]  [<ffffffff804a248b>] e1000_alloc_rx_buffers+0x25b/0x2e0
[44963.705791]  [<ffffffff804a27c0>] e1000_clean_rx_irq+0x240/0x380
[44963.705793]  [<ffffffff804a06bc>] e1000_clean+0x1fc/0x580
[44963.705795]  [<ffffffff80586922>] net_rx_action+0xe2/0x1c0
[44963.705798]  [<ffffffff8024f843>] __do_softirq+0x73/0xf0
[44963.705801]  [<ffffffff80227f6c>] call_softirq+0x1c/0x30
[44963.705803]  [<ffffffff80229f55>] do_softirq+0x35/0x70
[44963.705804]  [<ffffffff8022a041>] do_IRQ+0x81/0x100
[44963.705807]  [<ffffffff80227231>] ret_from_intr+0x0/0xa
[44963.705808]  <EOI>  [<ffffffff8022e6fc>] mwait_idle+0x3c/0x50
[44963.705813]  [<ffffffff80225d6c>] cpu_idle+0x5c/0x90
[44963.705814] 
[44963.705815] Mem-Info:
[44963.705816] DMA per-cpu:
[44963.705818] CPU    0: hi:    0, btch:   1 usd:   0
[44963.705819] CPU    1: hi:    0, btch:   1 usd:   0
[44963.705820] CPU    2: hi:    0, btch:   1 usd:   0
[44963.705822] CPU    3: hi:    0, btch:   1 usd:   0
[44963.705823] DMA32 per-cpu:
[44963.705824] CPU    0: hi:  186, btch:  31 usd: 142
[44963.705825] CPU    1: hi:  186, btch:  31 usd: 163
[44963.705827] CPU    2: hi:  186, btch:  31 usd: 163
[44963.705828] CPU    3: hi:  186, btch:  31 usd:  60
[44963.705829] Normal per-cpu:
[44963.705830] CPU    0: hi:  186, btch:  31 usd: 136
[44963.705832] CPU    1: hi:  186, btch:  31 usd: 177
[44963.705833] CPU    2: hi:  186, btch:  31 usd: 140
[44963.705834] CPU    3: hi:  186, btch:  31 usd:  74
[44963.705837] Active:169921 inactive:1640376 dirty:110482 writeback:385 unstable:0
[44963.705838]  free:8210 slab:66977 mapped:16894 pagetables:6051 bounce:0
[44963.705840] DMA free:9840kB min:12kB low:12kB high:16kB active:0kB inactive:0kB present:8856kB pages_scanned:0 all_unreclaimable? yes
[44963.705842] lowmem_reserve[]: 0 3246 7980 7980
[44963.705846] DMA32 free:20552kB min:4648kB low:5808kB high:6972kB active:3044kB inactive:2728908kB present:3324312kB pages_scanned:128 all_unreclaimable? no
[44963.705847] lowmem_reserve[]: 0 0 4734 4734
[44963.705851] Normal free:2448kB min:6776kB low:8468kB high:10164kB active:676640kB inactive:3832596kB present:4848000kB pages_scanned:0 all_unreclaimable? no
[44963.705853] lowmem_reserve[]: 0 0 0 0
[44963.705856] DMA: 4*4kB 6*8kB 3*16kB 2*32kB 1*64kB 3*128kB 2*256kB 1*512kB 2*1024kB 1*2048kB 1*4096kB = 9840kB
[44963.705862] DMA32: 51*4kB 224*8kB 165*16kB 44*32kB 14*64kB 12*128kB 15*256kB 0*512kB 0*1024kB 0*2048kB 2*4096kB = 20508kB
[44963.705869] Normal: 0*4kB 1*8kB 0*16kB 0*32kB 0*64kB 1*128kB 1*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 2440kB
[44963.705875] 1657643 total pagecache pages
[44963.705877] 0 pages in swap cache
[44963.705878] Swap cache stats: add 97, delete 97, find 22/29
[44963.705879] Free swap  = 16787740kB
[44963.705881] Total swap = 16787884kB
[44963.740373] 2277376 pages RAM
[44963.740373] 252168 pages reserved
[44963.740373] 1799111 pages shared
[44963.740373] 316620 pages non-shared
[44964.758701] swapper: page allocation failure. order:0, mode:0x20
[44964.758708] Pid: 0, comm: swapper Not tainted 2.6.27.8 #2
[44964.758710] 
[44964.758711] Call Trace:
[44964.758712]  <IRQ>  [<ffffffff80279d4d>] __alloc_pages_internal+0x3cd/0x4d0
[44964.758720]  [<ffffffff8029876b>] cache_alloc_refill+0x2fb/0x570
[44964.758723]  [<ffffffff80298abb>] __kmalloc+0xdb/0xe0
[44964.758726]  [<ffffffff8058289d>] __alloc_skb+0x6d/0x150
[44964.758728]  [<ffffffff80583407>] __netdev_alloc_skb+0x17/0x40
[44964.758731]  [<ffffffff804a248b>] e1000_alloc_rx_buffers+0x25b/0x2e0
[44964.758734]  [<ffffffff804a2833>] e1000_clean_rx_irq+0x2b3/0x380
[44964.758736]  [<ffffffff804a06bc>] e1000_clean+0x1fc/0x580
[44964.758738]  [<ffffffff80586922>] net_rx_action+0xe2/0x1c0
[44964.758741]  [<ffffffff8024f843>] __do_softirq+0x73/0xf0
[44964.758743]  [<ffffffff80227f6c>] call_softirq+0x1c/0x30
[44964.758746]  [<ffffffff80229f55>] do_softirq+0x35/0x70
[44964.758747]  [<ffffffff8022a041>] do_IRQ+0x81/0x100
[44964.758750]  [<ffffffff80227231>] ret_from_intr+0x0/0xa
[44964.758751]  <EOI>  [<ffffffff8022e6fc>] mwait_idle+0x3c/0x50
[44964.758756]  [<ffffffff80225d6c>] cpu_idle+0x5c/0x90
[44964.758757] 
[44964.758758] Mem-Info:
[44964.758759] DMA per-cpu:
[44964.758761] CPU    0: hi:    0, btch:   1 usd:   0
[44964.758762] CPU    1: hi:    0, btch:   1 usd:   0
[44964.758763] CPU    2: hi:    0, btch:   1 usd:   0
[44964.758765] CPU    3: hi:    0, btch:   1 usd:   0
[44964.758766] DMA32 per-cpu:
[44964.758767] CPU    0: hi:  186, btch:  31 usd: 176
[44964.758768] CPU    1: hi:  186, btch:  31 usd: 179
[44964.758770] CPU    2: hi:  186, btch:  31 usd: 155
[44964.758771] CPU    3: hi:  186, btch:  31 usd:  60
[44964.758772] Normal per-cpu:
[44964.758774] CPU    0: hi:  186, btch:  31 usd: 149
[44964.758775] CPU    1: hi:  186, btch:  31 usd: 124
[44964.758776] CPU    2: hi:  186, btch:  31 usd: 171
[44964.758778] CPU    3: hi:  186, btch:  31 usd:  57
[44964.758780] Active:169922 inactive:1639872 dirty:109948 writeback:6806 unstable:0
[44964.758781]  free:8253 slab:67410 mapped:16894 pagetables:6051 bounce:0
[44964.758783] DMA free:9840kB min:12kB low:12kB high:16kB active:0kB inactive:0kB present:8856kB pages_scanned:0 all_unreclaimable? yes
[44964.758785] lowmem_reserve[]: 0 3246 7980 7980
[44964.758789] DMA32 free:20656kB min:4648kB low:5808kB high:6972kB active:3044kB inactive:2727668kB present:3324312kB pages_scanned:0 all_unreclaimable? no
[44964.758790] lowmem_reserve[]: 0 0 4734 4734
[44964.758794] Normal free:2516kB min:6776kB low:8468kB high:10164kB active:676644kB inactive:3831820kB present:4848000kB pages_scanned:0 all_unreclaimable? no
[44964.758796] lowmem_reserve[]: 0 0 0 0
[44964.758799] DMA: 4*4kB 6*8kB 3*16kB 2*32kB 1*64kB 3*128kB 2*256kB 1*512kB 2*1024kB 1*2048kB 1*4096kB = 9840kB
[44964.758805] DMA32: 82*4kB 54*8kB 178*16kB 46*32kB 31*64kB 12*128kB 15*256kB 0*512kB 0*1024kB 0*2048kB 2*4096kB = 20632kB
[44964.758812] Normal: 0*4kB 1*8kB 0*16kB 0*32kB 0*64kB 1*128kB 1*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 2440kB
[44964.758818] 1657214 total pagecache pages
[44964.758820] 0 pages in swap cache
[44964.758821] Swap cache stats: add 97, delete 97, find 22/29
[44964.758823] Free swap  = 16787740kB
[44964.758824] Total swap = 16787884kB
[44964.759416] 2277376 pages RAM
[44964.759416] 252168 pages reserved
[44964.759416] 1799772 pages shared
[44964.759416] 316945 pages non-shared
[44964.790088] swapper: page allocation failure. order:0, mode:0x20
[44964.790102] Pid: 0, comm: swapper Not tainted 2.6.27.8 #2
[44964.790104] 
[44964.790104] Call Trace:
[44964.790106]  <IRQ>  [<ffffffff80279d4d>] __alloc_pages_internal+0x3cd/0x4d0
[44964.790113]  [<ffffffff8029876b>] cache_alloc_refill+0x2fb/0x570
[44964.790116]  [<ffffffff80298abb>] __kmalloc+0xdb/0xe0
[44964.790119]  [<ffffffff8058289d>] __alloc_skb+0x6d/0x150
[44964.790121]  [<ffffffff80583407>] __netdev_alloc_skb+0x17/0x40
[44964.790124]  [<ffffffff804a248b>] e1000_alloc_rx_buffers+0x25b/0x2e0
[44964.790126]  [<ffffffff804a27c0>] e1000_clean_rx_irq+0x240/0x380
[44964.790128]  [<ffffffff804a06bc>] e1000_clean+0x1fc/0x580
[44964.790131]  [<ffffffff80586922>] net_rx_action+0xe2/0x1c0
[44964.790134]  [<ffffffff8024f843>] __do_softirq+0x73/0xf0
[44964.790136]  [<ffffffff80227f6c>] call_softirq+0x1c/0x30
[44964.790138]  [<ffffffff80229f55>] do_softirq+0x35/0x70
[44964.790140]  [<ffffffff8022a041>] do_IRQ+0x81/0x100
[44964.790143]  [<ffffffff80227231>] ret_from_intr+0x0/0xa
[44964.790144]  <EOI>  [<ffffffff8022e6fc>] mwait_idle+0x3c/0x50
[44964.790148]  [<ffffffff80225d6c>] cpu_idle+0x5c/0x90
[44964.790149] 
[44964.790150] Mem-Info:
[44964.790152] DMA per-cpu:
[44964.790153] CPU    0: hi:    0, btch:   1 usd:   0
[44964.790154] CPU    1: hi:    0, btch:   1 usd:   0
[44964.790156] CPU    2: hi:    0, btch:   1 usd:   0
[44964.790157] CPU    3: hi:    0, btch:   1 usd:   0
[44964.790158] DMA32 per-cpu:
[44964.790160] CPU    0: hi:  186, btch:  31 usd: 176
[44964.790161] CPU    1: hi:  186, btch:  31 usd: 179
[44964.790162] CPU    2: hi:  186, btch:  31 usd: 155
[44964.790164] CPU    3: hi:  186, btch:  31 usd:  60
[44964.790165] Normal per-cpu:
[44964.790166] CPU    0: hi:  186, btch:  31 usd: 149
[44964.790167] CPU    1: hi:  186, btch:  31 usd: 124
[44964.790169] CPU    2: hi:  186, btch:  31 usd: 171
[44964.790170] CPU    3: hi:  186, btch:  31 usd:  57
[44964.790172] Active:169922 inactive:1639872 dirty:109948 writeback:6806 unstable:0
[44964.790173]  free:8253 slab:67410 mapped:16894 pagetables:6051 bounce:0
[44964.790175] DMA free:9840kB min:12kB low:12kB high:16kB active:0kB inactive:0kB present:8856kB pages_scanned:0 all_unreclaimable? yes
[44964.790177] lowmem_reserve[]: 0 3246 7980 7980
[44964.790181] DMA32 free:20656kB min:4648kB low:5808kB high:6972kB active:3044kB inactive:2727668kB present:3324312kB pages_scanned:0 all_unreclaimable? no
[44964.790183] lowmem_reserve[]: 0 0 4734 4734
[44964.790186] Normal free:2516kB min:6776kB low:8468kB high:10164kB active:676644kB inactive:3831820kB present:4848000kB pages_scanned:0 all_unreclaimable? no
[44964.790188] lowmem_reserve[]: 0 0 0 0
[44964.790191] DMA: 4*4kB 6*8kB 3*16kB 2*32kB 1*64kB 3*128kB 2*256kB 1*512kB 2*1024kB 1*2048kB 1*4096kB = 9840kB
[44964.790197] DMA32: 82*4kB 54*8kB 178*16kB 46*32kB 31*64kB 12*128kB 15*256kB 0*512kB 0*1024kB 0*2048kB 2*4096kB = 20632kB
[44964.790204] Normal: 0*4kB 1*8kB 0*16kB 0*32kB 0*64kB 1*128kB 1*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 2440kB
[44964.790211] 1657214 total pagecache pages
[44964.790212] 0 pages in swap cache
[44964.790213] Swap cache stats: add 97, delete 97, find 22/29
[44964.790215] Free swap  = 16787740kB
[44964.790216] Total swap = 16787884kB
[44964.795397] 2277376 pages RAM
[44964.795397] 252168 pages reserved
[44964.795397] 1798806 pages shared
[44964.795397] 316944 pages non-shared
[44969.255405] swapper: page allocation failure. order:0, mode:0x20
[44969.255411] Pid: 0, comm: swapper Not tainted 2.6.27.8 #2
[44969.255413] 
[44969.255414] Call Trace:
[44969.255415]  <IRQ>  [<ffffffff80279d4d>] __alloc_pages_internal+0x3cd/0x4d0
[44969.255424]  [<ffffffff8029876b>] cache_alloc_refill+0x2fb/0x570
[44969.255426]  [<ffffffff80298abb>] __kmalloc+0xdb/0xe0
[44969.255426]  [<ffffffff8058289d>] __alloc_skb+0x6d/0x150
[44969.255426]  [<ffffffff80583407>] __netdev_alloc_skb+0x17/0x40
[44969.255426]  [<ffffffff804a248b>] e1000_alloc_rx_buffers+0x25b/0x2e0
[44969.255426]  [<ffffffff804a2833>] e1000_clean_rx_irq+0x2b3/0x380
[44969.255426]  [<ffffffff804a06bc>] e1000_clean+0x1fc/0x580
[44969.255426]  [<ffffffff80586922>] net_rx_action+0xe2/0x1c0
[44969.255426]  [<ffffffff8024f843>] __do_softirq+0x73/0xf0
[44969.255426]  [<ffffffff80227f6c>] call_softirq+0x1c/0x30
[44969.255426]  [<ffffffff80229f55>] do_softirq+0x35/0x70
[44969.255426]  [<ffffffff8022a041>] do_IRQ+0x81/0x100
[44969.255426]  [<ffffffff80227231>] ret_from_intr+0x0/0xa
[44969.255426]  <EOI>  [<ffffffff8022e6fc>] mwait_idle+0x3c/0x50
[44969.255426]  [<ffffffff80225d6c>] cpu_idle+0x5c/0x90
[44969.255426] 
[44969.255426] Mem-Info:
[44969.255426] DMA per-cpu:
[44969.255426] CPU    0: hi:    0, btch:   1 usd:   0
[44969.255426] CPU    1: hi:    0, btch:   1 usd:   0
[44969.255426] CPU    2: hi:    0, btch:   1 usd:   0
[44969.255426] CPU    3: hi:    0, btch:   1 usd:   0
[44969.255426] DMA32 per-cpu:
[44969.255426] CPU    0: hi:  186, btch:  31 usd: 168
[44969.255426] CPU    1: hi:  186, btch:  31 usd: 172
[44969.255426] CPU    2: hi:  186, btch:  31 usd: 162
[44969.255426] CPU    3: hi:  186, btch:  31 usd:  60
[44969.255426] Normal per-cpu:
[44969.255426] CPU    0: hi:  186, btch:  31 usd: 174
[44969.255426] CPU    1: hi:  186, btch:  31 usd: 214
[44969.255426] CPU    2: hi:  186, btch:  31 usd: 168
[44969.255426] CPU    3: hi:  186, btch:  31 usd:  61
[44969.255426] Active:169827 inactive:1640091 dirty:119534 writeback:0 unstable:0
[44969.255426]  free:8236 slab:67181 mapped:16894 pagetables:6051 bounce:0
[44969.255426] DMA free:9840kB min:12kB low:12kB high:16kB active:0kB inactive:0kB present:8856kB pages_scanned:0 all_unreclaimable? yes
[44969.255426] lowmem_reserve[]: 0 3246 7980 7980
[44969.255426] DMA32 free:20572kB min:4648kB low:5808kB high:6972kB active:2684kB inactive:2727912kB present:3324312kB pages_scanned:0 all_unreclaimable? no
[44969.255426] lowmem_reserve[]: 0 0 4734 4734
[44969.255426] Normal free:2532kB min:6776kB low:8468kB high:10164kB active:676624kB inactive:3832452kB present:4848000kB pages_scanned:0 all_unreclaimable? no
[44969.255426] lowmem_reserve[]: 0 0 0 0
[44969.255426] DMA: 4*4kB 6*8kB 3*16kB 2*32kB 1*64kB 3*128kB 2*256kB 1*512kB 2*1024kB 1*2048kB 1*4096kB = 9840kB
[44969.255426] DMA32: 190*4kB 64*8kB 154*16kB 58*32kB 21*64kB 11*128kB 14*256kB 1*512kB 0*1024kB 0*2048kB 2*4096kB = 20632kB
[44969.255426] Normal: 0*4kB 1*8kB 1*16kB 1*32kB 1*64kB 0*128kB 2*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 2680kB
[44969.255426] 1657222 total pagecache pages
[44969.255426] 0 pages in swap cache
[44969.255426] Swap cache stats: add 97, delete 97, find 22/29
[44969.255426] Free swap  = 16787740kB
[44969.255426] Total swap = 16787884kB
[44969.261058] 2277376 pages RAM
[44969.261058] 252168 pages reserved
[44969.261058] 1799713 pages shared
[44969.261058] 316799 pages non-shared
[44969.290153] klogd: page allocation failure. order:0, mode:0x20
[44969.290157] Pid: 2366, comm: klogd Not tainted 2.6.27.8 #2
[44969.290158] 
[44969.290158] Call Trace:
[44969.290160]  <IRQ>  [<ffffffff80279d4d>] __alloc_pages_internal+0x3cd/0x4d0
[44969.290168]  [<ffffffff8029876b>] cache_alloc_refill+0x2fb/0x570
[44969.290170]  [<ffffffff80298abb>] __kmalloc+0xdb/0xe0
[44969.290173]  [<ffffffff8058289d>] __alloc_skb+0x6d/0x150
[44969.290175]  [<ffffffff80583407>] __netdev_alloc_skb+0x17/0x40
[44969.290178]  [<ffffffff804a248b>] e1000_alloc_rx_buffers+0x25b/0x2e0
[44969.290181]  [<ffffffff804a27c0>] e1000_clean_rx_irq+0x240/0x380
[44969.290183]  [<ffffffff804a06bc>] e1000_clean+0x1fc/0x580
[44969.290186]  [<ffffffff802455c4>] run_rebalance_domains+0x1b4/0x590
[44969.290189]  [<ffffffff80586922>] net_rx_action+0xe2/0x1c0
[44969.290191]  [<ffffffff8024f843>] __do_softirq+0x73/0xf0
[44969.290194]  [<ffffffff80227f6c>] call_softirq+0x1c/0x30
[44969.290196]  [<ffffffff80229f55>] do_softirq+0x35/0x70
[44969.290198]  [<ffffffff8022a041>] do_IRQ+0x81/0x100
[44969.290201]  [<ffffffff80227231>] ret_from_intr+0x0/0xa
[44969.290202]  <EOI>  [<ffffffff8024b889>] do_syslog+0x399/0x480
[44969.290206]  [<ffffffff8024b8a1>] do_syslog+0x3b1/0x480
[44969.290210]  [<ffffffff8025f360>] autoremove_wake_function+0x0/0x30
[44969.290212]  [<ffffffff80243e8c>] pick_next_task_fair+0x11c/0x130
[44969.290215]  [<ffffffff802dfcb9>] kmsg_read+0x29/0x60
[44969.290218]  [<ffffffff806172af>] thread_return+0x3d/0x5be
[44969.290220]  [<ffffffff802d6f9b>] proc_reg_read+0x7b/0xc0
[44969.290222]  [<ffffffff8029c7e8>] vfs_read+0xc8/0x170
[44969.290224]  [<ffffffff8029c993>] sys_read+0x53/0xa0
[44969.290226]  [<ffffffff80226d2b>] system_call_fastpath+0x16/0x1b
[44969.290227] 
[44969.290228] Mem-Info:
[44969.290229] DMA per-cpu:
[44969.290231] CPU    0: hi:    0, btch:   1 usd:   0
[44969.290232] CPU    1: hi:    0, btch:   1 usd:   0
[44969.290233] CPU    2: hi:    0, btch:   1 usd:   0
[44969.290235] CPU    3: hi:    0, btch:   1 usd:   0
[44969.290236] DMA32 per-cpu:
[44969.290237] CPU    0: hi:  186, btch:  31 usd: 168
[44969.290239] CPU    1: hi:  186, btch:  31 usd: 172
[44969.290240] CPU    2: hi:  186, btch:  31 usd: 162
[44969.290241] CPU    3: hi:  186, btch:  31 usd:  60
[44969.290242] Normal per-cpu:
[44969.290244] CPU    0: hi:  186, btch:  31 usd: 174
[44969.290245] CPU    1: hi:  186, btch:  31 usd: 214
[44969.290246] CPU    2: hi:  186, btch:  31 usd: 168
[44969.290248] CPU    3: hi:  186, btch:  31 usd:  61
[44969.290250] Active:169827 inactive:1640091 dirty:119534 writeback:0 unstable:0
[44969.290251]  free:8236 slab:67181 mapped:16894 pagetables:6051 bounce:0
[44969.290253] DMA free:9840kB min:12kB low:12kB high:16kB active:0kB inactive:0kB present:8856kB pages_scanned:0 all_unreclaimable? yes
[44969.290255] lowmem_reserve[]: 0 3246 7980 7980
[44969.290258] DMA32 free:20572kB min:4648kB low:5808kB high:6972kB active:2684kB inactive:2727912kB present:3324312kB pages_scanned:0 all_unreclaimable? no
[44969.290260] lowmem_reserve[]: 0 0 4734 4734
[44969.290264] Normal free:2532kB min:6776kB low:8468kB high:10164kB active:676624kB inactive:3832452kB present:4848000kB pages_scanned:0 all_unreclaimable? no
[44969.290266] lowmem_reserve[]: 0 0 0 0
[44969.290269] DMA: 4*4kB 6*8kB 3*16kB 2*32kB 1*64kB 3*128kB 2*256kB 1*512kB 2*1024kB 1*2048kB 1*4096kB = 9840kB
[44969.290275] DMA32: 190*4kB 64*8kB 154*16kB 58*32kB 21*64kB 11*128kB 14*256kB 1*512kB 0*1024kB 0*2048kB 2*4096kB = 20632kB
[44969.290282] Normal: 0*4kB 1*8kB 1*16kB 1*32kB 1*64kB 0*128kB 2*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 2680kB
[44969.290296] 1657222 total pagecache pages
[44969.290298] 0 pages in swap cache
[44969.290299] Swap cache stats: add 97, delete 97, find 22/29
[44969.290301] Free swap  = 16787740kB
[44969.290302] Total swap = 16787884kB
[44969.290907] 2277376 pages RAM
[44969.290907] 252168 pages reserved
[44969.290907] 1798824 pages shared
[44969.290907] 316798 pages non-shared
[44970.149170] swapper: page allocation failure. order:0, mode:0x20
[44970.149178] Pid: 0, comm: swapper Not tainted 2.6.27.8 #2
[44970.149180] 
[44970.149181] Call Trace:
[44970.149183]  <IRQ>  [<ffffffff80279d4d>] __alloc_pages_internal+0x3cd/0x4d0
[44970.149194]  [<ffffffff8029876b>] cache_alloc_refill+0x2fb/0x570
[44970.149197]  [<ffffffff80298abb>] __kmalloc+0xdb/0xe0
[44970.149202]  [<ffffffff8058289d>] __alloc_skb+0x6d/0x150
[44970.149205]  [<ffffffff80583407>] __netdev_alloc_skb+0x17/0x40
[44970.149209]  [<ffffffff804a248b>] e1000_alloc_rx_buffers+0x25b/0x2e0
[44970.149213]  [<ffffffff804a27c0>] e1000_clean_rx_irq+0x240/0x380
[44970.149216]  [<ffffffff804a06bc>] e1000_clean+0x1fc/0x580
[44970.149219]  [<ffffffff80586922>] net_rx_action+0xe2/0x1c0
[44970.149223]  [<ffffffff8024f843>] __do_softirq+0x73/0xf0
[44970.149226]  [<ffffffff80227f6c>] call_softirq+0x1c/0x30
[44970.149230]  [<ffffffff80229f55>] do_softirq+0x35/0x70
[44970.149232]  [<ffffffff8022a041>] do_IRQ+0x81/0x100
[44970.149236]  [<ffffffff80227231>] ret_from_intr+0x0/0xa
[44970.149238]  <EOI>  [<ffffffff8022e6fc>] mwait_idle+0x3c/0x50
[44970.149244]  [<ffffffff80225d6c>] cpu_idle+0x5c/0x90
[44970.149246] 
[44970.149247] Mem-Info:
[44970.149249] DMA per-cpu:
[44970.149251] CPU    0: hi:    0, btch:   1 usd:   0
[44970.149253] CPU    1: hi:    0, btch:   1 usd:   0
[44970.149255] CPU    2: hi:    0, btch:   1 usd:   0
[44970.149257] CPU    3: hi:    0, btch:   1 usd:   0
[44970.149259] DMA32 per-cpu:
[44970.149261] CPU    0: hi:  186, btch:  31 usd: 171
[44970.149263] CPU    1: hi:  186, btch:  31 usd: 121
[44970.149265] CPU    2: hi:  186, btch:  31 usd: 176
[44970.149267] CPU    3: hi:  186, btch:  31 usd:  60
[44970.149269] Normal per-cpu:
[44970.149270] CPU    0: hi:  186, btch:  31 usd: 166
[44970.149273] CPU    1: hi:  186, btch:  31 usd: 184
[44970.149275] CPU    2: hi:  186, btch:  31 usd: 170
[44970.149277] CPU    3: hi:  186, btch:  31 usd:  80
[44970.149280] Active:169820 inactive:1639990 dirty:118343 writeback:7926 unstable:0
[44970.149281]  free:8232 slab:67416 mapped:16894 pagetables:6051 bounce:0
[44970.149285] DMA free:9840kB min:12kB low:12kB high:16kB active:0kB inactive:0kB present:8856kB pages_scanned:0 all_unreclaimable? yes
[44970.149287] lowmem_reserve[]: 0 3246 7980 7980
[44970.149293] DMA32 free:20652kB min:4648kB low:5808kB high:6972kB active:2656kB inactive:2727824kB present:3324312kB pages_scanned:0 all_unreclaimable? no
[44970.149296] lowmem_reserve[]: 0 0 4734 4734
[44970.149301] Normal free:2436kB min:6776kB low:8468kB high:10164kB active:676624kB inactive:3832136kB present:4848000kB pages_scanned:0 all_unreclaimable? no
[44970.149304] lowmem_reserve[]: 0 0 0 0
[44970.149308] DMA: 4*4kB 6*8kB 3*16kB 2*32kB 1*64kB 3*128kB 2*256kB 1*512kB 2*1024kB 1*2048kB 1*4096kB = 9840kB
[44970.149318] DMA32: 97*4kB 74*8kB 132*16kB 58*32kB 29*64kB 13*128kB 14*256kB 1*512kB 0*1024kB 0*2048kB 2*4096kB = 20756kB
[44970.149328] Normal: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 1*128kB 1*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 2432kB
[44970.149338] 1657251 total pagecache pages
[44970.149340] 0 pages in swap cache
[44970.149342] Swap cache stats: add 97, delete 97, find 22/29
[44970.149344] Free swap  = 16787740kB
[44970.149346] Total swap = 16787884kB
[44970.178176] 2277376 pages RAM
[44970.178176] 252168 pages reserved
[44970.178176] 1799661 pages shared
[44970.178176] 316951 pages non-shared

Raid optimizations used:

# cat oraid.sh |grep -v ^#|grep .
. /etc/profile
echo "Optimizing RAID Arrays..."
cd /sys/block
DISKS=$(/bin/ls -1d sd[e-j])
echo "Setting read-ahead to 32 MiB for /dev/md0"
blockdev --setra 65536 /dev/md0
echo "Setting stripe_cache_size to 16 MiB for /dev/md0"
echo 16384 > /sys/block/md0/md/stripe_cache_size

