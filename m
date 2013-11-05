From: "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
Subject: RE: [PATCH] raid0: Set discard_granularity to correct value after
 reshape.
Date: Tue, 5 Nov 2013 14:25:19 +0000
Message-ID: <84A53BEA6EAC69439B7E311E9B17A76F01783D0B@IRSMSX105.ger.corp.intel.com>
References: <20131030122022.20862.97997.stgit@gklab-154-222.igk.intel.com>
 <20131031111612.2735d0c1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20131031111612.2735d0c1@notabene.brown>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "shli@kernel.org" <shli@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday, October 31, 2013 1:16 AM NeilBrown <neilb@suse.de> wrote:
> On Wed, 30 Oct 2013 13:20:22 +0100 Pawel Baldysiak
> <pawel.baldysiak@intel.com> wrote:
>=20
> > In case of reshape of raid0 through raid4 a value of
> > discard_granularity will be set to stripe size. MD driver should
> > re-set this value to correct one when migration will be finished.
> > Otherwise array will be left with wrong value and discard operation=
s will not
> work properly.
> >
> > Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> > Cc: Shaohua Li <shli@kernel.org>
> > ---
> >  drivers/md/raid0.c |    2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c index
> > c4d420b..807ca3a 100644
> > --- a/drivers/md/raid0.c
> > +++ b/drivers/md/raid0.c
> > @@ -266,6 +266,8 @@ static int create_strip_zones(struct mddev *mdd=
ev,
> struct r0conf **private_conf)
> >  	}
> >  	mddev->queue->backing_dev_info.congested_fn =3D raid0_congested;
> >  	mddev->queue->backing_dev_info.congested_data =3D mddev;
> > +	mddev->queue->limits.discard_granularity =3D
> > +			queue_logical_block_size(mddev->queue);
> >
> >  	/*
> >  	 * now since we have the hard sector sizes, we can make sure
>=20
> Thanks, but this doesn't seem like the right sort of fix.  It is to s=
pecific to the
> symptom rather than trying to address the underlying problem.
>=20
> Maybe something like this?  Can you review and test?
>=20
> Thanks,
> NeilBrown
>=20
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c index
> 628cd529343f..740b6340f980 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -3620,6 +3620,7 @@ level_store(struct mddev *mddev, const char
> *buf, size_t len)
>  		mddev->in_sync =3D 1;
>  		del_timer_sync(&mddev->safemode_timer);
>  	}
> +	blk_set_stacking_limit(&mddev->queue->limits);
>  	pers->run(mddev);
>  	set_bit(MD_CHANGE_DEVS, &mddev->flags);
>  	mddev_resume(mddev);
Hi Neil,
I have tested Yours patch, and everything works well.
TRIM operation are made correctly.
Could You apply it to upstream?=20

BTW. Correct name of this function is blk_set_stacking_limits();

Thanks,
Pawe=B3 Baldysiak
