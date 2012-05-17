From: NeilBrown <neilb@suse.de>
Subject: Re: Creating a 3-disk RAID6 array
Date: Thu, 17 May 2012 11:38:17 +1000
Message-ID: <20120517113817.7faf9c1e@notabene.brown>
References: <4FB4534A.5070608@volatilevoid.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/8dUHOPmtQGW1sNcKIWU+nXP"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FB4534A.5070608@volatilevoid.net>
Sender: linux-raid-owner@vger.kernel.org
To: Oliver Martin <oliver@volatilevoid.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/8dUHOPmtQGW1sNcKIWU+nXP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 17 May 2012 03:24:26 +0200 Oliver Martin <oliver@volatilevoid.net>
wrote:

> Hi,
>=20
> is there any specific reason why md refuses to create a RAID6 array with=
=20
> 3 disks? My (probably naive) understanding suggests it should be the=20
> same as a 3-disk RAID1, similar to a 2-disk RAID5.

I'll have to leave for for hpa to answer.  I've occasionally thought that
maybe it should be fixed, but it never seemed worth the effort.

>=20
> The reason I'm asking is that I currently have space on three disks for=20
> a new array, and would like to expand it when I add a fourth. I tried=20
> this scenario with a few loopback devices, but the only way to go from a=
=20
> 3-disk RAID1 to a 4-disk RAID6 seems to be via an intermediate 3-disk=20
> RAID5, requiring two reshapes. I'd like to avoid one of them, if at all=20
> possible.

Yes, not possible at present.
It might be as simple and finding the places that impose the limit and dele=
te
them...

NeilBrown



>=20
> Regards,
> Oliver
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/8dUHOPmtQGW1sNcKIWU+nXP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7RWiTnsnt1WYoG5AQKTQxAAmMfkpRgmybqiL0HVx42huQ7c2hfhYUs4
hZTOofr4kJRVqqiSo3HuSGNvcJc3xJWxY7pwTepAdPTjJbRvuAzNbMUdZrld9D0n
VfTgUrcTSHmUgRUaMqLGYI+arkXH9TZYKQ0f1mvEkNFYJ+7UQiBArCemUDdS/Y3x
YMlodiUuPifJ22gOKASMOPkOFofT4BBmYquJTWOXvNBP66t8C8EOJ9jxiGlb/2gY
5ZtRRX7NdES10BquCoei6t7A0wpWcpy6QyIDtnMV+EAhfE1v9iW2Bov7YsMRWlY8
CdnFIKW+uNBsKZtaFHlE8v4TowUsnqSxGPMjYKS74sH0Gu76eF2QlEIhoEvvzRlg
RV4sWpGi/JsqWqcZnvdpR6+dFR2ZvBFLWT028Hsnv/ZRW+IJy+xMsly8X1eeh7vu
VpqU9qDqxAXq2CfSq1NcmZoOrC2Rs3l5ujz1HQxEzybPD+hIcDj7UsJsNiQpcO2X
LgDr5VgDctp4fTPXX1Rg1ZvDLJds1JLHBGroAKWNff4LbU12tUf3yWnUtISmYnwV
WLQU7d2e/r62jrTwh8apzFqC2PcUEnGSME+d7Cz568h8IhIlB1V0E0I3Bu4RbcsD
RPgP3kLI2MleB+eZqhgWh9lMNHbvIq1h2BynQSDF9Go1oRPd66MiTEYq9e49sWXR
ljBHGpTS6UA=
=y0Wj
-----END PGP SIGNATURE-----

--Sig_/8dUHOPmtQGW1sNcKIWU+nXP--
