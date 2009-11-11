From: Doug Ledford <dledford@redhat.com>
Subject: Re: Bitmap did not survive reboot
Date: Wed, 11 Nov 2009 15:35:50 -0500
Message-ID: <4AFB2026.2010001@redhat.com>
References: <20091111150155475.WWUI3390@cdptpa-omta03.mail.rr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3676712E820A0AC48E1629A5"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091111150155475.WWUI3390@cdptpa-omta03.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3676712E820A0AC48E1629A5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/11/2009 10:01 AM, Leslie Rhorer wrote:
>=20
>>> If you have a temporary space for your data, I'd suggest you move it
>>> out and go for an internal bitmap solution. It certainly beats the
>>> patch work you're going to have to do on the startup scripts (and
>>> every time you update mdadm, or the distro).
>>>
>> There should be no need to move the data off - you can add an internal=

>> bitmap using the --grow option.  An internal bitmap does have more of =
an
>> overhead than an external one though.
>=20
> 	I thought I remembered reading in the man page than an internal
> bitmap could only be added when the array was created?  Is that incorre=
ct? =20

Yes, very incorrect.  You can use grow to add an internal bitmap later,
the only limitation is that the bitmap must be small enough to fit in
the reserved space around the superblock.  It's in the case that you
want to create some super huge, absolutely insanely fine grained bitmap
that it must be done at raid device creation time and that's only so it
can reserve sufficient space for the bitmap.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig3676712E820A0AC48E1629A5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkr7ICYACgkQg6WylM+/8ZT5OgCfaCSIRoYmic5i8RYwbavT4Qsx
oVIAoJlK3SAhBlMUGjrcBzbasHxvX++O
=pIvE
-----END PGP SIGNATURE-----

--------------enig3676712E820A0AC48E1629A5--
