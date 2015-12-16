From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] raid5-cache: add journal hot add/remove support
Date: Wed, 16 Dec 2015 12:14:46 +1100
Message-ID: <87r3inb3eh.fsf@notabene.neil.brown.name>
References: <48dfb85817d51f68d8da85368711ed14f945caa4.1450159900.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48dfb85817d51f68d8da85368711ed14f945caa4.1450159900.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 15 2015, Shaohua Li wrote:

> Add support for journal disk hot add/remove. Mostly trival checks in md
> part. The raid5 part is a little tricky. For hot-remove, we can't wait
> pending write as it's called from raid5d. The wait will cause deadlock.
> We simplily fail the hot-remove. A hot-remove retry can success
> eventually since if journal disk is faulty all pending write will be
> failed and finish. For hot-add, since an array supporting journal but
> without journal disk will be marked read-only, we are safe to hot add
> journal without stopping IO (should be read IO, while journal only
> handles write IO).
>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/md.c    | 44 +++++++++++++++++++++++++++++++++-----------
>  drivers/md/raid5.c | 31 +++++++++++++++++++++++--------
>  2 files changed, 56 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 807095f..de9e3a1 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2053,7 +2053,9 @@ static int bind_rdev_to_array(struct md_rdev *rdev,=
 struct mddev *mddev)
>=20=20
>  	/* make sure rdev->sectors exceeds mddev->dev_sectors */
>  	if (rdev->sectors && (mddev->dev_sectors =3D=3D 0 ||
> -			rdev->sectors < mddev->dev_sectors)) {
> +			rdev->sectors < mddev->dev_sectors) &&
> +	    !(test_bit(MD_HAS_JOURNAL, &mddev->flags) &&
> +	      test_bit(Journal, &rdev->flags))) {
>  		if (mddev->pers) {
>  			/* Cannot change size, so fail
>  			 * If mddev->level <=3D 0, then we don't care

This is (nearly) right, but it took me far too long to see that it was
right - and that makes it wrong.
If the end result was:

    /* make sure rdev->sectors exceeds mddev->dev_sectors for
     * non-journal devices
     */
   if (!test_bit(Journal, &rdev->flags) &&
       rdev->sectors &&
       (mddev->dev_sectors =3D=3D 0 || rdev->sectors < mddev->dev_sectors))=
 {
       .....

it would be a lot more obviously correct.  I removed the test on
MD_HAS_JOURNAL because it seems irrelevant.  We don't want to perform
that test on an rdev with Journal set whether MD_HAS_JOURNAL is set or
not.

=20=20=20=20

> @@ -2084,7 +2086,9 @@ static int bind_rdev_to_array(struct md_rdev *rdev,=
 struct mddev *mddev)
>  		}
>  	}
>  	rcu_read_unlock();
> -	if (mddev->max_disks && rdev->desc_nr >=3D mddev->max_disks) {
> +	if (mddev->max_disks && rdev->desc_nr >=3D mddev->max_disks &&
> +	    !(test_bit(MD_HAS_JOURNAL, &mddev->flags) &&
> +	     test_bit(Journal, &rdev->flags))) {
>  		printk(KERN_WARNING "md: %s: array is limited to %d devices\n",
>  		       mdname(mddev), mddev->max_disks);
>  		return -EBUSY;

Same here.  Removed the test on MD_HAS_JOURNAL is it is just confusing.
I wold prefer the test on Journal came first, but would accept having it
last if you prefer that.


> @@ -6031,8 +6035,25 @@ static int add_new_disk(struct mddev *mddev, mdu_d=
isk_info_t *info)
>  		else
>  			clear_bit(WriteMostly, &rdev->flags);
>=20=20
> -		if (info->state & (1<<MD_DISK_JOURNAL))
> +		if (info->state & (1<<MD_DISK_JOURNAL)) {
> +			struct md_rdev *rdev2;
> +			bool has_journal =3D false;
> +
> +			/* make sure no existing journal disk */
> +			rcu_read_lock();
> +			rdev_for_each(rdev2, mddev) {
> +				if (test_bit(Journal, &rdev2->flags)) {
> +					has_journal =3D true;
> +					break;
> +				}
> +			}
> +			rcu_read_unlock();
> +			if (has_journal) {
> +				export_rdev(rdev);
> +				return -EBUSY;
> +			}
>  			set_bit(Journal, &rdev->flags);
> +		}
>  		/*
>  		 * check whether the device shows up in other nodes
>  		 */

rcu_read_lock() isn't really needed here as we hold ->reconfig_mutex so
rdevs cannot disappear.
Maybe it is OK to leave it there as it costs almost nothing.  But maybe
it could lead other people to think RCU protection is needed in this
case, which is wrong....


> @@ -8162,19 +8183,20 @@ static int remove_and_add_spares(struct mddev *md=
dev,
>  			continue;
>  		if (test_bit(Faulty, &rdev->flags))
>  			continue;
> -		if (test_bit(Journal, &rdev->flags))
> -			continue;
> -		if (mddev->ro &&
> -		    ! (rdev->saved_raid_disk >=3D 0 &&
> -		       !test_bit(Bitmap_sync, &rdev->flags)))
> -			continue;
> +		if (!test_bit(Journal, &rdev->flags)) {
> +			if (mddev->ro &&
> +			    ! (rdev->saved_raid_disk >=3D 0 &&
> +			       !test_bit(Bitmap_sync, &rdev->flags)))
> +				continue;
>=20=20
> -		rdev->recovery_offset =3D 0;
> +			rdev->recovery_offset =3D 0;
> +		}
>  		if (mddev->pers->
>  		    hot_add_disk(mddev, rdev) =3D=3D 0) {
>  			if (sysfs_link_rdev(mddev, rdev))
>  				/* failure here is OK */;
> -			spares++;
> +			if (!test_bit(Journal, &rdev->flags))
> +				spares++;
>  			md_new_event(mddev);
>  			set_bit(MD_CHANGE_DEVS, &mddev->flags);
>  		}
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 704ef7f..f8f3d52 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7141,14 +7141,16 @@ static int raid5_remove_disk(struct mddev *mddev,=
 struct md_rdev *rdev)
>  	struct disk_info *p =3D conf->disks + number;
>=20=20
>  	print_raid5_conf(conf);
> -	if (test_bit(Journal, &rdev->flags)) {
> +	if (test_bit(Journal, &rdev->flags) && conf->log) {
>  		/*
> -		 * journal disk is not removable, but we need give a chance to
> -		 * update superblock of other disks. Otherwise journal disk
> -		 * will be considered as 'fresh'
> +		 * we can't wait pending write here, as this is called in
> +		 * raid5d, wait will deadlock.
>  		 */
> -		set_bit(MD_CHANGE_DEVS, &mddev->flags);
> -		return -EINVAL;
> +		if (atomic_read(&mddev->writes_pending))
> +			return -EBUSY;
> +		r5l_exit_log(conf->log);
> +		conf->log =3D NULL;
> +		return 0;

Failing with EBUSY if ->writes_pending is correct.
I wonder if extra care is needed when ->writes_pending is zero.
Note that for removing data devices, we set *rdevp to NULL,
call synchronize_rcu(), then check ->nr_pending and possibly restoring
the pointer.
This is because there is no other interlock between new writes arriving
and a device being removed.
The possible race would be that between the moment when
raid5_remove_disk tests ->writes_pending and when it sets conf->log to
NULL, a new write request comes in and gets as far as calling
r5_log_disk_error().
If r5l_log_disk_error() finds that ->log is not NULL, then
rl5_exit_log() in the other thread frees the log, and
r5l_log_disk_error() tests a bit in conf->log->rdev->flags, then it
could be accessing freed memory and anything could happen.

I think you need something like:

  log =3D conf->log;
  conf->log =3D NULL;
  synchronize_rcu();
  r5l_exit_log(log);

and then r5l_log_disk_error() should do:
   rcu_read_lock();
   log =3D rcu_dereference(conf->log);
   if (log)
      err =3D test_bit(Faulty, &log->rdev->flags);
   else
      err =3D test_bit(MD_HAS_JOURNAL, &conf->mddev->flags);
   rcu_read_unlock();
   return err;

The race is, admittedly, extremely unlikely.  But it is best to be safe,
especially with virtualised environments which can put unexpected delays
in strange places.

You could possibly use rcu_free() to free the log and avoid the
synchonize_rcu().=20

>  	}
>  	if (rdev =3D=3D p->rdev)
>  		rdevp =3D &p->rdev;
> @@ -7212,8 +7214,21 @@ static int raid5_add_disk(struct mddev *mddev, str=
uct md_rdev *rdev)
>  	int first =3D 0;
>  	int last =3D conf->raid_disks - 1;
>=20=20
> -	if (test_bit(Journal, &rdev->flags))
> -		return -EINVAL;
> +	if (test_bit(Journal, &rdev->flags)) {
> +		char b[BDEVNAME_SIZE];
> +		if (conf->log)
> +			return -EBUSY;
> +
> +		rdev->raid_disk =3D mddev->raid_disks;
> +		/*
> +		 * The array is in readonly mode if journal is missing, so no
> +		 * write requests running. We should be safe
> +		 */
> +		r5l_init_log(conf, rdev);
> +		printk(KERN_INFO"md/raid:%s: using device %s as journal\n",
> +		       mdname(mddev), bdevname(rdev->bdev, b));
> +		return 0;
> +	}

you'll need an "rcu_assign_pointer" in r5l_init_log() for the
   conf->log =3D log
to ensure proper ordering of memory writes.

And I'm a bit uncertain about setting rdev->raid_disk to
mddev->raid_disks.
I thought we decided that "Journal" devices had a different namespace
for raid_disk than data disks, so ->raid_disk of 0 was appropriate?
Setting the journal raid_disk to mddev->raid_disks might cause problems
when we ultimately support reshaping an array with a journal.


So: mostly good, but a few little issues to resolve.

Thanks,
NeilBrown

>  	if (mddev->recovery_disabled =3D=3D conf->recovery_disabled)
>  		return -EBUSY;
>=20=20
> --=20
> 2.4.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWcLsGAAoJEDnsnt1WYoG5DpcP/3cEbFaufTplho9eLQ7s7+1e
kjLLtLxPxze42dj3Zs2onddSkFn4ttBrXf+L/Jo2Lv3iY09Ex67BdQxJhCxpQqv2
WLUS5L/P3LPcsAHAHopbGaYsZxwMI/J8E5vMVdrrxtM9B8tkXHw1wyqQEN3Fpr5/
+0AXuyis1uh/sw2geeeJzC+RBq/eOoUGYY0JY26fhSpz1yx/rYGbjg2O5ESuwPsh
W5FAKJvaoWggbEV0wX68fARe+eQn6SXKXQcvwSfa+60x26rmRHRffy2ul4mOxNNI
8JH27wt0Qsno/ivNaZ3AWP0jYHuC+LuekzV36eJSgnqpnWEkwkKtbemn4myClh1S
SE4eDKjPgu2NXJU+9tnWCLELdQMGGAuuUyLRwhwgfcC0sYkXI1T58EXiQNuJZetG
PpeyFBK9MnoVQDxBWw7xnb3PjNqnk2caBZSfizNozh/7ZenpQ1jeh+Y/M2cF90lF
rYq7FXIz589++Ldm77FSVUa2dAVTPpSNkWp9W6TnIgSIm8Gulb8k/v84O1W265V6
AmW+sRwudO1pML1NeXQjjbk+NqjbQMTWkf//uPaP+U3hmQjN+WzA9Q2dx9ZjDxSP
UO4YTeMpvJGSwp6Ma2Fvwutp8gP4mjaZOic5280Yfz8kiFN9NeyrEWDN6Tl5vehc
ia/jYCmCg6sZ6zxaSvSL
=XFe7
-----END PGP SIGNATURE-----
--=-=-=--
