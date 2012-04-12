From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH][Trivial] mdadm man page: fix typo
Date: Thu, 12 Apr 2012 12:44:27 +1000
Message-ID: <20120412124427.7ecb8ee2@notabene.brown>
References: <CAGqmV7ovw0fW2HE0s69Ci7Y15YWGpnvESfW=rt=rEbp0kWPp_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/KnePmJZotHy=HQ6b56eOM/k"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGqmV7ovw0fW2HE0s69Ci7Y15YWGpnvESfW=rt=rEbp0kWPp_w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/KnePmJZotHy=HQ6b56eOM/k
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 12 Apr 2012 06:11:19 +0400 CoolCold <coolthecold@gmail.com> wrote:

> manpage for mdadm(8) contains typo - missing "d" at the end of "describe"=
 word.
>=20
> Signed-off-by: Roman Ovchinnikov <coolthecold@gmail.com>
> ---
>  mdadm.8.in |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/mdadm.8.in b/mdadm.8.in
> index 4f06a88..bddecd9 100644
> --- a/mdadm.8.in
> +++ b/mdadm.8.in
> @@ -1166,7 +1166,7 @@ will report failure if these specifiers didn't
> find any match.
>  .BR \-a ", " \-\-add
>  hot-add listed devices.
>  If a device appears to have recently been part of the array
> -(possibly it failed or was removed) the device is re\-added as describe
> +(possibly it failed or was removed) the device is re\-added as described
>  in the next point.
>  If that fails or the device was never part of the array, the device is
>  added as a hot-spare.
> --
> 1.7.2.5
> 1.7.2.5
>=20
>=20

Thanks.
Patch was slightly malformed ("find any match" should have been on end of
previous line) but I fixed that and applied.

NeilBrown

--Sig_/KnePmJZotHy=HQ6b56eOM/k
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT4ZBiznsnt1WYoG5AQLecQ//R5w3UK2jF7oed8gE3gNtr/3IBhb7Wcef
wFie/8Y/bFkg9Q0E8GQ7guccmecSEThlJKEmEp3JBU35sUDwE+9p0Vi9y9buzNiw
Suh9JUwANk2/FpRtemDETpEYLpvooMoHLOEn2zY1pP7J9F6nJn6MNB4zf+sA2v4W
4Dcb9hm/RYGXYJFLM4DX25pZ5g2K97kx7pzp4nQKEevkEm3C7zNvvP/fsljJmcXH
egDI3Iyj3l0LdQZ2NGJod3eAGwRD4LkneMgbWTA+TAF39VrNbTZqZOx6ZpdaAtYL
QVJajPrVDTv/oaTcwVKrr/0+QI2Fr7ebMzo7SyDXg6unrUsasT108kuoL2+NWKu2
M4dZ9G19UJytcq8/UGgVGnvxyvMwpViPSg8ExMv33bP5ZGBAHHWCYaf7jGe2cGyN
12860+BB5Slt9iU0COCbSPo325ttq4eMAMDcaiypQGvhgcRraoywi1RyKBfwtfim
/V1bBAgMq3imo/is4jG1wGBA8WSDnqbzWt6pqPAvBoqUDpFrAAZvDLFAADCae5L6
/RAVpGaWWTR6SgIQ4A0yt9wjf6Ot8Yb3Stz2WFIjHEwyMnkkCkv6Ow5Wkk/fncdX
R8eMQFb2FDH5Q9NH8t/g4oliHBJkINDuFusuT7U40Xeo3J38Oi4RurHYS+lKeOXK
P71LPp1F6RM=
=p28P
-----END PGP SIGNATURE-----

--Sig_/KnePmJZotHy=HQ6b56eOM/k--
