From: NeilBrown <neilb@suse.de>
Subject: Re: Thought about delayed sync
Date: Mon, 10 Oct 2011 09:12:36 +1100
Message-ID: <20111010091236.5bcbacd8@notabene.brown>
References: <20111008180309.GA14979@animx.eu.org>
	<20111009093641.4cfa79c9@notabene.brown>
	<20111009133216.Horde.3I8nXJk8pphOkYZAj4hRFEg@cakebox.homeunix.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kwRQzKrcwcqeZwvOjUJy8xV"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111009133216.Horde.3I8nXJk8pphOkYZAj4hRFEg@cakebox.homeunix.net>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander =?ISO-8859-1?B?S/xobg==?= <alexander.kuehn@nagilum.de>
Cc: Wakko Warner <wakko@animx.eu.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/kwRQzKrcwcqeZwvOjUJy8xV
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sun, 09 Oct 2011 13:32:16 +0200 Alexander K=FChn
<alexander.kuehn@nagilum.de> wrote:

>=20
> Zitat von NeilBrown <neilb@suse.de>:
>=20
> >  http://neil.brown.name/blog/20110216044002#5
>=20
> Using one bit per stripe looks like the natural choice to me, no?

It might seem natural, but that doesn't mean it is good.

My rule-of-thumb is that each bit should correspond to about one second of
resync time.  So that is probably 50-100MB these days.
So a 4TB drive would have 40,000-80,000 bits or be 5KB to 10KB in size.
I would probably rather a 4KB bitmap, so each bit could correspond to 2-3
seconds which is probably fine.
That might line up with the stripe size, or it might not.  And whether is
does or not is largely irrelevant to the code.

NeilBrown

--Sig_/kwRQzKrcwcqeZwvOjUJy8xV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTpIcXTnsnt1WYoG5AQK6EA//UmC2wKaqpl0wKbE0rvuW7AASMosBTD9P
6E1s9bVusvPKhPZekR6A0lKzBHVAYIIYmxrVqMpW2cwE7zg7NARkpkaKq8IwiN3O
ZQxSiczvh8urPrY+wMBCFvSbsI02XpY+cC8XeE+ZrGGr6YA4USi54RxSzjk6Yxl0
kKIFP8WDtzPDybYbxyxoe2RKg4RgAD4ks4bLCuYoElngFU17QFWJuWe0nw7puBOt
JBT8v+ScsSzLGaQWnH2+rAzoMGvp909VQqVSo/HOa7VSPeQ0qLnCarxNwuyUH5tI
JaKUPEDxxG6s/1UjcDQzqAq9mHcy0ZTp+NFWoHa8ulZ5bwZQjhiSG8/q5kfZOYik
E/KPw/2wkNkx7jILO4VVsj1/mNK7fqtRXueqFad+ovABGqqMose/n5oV9s4yU6w4
/BD5GvFehnl7lsTh9377bf5B9NLIKvvjm4MIcCJAXBS+EoSDp1AK8+U6oMpUcwRt
MNxyRCnTvcgtBOT4bFcTFzfLxI2FBKw+Q218sBJA/ZEDUxVkWREpM6Ah6nEcuSAF
Zsaz/6teFJu8x0DhMypQQwn7a/4LsMemj3NxZFobGvO/u+kwIv0RSCmHYcvQRsii
7s+U3Wl44COShuEkb9l0fe7Axiyfi7fG0xcSfqggDvJKA2pp+aBxmTwvifgCWw6m
iU74nlW55tg=
=kXUO
-----END PGP SIGNATURE-----

--Sig_/kwRQzKrcwcqeZwvOjUJy8xV--
