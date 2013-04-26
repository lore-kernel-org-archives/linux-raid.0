From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: replacing drives
Date: Fri, 26 Apr 2013 16:53:47 +0100
Message-ID: <20130426155347.GA9928@cthulhu.home.robinhill.me.uk>
References: <517A8EB5.8080100@supsi.ch>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <517A8EB5.8080100@supsi.ch>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Nunnari <roberto.nunnari@supsi.ch>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Apr 26, 2013 at 04:27:01PM +0200, Roberto Nunnari wrote:

> Hi all.
>=20
> I'd like to replace two hd in raid1 with larger ones.
>=20
> I could just add the new drives in raid1 and mount it on /opt after a=20
> dump/restore, but I'd prefer to just have to drives instead of four..=20
> less noise and less power consumption and noise.
>=20
> The question is: what whould be the best way to go?
> Tricks and tips? Drawbacks? Common errors?
>=20
> Any hint/advice welcome.
> Thank you. :-)
>=20
>=20
> present HD: two WD caviar green 500GB
> new HD: two WD caviar green 2TB
>=20
I don't think these have SCTERC configuration options, so you'll need to
make sure you increase the timeout in the storage stack to prevent read
timeouts from causing drives to be prematurely kicked out of the array.

>=20
> root@host1:~# uname -rms
> Linux 2.6.32-46-server x86_64
>=20
That'll be too old for the hot-replacement functionality, but that
doesn't make much difference for RAID1 anyway.

> root@host1:~# cat /proc/mdstat
> Personalities : [linear] [raid1] [multipath] [raid0] [raid6] [raid5]=20
> [raid4] [raid10]
> md1 : active raid1 sda2[0] sdb2[1]
>        7812032 blocks [2/2] [UU]
>=20
> md2 : active raid1 sda3[0] sdb3[1]
>        431744960 blocks [2/2] [UU]
>=20
> md0 : active raid1 sda1[0] sdb1[1]
>        48827328 blocks [2/2] [UU]
>=20
> unused devices: <none>
>=20
The safest option would be:
 - add in the new disks
 - partition to at least the same size as your existing partitions (they
   can be larger)
 - add the new partitions into the arrays (they'll go in as spares)
 - grow the arrays to 4 members (this avoids any loss of redundancy)
 - wait for the resync to complete
 - install grub/lilo/syslinux to the new disks
 - fail and remove the old disk partitions from the arrays
 - shrink the arrays back down to 2 members
 - remove the old disks

Then, if you're keeping the same number of partitions but increasing the
size:
 - grow the arrays to fill the partitions
 - grow the filesystems to fill the arrays
or, if you're adding extra partitions:
 - create new arrays on extra partitions
 - format and mount

If you have hot-plug bays then you can do all this without any downtime
(you could also do one disk at a time and just grow the arrays to 3
members), otherwise you'll need to shut down to install and remove the
disks.  If you only have two bays then you could fail one of the disks
then recover to a new one, but that's definitely a risky option.

That's the outline of the process anyway - if you need any details of
the actual commands then do ask.

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlF6owoACgkQShxCyD40xBJP5wCgnk65DasHRs5Wmu0G4LrLyi2H
zsEAniHvZbLod8EfTStT3yETJe83xu56
=3b8P
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
