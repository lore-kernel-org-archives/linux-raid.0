From: Doug Ledford <dledford@redhat.com>
Subject: Re: RAID 1 using SSD and 2 HDD
Date: Fri, 29 Jul 2011 09:38:37 -0400
Message-ID: <4E32B7DD.5010102@redhat.com>
References: <4E25C9BA.1060401@dodtsair.com> <24EACA6AC4B506428C92FE7C172FEF4E02084CF0@MX16A.corp.emc.com> <4E31AAEE.30601@redhat.com> <201107290153.45227.xavier@alternatif.org> <4E327E12.30900@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5076EEFAEB8C3AAE4A3C0BDF"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E327E12.30900@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Xavier Brochard <xavier@alternatif.org>, brian.foster@emc.com, mpower@dodtsair.com, rm@romanrm.ru, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5076EEFAEB8C3AAE4A3C0BDF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 7/29/2011 5:32 AM, John Robinson wrote:
>> One thing you didn't said is the respective size of the SSD and HD
>> partitions.
>> How did you determine them?
>=20
> Since he's running RAID-1, the partitions on the SSD and HDDs must be
> the same size. Note that the rest of the space on the HDDs was given to=

> /home and was not mirrored on the SSD.

Exactly.  I had a 128GB SSD, so I split it up more or less like so:

3GB to /boot (I run lots of test kernels)
20GB to / (more than enough in almost all cases)
90+GB to /home/dledford/repos

The hard drives were 500GB, so once I took out the 128 or so GB that was
mirrored to the SSD, that left another 375GB or so for the /home partitio=
n.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig5076EEFAEB8C3AAE4A3C0BDF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk4yt90ACgkQQ9aEs6Ims9gChwCfZ+pvWhUsuYcJNnLSgKPZsn0F
WX0AoMMmzedfQv0zXKrGSLJvM/cetHK5
=wL7S
-----END PGP SIGNATURE-----

--------------enig5076EEFAEB8C3AAE4A3C0BDF--
