From: NeilBrown <neilb@suse.de>
Subject: Re: RAID-10 keeps aborting
Date: Thu, 13 Jun 2013 13:11:59 +1000
Message-ID: <20130613131159.07250e04@notabene.brown>
References: <51AC1440.7020505@zytor.com>
	<51AC3283.4000403@zytor.com>
	<CAA9_cme6tYpYnrZDbrDduwPCjVn+PFbx_rZNPFazBEU9EF0upw@mail.gmail.com>
	<51ACBAA0.40604@zytor.com>
	<CAA9_cmc3Gs91C4aV6okUw-=q+fACm1+dooyafOZi+Lnj+Ne_ig@mail.gmail.com>
	<51ACD511.4030604@zytor.com>
	<yq1y5art543.fsf@sermon.lab.mkp.net>
	<CAA9_cmcoOYcFsJuuuJfC4aOUQxJ+6B_Z350HL70TXwYHF4_qGQ@mail.gmail.com>
	<yq1d2s1rcb7.fsf@sermon.lab.mkp.net>
	<51AE2A8C.4080508@zytor.com>
	<yq18v2prbum.fsf@sermon.lab.mkp.net>
	<CAA9_cmcBt3Mqt+iwrZFANoCef4YfopEPFbvYfEJgqFg8p7WtLQ@mail.gmail.com>
	<51AE3441.3000208@zytor.com>
	<CAA9_cmdSvThf_TRjtTSh3r6KOgF9RgzZ6GZPEeYoC2f_n_qz8A@mail.gmail.com>
	<51AEA4FE.3060900@zytor.com>
	<yq1mwr4pd9f.fsf@sermon.lab.mkp.net>
	<20130606142747.1fc17b7f@jlaw-desktop.mno.stratus.com>
	<yq1bo7ioe6e.fsf@sermon.lab.mkp.net>
	<20130610101505.33b32d07@jlaw-desktop.mno.stratus.com>
	<20130612131543.1c79e077@notabene.brown>
	<alpine.DEB.2.02.1306122242290.22555@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kWHR1XESCab1EmG.WGJn=F8"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1306122242290.22555@jlaw-desktop.mno.stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "H. Peter Anvin" <hpa@zytor.com>, Dan Williams <dan.j.williams@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/kWHR1XESCab1EmG.WGJn=F8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 12 Jun 2013 22:45:08 -0400 (EDT) Joe Lawrence
<joe.lawrence@stratus.com> wrote:

> On Wed, 12 Jun 2013, NeilBrown wrote:
>=20
> > I've applied that patch below - thanks.
> >=20
> > NeilBrown
> > >=20
> > > From b12c24ee0fce802f35263da65d236694b01c99cf Mon Sep 17 00:00:00 2001
> > > From: Joe Lawrence <joe.lawrence@stratus.com>
> > > Date: Fri, 7 Jun 2013 15:25:54 -0400
> > > Subject: [PATCH] raid1: properly set blk_queue_max_write_same_sectors
> > >=20
> [snip patch]
>=20
> Hi Neil -- this patch was only to test out what RAID1 would do if the=20
> blk_queue_max_write_same_sectors were set to enable WRITE SAME.  As HPA=20
> and Martin point out, we should be disabling WRITE SAME for raid1/10 in=20
> 3.10 / stable for now.  Sorry for the confusion.
>=20
> -- Joe

Ahh - thanks.

the code your patch removes is clearly wrong as chunk size doesn't mean
anything useful for raid1, but as you say we need to actually disable it, so
may as well do that at the same time as removing the error.

Thanks,
NeilBrown

--Sig_/kWHR1XESCab1EmG.WGJn=F8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUbk4fznsnt1WYoG5AQICoRAAnAbr/zhKfNJJcX0Babzm4uOy6zEodwyv
U26lMRHTqLBv9Bcwzh1z0+cpfVv3ZTYyKr2K8rwaVDcXKYUWIVh478M0hDdIdvtf
SlxnlVUKyVDHRV/LASA4/fpf8EdQiQygjWLgrMe6X+Q1yFoZF/C5sci8LkThDX+1
GgaaDo1kPs6N3wxFouDSdH5cdmuOyfQfDcZ7FFo62WIFsKJEGp5fm/vjo92OfgAp
JeQ87NSPD3Me9kFO+yhgx8QEUWT72WR+ccIkmgYWoTzHMqAC0NARW7e7saWcuRl2
w/3Kd+d4p2EDXlS6r4mO6O6KcU2qxVn0QStZnmcODYlTr3W8ZxlIXW30XXSB6NWn
j0eVYFgy28R0VPuHujp9/UHoI3f52oMNbsOmZxg6Adn/v5jdfzOBRBaTQtTdBgeU
YUnYvoUnRAoEWVyqbTp2NEGBeB0nuJwjHBkdThoWeo9rK2Eh7YicrkcIAzbD/EjH
lYC+C5RO6pNZ7X/wmQuUVfyG551qEvb9XctOAqdf7GovEsDmIElbuYOCa0cg2zjl
LKa0Cbo7cearswCyRDkgzpVvlwbbk+RONexv1sawCoOqXWpEzGUBgOpG1KFpjWQT
UsXsz0PTe1cev/qdONof55RkCnqPtbxVJkWadHc1tQB4aCQHEOx8yt+Cqhl3qE9Y
kJpYs29fyQg=
=t1Pk
-----END PGP SIGNATURE-----

--Sig_/kWHR1XESCab1EmG.WGJn=F8--
