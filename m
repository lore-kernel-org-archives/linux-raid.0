From: "Robert L. Harris" <Robert.L.Harris@rdlg.net>
Subject: Re: "failed-disk" ?
Date: Thu, 20 Mar 2003 16:32:53 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030320213253.GP13201@rdlg.net>
References: <20030320212250.GO13201@rdlg.net> <20030320212951.GA30142@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OmL7C/BU0IhhC9Of"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030320212951.GA30142@marowsky-bree.de>
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--OmL7C/BU0IhhC9Of
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



No but according to the RAID HOWTO it says it's a valid keyword for when
you need to build a mirror with a failed/missing disk (i.e. converting
root to raid and can't kill your existing /)


Thus spake Lars Marowsky-Bree (lmb@suse.de):

> On 2003-03-20T16:22:50,
>    "Robert L. Harris" <Robert.L.Harris@rdlg.net> said:
>=20
> > I'm trying to "mkraid /dev/md1" with the following:
> >=20
> > raiddev /dev/md1
> >   raid-level 1
> >   nr-raid-disks 2
> >   nr-spare-disks 0
> >   chunk-size 16
> >   persistent-superblock 1
> >   device failed-disk
> >   raid-disk 0
> >   device /dev/sdb1
> >   raid-disk 1
> >=20
> > I'm trying to convert this machine to raid1 on root.  Don't ask about
> > the md1, long story.  At any rate when I do the mkraid I get this:
> >=20
> > root@rharris-build2:~# mkraid /dev/md1
> > handling MD device /dev/md1
> > analyzing super-block
> > couldn't call stat() on device failed-disk -- No such file or directory
> > mkraid: aborted, see the syslog and /proc/mdstat for potential clues.
>=20
> Does your system have a device named 'failed-disk' ? I would assume not ;=
-)
>=20
>=20
> Sincerely,
>     Lars Marowsky-Br?e <lmb@suse.de>
>=20
> --=20
> SuSE Labs - Research & Development, SuSE Linux AG
>  =20
> "If anything can go wrong, it will." "Chance favors the prepared (mind)."
>   -- Capt. Edward A. Murphy            -- Louis Pasteur

:wq!
---------------------------------------------------------------------------
Robert L. Harris                     | PGP Key ID: E344DA3B
                                         @ x-hkp://pgp.mit.edu=20
DISCLAIMER:
      These are MY OPINIONS ALONE.  I speak for no-one else.

Diagnosis: witzelsucht  =09

IPv6 =3D robert@ipv6.rdlg.net	http://ipv6.rdlg.net
IPv4 =3D robert@mail.rdlg.net	http://www.rdlg.net

--OmL7C/BU0IhhC9Of
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+ejOF8+1vMONE2jsRAq8TAKDWtSpy6jNAUZ9YVSUh4+eYif2GtACfehP8
v7Ji33bYFjvvfw7ayL1NI5E=
=k7m9
-----END PGP SIGNATURE-----

--OmL7C/BU0IhhC9Of--
