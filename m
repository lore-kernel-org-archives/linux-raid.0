From: NeilBrown <neilb@suse.de>
Subject: Re: raid1d crash at boot
Date: Mon, 9 Jan 2012 12:35:52 +1100
Message-ID: <20120109123552.4a5f44de@notabene.brown>
References: <20111119134139.GA30570@rere.qmqm.pl>
	<20120107125303.GA4862@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/tB70hh0Kpf_F2aaqaDTXrun"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120107125303.GA4862@rere.qmqm.pl>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/tB70hh0Kpf_F2aaqaDTXrun
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 7 Jan 2012 13:53:04 +0100 Micha=C5=82 Miros=C5=82aw <mirq-linux@rer=
e.qmqm.pl>
wrote:

> On Sat, Nov 19, 2011 at 02:41:39PM +0100, Micha=C5=82 Miros=C5=82aw wrote:
> > I get following BUG_ON tripped while booting, before rootfs is mounted =
by
> > Debian's initrd. This started to happen for kernels since sometime
> > during 3.1-rcX.
> >=20
> > [    6.246170] ------------[ cut here ]------------
> > [    6.246246] kernel BUG at /mnt/src-tmp/jaja/git/qmqm/drivers/scsi/sc=
si_lib.c:1153!
> > [    6.246347] invalid opcode: 0000 [#1] PREEMPT SMP
> > [    6.246558] CPU 5
> > [    6.246614] Modules linked in: usb_storage uas firewire_ohci firewir=
e_core crc_itu_t xhci_hcd [last unloaded: scsi_wait_scan]
> > [    6.247131]
> > [    6.247194] Pid: 288, comm: md1_raid1 Not tainted 3.2.0-rc2mq+ #5 Sy=
stem manufacturer System Product Name/P8Z68-V PRO
> > [    6.247422] RIP: 0010:[<ffffffff812443a1>]  [<ffffffff812443a1>] scs=
i_setup_fs_cmnd+0x45/0x83
> > [    6.247563] RSP: 0018:ffff8804140d1bd0  EFLAGS: 00010046
> > [    6.247634] RAX: 0000000000000000 RBX: ffff88041d463800 RCX: 0000000=
0ffffffff
> > [    6.247710] RDX: 00000000ffffffff RSI: ffff8804142fd600 RDI: ffff880=
41d463800
> > [    6.247785] RBP: ffff8804142fd600 R08: 00000000ffffffff R09: 0000000=
000017a00
> > [    6.247861] R10: ffff88041d464000 R11: ffff88041d464000 R12: 0000000=
000000800
> > [    6.247936] R13: 0000000000000001 R14: ffff88041d463800 R15: 0000000=
000000000
> > [    6.248013] FS:  0000000000000000(0000) GS:ffff88042fb40000(0000) kn=
lGS:0000000000000000
> > [    6.248104] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > [    6.248176] CR2: 000000000042b200 CR3: 0000000001605000 CR4: 0000000=
0000406e0
> > [    6.248252] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
> > [    6.248328] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
> > [    6.248404] Process md1_raid1 (pid: 288, threadinfo ffff8804140d0000=
, task ffff88041539a4c0)
> > [    6.248495] Stack:
> > [    6.248557]  0000000000000000 ffff8804142fd600 ffff8804142fd600 ffff=
ffff8124a9be
> > [    6.248819]  ffff8804142fe3a0 ffff8804142fd600 ffff88041d463848 ffff=
ffff811a5d67
> > [    6.249084]  ffff8804142fe3a0 ffff880415452400 ffff8804156f0000 0000=
0000fffffa2b
> > [    6.249346] Call Trace:
> > [    6.249414]  [<ffffffff8124a9be>] ? sd_prep_fn+0x2cd/0xb72
> > [    6.249490]  [<ffffffff811a5d67>] ? cfq_dispatch_requests+0x6f2/0x82c
> > [    6.249567]  [<ffffffff8119a168>] ? blk_peek_request+0xc8/0x1bf
> > [    6.249638]  [<ffffffff81243d83>] ? scsi_request_fn+0x64/0x406
> > [    6.249708]  [<ffffffff8119a526>] ? blk_flush_plug_list+0x186/0x1b7
> > [    6.249780]  [<ffffffff8119a562>] ? blk_finish_plug+0xb/0x2a
> > [    6.249849]  [<ffffffff812a400f>] ? raid1d+0x91/0xb22
> > [    6.249919]  [<ffffffff81031729>] ? get_parent_ip+0x9/0x1b
> > [    6.249990]  [<ffffffff813a5c9e>] ? sub_preempt_count+0x83/0x94
> > [    6.250060]  [<ffffffff813a202a>] ? schedule+0x73f/0x772
> > [    6.250129]  [<ffffffff813a5d49>] ? add_preempt_count+0x9a/0x9c
> > [    6.250199]  [<ffffffff813a330b>] ? _raw_spin_lock_irqsave+0x13/0x31
> > [    6.250271]  [<ffffffff812a9bb4>] ? md_thread+0xfe/0x11c
> > [    6.250340]  [<ffffffff8104f6c6>] ? add_wait_queue+0x3c/0x3c
> > [    6.250410]  [<ffffffff812a9ab6>] ? signal_pending+0x17/0x17
> > [    6.250479]  [<ffffffff8104f045>] ? kthread+0x76/0x7e
> > [    6.250548]  [<ffffffff813a8c34>] ? kernel_thread_helper+0x4/0x10
> > [    6.250618]  [<ffffffff8104efcf>] ? kthread_worker_fn+0x139/0x139
> > [    6.250688]  [<ffffffff813a8c30>] ? gs_change+0xb/0xb
> > [    6.250754] Code: 85 c0 74 1d 48 8b 00 48 85 c0 74 15 48 8b 40 50 48=
 85 c0 74 0c 48 89 ee 48 89 df ff d0 85 c0 75 44 66 83 bd d0 00 00 00 00 75=
 02 <0f> 0b 48 89 ee 48 89 df e8 b6 e9 ff ff 48 85 c0 48 89 c2 74 20
> > [    6.253544] RIP  [<ffffffff812443a1>] scsi_setup_fs_cmnd+0x45/0x83
> > [    6.253658]  RSP <ffff8804140d1bd0>
> > [    6.253722] ---[ end trace 533b0b5008dd7cee ]---
> > [    6.253788] note: md1_raid1[288] exited with preempt_count 1
>=20
> I've bisected this to following commit. It's not trivially revertable on =
v3.2,
> but I'll do some tries with it.

Thanks for doing that - it is a great help.

And you were right - the write-mostly flag is relevant.

Please test this patch - it should fix the problem.

Thanks,
NeilBrown

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index cc24f0c..a368db2 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -531,8 +531,17 @@ static int read_balance(struct r1conf *conf, struct r1=
bio *r1_bio, int *max_sect
 		if (test_bit(WriteMostly, &rdev->flags)) {
 			/* Don't balance among write-mostly, just
 			 * use the first as a last resort */
-			if (best_disk < 0)
+			if (best_disk < 0) {
+				if (is_badblock(rdev, this_sector, sectors,
+						&first_bad, &bad_sectors)) {
+					if (first_bad < this_sector)
+						/* Cannot use this */
+						continue;
+					best_good_sectors =3D first_bad - this_sector;
+				} else
+					best_good_sectors =3D sectors;
 				best_disk =3D disk;
+			}
 			continue;
 		}
 		/* This is a reasonable device to use.  It might


--Sig_/tB70hh0Kpf_F2aaqaDTXrun
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTwpEeDnsnt1WYoG5AQIYmxAAiWtgaYTe5WnCbxZwwe/1XROAug9W1yX5
IThy6Ljt1g5+eABQvtsgV5iWqQ/h1qs6gTTfdtD/2YoLjTpwPwtBUkMWeA50LrO9
P99dEq0m7MDHc7BlZrU/GtgDz5Q70jrA8iOXB4039DljVq0ZmZ1Zg5xJ8XFEIjkL
sP9n4+F276palkTdVVWyWoUnLP1M2HlKb2P8Tj77lDk5SuZxdKzOVv1jXNkA1Vlo
gShKY3hCz5oTyWX/hLW1Ctmx2Y07trwfl66WeXSz7dygIVbEzGWcMCx04drT3Lr5
Oj0NcZfMtdP/Iu/La39hCpp2s3S88OU8AzE/35fyOvnxXVb+XkrHwstVs0AnsPwa
YD49PCL3YZu6P9MWqUf8P9SKRLpJoRicdjaPHKMnoICc1YYDVIQq+4Y06LnOKlTe
TNxjA1HGlDuPkkdbkDE4Y/Cgj+wsc56Kgq4fsutGls38NbkOX8AOUYkZtEnpObwe
xDLj8gwtTLRd105L+I/Jz89YAqO2BHkb0C2spTgt8WyuGAP46N0PzGATG+ToT1w0
E1Q2IM20gptjw631m0JVCJ1nAv594HackVeM/OpkGJvBiLu9tSCVOgpHPKtiToU6
c0BtCG2yuM25BIv2SgQyyWaIGD1+8+lDdmwtTWPoU2iYnfHEhTMsICPA0BjUkmPv
Jsw2hyy8iMo=
=5LhT
-----END PGP SIGNATURE-----

--Sig_/tB70hh0Kpf_F2aaqaDTXrun--
