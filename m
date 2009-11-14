From: Doug Ledford <dledford@redhat.com>
Subject: Re: [ANNOUNCE] mdadm-3.1 has been withdrawn
Date: Fri, 13 Nov 2009 22:32:24 -0500
Message-ID: <4AFE24C8.10002@redhat.com>
References: <19187.50708.551325.297625@notabene.brown>	 <4AF829B2.5090001@redhat.com>	 <423765b7af1be77f0a40dcbbb1f65c4b.squirrel@neil.brown.name> <e9c3a7c20911131554w28075d39mbc8bebc17a4ef260@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig035F22E5A88A429CFECDFEC3"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20911131554w28075d39mbc8bebc17a4ef260@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Neil F Brown <nfbrown@novell.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig035F22E5A88A429CFECDFEC3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/13/2009 06:54 PM, Dan Williams wrote:
> On Mon, Nov 9, 2009 at 1:22 PM, Neil F Brown <nfbrown@novell.com> wrote=
:
>> I'm certainly happy with increasing the chunksize to 512K.
>=20
> Probably good for reads, but it makes it harder for the code to
> collect full stripe writes.  I guess I should get some data to back
> that up one of these days...

My data (which I have, not that I need to get :-P) suggests that it
really doesn't matter.  For streaming writes, the buffer cache stores
stuff up long enough to get a stripe write even when the stripe is huge.
 For random writes, you don't normally get a full stripe no matter how
long you wait or how small the stripe is.  I say this after looking at
the various performance parameters of a timed 5 minute dbench run and
also the random write time and rate of both 4k and 16k tiotest runs to
raid arrays from 4 to 7 disks and with chunk sizes from 256k up to 1024k
using ext2, ext3, ext4, and xfs filesystems.  From those test results,
512k was roughly the sweet spot, streaming writes were effected far more
than random writes by chunk size, and both were probably even more
dependent on things other than chunk size (filesystem type and layout
for instance).


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig035F22E5A88A429CFECDFEC3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkr+JMgACgkQg6WylM+/8ZRMTACdHXq4o9UgQo3VdH9eR8+PGbfr
gvwAn3zO3pZrCIJs/PNWtQ+mlnXMVyrV
=ZAiT
-----END PGP SIGNATURE-----

--------------enig035F22E5A88A429CFECDFEC3--
