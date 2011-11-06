From: NeilBrown <neilb@suse.de>
Subject: Re: [PANIC] : kernel BUG at drivers/md/raid5.c:2756!
Date: Mon, 7 Nov 2011 09:00:56 +1100
Message-ID: <20111107090056.66331af5@notabene.brown>
References: <CAE0An6cvpqD8oPiHr2CAb753hC=47BYErOwAxaXoeHOYPaVznA@mail.gmail.com>
	<20111101163931.4d85e330@notabene.brown>
	<CAE0An6em5crdkSJOLHSB85fQ95Br5HRmu3pa-E4O10X5y7vr9g@mail.gmail.com>
	<20111101172946.1bf765f4@notabene.brown>
	<CAE0An6eSxFBYbHj7M=k4YDJdUv3oP8Y3_Sc3BB7K2RKix0W-yw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/rPtokPIu_+T1bnz8+e=l/sr"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAE0An6eSxFBYbHj7M=k4YDJdUv3oP8Y3_Sc3BB7K2RKix0W-yw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Manish Katiyar <mkatiyar@gmail.com>
Cc: linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

--Sig_/rPtokPIu_+T1bnz8+e=l/sr
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, 4 Nov 2011 11:25:41 -0700 Manish Katiyar <mkatiyar@gmail.com> wrote:

> On Mon, Oct 31, 2011 at 11:29 PM, NeilBrown <neilb@suse.de> wrote:
> > On Mon, 31 Oct 2011 23:09:04 -0700 Manish Katiyar <mkatiyar@gmail.com> =
wrote:
> >
> >> > I think you were quite unlucky to hit this and that you will find it=
 hard to
> >> > reproduce. :-(
> >>
> >> Well, its always reproducible on my ubuntu when I run that script.
> >>
> >
> > Excellent!! =A0 That means you can reliably see if the patch fixes it. =
:-)
>=20
> Sorry for the late reply. Yes it fixes it for me.

Thanks a lot for the confirmation!

NeilBrown


>=20
>=20
>=20
> >
> > I guess I was thinking of 'real' devices which are slower than XOR. =A0=
You were
> > using loop back device on files in /tmp which are presumably always in =
memory.
> > I guess it would be a lot easier to hit in that case.
> >
> > Thanks,
> > NeilBrown
> >
>=20
>=20
>=20


--Sig_/rPtokPIu_+T1bnz8+e=l/sr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTrcDmDnsnt1WYoG5AQIx3A//Vm90IxfwqJYBMAxlMm/mXG/9Snj4m2qz
KCVZkiGDwi6KwpVtqujrasDu116v6wTCxpCItAgK7zRkrBs3hub5rQUsJz2mow/M
LD+Ks+g0guY3H1JIk/2a14HwOCh+v5Dx6b9AKAVrhuzGBfk79MOTKRhNuiPFFnmf
FeeZp1P4ojr3VedKjDjswO4oMnkBCp3FOQdBGfi/RMSpJtFu3mvfmcBorJQ1mMmv
WttHq1Wm/cyqaVCrhWC+7Bw3or8pBHWJYxlnKbpvTffNmUluFw8B8E154Pj7dsBr
gBScVjyo+hMK0ZD8Soy1KltoDO1XY0JqQb/2LhrHqYXjdnt/nhhsVNBKTvzygPwS
C+D3ryznUurGfwrkwMtORQaQdeB8bvikcfni4hiZjHUvjG1BC0XYztOE0BAqkrLM
JDKhbPghJX2yeiJwq/4dBLOOzHuPaBTCFPNFm9SmlUtAyb1aQdeoDF8sgOAuSGLG
9S1rvuX44NhDDaG/PxU2qfhvQY1vgi2of1I2YkHVRkC29Z9XzHGZOWDZxd7eay4x
5j576HnajC/UtSArtXPLht1tGi9Ory5XYXOClpGeqC+L9FrbvSojKh78Tn1P8WKO
btxBH0g7GJGeyPiVaSMP6/E99N1kYIWYlBgl1R6qU9AApSM8GOvWq+Zl84sa5F8b
7XGIykq7K+k=
=HnUv
-----END PGP SIGNATURE-----

--Sig_/rPtokPIu_+T1bnz8+e=l/sr--
