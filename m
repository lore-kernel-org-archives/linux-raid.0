From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md/raid1:using else-if instead if.
Date: Mon, 2 Apr 2012 11:58:36 +1000
Message-ID: <20120402115836.76e98982@notabene.brown>
References: <201204011029101719694@gmail.com>
	<4F78ECBF.3060700@zytor.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/xre3po/PPjqctX1r9nvrUPR"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F78ECBF.3060700@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: majianpeng <majianpeng@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/xre3po/PPjqctX1r9nvrUPR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 01 Apr 2012 17:03:11 -0700 "H. Peter Anvin" <hpa@zytor.com> wrote:

> On 03/31/2012 07:29 PM, majianpeng wrote:
> > From 798f3fce3d077db049a44d0d2434261c937796e9 Mon Sep 17 00:00:00 2001
> > From: majianpeng <majianpeng@gmail.com>
> > Date: Sun, 1 Apr 2012 10:23:56 +0800
> > Subject: [PATCH] md/raid1:using else-if instead if.
> >=20
> > Signed-off-by: majianpeng <majianpeng@gmail.com>
> > ---
> >  drivers/md/raid1.c |    3 +--
> >  1 files changed, 1 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> > index 4a40a20..a9de970 100644
> > --- a/drivers/md/raid1.c
> > +++ b/drivers/md/raid1.c
> > @@ -2024,8 +2024,7 @@ static void handle_sync_write_finished(struct r1c=
onf *conf, struct r1bio *r1_bio
> >  		if (test_bit(BIO_UPTODATE, &bio->bi_flags) &&
> >  		    test_bit(R1BIO_MadeGood, &r1_bio->state)) {
> >  			rdev_clear_badblocks(rdev, r1_bio->sector, s);
> > -		}
> > -		if (!test_bit(BIO_UPTODATE, &bio->bi_flags) &&
> > +		} else if (!test_bit(BIO_UPTODATE, &bio->bi_flags) &&
> >  		    test_bit(R1BIO_WriteError, &r1_bio->state)) {
> >  			if (!rdev_set_badblocks(rdev, r1_bio->sector, s, 0))
> >  				md_error(conf->mddev, rdev);

I don't like this option as it confuses the logic..

>=20
> It would be even better to:
>=20
> if (test_bit(BIO_UPDATE, &bio->bi_flags)) {
> 	if (test_bit(R1BIO_MadeGood, &r1_bio->state))
>   			rdev_clear_badblocks(rdev, r1_bio->sector, s);
> } else {
> 	if (test_bit(R1BIO_WriteError, &r1_bio->state)) {
> 	...
>=20

and I don't really like adding unnecessary indentation.

>=20
> ... rather than testing the bit twice.

I'm really surprised that the compiler doesn't optimise that out.

I see:

   0x0000000000004fb1 <+113>:	mov    0x18(%rcx),%rax
   0x0000000000004fb5 <+117>:	test   $0x1,%al
   0x0000000000004fb7 <+119>:	je     0x4f70 <handle_sync_write_finished+48>

which is the first test_bit(BIO_UPTODATE), then

   0x0000000000004f70 <+48>:	mov    0x18(%rcx),%rax
   0x0000000000004f74 <+52>:	test   $0x1,%al
   0x0000000000004f76 <+54>:	jne    0x4f82 <handle_sync_write_finished+66>

so it is repeating a test that it already knows the answer too.
Why not just "je 0x4f78 <handle_sync_write_finished+56> I wonder.

Still, I'm much more interested in readability than this sort of micro
optimisation, so I'll leave the code as it is.

Thanks,
NeilBrown


>=20
> 	-hpa
>=20
>=20


--Sig_/xre3po/PPjqctX1r9nvrUPR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3kHzDnsnt1WYoG5AQJQ0g//Y+lAtcK2q0HoZik5q1SxLVR3IcX58TSq
/4WJOGy7O/BQtsXqcMGKi0+d8eJ1denzpXgY3O1h+cqYb5GN3IZtgqpfzWlxi1Jq
qp4DfAXJrHGgx/DaEkw/6J1zAO7EnGNJEDzvgpxN/5RZgP3U0vWlQlVYIBjdzPDK
gSISbwKHZTi72eqUO4tKD3fleBlqF3Q2F6FR3Kn72HpwEM1mYCMaVxxslFF0+ysZ
wBN6YytlIy7OYH/UXUbDMnw7TxxF8JhkopG01XYBQUoFqLlsQa4yX5Er3Db3WaKt
DoJtmhwemECLWpm+KSQR0/UZnCRjIrMAV6KFlv57Vx1v3I1SDVPKh0D62uHrmp6/
ytbMKvG8dYfMbjUcqtq+J5rgQBjtm/PCDQG0/qJ/mGRwrAfxBE2ecMnbSLxh8pQ4
o+GRY6bVgK3hXF7w3FjElveTdTnjDM36GmzBvvud1RBqvvz2pxMKZlB7IMVDhTkJ
2NdA6fbvhMmFD+pCYcbo4rVFcxdGxwBrHNmNFOYerVDjIihbWsl5Gai5afmbDPT1
vBfwjsDnsTNS0b3kOxQVgaB1XSdPLCwUwEF3JdmskQSV1pz7Y61yR+wAM08y09+L
EcysJpdyc1SPxSNDLKN+gCxOYBUCY4r56msWMX5Mulnt5BKu4N2V7Dm78+NpJ4Cv
33ERD7NtI3w=
=rDwk
-----END PGP SIGNATURE-----

--Sig_/xre3po/PPjqctX1r9nvrUPR--
