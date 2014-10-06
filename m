From: NeilBrown <neilb@suse.de>
Subject: Re: Cancelling not pausing array check
Date: Tue, 7 Oct 2014 07:59:44 +1100
Message-ID: <20141007075944.30be70ae@notabene.brown>
References: <CAAOsTSnYjW-r7VoOL0SiNhsdv5kn9DunrfD3izuLDzaHaBb56Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/P=n7lYr0=mZ1A9V8GIFpiMg"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAOsTSnYjW-r7VoOL0SiNhsdv5kn9DunrfD3izuLDzaHaBb56Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Patrik =?UTF-8?B?SG9ybsOtaw==?= <patrik@dsl.sk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/P=n7lYr0=mZ1A9V8GIFpiMg
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 6 Oct 2014 15:29:13 +0200 Patrik Horn=C3=ADk <patrik@dsl.sk> wrote:

> Hello,
>=20
> is it possible to cancel RAID 6 array check? echo check >
> /sys/block/mdX/md/sync_action apparently only pauses it and next check
> continuing from saved position. (I guess /sys/block/mdX/md/sync_min)
>=20
> I want to achieve two things:
>=20
> - Start check from the start of the array.
>=20
> - Be sure I can shutdown array without any ill effect because check
> was interrupted.
>=20
> I guess that position will be cleared when array is stopped and
> started again, but I dont want to guess and experiment... :)

Why ever not?  Guessing and experimenting is AWESOME.  We call it "Science".
I can understand that you might not want to experiment we real data, but
creating a few loop-back devices with "losetup", forming them into an array,
and experimenting on that can be very worthwhile.

NeilBrown


>=20
> Thanks.
>=20
> Best regards,
>=20
> Patrik
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/P=n7lYr0=mZ1A9V8GIFpiMg
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVDMCwDnsnt1WYoG5AQJrug//QsKLmepMwo42UkkD9yw19tdHXgLxVaRl
z0JmEjlr1l8chkMe+2cL+xD4+F1Gg3wtsyuXmmBZlHR4zwXPdCR/QhdGHgODa9Ig
Q2V6rNWSKUK3U2Rqzb/yowFL8YSQvwb46lf1jkBGY0ogWfZMp4p5KV5+/JSGqaK1
bNyjRqQlzd5zeQYEmGFuU+dlMMLUnMCTfCGP/T/ikHG6i9jEhGhvgdxrrEoAcepk
5xRCxHhz3fZEq+Sa7T5u5dgngpGuHCC1uuusYPQaJ/GxFh4TrJbCX2IYdSBK7G1X
EXoe0931IefXy01tNR2L/S+GgZGdJ/9XdXKUe2UJKFuBNLWJ614Z6gz2Anz+pV/2
FxHiF7GszQrD31Ts6pJYCofX9Mz8h/Jwy3grAP/J4beWVlMHTwutkh94borW9u9B
4pAq5co5zos2eVl/21Yv1mx0PKPEzWPuQTzXMjJPWuWt6bJxs+zD4wkkuioyhUX6
Wo7Cg9A6O7Rw5yJykVGfQM/ZEjKc4+tn1q1W/0mhzv1mVNVYIk6EJdE6h0+lzXXc
a6TZS9NQ9K1HSkdgoeMqnlMDFaoLU8YHDEIq0Pqh5kIl2kpgAQc0BRr4G489S0Kx
8isZ6h8jLAde05vdsVC6TwPHZU/6iVNbHbdcsF6+WXAY5Vi/4GYIzQ9NErP6il3q
pJT7xLPi5Lw=
=jsGd
-----END PGP SIGNATURE-----

--Sig_/P=n7lYr0=mZ1A9V8GIFpiMg--
