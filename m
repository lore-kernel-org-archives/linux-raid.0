From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md/raid: only permit hot-add of compatible integrity profiles
Date: Thu, 14 Jan 2016 11:56:14 +1100
Message-ID: <87h9ih6ksx.fsf@notabene.neil.brown.name>
References: <874mei8bu8.fsf@notabene.neil.brown.name> <20160114000007.14556.8837.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20160114000007.14556.8837.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: stable-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: axboe@fb.com, Mike Snitzer <snitzer@redhat.com>, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org, keith.busch@intel.com, hch@lst.de
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 14 2016, Dan Williams wrote:

> It is not safe for an integrity profile to be changed while i/o is
> in-flight in the queue.  Prevent adding new disks or otherwise online
> spares to an array if the device has an incompatible integrity profile.
>
> The original change to the blk_integrity_unregister implementation in
> md, commmit c7bfced9a671 "md: suspend i/o during runtime
> blk_integrity_unregister" introduced an immediate hang regression.
>
> This policy of disallowing changes the integrity profile once one has
> been established is shared with DM.

Thanks Dan.  That looks like it should address the issues and seems to
make sense.
If it passes my smoke-testing I'll include it in my merge-window pull
request tomorrow.

NeilBrown


>
> Here is an abbreviated log from a test run that:
> 1/ Creates a degraded raid1 with an integrity-enabled device (pmem0s) [  =
 59.076127]
> 2/ Tries to add an integrity-disabled device (pmem1m) [   90.489209]
> 3/ Retries with an integrity-enabled device (pmem1s) [  205.671277]
>
> [   59.076127] md/raid1:md0: active with 1 out of 2 mirrors
> [   59.078302] md: data integrity enabled on md0
> [..]
> [   90.489209] md0: incompatible integrity profile for pmem1m
> [..]
> [  205.671277] md: super_written gets error=3D-5
> [  205.677386] md/raid1:md0: Disk failure on pmem1m, disabling device.
> [  205.677386] md/raid1:md0: Operation continuing on 1 devices.
> [  205.683037] RAID1 conf printout:
> [  205.684699]  --- wd:1 rd:2
> [  205.685972]  disk 0, wo:0, o:1, dev:pmem0s
> [  205.687562]  disk 1, wo:1, o:1, dev:pmem1s
> [  205.691717] md: recovery of RAID array md0
>
> Fixes: c7bfced9a671 ("md: suspend i/o during runtime blk_integrity_unregi=
ster")
> Cc: <stable@vger.kernel.org>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Reported-by: NeilBrown <neilb@suse.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/md/md.c        |   28 ++++++++++++++++------------
>  drivers/md/md.h        |    2 +-
>  drivers/md/multipath.c |    6 +++---
>  drivers/md/raid1.c     |    6 +++---
>  drivers/md/raid10.c    |    6 +++---
>  5 files changed, 26 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 61aacab424cf..b1e1f6b95782 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2017,28 +2017,32 @@ int md_integrity_register(struct mddev *mddev)
>  }
>  EXPORT_SYMBOL(md_integrity_register);
>=20=20
> -/* Disable data integrity if non-capable/non-matching disk is being adde=
d */
> -void md_integrity_add_rdev(struct md_rdev *rdev, struct mddev *mddev)
> +/*
> + * Attempt to add an rdev, but only if it is consistent with the current
> + * integrity profile
> + */
> +int md_integrity_add_rdev(struct md_rdev *rdev, struct mddev *mddev)
>  {
>  	struct blk_integrity *bi_rdev;
>  	struct blk_integrity *bi_mddev;
> +	char name[BDEVNAME_SIZE];
>=20=20
>  	if (!mddev->gendisk)
> -		return;
> +		return 0;
>=20=20
>  	bi_rdev =3D bdev_get_integrity(rdev->bdev);
>  	bi_mddev =3D blk_get_integrity(mddev->gendisk);
>=20=20
>  	if (!bi_mddev) /* nothing to do */
> -		return;
> -	if (rdev->raid_disk < 0) /* skip spares */
> -		return;
> -	if (bi_rdev && blk_integrity_compare(mddev->gendisk,
> -					     rdev->bdev->bd_disk) >=3D 0)
> -		return;
> -	WARN_ON_ONCE(!mddev->suspended);
> -	printk(KERN_NOTICE "disabling data integrity on %s\n", mdname(mddev));
> -	blk_integrity_unregister(mddev->gendisk);
> +		return 0;
> +
> +	if (blk_integrity_compare(mddev->gendisk, rdev->bdev->bd_disk) !=3D 0) {
> +		printk(KERN_NOTICE "%s: incompatible integrity profile for %s\n",
> +				mdname(mddev), bdevname(rdev->bdev, name));
> +		return -ENXIO;
> +	}
> +
> +	return 0;
>  }
>  EXPORT_SYMBOL(md_integrity_add_rdev);
>=20=20
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index ca0b643fe3c1..dfa57b41541b 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -657,7 +657,7 @@ extern void md_wait_for_blocked_rdev(struct md_rdev *=
rdev, struct mddev *mddev);
>  extern void md_set_array_sectors(struct mddev *mddev, sector_t array_sec=
tors);
>  extern int md_check_no_bitmap(struct mddev *mddev);
>  extern int md_integrity_register(struct mddev *mddev);
> -extern void md_integrity_add_rdev(struct md_rdev *rdev, struct mddev *md=
dev);
> +extern int md_integrity_add_rdev(struct md_rdev *rdev, struct mddev *mdd=
ev);
>  extern int strict_strtoul_scaled(const char *cp, unsigned long *res, int=
 scale);
>=20=20
>  extern void mddev_init(struct mddev *mddev);
> diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
> index 7331a80d89f1..0a72ab6e6c20 100644
> --- a/drivers/md/multipath.c
> +++ b/drivers/md/multipath.c
> @@ -257,6 +257,9 @@ static int multipath_add_disk(struct mddev *mddev, st=
ruct md_rdev *rdev)
>  			disk_stack_limits(mddev->gendisk, rdev->bdev,
>  					  rdev->data_offset << 9);
>=20=20
> +			err =3D md_integrity_add_rdev(rdev, mddev);
> +			if (err)
> +				break;
>  			spin_lock_irq(&conf->device_lock);
>  			mddev->degraded--;
>  			rdev->raid_disk =3D path;
> @@ -264,9 +267,6 @@ static int multipath_add_disk(struct mddev *mddev, st=
ruct md_rdev *rdev)
>  			spin_unlock_irq(&conf->device_lock);
>  			rcu_assign_pointer(p->rdev, rdev);
>  			err =3D 0;
> -			mddev_suspend(mddev);
> -			md_integrity_add_rdev(rdev, mddev);
> -			mddev_resume(mddev);
>  			break;
>  		}
>=20=20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index e2169ff6e0f0..c4b913409226 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1589,6 +1589,9 @@ static int raid1_add_disk(struct mddev *mddev, stru=
ct md_rdev *rdev)
>  	if (mddev->recovery_disabled =3D=3D conf->recovery_disabled)
>  		return -EBUSY;
>=20=20
> +	if (md_integrity_add_rdev(rdev, mddev))
> +		return -ENXIO;
> +
>  	if (rdev->raid_disk >=3D 0)
>  		first =3D last =3D rdev->raid_disk;
>=20=20
> @@ -1632,9 +1635,6 @@ static int raid1_add_disk(struct mddev *mddev, stru=
ct md_rdev *rdev)
>  			break;
>  		}
>  	}
> -	mddev_suspend(mddev);
> -	md_integrity_add_rdev(rdev, mddev);
> -	mddev_resume(mddev);
>  	if (mddev->queue && blk_queue_discard(bdev_get_queue(rdev->bdev)))
>  		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
>  	print_conf(conf);
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 84e597e1c489..ce959b4ae4df 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1698,6 +1698,9 @@ static int raid10_add_disk(struct mddev *mddev, str=
uct md_rdev *rdev)
>  	if (rdev->saved_raid_disk < 0 && !_enough(conf, 1, -1))
>  		return -EINVAL;
>=20=20
> +	if (md_integrity_add_rdev(rdev, mddev))
> +		return -ENXIO;
> +
>  	if (rdev->raid_disk >=3D 0)
>  		first =3D last =3D rdev->raid_disk;
>=20=20
> @@ -1739,9 +1742,6 @@ static int raid10_add_disk(struct mddev *mddev, str=
uct md_rdev *rdev)
>  		rcu_assign_pointer(p->rdev, rdev);
>  		break;
>  	}
> -	mddev_suspend(mddev);
> -	md_integrity_add_rdev(rdev, mddev);
> -	mddev_resume(mddev);
>  	if (mddev->queue && blk_queue_discard(bdev_get_queue(rdev->bdev)))
>  		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
>=20=20

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWlvIuAAoJEDnsnt1WYoG5j0MQALqrcs5sOjPTvORZ0CQwLHmF
/1SNB4PA3G3+Jf2mbKopKAMkS2UzvI+CMWPI631K5i35aO+r8rLsoPpbVABOeSSI
+SZrBnlFPMyOGKkvlov5XeevgB4Z87LEpRn3yqC4qxqGQKs2JGYoG0JlEtkSvr7/
Y4spQZBpG3XtbNjYjo9s7gKe6WzAKBAoypmWS79agx4VJOBGAwRBHNPlsY2klwdU
e1vf2W5LlFzlJBdeP47ZgYOXx3m1GshzeQSWpVQqdvUmsnC2jy7j9YSNg7GxCEOZ
wuCtC5n+4NSGv18C6tesLAVOYUtVYbD8UAH12PaCfarSJcvjLCyPVJ56pk/Ina3j
dXJ8StogGolADu52d5f+s0AubhCXrOPsVousXk5Sf5bu0bvFHU2ThqLPJCi9J6CY
X0jqD0QUgF2XfOCfq5tIDgqt7Fl6RiUs2AzHcy56XSUgnls1TjVAsps/YEP2ta6B
9I71mS9++6pO2BSKayFMbgk7bwLXwfURcy0f77uY5Tpw6EKtz0XHIwJizca+TfVQ
2a4lU0iKJX8GE4/C32eu4qPtGfZlbfBjBItEG4CRWl4h472w7PvtGUOcXiZnAGYz
t/HIirfJJMloYzxXZsUGZPDhy+UA5an6Cubd7VtFYb6digbpwEknm78eDut+a7Kh
dwy1znBDhnFQR81IW0ax
=OBv1
-----END PGP SIGNATURE-----
--=-=-=--
