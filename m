From: Robin Hill <robin.hill47@ntlworld.com>
Subject: Re: RAID1 question
Date: Thu, 29 Sep 2011 21:25:05 +0100
Message-ID: <20110929202505.GB23316@cthulhu.home.robinhill.me.uk>
References: <20110929183457.GA19871@electro-mechanical.com>
 <20110929192611.GA23316@cthulhu.home.robinhill.me.uk>
 <20110929193705.GE19871@electro-mechanical.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NMuMz9nt05w80d4+"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110929193705.GE19871@electro-mechanical.com>
Sender: linux-raid-owner@vger.kernel.org
To: William Thompson <wt@electro-mechanical.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--NMuMz9nt05w80d4+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Sep 29, 2011 at 03:37:05PM -0400, William Thompson wrote:

> On Thu, Sep 29, 2011 at 08:26:11PM +0100, Robin Hill wrote:
> > On Thu Sep 29, 2011 at 02:34:57PM -0400, William Thompson wrote:
> >=20
> > > Please keep me in the CC.  I am not on the list.
> > >=20
> > > If I have a RAID1 of 2 disks and I decide to move them to another com=
puter
> > > and recreate the raid, does it really need to do the initial recovery?
> > >=20
> > You don't need to recreate the raid at all, just reassemble it. You may
> > want to update the homehost though, otherwise it will (IIRC) auto
> > assemble to md_126 (or so) instead of md0.
>=20
> The reason I asked this was because a mirrored pair that I currently have=
 is
> 0.90 version and I was going to use 1.0
>=20
You _should_ be able to do a --create --assume-clean there, without
losing the data, but I'd go with a backup, --create, and restore jsut to
be safe.

> > > For that matter, when creating a RAID1 on 2 disks, is it really needed
> > > to do the initial recovery?
> > >=20
> > > I understand why it's needed for RAID4/5/6 though.
> > >
> > Probably not, no. Anything written would go to both mirrors, and reads
> > of any un-mirrored areas are indeterminate anyway. You would lose the
>=20
> I figured this would be the case.
>=20
> > ability to check the array for mismatches though, and the recovery
> > process would bring everything into sync whenever it's run anyway. More
>=20
> I've rarely done this.  On large disks, this takes may hours to perform.
>=20
It can, but it also ensures the disks are readable. If you don't run
regular checks, in a recovery situation you may hit a bad block on a
supposedly good disk and have a heap more trouble to deal with.

> > of a question would be why not do the initial recovery? It doesn't delay
> > access to the array, and at least the I/O load is happening at a
> > controlled point (rather than at recovery time, when you have no
>=20
> I guess the only reason I can come up with would be to avoid extra head
> seeks.  Well, that and the time it takes.
>=20
> During the initial sync, if a write happens to an area that has been sync=
ed,
> does it go to all drives?  What about a write to an area that as not been
> synced yet?
>=20
If the area has already been synced then writes will definitely go to
all members. I'm pretty sure this also happens in areas which haven't
been synced as well, but I'm not 100% on that.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--NMuMz9nt05w80d4+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk6E1CEACgkQShxCyD40xBIaSgCgqWdHsOIUEq4x6mrhLgpY6BnW
6JoAoMzElUg9nQFAO2Q+PeGhdNwHbacr
=zVeT
-----END PGP SIGNATURE-----

--NMuMz9nt05w80d4+--
