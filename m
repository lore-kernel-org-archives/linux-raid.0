From: NeilBrown <neilb@suse.de>
Subject: Re: Persistent failures with simple md setup
Date: Mon, 4 Mar 2013 10:33:57 +1100
Message-ID: <20130304103357.45b2cad2@notabene.brown>
References: <1565063.1kpR7lz4Ph@xrated>
	<20130301082520.19be933a@notabene.brown>
	<1659994.UpSJlIr5Mb@xrated>
	<4291349.FrQcKOnicQ@xrated>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/hNYhSZlz5_FhNx+Qpfxi_zB"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4291349.FrQcKOnicQ@xrated>
Sender: linux-raid-owner@vger.kernel.org
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/hNYhSZlz5_FhNx+Qpfxi_zB
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Sun, 03 Mar 2013 20:31:57 +0100 Hans-Peter Jansen <hpj@urpla.net> wrote:

> Am Donnerstag, 28. Februar 2013, 23:16:01 schrieb Hans-Peter Jansen:
> > Am Freitag, 1. M=E4rz 2013, 08:25:20 schrieb NeilBrown:
> > > On Thu, 28 Feb 2013 11:49:53 +0100 Hans-Peter Jansen <hpj@urpla.net>
> > > wrote:
> > >=20
> > > This is what I asked for:
> > > > > It really feels like a udev bug, but it is hard to be sure.
> > > > > Could you edit /etc/init.d/boot.md and add
> > > > >=20
> > > > >    echo BEFORE mdadm -IRs > /dev/kmsg
> > > > >=20
> > > > > just before the call the "$mdadm_BIN -IRs",
> > > > >=20
> > > > >    echo AFTER mdadm -IRs > /dev/kmsg
> > > > >=20
> > > > > just after that call, and
> > > > >=20
> > > > >    echo AFTER mdadm -Asc > /dev/mksg
> > > > >=20
> > > > > just after the call to "$mdadm_BIN -A -s -c $mdadm_CONFIG"
> > > > >=20
> > > > > And maybe put similar messages just before and after the
> > > > >=20
> > > > >     /sbin/udevadm settle ....
> > > > >=20
> > > > > call.
> > > > >=20
> > > > > If you can then reproduce the problem, the extra logging might te=
ll us
> > > > > something useful.
> > >=20
> > > This is not at all the same thing:
> > > > I've enabled initrd (linuxrc=3Dtrace) and boot.md (#!/bin/sh -x)
> > > > debugging,
> > > > hence we should see the full story next time.
> > >=20
> > > It might help, but I'm far from certain that it will be nearly as use=
ful.
>=20
> I see, sh debug messages do not condense in /var/log/something, they're r=
outed
> somewhere else. I not sure, how I like that systemd implied sillyness.
>=20
> > Okay, okay, I do it both ways now..
> >=20
> > Let's see, when it triggers.
>=20
> I'm not sure, how the basic kernel boot contribute to boiling this issue =
down,=20
> but here we go: (not censored this time, hope it will go though..)



Thanks.  The interesting bit is here:

> Mar  3 09:11:59 zaphkiel kernel: [   28.781703] md: bind<sdb4>
It seems that udev is running "mdadm -I" on sdb4 here

> Mar  3 09:11:59 zaphkiel kernel: [   28.799939] tveeprom 1-0050: audio pr=
ocessor is MSP3415 (idx 6)
> Mar  3 09:11:59 zaphkiel kernel: [   28.862699] sr 7:0:0:0: Attached scsi=
 generic sg6 type 5
> Mar  3 09:11:59 zaphkiel kernel: [   28.894667] tveeprom 1-0050: has radio
> Mar  3 09:11:59 zaphkiel kernel: [   28.917194] bttv0: Hauppauge eeprom i=
ndicates model#44354
> Mar  3 09:11:59 zaphkiel kernel: [   28.984037] bttv0: tuner type=3D20
> Mar  3 09:11:59 zaphkiel kernel: [   29.003670] md: bind<sdb1>

and "mdadm -I sdb1"  here
> Mar  3 09:11:59 zaphkiel kernel: [   29.026123] input: HDA Digital PCBeep=
 as /devices/pci0000:00/0000:00:07.0/input/input5
> Mar  3 09:11:59 zaphkiel kernel: [   29.098905] i2c-core: driver [msp3400=
] using legacy suspend method
> Mar  3 09:11:59 zaphkiel kernel: [   29.139227] AFTER udevadm settle --ti=
meout=3D60

and now udev is "settled".  This is much less than 60 seconds after the
"BEFORE udevadm settle", so it didn't time out - it must have exhausted the
queue.

> Mar  3 09:11:59 zaphkiel kernel: [   29.211092] i2c-core: driver [msp3400=
] using legacy resume method
> Mar  3 09:11:59 zaphkiel kernel: [   29.276147] msp3400 1-0040: MSP3415D-=
B3 found @ 0x80 (bt878 #0 [sw])
> Mar  3 09:11:59 zaphkiel kernel: [   29.325203] md: bind<sdb2>

But look - it seems that "mdadm -I /dev/sdb2" was just run - presumably by
udev.

> Mar  3 09:11:59 zaphkiel kernel: [   29.391360] msp3400 1-0040: msp3400 s=
upports nicam, BEFORE mdadm -IRs

We managed to get two lines blended together here, but it is clear that this
is just before "mdadm -IRs" runs.

> Mar  3 09:11:59 zaphkiel kernel: [   29.455183] mode is autodetect
> Mar  3 09:11:59 zaphkiel kernel: [   29.525553] md/raid1:md0: active with=
 1 out of 2 mirrors
>=20

And unsurprisingly, md0 is assembled with only on mirror because we have se=
en
sdb1 but not sda1

> Mar  3 09:11:59 zaphkiel kernel: [   29.572395] i2c-core: driver [tuner] =
using legacy suspend method
> Mar  3 09:11:59 zaphkiel kernel: [   29.642012] i2c-core: driver [tuner] =
using legacy resume method
> Mar  3 09:11:59 zaphkiel kernel: [   29.688786] md: bind<sda4>

and here comes sda4.  Presumably sda1 is attempted a little later, but as m=
d0
is already assembled, mdadm refuses to do anything with it.

So "mdadm -IRs" is being run too early, apparently because "udevadm settle"=
 is
exiting too early.  However I have looked closely at the udev code, and run
various tests, and cannot see how it could possibly exit early.  I can
imagine it exiting a bit late in some anomalous situations, but not early.

The only way I can explain this is to suggest that something other than udev
is running "mdadm -I".  But I cannot imagine what would be doing that.

If you put a "sleep 10" before the "mdadm -IRs", I suspect your problems
would go away.  It isn't really a nice solution, but it is the only one I c=
an
think of at the moment.

NeilBrown

--Sig_/hNYhSZlz5_FhNx+Qpfxi_zB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUTPd5Tnsnt1WYoG5AQITxxAAwLZVrNWkFaVSJ3DofOu7UnhDEG58nHog
nGiIdi62ETjw210L4iaoLG7o02bulxT8jX8BN4/EcS9mDAmqYxwzxYPk/6fyCFAd
jh2DTrRuOvaTiRTaCDvLYPdPFtMHcAAkBnbEGa5a602OXM6BEVQAPLzL2aeOUnVo
ItTOc9DHvvdOMWlZqoEcxvUbm4LmC1P+2JKu8Kghty9sHGlDD5e2sp8QtJpA4qt3
ghxfgrTMAPGGPcu22bBcBoBbL8tj9prOkxDGUl0I4TagVDianALpXoAvn9M3Uw2j
e9hYVph2x4KupE9fwXB6xE5j3/lGyWUwlhDnRmuKr0QLiR2sUmw4E58iM2ZWVBm8
02yiaoXqcuE5dqKnT36BTJlRGkMMDico6IB4cOjeaZZMnFtJhP4/UsMMLLCUH9aH
PYHKgYQtb9tKJ56c0JJ/j5TjbbGCwhML4Pj6gEa1enKQxubaxek3R8Fy0KZoaazV
ipJ4LC9htPKc//Q/lMADoNmsYOa2tJXa2RbAisyG1sCmVOrZi6Ogh0wNc0O7wnxJ
nGyDMvZejmBbuw6ME0entyN1WdPLM3ZwVPRdXNsfQHcd/11UTKzf3erksWIhvnYV
X4uJ8mQosmaZnmDKZskB/kkGicWb9fdIuAyMqj4T2j/EjyRSEIR3EbesZWxg2ndy
MwPSDXBgLOI=
=ygLv
-----END PGP SIGNATURE-----

--Sig_/hNYhSZlz5_FhNx+Qpfxi_zB--
