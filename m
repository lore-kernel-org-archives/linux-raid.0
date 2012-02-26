From: NeilBrown <neilb@suse.de>
Subject: Re: md:When opened /proc/mdstat, increase the refcount of
Date: Sun, 26 Feb 2012 16:26:59 +1100
Message-ID: <20120226162659.5aeb1d4e@notabene.brown>
References: <201202261255005786849@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/hefp49IbhIZk4Z8UoF7KrgQ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201202261255005786849@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/hefp49IbhIZk4Z8UoF7KrgQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 26 Feb 2012 12:55:03 +0800 "majianpeng" <majianpeng@gmail.com> wrot=
e:

> >From 07a0eeb62a7bedec3f3312aff24ef62fbb36d820 Mon Sep 17 00:00:00 2001
> From: majianpeng <majianpeng@gmail.com>
> Date: Sun, 26 Feb 2012 20:43:05 +0800
> Subject: [PATCH] md:When opened /proc/mdstat, increase the refcount of
>  md-mod.ko
>=20
>     If md configured module, polled /proc/mdstat and removed the md-mod
>     can incur oops problem.
>=20
>     Reproduce this bug by following step:
>     1:configure md is module and insmod
>     2:poll(/proc/mdstat,timeout)
>     3:remove md-mod.ko
>     4:oops occur
>=20
> [  343.764057] BUG: unable to handle kernel paging request at
> ffffffffa007f9e0
> [  343.764101] IP: [<ffffffff8155578c>] _raw_spin_lock_irqsave+0xc/0x30
> [  343.764133] PGD 1807067 PUD 180b063 PMD b7b72067 PTE 0
> [  343.764167] Oops: 0002 [#1] SMP
> [  343.764190] CPU 3
> [  343.764205] Modules linked in: ext4 jbd2 crc16 async_pq async_xor xor
> async_memcpy async_raid6_recov raid6_pq async_tx sata_sil e1000e mvsas
> libsas scsi_transport_sas [last unloaded: md_mod]
> [  343.764304]
> [  343.764312] Pid: 5454, comm: udisks-daemon Not tainted 3.3.0-rc4+ #13
> To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M.
> [  343.764366] RIP: 0010:[<ffffffff8155578c>]  [<ffffffff8155578c>]
> _raw_spin_lock_irqsave+0xc/0x30
> [  343.764403] RSP: 0018:ffff8800a514bab8  EFLAGS: 00010082
> [  343.764423] RAX: 0000000000000282 RBX: ffffffffa007f9e0 RCX:
> ffff8800ba0051a8
> [  343.764448] RDX: 0000000000000100 RSI: ffff8800a514bc48 RDI:
> ffffffffa007f9e0
> [  343.764473] RBP: ffff8800a514bab8 R08: ffff8800a9bdb630 R09:
> 0000000000000001
> [  343.764499] R10: 0000000000000000 R11: 0000000000000000 R12:
> ffff8800a514bc48
> [  343.764524] R13: ffff8800a514bb88 R14: ffff8800a514be2c R15:
> 0000000000000000
> [  343.764551] FS:  00007fec6a4567c0(0000) GS:ffff8800bdb80000(0000)
> knlGS:0000000000000000
> [  343.764582] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  343.764603] CR2: ffffffffa007f9e0 CR3: 00000000a50f5000 CR4:
> 00000000000406e0
> [  343.764628] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [  343.764653] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [  343.764679] Process udisks-daemon (pid: 5454, threadinfo
> ffff8800a514a000, task ffff8800b7c41d80)
> [  343.764710] Stack:
> [  343.764719]  ffff8800a514bad8 ffffffff81054ceb 0000000000000003
> ffff8800a514bc38
> [  343.764756]  ffff8800a514bb28 ffffffff8112e216 ffff8800a514baf8
> 0000000000000000
> [  343.764794]  ffff8800a514bb28 000000000128ed20 ffff8800a514bef8
> 0000000000000001
> [  343.764830] Call Trace:
> [  343.764842]  [<ffffffff81054ceb>] remove_wait_queue+0x1b/0x60
> [  343.764864]  [<ffffffff8112e216>] poll_freewait+0x46/0xd0
> [  343.764884]  [<ffffffff8112f6e6>] do_sys_poll+0x416/0x500
> [  343.764905]  [<ffffffff8112e2a0>] ? poll_freewait+0xd0/0xd0
> [  343.764926]  [<ffffffff8112e390>] ? __pollwait+0xf0/0xf0
> [  343.764953]  [<ffffffff8112e390>] ? __pollwait+0xf0/0xf0
> [  343.764979]  [<ffffffff8112e390>] ? __pollwait+0xf0/0xf0
> [  343.765002]  [<ffffffff8112e390>] ? __pollwait+0xf0/0xf0
> [  343.765002]  [<ffffffff8112e390>] ? __pollwait+0xf0/0xf0
> [  343.765002]  [<ffffffff8143aec6>] ? verify_iovec+0x56/0xd0
> [  343.765002]  [<ffffffff8142eb76>] ? __sys_sendmsg+0x376/0x380
> [  343.765156]  [<ffffffff810f7459>] ? handle_mm_fault+0x139/0x240
> [  343.765156]  [<ffffffff81156b0a>] ? fsnotify+0x1ca/0x2b0
> [  343.765156]  [<ffffffff811d0388>] ?
> selinux_file_permission+0xe8/0x130
> [  343.765156]  [<ffffffff81077408>] ? ktime_get_ts+0xa8/0xe0
> [  343.765156]  [<ffffffff8112e58a>] ? poll_select_set_timeout+0x7a/0x90
> [  343.765156]  [<ffffffff8112f896>] sys_poll+0x66/0x100
> [  343.765156]  [<ffffffff8155d162>] system_call_fastpath+0x16/0x1b
> [  343.765156] Code: 8a 00 01 00 00 89 d0 f0 66 0f b1 0f 66 39 d0 0f 94
> c0 0f b6 c0 5d c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 9c 58 fa ba 00 01
> 00 00 <f0> 66 0f c1 17 0f b6 ce 38 d1 74 11 0f 1f 84 00 00 00 00 00 f3
> [  343.765156] RIP  [<ffffffff8155578c>] _raw_spin_lock_irqsave+0xc/0x30
> [  343.765156]  RSP <ffff8800a514bab8>
> [  343.765156] CR2: ffffffffa007f9e0
> [  343.791890] ---[ end trace 10ed0211ce0a5736 ]---
>=20
> Signed-off-by: majianpeng <majianpeng@gmail.com>
> ---
>  drivers/md/md.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ce88755..105c7f9 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6859,9 +6859,15 @@ static int md_seq_open(struct inode *inode, struct=
 file *file)
> =20
>  	seq =3D file->private_data;
>  	seq->poll_event =3D atomic_read(&md_event_count);
> +	__module_get(THIS_MODULE);
>  	return error;
>  }
> =20
> +static int md_seq_release(struct inode *inode, struct file *file)
> +{
> +	module_put(THIS_MODULE);
> +	return seq_release_private(inode, file);
> +}
>  static unsigned int mdstat_poll(struct file *filp, poll_table *wait)
>  {
>  	struct seq_file *seq =3D filp->private_data;
> @@ -6882,7 +6888,7 @@ static const struct file_operations md_seq_fops =3D=
 {
>  	.open           =3D md_seq_open,
>  	.read           =3D seq_read,
>  	.llseek         =3D seq_lseek,
> -	.release	=3D seq_release_private,
> +	.release	=3D md_seq_release,
>  	.poll		=3D mdstat_poll,
>  };
> =20

Thanks for the report and the patch.
However I think the problem should be fixed in procfs.
md_set_fops contains
	.owner		=3D THIS_MODULE,

and procfs should be able to use this to keep a reference on the module
whenever the file is open.  It seems that it doesn't.
Fixing this in procfs is more general than just fixing it in md, and also it
is likely to be safe.  Having a module take a reference to itself is usually
racy and should be avoided.

Could you see if it can be fixed in procfs?

Thanks,
NeilBrown

--Sig_/hefp49IbhIZk4Z8UoF7KrgQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT0nCoznsnt1WYoG5AQIbSQ/9HN+VLIKL5yGmpEdwUHu0bo23HYn7A9UQ
G2jtNMUzQKKYQ5EFOgR3ECPLLS4uI6LUtmltbbpkVRHzSBIK7nmX43KbGjZU5dlz
a/B4DglqeGFTu/blAx6FgAm8f77yUWMIU1eMTLXCnaDSQ8wjQGRuXT5PVo9GGRxL
+e4jwu/BB53+R5WqpjD8LBcNilthI1IsNgm7/XiAm3lOiN8K7MryVg6fg7Ogytqt
qwXNjH4rj79bZj4qqJ7gn7htP9JG9GnlhEAcJpIlwHc9UbZDnbCrD62QnINftnEb
DlWbuIxQiM0ZZxRnqXKx56sql95RprJ/lnHKaIFrmoTedWYzVrlcR9w61UIRXDkF
PH6uEgYQ/rOpxICbqz0g5jlPBAKzJ8r51HZmhj9VBOjghCf4gvSdh8fLxAXUsbNS
0W1g/dfnSTRITRvZrhF5WEnminhGZ/Z+au28P43k7E5VhWTNctsiBHezWR3JAQaJ
EYA+lhV0VNL1vcRexPON14XJE2s4fk1ighKvaCXRPAslmO7BRf4tsbZNy/2h1DKX
Mlt5TdMy9+9RAuyNnyuRs4UMRiGSBx4aDF4JFjx3kk/zTKvNofImEjG3PQitRoto
mnutO11VNA11DAorPg3o8gdR1GqjvAFGAlg4QjXPBaVgSD/y0vEMx8FX5Chk4f+Y
uiftCm6J0fU=
=oAZ5
-----END PGP SIGNATURE-----

--Sig_/hefp49IbhIZk4Z8UoF7KrgQ--
