From: NeilBrown <neilb@suse.de>
Subject: Re: [patch v2]raid5: fix directio regression
Date: Wed, 15 Aug 2012 10:56:10 +1000
Message-ID: <20120815105610.74fe418e@notabene.brown>
References: <20120807032240.GA22495@kernel.org>
	<201208071312593120932@gmail.com>
	<CANejiEUQcA6X75WG0xSgSv6NAQaBQnwpDD-5QaNVbqmo-oqLsA@mail.gmail.com>
	<201208071421033759628@gmail.com>
	<CANejiEVoOprAFoS6mCVYDJKh+nbGE0=7Xw_CpVS+Z9AcUoh6RQ@mail.gmail.com>
	<201208081321202343795@gmail.com>
	<CANejiEWC5ZKWT2L4DM-bfGi+v=TpkABruQqe5h0qG4oQg9sDhw@mail.gmail.com>
	<201208090919591567972@gmail.com>
	<20120809113230.152aade3@notabene.brown>
	<CANejiEX1TKG_KhAsgUauHaCe2GE7jU1ozD-3c21VFgrm9COajQ@mail.gmail.com>
	<20120814063343.GA30353@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/BB0u5h3W8JP3KWZxf2nc2Q9"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120814063343.GA30353@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Jianpeng Ma <majianpeng@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-Id: linux-raid.ids

--Sig_/BB0u5h3W8JP3KWZxf2nc2Q9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 14 Aug 2012 14:33:43 +0800 Shaohua Li <shli@kernel.org> wrote:

> On Thu, Aug 09, 2012 at 01:07:01PM +0800, Shaohua Li wrote:
> > 2012/8/9 NeilBrown <neilb@suse.de>:
> > > On Thu, 9 Aug 2012 09:20:05 +0800 "Jianpeng Ma" <majianpeng@gmail.com=
> wrote:
> > >
> > >> On 2012-08-08 20:53 Shaohua Li <shli@kernel.org> Wrote:
> > >> >2012/8/8 Jianpeng Ma <majianpeng@gmail.com>:
> > >> >> On 2012-08-08 10:58 Shaohua Li <shli@kernel.org> Wrote:
> > >> >>>2012/8/7 Jianpeng Ma <majianpeng@gmail.com>:
> > >> >>>> On 2012-08-07 13:32 Shaohua Li <shli@kernel.org> Wrote:
> > >> >>>>>2012/8/7 Jianpeng Ma <majianpeng@gmail.com>:
> > >> >>>>>> On 2012-08-07 11:22 Shaohua Li <shli@kernel.org> Wrote:
> > >> >>>>>>>My directIO randomwrite 4k workload shows a 10~20% regression=
 caused by commit
> > >> >>>>>>>895e3c5c58a80bb. directIO usually is random IO and if request=
 size isn't big
> > >> >>>>>>>(which is the common case), delay handling of the stripe hasn=
't any advantages.
> > >> >>>>>>>For big size request, delay can still reduce IO.
> > >> >>>>>>>
> > >> >>>>>>>Signed-off-by: Shaohua Li <shli@fusionio.com>
> > >> >>>> [snip]
> > >> >>>>>>>--
> > >> >>>>>> May be used size to judge is not a good method.
> > >> >>>>>> I firstly sended this patch, only want to control direct-writ=
e-block,not for reqular file.
> > >> >>>>>> Because i think if someone used direct-write-block for raid5,=
he should know the feature of raid5 and he can control
> > >> >>>>>> for write to full-write.
> > >> >>>>>> But at that time, i did know how to differentiate between reg=
ular file and block-device.
> > >> >>>>>> I thik we should do something to do this.
> > >> >>>>>
> > >> >>>>>I don't think it's possible user can control his write to be a
> > >> >>>>>full-write even for
> > >> >>>>>raw disk IO. Why regular file and block device io matters here?
> > >> >>>>>
> > >> >>>>>Thanks,
> > >> >>>>>Shaohua
> > >> >>>> Another problem is the size. How to judge the size is large or =
not?
> > >> >>>> A syscall write is a dio and a dio may be split more bios.
> > >> >>>> For my workload, i usualy write chunk-size.
> > >> >>>> But your patch is judge by bio-size.
> > >> >>>
> > >> >>>I'd ignore workload which does sequential directIO, though
> > >> >>>your workload is, but I bet no real workloads are. So I'd like
> > >> >> Sorry,my explain maybe not corcrect. I write data once which size=
 is almost chunks-size * devices,in order to full-write
> > >> >> and as possible as to no pre-read operation.
> > >> >>>only to consider big size random directio. I agree the size
> > >> >>>judge is arbitrary. I can optimize it to be only consider stripe
> > >> >>>which hits two or more disks in one bio, but not sure if it's
> > >> >>>worthy doing. Not ware big size directio is common, and even
> > >> >>>is, big size request IOPS is low, a bit delay maybe not a big
> > >> >>>deal.
> > >> >> If add a acc_time for 'striep_head' to control?
> > >> >> When get_active_stripe() is ok, update acc_time.
> > >> >> For some time, stripe_head did not access and it shold pre-read.
> > >> >
> > >> >Do you want to add a timer for each stripe? This is even ugly.
> > >> >How do you choose the expire time? A time works for harddisk
> > >> >definitely will not work for a fast SSD.
> > >> A time is like the size which is arbitrary.
> > >> How about add a interface in sysfs to control by user?
> > >> Only user can judge the workload, which sequatial write or random wr=
ite.
> > >
> > > This is getting worse by the minute.  A sysfs interface for this is
> > > definitely not a good idea.
> > >
> > > The REQ_NOIDLE flag is a pretty clear statement that no more requests=
 that
> > > merge with this one are expected.  If some use cases sends random req=
uests,
> > > maybe it should be setting REQ_NOIDLE.
> > >
> > > Maybe someone should do some research and find out why WRITE_ODIRECT =
doesn't
> > > include REQ_NOIDLE.  Understanding that would help understand the cur=
rent
> > > problem.
> >=20
> > A quick search shows only cfq-iosched uses REQ_NOIDLE. In
> > cfq, a queue is idled to avoid losing its share. REQ_NOIDLE
> > tells cfq to avoid idle, since the task will not dispatch further
> > requests any more. Note this isn't no merge.
>=20
> Since REQ_NOIDLE has no relationship with request merge, we'd better remo=
ve it.
> I came out a new patch, which doesn't depend on request size any more. Wi=
th
> this patch, sequential directio will still introduce unnecessary raid5 pr=
eread
> (especially for small size IO), but I bet no app does sequential small si=
ze
> directIO.
>=20
> Thanks,
> Shaohua
>=20
> Subject: raid5: fix directio regression
>=20
> My directIO randomwrite 4k workload shows a 10~20% regression caused by c=
ommit
> 895e3c5c58a80bb. This commit isn't friendly for small size random IO, bec=
ause
> delaying such request hasn't any advantages.
>=20
> DirectIO usually is random IO. I thought we can ignore request merge betw=
een
> bios from different io_submit. So we only consider one bio which can drive
> unnecessary preread in raid5, which is large request. If a bio is large e=
nough
> and some of its stripes will access two or more disks, such stripes shoul=
d be
> delayed to avoid unnecessary preread till bio for the last disk of the st=
rips
> is added.
>=20
> REQ_NOIDLE doesn't mean about request merge, I deleted it.

Hi,
 Have you tested what effect this has on large sequential direct writes?
 Because it don't make sense to me and I would be surprised if it improves
 things.

 You are delaying setting the STRIPE_PREREAD_ACTIVE bit until you think you
 have submitted all the writes from this bio that apply to the give stripe.
 That does make some sense, however it doesn't seem to deal with the
 possibility that the one bio covers parts of two different stripes.  In th=
at
 case the first stripe never gets STRIPE_PREREAD_ACTIVE set, so it is delay=
ed
 despite having 'REQ_SYNC' set.

 Also, and more significantly, plugging should mean that the various
 stripe_heads are not even looked at until all of the original bio is
 processed, so while STRIPE_PREREAD_ACTIVE might get set early, it should n=
ot
 get processed until the whole bio is processed and the queue is unplugged.

 So I don't think this patch should make a difference on large direct write=
s,
 and if it does then something strange is going on that I'd like to
 understand first.

 I suspect that the original patch should be reverted because while it does
 improve one case, it causes a regression in another and regressions should
 be avoided.  It would be nice to find a way for both to go fast though...

Thanks,
NeilBrown


>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  drivers/md/raid5.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>=20
> Index: linux/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.c	2012-08-13 15:03:16.479473326 +0800
> +++ linux/drivers/md/raid5.c	2012-08-14 11:10:37.335982170 +0800
> @@ -4076,6 +4076,7 @@ static void make_request(struct mddev *m
>  	struct stripe_head *sh;
>  	const int rw =3D bio_data_dir(bi);
>  	int remaining;
> +	int chunk_sectors;
> =20
>  	if (unlikely(bi->bi_rw & REQ_FLUSH)) {
>  		md_flush_request(mddev, bi);
> @@ -4089,6 +4090,11 @@ static void make_request(struct mddev *m
>  	     chunk_aligned_read(mddev,bi))
>  		return;
> =20
> +	if (mddev->new_chunk_sectors < mddev->chunk_sectors)
> +		chunk_sectors =3D mddev->new_chunk_sectors;
> +	else
> +		chunk_sectors =3D mddev->chunk_sectors;
> +
>  	logical_sector =3D bi->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
>  	last_sector =3D bi->bi_sector + (bi->bi_size>>9);
>  	bi->bi_next =3D NULL;
> @@ -4192,7 +4198,8 @@ static void make_request(struct mddev *m
>  			finish_wait(&conf->wait_for_overlap, &w);
>  			set_bit(STRIPE_HANDLE, &sh->state);
>  			clear_bit(STRIPE_DELAYED, &sh->state);
> -			if ((bi->bi_rw & REQ_NOIDLE) &&
> +			if ((bi->bi_rw & REQ_SYNC) &&
> +			    (last_sector - logical_sector < chunk_sectors) &&
>  			    !test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
>  				atomic_inc(&conf->preread_active_stripes);
>  			release_stripe_plug(mddev, sh);


--Sig_/BB0u5h3W8JP3KWZxf2nc2Q9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUCrzqjnsnt1WYoG5AQLEeQ/+O2V0+VB5tNb2w8bKxWMxEdWpuN/TXmqb
XKVGiS7mCwJUhOY7tx3bWUuK4QJv23h4Dx4mUn0NU7OsQiIc4saTue4Fr3Anco+J
TBxZmQKM3Wy33J/WRoucIDM2RSpa+rP24m0HwPcH31w30JGZPli5DRAAGOXgTfCW
BvI6WJ/jPbqSJ15ZF+KhbXPow8SNHTmiaft3vWR3V0UGp912PfyocLd6kwVuT0wo
HcAeB0GyO77rYcyzRUQNkqqKDnjepYe2Y59I3IZvohA2sPdsTNLNTmv2omSHXXzQ
83MNoGaegp5yOl9e+Fs33oJ2un1+dNIPeDIUBci78YfkZvTbDDJ5OnT4xJ5sDtT9
YUXyWpb7e3eftJUrpGHOGPabJxptSEM/Ea5Q9Ps0mRTImhHW7EkogSDmpkISu0f8
04lV4c610c0rzjtsykWPUFP+c6W7L5xD5C44PLWaIeMALLjKnEDZLi//quXykMVK
Scu04ZnOWzyT2zwIUaIT5eaJSd32rAh7HSJc6RPz6uS49OYeWyLnGKaBTms1OTnR
agy6AMUzkTrkA5HGrvYcgVIhcQyN+gbTLjBqvhC6BHBQknx8vuv2a0+4lPqbRK11
+/wcw39s3rb+wGs92YA4VYGK0yOzouVZ1gIzX5WqIfo/gEjTU4TYK0N5a8tCfLXu
SU6x/TZMW4M=
=GpWQ
-----END PGP SIGNATURE-----

--Sig_/BB0u5h3W8JP3KWZxf2nc2Q9--
