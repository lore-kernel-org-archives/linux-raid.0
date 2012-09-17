From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: What parameters to mdadm, to re-create md device with payload
 starting at 0x22000 position on backing storage?
Date: Mon, 17 Sep 2012 18:49:52 +0100
Message-ID: <20120917174952.GA6559@cthulhu.home.robinhill.me.uk>
References: <5056CA7E.5040303@statystyka.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5056CA7E.5040303@statystyka.net>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon Sep 17, 2012 at 09:00:14AM +0200, Adam Ryczkowski wrote:

> I try to recover from mdadm raid disaster, which happened when moving=20
> from ubuntu server 10.04 to 12.04. I know the correct order of devices=20
> from dmesg log, but given this information, I still cannot access the dat=
a.
>=20
> The superblocks look messy; the mdadm --examine for each disk is on=20
> http://askubuntu.com/questions/186666/mdadm-fails-after-10-04-12-04-upgra=
de
>=20
> By inspecting the raw contents of backing storage, I found the beginning=
=20
> of my data (the LUKS container in my case) starts at position 0x22000=20
> relative to the beginning of the first partition in the raid, .i.e.=20
> /dev/sdb6.
>=20
> Question: What is the combination of options issued to "mdadm --create"=
=20
> to re-create mdadm that starts with the given offset? Bitmap size?
>=20
> The relevant information from syslog when the system was healthy are=20
> pasted here: http://pastebin.com/9KKaXXiU
>=20
Looks like you've been hit by the bug mentioned here:
    http://neil.brown.name/blog/20120615073245

You've got most of the required data to recreate the array. It's just
the chunk size missing I think. This is probably 512K as the arrays are
using 1.2 superblocks, but it may be 64K if you were using an old mdadm
version.

Your data offset is 272 sectors, which means you'll need to use an older
mdadm version to re-create the array. Newer versions use 2048 sectors,
but it looks like version 3.0 uses 272, so grab a copy of that if
possible.

Assuming your drives are numbered in the same order as previously, the
create commands will be:
    mdadm -C /dev/md5 -e 1.2 -l 5 -n 5 /dev/sd{b,f,c,e,d}6 \
        --assume-clean --uuid=3Da3945c40:73237cd6:3d61998e:8f773d03
and
    mdadm -C /dev/md6 -e 1.2 -l 6 -n 5 /dev/sd{b,f,c,e,d}5 \
        --assume-clean --uuid=3D2a8fd2df:3ad53552:e8b80ecf:a46d93a2

Make sure you use the curly brace format to list the disks rather than
square brackets - that'll ensure the order is maintained. Also make sure
that --assume-clean is used to prevent rebuilding from kicking off, and
losing data.

After recreating the array, run a "fsck -n" on the array to check
whether the details are correct. If not, stop the array and try
recreating it again, adding "-c 64" to set the chunk size to 64K.

Once you've got them up and fsck shows clean, you can re-add the bitmaps
using "mdadm -G /dev/mdX --bitmap=3Dinternal".

Do read through Neil's blog post first as there may be something I've
missed.

HTH and good luck,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlBXYr8ACgkQShxCyD40xBIxuQCfWzVkIlwAab9c07+mpTmkYI6I
aSkAnjxPFc7Nsxp2Du9Od7C/DLgLeH8o
=XHoI
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
