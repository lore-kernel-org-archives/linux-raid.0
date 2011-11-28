From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: linear raid, is partial recovery possible?
Date: Mon, 28 Nov 2011 20:51:00 +0000
Message-ID: <20111128205100.GA8900@cthulhu.home.robinhill.me.uk>
References: <BLU0-SMTP248DE7134BCABFEB83181BD98B20@phx.gbl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BLU0-SMTP248DE7134BCABFEB83181BD98B20@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: wilsonjonathan <piercing_male@hotmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon Nov 28, 2011 at 08:06:35PM +0000, wilsonjonathan wrote:

> Quick question regarding linear raid.
>=20
> If a disk fails on a linear raid I understand how the raid is
> non-recoverable, as a whole, as it has lost a chunk of data.
>=20
> However is it possible to recover the data from the non-failed portion
> of the raid as I assume linear works by starting at one end of the array
> and slowly progresses to the other?
>=20
> Or perhaps it is dependent on the file system on the array, eg. ext
> works by trying to place files distant to each other to help reduce the
> possibility of fragmentation?
>=20
It's entirely dependent on the filesystem, yes. You've obviously lost a
chunk of the filesystem, so whatever was on there (data/metadata) is
lost. You should be able to recover what's on the remaining portion of
the RAID (or AID, as there's no redundancy involved) though.

> Perhaps the filesystem meta data, or some portion, may span between two
> physical drives which would corrupt its table?
>=20
Possibly. Ext2/3/4 scatter duplicate superblocks around the filesystem,
so you should be able to access the root metadata anyway, which will
then link in to whatever metadata is left on the remaining drive(s).

> And obviously if a file spans two disks it would be missing part of its
> data?
>=20
Yep.

> Does the raid underlying a file system do its own things, re-space,
> physical data layout, etc; or does/can a file system impact on the
> workings of an array?
>=20
The RAID system has no knowledge of the filesystem, and the filesystem
sees the array as simply another block device (no different from a
normal disk partition) so there's no way for the two to affect each
other directly. Some fileystem creation tools do use the array
configuration to control how the filesystem is created initially (stripe
sizes, allocation blocks, etc) but those are just parameters that the
user can specify/override anyway.

> The more I look into software raid the more fasinated I become with it
> and its inner workings. While its way beyond me in some of the maths and
> the fact I am un-proficient in C it has really caught my intrigue, and
> all because I wanted to set up a small home server ;-)
>=20
Well, I'd recommend against using linear RAID anyway. There's no
redundancy at all, and no performance benefits. You'd be better off
using the separate disks as separate filesystems.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk7T9DQACgkQShxCyD40xBIDyACeNTLXuQT5gYV391tXF9PoXaQq
7HkAoLOa0FrI/Wn+O0tir+Cipnmp8c0I
=RKbf
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
