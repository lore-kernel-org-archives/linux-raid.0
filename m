From: NeilBrown <neilb@suse.de>
Subject: Re: status of patches ( raid5 multiple threads )
Date: Wed, 20 Feb 2013 14:13:09 +1100
Message-ID: <20130220141309.1928358b@notabene.brown>
References: <CAEyJA_uzE++2TDntK6pcdmgLgXbPE_9--XdHwdsFR72vaUeHng@mail.gmail.com>
	<20120911094420.044cfa98@notabene.brown>
	<CAEyJA_ubguH+9k_xXmjFwXN=QHp9E1t+UbTxFYdVqEAT59Lzrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/jW8/EriH9kBbJV.x7m6oJ1A"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAEyJA_ubguH+9k_xXmjFwXN=QHp9E1t+UbTxFYdVqEAT59Lzrw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: vincent Ferrer <vincentchicago1@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/jW8/EriH9kBbJV.x7m6oJ1A
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 19 Feb 2013 11:22:06 -0800 vincent Ferrer <vincentchicago1@gmail.co=
m>
wrote:

> Hi  Neil / Shaohua,
>=20
> Did the patches for  "raid5  create multiple threads" got
> reviewed/merged into  3.8 kernel ?  Or otherwise what is the plan and
> current state of multi-thread raid5 support in latest linux kernels ?
>=20
> Appreciate your answers and great work.
>=20

No, not in 3.8.  I really should spend some time reviewing that code, but
I've had a very busy summer...

Have you (or anyone else) tested them?  Can you report anything positive or
negative?  Having someone other than the author say "this helped a lot" wou=
ld
be a very strong motivator for me....

NeilBrown


> -Vincy
>=20
>=20
>=20
> On Mon, Sep 10, 2012 at 4:44 PM, NeilBrown <neilb@suse.de> wrote:
> > On Mon, 10 Sep 2012 11:45:18 -0700 vincent Ferrer <vincentchicago1@gmai=
l.com>
> > wrote:
> >
> >> Hi Shaohua  (and linux-raid maintainers),
> >>
> >> Interested in knowing status of patches  "raid5  create multiple threa=
ds "
> >> http://www.spinics.net/lists/raid/msg39978.html
> >>
> >> Specifically want to know if it is available in any of the latest
> >> kernel releases 3.x ?
> >>
> >> Or otherwise when are these patches expected to get merged into linux
> >> kernel tree.
> >
> > I don't plan to submit them for 3.7, though I might for 3.8 if I get a =
change
> > to give them a proper review.
> >
> > NeilBrown


--Sig_/jW8/EriH9kBbJV.x7m6oJ1A
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUSQ/RTnsnt1WYoG5AQKdqw//U++q7ZPAeO/R+lYn/hUQwu2+bqSEsveD
nlDOwPd8tKylHDrLkthyQuabA1qATN3RAzmcXebZTYM5LlrJaU12jVHgsQG/MiXC
ILmwHwNkFUMz2d6lY+sWPaMdNzTUwfXLC9LV9tzapoYWyLCcDCgsk1NzzasXWFxs
9kKrQcGmMeReboXmO2qS1FwdAlkn+mrpYLSLhfV3bDR9Jwd/BIhQ8BFPYJ8ugqEQ
/qu5gprEiORjmefZb5Ock2txnQckfcs/0iI6PSKlDysBXKov1urSqI2hKH0EIPEb
l+qkulIrhj9RII/tEnxplmKeC+6pz4t6RNyOTE7do/K+PnxTrDPl2Y92U8zwyitb
Z2haHG5C3jcjx5X2f+x1aAJtJgiMcdLO5rWqwxmuc0HFHLSird5IJdORE9t6wuHg
/+L/1wbP6yt6HWqNePkT24wy1qDTWW5FbbcXH7/TuIVWz4Xgc3vR+VAy1hDcn4EM
gtg4Wbvf67DymdCD/bNWDApe7VdVDHXTAlhm1cz5gCV0FUAODGkq28TUpkdEJ/F5
ekLVTj5MhdoKNGulExVVyy6vPetIjmWvoxfn+RTfR6bAlr0zOzM72hhQLdU/b17b
VMVG7kpPxKgO6knpXgF559NmaNHYL0yKrzE3u+Bo/RxKaNoRUVlzIL5K2e+K+tuW
gUXpBESJGjE=
=tZvr
-----END PGP SIGNATURE-----

--Sig_/jW8/EriH9kBbJV.x7m6oJ1A--
