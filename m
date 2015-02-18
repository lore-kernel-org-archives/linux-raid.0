From: NeilBrown <neilb@suse.de>
Subject: Re: help with the little script (erc timout fix)
Date: Thu, 19 Feb 2015 08:25:34 +1100
Message-ID: <20150219082534.0830ee30@notabene.brown>
References: <loom.20150214T222329-324@post.gmane.org>
	<20150216142845.0d50207c@notabene.brown>
	<loom.20150216T124230-883@post.gmane.org>
	<54E1EDEA.1030503@turmel.org>
	<loom.20150216T165111-551@post.gmane.org>
	<54E226B5.1080500@turmel.org>
	<loom.20150216T183419-387@post.gmane.org>
	<20150217104906.62d36c62@notabene.brown>
	<loom.20150218T155053-576@post.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/OJvSO2iZexHhdokl3uzStqp"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20150218T155053-576@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Chris <email.bug@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/OJvSO2iZexHhdokl3uzStqp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 18 Feb 2015 15:04:53 +0000 (UTC) Chris <email.bug@arcor.de> wrote:

>=20
> Hello,
>=20
> by adapting what I could find, I compiled the following short snippet now.
>=20
> Could list members please look at this novice code and suggest a way to=20
> determine the containing disk device $HDD_DEV from the parition/disk,
> before I dare to test this.
>=20
>=20
>=20
> In udev-md-raid-assembly.rules, below LABEL=3D"md_inc" (section only hand=
ling
> all md suppported devices) add:
>=20
> # fix timouts for redundant raids, if possible
> IMPORT{program}=3D"BINDIR/mdadm --examine --export $tempnode"
> TEST=3D"/usr/sbin/smartctl", ENV{MD_LEVEL}=3D=3D"raid[1-9]*",
> RUN+=3D"BINDIR/mdadm-erc-timout-fix.sh $tempnode"

It might make sense to have 2 rules, one for partitions and one for disks
(based on ENV{DEVTYPE}).  Then use $parent to get the device from the
partition, and  $devnode to get the device of the disk.

>=20
> And in a new mdadm-erc-timout-fix.sh file implement:
>=20
>   #! /bin/sh
>=20
>   HDD_DEV=3D $1 somehow stipping off the tailing numbers?
>=20
>   if smartctl -l scterc ${HDD_DEV} | grep -q Disabled ; then
>     /usr/sbin/smartctl -l scterc,70,70 ${HDD_DEV}
>   else
>     if ! smartctl -l scterc ${HDD_DEV} | grep -q seconds ; then
>       echo 180 >/sys/block/${HDD_DEV}/device/timeout
>     fi
>   fi

You should be consistent and use /usr/sbin/smartctl everywhere, or explicit=
ly
set $PATH and just use smartctl  everywhere.

>=20
> Correct execution during boot would seem to require that distro
> package managers hook smartctl and the script into the initramfs
> generation.
>=20
> Regards,
> Chris

One problem with this approach is that it assumes circumstances don't chang=
e.
If you have a working RAID1, then limiting the timeout on both devices makes
sense.  If you have a degraded RAID1 with only one device left then you
really want the drive to try as hard as it can to get the data.

There is a "FAILFAST" mechanism in the kernel which allows the filesystem to
md etc to indicate that it wants accesses to "fail fast", which presumably
means to use a smaller timeout.
I would rather md used this flag where appropriate, and for the device to
respond to it by using suitable timeouts.

The problem is that FAILFAST isn't documented usefully and it is very hard =
to
figure out what exactly (if anything) it does.

But until that is resolved, a fix like this is probably a good idea.

NeilBrown

--Sig_/OJvSO2iZexHhdokl3uzStqp
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVOUDTjnsnt1WYoG5AQIFLRAAkMvoBbuZ29XJ537lh5IfrzivBq6eUpC5
EOduGxjny86jcALjl+k/iUnwNWzg+ISLyL1QLI54ps3VrjZELneXDuT6gCXzAgIN
xF2aiFqnw+qP8+Pg7xAjb8xzEfdCcPoIItynldeiJEygzamAKBp3+1FmIzNSu9GT
Mxzpfa6lwR+xmNKuYe5JlweeAtUDn/tfOSlwb6BBT8LqxXxTkGJjYcrDr53Cl2TC
m//VRJYH5aoLBdDwDtI68b4NuXsaESnKcQ+plxrgdlnVxWdhBtJMxGSVwjpQemi0
kYz9pMU2wWbu75hjBt66pZ9YdNxtagQSpNumAWOnjXIg/aohtjGPx58ahLt0Vaoo
qmy3RSG64/sOgBoAwMew6aa8Wzh22cXkrirn6TnG12ghUnLZY39edxsBeAQqasHY
M+TkdP6nTDR6XTqOP5pAuZ5K156CYYFcHsn4ooQbUm7NZTVaMMaZZU9++T7yiXIC
LvgpDwa1bwhlunlBuAacEZiPxV3SfNaZ4T+M/OIIzn1BqYFHpeUN4aqTEvCWF297
xv5Jp8XCY/ZB6mj8t7NegGhMF40ta63X/97kNa9uhenhqShycYaifaa8ruNUgBDE
14O3pyoXKtxuuZfhr0n0hQq7MuQcj/IEMak6DM75EWlyChs2pKtjrU0h+DE6gxEV
qMkZiTq6L10=
=HbH9
-----END PGP SIGNATURE-----

--Sig_/OJvSO2iZexHhdokl3uzStqp--
