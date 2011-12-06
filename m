From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: need a little help rebuilding a raid 10
Date: Tue, 6 Dec 2011 14:39:28 +0000
Message-ID: <20111206143927.GB16489@cthulhu.home.robinhill.me.uk>
References: <CAGpXXZKdbs+Y3qNHnVmFGB3sKE5R7viRajrVM+udUqoDgsA0yg@mail.gmail.com>
 <CAGpXXZKWB7qpRtWK7GuohuF-OOuAGQ_tSODCnLCouS+Z-SWZDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tsOsTdHNUZQcU9Ye"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGpXXZKWB7qpRtWK7GuohuF-OOuAGQ_tSODCnLCouS+Z-SWZDA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--tsOsTdHNUZQcU9Ye
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Dec 06, 2011 at 09:11:24AM -0500, Greg Freemyer wrote:

> Hmm...
>=20
> My rebuild failed.  At first glance I had both a failed drive and a faile=
d slot?
>=20
> What I don't understand is I have I/O errors in /var/log/messages from
> when the rebuild failed over night.
>=20
> But this morning, hdparm --read-sector is reading the "bad" sectors fine.
>=20
> I already tried replacing the drive and the replacement drive also
> reported media errors during the rebuild, that's why I came to believe
> I had a bad slot.
>=20
> Now I have non-repeatable media errors.
>=20
> fyi: I have the problem drive connected via eSata now, so it's a
> different controller totally than where it was when the failure first
> occurred.
>=20
> Any thoughts?
>=20
Last time I had this sort of issue, it was down to the motherboard.
Somewhere between the drives and the CPU, one or more of the chipsets
were causing issues (I actually had the same issue on multiple
motherboards, though I think using the same/similar onboard SATA
controllers). Single drive tests worked fine - it was only when
hammering the entire array that it would get a write error and fail a
random drive. I've since bought a proper SAS/SATA PCIe card (Intel
RS2WC080) and have had no issues since.

The other things I can think of that may cause this type of issue are a
flaky PSU, or physical shock to the server chassis (even relatively
small movements can cause read/write slowdowns/errors - there's a video
clip online of someone just shouting in front of a rack and causing the
transfer speed to drop off dramatically).

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--tsOsTdHNUZQcU9Ye
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk7eKR8ACgkQShxCyD40xBK5lwCdE0EEyoJYGiuFYEvMYjOsM6Cm
eSIAoIaTGIY6ub2ZLw+RXpcQjzYaASFi
=4I7l
-----END PGP SIGNATURE-----

--tsOsTdHNUZQcU9Ye--
