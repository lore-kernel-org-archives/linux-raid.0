From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: alignment of metadata 1.2 and mkfs.ext4
Date: Wed, 6 Jul 2011 11:03:32 +0100
Message-ID: <20110706100332.GA9957@cthulhu.home.robinhill.me.uk>
References: <1309936276.11661.8.camel@baal>
 <20110706152016.1982c6fd@natsu>
 <1309945954.2685.2.camel@baal>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1309945954.2685.2.camel@baal>
Sender: linux-raid-owner@vger.kernel.org
To: "Tyler J. Wagner" <tyler@tolaris.com>
Cc: Roman Mamedov <rm@romanrm.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Jul 06, 2011 at 10:52:34AM +0100, Tyler J. Wagner wrote:

> On Wed, 2011-07-06 at 15:20 +0600, Roman Mamedov wrote:
> > On Wed, 06 Jul 2011 08:11:16 +0100
> > "Tyler J. Wagner" <tyler@tolaris.com> wrote:
> >=20
> > > Metadata 1.2 puts the data 4K from the start of the device/partition.
> >=20
> > This is not correct. See mdadm -E /dev/sdX.
> >=20
> > $ sudo mdadm -E /dev/sdc3
> > /dev/sdc3:
> > ...
> >         Version : 1.2
> > ...
> >     Data Offset : 2048 sectors
> > ...
>=20
> That is very interesting. The mdadm man page, and everything I've seen
> online, all say "The different sub-versions store the superblock at
> different locations on the device, either at the end (for 1.0), at the
> start (for 1.1) or 4K from the start (for 1.2)."
>=20
That's the RAID superblock at 4K, not the data.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk4UMvQACgkQShxCyD40xBKT8QCeLqNIVXvSAEY84vzagTNW4OGl
41sAnjC7KZTWxnLZP7ID8DyoxfAFyDnz
=41HY
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
