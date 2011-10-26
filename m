From: NeilBrown <neilb@suse.de>
Subject: Re: with raid-6 any writes access all disks
Date: Thu, 27 Oct 2011 08:23:31 +1100
Message-ID: <20111027082331.01e1fc7a@notabene.brown>
References: <CAGtzr3c65BXDfWZq4ejKwCZv7hPZmdCpvQP17RgFS-Vrn2YF5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=Rb0b3yUeMwcJ+gN+/89buf"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGtzr3c65BXDfWZq4ejKwCZv7hPZmdCpvQP17RgFS-Vrn2YF5Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Pearson <kermit4@gmail.com>
Cc: linux-raid@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-raid.ids

--Sig_/=Rb0b3yUeMwcJ+gN+/89buf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 26 Oct 2011 16:01:19 -0500 Chris Pearson <kermit4@gmail.com> wrote:

> In 2.6.39.1, any writes to a raid-6 array cause all disks to be
> accessed.  Though I don't understand the math behind raid-6, I have
> tested on LSI cards that it is possible to only access 3 disks.

You are correct.  md/raid6 doesn't do the required maths.

i.e.  it always adds all data together to calculate the parity.
It never subtracts old data from the parity, then add new data.

This was a decision made by the original implementer (hpa) and no-one has
offered code to change it.

(yes, I review and accept patches :-)

NeilBrown

--Sig_/=Rb0b3yUeMwcJ+gN+/89buf
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTqh6Wjnsnt1WYoG5AQIlug//ZHEsz03yvJ3Fo6s/sjdD2adNLSaXas90
39nmhugMOsFpH1HGu2RU9QbH3DW/GByPsdWGsAaVJcDwHRr2JZlkDP7qYZ1hlhAY
t/H84LpYnqzSI0t6UPJDVV4Y0hb5hG3C5Ri0FJy5N8CG7vr1qvooW49lOzPqnJ8D
x2ZrMOfc0lOWc098SE1sHPIC74SSYROef2xZJYva3MkwWcbjIiXB+jf4abVy7mE6
Yr7gmB0hk8D08xdNSGYhCFv2KHFXh2L5oRaHXHla9+FUElsNbFIccwhYXRVqg0Bz
nr4Jzwuh4bPYy04h59oGETBJ7JMGnrdTijPj94xINRVpzA2thlYZQsfiNS2UB//3
XPj2Rn1PwT10vZ13GZsmD/RvQoZqaV8cxr4GuhwrZdUMc+2d3hYj9YSqQtvDLiRN
h0T7YD8vMDCXoUV7XoV5VKoN8t181puAXNPTRmSmavMIydp8lT9mwtUcq2E2SZwb
vvURqgFkaVh5/nb7nz2XzCX6tswGz8lN9vc4korPLfKlB4WhQSe517dzfjDGjelB
eef8Op58DXeOiLbCIFoiIUC1I7pz/l5VEijsThbRETHDt6Raqi86fKd+9D67OzZX
WIcH3ltGJ2GfHZRQ6yE0L4+vUcLT6Oj1fmooIhf7cn/zeCngUAXxH0Xi9Q+F5pvT
axY9msFckEE=
=nYzV
-----END PGP SIGNATURE-----

--Sig_/=Rb0b3yUeMwcJ+gN+/89buf--
