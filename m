From: NeilBrown <neilb@suse.de>
Subject: Re: Can a running MD array name change?
Date: Fri, 25 Oct 2013 18:38:44 +1100
Message-ID: <20131025183844.2e5c8fec@notabene.brown>
References: <l4d4vb$vgk$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/580a.5R_6ovh8MMxF1_D/vM"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <l4d4vb$vgk$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ian Pilcher <arequipeno@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/580a.5R_6ovh8MMxF1_D/vM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 25 Oct 2013 02:01:07 -0500 Ian Pilcher <arequipeno@gmail.com> wrote:

> I'm still trying to figure out if there is any way that the kernel name
> of an MD RAID array (as shown in /proc/mdstat) can change while the
> array is running.

No.  The name that appears in /proc/mdstat can not change while an array is
active.  Nor will this ever be possible (at least as long as I have any say
in the matter).

Hope that helps.

NeilBrown

>=20
> See http://article.gmane.org/gmane.linux.raid/44417 for a fairly
> thorough explanation of why this is important to me.
>=20
> Any insight greatly appreciated.
>=20
> Thanks!
>=20


--Sig_/580a.5R_6ovh8MMxF1_D/vM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUmogBDnsnt1WYoG5AQIlnQ//chdZdScXo4kx2JH2YAxJ4mKgDTWGapxq
51Sk+uw75xawz+K8fdYMCkkIVObyxjbAC022/+qhCS4nRo09DRW30ri9a8ZUTqP8
geF6UIIWrqEbLGsya1/hAtMmBcUE1i+3sXqIqznQp7ZRGFCspI69w2NMYGhC5L2D
Kpi7T8pDPq0bfra21Ci2Fm/q7UG5DKYWTWPU69Xxchx3zn/5jQfK2mgaKsl/emjs
df2pDYN5G7V09u7W0Tw52imWbZ6ac2OuRyl8nz1ecWvj/ZUXI7DIJ+TjTzk7Fnv2
uXFohfifrSpqrc9cYaeaztdcjLjvNlw291Ec4Ezx/YFmdSVGtFszU8dcAC5Vh4M+
Q7CcseHHXjqgmSw7MyKd9libz5lYgAHMARDV8a7J//uKaEjvxPmn6pM7ABSMDxdT
LFvNlNuAVAYBBMyRFQz3xxSksA9HhaUL7UwLlf4J6CLw0gkoS16Q0mWkvBOdMX4u
Gudx3nFC5dRR8Agp0MwW3oKi2/Ylvsm7GeG+5eGB84s7r0GTrNFi6vM2U5WzFnBq
PhORpAd6bwamWrH5L7A0lDrs1otylyfWAAozjRGmRPz3PUj5J5tDfz/PUhsEhYfe
EgE6d7Kp4mWHnrXESHBCf1YsSj8GQWm6DyFb33+5UvS4maNlZpQHDa5KB6M1YJ8Q
wW5T6NDVgv8=
=6Bus
-----END PGP SIGNATURE-----

--Sig_/580a.5R_6ovh8MMxF1_D/vM--
