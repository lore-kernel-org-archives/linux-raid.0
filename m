From: NeilBrown <neilb@suse.de>
Subject: Re: Kernel oops adding bitmap
Date: Tue, 20 Mar 2012 08:32:10 +1100
Message-ID: <20120320083210.4a272426@notabene.brown>
References: <4F67627D.8050205@nuclearwinter.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/B9dzk9MA0Nl0mXg6TvcZbnE"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F67627D.8050205@nuclearwinter.com>
Sender: linux-raid-owner@vger.kernel.org
To: Larkin Lowrey <llowrey@nuclearwinter.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/B9dzk9MA0Nl0mXg6TvcZbnE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 19 Mar 2012 11:44:45 -0500 Larkin Lowrey <llowrey@nuclearwinter.com>
wrote:

> The following command oopsed.
>=20
> mdadm -G --bitmap=3Dinternal /dev/md0
>=20
> The array is a two disk raid1 and hosts the root filesystem.
>=20
> Is it not possible/allowed to add a bitmap to an active/mounted array?

It is.  But it is busted.

Either use an older mdadm (3.2.2 or earlier), or apply this patch

http://neil.brown.name/git?p=3Dmd;a=3Dcommitdiff;h=3D4474ca42e2577563a919fd=
3ed782e2ec55bf11a2

which has been sent to Linus already and should appear in -stable kernels in
a couple of weeks.

NeilBrown



diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index cdf36b1..239af9a 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1904,6 +1904,8 @@ location_store(struct mddev *mddev, const char *buf, =
size_t len)
 			if (mddev->pers) {
 				mddev->pers->quiesce(mddev, 1);
 				rv =3D bitmap_create(mddev);
+				if (!rv)
+					rv =3D bitmap_load(mddev);
 				if (rv) {
 					bitmap_destroy(mddev);
 					mddev->bitmap_info.offset =3D 0;


> [  339.521575] scsi_verify_blk_ioctl: 662 callbacks suppressed
> [  339.531128] mdadm: sending ioctl 1261 to a partition!
> [  339.539999] mdadm: sending ioctl 1261 to a partition!
> [  339.549504] mdadm: sending ioctl 1261 to a partition!
> [  339.558273] mdadm: sending ioctl 1261 to a partition!
> [  339.570764] md0: bitmap file is out of date (0 < 47) -- forcing full
> recovery
> [  339.574628] mdadm: sending ioctl 800c0910 to a partition!
> [  339.574635] mdadm: sending ioctl 800c0910 to a partition!
> [  339.574646] mdadm: sending ioctl 1261 to a partition!
> [  339.574650] mdadm: sending ioctl 1261 to a partition!
> [  339.580825] mdadm: sending ioctl 800c0910 to a partition!
> [  339.580832] mdadm: sending ioctl 800c0910 to a partition!
> [  339.634433] created bitmap (1 pages) for device md0
> [  341.719752] BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000010
> [  341.720673] IP: [<ffffffff81473cc0>] bitmap_endwrite+0x130/0x250
> [  341.720673] PGD 0
> [  341.720673] Oops: 0000 [#1] SMP
> [  341.720673] CPU 1
> [  341.720673] Modules linked in: lockd it87 hwmon_vid ip6t_REJECT
> nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter nf_conntrack_ipv4
> nf_defrag_ipv4 xt_state ip6_tables nf_conntrack keyspan
> snd_hda_codec_hdmi snd_hda_intel snd_hda_codec snd_hwdep snd_seq
> snd_seq_device microcode edac_core sp5100_tco snd_pcm edac_mce_amd
> i2c_piix4 r8169 k10temp mii serio_raw snd_timer snd soundcore
> snd_page_alloc shpchp uinput sunrpc raid456 async_raid6_recov async_pq
> raid6_pq async_xor xor async_memcpy async_tx pata_acpi ata_generic raid0
> raid1 firewire_ohci firewire_core crc_itu_t pata_atiixp mvsas libsas
> scsi_transport_sas wmi radeon ttm drm_kms_helper drm i2c_algo_bit
> i2c_core [last unloaded: scsi_wait_scan]
> [  341.720673]
> [  341.720673] Pid: 0, comm: swapper/1 Not tainted 3.2.9-1.fc16.x86_64
> #1 Gigabyte Technology Co., Ltd. GA-MA790GPT-UD3H/GA-MA790GPT-UD3H
> [  341.720673] RIP: 0010:[<ffffffff81473cc0>]  [<ffffffff81473cc0>]
> bitmap_endwrite+0x130/0x250
> [  341.867091] RSP: 0018:ffff880227c43b90  EFLAGS: 00010046
> [  341.867091] RAX: 0000000000000000 RBX: ffff8802110edd00 RCX:
> 0000000000000000
> [  341.867091] RDX: 00000000000000a4 RSI: 00000000000008a4 RDI:
> 0000000000000000
> [  341.867091] RBP: ffff880227c43bf0 R08: 0000000000000000 R09:
> 000000000000000b
> [  341.867091] R10: 0000000000000000 R11: 0000000000000001 R12:
> 0000000001485d40
> [  341.867091] R13: ffff8802110edd3c R14: 0000000000000202 R15:
> 0000000000000008
> [  341.867091] FS:  00007fa3e76bd7c0(0000) GS:ffff880227c40000(0000)
> knlGS:0000000000000000
>=20
> This is all I got over the serial console.
>=20
> --Larkin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/B9dzk9MA0Nl0mXg6TvcZbnE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT2el2jnsnt1WYoG5AQKSdw//cyiE0RHF8s+4U3d47I/iTXK91dUYPtHK
s08VTkAMNmEItgOO16qqYPXO7v1nbUj4cg7qmBGcby4yVlMKlT/jqbn5R19mKYrS
2ponlPR3x6XfPN7rhxpqgj8AMKXD+URyOkh+4HX5Yb0yZPp02Vg1qeEq74zUNeGy
ZymFoCgd+SDhS7czqj4s8ndDBJ2jjEJ93JXWZjN7y8k+oKbsMYP6N29elfxSnOK1
ZbNekOIZnCWb/5VTf+6MX20iFDrOtoCiidmqeYeSyuVj+FNf7V6IxnxUZAhqDqgW
ex0Tf5StCZAZnRH0OSsMAq74Hz0/B9+3PDLKd4eatRCwjBOwW1IAKEYzSw10sE6/
m7EGOHFCexF3SvemumnydC8XpToA6oqnLz/3YI8io1nC0LrZ0AZbJ5DizkZweKkP
GAdrTUedv5m8m89I7oQnSAlx5/Mh7hb5VYb4qr4M51EAqT9wF9kGe1OId9wgWw/c
tq6LCrefI/qq6vQNum4pAfUxMkheot2rJHC674zJepGXpKYiYHoYQKOuR9Yn/2E6
Lk6jAAsAN3YrHzWYcqN4i+kMsEypa3Xk1npLN4TeDYET+LpQYxbTgBfolHXgEcdI
l9KT/BI3JOmuhaQwr+OzowcSLiFkM9Jhg1N+g8dPGyB32pwDkGttJVzYfxLm6MTx
rygxuNRTcII=
=Ekr7
-----END PGP SIGNATURE-----

--Sig_/B9dzk9MA0Nl0mXg6TvcZbnE--
