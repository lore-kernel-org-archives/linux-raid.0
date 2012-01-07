From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: Re: raid1d crash at boot
Date: Sat, 7 Jan 2012 13:53:04 +0100
Message-ID: <20120107125303.GA4862@rere.qmqm.pl>
References: <20111119134139.GA30570@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111119134139.GA30570@rere.qmqm.pl>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On Sat, Nov 19, 2011 at 02:41:39PM +0100, Micha=B3 Miros=B3aw wrote:
> I get following BUG_ON tripped while booting, before rootfs is mounte=
d by
> Debian's initrd. This started to happen for kernels since sometime
> during 3.1-rcX.
>=20
> [    6.246170] ------------[ cut here ]------------
> [    6.246246] kernel BUG at /mnt/src-tmp/jaja/git/qmqm/drivers/scsi/=
scsi_lib.c:1153!
> [    6.246347] invalid opcode: 0000 [#1] PREEMPT SMP
> [    6.246558] CPU 5
> [    6.246614] Modules linked in: usb_storage uas firewire_ohci firew=
ire_core crc_itu_t xhci_hcd [last unloaded: scsi_wait_scan]
> [    6.247131]
> [    6.247194] Pid: 288, comm: md1_raid1 Not tainted 3.2.0-rc2mq+ #5 =
System manufacturer System Product Name/P8Z68-V PRO
> [    6.247422] RIP: 0010:[<ffffffff812443a1>]  [<ffffffff812443a1>] s=
csi_setup_fs_cmnd+0x45/0x83
> [    6.247563] RSP: 0018:ffff8804140d1bd0  EFLAGS: 00010046
> [    6.247634] RAX: 0000000000000000 RBX: ffff88041d463800 RCX: 00000=
000ffffffff
> [    6.247710] RDX: 00000000ffffffff RSI: ffff8804142fd600 RDI: ffff8=
8041d463800
> [    6.247785] RBP: ffff8804142fd600 R08: 00000000ffffffff R09: 00000=
00000017a00
> [    6.247861] R10: ffff88041d464000 R11: ffff88041d464000 R12: 00000=
00000000800
> [    6.247936] R13: 0000000000000001 R14: ffff88041d463800 R15: 00000=
00000000000
> [    6.248013] FS:  0000000000000000(0000) GS:ffff88042fb40000(0000) =
knlGS:0000000000000000
> [    6.248104] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [    6.248176] CR2: 000000000042b200 CR3: 0000000001605000 CR4: 00000=
000000406e0
> [    6.248252] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000=
00000000000
> [    6.248328] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000=
00000000400
> [    6.248404] Process md1_raid1 (pid: 288, threadinfo ffff8804140d00=
00, task ffff88041539a4c0)
> [    6.248495] Stack:
> [    6.248557]  0000000000000000 ffff8804142fd600 ffff8804142fd600 ff=
ffffff8124a9be
> [    6.248819]  ffff8804142fe3a0 ffff8804142fd600 ffff88041d463848 ff=
ffffff811a5d67
> [    6.249084]  ffff8804142fe3a0 ffff880415452400 ffff8804156f0000 00=
000000fffffa2b
> [    6.249346] Call Trace:
> [    6.249414]  [<ffffffff8124a9be>] ? sd_prep_fn+0x2cd/0xb72
> [    6.249490]  [<ffffffff811a5d67>] ? cfq_dispatch_requests+0x6f2/0x=
82c
> [    6.249567]  [<ffffffff8119a168>] ? blk_peek_request+0xc8/0x1bf
> [    6.249638]  [<ffffffff81243d83>] ? scsi_request_fn+0x64/0x406
> [    6.249708]  [<ffffffff8119a526>] ? blk_flush_plug_list+0x186/0x1b=
7
> [    6.249780]  [<ffffffff8119a562>] ? blk_finish_plug+0xb/0x2a
> [    6.249849]  [<ffffffff812a400f>] ? raid1d+0x91/0xb22
> [    6.249919]  [<ffffffff81031729>] ? get_parent_ip+0x9/0x1b
> [    6.249990]  [<ffffffff813a5c9e>] ? sub_preempt_count+0x83/0x94
> [    6.250060]  [<ffffffff813a202a>] ? schedule+0x73f/0x772
> [    6.250129]  [<ffffffff813a5d49>] ? add_preempt_count+0x9a/0x9c
> [    6.250199]  [<ffffffff813a330b>] ? _raw_spin_lock_irqsave+0x13/0x=
31
> [    6.250271]  [<ffffffff812a9bb4>] ? md_thread+0xfe/0x11c
> [    6.250340]  [<ffffffff8104f6c6>] ? add_wait_queue+0x3c/0x3c
> [    6.250410]  [<ffffffff812a9ab6>] ? signal_pending+0x17/0x17
> [    6.250479]  [<ffffffff8104f045>] ? kthread+0x76/0x7e
> [    6.250548]  [<ffffffff813a8c34>] ? kernel_thread_helper+0x4/0x10
> [    6.250618]  [<ffffffff8104efcf>] ? kthread_worker_fn+0x139/0x139
> [    6.250688]  [<ffffffff813a8c30>] ? gs_change+0xb/0xb
> [    6.250754] Code: 85 c0 74 1d 48 8b 00 48 85 c0 74 15 48 8b 40 50 =
48 85 c0 74 0c 48 89 ee 48 89 df ff d0 85 c0 75 44 66 83 bd d0 00 00 00=
 00 75 02 <0f> 0b 48 89 ee 48 89 df e8 b6 e9 ff ff 48 85 c0 48 89 c2 74=
 20
> [    6.253544] RIP  [<ffffffff812443a1>] scsi_setup_fs_cmnd+0x45/0x83
> [    6.253658]  RSP <ffff8804140d1bd0>
> [    6.253722] ---[ end trace 533b0b5008dd7cee ]---
> [    6.253788] note: md1_raid1[288] exited with preempt_count 1

I've bisected this to following commit. It's not trivially revertable o=
n v3.2,
but I'll do some tries with it.

Best Regards,
Micha=B3 Miros=B3aw

---

commit d2eb35acfdccbe2a3622ed6cc441a5482148423b
Author: NeilBrown <neilb@suse.de>
Date:   Thu Jul 28 11:31:48 2011 +1000

    md/raid1: avoid reading from known bad blocks.
   =20
    Now that we have a bad block list, we should not read from those
    blocks.
    There are several main parts to this:
      1/ read_balance needs to check for bad blocks, and return not onl=
y
         the chosen device, but also how many good blocks are available
         there.
      2/ fix_read_error needs to avoid trying to read from bad blocks.
      3/ read submission must be ready to issue multiple reads to
         different devices as different bad blocks on different devices
         could mean that a single large read cannot be served by any on=
e
         device, but can still be served by the array.
         This requires keeping count of the number of outstanding reque=
sts
         per bio.  This count is stored in 'bi_phys_segments'
      4/ retrying a read needs to also be ready to submit a smaller rea=
d
         and queue another request for the rest.
   =20
    This does not yet handle bad blocks when reading to perform resync,
    recovery, or check.
   =20
    'md_trim_bio' will also be used for RAID10, so put it in md.c and
    export it.
   =20
    Signed-off-by: NeilBrown <neilb@suse.de>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
