From: Doug Ledford <dledford@redhat.com>
Subject: Re: [ANNOUNCE] mdadm-3.1 has been withdrawn
Date: Mon, 09 Nov 2009 16:00:07 -0500
Message-ID: <4AF882D7.4030503@redhat.com>
References: <19187.50708.551325.297625@notabene.brown>    <4AF829B2.5090001@redhat.com> <423765b7af1be77f0a40dcbbb1f65c4b.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDCD84C2218F8732F410CB924"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <423765b7af1be77f0a40dcbbb1f65c4b.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Neil F Brown <nfbrown@novell.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDCD84C2218F8732F410CB924
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/09/2009 03:22 PM, Neil F Brown wrote:
> On Tue, November 10, 2009 1:39 am, Doug Ledford wrote:
>> On 11/06/2009 01:45 AM, Neil Brown wrote:
>>>
>>> Greetings.
>>>
>>>  About a week ago I released mdadm-3.1
>>>  I have now 'withdrawn' it meaning that it doesn't appear on the
>>>  kernel.org mirrors any more, and I ask people not to use it.
>>
>> Although the cause for this sucks, I was actually going to suggest tha=
t
>> since 3.1 is a version bump, that we take the opportunity to change a
>> few defaults.  Like switching to version 1 superblocks instead of
>> version 0 by default.  And changing the default chunk size to 512k
>> instead of 64k.  The time has simply come for the 0->1 superblock
>> change, and I have a good deal of data showing that for SATA disks at
>> least, the 512k chunk size is the typical sweet  spot.
>=20
> I had been toying with that idea myself - certainly of changing the
> defaults soon.
> I'm tempted to make the default metadata "1.1" though possibly not for
> RAID1.  For RAID0,4,5,6,10 there is no value in having the metadata
> at the end of the device.  For RAID1 there is as it makes booting off
> any member easier.
> Thoughts?

While it makes booting off of a raid1 easier, raid1 is *precisely* the
level that is prone to silent data corrupt due to the individual members
being able to be mounted while not part of a running raid array.  I
would make it default to 1.1 period, and force distros or other people
to either A) update the boot loader to something that can handle a 1.1
superblock (grub2 should be able to) or B) manually set it to 1.0 instead=
=2E

>=20
> I'm certainly happy with increasing the chunksize to 512K.
>=20
> NeilBrown


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigDCD84C2218F8732F410CB924
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkr4gtcACgkQg6WylM+/8ZRKSgCfXTFe6OuFWVvo1MxTWvnZHFli
FhoAn0w4cd89k12hmgimgj+yEKdcCseM
=DPUR
-----END PGP SIGNATURE-----

--------------enigDCD84C2218F8732F410CB924--
