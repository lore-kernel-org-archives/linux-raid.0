From: Johannes Truschnigg <johannes@truschnigg.info>
Subject: Re: Is the LSI SAS9211-8i still the go to HBA?
Date: Thu, 28 Sep 2017 10:52:56 +0200
Message-ID: <20170928085255.i6ogmdyf6xwic5kv@vault.lan>
References: <1d014bd9-7946-ba3e-f5fb-f64a92ccc769@eyal.emu.id.au>
 <77d0cd80-40b3-acb2-ba8a-e3650ad1b734@aei.mpg.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="lbdfpxygdljfhf5m"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <77d0cd80-40b3-acb2-ba8a-e3650ad1b734@aei.mpg.de>
Sender: linux-raid-owner@vger.kernel.org
To: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
Cc: Eyal Lebedinsky <eyal@eyal.emu.id.au>, list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--lbdfpxygdljfhf5m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 28, 2017 at 10:40:43AM +0200, Carsten Aulbert wrote:
> Hi
>=20
> On 09/28/17 10:34, Eyal Lebedinsky wrote:
> > [...]
> > So, is there another candidate for 8 way HBA for use with linux software
> > raid?
>=20
> We operate a couple of SAS3008 based cards from Broadcom formerly known
> as Avago formerly known as LSI ;)
>=20
> E.g. the 9300-8i card which we flashed ourselves from IR to IT mode work
> quite nicely without any complain at the moment.

Same here - just make sure to flash a recent-ish firmware image. The 3008 w=
as
unusable garbage before the (iirc) "P8" release for us.

--=20
with best regards:
- Johannes Truschnigg ( johannes@truschnigg.info )

www:   https://johannes.truschnigg.info/
phone: +43 650 2 133337
xmpp:  johannes@truschnigg.info

Please do not bother me with HTML-email or attachments. Thank you.

--lbdfpxygdljfhf5m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEGu9IhkI+7/aKLUWF95W3jMsYfLUFAlnMuGMACgkQ95W3jMsY
fLUgthAAuFlOujkD15tqg6IA1iWAUE4f2rLCpqAgW75DOarptl+I8d6ny0rAl87G
/xuWOJipryVSS4nJ2I7x3DLUU3R3FskHFnlh8FGgWg5wbCLsMXEC4EmY/5Fbel/w
JavilMAk6qyJtKfzIABExeQm44//QgdOD6i4J7GwxtB0JKyyUNlHGCS4MqoRGDRQ
ABnnCb8jIwdP9lJwFhrGciHZjUTc3DZJAe6EDR7IWsWmfAnBZvjeMO5M0WVp+mCo
qfoEvMeKx3B5r9os8nMVCHAWWmVCbFO5A3uzmLeamR+ll//URQwkS4v0o6IDHKHe
2/v9bOAxUddMdCSRDdy+j4W3DVqGnK4OjAUkJSQ/ZnyKYb+CGjsuqGY1Omz2lz/2
HjvnPmkxBo09KIyFPVs5c7h7bqwBu2WLIQYUbb4F1nbupMYr70E6dOY7UKdyvyPu
wFJFE/kXwttKf+bYoR7BrRhh6NUhDnqRw2vuuJ35wAvIqpA/MfZF04f/AUJAGEiB
7L6EUy4QXEz8mvUmwO0IYRzr/0Z1kwC8q6BymdFmXgMI1pCZy02A5m1NS/7pQSPc
FBoCvcZITK9YIEkxmOSM6FgpLzitmIjQiHjuWJleqNSXGMh0DjyqGNzA5hQ3ZUQs
tsOf2SVWrUldou9nf9WCj5LmPdDDFC+ba60fCEWl11oEPqM6DlA=
=VZkO
-----END PGP SIGNATURE-----

--lbdfpxygdljfhf5m--
