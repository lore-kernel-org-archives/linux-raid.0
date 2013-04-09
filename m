From: Kevin Liao <kevinliao@qnap.com>
Subject: Re: Raid 5/10 discard support broken in 3.8.2
Date: Tue, 9 Apr 2013 22:14:23 +0800
Message-ID: <CAOoaTqWbU05m72fhW97a2FFAt+00hhfeWOSUUERbN-ZQukN85w@mail.gmail.com>
References: <CAKHEz2a+gwCzj16s3P3UOFMezC=CFe3D2002yyNsA_E5+-Ci6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKHEz2a+gwCzj16s3P3UOFMezC=CFe3D2002yyNsA_E5+-Ci6Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Cundiff <syshackmin@gmail.com>
Cc: Linux MDADM Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2013/3/6 Dave Cundiff <syshackmin@gmail.com>
>
> Hi all,
>
> It appears the Raid 5/10 discard support does not work in the mainline kernel.
>
> I've been trying to backport it to a RHEL 6 kernel without success. I
> finally managed to setup a mainline dev box and discovered it doesn't
> work on it either!
>
> I'm now testing on a stock 3.8.2 kernel. The drives I'm using are
> Samsung 840 Pro's hanging off an LSI 9211-8i. No backplane and each
> drive has a dedicated channel. No RAID on the LSI, its just an HBA.
>
> As for Raid5 that just explodes on a BUG.
>
> This Raid5:
> mdadm -C /dev/md126 -n6 -l5 --assume-clean /dev/sda3 /dev/sdb3
> /dev/sdc3 /dev/sdd3 /dev/sde3 /dev/sdf3
>
> Outputs 2 sets of kprints
>
> granularity: 65535
> alignment: 42966
> max_discard_sectors: 8388607
> max_discard_sectors: 8388480
> granularity: 65535
> alignment: 42966
> max_discard_sectors: 8388607
> max_discard_sectors: 8388480
>
> and then dies on a BUG
>
> ------------[ cut here ]------------
> kernel BUG at drivers/scsi/scsi_lib.c:1028!
> invalid opcode: 0000 [#1] SMP
> Modules linked in: raid456 async_raid6_recov async_pq raid6_pq
> async_xor xor async_memcpy async_tx xt_REDIRECT ipt_MASQUERADE
> iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4
> xt_DSCP iptable_mangle iptable_filter nf_conntrack_ftp
> nf_conntrack_irc xt_TCPMSS xt_owner xt_mac xt_length xt_ecn xt_LOG
> xt_recent xt_limit xt_multiport xt_conntrack ipt_ULOG ipt_REJECT
> ip_tables sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state
> nf_conntrack ip6table_filter ip6_tables ext3 jbd dm_mod gpio_ich
> iTCO_wdt iTCO_vendor_support coretemp hwmon acpi_cpufreq freq_table
> mperf kvm_intel kvm microcode serio_raw pcspkr i2c_i801 lpc_ich
> snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm
> snd_timer snd soundcore snd_page_alloc ioatdma dca i7core_edac
> edac_core sg ext4 mbcache jbd2 raid1 raid10 sd_mod crc_t10dif
> crc32c_intel pata_acpi ata_generic ata_piix e1000e mpt2sas
> scsi_transport_sas raid_class mgag200 ttm drm_kms_helper be2iscsi
> bnx2i cnic uio ipv6 cxgb4i cxgb4 cxgb3i libcxgbi cxgb3 mdio
> libiscsi_tcp qla4xxx iscsi_boot_sysfs libiscsi scsi_transport_iscsi
> CPU 7
> Pid: 6993, comm: md127_raid5 Not tainted 3.8.2-1.el6.x86_64 #2
> Supermicro X8DTL/X8DTL
> RIP: 0010:[<ffffffff813fe5e2>]  [<ffffffff813fe5e2>] scsi_init_sgtable+0x62/0x70
> RSP: 0018:ffff88032d9e5a98  EFLAGS: 00010006
> RAX: 000000000000007f RBX: ffff88062bbd0d90 RCX: ffff88032ccc1808
> RDX: ffff8805618ed080 RSI: ffffea000b202540 RDI: 0000000000000000
> RBP: ffff88032d9e5aa8 R08: 0000160000000000 R09: 000000032df23000
> R10: 000000032dc18000 R11: 0000000000000000 R12: ffff88062bbf1518
> R13: 0000000000000000 R14: 0000000000000020 R15: 000000000007f000
> FS:  0000000000000000(0000) GS:ffff88063fc60000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000002024360 CR3: 000000032ed69000 CR4: 00000000000007e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process md127_raid5 (pid: 6993, threadinfo ffff88032d9e4000, task
> ffff88032c30e040)
> Stack:
>  ffff88062bbf14c0 ffff88062bbd0d90 ffff88032d9e5af8 ffffffff813fe89d
>  ffff88032cdbe800 0000000000000086 ffff88032d9e5af8 ffff88062bbd0d90
>  ffff88062bbf14c0 0000000000000000 ffff88032cdbe800 000000000007f000
> Call Trace:
>  [<ffffffff813fe89d>] scsi_init_io+0x3d/0x170
>  [<ffffffff813feb44>] scsi_setup_blk_pc_cmnd+0x94/0x180
>  [<ffffffffa023d1f2>] sd_setup_discard_cmnd+0x182/0x270 [sd_mod]
>  [<ffffffffa023d378>] sd_prep_fn+0x98/0xbd0 [sd_mod]
>  [<ffffffff8129ae00>] ? list_sort+0x1b0/0x3c0
>  [<ffffffff8126ba1e>] blk_peek_request+0xce/0x220
>  [<ffffffff813fddd0>] scsi_request_fn+0x60/0x540
>  [<ffffffff8126a5e7>] __blk_run_queue+0x37/0x50
>  [<ffffffff8126abae>] queue_unplugged+0x4e/0xb0
>  [<ffffffff8126bcf6>] blk_flush_plug_list+0x156/0x230
>  [<ffffffff8126bde8>] blk_finish_plug+0x18/0x50
>  [<ffffffffa067b602>] raid5d+0x282/0x2a0 [raid456]
>  [<ffffffff8149d1f7>] md_thread+0x117/0x150
>  [<ffffffff8107bfd0>] ? wake_up_bit+0x40/0x40
>  [<ffffffff8149d0e0>] ? md_rdev_init+0x110/0x110
>  [<ffffffff8107b73e>] kthread+0xce/0xe0
>  [<ffffffff8107b670>] ? kthread_freezable_should_stop+0x70/0x70
>  [<ffffffff815dbeec>] ret_from_fork+0x7c/0xb0
>  [<ffffffff8107b670>] ? kthread_freezable_should_stop+0x70/0x70
> Code: 49 8b 14 24 e8 f0 31 e7 ff 41 3b 44 24 08 77 1b 41 89 44 24 08
> 8b 43 54 41 89 44 24 10 31 c0 5b 41 5c c9 c3 b8 02 00 00 00 eb f4 <0f>
> 0b eb fe 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 66 66 66
> RIP  [<ffffffff813fe5e2>] scsi_init_sgtable+0x62/0x70
>  RSP <ffff88032d9e5a98>
> ---[ end trace 5aea2a41495b91fc ]---
> Kernel panic - not syncing: Fatal exception
>
> That BUG is in
>
>   /*
>    * Next, walk the list, and fill in the addresses and sizes of
>    * each segment.
>    */
>   count = blk_rq_map_sg(req->q, req, sdb->table.sgl);
>   BUG_ON(count > sdb->table.nents);
>   sdb->table.nents = count;
>   sdb->length = blk_rq_bytes(req);
>   return BLKPREP_OK;
>
> WAAAY over my head.
>
> So at this point I'm unsure how to continue. My total time in kernel
> code numbers in hours(maybe days). :)
>
> My Backport to RHEL works if I increase the chunk size to 65536 as
> well. I could go with that but I'm fairly certain such huge chunks may
> cause an IO issue even on a crazy fast SSD array.
>

Hi Dave and all,

May I ask about the status of this problem? I am trying to backport discard
support to kernel 3.4 but have almost the same kernel bug and error message.
Thanks a lot.

Regards,
Kevin
