From: Sitsofe Wheeler <sitsofe@gmail.com>
Subject: kernel BUG at block/bio.c:1785 while trying to issue a discard to LVM
 on RAID1 md
Date: Mon, 3 Oct 2016 17:47:51 +0100
Message-ID: <CALjAwxgg-m2bgFf10hLB3j=2ntVxqt0vDSKuQyOavqvKXC2G5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

While trying to do a discard (via blkdiscard --length 1048576
/dev/<pathtodevice>) to an LVM device atop a two disk md RAID1 the
following oops was generated:

[  103.306243] md: resync of RAID array md127
[  103.306246] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[  103.306248] md: using maximum available idle IO bandwidth (but not
more than 200000 KB/sec) for resync.
[  103.306251] md: using 128k window, over a total of 244194432k.
[  103.308158] ------------[ cut here ]------------
[  103.308205] kernel BUG at block/bio.c:1785!
[  103.308243] invalid opcode: 0000 [#1] SMP
[  103.308279] Modules linked in: vmw_vsock_vmci_transport vsock
sb_edac raid1 edac_core intel_powerclamp coretemp crct10dif_pclmul
crc32_pclmul ghash_clmulni_intel vmw_balloon ppdev intel_rapl_perf
joydev vmxnet3 parport_pc vmw_vmci parport shpchp acpi_cpufreq fjes
tpm_tis tpm i2c_piix4 dm_multipath vmwgfx drm_kms_helper ttm drm
crc32c_intel serio_raw vmw_pvscsi ata_generic pata_acpi
[  103.308641] CPU: 0 PID: 391 Comm: md127_raid1 Not tainted
4.7.5-200.fc24.x86_64 #1
[  103.308699] Hardware name: VMware, Inc. VMware Virtual
Platform/440BX Desktop Reference Platform, BIOS 6.00 09/30/2014
[  103.308784] task: ffff88003beb0000 ti: ffff88000016c000 task.ti:
ffff88000016c000
[  103.308841] RIP: 0010:[<ffffffffa23a4312>]  [<ffffffffa23a4312>]
bio_split+0x82/0x90
[  103.308921] RSP: 0018:ffff88000016fb38  EFLAGS: 00010246
[  103.308972] RAX: 00057fffffffffff RBX: 0000000000000000 RCX: ffff88003f017a80
[  103.309038] RDX: 0000000002400000 RSI: 0000000000000000 RDI: ffff88003bc01500
[  103.309110] RBP: ffff88000016fb50 R08: 0000000000000080 R09: ffff88003bc01500
[  103.310652] R10: ffff88000016fbb0 R11: 0000000000000000 R12: 0000000000000000
[  103.312043] R13: 0000000000000000 R14: 0000000000000002 R15: ffff88003f168900
[  103.313419] FS:  0000000000000000(0000) GS:ffff88003ec00000(0000)
knlGS:0000000000000000
[  103.314815] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  103.315731] CR2: 00007fdd4daeb400 CR3: 000000003b2c5000 CR4: 00000000001406f0
[  103.316328] Stack:
[  103.316879]  0000000000000000 00000000000001fe 0000000000000000
ffff88000016fbf0
[  103.317473]  ffffffffa23b1afd 0000000000000246 0000000002011200
ffff88003f017a80
[  103.318050]  0005800000000000 000000803e8013c0 ffff88000016fc00
ffff88003bc01500
[  103.318626] Call Trace:
[  103.319196]  [<ffffffffa23b1afd>] blk_queue_split+0x2cd/0x620
[  103.319780]  [<ffffffffa23acb83>] blk_queue_bio+0x53/0x3d0
[  103.320378]  [<ffffffffa23ab022>] generic_make_request+0xf2/0x1d0
[  103.320960]  [<ffffffffa23ab176>] submit_bio+0x76/0x160
[  103.321535]  [<ffffffffa23a1693>] submit_bio_wait+0x63/0x90
[  103.322112]  [<ffffffffc058e27a>] raid1d+0x3ea/0xfb0 [raid1]
[  103.322688]  [<ffffffffa27eb3ec>] ? schedule_timeout+0x1ac/0x270
[  103.323268]  [<ffffffffa2649c59>] md_thread+0x139/0x150
[  103.323848]  [<ffffffffa20e46e0>] ? prepare_to_wait_event+0xf0/0xf0
[  103.324417]  [<ffffffffa2649b20>] ? find_pers+0x70/0x70
[  103.324988]  [<ffffffffa20c0588>] kthread+0xd8/0xf0
[  103.325562]  [<ffffffffa27ec77f>] ret_from_fork+0x1f/0x40
[  103.326108]  [<ffffffffa20c04b0>] ? kthread_worker_fn+0x180/0x180
[  103.326654] Code: 44 89 e2 4c 89 ef e8 1e 47 03 00 41 8b 75 28 48
89 df e8 92 d6 ff ff 5b 4c 89 e8 41 5c 41 5d 5d c3 e8 63 fc ff ff 49
89 c5 eb b6 <0f> 0b 0f 0b 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00
48 8b
[  103.328410] RIP  [<ffffffffa23a4312>] bio_split+0x82/0x90
[  103.328943]  RSP <ffff88000016fb38>
[  103.329474] ---[ end trace f093e2f8fabdb9b3 ]---

The kernel is 4.7.5-200.fc24.x86_64 from Fedora 24. While md is stuck
in the PENDING state the oops seems to be reproducible. If md is in
the middle of resyncing the system locks up entirely without printing
anything instead...

The "disks" are raw disk mappings of SSDs on ESXi being passed to a
VM. Here's the some initial /sys/block/ output before the any discards
are issued:
 # grep . /sys/block/sdc/queue/*
/sys/block/sdc/queue/add_random:0
/sys/block/sdc/queue/discard_granularity:512
/sys/block/sdc/queue/discard_max_bytes:4294966784
/sys/block/sdc/queue/discard_max_hw_bytes:4294966784
/sys/block/sdc/queue/discard_zeroes_data:0
/sys/block/sdc/queue/hw_sector_size:512
/sys/block/sdc/queue/io_poll:0
grep: /sys/block/sdc/queue/iosched: Is a directory
/sys/block/sdc/queue/iostats:1
/sys/block/sdc/queue/logical_block_size:512
/sys/block/sdc/queue/max_hw_sectors_kb:32767
/sys/block/sdc/queue/max_integrity_segments:0
/sys/block/sdc/queue/max_sectors_kb:1280
/sys/block/sdc/queue/max_segments:128
/sys/block/sdc/queue/max_segment_size:65536
/sys/block/sdc/queue/minimum_io_size:512
/sys/block/sdc/queue/nomerges:0
/sys/block/sdc/queue/nr_requests:128
/sys/block/sdc/queue/optimal_io_size:0
/sys/block/sdc/queue/physical_block_size:512
/sys/block/sdc/queue/read_ahead_kb:128
/sys/block/sdc/queue/rotational:0
/sys/block/sdc/queue/rq_affinity:1
/sys/block/sdc/queue/scheduler:[noop] deadline cfq
/sys/block/sdc/queue/write_cache:write through
/sys/block/sdc/queue/write_same_max_bytes:0

-- 
Sitsofe | http://sucs.org/~sits/
