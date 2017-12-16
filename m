From: NeilBrown <neilb@suse.com>
Subject: Re: Is there any lazy initialization mechanism in linux-raid?
Date: Sat, 16 Dec 2017 15:22:47 +1100
Message-ID: <87k1xnmhd4.fsf@notabene.neil.brown.name>
References: <46a50eb1-7836-9ec5-109a-59d223708547@bwstor.com.cn>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46a50eb1-7836-9ec5-109a-59d223708547@bwstor.com.cn>
Sender: linux-raid-owner@vger.kernel.org
To: guomingyang <guomingyang@bwstor.com.cn>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 15 2017, guomingyang wrote:

> Hi all:
>
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Today's disk is becoming larger and large=
r, and the recovery time=20
> is becoming longer. I'm thinking about a lazy initialization mechanism=20
> in linux raid5 to speed up recovery, which contains an un-initializing=20
> bitmap and a backend thread for initializing stripes lazily only after a=
=20
> stripe is write. The major difference is as follows:
>
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (1)When a raid4 or raid5 device is create=
d, we don't recovery a=20
> disk as usual, instead we just set all the bit in un-initialize bitmap.
>
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (2)When a write happens and the correspon=
ding un-initializing bit=20
> is set, we must first clean the bit, then wake up the backend thread to=20
> resync the stripe, and only do RCW in corresponding stripe before the=20
> resync is done.
>
>  =C2=A0 =C2=A0=C2=A0 The major advantage of this mechanism is that when a=
 disk is=20
> replaced, we can only recovery the stripes which have been initialized,=20
> so as to speed up recovery.
>
>  =C2=A0=C2=A0=C2=A0=C2=A0 Does linux-raid have similar mechanism today? O=
r is there anyone=20
> who has already working on similar mechanism?
>

No, linux-raid doesn't support this.
I don't know of anyone working on this.
I wrote about the idea nearly 7 years ago

   http://neil.brown.name/blog/20110216044002#5

but never got around to doing anything.  It probably wouldn't be too
hard if someone wanted it enough to put in some effort.

NeilBrown


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlo0n5cACgkQOeye3VZi
gbk3ug/6At8DWn5LcCmpyvQKhvAdo0koFNOkssWpz5FYHQiR58/JpVBvgVAAFV/O
a2VZmsOz0oPsh1861pC9Rg82A0qEMLyBtp1p+8dvF1kzIJ/1kLX6VySAZIirT9ld
+EGse8Yp2iIY+qTvtiGOV0Wo9ARTnjoF00KXUkQ6orNDwJS/IfGxMenpPpjXPYI3
Rfs3qxwCFGdDg9ehsYbYOi3ufQxJqblKNCLdv6h5UC79AP6Belr3iS/q3OjsMwyU
CWOP3g+i1x7CAhqZSf/WNlUv4iLEW8YQjuyYDrg2md6WLxR6eY9/JqMBJNJFLiva
T8MMJySCoWYCe1O8mSfeG97+Xe1CBvQtMRz5qB6sT43sL9tdT6V3hFJNw/HCFMIE
HCTDn86KvYEBpRHfZqx/VxLMR7HYGDXbj7MHmTtu3K1dsKBaKDZh6gfAgi3jquN1
W4ZF2E+EJCHZMEugDW8IHXiEQMHBLwFQW4rO7wSTiMMka8pjnk0byfPdvYh6xACL
IrLENvW+9Ylgkc5q0jPTWr/4wfDsppuNYa8LKMzOHBxI79m0IhwpPPL+OoZ1xriu
YStdh38qlxkRByLjZv5T0Bfl4/oHl3QrsfpVr7+UNnK8oZx42g6BmhZCX4T8iONM
GAETDzgt0WBqFixKKNxGtB0KDNFU8leDE/KWgq5deSrD5vUb8ko=
=2RAv
-----END PGP SIGNATURE-----
--=-=-=--
