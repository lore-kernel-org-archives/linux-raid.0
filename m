From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: raid10 layout for 2xSSDs
Date: Mon, 16 Nov 2009 16:52:54 +0000
Message-ID: <20091116165254.GC28577@cthulhu.home.robinhill.me.uk>
References: <1258381745.31633.35.camel@localhost>
 <878we61oev.fsf@frosties.localdomain>
 <20091116163102.GB28577@cthulhu.home.robinhill.me.uk>
 <7bc80d500911160838r2c21448eyefd788e6c84c780@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/Uq4LBwYP4y1W6pO"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7bc80d500911160838r2c21448eyefd788e6c84c780@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--/Uq4LBwYP4y1W6pO
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon Nov 16, 2009 at 08:38:34AM -0800, Christopher Chen wrote:

> On Mon, Nov 16, 2009 at 8:31 AM, Robin Hill <robin@robinhill.me.uk> wrote:
> > On Mon Nov 16, 2009 at 04:26:32PM +0100, Goswin von Brederlow wrote:
> >
> >> What I'm aiming at is that offset might better fit into erase blocks,
> >> cause less internal fragmentation on the disk and give better wear
> >> leveling. Might improve speed and lifetime. But that is just a
> >> thought. Maybe test and do ask Intel (or other vendors) about it.
> >>
> > I very much doubt this will make any difference. =A0With SSDs you have =
to
> > throw out any preconceptions of internal layout you may have. =A0You ha=
ve
> > absolutely no idea (or control of) where two consecutive blocks will
> > actually get written. =A0Fragmentation and seek time are thus irrelevant
> > (or uncontrollable anyway).
> >
> > I don't see how any RAID-10 layout would perform better than another
> > with SSDs, unless there's internal optimisations/constraints which
> > affect sequential reading from multiple devices. =A0I'm not aware of any
> > though - RAID-10 n2 may be the same layout as RAID-1 but it's an
> > entirely separate piece of code.
>=20
> Don't forget that RAID-1 also does balanced reads.
>=20
Only for parallel reads.  A single sequential read will only access a
single disk, whereas I believe for RAID-10 it will access both disks.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--/Uq4LBwYP4y1W6pO
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAksBg2YACgkQShxCyD40xBKvQgCdHisnvf7YyCwa+QN12p2mt0C6
gaQAoIbrHCL5N6BIERPHKSYjns3As208
=iysT
-----END PGP SIGNATURE-----

--/Uq4LBwYP4y1W6pO--
