From: Roman Mamedov <roman@rm.pp.ru>
Subject: Re: RAID5 crashed for unknown reason on old 2.6.16 kernel
Date: Thu, 15 Jul 2010 19:09:24 +0600
Message-ID: <20100715190924.0f62890a@natsu>
References: <AANLkTimTAvYM7p4sk8S5He4WOWT3FW6IRPQ0AfpFnIVR@mail.gmail.com>
	<AANLkTik3OIS0AKHZaBHEuqi9NNFKYQ7sWh_iZecirJgS@mail.gmail.com>
	<20100629165031.6c96a635@notabene.brown>
	<AANLkTilC9tPAVS2UWcJDykDyvkCDZbZjFD-R-h6OxRxi@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/8SRzd8k+Z74Yrg8KRVvlxQj"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTilC9tPAVS2UWcJDykDyvkCDZbZjFD-R-h6OxRxi@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Markus Hennig <mhennig@gmail.com>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

--Sig_/8SRzd8k+Z74Yrg8KRVvlxQj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 15 Jul 2010 13:53:50 +0200
Markus Hennig <mhennig@gmail.com> wrote:

> I got all my data back from a degraded RAID5 array with 3 disks.
> The only point which is worth to mention: XFS as underlying file
> system is ineligible for small/cheap NAS because it is not edian safe.
> I bought a powerpc driven MAC to replay the XFS journal...

QEMU can emulate almost every modern architecture while running on almost a=
ny
different one, with various degrees of (understandable) slowness.

> That leads to my question to the list: does somebody know if BTRFS is
> endian safe or what is an endian-safe alternative to ext3/ext ?

I'd suggest to use Ext4 for now. You can always convert it to BTRFS at a la=
ter
time: https://btrfs.wiki.kernel.org/index.php/Conversion_from_Ext3

--=20
With respect,
Roman

--Sig_/8SRzd8k+Z74Yrg8KRVvlxQj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkw/CIQACgkQTLKSvz+PZwgh3gCfe1VGqjR2rCiyCuqSWjiz50Hr
pZcAn1IGB4oeJwIxwC5O23avQXWWhY1K
=cBd0
-----END PGP SIGNATURE-----

--Sig_/8SRzd8k+Z74Yrg8KRVvlxQj--
