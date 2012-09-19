From: NeilBrown <neilb@suse.de>
Subject: Re: Wrong array size detected after reboot
Date: Thu, 20 Sep 2012 09:11:09 +1000
Message-ID: <20120920091109.5d950820@notabene.brown>
References: <CAFEwywaeGevnDMu7Do_wK+_Jgtyd0vman0804C2LyqbyzcJ9Sw@mail.gmail.com>
	<504C0462.2000609@turmel.org>
	<20120910091352.38dfdc20@notabene.brown>
	<CAFEwywaGN3cvXVAJxsWuc1-j0mfeLtKs_iqNznFQN8QA7JO8qQ@mail.gmail.com>
	<20120919114202.0ad6355b@notabene.brown>
	<CAFEwywbuH1689UStqoGOsvAh_X9afCpojKouY=Po5sXFGDFutw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/KO2RVY/NFyrKqJRHn/P5h6Z"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFEwywbuH1689UStqoGOsvAh_X9afCpojKouY=Po5sXFGDFutw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Markus Irle <tha.bear@gmail.com>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/KO2RVY/NFyrKqJRHn/P5h6Z
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 19 Sep 2012 20:34:11 +0200 Markus Irle <tha.bear@gmail.com> wrote:

> Hi Neal,
>=20
> On Wed, Sep 19, 2012 at 3:42 AM, NeilBrown <neilb@suse.de> wrote:
> > On Sun, 16 Sep 2012 01:32:06 +0200 Markus Irle <tha.bear@gmail.com> wro=
te:
> >
> >> I'm running 3.2 (3.2.0-31-generic, latest in current Ubuntu release 12=
.04) now.
> >
> > Sorry, I got that wrong.
> > That commit is the one that introduced the bug.
> >
> > It's fixed by 667a5313ecd7308d which will be in 3.6, and is being
> > back-ported to most -stable kernels, thought it doesn't seem to have ar=
rived
> > in any yet.
> >
> > Maybe you can ask Ubuntu to provide a kernel containing that commit?
> > Or compile your own?
> >
> > Or find a kernel older than 3.2...
>=20
> Ok, I'm a bit confused.

Me too it would seem - sorry.  I was thinking of a RAID0 problem with simil=
ar
symptoms.

>=20
> I was running 2.6.38 when I replaced the drives and grew the array.
> Apparently growing went fine, because I was using the array for a
> couple of weeks. But it didn't write the correct metadata (0.90), thus
> reassembling after boot fails (or rather is the wrong size).
>=20
> I tried booting with 3.0.0, 3.2.0 and 3.5.0 with exactly the same results.
>=20
> I feel that no matter what kernel, as long as the metadata's wrong, I
> can't assemble it correctly, correct?

Yes, the metadata has lots the most-significant-bit of the 'size'.

So it should be sufficient to:
  mdadm -G /dev/md2 --size 2930266432

where the size is calculated as the current "used device size" plus 2^31.
You could probably just do "--size max"

This will cause a resync of the 2G of data which is probably unnecessary, b=
ut
is awkward to avoid.

NeilBrown

--Sig_/KO2RVY/NFyrKqJRHn/P5h6Z
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUFpRDTnsnt1WYoG5AQK8OA/+MmyyORZ5yETHUIlRUdLpf+XoveaRT65k
zBJ6504KQvg5dtQnG2azNyvWINMOJnXUWua1tZv0zymA5mmVHRmxlu5+wUInurvs
C/WpZTq/P7zev5SD1C3ZUxnBJgNMOy5HkbBATKRPfV7jnYChJ/Cec8TY8IlUwPfM
KXvAhJM+RFId1wk5Ko60MClrqZ6nEj4an2guTOb2joWJTSwQJy3nfO4Oi3Q3PUwL
0za/YgkWNn2wWs1u5epdFmgBvqj8P2U07V4WtPOP0dvtBFhb0ZIpby+LZ+GDE9mG
j9YNtGW/n9uYm2S1rNZ0M8Byp2sMY6Q3bMOHSlG96WHMqO9wm3DW88AlvzBhA3w7
h2gVqTdxTbBznPwIe6+RJewrXzVT3acrWRLGBfq4gJ2DWhfINxDMVSdF2ZO1T6/T
ovlpbXWqgwXZXoMtrlHmRzqvgXaMZFxxm105wZf5KcOZXlsALZ5K568J3afXs+zH
Tx1HMYL2TjNA4SezyFHsF5LcJfp9bkpCYRQPmFvCMafFJH/jdtSRF+YwQEpyYnCH
TyAduvoE+7Fz2Tp/QNw3PhVasUbOi6ZNZRIFYqImUPYJF9cyaUbO6JTmF7cyb//x
/MKEdLfrcUwrlo+u/gehhT0FN+9JieUqtGYlVjPaB0LFvb1yD6AdB9d6+kSuQnxW
0UtYUgHyuHc=
=TV1R
-----END PGP SIGNATURE-----

--Sig_/KO2RVY/NFyrKqJRHn/P5h6Z--
