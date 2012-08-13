From: NeilBrown <neilb@suse.de>
Subject: Re: Device Unusable At Startup
Date: Mon, 13 Aug 2012 10:20:20 +1000
Message-ID: <20120813102020.172d3a93@notabene.brown>
References: <CACO8viqZO9bbdYtZMT3E0oMfWUjAzps1uNq7rBm419eXtt6bCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/zt/NDj5Jbw=jV9OYVvfW.P="; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACO8viqZO9bbdYtZMT3E0oMfWUjAzps1uNq7rBm419eXtt6bCg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jake Thomas <thomasj10@georgefox.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/zt/NDj5Jbw=jV9OYVvfW.P=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 12 Aug 2012 16:59:25 -0700 Jake Thomas <thomasj10@georgefox.edu>
wrote:

> sudo mdadm --create /dev/answers --level=3D1 --raid-devices=3D2
> /dev/blog,/dev/linux-raid@vger.kernel.org

;-)

>=20
> Thanks for the responses Neil!
>=20
>    I did try the following kernel parameter:
>=20
> md-mod.start_dirty_degraded=3D1
>=20
>    Does my kernel simply not honor that parameter? I'll try and look
> into my initial ramdisk and see some of these scripts you're talking
> about.

That parameter is for a different issue.  Starting a RAID5 or RAID6 when it
is dirty and degraded can cause data loss, so it is not done by default.

In your situation the array is not dirty and it isn't RAID5 or RAID6, so th=
at
doesn't apply.

NeilBrown

--Sig_/zt/NDj5Jbw=jV9OYVvfW.P=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUChIRDnsnt1WYoG5AQI3VRAAxMasVZkenMuueKoepbL/4nrhO9d5IOF6
nZT/U9Xeckz2WLAOVjPk2ZP89DaAmTDp+5MKf5mqNfh53PQYpAWL3h8gq7THmgpe
0SamA+rTZQdgtEDRcUSmENHZKkG7sPiU47PwRHwJO6Z1PmWFkdDHVskTpLzqQbRY
h+vULL9f8eX2km9sR++V8ipYkCKeGVrqU9C/aV6Huj2nczfpm/YyqlgEcEjhDv3B
mW5xJJYFuL5Ge4ERQq7pQ20P4Wo0kDCAy4DtPxExOd6ucyhsKPri+w4tm8ZDuhyL
mUq7v1MK8dKjo1l+PYGtezixC0SvkeWKHECUfjasoMjC5iEIAD8q5TVOwiFiQ4pJ
gtP3XptKl7vB4zw3HpPWfORq6Ur4T4++dzNmhzfR7fvRWqexRyWvJVQTUCMQL1f8
goK/EbzxAurhOiuqHUD1S1LVHgtL9+apZyX1APZyrlz+5kSr8uI7sDjPGuADK21j
FBA9lzbfJ5MiYiQcP3laBV6pbhVOcEWjTDWY+cieimNE8HxssjLKbr6BJBZlRv59
1PwIUdbch6jOy7z4MxHgPa//hbkAzaIvJ9odTxKFIgdw1bgR1R9pTXH3UGDnjxoV
xv/WS7/l/CZHS/a4dHBE8qfu5i5u4z6ASNGrsGzZN/QXkUhwWDmDpg0p+jLqN0R7
dphduGaXfUU=
=66HO
-----END PGP SIGNATURE-----

--Sig_/zt/NDj5Jbw=jV9OYVvfW.P=--
