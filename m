From: NeilBrown <nfbrown@novell.com>
Subject: Re: mdadm Oops on a small ARM system
Date: Fri, 15 Jan 2016 08:35:35 +1100
Message-ID: <87wprb6dzs.fsf@notabene.neil.brown.name>
References: <20160114125216.1286288f@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160114125216.1286288f@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 14 2016, Roman Mamedov wrote:

> Hello,
>
> I am trying to run mdadm on an ARM system with 64 MB of RAM.
>
> mdadm --assemble --scan results in the following error.
> mdadm --detail /dev/md4 locks up indefinitely.
>
> It is a 2-member degraded RAID1 of 1.5 TB disks, previously created on am=
d64 PC.
>
> I remember mdadm working on this configuration before, maybe not with thi=
s array.
> In fact the stock OS of the device uses mdadm to provide RAID functionali=
ty too.
>
> Currently I am using Debian Wheezy with kernel 3.2.68 and mdadm 3.2.5.
>
> Any ideas?

It is the kernel crashing, not the "mdadm" program itself.

It looks like some weird data corruption.
The sync_page_io function allocates a bio, uses it to submit and wait
for a read to read the superblock off a device.  Then when it all
bio_put() to free the bio, the bio turns out to be partly corrupted.

All I can suggest is to try a different/newer kernel.

NeilBrown


>
> [Thu Jan 14 12:37:38 2016] md: md4 stopped.
> [Thu Jan 14 12:37:38 2016] md: bind<sda3>
> [Thu Jan 14 12:37:38 2016] md: raid1 personality registered for level 1
> [Thu Jan 14 12:37:38 2016] bio: create slab <bio-1> at 1
> [Thu Jan 14 12:37:38 2016] md/raid1:md4: active with 1 out of 2 mirrors
> [Thu Jan 14 12:37:38 2016] Unable to handle kernel paging request at virt=
ual address 01314289
> [Thu Jan 14 12:37:38 2016] pgd =3D c2ea8000
> [Thu Jan 14 12:37:38 2016] [01314289] *pgd=3D00000000
> [Thu Jan 14 12:37:38 2016] Internal error: Oops: 1 [#1]
> [Thu Jan 14 12:37:38 2016] Modules linked in: raid1 md_mod fuse tcp_illin=
ois ipv6 evdev mv643xx_eth inet_lro lm75 g760a gpio_keys usb_storage ext4 c=
rc16 mbcache jbd2 sg sd_mod crc_t10dif sata_mv libata ehci_hcd usbcore scsi=
_mod usb_common
> [Thu Jan 14 12:37:38 2016] CPU: 0    Not tainted  (3.2.0-4-orion5x #1 Deb=
ian 3.2.68-1+deb7u6)
> [Thu Jan 14 12:37:38 2016] PC is at mddev_bio_destructor+0x4/0xc [md_mod]
> [Thu Jan 14 12:37:38 2016] LR is at bio_put+0x44/0x48
> [Thu Jan 14 12:37:38 2016] pc : [<bf23993c>]    lr : [<c00f0c68>]    psr:=
 60000013
> [Thu Jan 14 12:37:38 2016] sp : c38dfd10  ip : c38e2044  fp : 00000000
> [Thu Jan 14 12:37:38 2016] r10: 00000200  r9 : 00000000  r8 : 00000008
> [Thu Jan 14 12:37:38 2016] r7 : 00000001  r6 : 00000010  r5 : f0000009  r=
4 : c2f7c724
> [Thu Jan 14 12:37:38 2016] r3 : 01314011  r2 : 00000000  r1 : 20000013  r=
0 : c2f7c724
> [Thu Jan 14 12:37:38 2016] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  IS=
A ARM  Segment user
> [Thu Jan 14 12:37:38 2016] Control: a005317f  Table: 02ea8000  DAC: 00000=
015
> [Thu Jan 14 12:37:38 2016] Process mdadm (pid: 1777, stack limit =3D 0xc3=
8de270)
> [Thu Jan 14 12:37:38 2016] Stack: (0xc38dfd10 to 0xc38e0000)
> [Thu Jan 14 12:37:38 2016] fd00:                                     2000=
0013 bf239a50 60000013 00000000
> [Thu Jan 14 12:37:38 2016] fd20: c38dfd20 c38dfd20 00000000 c04c1cc0 c326=
baa0 c39db810 00000001 00000000
> [Thu Jan 14 12:37:38 2016] fd40: 00000001 bf24232c 00000200 c04c1cc0 0000=
0000 00000001 00000008 00000000
> [Thu Jan 14 12:37:38 2016] fd60: bf248298 00000000 00000000 c321e7a0 c2d6=
a0e0 c39db800 bf23fd90 ad7175da
> [Thu Jan 14 12:37:38 2016] fd80: 00000008 bf245150 00000000 00000000 0000=
0100 c39db898 becfe538 c0290f84
> [Thu Jan 14 12:37:38 2016] fda0: bf25c2fc c38dfdb4 ad7175da 00000000 c321=
ee20 c39db800 00000000 c39db810
> [Thu Jan 14 12:37:38 2016] fdc0: 00000000 bf25c514 bf23fd90 c39db898 becf=
e538 bf240060 00000000 c38dfdfc
> [Thu Jan 14 12:37:38 2016] fde0: c3402c80 c39db810 c2f5e320 c00f35d0 c39d=
b800 c39db800 c39db810 c326baa0
> [Thu Jan 14 12:37:38 2016] fe00: c3496ac0 bf2458b0 0000000f 00000000 0000=
0000 00000000 00000000 00000000
> [Thu Jan 14 12:37:38 2016] fe20: 00000000 00000000 00000000 c39db800 c39d=
b800 00000000 c3496ac0 400c0930
> [Thu Jan 14 12:37:38 2016] fe40: c38de000 00000000 becfe538 bf2402c4 400c=
0930 c39db800 00000000 bf241878
> [Thu Jan 14 12:37:38 2016] fe60: 00000002 00000008 00000003 00000000 0000=
0006 c00f9330 c2e79a40 c3869508
> [Thu Jan 14 12:37:38 2016] fe80: c397b428 c397b428 c2cd0f00 c2e79a40 c397=
b428 c2cd0f00 c3869508 00000000
> [Thu Jan 14 12:37:38 2016] fea0: c397b428 c00fab20 00000000 c3496ac0 c2fb=
f400 400c0930 0000009f c38de000
> [Thu Jan 14 12:37:38 2016] fec0: 00000000 c015ebc0 00000000 c015f514 0000=
00d0 c38dff78 bf0b8a70 c2e27800
> [Thu Jan 14 12:37:38 2016] fee0: c2e27800 c3496ac0 c3402c90 bf000fbc 0000=
0007 bf0c94c8 c2d1de00 00000000
> [Thu Jan 14 12:37:38 2016] ff00: c3267e38 00000004 00000004 00000000 c38d=
e000 00000000 becfe538 c00d609c
> [Thu Jan 14 12:37:38 2016] ff20: c3402740 00000000 0000009f c2e7ac00 c340=
2750 bf0c96f8 c3402c80 c00f2e88
> [Thu Jan 14 12:37:38 2016] ff40: c2f5e320 c2e8fe58 c2f5e320 c2e8fe58 2000=
0013 c2f5e320 c2e8fe58 c00c8bc4
> [Thu Jan 14 12:37:38 2016] ff60: 00000000 c32da1c0 00000000 400c0930 0000=
0004 00000000 c38de000 00000000
> [Thu Jan 14 12:37:38 2016] ff80: becfe538 c00d616c 00000004 00000000 016d=
1908 00000001 00000000 00000036
> [Thu Jan 14 12:37:38 2016] ffa0: c0012388 c00121e0 016d1908 00000001 0000=
0004 400c0930 00000000 00000000
> [Thu Jan 14 12:37:38 2016] ffc0: 016d1908 00000001 00000000 00000036 0000=
0001 0000000a 016d27c0 becfe538
> [Thu Jan 14 12:37:38 2016] ffe0: 00000004 becfe0c8 0001cd44 b6f157ac 6000=
0010 00000004 00000000 00000000
> [Thu Jan 14 12:37:38 2016] [<bf23993c>] (mddev_bio_destructor+0x4/0xc [md=
_mod]) from [<c00f0c68>] (bio_put+0x44/0x48)
> [Thu Jan 14 12:37:38 2016] [<c00f0c68>] (bio_put+0x44/0x48) from [<bf239a=
50>] (sync_page_io+0xc0/0xd4 [md_mod])
> [Thu Jan 14 12:37:38 2016] [<bf239a50>] (sync_page_io+0xc0/0xd4 [md_mod])=
 from [<bf24232c>] (read_sb_page+0xd0/0x17c [md_mod])
> [Thu Jan 14 12:37:38 2016] [<bf24232c>] (read_sb_page+0xd0/0x17c [md_mod]=
) from [<bf245150>] (bitmap_create+0x31c/0x6d4 [md_mod])
> [Thu Jan 14 12:37:38 2016] [<bf245150>] (bitmap_create+0x31c/0x6d4 [md_mo=
d]) from [<bf240060>] (md_run+0x658/0x8b0 [md_mod])
> [Thu Jan 14 12:37:38 2016] [<bf240060>] (md_run+0x658/0x8b0 [md_mod]) fro=
m [<bf2402c4>] (do_md_run+0xc/0x74 [md_mod])
> [Thu Jan 14 12:37:38 2016] [<bf2402c4>] (do_md_run+0xc/0x74 [md_mod]) fro=
m [<bf241878>] (md_ioctl+0xd94/0x104c [md_mod])
> [Thu Jan 14 12:37:38 2016] [<bf241878>] (md_ioctl+0xd94/0x104c [md_mod]) =
from [<c015ebc0>] (__blkdev_driver_ioctl+0x1c/0x28)
> [Thu Jan 14 12:37:38 2016] [<c015ebc0>] (__blkdev_driver_ioctl+0x1c/0x28)=
 from [<c015f514>] (blkdev_ioctl+0x6ac/0x720)
> [Thu Jan 14 12:37:38 2016] [<c015f514>] (blkdev_ioctl+0x6ac/0x720) from [=
<c00d609c>] (do_vfs_ioctl+0x504/0x588)
> [Thu Jan 14 12:37:38 2016] [<c00d609c>] (do_vfs_ioctl+0x504/0x588) from [=
<c00d616c>] (sys_ioctl+0x4c/0x6c)
> [Thu Jan 14 12:37:38 2016] [<c00d616c>] (sys_ioctl+0x4c/0x6c) from [<c001=
21e0>] (ret_fast_syscall+0x0/0x2c)
> [Thu Jan 14 12:37:38 2016] Code: e1a00004 e8bd80f8 bf239938 e5103004 (e59=
31278)=20
> [Thu Jan 14 12:37:38 2016] ---[ end trace f3c05bbfe27f5503 ]---
>
> --=20
> With respect,
> Roman

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWmBSnAAoJEDnsnt1WYoG5f50QAJfFKMinspJ/43rHAWxirVBq
Oq5usW42GR2+6AKvXUN+3vhgSnZLC2GeXzTPmQDeHrZDmJeFx00BApyEyHSeNe6c
cRvqZDi9IE0R3lQ5N+GEqQzz4+TRowYJHJhIedNPkQSb9gvG/EkpYFVLWK3dUzAc
7t3aQk3q0N7zH0S2BmF+rbiLRR+FwRfQSaUyA+/sy9+UqJeSOBfolD3smBWfomqL
pcjvbdhg72zZm8hcH910nk/eWt3x9OQ6MpMfaiG9VCmZR3vI9YPlW4kUFKgzMLel
ioce719aSXyshqHvFl7+AlfcDAPcUF2CM78aX7+QMsOfKRtynB3RA6ubm4mJ4zgE
iDMZ1CKWWaKRwUP2+BUiL/e7vmWF9G8AyriZUcRuJ9+pIOeq1MPopFNqa4fciNKi
2oPOKRjymf8ab/VZsew6d4b3bejbiqm2yACJNcGAWWbK3vJt041rcmFWLEitJ16S
QWkApofRJPByUnj8BEG931dykwQRS5UjmIKbW9QkiB8GG0nDyIZGTTFWoQacbbHf
aTs8v8fqZ5A4EFUyB7n9EaDRZplbfc34sFza5xcFx2iQepJcroQKB2Sz3m7oPCW/
1bE7dE0OW0xughlxoOwKaApDwJSrWxiiKpUBHNpPH9d7857sfJT5wHVhLBI1rMgi
SMJpBcKzAPT3Cg69OY0i
=zXjY
-----END PGP SIGNATURE-----
--=-=-=--
