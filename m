From: NeilBrown <neilb@suse.com>
Subject: Re: Interesting mdadm quirk ...
Date: Mon, 09 Jan 2017 09:44:37 +1100
Message-ID: <87mvf1jhnu.fsf@notabene.neil.brown.name>
References: <5870EB3F.2060206@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5870EB3F.2060206@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Sun, Jan 08 2017, Wols Lists wrote:

> Just been doing some raid testing, and this happened ...
>
> linux-lfqf:/dev # mdadm md/parity
> md/parity: 31.97GiB raid5 3 devices, 0 spares. Use mdadm --detail for
> more detail.
> linux-lfqf:/dev # mdadm --stop md/parity
> mdadm: Cannot open md/parity
> linux-lfqf:/dev # mdadm --stop /dev/md/parity
> mdadm: stopped /dev/md/parity
>
> Weird - why can it successfully stop it when passed an absolute path,
> but not when passed a relative path? When I did the first variant, I
> used tab completion, and then when I edited it I really did edit it, not
> retype it, so I can't see any way the two arguments could refer to
> different objects.

If you give mdadm a name of an array that start with "/", it is assumed
to be a path name (usually in /dev).
If it doesn't start with "/", then it is an array name.  The might mean
different things in different contexts, I'm not 100% sure.
However, for --stop, it a name like you would find is /sys/block or
/proc/mdstat.
So "mdadm --stop md0" or "mdadm --stop md_parity" might do what you
want.
Probably the error message could be more useful here.

NeilBrown


>
> Oh - and
>
> mdadm --version
> mdadm - v3.4 - 28th January 2016
>
> ie stock SuSE leap 42.2
>
> Cheers,
> Wol
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhywNUACgkQOeye3VZi
gbmEYg/+KeN0fbULypTpIPn1gtvqJuJjxtWUBjK8kq8fx3vJ+NMhkj55kWt0V+i7
NzdBJkZ4sM9qWQJpvTz6Om91x5gmm4YEfxZUmiqb2t2B4EK6ECmR4MPqxXwroNdX
dPzumFd2n+ZT/BNgFP/VVX0ySylqD+2QjkaOEEUnu9dYYxzs8fGwbWyA1XVnX4Co
IsfBJ11huZ14GFgv24HFSvdwUNAA5ZztxmlgPoVnbUL1McQEDZEcXG09qRn7DMnU
skxfCJPX6eq5n9P5J119FuBMTlON0fPg4cVmsNwM7NmUKxpT9mLi8/iTfQitP/jo
wpDokm2TcSYvlz62oWsKSZ8PGwDCrSS8y9c4yfVVUjSPQOjA5+enit+kly3diiuR
xREr+PX4an8ZhfehSdydTNkHr01aRyk13sgm7uwMUXJVNFXkNTUfguTgD6YZDO5I
CzdOTjuZTch/LQZ14QZQXPwKh8+FWUfQynSM2uokQAM1Jwi1Vvr06uXTSNB23Qp2
A0DyYR5hl1W+6g+cPbFbgOIkypYKqYwfjkOht76TfNiAg+EhrP50YBeFir3DnkhS
Mb/sGnk+n2g7ouj2x9TytGNhH6dD+QyTPl1lwxLn05wg57+yNzaCGmBq6AaQA6iB
oVN0dFPlnP5hTMLA2hFfPBBGVzj3UxzduG7xKBl6dTBrLaIRdk0=
=aFqy
-----END PGP SIGNATURE-----
--=-=-=--
