From: NeilBrown <neilb@suse.de>
Subject: Re: DDF/RAID10 patch series
Date: Thu, 4 Jul 2013 20:10:52 +1000
Message-ID: <20130704201052.606792ad@notabene.brown>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/k3THZdNLi4l+NmaZpjj8y0_"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: mwilck@arcor.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/k3THZdNLi4l+NmaZpjj8y0_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed,  3 Jul 2013 22:27:40 +0200 mwilck@arcor.de wrote:

> This is the DDF/RAID10 patch series I announced.
>=20
> The whole patch set is aimed at making --Create work with DDF/RAID10.
> When --Create eventually works, RAID10 can be added to the DDF
> regression test.
>=20
> With this patch set, DDF is still far from the level of functionality
> present in IMSM, but getting a little closer.
>=20
> The patch set also includes some cleanup patches and debug code which
> I needed to find the bugs in earlier versions, and which might be useful
> later as well.
>=20
> Please review and test.

Thanks Martin.  I hope to look over these Monday next week.

NeilBrown


--Sig_/k3THZdNLi4l+NmaZpjj8y0_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUdVKLDnsnt1WYoG5AQJNtg//Y3tAsruJgLCmj58ATI2bNS7tAw6fCcdj
+7w2OVN0md7WL9+ExZzAgUP1mzBx/wzPiqgi9zz1lnOkZZOsi8e/5nzwsKcrH1Lr
JvTy3QUu4UHgHbKazx6c+XImS8tocZ+KOf3qW4f3nj8VWyZ1MhRN60G6x/s4Ps8E
EWHrL7u7Iob5wJfuope71+VNfJDShTl9t7L3aMU1EX0n6zrt7z++SoBjLLRes+Ay
Td1e4ZvblxEuIAv7c1CpLmghWCpt9Ugy+1vuuhwI4nn105jltEuOgAhvyZhEtnjz
858vd1KsdIfMauko9B6GXKfGXKF48SsJ/5uFo3gSFI0FvoYagzPlYtpT9te1IwSm
GYECp+A4iqpQZEYvoo74jaGQCx4B+CGVZQ58AjwRr0QHAJN/Q7LC5Gsx+HPHogAd
lyNNaU4Tl8lv5ryqJy6YCyC4hd4b3oVu2KMVGGP2833Pt5wJZIR71aQK96unxmTx
K/uACPiiHAQo4Ky+mB96/LiMPDp8K/BEo6px6OJSOJBKz1khKnipJe6OgEdakDm/
MkFcy0y/SqqSJqBB4B5bHUk9+ukkultLL3xl9xU4qJlgKqxVyYfcB5smzttTZo63
ZlikADWZ7SBp5qrpuJ5yfctD4l3ohUiJ/gWlTkdVP3xgXNHprb//11nZryXzwd9p
mdQqdGQkza4=
=72cw
-----END PGP SIGNATURE-----

--Sig_/k3THZdNLi4l+NmaZpjj8y0_--
