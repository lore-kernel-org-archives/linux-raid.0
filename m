From: NeilBrown <neilb@suse.de>
Subject: Re: Enable SCTERC in the kernel?
Date: Fri, 25 Oct 2013 21:42:52 +1100
Message-ID: <20131025214252.1929c7f1@notabene.brown>
References: <1969984.qn2lKzvFd6@eseries.newtech.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5thAUlwuY5OiQ1S7DmSK+up"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1969984.qn2lKzvFd6@eseries.newtech.fi>
Sender: linux-raid-owner@vger.kernel.org
To: dag@newtech.fi
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/5thAUlwuY5OiQ1S7DmSK+up
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 25 Oct 2013 11:51 +0300 Dag Nygren <dag@newtech.fi> wrote:

>=20
> Hi all!
>=20
> Just run into the standard problem by not having SCTERC enabled
> for my drives due to a spelling mistake in my rc.local script
> setting the parameters and started wondering:
>=20
> - What if the md module automatically set this during assembly
> of the RAID? - In the kernel module itself. It could always set it,
> if the set failed we could spit out a kernel warning that the used
> drive might not be the best as a RAID device. Would there be any ill
> effects from this?
> - And ditto for the device time-out.
>=20
> This would definitely make md work a lot better for people. I have a
> strange feeling that most don't know the parameter needs setting...

I don't think it is appropriate for the kernel to automatically set such
things.  However it might be appropriate for mdadm to do it when assembling
or creating the array.

I'm happy to review and  possibly accept patches.

NeilBrown

--Sig_/5thAUlwuY5OiQ1S7DmSK+up
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUmpLLDnsnt1WYoG5AQLC1A//c6lpXVwuCJtIRmF+uYBOO094AtPJnslM
PZFZn3I4CivsC3BkqTOmwUCPywHnnDYI0fCXCoQkANa6qotNiy/P2OgVB61gJtGG
Xgr9J1n1WEAG0UEOktp8K5PclRDYncVL4DWYvFDMW7MHIfilVdk8Bno6aEor4m6y
68T316zaTHE2Wdh57fjzv1tgiBktgJqnBIl14l70yRBa5rOiKAY6GkvrEVghru3t
axTZb4Ci6preQz2mPEbb5H5FXG1ZWHYoVzL3D9GuT5WIqplnbnjfU2VXkygrMuqr
9f1Kn1uEnK96UE8KC08qO8vA6fRTsWo8kbSDOkF5FSEhhZO4fhwPsgSdrJVAUUkG
HdGxDTbJc8g/F7FwSHJQdtXwt2zzvNuOasiQj9wuVe5SJxcjlBuGIb4H7gACc2vu
4mdkc+HmdnjC8ytyql6For+pdN7YRC73DRnb750lvMyDVqi3Ej+0r6nvE0CzkYkf
Jk92WEyi/FpFuDuEAfZoRfUl0VjOQLdJQPA0bbcJhFI50utvMukESMmcm+qaxst+
dkXSABk0lUNmvnOxB1hO/zEO67sjmsfyI8g4mzHey8IhGQ+A79NHfDk0j5R6ZyqG
gR07CXP+uv1At3+xMlIzgTxIiOzQBVIPiePGT5+UcJcht7EivN5eOhQmO0z/LhGB
PIBUIzsn5ZI=
=GYgk
-----END PGP SIGNATURE-----

--Sig_/5thAUlwuY5OiQ1S7DmSK+up--
