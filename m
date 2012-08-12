From: NeilBrown <neilb@suse.de>
Subject: Re: Device Unusable At Startup
Date: Mon, 13 Aug 2012 08:39:02 +1000
Message-ID: <20120813083902.53eaa0f8@notabene.brown>
References: <CACO8vio9vg_E9bwV6E0KdK43jg26_VBg0KC-YO5S4TSr7DoJuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=C9ie7Rcu61tq98.ro+sZKK"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACO8vio9vg_E9bwV6E0KdK43jg26_VBg0KC-YO5S4TSr7DoJuA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jake Thomas <thomasj10@georgefox.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/=C9ie7Rcu61tq98.ro+sZKK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 12 Aug 2012 15:17:09 -0700 Jake Thomas <thomasj10@georgefox.edu>
wrote:

> CC to linux-raid mailing list:
>=20
> Hi Neil!
>=20
>    Sorry for the delayed response. I kept checking on my iPhone for a
> response, and for some reason or lack thereof didn't see it. I figured
> that I'd have to wait a few days for my post to go through. I started
> checking over here everyday and never got a response:
> http://marc.info/?l=3Dlinux-raid&m=3D134415164808677&w=3D2 . I guess I
> neglected this blog. And I was out camping for a few days.
>=20
>    When I do "sudo /sbin/mdadm.moved -D /dev/md127" after startup
> (before it's working), it says:
>=20
> mdadm: md device /dev/md127 does not appear to be active.
>=20
> (I now moved /sbin/mdadm.moved back to /sbin/mdadm for ease of use.)
>=20
> When I do "sudo mdadm --misc --query /dev/md127", I get:
>=20
> /dev/md127: is an md device which is not active
>=20
>=20
> I found out that I can do:
>=20
> "sudo mdadm -R /dev/md127" and that starts it up just fine and
> everything is good again. (Don't have to stop it or anything.)
>=20
> I can then do:
> sudo mdadm /dev/md127 -a /dev/ram0.
>=20
> However, the problem still remains that it is not started on start-up,
> thus I cannot have /usr be such a raid device, which needs to be
> mounted very early in startup, before any scripts get ran. Therefore I
> can't just put "mdadm -R /dev/md127" in a script somewhere to fix the
> issue. I even tried the raid=3Dautodetect option at the kernel
> parameters line (And yes, "mdadm_udev" was in the HOOKS line in
> mkinitcpio.conf and "md_mod" and "raid0" were in the MODULES line in
> mkinitcpio.conf when I built the initial ramdisk with mkinitcpio.)
> I also tried doing "md=3D1,/dev/sda2" at the kernel line, which was
> ignored, because /dev/md1 was not created. Instead, I got the regular
> /dev/md127 (which is not active). Also tried "md=3D1,/dev/sda2,missing".
> Same result. Also tried "md=3D1,/dev/sda2,/dev/ram0". Same result. Also
> tried "md=3D1,/dev/ram0,/dev/sda2". Same result. Also tried
> "md=3D1,missing,/dev/sda2". Same result.
> I also tried  md-mod.start_dirty_degraded=3D1. Still wasn't active on sta=
rtup.
>=20
> After running the above two commands (before the kernel parameters
> paragraph) to get the raid device going, "sudo mdadm -D /dev/md127"
> gives:
> /dev/md127:
>         Version : 1.2
>   Creation Time : Wed Aug  1 19:33:20 2012
>      Raid Level : raid1
>      Array Size : 3144692 (3.00 GiB 3.22 GB)
>   Used Dev Size : 3144692 (3.00 GiB 3.22 GB)
>    Raid Devices : 2
>   Total Devices : 2
>     Persistence : Superblock is persistent
>=20
>     Update Time : Sun Aug 12 13:39:56 2012
>           State : clean, degraded, recovering
>  Active Devices : 1
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 1
>=20
>  Rebuild Status : 9% complete
>=20
>            Name : archbang:0
>            UUID : 31f0bda6:4cd69924:46a0e3b2:4f7e32ba
>          Events : 166
>=20
>     Number   Major   Minor   RaidDevice State
>        2       1        0        0      spare rebuilding   /dev/ram0
>        1       8        2        1      active sync writemostly   /dev/sd=
a2
>=20
>=20
> Also, when I first startup, if I do:
> sudo mdadm --manage /dev/md127 --remove /dev/sda2
>=20
> I get:
> mdadm: cannot get array info for /dev/md127
>=20
> And if I do:
> sudo mdadm --manage /dev/md* --remove /dev/sda2
>=20
> I get:
> mdadm: Must give one of -a/-r/-f for subsequent devices at /dev/md127
>=20
> What's going on with the above two command outputs?
>=20
>=20
> I will put a copy of this reply here:
> http://marc.info/?l=3Dlinux-raid&m=3D134415164808677&w=3D2
>=20
> For those of you looking at the linux-raid mailing list, I am coming
> from here: http://neil.brown.name/blog/20120615073245 .
>=20
> The idea of RAID1ing with a ramdisk came from
> here:https://bbs.archlinux.org/viewtopic.php?pid=3D493773#p493773 .




If you ask a question on the blog, you get a reply on the blog. If you ask =
a question on linux-raid you get a reply on linux-raid.... If you ask on bo=
th.... :-)=20

The array isn't starting at boot time because it is degraded. This suggests=
 a problem
with the boot scripts. I suspect your distro ('arch'?) is relying on "mdadm=
 -I"
being run from udev to start the arrays. This by itself isn't always enough=
. After
all devices have been discovered you need "mdadm -Irs" or "mdadm --incremen=
tal --run --scan"
to assemble any newly-degraded arrays.

So in some script before it tries to mount filesystems you want something l=
ike:

   udevadm settle mdadm --incremental --run --scan

This will have to go in a script in the initrd of course.


NeilBrown

--Sig_/=C9ie7Rcu61tq98.ro+sZKK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUCgwhjnsnt1WYoG5AQIaUQ/+M6vztLrUCwkL26rr+07U+HmcJP3l7Mcc
fKdVY0+ocT8wc/LbLOv2phN70YfN/kYqpl0VI2mPCg3jBnuAEKuUpq3ngQgYCH15
Uc8IAUHX8Zjx2M7dkXiyxj46SA5ETxV/t2S/0W8E3pX4rpHrCXoWSzQYxoUzlz9N
7JERUMDgnGhue8KV5WTrnXrNKYshFmvwo487c9mi2Le1sY7DDCcBD5D7mTT22JFU
SnF7AlDNKo5kXgmdUNuYPPKs1TuQ9eq25m0Dl2wUzJJYR4/me+frJzTlTlpMr2Cn
XIRgpgdbAGoVWmPRrqz6zrKhPR1wBV+BZbfW7PyTGANqwTTJIvEfuR1dJdz4piQr
ffo457f7yQqvtdeMSFFzbI4YTA0QEOaONlANGueKZb05EhjjA39Cc2JpZNTV1mQR
loRLBo9HDsPDAzDVbhtffesMgLU1yRKRPWIUITEm9+0wslIrchQv1CfCSgM71t5G
9BoTZmYV1W/bUs6nKmpFgFQwCkItr0SumbzABgcz4RTZYxujAn32WX0PvWuwlnJc
0wvjyWqDTj1MD+iVtkXlrG9KnrvjH3gGrcTjWOXdEutoUavoqSp7JhIu9XOWg/9F
wpa8GL3dRSJ8ObDjnL4qlcYhKr7nbGJRTO7b19oEFoRXrEmvVlYDb0SN5Phn3vO2
S7HLIuGNyZ4=
=Yx2R
-----END PGP SIGNATURE-----

--Sig_/=C9ie7Rcu61tq98.ro+sZKK--
