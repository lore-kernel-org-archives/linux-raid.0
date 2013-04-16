From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Odd --examine output
Date: Tue, 16 Apr 2013 09:58:57 +0100
Message-ID: <20130416085857.GB25795@cthulhu.home.robinhill.me.uk>
References: <CD917B51.41713%michael.vanhorn@wright.edu>
 <10112252.14.1366051374769.JavaMail.root@zimbra>
 <20844.24431.814932.275104@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xgyAXRrhYN0wYx8y"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20844.24431.814932.275104@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--xgyAXRrhYN0wYx8y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon Apr 15, 2013 at 04:13:35PM -0400, John Stoffel wrote:

> >>>>> "Roy" =3D=3D Roy Sigurd Karlsbakk <roy@karlsbakk.net> writes:
>=20
> >> >NOT a guess. Back up what you can, while you can, and start over. Use
> >> >"fdisk -u" so you can ensure partitions start on multiples of eight
> >> >(8)
> >> >sectors. (Modern fdisk uses 1MB alignment by default. Highly
> >> >recommended.)
> >> >
> >> >
> >>=20
> >> So, if I start the partition at sector 64 (rather than 63), that's
> >> better,
> >> right (since 64 is a multiple of 8)? Or is there more math to do and
> >> I'm still not getting it?
>=20
> Roy> I still don't understand why people use partitions for RAID when
> Roy> the whole drive is used anyway. Partitions were invented to
> Roy> partition things up and are of no use if you want to spend the
> Roy> whole drive's space for RAID use (or otherwise).
>=20
> Because if I take a 2tb disk a I put a partition on there which is a
> bit smaller than the full disk, if I then add a new 2tb (or any other
> size) disk which says it's 2tb, but it's really a bit smaller, then
> I'm not screwed.  I've had it happen.
>=20
Recently? AFAIK, all modern drives (everything over 320G-ish IIRC) use
standardised sizes (i.e. any 2TB disk will present exactly the same
number of sectors). I recall reading that all the manufacturers agreed
to do this to prevent just this sort of issue, though I can't find a
reference to it now.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--xgyAXRrhYN0wYx8y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlFtEtAACgkQShxCyD40xBKuDwCg4cEBqDrUCYG3BadD+/Rn2qdo
mGAAoKMxAFEJ85qNhtj/VTLrjiTtkq1o
=HTXO
-----END PGP SIGNATURE-----

--xgyAXRrhYN0wYx8y--
