From: Doug Ledford <dledford@redhat.com>
Subject: Re: [ANNOUNCE] mdadm-3.1 has been withdrawn
Date: Mon, 09 Nov 2009 09:39:46 -0500
Message-ID: <4AF829B2.5090001@redhat.com>
References: <19187.50708.551325.297625@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigED375E278C08606C750BC47A"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19187.50708.551325.297625@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <nfbrown@novell.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigED375E278C08606C750BC47A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/06/2009 01:45 AM, Neil Brown wrote:
>=20
> Greetings.
>=20
>  About a week ago I released mdadm-3.1
>  I have now 'withdrawn' it meaning that it doesn't appear on the
>  kernel.org mirrors any more, and I ask people not to use it.

Although the cause for this sucks, I was actually going to suggest that
since 3.1 is a version bump, that we take the opportunity to change a
few defaults.  Like switching to version 1 superblocks instead of
version 0 by default.  And changing the default chunk size to 512k
instead of 64k.  The time has simply come for the 0->1 superblock
change, and I have a good deal of data showing that for SATA disks at
least, the 512k chunk size is the typical sweet  spot.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigED375E278C08606C750BC47A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkr4KbcACgkQg6WylM+/8ZSsSgCdEy1WbANDBkV3KWHHaKJzKj/V
a4sAoIjXaThULlj66S1sYaFwptjeAK/x
=nsOA
-----END PGP SIGNATURE-----

--------------enigED375E278C08606C750BC47A--
