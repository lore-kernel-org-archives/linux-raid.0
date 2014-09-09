From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Create.c: Try few more times to stop array after failed
 creation
Date: Tue, 9 Sep 2014 20:16:43 +1000
Message-ID: <20140909201643.27697aa8@notabene.brown>
References: <20140905142612.10761.82358.stgit@gklab-154-222.intel.com>
	<20140908163337.6129ef3e@notabene.brown>
	<84A53BEA6EAC69439B7E311E9B17A76F1A69724E@IRSMSX110.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/mwYe5owCtdQRFYZym0IJKDH"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <84A53BEA6EAC69439B7E311E9B17A76F1A69724E@IRSMSX110.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

--Sig_/mwYe5owCtdQRFYZym0IJKDH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 9 Sep 2014 10:04:38 +0000 "Baldysiak, Pawel"
<pawel.baldysiak@intel.com> wrote:

> > On: Monday, September 08, 2014 8:34 AM NeilBrown wrote:
> > To: Baldysiak, Pawel
> > Cc: linux-raid@vger.kernel.org; Paszkiewicz, Artur
> > Subject: Re: [PATCH] Create.c: Try few more times to stop array after f=
ailed
> > creation
> >=20
> > On Fri, 05 Sep 2014 16:26:13 +0200 Pawel Baldysiak
> > <pawel.baldysiak@intel.com> wrote:
> >=20
> > > Sometimes after failure in creation (exp. due to duplicate devices in
> > > create command) newly created empty md array will not be stopped due
> > > to openers>1 (create_mddev will not manage to drop lock).
> > > In this case ioctl() will return error - this needs to be checked and
> > > if occurs - sending STOP_ARRAY should be repeat after delay to make
> > > sure that mddev is stopped correctly.
> > >
> > > Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> > > ---
> > >  Create.c |    7 ++++++-
> > >  1 file changed, 6 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/Create.c b/Create.c
> > > index 330c5b4..7c8e53e 100644
> > > --- a/Create.c
> > > +++ b/Create.c
> > > @@ -904,7 +904,12 @@ int Create(struct supertype *st, char *mddev,
> > >  				if (st->ss->add_to_super(st, &inf->disk,
> > >  							 fd, dv->devname,
> > >  							 dv->data_offset)) {
> > > -					ioctl(mdfd, STOP_ARRAY, NULL);
> > > +					int count =3D 5;
> > > +					while (count &&
> > > +					       (ioctl(mdfd, STOP_ARRAY, NULL)
> > < 0)) {
> > > +						usleep(100000);
> > > +						count--;
> > > +					}
> > >  					goto abort_locked;
> > >  				}
> > >  				st->ss->getinfo_super(st, inf, NULL);
> >=20
> > I don't like this.  I don't really like any of the other loops like thi=
s that are
> > already in the code either.  I wonder if we can avoid the need for it.
> >=20
> > Given that the array hasn't been started yet, no other process can actu=
ally be
> > *using* the array.  And given that we have an O_EXCL open at this point=
, no
> > other process can be trying to stop/start the array.
> > So it should be safe to change the kernel to not fail in this situation.
> >=20
> > If you apply this kernel patch:
> >=20
> > diff --git a/drivers/md/md.c b/drivers/md/md.c index
> > 1294238610df..1bf3fe1ecc79 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -5362,7 +5362,7 @@ static int do_md_stop(struct mddev * mddev, int
> > mode,
> >  	mddev_lock_nointr(mddev);
> >=20
> >  	mutex_lock(&mddev->open_mutex);
> > -	if (atomic_read(&mddev->openers) > !!bdev ||
> > +	if ((mddev->pers && atomic_read(&mddev->openers) > !!bdev) ||
> >  	    mddev->sysfs_active ||
> >  	    mddev->sync_thread ||
> >  	    (bdev && !test_bit(MD_STILL_CLOSED, &mddev->flags))) {
> >=20
> >=20
> > does that fir your problem?  Can you see any reason not to allow
> > STOP_ARRAY to succeed in this situation?
> >=20
> Hi Neil
> Thanks for your answer.
> To fix this problem same thing needs to be added in one more place in ker=
nel:
>=20
> @@ -6454,7 +6454,7 @@ static int md_ioctl(struct block_device *bdev, fmod=
e_t mode,
>  		 * and writes
>  		 */
>  		mutex_lock(&mddev->open_mutex);
> -		if (atomic_read(&mddev->openers) > 1) {
> +		if (mddev->pers && (atomic_read(&mddev->openers) > 1)) {
>  			mutex_unlock(&mddev->open_mutex);
>  			err =3D -EBUSY;
>  			goto abort;
>=20
> Should I prepare the patch, or you can do it?

I'll do it thanks - I have it half done already.

Thanks for testing.

NeilBrown

--Sig_/mwYe5owCtdQRFYZym0IJKDH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVA7Tiznsnt1WYoG5AQKNPA/6Akkr7xKAvWKuRDH6Y6kI4zWEHyUfHgoK
yamHIt5dMNXwHEO5NUE+mSCt63TLGhQZ8QnPmmIn4lMfhjL/Js1MSsVZM3xvN9b7
u+2yvGeRvR1Hg0xITQMQUphrynM3koTxTt9kANIOe8wp/s+nxJuzI4bRRUIOA03Y
NFKZgtGZbjUmi0AjL4pfvoN21/HAoO7vLZ09oSjeaYb/w1NCAmIRPwE5R60Li+Gg
4gNdY1XDKCmZAXQsZZkjgqwpoNnAzCO/yJRsa3fpkEUlH/FkD9F364LNOn6UVpJt
RA/DOqPKXNQfK2hwdTnoZYwYVp92P6cn4W+qRmymkPCQABOX867W5e+PNE6yzpou
X72bIkphO21t80CQ27wn1m2LuflQphmLWgnqI71zWnFh+h7gdeiicufVgs4dr+iP
nbOJkxd4BjxkkhSXK8pOnAZWuoVJ2Qst8CUXdhiZL2U80rbPTVtS1W0AOaNKDRsn
zx90rK0oVZTbvKyWGnInnGx4NiuG6QcXgaKUwqpr9BVRd66p9SLS2sgCy7SY6gLU
T4yANldRFrF3xjvZh/vq6xC+LDQHNB82rJ6Y0ry9xw1Alkk2UQJHUSDxRFy83xCq
avNXhHnMduYZ4qaqp6Kt7M0R1/c0yCPBtb9nWKEVD8zJlbMu2F+1k+2UOv4YuOVd
zUEW4EcbwmI=
=cSBo
-----END PGP SIGNATURE-----

--Sig_/mwYe5owCtdQRFYZym0IJKDH--
