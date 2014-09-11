From: NeilBrown <neilb@suse.de>
Subject: Re: [patch v2 0/6] raid5: automatically batch adjacent full stripe
 write
Date: Thu, 11 Sep 2014 17:15:25 +1000
Message-ID: <20140911171525.4ec2a88d@notabene.brown>
References: <20140910124009.810771309@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/IKQ6l6pjoJBwmiu._.C+qQ5"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140910124009.810771309@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/IKQ6l6pjoJBwmiu._.C+qQ5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 10 Sep 2014 20:40:09 +0800 shli@kernel.org wrote:

> This is the 2nd attempt to make adjacent full stripe write together. The =
main
> change against v1 is how to detect if stripes can be batched. Also some b=
ugs
> are fixed.
>=20

Thanks a lot for this - it looks quite good.  I've read through most of it
and don't see anything worth mentioning.... except maybe to wonder why
to_addr_page() has an unused 'sh' argument.  Maybe I'll just remove that(?).

I've pushed it you the 'devel' branch of my md git tree.  I'll try to do so=
me
testing of my own next week.

Thanks,
NeilBrown

--Sig_/IKQ6l6pjoJBwmiu._.C+qQ5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVBFMDTnsnt1WYoG5AQIMRw//cXKD8JEbS4gbKD5gTpyfF2EDxZdniBiB
DlJRJnOC+fWjLUakHHKuu77vDOTqwRFFI6YLS0P6MkUgIfd1t82ojK0jGpefHuby
0Qi6Jqi2+72AhR6jV91wk9+TzK63tlrPc6ueCRJvrCp4H1gdeeUfzsAi51s11w7h
0igXat/HmOmLskHVEMwoW53eqEUMPAEH8GxJVLtAxlWOQHNk2aj8goW6bxLciN6b
ePG4259kQbE/b/Ug+Z1jv/lxftXdTXfk+womCf1gLn8M/NH75KHJjCS/vunLyciu
d69x6dHnirZlf24E7I4/uuoLWtHFYiOWQI3HKYOc8Ij7fX9tveSXMirPorSzK3JW
qUyOYKYrAmy7JxNk1aHLYgqssDtmkwCtUiarb+yDCZetermg3QCCh6tIqXssXnm5
/PZI2i+tyb2JDyVPdXkWribpR+2zbwNXzvwFPkpHO0lWcdlxSrdzDdLyUk247HZX
kGZoDLaxO35l+JRnfoGYalWYnsOpEMf/nOEtuVpDV5j37aweFWX1lKRNMQWETJDu
uwGnIvweUAwPH50l5Kjco1ONsbSRvGyJn9opNiqm84lXlCH9gFcM/2CpBvLlo/xb
w8O09DFW9MzA+vEHyn6LAqpx0osTKF0O2HsmLW+kFa+pykGtZbbXrPJZkIhL8YRx
45C/CwqQ1ZQ=
=xyy1
-----END PGP SIGNATURE-----

--Sig_/IKQ6l6pjoJBwmiu._.C+qQ5--
