From: Doug Ledford <dledford@redhat.com>
Subject: Re: [ANNOUNCE] mdadm-3.1 has been withdrawn
Date: Mon, 09 Nov 2009 16:07:09 -0500
Message-ID: <4AF8847D.8030303@redhat.com>
References: <19187.50708.551325.297625@notabene.brown> <4AF829B2.5090001@redhat.com>  <4AF836F8.5040903@panix.com> <cccedfc60911090742x5ac85a5axcf93d5cb9f6f6539@mail.gmail.com> <alpine.DEB.1.10.0911091749320.22728@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig86E569C25CBF68BE8EA183B5"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0911091749320.22728@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Jon Nelson <jnelson-linux-raid@jamponi.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig86E569C25CBF68BE8EA183B5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/09/2009 11:51 AM, Mikael Abrahamsson wrote:
> On Mon, 9 Nov 2009, Jon Nelson wrote:
>=20
>> I've been using 1.1 for everything.  What's the current wisdom
>> regarding 1.0 vs 1.1 or 1.2?
>> I used 1.1 because that's also where filesystem metadata usually goes
>> and therefore one might hope that the presence of the md metadata
>> would prevent accidental identification of a raid volume as containing=

>> a filesystem.
>=20
> I like 1.2 because if you happen to write an MBR or something to the
> drive, you don't lose the superblock.

Of course, I recently had a bug report that I ended closing out as
NOTABUG because of this very ability.  The person had arrays with 1.2
superblocks, and they went to add a new disk, and all the existing disks
had a specific partition layout, so he copied that to the new disk, then
tried to add the partition to the raid array.  It kept returning "device
too small for array".  Then, upon inspection, we come to see he has a
1.2 superblock on the *entire* drive, which left the partition table
intact, but the partition table is *pointless* because the array is on
the whole disk devices.  This sort of confusion is bad.  So, while I
could see making it 1.2 for partitions (so that boot sectors won't
overwrite the superblock), I wouldn't make it 1.2 for whole disk
devices, and in fact it might be wise to refuse to create 1.2
superblocks on whole disk devices.  Just a thought.

> With 1.2 I can also take the drive from a 3ware hw-raid (single drive i=
n
> 3ware bios) and put in a non-3ware (because the 3ware stores the
> superblock at the end, so when you put it in a non-3ware the end has no=
w
> changed).

1.1 should work just as well for this.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig86E569C25CBF68BE8EA183B5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkr4hH0ACgkQg6WylM+/8ZTOAwCeI3f7VENsGJid4JsgdL7y3Lha
OYEAniF6DxATYcP+15j+OnGEcllVyMn6
=fhHp
-----END PGP SIGNATURE-----

--------------enig86E569C25CBF68BE8EA183B5--
