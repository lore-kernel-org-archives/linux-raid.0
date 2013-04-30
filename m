From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: replacing drives
Date: Tue, 30 Apr 2013 14:45:35 +0100
Message-ID: <20130430134534.GA14347@cthulhu.home.robinhill.me.uk>
References: <517A8EB5.8080100@supsi.ch>
 <20130426155347.GA9928@cthulhu.home.robinhill.me.uk>
 <517FC46A.1080702@supsi.ch>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <517FC46A.1080702@supsi.ch>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Nunnari <roberto.nunnari@supsi.ch>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Apr 30, 2013 at 03:17:30PM +0200, Roberto Nunnari wrote:

> Robin Hill wrote:
> > On Fri Apr 26, 2013 at 04:27:01PM +0200, Roberto Nunnari wrote:
> >=20
> >> Hi all.
> >>
> >> I'd like to replace two hd in raid1 with larger ones.
> >>
> >> I could just add the new drives in raid1 and mount it on /opt after a=
=20
> >> dump/restore, but I'd prefer to just have to drives instead of four..=
=20
> >> less noise and less power consumption and noise.
> >>
> >> The question is: what whould be the best way to go?
> >> Tricks and tips? Drawbacks? Common errors?
> >>
> >> Any hint/advice welcome.
> >> Thank you. :-)
> >>
> >>
> >> present HD: two WD caviar green 500GB
> >> new HD: two WD caviar green 2TB
> >>
> > I don't think these have SCTERC configuration options, so you'll need to
> > make sure you increase the timeout in the storage stack to prevent read
> > timeouts from causing drives to be prematurely kicked out of the array.
>=20
> How do I increase that timeout?
>=20
Mikael's just answered this one.

> Also, the old HD are up and running for over 4 years now, and never got=
=20
> any trouble.. just time to time a few warning on /dev/sdb from smartctl:
>=20
> Device: /dev/sdb, ATA error count increased from 27 to 28
>=20
> But I don't believe that's something to worry about..
>=20
Probably not. The only counter that's really significant is the number
of reallocated sectors. As for not having had any timeout issues before,
it does depend on the setup. It may be that the disk manufacturers have
increased timeouts on newer disks (the higher data desnity could well
increase the odds of getting failures on the first pass), or it may be
down to vibrations in the chassis causing problems, etc. It's safer to
make sure that the storage subsystem has longer timeouts than the drives
anyway.

> >=20
> >> root@host1:~# uname -rms
> >> Linux 2.6.32-46-server x86_64
> >>
> > That'll be too old for the hot-replacement functionality, but that
> > doesn't make much difference for RAID1 anyway.
>=20
> ok.
>=20
>=20
> >=20
> >> root@host1:~# cat /proc/mdstat
> >> Personalities : [linear] [raid1] [multipath] [raid0] [raid6] [raid5]=
=20
> >> [raid4] [raid10]
> >> md1 : active raid1 sda2[0] sdb2[1]
> >>        7812032 blocks [2/2] [UU]
> >>
> >> md2 : active raid1 sda3[0] sdb3[1]
> >>        431744960 blocks [2/2] [UU]
> >>
> >> md0 : active raid1 sda1[0] sdb1[1]
> >>        48827328 blocks [2/2] [UU]
> >>
> >> unused devices: <none>
> >>
> > The safest option would be:
> >  - add in the new disks
> >  - partition to at least the same size as your existing partitions (they
> >    can be larger)
> >  - add the new partitions into the arrays (they'll go in as spares)
>=20
> got till here..
>=20
>=20
> >  - grow the arrays to 4 members (this avoids any loss of redundancy)
>=20
> now the next step.. that's a raid1 array.. is it possible to grow the=20
> arrays to 4 members?
>=20
Yes, there's no problem with running RAID1 arrays with more than two
mirrors (with md anyway) - they're all identical so it doesn't really
make any difference how many you have.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlF/yv0ACgkQShxCyD40xBL5HQCfe8a3CiZ5kBfY053760bMg3Fl
kyQAnRUMeB/y7nhtzmriuDPVzVWOolgF
=xHRS
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
