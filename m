From: Doug Ledford <dledford@redhat.com>
Subject: Re: safe segmenting of conflicting changes
Date: Mon, 26 Apr 2010 12:59:07 -0400
Message-ID: <4BD5C65B.7080707@redhat.com>
References: <loom.20100423T152429-20@post.gmane.org> <4BD1B7E8.9020602@cfl.rr.com> <4BD1E491.3090603@cfl.rr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7872A22BD07E6D5BB323534C"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BD1E491.3090603@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7872A22BD07E6D5BB323534C
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/23/2010 02:18 PM, Phillip Susi wrote:
> After some more testing it seems the problems with --incremental are
> more deep and general.  I have found two steps that both appear to do
> the wrong thing:
>=20
> mdadm /dev/md0 --fail /dev/sdb
> mdadm /dev/md0 --remove /dev/sdb
>=20
> At this point mdadm -E /dev/sda shows that sdb has been removed, but
> mdadm -E of /dev/sdb shows both disks are active and in sync still.  Th=
e
> metadata of sdb should be updated when failed or removed if possible.
>=20
> mdadm --incremental /dev/sdb
>=20
> This goes ahead and adds the disk back to the array, despite the fact
> that it has been explicitly removed.

Of course it does.  You've just explicitly readded it, which is no
different than your explicit removal.  Mdadm honors both.

> Whether or not the superblock on sdb is updated when it is removed,
> --incremental should NOT use it as long as mdadm -D /dev/md0 says that
> disk is removed, at least not use it in /dev/md0.

Why not?  It's not like it uses it without correcting the missing bits
first.  My guess is that you've either A) got a write intent bitmap or
B) did the test in such a way that the raid stack knows the drive is
actually still in sync, in which case it was readded without resyncing
or with only the resyncing necessary to satisfy the bitmap, either of
which was probably so fast you didn't notice it.  To test this to your
satisfaction and make sure that the raid stack is doing what you want,
fail then remove a drive, then do a bunch of writes to the array, *then*
readd the drive using incremental.  It will either get kicked out as
stale, or it will get resynced.  Can't remember which off the top of my
head.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig7872A22BD07E6D5BB323534C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvVxlsACgkQg6WylM+/8ZSsTgCfSzpnZ3G/7raSBIHy2EN7NeEj
DE4AoIUTWcWL/TzslwF6s4B2ItINe3KH
=AdI1
-----END PGP SIGNATURE-----

--------------enig7872A22BD07E6D5BB323534C--
