From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 3/3] md/raid5: per hash value and exclusive
 wait_for_stripe
Date: Thu, 14 May 2015 16:09:15 +1000
Message-ID: <20150514160915.58dcd4e5@notabene.brown>
References: <1430275735-20290-1-git-send-email-yuanhan.liu@linux.intel.com>
	<1430275735-20290-3-git-send-email-yuanhan.liu@linux.intel.com>
	<20150514154511.26b74f5b@notabene.brown>
	<20150514055508.GJ3124@yliu-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/pPbr=yFbxU4=CFC3s7CWoi9"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150514055508.GJ3124@yliu-dev.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/pPbr=yFbxU4=CFC3s7CWoi9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 14 May 2015 13:55:08 +0800 Yuanhan Liu <yuanhan.liu@linux.intel.com>
wrote:

> On Thu, May 14, 2015 at 03:45:11PM +1000, NeilBrown wrote:
> > On Wed, 29 Apr 2015 10:48:55 +0800 Yuanhan Liu <yuanhan.liu@linux.intel=
.com>
> > wrote:
> >=20
> > > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > > index 64d5bea..697d77a 100644
> > > --- a/drivers/md/raid5.c
> > > +++ b/drivers/md/raid5.c
> > > @@ -344,7 +344,8 @@ static void release_inactive_stripe_list(struct r=
5conf *conf,
> > >  					 int hash)
> > >  {
> > >  	int size;
> > > -	bool do_wakeup =3D false;
> > > +	unsigned long do_wakeup =3D 0;
> > > +	int i =3D 0;
> > >  	unsigned long flags;
> > > =20
> > >  	if (hash =3D=3D NR_STRIPE_HASH_LOCKS) {
> > > @@ -365,15 +366,19 @@ static void release_inactive_stripe_list(struct=
 r5conf *conf,
> > >  			    !list_empty(list))
> > >  				atomic_dec(&conf->empty_inactive_list_nr);
> > >  			list_splice_tail_init(list, conf->inactive_list + hash);
> > > -			do_wakeup =3D true;
> > > +			do_wakeup |=3D 1 << (size - 1);
> > >  			spin_unlock_irqrestore(conf->hash_locks + hash, flags);
> > >  		}
> > >  		size--;
> > >  		hash--;
> > >  	}
> > > =20
> > > +	for (i =3D 0; i < NR_STRIPE_HASH_LOCKS; i++) {
> > > +		if (do_wakeup & (1 << i))
> > > +			wake_up(&conf->wait_for_stripe[i]);
> > > +	}
> > > +
> >=20
> > hi,
> >  I've been doing some testing and got a lock-up in resize_stripes, wait=
ing
> >  on wait_for_stripe[].
> >=20
> >  Looking at the above code,  I think
> >       do_wakeup |=3D 1 << (size - 1);
> >  should be
> >       do_wakeup |=3D 1 << hash;
> >=20
> >  do you agree?  Or am I missing something?
>=20
> Right. Sorry for the careless mistake.

Thanks for confirming.
Mistakes happen - that's why we test :-)

I've merged that fix into your patch.

NeilBrown

--Sig_/pPbr=yFbxU4=CFC3s7CWoi9
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVVQ8DDnsnt1WYoG5AQKCtBAAqWXiPy7fktwKvU3A6fU94EtAfLpdPG3M
eJKudzTHNUEm9Fs7pm0Sz3+jM2CRqUCOPuKJKZUY9DPi2iEpCcZnDIN0LkseTPUR
cos/xMOs1cISPjDVtkgdVXaNgwgj/2YG0X/kRy3FVD4qhAqf0Ocv6JgJDIePRBZm
elo8KSveBixXkj+HhEZAwsjPRwtkePSWIQcuhEzsG/tsH58+KCPYWInbVS42GD5s
tKBGu/FEIwXxgq0zvnIMFlHxc6EJc6WkyNGHK7efrRwp6FOlE2aWwKBMMb2ZOqbp
8qBk4/93dWG4m/89zES+BeISSLlz/nfE4X3fw3yWqsr3mrGj5tll+I6U+PkiYvc3
tosemY0/SmLjL+EvpNR6ARiGB5+mXb8RGGWYJBaTVPQRhJkSrRqMF+OyV1u86nns
bK0eZ8A4T8JuPDGCGfleB2LY4hWvwCad/etcjR8R3N6NH4ql9YLgmwhN+L0aRWXZ
+60KKA4/AQWxTa3d8dViESacMnN07hvbcPbS1EEdwITdC4kUGT7XE5weROhr200G
z7foa5I53NnvOuVk2nrnWy/uleL/v09uDsUPIxl6b9k8daJozgLgCUzavP9+YQSU
Fje98tJnCSS5mnOTaCjr/o01EZAdnigud7Js01PNxhQhq/KdUkRTwRRF9W4O/Jnb
cTSEc71OJPo=
=AhXu
-----END PGP SIGNATURE-----

--Sig_/pPbr=yFbxU4=CFC3s7CWoi9--
