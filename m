From: NeilBrown <neilb@suse.de>
Subject: Re: md/raid10: handle recovery of replacement devices.
Date: Tue, 15 Nov 2011 17:58:02 +1100
Message-ID: <20111115175802.498875b3@notabene.brown>
References: <20111115063239.GA30827@elgon.mountain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0CJqcBq_ygU/X7NitZEvcSg"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111115063239.GA30827@elgon.mountain>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/0CJqcBq_ygU/X7NitZEvcSg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 15 Nov 2011 09:32:39 +0300 Dan Carpenter <dan.carpenter@oracle.com>
wrote:

> Hello NeilBrown,
>=20
> This is a semi-automatic email about new static checker warnings.
>=20
> The patch e1f6cbf7e1b0: "md/raid10: handle recovery of replacement=20
> devices." from Nov 9, 2011, leads to the following Smatch complaint:
>=20
> drivers/md/raid10.c +2814 sync_request()
> 	 error: we previously assumed 'bio' could be null (see line 2808)
>=20
> drivers/md/raid10.c
>   2807					bio =3D r10_bio->devs[1].repl_bio;
>   2808					if (bio)
>                                             ^^^
> check.
>=20
>   2809						bio->bi_end_io =3D NULL;
>   2810					rdev =3D mirror->replacement;
>   2811					if (rdev =3D=3D NULL ||
>   2812					    test_bit(Faulty, &rdev->flags))
>   2813						break;
>   2814					bio->bi_next =3D biolist;
>                                         ^^^^^^^^^^^^
> unconditional dereference.
>=20
>   2815					biolist =3D bio;
>   2816					bio->bi_private =3D r10_bio;
>=20
> regards,
> dan carpenter


Thanks.

I happen to know that if mirror->replacement is not NULL, then
conf->have_replacement is true, so r10buf_pool_alloc will have allocated
[1].repl_bio so if we get to 2814, bio will definitely be non-NULL.

Still, it wouldn't hurt to add a test for 'bio' to keep match happy, and put
in a big comment to keep reviewers happy.  I'll consider doing that.

Thanks,
NeilBrown

--Sig_/0CJqcBq_ygU/X7NitZEvcSg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIUAwUBTsINgDnsnt1WYoG5AQLizg/40Qok9N7t1l2nihiCmUAc6WVigrqKkDC0
fvEmxm9tq1FSJmGEm5An/YHWV+/Nhk5aV2b/N83mOhmrhUPQQan5nZ12OvrrlvM2
gfUXsgi2rwgRkSWugbkCOie3HTeWcFj3vd+E3QmG5cIo7I7jVXZOyRdgwT18Ouo9
eRxFTTYRiUnVj70U7ZwfYUIFw0D6ZfW8U1ZANvVuW3MC4ll9jFIbOrR5NWg+Ss0Y
u0+jvipvGSW1te6ZNU4Wj//n0hlcaElmOcT+SsYxuYuuRl5HTCkuAr48aJ4Hg2ue
u04CNIyFFCcm+OLEH27ip4x+w6w1OtWbh6+3sO2ghVHSb4xmsobd58c+1JFzt60g
tcUIWjDYJLPPAXodgqIFcnDaDenMaxRCzyPSoxC/pmJEmrcmKLvwGnd/w+IXz1uQ
WFDlVALnb7xsbtWH79RTDArXA1z5N037gysLdDcAmfAPvUHuVtRLNQQW6Wn0vTWh
4sxWuAXzE4BQbOmUy4FHR9m4J7K91+feLuLmGLxRw0WJ7f80wB6okhOHDR8Z4Dnm
KCofjvhoDJsGd3Bl7jzLv10F41Nsy4D+SK1w3eW2HFEtb5QFeMx15Tr1ouDjgkaF
pZJj16mzYA2NgYZiRjwU49peh5BfbAt1g2jWNY/r8gmrH90c7lhH/RsNDDktsXlZ
303avLIM0A==
=3fSn
-----END PGP SIGNATURE-----

--Sig_/0CJqcBq_ygU/X7NitZEvcSg--
