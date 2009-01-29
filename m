From: Jody McIntyre <scjody@sun.com>
Subject: Re: sun x4500 soft lockup during raid creation
Date: Thu, 29 Jan 2009 17:54:09 -0500
Message-ID: <20090129225408.GM9898@clouds>
References: <1233174633.7008.34.camel@hazard2.francoudi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <1233174633.7008.34.camel@hazard2.francoudi.com>
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Vladimir Ivashchenko <hazard@francoudi.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 28, 2009 at 10:30:33PM +0200, Vladimir Ivashchenko wrote:

> CentOS 5.2, 2.6.18-92.1.22.el5PAE, sata_mv. Two dual-core Opterons @ 2.8
> Ghz, 16 GB RAM.

You should really be running the EL 5.3 kernel - sata_mv in EL 5.2 has
known issues according to the x4500 team but they are happy with the
version in EL 5.3.

> Any stability assurances or workarounds are highly appreciated. :)

It's just a lockup, not a crash.  The system will be fine.  We've seen a
lot of these, and there's a workaround patch attached to this bug:

https://bugzilla.lustre.org/show_bug.cgi?id=17084

It's probably the same bug seen here, as pointed out by Richard Scobie:
http://marc.info/?l=linux-raid&m=123264525708803&w=2

The problem is not specific to the x4500 - I've seen it with many
configurations, including on non-Sun hardware, generally when lots of
disks are involved in a rebuild.  I have not seen it with any mainline
kernel in the past 6 months (they are much more recent than EL 5) but it
may still exist.

As a complete side note, you'll likely see better performance if you
stagger disks across controllers (the x4500 has 6) rather than creating
arrays with most disks from 3 controllers.

Note: I don't work for Sun support or the x4500 product team and nothing
in this message is necessarily an official Sun position.

Cheers,
Jody


> Jan 28 21:31:32 SunSTG kernel: BUG: soft lockup - CPU#0 stuck for 10s!
> [md3_raid5:5672]
> Jan 28 21:31:32 SunSTG kernel:
> Jan 28 21:31:32 SunSTG kernel: Pid: 5672, comm:            md3_raid5
> Jan 28 21:31:32 SunSTG kernel: EIP: 0060:[<f8d68162>] CPU: 0
> Jan 28 21:31:32 SunSTG kernel: EIP is at raid6_sse22_gen_syndrome
> +0x10a/0x1b6 [raid456]
> Jan 28 21:31:32 SunSTG kernel:  EFLAGS: 00000202    Not tainted
> (2.6.18-92.1.22.el5PAE #1)
> Jan 28 21:31:32 SunSTG kernel: EAX: ea0774e0 EBX: 000004e0 ECX: ead0ad30
> EDX: ea077000
> Jan 28 21:31:32 SunSTG kernel: ESI: ead0ade0 EDI: 00000004 EBP: ead0add0
> DS: 007b ES: 007b
> Jan 28 21:31:32 SunSTG kernel: CR0: 80050033 CR2: 0806e000 CR3: 373239e0
> CR4: 000006f0
> Jan 28 21:31:32 SunSTG kernel:  [<f8d63562>] compute_parity6+0x21c/0x28a
> [raid456]
> Jan 28 21:31:32 SunSTG kernel:  [<f8d6452e>] handle_stripe+0xc8b/0x215e
> [raid456]
> Jan 28 21:31:32 SunSTG kernel:  [<c041fdb3>] enqueue_task+0x29/0x39
> Jan 28 21:31:32 SunSTG kernel:  [<c0420629>] try_to_wake_up+0x371/0x37b
> Jan 28 21:31:32 SunSTG kernel:  [<c041edec>] __wake_up_common+0x2f/0x53
> Jan 28 21:31:32 SunSTG kernel:  [<c041fbe6>] __wake_up+0x2a/0x3d
> Jan 28 21:31:32 SunSTG kernel:  [<f8d61744>] release_stripe+0x21/0x2e
> [raid456]
> Jan 28 21:31:33 SunSTG kernel:  [<f8d65b0c>] raid5d+0x10b/0x130
> [raid456]
> Jan 28 21:31:33 SunSTG kernel:  [<c059aca8>] md_thread+0xdf/0xf5
> Jan 28 21:31:33 SunSTG kernel:  [<c0436347>] autoremove_wake_function
> +0x0/0x2d
> Jan 28 21:31:33 SunSTG kernel:  [<c059abc9>] md_thread+0x0/0xf5
> Jan 28 21:31:33 SunSTG kernel:  [<c0436285>] kthread+0xc0/0xeb
> Jan 28 21:31:33 SunSTG kernel:  [<c04361c5>] kthread+0x0/0xeb
> Jan 28 21:31:33 SunSTG kernel:  [<c0405c3b>] kernel_thread_helper
> +0x7/0x10
> 
> Jan 28 21:31:33 SunSTG kernel:  =======================
> Jan 28 21:32:26 SunSTG kernel: BUG: soft lockup - CPU#2 stuck for 10s!
> [md3_raid5:5672]
> Jan 28 21:32:26 SunSTG kernel:
> Jan 28 21:32:26 SunSTG kernel: Pid: 5672, comm:            md3_raid5
> Jan 28 21:32:26 SunSTG kernel: EIP: 0060:[<f8d68170>] CPU: 2
> Jan 28 21:32:26 SunSTG kernel: EIP is at raid6_sse22_gen_syndrome
> +0x118/0x1b6 [raid456]
> Jan 28 21:32:26 SunSTG kernel:  EFLAGS: 00000202    Not tainted
> (2.6.18-92.1.22.el5PAE #1)
> Jan 28 21:32:26 SunSTG kernel: EAX: ea784040 EBX: 00000040 ECX: ead0ad30
> EDX: ea784000
> Jan 28 21:32:26 SunSTG kernel: ESI: ead0adf0 EDI: 00000008 EBP: ead0add0
> DS: 007b ES: 007b
> Jan 28 21:32:26 SunSTG kernel: CR0: 80050033 CR2: b7f6f000 CR3: 3714e920
> CR4: 000006f0
> Jan 28 21:32:26 SunSTG kernel:  [<f8d63562>] compute_parity6+0x21c/0x28a
> [raid456]
> Jan 28 21:32:26 SunSTG kernel:  [<f8d6452e>] handle_stripe+0xc8b/0x215e
> [raid456]
> Jan 28 21:32:26 SunSTG kernel:  [<c041f34b>] find_busiest_group
> +0x177/0x462
> Jan 28 21:32:26 SunSTG kernel:  [<c041fc53>] task_rq_lock+0x31/0x58
> Jan 28 21:32:26 SunSTG kernel:  [<c0420629>] try_to_wake_up+0x371/0x37b
> Jan 28 21:32:26 SunSTG kernel:  [<f8d6171e>] __release_stripe+0xfc/0x101
> [raid456]
> Jan 28 21:32:26 SunSTG kernel:  [<f8d61744>] release_stripe+0x21/0x2e
> [raid456]
> Jan 28 21:32:26 SunSTG kernel:  [<f8d65b0c>] raid5d+0x10b/0x130
> [raid456]
> Jan 28 21:32:26 SunSTG kernel:  [<c059aca8>] md_thread+0xdf/0xf5
> Jan 28 21:32:26 SunSTG kernel:  [<c0436347>] autoremove_wake_function
> +0x0/0x2d
> Jan 28 21:32:26 SunSTG kernel:  [<c059abc9>] md_thread+0x0/0xf5
> Jan 28 21:32:26 SunSTG kernel:  [<c0436285>] kthread+0xc0/0xeb
> Jan 28 21:32:26 SunSTG kernel:  [<c04361c5>] kthread+0x0/0xeb
> Jan 28 21:32:26 SunSTG kernel:  [<c0405c3b>] kernel_thread_helper
> +0x7/0x10
> Jan 28 21:32:26 SunSTG kernel:  =======================
> 
> <somewhere here I issue commands to create md4>
> 
> Jan 28 21:32:43 SunSTG kernel: md: syncing RAID array md4
> Jan 28 21:32:43 SunSTG kernel: md: minimum _guaranteed_ reconstruction
> speed: 1000 KB/sec/disc.
> Jan 28 21:32:43 SunSTG kernel: md: using maximum available idle IO
> bandwidth (but not more than 200000 KB/sec) for reconstruction.
> Jan 28 21:32:43 SunSTG kernel: md: using 128k window, over a total of
> 244195200 blocks.
> Jan 28 21:33:20 SunSTG kernel: BUG: soft lockup - CPU#3 stuck for 10s!
> [md4_raid5:5694]
> Jan 28 21:33:20 SunSTG kernel:
> Jan 28 21:33:20 SunSTG kernel: Pid: 5694, comm:            md4_raid5
> Jan 28 21:33:20 SunSTG kernel: EIP: 0060:[<f8d63aff>] CPU: 3
> Jan 28 21:33:20 SunSTG kernel: EIP is at handle_stripe+0x25c/0x215e
> [raid456]
> Jan 28 21:33:20 SunSTG kernel:  EFLAGS: 00000282    Not tainted
> (2.6.18-92.1.22.el5PAE #1)
> Jan 28 21:33:20 SunSTG kernel: EAX: f6a2b404 EBX: 00000001 ECX: f53d17c0
> EDX: e8c532c0
> Jan 28 21:33:20 SunSTG kernel: ESI: e8c532c4 EDI: 00000016 EBP: e8c52b64
> DS: 007b ES: 007b
> Jan 28 21:33:20 SunSTG kernel: CR0: 8005003b CR2: b7cfc000 CR3: 3714ef00
> CR4: 000006f0
> Jan 28 21:33:20 SunSTG kernel:  [<c041f34b>] find_busiest_group
> +0x177/0x462
> Jan 28 21:33:20 SunSTG kernel:  [<c041fc53>] task_rq_lock+0x31/0x58
> Jan 28 21:33:20 SunSTG kernel:  [<c041fdb3>] enqueue_task+0x29/0x39
> Jan 28 21:33:20 SunSTG kernel:  [<c0420629>] try_to_wake_up+0x371/0x37b
> Jan 28 21:33:20 SunSTG kernel:  [<c041edec>] __wake_up_common+0x2f/0x53
> Jan 28 21:33:20 SunSTG kernel:  [<c041fbe6>] __wake_up+0x2a/0x3d
> Jan 28 21:33:20 SunSTG kernel:  [<f8d61744>] release_stripe+0x21/0x2e
> [raid456]
> Jan 28 21:33:20 SunSTG kernel:  [<f8d65b0c>] raid5d+0x10b/0x130
> [raid456]
> Jan 28 21:33:20 SunSTG kernel:  [<c059aca8>] md_thread+0xdf/0xf5
> Jan 28 21:33:20 SunSTG kernel:  [<c0436347>] autoremove_wake_function
> +0x0/0x2d
> Jan 28 21:33:20 SunSTG kernel:  [<c059abc9>] md_thread+0x0/0xf5
> Jan 28 21:33:21 SunSTG kernel:  [<c0436285>] kthread+0xc0/0xeb
> Jan 28 21:33:21 SunSTG kernel:  [<c04361c5>] kthread+0x0/0xeb
> Jan 28 21:33:21 SunSTG kernel:  [<c0405c3b>] kernel_thread_helper
> +0x7/0x10
> Jan 28 21:33:21 SunSTG kernel:  =======================
> Jan 28 21:33:50 SunSTG kernel: BUG: soft lockup - CPU#3 stuck for 10s!
> [md4_raid5:5694]
> Jan 28 21:33:50 SunSTG kernel:
> Jan 28 21:33:50 SunSTG kernel: Pid: 5694, comm:            md4_raid5
> Jan 28 21:33:50 SunSTG kernel: EIP: 0060:[<f8bf9813>] CPU: 3
> Jan 28 21:33:50 SunSTG kernel: EIP is at xor_sse_5+0xa0/0x3b5 [xor]
> Jan 28 21:33:50 SunSTG kernel:  EFLAGS: 00000202    Not tainted
> (2.6.18-92.1.22.el5PAE #1)
> Jan 28 21:33:50 SunSTG kernel: EAX: 0000000b EBX: e8e66500 ECX: e8e69500
> EDX: e8e6e500
> Jan 28 21:33:50 SunSTG kernel: ESI: e8e67500 EDI: e8e68500 EBP: e96b5dd4
> DS: 007b ES: 007b
> Jan 28 21:33:50 SunSTG kernel: CR0: 80050033 CR2: b7cfc000 CR3: 3714ef00
> CR4: 000006f0
> Jan 28 21:33:50 SunSTG kernel:  [<f8bfa200>] xor_block+0x74/0x7d [xor]
> Jan 28 21:33:50 SunSTG kernel:  [<f8d636b3>] compute_block_1+0xe3/0x13a
> [raid456]
> Jan 28 21:33:50 SunSTG kernel:  [<f8d644ba>] handle_stripe+0xc17/0x215e
> [raid456]
> Jan 28 21:33:50 SunSTG kernel:  [<c041f34b>] find_busiest_group
> +0x177/0x462
> Jan 28 21:33:50 SunSTG kernel:  [<c041fdb3>] enqueue_task+0x29/0x39
> Jan 28 21:33:50 SunSTG kernel:  [<c0420629>] try_to_wake_up+0x371/0x37b
> Jan 28 21:33:50 SunSTG kernel:  [<c041edec>] __wake_up_common+0x2f/0x53
> Jan 28 21:33:50 SunSTG kernel:  [<c041fbe6>] __wake_up+0x2a/0x3d
> Jan 28 21:33:50 SunSTG kernel:  [<f8d61744>] release_stripe+0x21/0x2e
> [raid456]
> Jan 28 21:33:50 SunSTG kernel:  [<f8d65b0c>] raid5d+0x10b/0x130
> [raid456]
> Jan 28 21:33:50 SunSTG kernel:  [<c059aca8>] md_thread+0xdf/0xf5
> Jan 28 21:33:50 SunSTG kernel:  [<c0436347>] autoremove_wake_function
> +0x0/0x2d
> Jan 28 21:33:50 SunSTG kernel:  [<c059abc9>] md_thread+0x0/0xf5
> Jan 28 21:33:51 SunSTG kernel:  [<c0436285>] kthread+0xc0/0xeb
> Jan 28 21:33:51 SunSTG kernel:  [<c04361c5>] kthread+0x0/0xeb
> Jan 28 21:33:51 SunSTG kernel:  [<c0405c3b>] kernel_thread_helper
> +0x7/0x10
> Jan 28 21:33:51 SunSTG kernel:  =======================
> ... and it goes on complaining about md4_raid5:5694.
> 
> [root@SunSTG ~]# mdadm --detail /dev/md3
> /dev/md3:
>         Version : 00.90.03
>   Creation Time : Wed Jan 28 21:30:50 2009
>      Raid Level : raid6
>      Array Size : 5372294400 (5123.42 GiB 5501.23 GB)
>   Used Dev Size : 244195200 (232.88 GiB 250.06 GB)
>    Raid Devices : 24
>   Total Devices : 24
> Preferred Minor : 3
>     Persistence : Superblock is persistent
> 
>     Update Time : Wed Jan 28 21:30:50 2009
>           State : clean, resyncing
>  Active Devices : 24
> Working Devices : 24
>  Failed Devices : 0
>   Spare Devices : 0
> 
>      Chunk Size : 64K
> 
>  Rebuild Status : 15% complete
> 
>            UUID : d8c2b5ce:576a117b:f2494cd1:626a774c
>          Events : 0.1
> 
>     Number   Major   Minor   RaidDevice State
>        0       8        0        0      active sync   /dev/sda
>        1      65      160        1      active sync   /dev/sdaa
>        2      65      176        2      active sync   /dev/sdab
>        3      65      208        3      active sync   /dev/sdad
>        4      65      224        4      active sync   /dev/sdae
>        5      65      240        5      active sync   /dev/sdaf
>        6      66        0        6      active sync   /dev/sdag
>        7      66       16        7      active sync   /dev/sdah
>        8      66       32        8      active sync   /dev/sdai
>        9      66       48        9      active sync   /dev/sdaj
>       10      66       64       10      active sync   /dev/sdak
>       11      66       80       11      active sync   /dev/sdal
>       12      66       96       12      active sync   /dev/sdam
>       13      66      112       13      active sync   /dev/sdan
>       14      66      128       14      active sync   /dev/sdao
>       15      66      144       15      active sync   /dev/sdap
>       16      66      160       16      active sync   /dev/sdaq
>       17      66      176       17      active sync   /dev/sdar
>       18      66      192       18      active sync   /dev/sdas
>       19      66      208       19      active sync   /dev/sdat
>       20      66      224       20      active sync   /dev/sdau
>       21      66      240       21      active sync   /dev/sdav
>       22       8       16       22      active sync   /dev/sdb
>       23       8       32       23      active sync   /dev/sdc
> [root@SunSTG ~]# mdadm --detail /dev/md4
> /dev/md4:
>         Version : 00.90.03
>   Creation Time : Wed Jan 28 21:32:39 2009
>      Raid Level : raid6
>      Array Size : 4883904000 (4657.65 GiB 5001.12 GB)
>   Used Dev Size : 244195200 (232.88 GiB 250.06 GB)
>    Raid Devices : 22
>   Total Devices : 22
> Preferred Minor : 4
>     Persistence : Superblock is persistent
> 
>     Update Time : Wed Jan 28 21:32:39 2009
>           State : clean, resyncing
>  Active Devices : 22
> Working Devices : 22
>  Failed Devices : 0
>   Spare Devices : 0
> 
>      Chunk Size : 64K
> 
>  Rebuild Status : 17% complete
> 
>            UUID : 7e2c7f35:f51c9047:40130c15:63a7cfa6
>          Events : 0.1
> 
>     Number   Major   Minor   RaidDevice State
>        0       8       48        0      active sync   /dev/sdd
>        1       8       64        1      active sync   /dev/sde
>        2       8       80        2      active sync   /dev/sdf
>        3       8       96        3      active sync   /dev/sdg
>        4       8      112        4      active sync   /dev/sdh
>        5       8      128        5      active sync   /dev/sdi
>        6       8      144        6      active sync   /dev/sdj
>        7       8      160        7      active sync   /dev/sdk
>        8       8      176        8      active sync   /dev/sdl
>        9       8      192        9      active sync   /dev/sdm
>       10       8      208       10      active sync   /dev/sdn
>       11       8      224       11      active sync   /dev/sdo
>       12       8      240       12      active sync   /dev/sdp
>       13      65        0       13      active sync   /dev/sdq
>       14      65       16       14      active sync   /dev/sdr
>       15      65       32       15      active sync   /dev/sds
>       16      65       48       16      active sync   /dev/sdt
>       17      65       64       17      active sync   /dev/sdu
>       18      65       80       18      active sync   /dev/sdv
>       19      65       96       19      active sync   /dev/sdw
>       20      65      112       20      active sync   /dev/sdx
>       21      65      144       21      active sync   /dev/sdz
> 
> 
> -- 
> Best Regards,
> Vladimir Ivashchenko
> Chief Technology Officer
> PrimeTel PLC, Cyprus - www.prime-tel.com
> Tel: +357 25 100100 Fax: +357 2210 2211
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
