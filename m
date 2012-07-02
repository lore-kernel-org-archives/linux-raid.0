From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 02/10 v3] raid5: delayed stripe fix
Date: Mon, 2 Jul 2012 10:55:37 +1000
Message-ID: <20120702105537.24b86ced@notabene.brown>
References: <20120625072447.268095276@kernel.org>
	<20120625072606.544356632@kernel.org>
	<20120702104648.758e56d9@notabene.brown>
	<20120702004955.GA327@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.mPtDb7oUknPzclU5cFSniE"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120702004955.GA327@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

--Sig_/.mPtDb7oUknPzclU5cFSniE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 2 Jul 2012 08:49:55 +0800 Shaohua Li <shli@kernel.org> wrote:

> On Mon, Jul 02, 2012 at 10:46:48AM +1000, NeilBrown wrote:
> > On Mon, 25 Jun 2012 15:24:49 +0800 Shaohua Li <shli@kernel.org> wrote:
> >=20
> > > There isn't locking setting STRIPE_DELAYED and STRIPE_PREREAD_ACTIVE =
bits, but
> > > the two bits have relationship. A delayed stripe can be moved to hold=
 list only
> > > when preread active stripe count is below IO_THRESHOLD. If a stripe h=
as both
> > > the bits set, such stripe will be in delayed list and preread count n=
ot 0,
> > > which will make such stripe never leave delayed list.
> > >=20
> > > Signed-off-by: Shaohua Li <shli@fusionio.com>
> > > ---
> > >  drivers/md/raid5.c |    4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > >=20
> > > Index: linux/drivers/md/raid5.c
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > --- linux.orig/drivers/md/raid5.c	2012-06-25 14:36:15.964613183 +0800
> > > +++ linux/drivers/md/raid5.c	2012-06-25 14:36:57.280096788 +0800
> > > @@ -196,12 +196,14 @@ static void __release_stripe(struct r5co
> > >  		BUG_ON(!list_empty(&sh->lru));
> > >  		BUG_ON(atomic_read(&conf->active_stripes)=3D=3D0);
> > >  		if (test_bit(STRIPE_HANDLE, &sh->state)) {
> > > -			if (test_bit(STRIPE_DELAYED, &sh->state))
> > > +			if (test_bit(STRIPE_DELAYED, &sh->state) &&
> > > +			    !test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
> > >  				list_add_tail(&sh->lru, &conf->delayed_list);
> > >  			else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
> > >  				   sh->bm_seq - conf->seq_write > 0)
> > >  				list_add_tail(&sh->lru, &conf->bitmap_list);
> > >  			else {
> > > +				clear_bit(STRIPE_DELAYED, &sh->state);
> > >  				clear_bit(STRIPE_BIT_DELAY, &sh->state);
> > >  				list_add_tail(&sh->lru, &conf->handle_list);
> > >  			}
> >=20
> > Thanks.  I've applied this patch and will submit it upstream shortly.
> >=20
> > Have you actually seen a stripe get trapped with both bits set, or is t=
his
> > just a theoretical problem discovered by code inspection?
>=20
> I print the flags of strip when there is overlap sleep in make_request(),=
 and
> found this case, so this is real.

OK, thanks.

>=20
> How do you think about the other patches in the series?

I'll let you know shortly.

NeilBrown

--Sig_/.mPtDb7oUknPzclU5cFSniE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/DxiTnsnt1WYoG5AQLKrw//dSh3nmPlEP+gwlraKoUIuHK93HbB5nmU
2lOYOIx41ljW7XYOztYjPUhTgcsZf2LB8fF9bCwz4zTf3vHsuNLNB8KBx7PDHQ0f
Wj3t07jsQfifWGktRgHZ9NOTvbxs66wxs66LilirOwwFx/cTmiFq6TW7i4d99O7X
1Pw8Z2IlRo8gXOUdypCCFBkRqFrKcxq9P2Oiw93K2wkRReIDICfavQhfSmEPP6QL
d5iPeIweddSRgsrng4xHBqE3j0Q5L/UBCjOou9c8flgsDIIs2VjnNLcE5Al1Ixtn
RXoU1PlcXn6U+bdBMgxcO/oVbiNPPv88lG1QEtogXeBk/s17O9zEcf6d5A2XgjKO
8M7fOqu/IyOmYHUeBRTHuNUXueogjhRMOjGAzMWAbAJAGLBu7At9dOsZ5LNR+KxM
I+c+ZOBNuLJyruZmjISvg0Y7PrfnulYNHuUG30ucbGcigJOigNR8k7GZDy24aDgq
dSm2QZIDQA7Cxdi9irsP8bTobUIpUUmugMHYND0PZOzWDIacI6IfocjWbGIujsLM
6GVMurOZXBhSAHojRNghN2AUrTf1fX4dWRCa+9jdNmQGu5A3NWbkRkf9Zmy395i2
38OcvUuygrE3gyigHpy5xR5YPeN8VjsnB5E41SP5wxybfDsSCtaASFKyGqJI22VP
wj7c3tmqI8w=
=Tm1U
-----END PGP SIGNATURE-----

--Sig_/.mPtDb7oUknPzclU5cFSniE--
