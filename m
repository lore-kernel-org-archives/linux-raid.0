From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/2] raid5: For write performance, remove REQ_SYNC when
 write was odirect.
Date: Mon, 16 Jul 2012 17:30:28 +1000
Message-ID: <20120716173028.69dd5ead@notabene.brown>
References: <201207160931507187344@gmail.com>
	<20120716154010.0ef12c57@notabene.brown>
	<201207161442513597497@gmail.com>
	<20120716170717.5d5ee04c@notabene.brown>
	<201207161511247039289@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/se_DRRLjocLF5b6JNPX66qD"; protocol="application/pgp-signature"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <201207161511247039289@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: viro <viro@ZenIV.linux.org.uk>, linux-raid <linux-raid@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/se_DRRLjocLF5b6JNPX66qD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 16 Jul 2012 15:11:29 +0800 majianpeng <majianpeng@gmail.com> wrote:

> On 2012-07-16 15:07 NeilBrown <neilb@suse.de> Wrote:
> >On Mon, 16 Jul 2012 14:42:54 +0800 majianpeng <majianpeng@gmail.com> wro=
te:
> >
> >> On 2012-07-16 13:40 NeilBrown <neilb@suse.de> Wrote:
> >> >On Mon, 16 Jul 2012 09:31:55 +0800 majianpeng <majianpeng@gmail.com> =
wrote:
> >> >
> [snip]
> >> > Normal 'sync' requests use WRITE_SYNC which includes "REQ_NOIDLE" wh=
ich means
> >> >   /* don't anticipate more IO after this one */
> >> > O_DIRECT request use WRITE_ODIRECT which does not include this flag.
> >> >
> >
> >> Using REQ_NOIDEL to difference odirect and sync.Why not using:
> >>  +	if (bi->bi_rw & WRITE_ODIRECT)
> >>  +		bi->bi_rw &=3D ~REQ_SYNC;
> >
> >Because that code is wrong.  WRITE_ODIRECT is not one flag, it is two fl=
ags
> >'or'ed together.  So this code does not do what you expect.
> >
> No, I used those code test and it's ok.
> The code used & not &&.
> Maybe I wrong?

Think about it...

#define REQ_WRITE               (1 << __REQ_WRITE)
#define REQ_SYNC                (1 << __REQ_SYNC)

#define RW_MASK                 REQ_WRITE
#define WRITE                   RW_MASK

#define WRITE_ODIRECT		(WRITE | REQ_SYNC)

So  =20
    (bi->bi_rw & WRITE_ODIRECT)

will be true if either REQ_WRITE or REQ_SYNC are set in bi_rw
So whenever REQ_SYNC is set, your code clears the flag.
So your code is functionally identical to

   bi->bi_rw &=3D ~REQ_SYNC;

NeilBrown


--Sig_/se_DRRLjocLF5b6JNPX66qD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUAPDFDnsnt1WYoG5AQKZsw//X7xx8C7rk4BMzZ7AdMdjbtQbmb05bMEE
7CUcKzFdtmMHhWjHkvYkGO0bCKeDHWXcrvB1CDQg/UeQn1KP/kry+UpH4XNklAbL
m4yanGJwXcVQ7mZXbtQ2vC24TrR6GVQJAurZ3oIOZgDIXkc6ScwBo0OtevCXsxw9
OL7TvpLVb7TWuyeqR4gxBFsNtXKtRWun2aI+3gerER0biyQLwA63Aj/G18ZRcJE1
sDOf7j+Qj0MRAHP/jIuRMQ3NMqJ1px8v6tRqk0UQLcmPshZqW0zs5SCwdF1yMSzn
RJs5zSFQiy4b5PsjliNW1/RHp/izL6SbR9GLQMG44Zod8JnNpZaOeSttaOulLhTr
2fsw8JhKg83bFGgkpICSP3uAFfU6fiMcrwwodgoZlR6yS1Frz9/s4d7FEZ2SfknA
evJ5pbXFuoMujyo6DPFepkRcTqTIXohv1nfAf/I5QZR/8YaW5TmATMeptUn7r/tr
lQqUIvKuqytFs/YFY/hPepIfE9WKwivhULoHrOUCv3EHqYG6eH2Fc7VWtWvbVPM3
KTSF7jyRG/qJGcaY7mOcFDBu0HlQ4a3ujcw07DegXeD61ZO7SP0LjSUwdQfytWq8
D9t5SCOwv9DDpuXEXDw/EOvqTKx+eA5OyGs2ULybXVujlzUVM4xM6msygdU5hQoD
vzdkqEWhiWY=
=YtGi
-----END PGP SIGNATURE-----

--Sig_/se_DRRLjocLF5b6JNPX66qD--
