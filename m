From: "Robert L. Harris" <Robert.L.Harris@rdlg.net>
Subject: Re: "failed-disk" ?
Date: Tue, 25 Mar 2003 09:16:10 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030325141610.GI683@rdlg.net>
References: <20030324143458.GB683@rdlg.net> <Pine.LNX.4.44.0303251453520.31592-100000@duplo.agenda.si>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2xeD/fx0+7k8I/QN"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0303251453520.31592-100000@duplo.agenda.si>
To: danci@agenda.si
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--2xeD/fx0+7k8I/QN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



Actually I thought that meant only when converting a root to raid, but
as a random guess tried this.  I had to physically swap the lines so it
looked like:

device /dev/lvm-vg2/lvm2
raid-disk 1
device /dev/lvm-vg1/lvm1
failed-disk 0

It came right up after that.


Thus spake danci@agenda.si (danci@agenda.si):

> On Mon, 24 Mar 2003, Robert L. Harris wrote:
>=20
> >   I'm at the point of trying to restart /dev/md0 with one mirror dead.
> > My raidtab looks like this:
> >
> > raiddev /dev/md0
> >   raid-level 1
> >   nr-raid-disks 2
> >   nr-spare-disks 0
> >   chunk-size 16
> >   persistent-superblock 1
> >   device /dev/lvm-vg1/lvm1
> >   raid-disk 0
> >   device /dev/lvm-vg2/lvm2
> >   raid-disk 1
> >
> > I changed the first raid-disk line to be:
> >   failed-disk 0
>=20
> I'm not sure if this is your problem, but the Software RAID How-To says:
>=20
> "Don't put the failed-disk as the first disk in the raidtab, that will
> give you problems with starting the RAID. Create the RAID, and put a
> filesystem on it."
>=20
> It may be that SW RAID cannot really use LVMs. It is usually the
> other way around (LVM using RAID arrays).
>=20
>   D.

:wq!
---------------------------------------------------------------------------
Robert L. Harris                     | PGP Key ID: E344DA3B
                                         @ x-hkp://pgp.mit.edu=20
DISCLAIMER:
      These are MY OPINIONS ALONE.  I speak for no-one else.

Diagnosis: witzelsucht  =09

IPv6 =3D robert@ipv6.rdlg.net	http://ipv6.rdlg.net
IPv4 =3D robert@mail.rdlg.net	http://www.rdlg.net

--2xeD/fx0+7k8I/QN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+gGSp8+1vMONE2jsRAu5OAJ9V3JWaWavaUaD92xlKnGt30oIXEwCfetVW
WUiFtPflxx6QyxX49hHSf9I=
=c1PM
-----END PGP SIGNATURE-----

--2xeD/fx0+7k8I/QN--
