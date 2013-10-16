From: NeilBrown <neilb@suse.de>
Subject: Re: crypto/xor.c and lib/raid6 to improve raid5/6 performance?
Date: Wed, 16 Oct 2013 17:28:25 +1100
Message-ID: <20131016172825.3a06fe99@notabene.brown>
References: <CAP7cwtumKJ5t3cb0bACaVtGVKXT2jibzWzdjqY2Si=uNjDg1KQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/B_YKNxbF6OUv/QIBYSBACu3"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAP7cwtumKJ5t3cb0bACaVtGVKXT2jibzWzdjqY2Si=uNjDg1KQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: xxiao <xiaoxianghua@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/B_YKNxbF6OUv/QIBYSBACu3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 11 Oct 2013 15:20:32 -0500 xxiao <xiaoxianghua@gmail.com> wrote:

> I'm looking for ways to speed up RAID calculations(e.g XOR for RAID5) plus
> offloading them from CPU as much as possible. During kernel boot up I
> noticed two outputs:
>=20
> crypto/xor.c:
> xor: measuring software checksum speed
>    8regs     :  3379.000 MB/sec
>    8regs_prefetch:  2969.000 MB/sec
>    32regs    :  3398.000 MB/sec
>    32regs_prefetch:  3054.000 MB/sec
> xor: using function: 32regs (3398.000 MB/sec)
>=20
> lib/raid6:
> raid6: altivecx1  1470 MB/s
> raid6: altivecx2  1820 MB/s
> raid6: altivecx4  2756 MB/s
> raid6: altivecx8  2874 MB/s
> raid6: int64x1    480 MB/s
> raid6: int64x2    832 MB/s
> raid6: int64x4   1221 MB/s
> raid6: int64x8   1160 MB/s
> raid6: using algorithm altivecx8 (2874 MB/s)
> raid6: using intx1 recovery algorithm
>=20
> However I'm unclear how the md drivers(especially RAID5, and/or RAID6) can
> benefit from these code, can I use them to accelerate RAID5/6's XOR with
> these code somehow?
>=20

RAID5 and RAID6 already use exactly this code to perform xor and RAID6
calculations.

If a platform has some sort of co-processor which can do these calculations,
md can certainly use that too.
Some of the relevant code is in "linux/crypto/async_tx"
Other code is elsewhere in the tree. looks for "adma" for "advanced
DMA" in file names.

NeilBrown

--Sig_/B_YKNxbF6OUv/QIBYSBACu3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUl4yCTnsnt1WYoG5AQKoTA//SAvNRfIZyvi3p3vjRTKaiGz6xtcW6Oba
PE7KK31M7A0pTPfAgQcn9HbKXQGLRkIzQrL0uyLBXnrKmdeWseF9BnsRfzrc1qOY
6omzDETU5xm6gzK4/LA/MLMFtxP03RT5uCpQTP++xbSk+7M+E2IbrVt5iHNZ3v7L
NVs3VItcnL2+cf+De1Ob3bi+AqZWqdvEVJ3vOe0Efqg50b41tOooOBqJVfunB5KL
raMZfFbMxNdkotprazn+5LjMC9+dLHoAqfhvLp4dCdhBvn8m9SXr7JH9xSBLMjGe
e5V+3wLrHuI/M+6VGAgJDHPs8MCu/iv6BQx5UxO0yPxRz+695JJk5gRqD5yH8YjS
0s6OMer9XYa3qPCON4fJ27r6UPB3cjfSqCkG1j62NV7J6PSBiI1RnzP99ZK9Zy1W
ZsJMgHKl6NsfpsF9d4VrpnZmKkziR3P+d4ern7UyxVeBAwJUDp9HncVnLeCcoMr4
S82j2RdyVqUo9s8a8to4PnqtBynmJczPIGKt8j4+UOx+nzrx+/BuLF98E25n1E6L
6WWARld99JlnYvAVQNZJgk1ipBtF1Eh62qxkJAFzEMvXfJWZd14WafWog0E0Xl3O
yhicBiIC0GWq0qh08qx2xkdXVzZooRKlofYXWEg2tVUaLj7pFEYmZQFfr/ZuY7w8
ne3hEshv9hU=
=a+FZ
-----END PGP SIGNATURE-----

--Sig_/B_YKNxbF6OUv/QIBYSBACu3--
