From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 6/7 v2] MD: raid5 trim support
Date: Mon, 13 Aug 2012 13:58:31 +1000
Message-ID: <20120813135831.284d721d@notabene.brown>
References: <20120810025113.050392766@kernel.org>
	<20120810025255.292192477@kernel.org>
	<20120813115051.64d5d44e@notabene.brown>
	<20120813020454.GA447@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/lBATm/VdtuUxNrZMZeAeyzR"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120813020454.GA447@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Shaohua Li <shli@fusionio.com>, linux-raid@vger.kernel.org, axboe@kernel.dk
List-Id: linux-raid.ids

--Sig_/lBATm/VdtuUxNrZMZeAeyzR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 13 Aug 2012 10:04:54 +0800 Shaohua Li <shli@kernel.org> wrote:

> On Mon, Aug 13, 2012 at 11:50:51AM +1000, NeilBrown wrote:
> > On Fri, 10 Aug 2012 10:51:19 +0800 Shaohua Li <shli@fusionio.com> wrote:
> >=20
> > > @@ -4094,6 +4159,19 @@ static void make_request(struct mddev *m
> > >  	bi->bi_next =3D NULL;
> > >  	bi->bi_phys_segments =3D 1;	/* over-loaded to count active stripes =
*/
> > > =20
> > > +	/* block layer doesn't correctly do alignment even we set correct a=
lignment */
> > > +	if (unlikely(bi->bi_rw & REQ_DISCARD)) {
> > > +		int stripe_sectors =3D conf->chunk_sectors *
> > > +			(conf->raid_disks - conf->max_degraded);
> >=20
> > This isn't right when an array is being reshaped.
> > I suspect that during a reshape we should only attempt DISCARD on the p=
art of
> > the array which has already been reshaped.  On the other section we can
> > either fail the discard (is that a good idea?) or write zeros.
>=20
> I had a check in below for-loop for reshape, is it enough? If not, I'd li=
ke
> just ignore discard request for reshape. We force discard_zero_data to be=
 0, so
> should be ok.

Yes, you are right - that is sufficient.  I hadn't read it properly.

>=20
> I'll fix other two issues. Will repost the raid5 discard patches later.

thanks,
NeilBrown

--Sig_/lBATm/VdtuUxNrZMZeAeyzR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUCh7Zznsnt1WYoG5AQKLCRAAkcR1P8AH3964zEtsPgg42a5YOG3voQLe
59FQxfhKtjPFuJNNCu7csj2k06mfTxP7NX/2mfKp13O8P55oEfoj1+IkD4g2zBoN
BJHxbCisnFDt3RxH1x0coddJPtUP+oMS8S+K0PQWJ0UU66HCujxGJoq970ES6hkd
0hd/4jcPQreMF1+g3glD61D0EfzcvRv6zXIWDMlFuDZ1ls2Q7OgWNkn6cFo9Zac4
D0TBnf2juVV7FahuM7Lf4O/blHxS6npjdDtog/TGBkAeqJOCYIZoRYrxfaEZF6uY
OOszkJ0kRo4nLVFCQugc+G4VRpqcajLH/rVF5YDBIZPZ+BoJtNkinDdfLp2cQpAp
ZVbhImsRp4qoBYDPIBgU0CSp+XAPlvXkJfopA8RZHAIjTsYxUKVU7arRb5E4Pi8l
Ns2TKkWK9vdaulyx0jcULRaEoRN91jZ9dxKTgbadSyMGjG2Anv9oA1PFK1V7gJOw
yeHSBN4MHt4FQmfemFBuMsQJo80cioAQTXvQ8B8CNDFx/y25xBGbyZ2hTXFbur3w
nMd9dHAuP/KZVG+kYRaSFN1eeOX/I25fJ1SYSlRI4giZ5sHXLe7mySVPOcqH4sEK
/j3TmhqcZeN3GWSbqoEml5L4Zp87k3XnZAAePtB2VSzRasylqeLxIh+ybq0Fyvfs
lGn9tQZy7X4=
=5XkN
-----END PGP SIGNATURE-----

--Sig_/lBATm/VdtuUxNrZMZeAeyzR--
