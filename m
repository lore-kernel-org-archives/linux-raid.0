From: NeilBrown <neilb@suse.com>
Subject: Re: mdadm segfault with incremental
Date: Thu, 26 Oct 2017 09:00:10 +1100
Message-ID: <871slqevmd.fsf@notabene.neil.brown.name>
References: <CAJO99Tk=at4gXNgEHKmq1=iDip+vt2LT-T8d+FSQYGJquH5C2g@mail.gmail.com> <87mv4iehop.fsf@notabene.neil.brown.name> <CAJO99Tnd0dB-90yqrhVseENpsCp4b9tDAFkNSbr+NzGgxT68qA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJO99Tnd0dB-90yqrhVseENpsCp4b9tDAFkNSbr+NzGgxT68qA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?utf-8?Q?Bj=C3=B8rnar?= Ness <bjornar.ness@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 24 2017, Bj=C3=B8rnar Ness wrote:

> Hello, Neil.
>
> This patch seems to solve the issues I am experiencing. So fine to apply.
>

Thanks for testing and confirming.  I'll turn it into a proper patch and
send it upstream. There might be other places where validate_geometry
should be used instead of avail_size.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnxCWsACgkQOeye3VZi
gblFqw//XfVfBlHUlgLURsnQ9VbiiXcOxZO2V/cG695FLVvGmRomOjp5fdA/P9nG
kvEkL5i9i/UZFPqeoJ/qUd31GKNxuYkLhKYchen4dH//PkewiaKX4IGHiUq/lo/D
lA855tTxivB1m5NKSoNLfY6nJz4Z4lrGvMPdZYz6W5pc4qFwhCkkMPbNUZy5xTUw
W/mEwEQW7RqANx7bKJwQ8scy4pFMRbOCI7d+I07tPLCzmx7FxikdUuujLN6HAcwB
FhHS9ok/jnkjaoU7ZjnYhwjAVEkldhbp/Ed3E90qJuUn2GmFbYLLqWxtPEB/o0+q
tJtccb1IlX/z03iz1LQ0s0VKgIHS28sHFY5dj4B02UhtaYGeH8956d5ZuhAzAgPZ
5N+ccwwyw9h/1L2b4MU6NfuOOL3+l8sjjNzhUWVwYWk3BLUilywfsb9wFlyCI0AD
elMgx5W3eGuYG7nTQ0C54JGMX7W49V/M4u/K8yXWQPYa00VBVIxSktK+ydP7wM9y
p19td3xId5HKmAF71Y8F70pdyKr6QFBrJmuZjHvdzvirgYT1C9JPOV7QAebiofca
TUcDIJOZb0Q63UN66Oi8mCbb5YVRGSfM4koZp4IKCCQ+DUea/3AZwgI1rGXB0yA2
8+3G3vq1KJ34ZgFkDcqF3audLHtLdObC6Svmteh/paCGWR2D+sQ=
=DWNs
-----END PGP SIGNATURE-----
--=-=-=--
