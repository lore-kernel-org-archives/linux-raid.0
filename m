From: Andre Noll <maan@systemlinux.org>
Subject: Re: linear : divide error: 0000
Date: Mon, 3 Nov 2008 11:32:21 +0100
Message-ID: <20081103103221.GJ17966@skl-net.de>
References: <1346d4690811020803p47f62b3ak9868832969040759@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BEa57a89OpeoUzGD"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1346d4690811020803p47f62b3ak9868832969040759@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Wei Yongquan <weiyqlq@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--BEa57a89OpeoUzGD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 00:03, Wei Yongquan wrote:
> Hi
>     When I create a linear device with two small disk(less then 576K),
> a segmentation fault occurs. follow message:
> md: bind<hda>
> md: bind<hdb>
> divide error: 0000 [#1]
> Modules linked in:
>=20
> Pid: 251, comm: mdadm.static Not tainted (2.6.27.4 #2)
> EIP: 0060:[<c02ee9d0>] EFLAGS: 00000202 CPU: 0
> EIP is at linear_conf+0x1e0/0x2f0
> EAX: 00000381 EBX: 00000000 ECX: 00000000 EDX: 00000000
> ESI: 00000001 EDI: c6d571e0 EBP: 00000001 ESP: c6d83c64
>  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Process mdadm.static (pid: 251, ti=3Dc6d82000 task=3Dc781ca30 task.ti=3Dc=
6d82000)
> Stack: c02f1273 00000380 00000002 c6d5a400 c6d5a410 c032c7b0 c032c7b0 000=
00002
>        00d5bc6c c6d5a400 ffffffff c6d5a484 c6d5a400 c02eebc2 c035d0c0 c02=
f670d
>        c0336ed0 ffffffff c6d81cf0 c7482ec8 00000000 00000001 c6d5a410 c6d=
5a200
> Call Trace:
>  [<c02f1273>] mddev_put+0x13/0x70
>  [<c02eebc2>] linear_run+0x22/0x80
>  [<c02f670d>] do_md_run+0x3bd/0x960
>  [<c0276ed9>] bd_claim_by_disk+0x1a9/0x280
>  [<c02f31f9>] bind_rdev_to_array+0x1d9/0x270
>  [<c023497c>] handle_level_irq+0x6c/0xa0
>  [<c0204f79>] do_IRQ+0x39/0x70
>  [<c02a3680>] cfq_merged_request+0x0/0x60
>  [<c02f8f00>] md_ioctl+0x1530/0x1a10
>  [<c0203193>] common_interrupt+0x23/0x28
>  [<c02e2910>] task_no_data_intr+0x0/0x80
>  [<c02de2aa>] ide_execute_command+0x4a/0x60
>  [<c02e2485>] do_rw_taskfile+0x1a5/0x250
>  [<c02deb72>] ide_wait_stat+0x42/0x90
>  [<c02991f2>] elv_queue_empty+0x22/0x30
>  [<c02dc53a>] ide_do_request+0x9a/0xa00
>  [<c029ae58>] submit_bio+0x48/0xd0
>  [<c0299447>] elv_drain_elevator+0x17/0x60
>  [<c029ba51>] __generic_unplug_device+0x11/0x40
>  [<c02f79d0>] md_ioctl+0x0/0x1a10
>  [<c029edad>] blkdev_driver_ioctl+0x5d/0x60
>  [<c029f051>] blkdev_ioctl+0x2a1/0x820
>  [<c029af7b>] __freed_request+0x9b/0xa0
>  [<c029afa4>] freed_request+0x24/0x50
>  [<c02e1c58>] ide_raw_taskfile+0x78/0x90
>  [<c02e1c88>] ide_no_data_taskfile+0x18/0x20
>  [<c02e505f>] ide_cacheflush_p+0x5f/0x90
>  [<c02e55de>] ide_disk_put+0x2e/0x50
>  [<c02e5693>] idedisk_release+0x43/0xb0
>  [<c0276ab5>] block_ioctl+0x15/0x20
>  [<c0276aa0>] block_ioctl
>=20
> I found the code in linear.c: +200
>             round =3D sector_div(sz, base);

This sector_div() is in linear_conf() while the call trace indicates
the bug happens in mddev_put(). I'll have a deeper look later today.

Is this a recent regression?

Thanks for the report
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--BEa57a89OpeoUzGD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJDtM1Wto1QDEAkw8RAqGaAJ0T4n1Hbzoyirq6cdjGNZZdDciIdQCfWked
HsJg4qmIdY67tztBxrUghEA=
=g29h
-----END PGP SIGNATURE-----

--BEa57a89OpeoUzGD--
