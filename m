From: NeilBrown <neilb@suse.de>
Subject: Re: md:Fix a bug in function badblocks_show().
Date: Wed, 27 Jun 2012 13:01:08 +1000
Message-ID: <20120627130108.732db1ea@notabene.brown>
References: <201203081446488121330@gmail.com>
	<20120314123245.74feeab8@notabene.brown>
	<201206121703581252053@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3O=hNUyfvbmp_PqmXpvNtXA"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201206121703581252053@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: kedacomkernel <kedacomkernel@gmail.com>
Cc: majianpeng <majianpeng@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/3O=hNUyfvbmp_PqmXpvNtXA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 12 Jun 2012 17:04:00 +0800 kedacomkernel <kedacomkernel@gmail.com>
wrote:

> On 2012-03-14 09:32 NeilBrown <neilb@suse.de> Wrote:
> >On Thu, 8 Mar 2012 14:46:52 +0800 "majianpeng" <majianpeng@gmail.com> wr=
ote:
> >
> >> >From 58d2ba381eee4b732fca99a7311b1dcf589f57c3 Mon Sep 17 00:00:00 2001
> >> From: majianpeng <majianpeng@gmail.com>
> >> Date: Thu, 8 Mar 2012 14:37:00 +0800
> >> Subject: [PATCH] md:Fix a bug in function badblocks_show().
> >>=20
> >> If unack=3D=3D0, it will show all bad blocks include unacknowledged-ba=
d-blocks.
> >
> >Correct.  It is meant to.
> >The "bad_blocks" file shows all bad blocks.
> >The "unacknowledged_bad_blocks" file show all unacknowledged bad blocks.
> >
> >Thanks,
> >NeilBrown
> >
> >
> >>=20
> >> Signed-off-by: majianpeng <majianpeng@gmail.com>
> >> ---
> >>  drivers/md/md.c |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>=20
> >> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >> index ce88755..3f1b6e5 100644
> >> --- a/drivers/md/md.c
> >> +++ b/drivers/md/md.c
> >> @@ -8091,7 +8091,7 @@ retry:
> >>  		int ack =3D BB_ACK(p[i]);
> >>  		i++;
> >> =20
> >> -		if (unack && ack)
> >> +		if ((unack ^ ack) =3D=3D 0)
> >>  			continue;
> >> =20
> >>  		len +=3D snprintf(page+len, PAGE_SIZE-len, "%llu %u\n",
> >
> >
> Hi Neil:
> 	I found this bug in kernel-3.5-rc2.I deem you may lost to apply this pat=
ch.

No, I didn't lose it.  I deliberately chose not to apply it.
As I said, the current behaviour is correct.  Please read the message that =
you
replied to.

NeilBrown

--Sig_/3O=hNUyfvbmp_PqmXpvNtXA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT+p3dDnsnt1WYoG5AQIs1g//RKet55DnPXc9PTjm4Eg6cXeR3KXJt8yw
CxXVIDC2br7fy5vb14fxGxIui3r6qz450k3+55WHpLcylOnIW1w30yHQj8jkQpNk
EEFv9oCzaVl/clJ088XY3stqziFN5PsX7NfBteVmex2OowTFf6qwoDupeybB1kFi
GsqOvL4Pq3Hmyw9vUx6gvNT09IuhUjrT94xJie8hppnnTvHkFouywLjgLEbtjYjS
/IXTy+lNk+QqAxlozgnB2WbSfWPocZws4Ln/nrU3qLSlPpALrOXDgu7M3ThFJ3hF
rBtiQeCsRJol0iXxvRcWRrN5jl7cNgVmu66wAvGB1+599ElbtZxR6jMhJmFyB8JI
2I+TCE3DY/iI7SvHMA3K+IWxh4f+qVKLMcX3KNaUb8bdbtu8oFJl9PKe9rTFLnKR
3Q2S8bV7Dxcro7JKmMfzPYjlzUEoiEgts40p/hgX4cmmLIuLqQXV96+awFgZrSdk
daRMITbOfjWUUfh+gi2nhTDMnDszLsYbyyZ1aa50AbmBegB1woLSa9RsSykGDF38
aYODp0xdjNcmJWANNiqkSyd53S28+pESDA5LE/tHjledkGwWBF4fqQw/01FlvNHz
ITpqQXHIaOuAzYVu/keih+AkzCRH1fO9KHRpnmiKhlY1I0Ugcq1xdl4EZoPfZCWv
Yq7GB5ADH2k=
=Zfr3
-----END PGP SIGNATURE-----

--Sig_/3O=hNUyfvbmp_PqmXpvNtXA--
