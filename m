From: "Robert L. Harris" <Robert.L.Harris@rdlg.net>
Subject: Re: Software RAID level 1 issue
Date: Fri, 30 May 2003 17:44:57 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030530214457.GT20195@rdlg.net>
References: <C587FF391BCAD411B8120008C7864670057DA5B8@mtvxch07.veritas.com> <1054403067.14818.280.camel@testlin.hades> <3ED7B898.4409555F@SteelEye.com> <1054409970.14937.296.camel@testlin.hades>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+Yg8W10oK6rlW0RR"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1054409970.14937.296.camel@testlin.hades>
To: Stef Telford <stef@chronozon.artofdns.com>
Cc: Paul Clements <Paul.Clements@SteelEye.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--+Yg8W10oK6rlW0RR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



The problem I see and I believe I've had is when the box starts to boot
up the system hangs durring the init script runs (pre-runlevel 3).  At
these times my system is busy hammering my raid arrays and will finally
continue on to run level 3 once things are synced up.


Thus spake Stef Telford (stef@chronozon.artofdns.com):

> Paul Clements wrote:
> > Stef Telford wrote:
> >=20
> > [snip]
> >=20
> > > during resync's on raid-1 the mirror will not be available.=20
> >=20
> > I'm not sure I understand this. md/raid1 devices are accessible while
> > resync is occurring...albeit with lower I/O throughput since the resync
> > is consuming bandwidth.
> >=20
>=20
> The way i read the original posters question was
> that he/she was trying to restart the faulted=20
> 'device', or rather was trying to re-activate the=20
> broken md device whilst the working copy was trying to
> rebuild it. accessing the working copy should work, but
> not the broken md (unless i have seriously misread
> someplace :). Under raid5 or raid10, you can still=20
> access the broken md during a resync/rebuild, this
> was what i thought the person was trying to do.
>=20
> apologies if i misunderstood the original phrasing :)
>=20
> regards=20
> Stef Telford <stef@chronozon.artofdns.com>
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

:wq!
---------------------------------------------------------------------------
Robert L. Harris                     | GPG Key ID: E344DA3B
                                         @ x-hkp://pgp.mit.edu=20
DISCLAIMER:
      These are MY OPINIONS ALONE.  I speak for no-one else.

Diagnosis: witzelsucht  =09

IPv6 =3D robert@ipv6.rdlg.net	http://ipv6.rdlg.net
IPv4 =3D robert@mail.rdlg.net	http://www.rdlg.net

--+Yg8W10oK6rlW0RR
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE+19DZ8+1vMONE2jsRAluHAJ4tgRS/7ZnJXMVX1YhJ5q7od38QWACeKQte
vETFXtdDMgrb5F+rEU1CiRo=
=RIR9
-----END PGP SIGNATURE-----

--+Yg8W10oK6rlW0RR--
