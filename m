From: NeilBrown <neilb@suse.de>
Subject: Re: Hi! Strange issue with LSR -- bitmaps hadn't been used during 2
 of 3 RAIDs resync
Date: Sun, 27 May 2012 22:00:07 +1000
Message-ID: <20120527220007.64fb230b@notabene.brown>
References: <CA+sTkh74rDvV05pjhVAD5wa4fxXsZE5MLN4y4fMd=Js7_BoTDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/FFeV1MpXiYzoSVZzQvXNjQR"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+sTkh74rDvV05pjhVAD5wa4fxXsZE5MLN4y4fMd=Js7_BoTDQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Igor M Podlesny <for.poige+lsr@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/FFeV1MpXiYzoSVZzQvXNjQR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 27 May 2012 19:32:40 +0800 Igor M Podlesny <for.poige+lsr@gmail.com>
wrote:

>    A power outage has happened to system (which was in "suspend"
> state) with RAID-10, RAID-5 and RAID-6. Later on boot, RAID-10 was
> fast re-synced using bitmap, but both RAID-5 and RAID-6 were in
> auto-readonly mode with resync=3DDELAYED. When they flipped to
> Read-Write, LSR started re-syncing not using bitmaps seemingly. A bug?

Maybe.  But with so little detail it is hard to say.
What made you think the bitmaps weren't being used?
Did that arrays still have their bitmaps?
Where they degraded?
How many bits were set in the bitmaps (probably too late to check now)?

Is it reproducable ?  ... OK, I don't really expect you to try to reproduce
it, but if you could that would be awesome!

NeilBrown


>=20
>    Occurred once on Linux 3.2.12, x86_64.
>=20
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/FFeV1MpXiYzoSVZzQvXNjQR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT8IXRznsnt1WYoG5AQLikhAAle7ADJ+ZmkBpEGX1gddI4eFXgO6k5S/4
EuJwN+8XGExxow/u18yDQuSJPtFyECM6bW96Y8ke5voJVSLF9i3tUpz2hSUvmpxv
Y/ncxXZhZA2gRzGzceijGufSNenLvxbdxjp0R7+dddmVmdQ4EgTETmJWfnKxflkd
meex8TrzrhY5rhW51b/g8ylQ58fNVQWweSVEEGAGUyFX00VyxIH5i3cXN46POF15
Jc2UJb/Yc2T4S/d7LRWeEV9doOLvL4hI8+umjGBIYvvAj5IHTNrMFfa/rGnL9YBC
iZyLNrfotZYY3cuosI8/HWPrf/dOzzr1dMK8bpicOmg4/W05SCg+eCs260h/ADZK
a8I8Cr9eQi4qQ0tzWMWuqNrzGvgmJwxx978By3SnniAZR2YX5RR4JTNKdzLFR0TW
U6tgnHo5bvyiNl8EQky7ThWMXWTBrS/86fnMVerDikzXv38JWjqrx7ak9HtzGDBP
pYKT/fS/lB2S3mSv/Agj1b80MeTyd3gtmPjruJapdKfj/wlTlwDXivrh9LekzDaf
0HEkTpukfdavCDtFbaLHuy7CA7Y5yw+Vh9zLPPexzNSjIpoiruJjWZZyGM8X3Zme
fQgcvbA8ICw++E/uJkgBK9I5U0496+pduO/jOV+bmfs45swsnCSubqac96ZdbaQa
96fXkNzCS4M=
=eoJz
-----END PGP SIGNATURE-----

--Sig_/FFeV1MpXiYzoSVZzQvXNjQR--
