From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: raid5 trim OOPS / use after free?
Date: Thu, 17 Oct 2013 18:14:49 -0500
Message-ID: <52606F69.3050000@hardwarefreak.com>
References: <wrfj61svftky.fsf@redhat.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfj61svftky.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>, linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>, Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shli@fusionio.com>
List-Id: linux-raid.ids

On 10/17/2013 4:58 PM, Jes Sorensen wrote:
> Hi,
> 
> I have been trying out the trim code in recent kernels and I am
> consistently seeing crashes with the raid5 trim implementation.
> 
> I am seeing 3-4 different OOPS outputs which are very different in their
> output. This makes me suspect this is a memory corruption of use after
> free problem?
> 
> Basically I have a system with an AHCI controller and 4 SATA SSD drives
> hooked up to it. I create a raid5 and then run mkfs.ext4 on it and the
> fireworks display starts.
> 
> I first saw this with an older kernel with some backports applied, but I
> am able to reproduce this with the current top of tree out of Linus'
> tree.
> 
> Any ideas?

See a nearly identical problem posted to this list yesterday:

http://www.spinics.net/lists/raid/msg44686.html



> Jes
> 
> 
> commit 83f11a9cf2578b104c0daf18fc9c7d33c3d6d53a
> Merge: 02a3250 a37f863
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Thu Oct 17 10:39:01 2013 -0700
> 
> 
> [root@noisybay ~]# mdadm --zero-superblock /dev/sd[efgh]3 ; mdadm --create -e 1.2 --level=5 --raid-devices=4 /dev/md99 /dev/sd[efgh]3 
> mdadm: array /dev/md99 started.
> [root@noisybay ~]# mkfs.ext4 /dev/md99
> ....
> 
> md: bind<sdf3>
> md: bind<sdg3>
> md: bind<sdh3>
> async_tx: api initialized (async)
> xor: automatically using best checksumming function:
>    avx       : 25848.000 MB/sec
> raid6: sse2x1    9253 MB/s
> raid6: sse2x2   11652 MB/s
> raid6: sse2x4   13738 MB/s
> raid6: using algorithm sse2x4 (13738 MB/s)
> raid6: using ssse3x2 recovery algorithm
> md: raid6 personality registered for level 6
> md: raid5 personality registered for level 5
> md: raid4 personality registered for level 4
> md/raid:md99: device sdg3 operational as raid disk 2
> md/raid:md99: device sdf3 operational as raid disk 1
> md/raid:md99: device sde3 operational as raid disk 0
> md/raid:md99: allocated 4344kB
> md/raid:md99: raid level 5 active with 3 out of 4 devices, algorithm 2
> md99: detected capacity change from 0 to 119897849856
> md: recovery of RAID array md99
>  md99: unknown partition table
> md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
> md: using 128k window, over a total of 39029248k.
> BUG: unable to handle kernel paging request at ffffffff00000004
> IP: [<ffffffff8124e336>] __blk_segment_map_sg+0x66/0x140
> PGD 1a0c067 PUD 0 
> Oops: 0000 [#1] SMP 
> Modules linked in: raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx ip6table_filter ip6_tables ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge autofs4 8021q garp stp llc cpufreq_ondemand ipv6 dm_mirror dm_region_hash dm_log dm_mod vhost_net macvtap macvlan vhost tun kvm_intel kvm uinput iTCO_wdt iTCO_vendor_support microcode pcspkr i2c_i801 i2c_core sg video acpi_cpufreq freq_table lpc_ich mfd_core e1000e ptp pps_core ext4 jbd2 mbcache sd_mod crc_t10dif crct10dif_common usb_storage ahci libahci
> CPU: 2 PID: 2651 Comm: md99_raid5 Not tainted 3.12.0-rc5+ #16
> Hardware name: Intel Corporation S1200BTL/S1200BTL, BIOS S1200BT.86B.02.00.0035.030220120927 03/02/2012
> task: ffff8800378e2040 ti: ffff8802338d2000 task.ti: ffff8802338d2000
> RIP: 0010:[<ffffffff8124e336>]  [<ffffffff8124e336>] __blk_segment_map_sg+0x66/0x140
> RSP: 0018:ffff8802338d39a8  EFLAGS: 00010082
> RAX: ffffffff00000004 RBX: ffff880235b05e38 RCX: ffffea0007b848b8
> RDX: ffffffff00000004 RSI: 0000000000000000 RDI: ffff88023436f020
> RBP: ffff8802338d39d8 R08: 0000000000002000 R09: 0000000000000000
> R10: 0000160000000000 R11: 0000000234a6e000 R12: ffff8802338d3a18
> R13: ffff8802338d3a10 R14: ffff8802338d3a24 R15: 0000000000001000
> FS:  0000000000000000(0000) GS:ffff88023ee40000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffff00000004 CR3: 0000000001a0b000 CR4: 00000000001407e0
> Stack:
>  ffff880233ccf5d8 0000000000000001 ffff880235b05d38 ffff8802338d3a20
>  ffff88023436e880 ffff8802338d3a24 ffff8802338d3a58 ffffffff8124e58b
>  ffff8802338d3a20 000000010000007f ffff880233c92678 ffff8802342b4ae0
> Call Trace:
>  [<ffffffff8124e58b>] blk_rq_map_sg+0x9b/0x210
>  [<ffffffff81398460>] scsi_init_sgtable+0x40/0x70
>  [<ffffffff8139873d>] scsi_init_io+0x3d/0x170
>  [<ffffffff81390c89>] ? scsi_get_command+0x89/0xc0
>  [<ffffffff813989e4>] scsi_setup_blk_pc_cmnd+0x94/0x180
>  [<ffffffffa003e2b2>] sd_setup_discard_cmnd+0x182/0x270 [sd_mod]
>  [<ffffffffa003e438>] sd_prep_fn+0x98/0xbd0 [sd_mod]
>  [<ffffffff813ad880>] ? ata_scsiop_mode_sense+0x3c0/0x3c0
>  [<ffffffff813ab227>] ? ata_scsi_translate+0xa7/0x180
>  [<ffffffff81248671>] blk_peek_request+0x111/0x270
>  [<ffffffff81397c60>] scsi_request_fn+0x60/0x550
>  [<ffffffff81247177>] __blk_run_queue+0x37/0x50
>  [<ffffffff812477ae>] queue_unplugged+0x4e/0xb0
>  [<ffffffff81248958>] blk_flush_plug_list+0x158/0x1e0
>  [<ffffffff812489f8>] blk_finish_plug+0x18/0x50
>  [<ffffffffa0489884>] raid5d+0x314/0x380 [raid456]
>  [<ffffffff815557e9>] ? schedule+0x29/0x70
>  [<ffffffff815531f5>] ? schedule_timeout+0x195/0x220
>  [<ffffffff810706ce>] ? prepare_to_wait+0x5e/0x90
>  [<ffffffff8143b8bf>] md_thread+0x11f/0x170
>  [<ffffffff81070360>] ? wake_up_bit+0x40/0x40
>  [<ffffffff8143b7a0>] ? md_rdev_init+0x110/0x110
>  [<ffffffff8106fb1e>] kthread+0xce/0xe0
>  [<ffffffff8106fa50>] ? kthread_freezable_should_stop+0x70/0x70
>  [<ffffffff8155f8ec>] ret_from_fork+0x7c/0xb0
>  [<ffffffff8106fa50>] ? kthread_freezable_should_stop+0x70/0x70
> Code: 45 10 8b 00 85 c0 75 5d 49 8b 45 00 48 85 c0 74 10 48 83 20 fd 49 8b 7d 00 e8 a7 bc 02 00 48 89 c2 49 89 55 00 48 8b 0b 8b 73 0c <48> 8b 02 f6 c1 03 0f 85 bf 00 00 00 83 e0 03 89 72 08 44 89 7a 
> RIP  [<ffffffff8124e336>] __blk_segment_map_sg+0x66/0x140
>  RSP <ffff8802338d39a8>
> CR2: ffffffff00000004
> ---[ end trace ef0b7ea0d0429820 ]---
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

