From: NeilBrown <neilb@suse.de>
Subject: Re: Accesses to not yet running array
Date: Mon, 26 Aug 2013 17:53:07 +1000
Message-ID: <20130826175307.2240e492@notabene.brown>
References: <CAC9WiBgjEQxe_uymD6WW3Oj5Bm6aYD-RBD-8m3G40c1y3HUb0Q@mail.gmail.com>
	<20130821090634.413491d8@notabene.brown>
	<CAC9WiBiYYOjCVaa5tKVC7Lnkz7fcB2wHM0v2wdQUi=1Ufku5gA@mail.gmail.com>
	<CAC9WiBjBGD0J5vSe+q7y+UVGp2+++Ac++zeQ_=LUz9eQ-kCffA@mail.gmail.com>
	<5217B364.1070704@arcor.de>
	<20130826153021.6075fb8b@notabene.brown>
	<CAC9WiBiJ5vwZ7ngxv3CXZhbDTT7X_mtocVAtixRny427XwfFag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/S9PN8a2TT_7YrY=XAogfjdB"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBiJ5vwZ7ngxv3CXZhbDTT7X_mtocVAtixRny427XwfFag@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: Martin Wilck <mwilck@arcor.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/S9PN8a2TT_7YrY=XAogfjdB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 26 Aug 2013 09:30:04 +0200 Francis Moreau <francis.moro@gmail.com>
wrote:

> Hello Neil,
>=20
> On Mon, Aug 26, 2013 at 7:30 AM, NeilBrown <neilb@suse.de> wrote:
> > On Fri, 23 Aug 2013 21:09:24 +0200 Martin Wilck <mwilck@arcor.de> wrote:
> >
> >> On 08/23/2013 12:00 PM, Francis Moreau wrote:
> >>
> >> > [ adding Martin in CC since it seems related to DDF... ]
> >>
> >> I reproduced it here. The problem is that mdmon isn't running. Simply
> >> try running "mdmon /dev/md127", and the mount should proceed.
> >>
> >> You'd avoid the problem by running "mdadm -IR /dev/sda" in the first p=
lace.
> >>
> >> @Neil: This is unexpected, I think we need some code to start mdmon if
> >> necessary in Manage_run. I considered coming up with a patch, but you
> >> can do it much quicker, I think.
> >>
> >
> > I've changed Manage_run() to call the same code that "mdadm -IRs" call,=
 but
> > asking to just run the one array, not all arrays.
> > This should  do what is expected (I hope).
>=20
>=20
> Any chance to get the same fix for 3.2.x release ?

I think it would be a lot easier to just remove the "mdadm -R ..." calls.
Where exactly are they?  In some /etc/init.d script?

You probably want "mdadm -IRs" there.

NeilBrown

--Sig_/S9PN8a2TT_7YrY=XAogfjdB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUhsJYznsnt1WYoG5AQIxew/9FKRJ6Te1sQ2BgAHf57wY9rMtmDEySmNo
zJvF3SGBLd5HRYAmSyenQTiKj85hgMOnUWjdpEuoqt9UEkXWMUG1JbWNdjCApo78
NWEE+dsvQK9dsefNuzQwUNsps1cuztH/I4d1ETVogx0N/CY/vQqtpgynatpU06Ic
W0pHIXBwnbNzRPtycyzHcnNpZMqtaV62eL6+5lJJRiXhlACbjMl8bwDDeGpnTJrg
RE12eQlrUG0x1K1ubbxxjTD+Bnwf/bE4kCduXIhDi1pg9chNATUMinQZ5ipY/QwA
XMHz19olFKBCIe9BcKudv9jZbcorYDq7E6msp6iiKA25nwk4nKHo4iJT5ejBg3/t
BGh/FMWGbiXEf//6mKKEQ2Y5BWuwApIR44xGwpjKLH9G9SyaqJSePkH3m/bMJb7v
9BWwJlsZAc0mkTgjIsScI2OriOCNcLq9gGNGsgBSJDSWSD6B6DwmCFNYzYvJcgZb
ExNB7NaUvdcDrKutskS+JgAOcfjygjFEx3i9pMVtJHlarR4s3st4EvW9QhOMKq8a
FxKb97Osbj1awRojSpMFTjFqwUbcSiQfV5s0ncgXcmz9GwoQ7sDHhlmlH8JtrTge
SU/TcP8HPT/sgRRuUqk/26p7FgYKgTsifWyidvul8D7n8GkfQ1KpUA1/xdrJPihb
3rURC5EWFWA=
=WPGu
-----END PGP SIGNATURE-----

--Sig_/S9PN8a2TT_7YrY=XAogfjdB--
