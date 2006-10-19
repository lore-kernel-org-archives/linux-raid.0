From: Doug Ledford <dledford@redhat.com>
Subject: RE: why partition arrays?
Date: Thu, 19 Oct 2006 11:46:55 -0400
Message-ID: <1161272815.2917.569.camel@fc6.xsintricity.com>
References: <C59E07CE09883545BC9EC6B87E2D3C83523DBF@kdtc.tt.umist.ac.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/QWXGGdSlI8d4lQVB3Ev"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C59E07CE09883545BC9EC6B87E2D3C83523DBF@kdtc.tt.umist.ac.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Ken Walker <ken.walker@manchester.ac.uk>
Cc: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-/QWXGGdSlI8d4lQVB3Ev
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2006-10-19 at 12:25 +0100, Ken Walker wrote:
> So is LVM better for partitions on a large raid5, or any raid, than separ=
ate
> partitions on that array.

In some ways yes, although it introduces a certain amount of uncertainty
in tuning of block devices.

> I'm still in my learning curve :)
>=20
> for example, if one has Linux running on a two disk mirror array, raid1, =
and
> the first disk is partitioned, say 5 partitions, with those partitions
> mirrored on the second disk, and each identical partition is then run as =
a
> mirror raid1.
>=20
> What your saying is that, if a single partition fails, to remove the driv=
e
> you have to fail all the array partitions on the drive your taking out, t=
hen
> rebuild the partitions and then add to the dirty raid the new partitions =
one
> at a time.

Yep.

> Will LVM remove all this, so if you have a mirror as a single raid
> partition, and use LVM to create the partitions on that mirror, if a disk
> goes down, can it be removed, replaced, and then just added to the single
> raid, with LVM having had no idea what was going on in the background and
> just plod along merrily.

Yep.  In addition, with LVM, if you added two new disks, also in a raid1
array, then you could add that to your current volume group as another
physical volume, and the LVM code would happily extend your volume to
span both RAID1 arrays and increase the size.  Since the md code can now
grow things, this isn't as impressive as it used to be, but it's
probably a little easier to handle the lvm stuff than the md growth
stuff if for no other reason than they have graphical LVM tools that you
can do this with.

> Is LVM stable, or can it cause more problems than separate raids on a arr=
ay.

Current incarnations are very stable.  I mentioned earlier that it can
introduce some tuning issues.  If you are dealing with a raid device
directly, then it's relatively straight forward to set the stripe size,
chunk size, etc. according to the number of raid disks and then set the
elevator and possibly things like read ahead values to optimize the raid
array's performance for different needs.  When you introduce LVM on top
of raid, there is the possibility that there will be interactions
between the two that have a detrimental impact on performance (this may
not always be the case, and it may not be unfixable, I'm just saying
it's an additional layer you have to deal with).

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-/QWXGGdSlI8d4lQVB3Ev
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFN53vTzP9PM7pjw8RAia6AJ9Uiw73Lo2x/mTcsXp7cSK22agUEgCePJIk
UWarqblsPkZI5AQkcAPG430=
=vEut
-----END PGP SIGNATURE-----

--=-/QWXGGdSlI8d4lQVB3Ev--

