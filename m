From: NeilBrown <neilb@suse.de>
Subject: Re: Failed to find backup of critical section
Date: Sun, 1 Sep 2013 19:21:49 +1000
Message-ID: <20130901192149.6f119180@notabene.brown>
References: <5223012C.2090207@nathanshearer.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/e8_I_ZuPp1rBiAeUiqGH_=f"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5223012C.2090207@nathanshearer.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Nathan Shearer <mail@nathanshearer.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/e8_I_ZuPp1rBiAeUiqGH_=f
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 01 Sep 2013 02:56:12 -0600 Nathan Shearer <mail@nathanshearer.ca>
wrote:

> Hi, I've run into a problem recovering my array from a server power=20
> failure. I'll try to keep it short so here is a sequence of events:
>=20
>  1. Running a healthy 4-disk RAID5 array (on server-01).
>  2. Added a 5th drive and grow the array to a 5-disk RAID6 array (backup
>     file stored on a separate RAID1 array on other disks)
>  3. Grow begins and passes the critical section, gets to ~15% complete
>     and power to the server fails

When growing a 4-disk RAID5 to a 5-disk RAID6 the entire process is in the
"critical section".  This is because it is always writing to location where
live data is.
When increasing the number of data drives there is a short critical section
at the start.
When decreasing the number of data drives there is a short critical section
at the end.
But when you don't change the number of data drives as in this case, it is
all critical and all needs a backup.

>  4. I then move all 5 drives to backup server. The RAID5/6 array
>     assembles and grow continues (without backup file since it's on
>     server-01)

That shouldn't work.  It shouldn't start without the backup file.

>  5. I begin copying data off of that array onto a separate array --
>     filesystem and data is consistent :)
>  6. Power restored to server-01
>  7. Safely stop the growing array with mdadm --stop
>  8. Move 5 drives back into server-01
>  9. Attempt mdadm --assemble and I get:
>     # mdadm --assemble /dev/md9
>     mdadm: Failed to restore critical section for reshape, sorry.
>            Possibly you needed to specify the --backup-file

That should have happened on server-02

> 10. Attempt with the original backup file:
>     # mdadm --assemble /dev/md9 --backup-file
>     /mnt/temp/raid-reshape-backup-file
>     mdadm: Failed to restore critical section for reshape, sorry.
>=20
> So when I enable --verbose I get:
>=20
>     mdadm:/dev/md9 has an active reshape - checking if critical section
>     needs to be restored
>     mdadm: Failed to find backup of critical section
>     mdadm: Failed to restore critical section for reshape, sorry.
>            Possibly you needed to specify the --backup-file
>=20
> When I provide the backup file I get:
>=20
>     mdadm:/dev/md9 has an active reshape - checking if critical section
>     needs to be restored
>     mdadm: too-old timestamp on backup-metadata on
>     /mnt/temp/raid-reshape-backup-file
>     mdadm: Failed to find backup of critical section
>     mdadm: Failed to restore critical section for reshape, sorry.
>=20
> When I tell it to use the "old" backup file I get:
>=20
>     # export MDADM_GROW_ALLOW_OLD=3D1
>     # mdadm --assemble /dev/md9 -vv --backup-file
>     /mnt/temp/raid-reshape-backup-file
>     mdadm:/dev/md9 has an active reshape - checking if critical section
>     needs to be restored
>     mdadm: accepting backup with timestamp 1377794387 for array with
>     timestamp 1377904444
>     mdadm: backup-metadata found on /mnt/temp/raid-reshape-backup-file
>     but is not needed
>     mdadm: Failed to find backup of critical section
>     mdadm: Failed to restore critical section for reshape, sorry.
>=20
> OK, so the backup file is not needed. I assume this is because the=20
> critical section was passed long ago, but then why is it attempting to=20
> find and restore the backup file when it is provided and also not=20
> needed? I have not tried a --force because I don't want to trash my=20
> array if there is another better option that I can still try. Any ideas?=
=20
> Is this potentially a bug in mdadm where this kind of array state is not=
=20
> expected?
>=20

The content of the backup file is not needed as it is (presumably) before t=
he
place where the reshape has proceeded to.

The backup is only needed after an unclean shutdown.  Presumably you had an
unclean shutdown when server-01 lost power, so that could have resulted in
corruption and shouldn't have restarted easily on server-02.

However as the shutdown on server-02 was clean there would be no further
corruption.
You can start the array by giving a backup file (it can be empty) and
specifying  --invalid-backup.  This  tells mdadm not to bother if it cannot
restore the critical section but to just keep going.

NeilBrown



--Sig_/e8_I_ZuPp1rBiAeUiqGH_=f
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUiMHLjnsnt1WYoG5AQJ/QRAArjy1yb9MaG1DQdYlhxY/Rk3R5Q58n9yJ
bce9lRhYhUd+kF+f2KVx8RjdtX/Y0MmZem2HK7O862Y9X8qlKrsSdZ9LMxWJ8omv
rZgKQc4Nb0vGrGRtgBRD7Z//VZKq7DJE4RF4gzgL/6/ua3OFW5/x7FS3M6DxPnTx
xsrFtIiAhIHwr5HeMadWyVNOp+JweSKmBWrWUcWO4VLNstqOwDgOPLRFaXRM5H8k
spUq8axRtJHiQRj4nCF8UkHkoZBG+423acK182QJ0fn2O9pnfTKtTk/nlqAWjEvn
RG71li7eQEP2dZOI4EFA1NHMidPtERv/TRheozc926iZ2zNjvpu3mIt2DDygFVLX
QpQRNRHxU5X4Z8xvMgqvVh9yQSLQdHZ2usm+/ZygwiSK4snR2+LLw83crhybxXiq
3VL5MjQn7ejQHSRS2FGxLYD2VCUECA/l5wVFYEcx6mae8qUZVkMiuK12e2gWkx1+
kfEIjLY3K3rrgbXzEpCA/OpRuvmbRr7TYy+F2StPuujYSub2lTw1kif2ySD9Rbwf
1lWAvX0x3xhXNhD3Nokmb0KrVq0WHlywvjs6j9EQ/q99zOg3pRO4qvA68k5YsgF5
4QCME70JNqY86HQ26FwBPCgpUsCLv/bmrGR/Rd3cBxwhFnWfDk+6z5DRwOpx9i7p
71X8gWVDYA4=
=9/AU
-----END PGP SIGNATURE-----

--Sig_/e8_I_ZuPp1rBiAeUiqGH_=f--
