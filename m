From: Roman Mamedov <rm@romanrm.net>
Subject: mdadm Oops on a small ARM system
Date: Thu, 14 Jan 2016 12:52:16 +0500
Message-ID: <20160114125216.1286288f@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/GNGkq.7WNKaJwaGh+_Y9Wzk"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/GNGkq.7WNKaJwaGh+_Y9Wzk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

I am trying to run mdadm on an ARM system with 64 MB of RAM.

mdadm --assemble --scan results in the following error.
mdadm --detail /dev/md4 locks up indefinitely.

It is a 2-member degraded RAID1 of 1.5 TB disks, previously created on amd6=
4 PC.

I remember mdadm working on this configuration before, maybe not with this =
array.
In fact the stock OS of the device uses mdadm to provide RAID functionality=
 too.

Currently I am using Debian Wheezy with kernel 3.2.68 and mdadm 3.2.5.

Any ideas?

[Thu Jan 14 12:37:38 2016] md: md4 stopped.
[Thu Jan 14 12:37:38 2016] md: bind<sda3>
[Thu Jan 14 12:37:38 2016] md: raid1 personality registered for level 1
[Thu Jan 14 12:37:38 2016] bio: create slab <bio-1> at 1
[Thu Jan 14 12:37:38 2016] md/raid1:md4: active with 1 out of 2 mirrors
[Thu Jan 14 12:37:38 2016] Unable to handle kernel paging request at virtua=
l address 01314289
[Thu Jan 14 12:37:38 2016] pgd =3D c2ea8000
[Thu Jan 14 12:37:38 2016] [01314289] *pgd=3D00000000
[Thu Jan 14 12:37:38 2016] Internal error: Oops: 1 [#1]
[Thu Jan 14 12:37:38 2016] Modules linked in: raid1 md_mod fuse tcp_illinoi=
s ipv6 evdev mv643xx_eth inet_lro lm75 g760a gpio_keys usb_storage ext4 crc=
16 mbcache jbd2 sg sd_mod crc_t10dif sata_mv libata ehci_hcd usbcore scsi_m=
od usb_common
[Thu Jan 14 12:37:38 2016] CPU: 0    Not tainted  (3.2.0-4-orion5x #1 Debia=
n 3.2.68-1+deb7u6)
[Thu Jan 14 12:37:38 2016] PC is at mddev_bio_destructor+0x4/0xc [md_mod]
[Thu Jan 14 12:37:38 2016] LR is at bio_put+0x44/0x48
[Thu Jan 14 12:37:38 2016] pc : [<bf23993c>]    lr : [<c00f0c68>]    psr: 6=
0000013
[Thu Jan 14 12:37:38 2016] sp : c38dfd10  ip : c38e2044  fp : 00000000
[Thu Jan 14 12:37:38 2016] r10: 00000200  r9 : 00000000  r8 : 00000008
[Thu Jan 14 12:37:38 2016] r7 : 00000001  r6 : 00000010  r5 : f0000009  r4 =
: c2f7c724
[Thu Jan 14 12:37:38 2016] r3 : 01314011  r2 : 00000000  r1 : 20000013  r0 =
: c2f7c724
[Thu Jan 14 12:37:38 2016] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA =
ARM  Segment user
[Thu Jan 14 12:37:38 2016] Control: a005317f  Table: 02ea8000  DAC: 00000015
[Thu Jan 14 12:37:38 2016] Process mdadm (pid: 1777, stack limit =3D 0xc38d=
e270)
[Thu Jan 14 12:37:38 2016] Stack: (0xc38dfd10 to 0xc38e0000)
[Thu Jan 14 12:37:38 2016] fd00:                                     200000=
13 bf239a50 60000013 00000000
[Thu Jan 14 12:37:38 2016] fd20: c38dfd20 c38dfd20 00000000 c04c1cc0 c326ba=
a0 c39db810 00000001 00000000
[Thu Jan 14 12:37:38 2016] fd40: 00000001 bf24232c 00000200 c04c1cc0 000000=
00 00000001 00000008 00000000
[Thu Jan 14 12:37:38 2016] fd60: bf248298 00000000 00000000 c321e7a0 c2d6a0=
e0 c39db800 bf23fd90 ad7175da
[Thu Jan 14 12:37:38 2016] fd80: 00000008 bf245150 00000000 00000000 000001=
00 c39db898 becfe538 c0290f84
[Thu Jan 14 12:37:38 2016] fda0: bf25c2fc c38dfdb4 ad7175da 00000000 c321ee=
20 c39db800 00000000 c39db810
[Thu Jan 14 12:37:38 2016] fdc0: 00000000 bf25c514 bf23fd90 c39db898 becfe5=
38 bf240060 00000000 c38dfdfc
[Thu Jan 14 12:37:38 2016] fde0: c3402c80 c39db810 c2f5e320 c00f35d0 c39db8=
00 c39db800 c39db810 c326baa0
[Thu Jan 14 12:37:38 2016] fe00: c3496ac0 bf2458b0 0000000f 00000000 000000=
00 00000000 00000000 00000000
[Thu Jan 14 12:37:38 2016] fe20: 00000000 00000000 00000000 c39db800 c39db8=
00 00000000 c3496ac0 400c0930
[Thu Jan 14 12:37:38 2016] fe40: c38de000 00000000 becfe538 bf2402c4 400c09=
30 c39db800 00000000 bf241878
[Thu Jan 14 12:37:38 2016] fe60: 00000002 00000008 00000003 00000000 000000=
06 c00f9330 c2e79a40 c3869508
[Thu Jan 14 12:37:38 2016] fe80: c397b428 c397b428 c2cd0f00 c2e79a40 c397b4=
28 c2cd0f00 c3869508 00000000
[Thu Jan 14 12:37:38 2016] fea0: c397b428 c00fab20 00000000 c3496ac0 c2fbf4=
00 400c0930 0000009f c38de000
[Thu Jan 14 12:37:38 2016] fec0: 00000000 c015ebc0 00000000 c015f514 000000=
d0 c38dff78 bf0b8a70 c2e27800
[Thu Jan 14 12:37:38 2016] fee0: c2e27800 c3496ac0 c3402c90 bf000fbc 000000=
07 bf0c94c8 c2d1de00 00000000
[Thu Jan 14 12:37:38 2016] ff00: c3267e38 00000004 00000004 00000000 c38de0=
00 00000000 becfe538 c00d609c
[Thu Jan 14 12:37:38 2016] ff20: c3402740 00000000 0000009f c2e7ac00 c34027=
50 bf0c96f8 c3402c80 c00f2e88
[Thu Jan 14 12:37:38 2016] ff40: c2f5e320 c2e8fe58 c2f5e320 c2e8fe58 200000=
13 c2f5e320 c2e8fe58 c00c8bc4
[Thu Jan 14 12:37:38 2016] ff60: 00000000 c32da1c0 00000000 400c0930 000000=
04 00000000 c38de000 00000000
[Thu Jan 14 12:37:38 2016] ff80: becfe538 c00d616c 00000004 00000000 016d19=
08 00000001 00000000 00000036
[Thu Jan 14 12:37:38 2016] ffa0: c0012388 c00121e0 016d1908 00000001 000000=
04 400c0930 00000000 00000000
[Thu Jan 14 12:37:38 2016] ffc0: 016d1908 00000001 00000000 00000036 000000=
01 0000000a 016d27c0 becfe538
[Thu Jan 14 12:37:38 2016] ffe0: 00000004 becfe0c8 0001cd44 b6f157ac 600000=
10 00000004 00000000 00000000
[Thu Jan 14 12:37:38 2016] [<bf23993c>] (mddev_bio_destructor+0x4/0xc [md_m=
od]) from [<c00f0c68>] (bio_put+0x44/0x48)
[Thu Jan 14 12:37:38 2016] [<c00f0c68>] (bio_put+0x44/0x48) from [<bf239a50=
>] (sync_page_io+0xc0/0xd4 [md_mod])
[Thu Jan 14 12:37:38 2016] [<bf239a50>] (sync_page_io+0xc0/0xd4 [md_mod]) f=
rom [<bf24232c>] (read_sb_page+0xd0/0x17c [md_mod])
[Thu Jan 14 12:37:38 2016] [<bf24232c>] (read_sb_page+0xd0/0x17c [md_mod]) =
from [<bf245150>] (bitmap_create+0x31c/0x6d4 [md_mod])
[Thu Jan 14 12:37:38 2016] [<bf245150>] (bitmap_create+0x31c/0x6d4 [md_mod]=
) from [<bf240060>] (md_run+0x658/0x8b0 [md_mod])
[Thu Jan 14 12:37:38 2016] [<bf240060>] (md_run+0x658/0x8b0 [md_mod]) from =
[<bf2402c4>] (do_md_run+0xc/0x74 [md_mod])
[Thu Jan 14 12:37:38 2016] [<bf2402c4>] (do_md_run+0xc/0x74 [md_mod]) from =
[<bf241878>] (md_ioctl+0xd94/0x104c [md_mod])
[Thu Jan 14 12:37:38 2016] [<bf241878>] (md_ioctl+0xd94/0x104c [md_mod]) fr=
om [<c015ebc0>] (__blkdev_driver_ioctl+0x1c/0x28)
[Thu Jan 14 12:37:38 2016] [<c015ebc0>] (__blkdev_driver_ioctl+0x1c/0x28) f=
rom [<c015f514>] (blkdev_ioctl+0x6ac/0x720)
[Thu Jan 14 12:37:38 2016] [<c015f514>] (blkdev_ioctl+0x6ac/0x720) from [<c=
00d609c>] (do_vfs_ioctl+0x504/0x588)
[Thu Jan 14 12:37:38 2016] [<c00d609c>] (do_vfs_ioctl+0x504/0x588) from [<c=
00d616c>] (sys_ioctl+0x4c/0x6c)
[Thu Jan 14 12:37:38 2016] [<c00d616c>] (sys_ioctl+0x4c/0x6c) from [<c00121=
e0>] (ret_fast_syscall+0x0/0x2c)
[Thu Jan 14 12:37:38 2016] Code: e1a00004 e8bd80f8 bf239938 e5103004 (e5931=
278)=20
[Thu Jan 14 12:37:38 2016] ---[ end trace f3c05bbfe27f5503 ]---

--=20
With respect,
Roman

--Sig_/GNGkq.7WNKaJwaGh+_Y9Wzk
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlaXU7EACgkQTLKSvz+PZwgNuQCdE/LFKL63tG+wMSnsmu/+onSY
sFEAn1ABhIkFgJkWVuCrJH2kbBZPe6/s
=wZBw
-----END PGP SIGNATURE-----

--Sig_/GNGkq.7WNKaJwaGh+_Y9Wzk--
