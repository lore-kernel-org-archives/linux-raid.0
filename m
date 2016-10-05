From: Sitsofe Wheeler <sitsofe@gmail.com>
Subject: Re: kernel BUG at block/bio.c:1785 while trying to issue a discard to
 LVM on RAID1 md
Date: Wed, 5 Oct 2016 22:31:11 +0100
Message-ID: <CALjAwxhYh0JDKh7E_t9sm-vBBPX-3dzL5hDMi4rA6uE2RqaJoQ@mail.gmail.com>
References: <CALjAwxgg-m2bgFf10hLB3j=2ntVxqt0vDSKuQyOavqvKXC2G5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CALjAwxgg-m2bgFf10hLB3j=2ntVxqt0vDSKuQyOavqvKXC2G5Q@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On 3 October 2016 at 17:47, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>
> While trying to do a discard (via blkdiscard --length 1048576
> /dev/<pathtodevice>) to an LVM device atop a two disk md RAID1 the
> following oops was generated:
>
> [  103.306243] md: resync of RAID array md127
> [  103.306246] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> [  103.306248] md: using maximum available idle IO bandwidth (but not
> more than 200000 KB/sec) for resync.
> [  103.306251] md: using 128k window, over a total of 244194432k.
> [  103.308158] ------------[ cut here ]------------
> [  103.308205] kernel BUG at block/bio.c:1785!

This still seems to be here but slightly modified with a 4.8.0 kernel:

[  156.501373] ------------[ cut here ]------------
[  156.502374] kernel BUG at block/bio.c:1785!
[  156.503139] invalid opcode: 0000 [#1] SMP
[  156.503816] Modules linked in: vmw_vsock_vmci_transport vsock
sb_edac edac_core intel_powerclamp coretemp raid1 crct10dif_pclmul
crc32_pclmul ghash_clmulni_intel ppdev intel_rapl_perf vmxnet3
vmw_balloon pcspkr joydev acpi_cpufreq tpm_tis i2c_piix4 tpm_tis_core
vmw_vmci parport_pc fjes tpm shpchp parport dm_multipath vmwgfx
drm_kms_helper ttm drm crc32c_intel serio_raw vmw_pvscsi ata_generic
pata_acpi
[  156.510208] CPU: 0 PID: 407 Comm: md127_raid1 Not tainted
4.8.0-1.vanilla.knurd.1.fc24.x86_64 #1
[  156.511559] Hardware name: VMware, Inc. VMware Virtual
Platform/440BX Desktop Reference Platform, BIOS 6.00 09/30/2014
[  156.513209] task: ffff9944f9ed9d80 task.stack: ffff9944f903c000
[  156.514159] RIP: 0010:[<ffffffffbc3aa71a>]  [<ffffffffbc3aa71a>]
bio_split+0x8a/0x90
[  156.515471] RSP: 0018:ffff9944f903fb38  EFLAGS: 00010246
[  156.516323] RAX: 00000000fffdd1f3 RBX: 0000000000000000 RCX: ffff9944ff05cf00
[  156.517456] RDX: 0000000002400000 RSI: 0000000000000000 RDI: ffff9944f830b700
[  156.518573] RBP: ffff9944f903fb50 R08: 0000000000000001 R09: ffff9944f830b700
[  156.519680] R10: ffff9944f903fbb0 R11: 0000000000000000 R12: 0000000000000000
[  156.520807] R13: 0000000000000000 R14: 0000000000000000 R15: ffff9944ff1388e0
[  156.521916] FS:  0000000000000000(0000) GS:ffff9944fec00000(0000)
knlGS:0000000000000000
[  156.523187] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  156.524080] CR2: 0000561c09a99108 CR3: 000000003ab2e000 CR4: 00000000001406f0
[  156.525228] Stack:
[  156.525571]  0000000000000000 0000000000000200 0000000000000000
ffff9944f903fbf0
[  156.526812]  ffffffffbc3b7f0e ffff9944f8928000 ffff9944fec19580
ffff9944ff05cf00
[  156.528072]  0005803fff747000 ffff9944f903fc00 00000001f8928080
ffff9944f830b700
[  156.529308] Call Trace:
[  156.529706]  [<ffffffffbc3b7f0e>] blk_queue_split+0x18e/0x640
[  156.530609]  [<ffffffffbc3b2fe3>] blk_queue_bio+0x53/0x3c0
[  156.531487]  [<ffffffffbc3b1482>] generic_make_request+0xf2/0x1d0
[  156.532436]  [<ffffffffbc3b15dd>] submit_bio+0x7d/0x150
[  156.533272]  [<ffffffffbc3aa47e>] ? bio_clone_bioset+0x14e/0x360
[  156.534211]  [<ffffffffbc3a7a0d>] submit_bio_wait+0x5d/0x90
[  156.535108]  [<ffffffffc051a3b5>] raid1d+0x405/0x1010 [raid1]
[  156.536040]  [<ffffffffbc0d4d49>] ? set_next_entity+0x49/0xd0
[  156.536938]  [<ffffffffbc64ffe9>] md_thread+0x139/0x150
[  156.537766]  [<ffffffffbc0e39b0>] ? prepare_to_wait_event+0xf0/0xf0
[  156.538758]  [<ffffffffbc64feb0>] ? find_pers+0x70/0x70
[  156.539578]  [<ffffffffbc0c0328>] kthread+0xd8/0xf0
[  156.540355]  [<ffffffffbc7fd43f>] ret_from_fork+0x1f/0x40
[  156.541208]  [<ffffffffbc0c0250>] ? kthread_worker_fn+0x180/0x180
[  156.542186] Code: 44 89 e2 4c 89 ef e8 d6 51 03 00 41 8b 75 28 48
89 df e8 3a d3 ff ff 5b 4c 89 e8 41 5c 41 5d 5d c3 e8 1b fc ff ff 49
89 c5 eb b6 <0f> 0b 0f 0b 66 90 0f 1f 44 00 00 48 8b 07 55 48 89 e5 48
85 c0
[  156.546655] RIP  [<ffffffffbc3aa71a>] bio_split+0x8a/0x90
[  156.547535]  RSP <ffff9944f903fb38>
[  156.548127] ---[ end trace bdaed0bbc089e451 ]---
[  156.549888] BUG: unable to handle kernel paging request at 000000004ebddcbe
[  156.551080] IP: [<ffffffffbc0e323b>] __wake_up_common+0x2b/0x80
[  156.552036] PGD 0
[  156.552430] Oops: 0000 [#2] SMP
[  156.552958] Modules linked in: vmw_vsock_vmci_transport vsock
sb_edac edac_core intel_powerclamp coretemp raid1 crct10dif_pclmul
crc32_pclmul ghash_clmulni_intel ppdev intel_rapl_perf vmxnet3
vmw_balloon pcspkr joydev acpi_cpufreq tpm_tis i2c_piix4 tpm_tis_core
vmw_vmci parport_pc fjes tpm shpchp parport dm_multipath vmwgfx
drm_kms_helper ttm drm crc32c_intel serio_raw vmw_pvscsi ata_generic
pata_acpi
[  156.559295] CPU: 0 PID: 407 Comm: md127_raid1 Tainted: G      D
    4.8.0-1.vanilla.knurd.1.fc24.x86_64 #1
[  156.560844] Hardware name: VMware, Inc. VMware Virtual
Platform/440BX Desktop Reference Platform, BIOS 6.00 09/30/2014
[  156.562491] task: ffff9944f9ed9d80 task.stack: ffff9944f903c000
[  156.563418] RIP: 0010:[<ffffffffbc0e323b>]  [<ffffffffbc0e323b>]
__wake_up_common+0x2b/0x80
[  156.564740] RSP: 0018:ffff9944f903fe38  EFLAGS: 00010096
[  156.565588] RAX: 0000000000000282 RBX: ffff9944f903ff10 RCX: 0000000000000000
[  156.566703] RDX: 000000004ebddcbe RSI: 0000000000000003 RDI: ffff9944f903ff10
[  156.567819] RBP: ffff9944f903fe70 R08: 0000000000000000 R09: 0000000000000000
[  156.568924] R10: 0000000000000000 R11: 00000000fa83b2da R12: ffff9944f903ff18
[  156.570038] R13: 0000000000000282 R14: 0000000000000001 R15: 0000000000000003
[  156.571158] FS:  0000000000000000(0000) GS:ffff9944fec00000(0000)
knlGS:0000000000000000
[  156.572414] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  156.573303] CR2: 000000004ebddcbe CR3: 00000000388ca000 CR4: 00000000001406f0
[  156.574498] Stack:
[  156.574829]  00000001f8920000 0000000000000000 ffff9944f903ff10
ffff9944f903ff08
[  156.576098]  0000000000000282 0000000000000001 0000000000000000
ffff9944f903fe80
[  156.577333]  ffffffffbc0e32f3 ffff9944f903fea8 ffffffffbc0e3e57
0000000000000000
[  156.578567] Call Trace:
[  156.578962]  [<ffffffffbc0e32f3>] __wake_up_locked+0x13/0x20
[  156.579904]  [<ffffffffbc0e3e57>] complete+0x37/0x50
[  156.580699]  [<ffffffffbc09e13c>] mm_release+0xbc/0x140
[  156.581513]  [<ffffffffbc0a47f5>] do_exit+0x155/0xb10
[  156.582331]  [<ffffffffbc7feac7>] rewind_stack_do_exit+0x17/0x20
[  156.583262]  [<ffffffffbc0c0250>] ? kthread_worker_fn+0x180/0x180
[  156.584230] Code: 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 41 55 41
54 4c 8d 67 08 53 41 89 f7 48 83 ec 10 89 55 cc 48 8b 57 08 4c 89 45
d0 49 39 d4 <48> 8b 32 74 40 48 8d 42 e8 4c 8d 6e e8 41 89 ce 8b 18 48
8b 4d
[  156.588679] RIP  [<ffffffffbc0e323b>] __wake_up_common+0x2b/0x80
[  156.589646]  RSP <ffff9944f903fe38>
[  156.590203] CR2: 000000004ebddcbe
[  156.590754] ---[ end trace bdaed0bbc089e452 ]---
[  156.591478] ------------[ cut here ]------------
[  156.592235] WARNING: CPU: 0 PID: 407 at kernel/exit.c:737 do_exit+0x62/0xb10

The difference is the last oops seems to be endlessly repeated over
and over again essentially making it feel like the system has locked
up. Partner issue is over on
http://www.gossamer-threads.com/lists/linux/kernel/2538757?do=post_view_threaded#2538757
.

-- 
Sitsofe | http://sucs.org/~sits/
