From: "Robert L. Harris" <Robert.L.Harris@rdlg.net>
Subject: Re: Software RAID level 1 issue
Date: Fri, 30 May 2003 19:32:55 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030530233255.GU20195@rdlg.net>
References: <C587FF391BCAD411B8120008C7864670057DA5B8@mtvxch07.veritas.com> <1054403067.14818.280.camel@testlin.hades> <3ED7B898.4409555F@SteelEye.com> <1054409970.14937.296.camel@testlin.hades> <20030530214457.GT20195@rdlg.net> <3ED7D58B.984C6A17@SteelEye.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NHfequSh1hmJPP0s"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3ED7D58B.984C6A17@SteelEye.com>
To: Paul Clements <Paul.Clements@SteelEye.com>
Cc: Stef Telford <stef@chronozon.artofdns.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--NHfequSh1hmJPP0s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



Actually, bingo a light just came on.  I think this may be the issue.
Why it hangs like this I'm not sure as all my systems are ext3 and being
as his is RedHat9 I'd think his are journaled by default so the fsck
shouldn't take long.  Mine are Debian 3.0


Thus spake Paul Clements (Paul.Clements@SteelEye.com):

> "Robert L. Harris" wrote:
> >=20
> > The problem I see and I believe I've had is when the box starts to boot
> > up the system hangs durring the init script runs (pre-runlevel 3).  At
> > these times my system is busy hammering my raid arrays and will finally
> > continue on to run level 3 once things are synced up.
>=20
> Hmm, could it be fsck on a busily resyncing array? It must be something
> in the initscripts that is causing this...the driver's raidstart command
> will return and give you access to the device before (while) the resync
> begins...=20
>=20
> Is this on Red Hat?
>=20
> --
> Paul
>=20
> > Thus spake Stef Telford (stef@chronozon.artofdns.com):
> >=20
> > > Paul Clements wrote:
> > > > Stef Telford wrote:
> > > >
> > > > [snip]
> > > >
> > > > > during resync's on raid-1 the mirror will not be available.
> > > >
> > > > I'm not sure I understand this. md/raid1 devices are accessible whi=
le
> > > > resync is occurring...albeit with lower I/O throughput since the re=
sync
> > > > is consuming bandwidth.
> > > >
> > >
> > > The way i read the original posters question was
> > > that he/she was trying to restart the faulted
> > > 'device', or rather was trying to re-activate the
> > > broken md device whilst the working copy was trying to
> > > rebuild it. accessing the working copy should work, but
> > > not the broken md (unless i have seriously misread
> > > someplace :). Under raid5 or raid10, you can still
> > > access the broken md during a resync/rebuild, this
> > > was what i thought the person was trying to do.
> > >
> > > apologies if i misunderstood the original phrasing :)
> > >
> > > regards
> > > Stef Telford <stef@chronozon.artofdns.com>
> > >
> > > -
> > > To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >=20
> > :wq!
> > -----------------------------------------------------------------------=
----
> > Robert L. Harris                     | GPG Key ID: E344DA3B
> >                                          @ x-hkp://pgp.mit.edu
> > DISCLAIMER:
> >       These are MY OPINIONS ALONE.  I speak for no-one else.
> >=20
> > Diagnosis: witzelsucht
> >=20
> > IPv6 =3D robert@ipv6.rdlg.net     http://ipv6.rdlg.net
> > IPv4 =3D robert@mail.rdlg.net     http://www.rdlg.net
> >=20
> >   ---------------------------------------------------------------------=
---
> >    Part 1.2Type: application/pgp-signature

:wq!
---------------------------------------------------------------------------
Robert L. Harris                     | GPG Key ID: E344DA3B
                                         @ x-hkp://pgp.mit.edu=20
DISCLAIMER:
      These are MY OPINIONS ALONE.  I speak for no-one else.

Diagnosis: witzelsucht  =09

IPv6 =3D robert@ipv6.rdlg.net	http://ipv6.rdlg.net
IPv4 =3D robert@mail.rdlg.net	http://www.rdlg.net

--NHfequSh1hmJPP0s
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE+1+om8+1vMONE2jsRAtpTAKCbUm4fPi0PZLJgWzISSjju5OpSdACg5x53
69a6qUmVmDxw8SrDUQnlsdI=
=OH3j
-----END PGP SIGNATURE-----

--NHfequSh1hmJPP0s--
