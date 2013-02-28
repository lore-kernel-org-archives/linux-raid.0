From: NeilBrown <neilb@suse.de>
Subject: Re: Persistent failures with simple md setup
Date: Thu, 28 Feb 2013 14:40:13 +1100
Message-ID: <20130228144013.61dcfe6b@notabene.brown>
References: <1565063.1kpR7lz4Ph@xrated>
	<2286786.BnthJ2WIKW@xrated>
	<20130205144448.2f40b306@notabene.brown>
	<4993918.JF2cWAHTeM@xrated>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/dbdbPBi+8K84ZSsDlIdgRVt"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4993918.JF2cWAHTeM@xrated>
Sender: linux-raid-owner@vger.kernel.org
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/dbdbPBi+8K84ZSsDlIdgRVt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 27 Feb 2013 18:01:29 +0100 Hans-Peter Jansen <hpj@urpla.net> wrote:

> [I intentionally switched off line wrapping, since it renders the given i=
nformation
>  inedible]
>=20
> Hi Neil,
>=20
> sorry for the delay. Meanwhile, I updated to mdadm 3.2.6, and recreated t=
he initrd.
> Since I do the recreation on a regular base, no data salad appeared, but =
the initial
> issue persists. I trigger checking the related md on each manual interven=
tion.
>=20
> Hence approaching this again.=20
>=20
> That's a typical boot sequence:

BTW, you aren't the only one to hit this issue .... I think I'm starting to
get closer to the problem.


>=20
> Feb 27 08:35:48 zaphkiel kernel: [    0.000000] Kernel command line: PROF=
ILE=3Dibk root=3D/dev/disk/by-uuid/782b24f2-26f6-4ea9-ab8b-d377cd2ac97b con=
sole=3DttyS0,19200 console=3Dtty0 resume=3D/dev/md127 splash=3Dsilent  cons=
ole=3DttyS0,115200n8 vga=3D791
> Feb 27 08:35:48 zaphkiel kernel: [    6.816164] sd 0:0:0:0: [sda] 1953525=
168 512-byte logical blocks: (1.00 TB/931 GiB)
> Feb 27 08:35:48 zaphkiel kernel: [    6.862240] sd 1:0:0:0: [sdb] 1953525=
168 512-byte logical blocks: (1.00 TB/931 GiB)
> Feb 27 08:35:48 zaphkiel kernel: [    6.983157] sd 0:0:0:0: [sda] Write P=
rotect is off
> Feb 27 08:35:48 zaphkiel kernel: [    7.011914] sd 0:0:0:0: [sda] Mode Se=
nse: 00 3a 00 00
> Feb 27 08:35:48 zaphkiel kernel: [    7.011932] sd 0:0:0:0: [sda] Write c=
ache: enabled, read cache: enabled, doesn't support DPO or FUA
> Feb 27 08:35:48 zaphkiel kernel: [    7.159045] sd 1:0:0:0: [sdb] Write P=
rotect is off
> Feb 27 08:35:48 zaphkiel kernel: [    7.187766] sd 1:0:0:0: [sdb] Mode Se=
nse: 00 3a 00 00
> Feb 27 08:35:48 zaphkiel kernel: [    7.187783] sd 1:0:0:0: [sdb] Write c=
ache: enabled, read cache: enabled, doesn't support DPO or FUA
> Feb 27 08:35:48 zaphkiel kernel: [    7.319637]  sda: sda1 sda2 sda3 sda4
> Feb 27 08:35:48 zaphkiel kernel: [    7.386469] sd 0:0:0:0: [sda] Attache=
d SCSI disk
> Feb 27 08:35:48 zaphkiel kernel: [    7.414335]  sdb: sdb1 sdb2 sdb3 sdb4
> Feb 27 08:35:48 zaphkiel kernel: [    7.470597] sd 1:0:0:0: [sdb] Attache=
d SCSI disk
> Feb 27 08:35:48 zaphkiel kernel: [    9.676078] PM: Checking hibernation =
image partition /dev/md127
> Feb 27 08:35:48 zaphkiel kernel: [    9.956010] sd 6:0:0:0: [sdc] Attache=
d SCSI removable disk
> Feb 27 08:35:48 zaphkiel kernel: [   10.175875] sd 6:0:0:1: [sdd] Attache=
d SCSI removable disk
> Feb 27 08:35:48 zaphkiel kernel: [   10.262999] sd 6:0:0:2: [sde] Attache=
d SCSI removable disk
> Feb 27 08:35:48 zaphkiel kernel: [   10.299000] sd 6:0:0:3: [sdf] Attache=
d SCSI removable disk
> Feb 27 08:35:48 zaphkiel kernel: [   10.618022] md: raid1 personality reg=
istered for level 1
> Feb 27 08:35:48 zaphkiel kernel: [   11.139833] md: bind<sda3>
> Feb 27 08:35:48 zaphkiel kernel: [   11.158438] md: bind<sdb3>
> Feb 27 08:35:48 zaphkiel kernel: [   11.200897] md/raid1:md124: active wi=
th 2 out of 2 mirrors

Presumably this is md124 being assembled in the initrd as it contains the
root filesystem.


> Feb 27 08:35:48 zaphkiel kernel: [   11.233921] created bitmap (200 pages=
) for device md124
> Feb 27 08:35:48 zaphkiel kernel: [   11.276742] md124: bitmap initialized=
 from disk: read 13/13 pages, set 0 of 409595 bits
> Feb 27 08:35:48 zaphkiel kernel: [   11.356796] md124: detected capacity =
change from 0 to 107372728320
> Feb 27 08:35:48 zaphkiel kernel: [   11.395610]  md124: unknown partition=
 table
> Feb 27 08:35:48 zaphkiel kernel: [   11.543579] md: raid0 personality reg=
istered for level 0
> Feb 27 08:35:48 zaphkiel kernel: [   11.583994] md: raid10 personality re=
gistered for level 10
> Feb 27 08:35:48 zaphkiel kernel: [   12.188576] md: raid6 personality reg=
istered for level 6
> Feb 27 08:35:48 zaphkiel kernel: [   12.220473] md: raid5 personality reg=
istered for level 5
> Feb 27 08:35:48 zaphkiel kernel: [   12.252320] md: raid4 personality reg=
istered for level 4
> Feb 27 08:35:48 zaphkiel kernel: [   12.318865] XFS (md124): Mounting Fil=
esystem
> Feb 27 08:35:48 zaphkiel kernel: [   12.535666] XFS (md124): Ending clean=
 mount

And now XFS has mounted that, so presumably about there the boot sequence
switches from initrd to real-root.  You have obviously removed some lines,
presumably because you thought brevity would help.  For future reference: it
doesn't.  I much prefer to see complete logs so I can correlate various par=
ts
of the sequence and be sure I understand what I'm seeing.  But I probably
have enough here.

> Feb 27 08:35:48 zaphkiel kernel: [   22.720866] sd 0:0:0:0: Attached scsi=
 generic sg0 type 0
> Feb 27 08:35:48 zaphkiel kernel: [   23.126126] sd 1:0:0:0: Attached scsi=
 generic sg1 type 0
> Feb 27 08:35:48 zaphkiel kernel: [   23.203876] sd 6:0:0:0: Attached scsi=
 generic sg2 type 0
> Feb 27 08:35:48 zaphkiel kernel: [   23.402184] sd 6:0:0:1: Attached scsi=
 generic sg3 type 0
> Feb 27 08:35:48 zaphkiel kernel: [   23.725330] sd 6:0:0:2: Attached scsi=
 generic sg4 type 0
> Feb 27 08:35:48 zaphkiel kernel: [   23.917899] sd 6:0:0:3: Attached scsi=
 generic sg5 type 0
> Feb 27 08:35:48 zaphkiel kernel: [   24.492587] md: bind<sda2>
> Feb 27 08:35:48 zaphkiel kernel: [   24.711804] md: bind<sda1>
> Feb 27 08:35:48 zaphkiel kernel: [   24.821071] md: bind<sda4>

These are parts of 3 different arrays that are starting to be assembled in
parallel.  That must be udev running "mdadm -I /dev/sdaX" which will partly
assemble each array.  when the 'sdb' bits come along "mdadm -I /dev/sdbX"
should complete the assembly.


> Feb 27 08:35:48 zaphkiel kernel: [   25.607192] md: bind<sdb2>
> Feb 27 08:35:48 zaphkiel kernel: [   25.672335] md/raid1:md1: active with=
 2 out of 2 mirrors
> Feb 27 08:35:48 zaphkiel kernel: [   25.723678] created bitmap (8 pages) =
for device md1
> Feb 27 08:35:48 zaphkiel kernel: [   25.771764] md1: bitmap initialized f=
rom disk: read 1/1 pages, set 0 of 16379 bits

And there is the first one:  mdadm -I /dev/sdb2 must have been run by udev =
so
md1 got fully assembled.


> Feb 27 08:35:48 zaphkiel kernel: [   25.854963] md/raid1:md0: active with=
 1 out of 2 mirrors

But now md0 got assembled with waiting for sdb1.  This must have been the
   mdadm -IRs
in /etc/init.d/boot.md.  The purpose of this is to find any partially
assembled arrays and complete the assembly.  This is needed if, for example,
sdb has failed complete and would never be found.  However it shouldn't
happen yet.  It should wait until all the devices that have been discovered
have been processed.
A little early in the boot.md file you will see:
        if [ "$MDADM_DEVICE_TIMEOUT" -gt 0 ] ; then
            /sbin/udevadm settle --timeout=3D"$MDADM_DEVICE_TIMEOUT"
        fi

so unless you have MDADM_DEVICE_TIMEOUT=3D0 in /etc/sysconfig/mdadm (which I
very much doubt) it should have already waited.  But there is no sign that =
it
did.  So maybe "udevadm settle" is broken?


> Feb 27 08:35:48 zaphkiel kernel: [   25.886903] md1: detected capacity ch=
ange from 0 to 2146783232
> Feb 27 08:35:48 zaphkiel kernel: [   25.929142] created bitmap (6 pages) =
for device md0
> Feb 27 08:35:48 zaphkiel kernel: [   25.958684]  md1: unknown partition t=
able
> Feb 27 08:35:48 zaphkiel kernel: [   25.995737] md: bind<sdb4>
> Feb 27 08:35:48 zaphkiel kernel: [   26.012500] md0: bitmap initialized f=
rom disk: read 1/1 pages, set 0 of 12047 bits
> Feb 27 08:35:48 zaphkiel kernel: [   26.077270] md0: detected capacity ch=
ange from 0 to 98689024
> Feb 27 08:35:48 zaphkiel kernel: [   26.168097] md/raid1:md3: active with=
 2 out of 2 mirrors

And here comes sdb4, so "mdadm -I /dev/sdb4" must have been run by udev.  A=
nd
it got in before the  "mdadm -IRs" managed to find that md0 was incomplete,
and started it.


> Feb 27 08:35:48 zaphkiel kernel: [   26.205258]  md0: unknown partition t=
able
> Feb 27 08:35:48 zaphkiel kernel: [   26.242295] created bitmap (415 pages=
) for device md3
> Feb 27 08:35:48 zaphkiel kernel: [   26.304271] md3: bitmap initialized f=
rom disk: read 26/26 pages, set 1465 of 849320 bits
> Feb 27 08:35:48 zaphkiel kernel: [   26.392578] md3: detected capacity ch=
ange from 0 to 890575601664
> Feb 27 08:35:48 zaphkiel kernel: [   26.575527]  md3: unknown partition t=
able
> Feb 27 08:35:48 zaphkiel kernel: [   26.763091] Adding 2096464k swap on /=
dev/md1.  Priority:0 extents:1 across:2096464k=20
> Feb 27 08:35:48 zaphkiel kernel: [   29.268318] XFS (md3): Mounting Files=
ystem
> Feb 27 08:35:48 zaphkiel kernel: [   29.521844] EXT4-fs (md0): mounting e=
xt2 file system using the ext4 subsystem
> Feb 27 08:35:48 zaphkiel kernel: [   29.684176] EXT4-fs (md0): mounted fi=
lesystem without journal. Opts: acl,user_xattr
> Feb 27 08:35:48 zaphkiel kernel: [   30.356255] XFS (md3): Ending clean m=
ount
>=20
> Today, /dev/sdb1 of /dev/md0 vanished. Re-adding and checking doesn't rev=
ealed=20
> any error, but it would be cool to get to the bottom of this, as re-addin=
g some
> lost partitions to the md every second day *is* a real PITA.
>=20
> What could I do to help resolving this issue?=20

It really feels like a udev bug, but it is hard to be sure.
Could you edit /etc/init.d/boot.md and add
   echo BEFORE mdadm -IRs > /dev/kmsg
just before the call the "$mdadm_BIN -IRs",
   echo AFTER mdadm -IRs > /dev/kmsg
just after that call, and
   echo AFTER mdadm -Asc > /dev/mksg
just after the call to "$mdadm_BIN -A -s -c $mdadm_CONFIG"

And maybe put similar messages just before and after the =20
    /sbin/udevadm settle ....
call.

If you can then reproduce the problem, the extra logging might tell us
something useful.

NeilBrown

--Sig_/dbdbPBi+8K84ZSsDlIdgRVt
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUS7RnTnsnt1WYoG5AQK8rRAAouPPzBNnVRjyEqcFQAgf7HKPKxT9GoXE
5KTUgxqte0ntnj/G6hWcHLx3HBG45yzmy6IakZuIaflb14Fgmhbi2X0qoXY7a1o+
bRIZ5IHU3bcvO5ScM8sUkD12j5yiNo/gheGidmANG7FPlPeXJAxz/FiANP2rw4Lu
6ESvl+365/dx3vDhNpxS52wjfOOuFC9d0Jkl7zBLRoM9aO/LoA9jJTde2a8gwf8A
0XeplEP22F1T3L3YCwUN+E4KXZnphSJGaSTSrmwkdFBd0534mGP3H2sm1DjRIUI3
+yF108owzU7inUlSm87+QuGlnYqLKHH7ZiLiKrlVFIIcQhrCEYWX6fLX9ATDxX/w
+KVOuX/kU5ENwHvW9D1FoKaDB/gWg1SEpil5M0fA4o8zbcpWZJqdusXZADzimOp9
vEeZogOV4wyyCrkCcQp/sWAaNsROPKijs8C0vbr57t/GKgvaa0GlkEa/Zb1tAQVF
QFjcgssOU41ckPWQM7JaB2tO/hkeOyihxxYWGgBMDdnqsi7N/XHWh1RLL5DzZlgN
1t2+6lmJ3dCqPVqsTZZzb5zvOapGRcg901Md8q2CkYg6H4e31dMDQQm5FOmAsTG3
6MA6FcmYmGylAJYbLhJ+stJddHz3zhTH9gcdIKSfO3DLKXd6+25pNF8vln7P3waw
0esK7Qmq1gw=
=AML3
-----END PGP SIGNATURE-----

--Sig_/dbdbPBi+8K84ZSsDlIdgRVt--
