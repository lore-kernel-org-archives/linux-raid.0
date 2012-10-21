From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm: super0: do not override uuid with homehost
Date: Mon, 22 Oct 2012 08:50:44 +1100
Message-ID: <20121022085044.044026cf@notabene.brown>
References: <20121020154002.F24612C12@gandalf.tls.msk.ru>
	<5082CCB7.3010402@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/+URC_ZLS0Fgn5PhE8bTTelO"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5082CCB7.3010402@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/+URC_ZLS0Fgn5PhE8bTTelO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 20 Oct 2012 20:09:27 +0400 Michael Tokarev <mjt@tls.msk.ru> wrote:

> On 20.10.2012 19:40, Michael Tokarev wrote:
> > When --uuid is specified in the command line, even for v0.90
> > superblock we override last portion of uuid with data from
> > --homehost, which is wrong (and disagrees with the manpage).
> > Only use homehost in super0 if no uuid is specified.
> >=20
> > Signed-off-By: Michael Tokarev <mjt@tls.msk.ru>
> >=20
> > diff --git a/super0.c b/super0.c
> > index 1375799..ca4c082 100644
> > --- a/super0.c
> > +++ b/super0.c
> > @@ -657,7 +657,7 @@ static int init_super0(struct supertype *st, mdu_ar=
ray_info_t *info,
> >  		if (rfd >=3D 0)
> >  			close(rfd);
> >  	}
> > -	if (homehost) {
> > +	if (homehost && !uuid) {
>=20
> Besides, do we need to check *homehost here too,
> in order to be able to unset homehost given in
> config file or whatnot, by setting it to an empty
> string?

No we don't.
	if (homehost && (!homehost[0] || strcasecmp(homehost, "<none>") =3D=3D 0))=
 {
		homehost =3D NULL;
		require_homehost =3D 0;
	}

(from 3.2.x, slightly different in 'master') so if *homehost would be nul,
homehost gets set to NULL.

I've applied your patch as-is.
Thanks,
NeilBrown

>=20
> /mjt
>=20
>=20
> >  		char buf[20];
> >  		char *hash =3D sha1_buffer(homehost,
> >  					 strlen(homehost),


--Sig_/+URC_ZLS0Fgn5PhE8bTTelO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUIRuNDnsnt1WYoG5AQLWcA/9Ed9WEPZewDFyzvcI+HHtyz+eEIquEGiW
VGwEul1R2CRu6lRDFbWAxN8d0pKzxDUgsZvVQgR9ljIikqViASiSwGp286aaZNB/
nyOP+kq/vI5C3X5FTzYMcPo/WtD3mLyZLlIPkXOnek7XmQj+n/tamgSNNpNxYR2E
t3uKd7z2BE4FMQDrjzLHyVPlM1WvQ/Ndnp38s3UqfmFthGLOc+TEuTNhIGf+u/tz
32qjidS7ukYUEf9wLEww4Z3aBiwMC5DQRu5jH1xWGwRZeyhMRBLtxAQqoHZQ7t0w
zLynQbRngBPjh80qIj1bUDabkVJsYkaxu8Y1zYC+Nc3zGhJQFmiEkRTTaqBl92FG
uGfEEw0dUhWLmv1qpNaSTYXgYelcm2lS9Z3YYj0q1SXtOQbUIeIznWRBsws6Y8VR
g98kUrKc3PGpyV3qnKkr3TQuNId+x1zMkavilx+c6Cpft4TednSEa/WYe3vR4NmL
r8NVvohzG2iJk4ZW/kpj+rL3qATG3pSuoU3qcSp03g+hgsoaNDSnWofNqZf5UTf4
12kzq/LTIMFh3F+45scBwlyPqJ7DVOTRQM7bmL/j2jNNfElytEPKPBh8S1wTE8eL
iRWudOTPB4yG9CQDyKph1YHrEE4+KLYCX6PWDzhb3Dp2kobv1zN4jLObG0/MdGDU
5OaqJiHHMHA=
=nbuT
-----END PGP SIGNATURE-----

--Sig_/+URC_ZLS0Fgn5PhE8bTTelO--
