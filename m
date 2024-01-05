Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82EC22E824
	for <linux-raid@vger.kernel.org>; Fri,  5 Jan 2024 15:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c+WMV25l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704468146; x=1736004146;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZV6f7dSSa5UxOLp/+oWBt2MCErEkE1nsKmKCF80bg58=;
  b=c+WMV25lbnTYMOs0wJqbrK2p/gbJtHW80HH5y1fIOMdqG2SCez+laYmZ
   6ziasYLSRFQnHsPYKNQiOBOM7JcrCl9oWzgxQgRfmGkBo3WeeHVofppdm
   IvNLO3RIKURTUsbuGjEaF0BvcApWUi6atPxjozO9DgFTUEx8PPG5mRxHY
   6H7yb/j+U3syl5nSqgkGsj+/bYSLU9jD5Bg7ejtbWjqurcUHeptQWh7hY
   PN1mgMlbPsqZ8C8tK87yZYUj3g9kGKt+FUjPwXHD37PHNksNsDSofPQ7s
   do4yIf5WRlPSRqERZAVzdpRJE6Ij4xtq8Jzi5Tr2qRSS9Oc2wrLwaiKTq
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10944"; a="4892338"
X-IronPort-AV: E=Sophos;i="6.04,334,1695711600"; 
   d="scan'208";a="4892338"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2024 07:22:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10944"; a="730491142"
X-IronPort-AV: E=Sophos;i="6.04,334,1695711600"; 
   d="scan'208";a="730491142"
Received: from bmccuske-mobl1.amr.corp.intel.com (HELO peluse-desk5) ([10.213.173.203])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2024 07:22:24 -0800
Date: Fri, 5 Jan 2024 08:22:23 -0700
From: Paul E Luse <paul.e.luse@linux.intel.com>
To: song@kernel.org
Cc: linux-raid@vger.kernel.org
Subject: Re: [PATCH] md/raid1: round robin disk selection for large
 sequential reads
Message-ID: <20240105081949.62a228d8@peluse-desk5>
In-Reply-To: <20240102125115.129261-1-paul.e.luse@linux.intel.com>
References: <20240102125115.129261-1-paul.e.luse@linux.intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; aarch64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue,  2 Jan 2024 05:51:15 -0700
paul luse <paul.e.luse@linux.intel.com> wrote:

> Hi Everyone,
>=20
> I=E2=80=99m sending this out as an RFC with some comments below.  Hope
> that=E2=80=99s OK, note that this is my first patch for mdraid but the
> first time I=E2=80=99ve ever even looked at any of the code so please
> keep that in mind :) Would be great if others had a chance to
> test on their setups with their favorite disks or if you have
> disk manufacturer/model suggestions please me know.
>=20
> Quick background: A colleague of mine ran a short test with
> biotop running random reads on a 2 disk array and noticed an
> approximate 70/30 distribution of reads between the 2 drives.
> He asked me if the was normal and, not knowing this RAID stack,
> I said I don=E2=80=99t know but I=E2=80=99ll have a look.  As a quick hac=
k I
> threw out pretty much the whole function and forced a 50/50
> distribution on got impressive gains on large sequential IO, it
> was enough that I decided to start working on it for real.
>=20
> This RFC patch adds more complexity to an already fairly complex
> function I think but I don=E2=80=99t see a simple refactor and most of
> the additions are compartmentalized at the end.  The concept is
> simple, round robin the available disks on sequential reads
> (doesn=E2=80=99t work well for non-sequential) switching to the next disk
> after a specified number of bytes have been read from the current
> disk (empirically determined).  To reduce testing the patch only
> supports doing round robin selection for 2 mirror sets or less.
> More could be supported likely adjusting the threshold for moving
> to the next disk based on the number of mirrors.
>=20
> Additionally, I think I can optimize the read/write mix cases as
> well but didn=E2=80=99t want to hold off any longer on getting the RFC ou=
t.
>=20
> I am also gathering more performance data on other drivs.  Here is
> what I have available now on Google Photos:
>=20
> Kioxia CM7: https://photos.app.goo.gl/TpS8wH1rCtnwLVLw9
> Intel P5520: https://photos.app.goo.gl/zGBPFT7mJCXdoU8h6
> Samsung MZ: https://photos.app.goo.gl/GmJrBDNQyDuY7diQ6
>=20
> Comments:
>=20
> * There a subtle bug fix in here that if everyone agrees on the
> patch direction I=E2=80=99ll break it out into a separate patch.  We used
> to set R1BIO_FailFast without really knowing if there is more than
> 1 available disks.  Discussed this on slack, it=E2=80=99s fairly clear. To
> fix this, there are no more breaks in the loop, we always loop
> through all disks counting available ones and storing key parameters
> that were set to their last value as a result of the break.
>=20
> * This patch also needs the =E2=80=9Cloop through all disks=E2=80=9D fix =
above
> because we can=E2=80=99t round robin unless we know we have enough disks
>=20
> * There=E2=80=99s a potential bug in the sequential condition, I removed =
the
> entire block of code as it=E2=80=99s no longer relevant with the round ro=
bin
> logic (the section about choose_next_idle).  This was discussed a
> bit on slack, there was a questionable comparison
> `mirror->next_seq_sect > opt_iosize`
>=20
> * There=E2=80=99s nothing really tricky going on here, the one thing that
> might not be super obvious is how we round robin, we start on the
> current disk and store it=E2=80=99s index in the mirrors[] array so that =
we
> can find the next one on the next call to read_balance.  We have to
> select the index into the array as opposed to `best_disk` as that can
> be at any position in the array depending on the state of the array.
>=20
> thanks,
> Paul

FYI I"m withdrawing this patch for consideration after much discussion
on Slack. As noted in my commit message I was hesitant to add more
complexity to and already complex function but wanted to get the ball
rolling with regards making some improvements in this area.

Kwai Yu and I will be working together to submit a series of patches
that refactors read_balance() while also incorporates the round robin
logic in this patch.  We'll also follow up with patches to improve
performance around concurrency and possibly some other areas as well.

If you are an active developer and not on Slack please let either
myself or Song know and we'll get you an invite.

Note that Slack is not a replacement for code reviews, those should
always happen via email but it a great place to collaborate and discuss
issues with existing code, new ideas, performance topics, testing, etc.

-Paul



>=20
> Signed-off-by: paul luse <paul.e.luse@linux.intel.com>
> ---
>  drivers/md/raid1.c | 107
> +++++++++++++++++++++++++++++++-------------- drivers/md/raid1.h |
> 6 +++ 2 files changed, 79 insertions(+), 34 deletions(-)
>=20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index aaa434f0c175..3ecb90a29053 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -596,6 +596,9 @@ static sector_t
> align_to_barrier_unit_end(sector_t start_sector, *
>   * The rdev for the device selected will have nr_pending incremented.
>   */
> +#define MAX_RR_DISKS 3
> +#define RR_16K_IN_SECS 0x20
> +#define RR_128K_IN_SECS 0x100
>  static int read_balance(struct r1conf *conf, struct r1bio *r1_bio,
> int *max_sectors) {
>  	const sector_t this_sector =3D r1_bio->sector;
> @@ -608,7 +611,9 @@ static int read_balance(struct r1conf *conf,
> struct r1bio *r1_bio, int *max_sect unsigned int min_pending;
>  	struct md_rdev *rdev;
>  	int choose_first;
> -	int choose_next_idle;
> +	int avail_disk[MAX_RR_DISKS * 2];
> +	int avail_disks, choose_first_disk, any_pending, best_index;
> +	bool sequential;
> =20
>  	/*
>  	 * Check if we can balance. We can balance on the whole
> @@ -624,7 +629,10 @@ static int read_balance(struct r1conf *conf,
> struct r1bio *r1_bio, int *max_sect min_pending =3D UINT_MAX;
>  	best_good_sectors =3D 0;
>  	has_nonrot_disk =3D 0;
> -	choose_next_idle =3D 0;
> +	avail_disks =3D 0;
> +	any_pending =3D 0;
> +	choose_first_disk =3D -1;
> +	sequential =3D false;
>  	clear_bit(R1BIO_FailFast, &r1_bio->state);
> =20
>  	if ((conf->mddev->recovery_cp < this_sector + sectors) ||
> @@ -664,6 +672,7 @@ static int read_balance(struct r1conf *conf,
> struct r1bio *r1_bio, int *max_sect best_good_sectors =3D sectors;
>  				best_dist_disk =3D disk;
>  				best_pending_disk =3D disk;
> +				avail_disk[avail_disks++] =3D disk;
>  			}
>  			continue;
>  		}
> @@ -692,8 +701,16 @@ static int read_balance(struct r1conf *conf,
> struct r1bio *r1_bio, int *max_sect best_good_sectors =3D good_sectors;
>  					best_disk =3D disk;
>  				}
> -				if (choose_first)
> -					break;
> +				if (choose_first) {
> +					/* As we need to loop
> through all disks and in some cases
> +					 * we know we want to use
> the first, set it so that
> +					 * best_disk doesn't get
> updated in subsequent loop
> +					 * iterations.
> +					 */
> +					if (choose_first_disk =3D=3D -1)
> +						choose_first_disk =3D
> best_disk;
> +					continue;
> +				}
>  			}
>  			continue;
>  		} else {
> @@ -709,44 +726,30 @@ static int read_balance(struct r1conf *conf,
> struct r1bio *r1_bio, int *max_sect nonrot =3D bdev_nonrot(rdev->bdev);
>  		has_nonrot_disk |=3D nonrot;
>  		pending =3D atomic_read(&rdev->nr_pending);
> +		any_pending |=3D pending;
> +		avail_disk[avail_disks++] =3D disk;
>  		dist =3D abs(this_sector -
> conf->mirrors[disk].head_position); if (choose_first) {
>  			best_disk =3D disk;
> -			break;
> +			if (choose_first_disk =3D=3D -1)
> +				choose_first_disk =3D best_disk;
> +			continue;
>  		}
> -		/* Don't change to another disk for sequential reads
> */
> +		/* For sequential reads, we round robin available
> disks assuming
> +		 * all other conditions are met to make this viable.
> See below for
> +		 * more info.
> +		 */
>  		if (conf->mirrors[disk].next_seq_sect =3D=3D this_sector
>  		    || dist =3D=3D 0) {
> -			int opt_iosize =3D bdev_io_opt(rdev->bdev) >>
> 9;
> -			struct raid1_info *mirror =3D
> &conf->mirrors[disk];=20
> +			sequential =3D true;
> +			best_index =3D avail_disks - 1;
>  			best_disk =3D disk;
> -			/*
> -			 * If buffered sequential IO size exceeds
> optimal
> -			 * iosize, check if there is idle disk. If
> yes, choose
> -			 * the idle disk. read_balance could already
> choose an
> -			 * idle disk before noticing it's a
> sequential IO in
> -			 * this disk. This doesn't matter because
> this disk
> -			 * will idle, next time it will be utilized
> after the
> -			 * first disk has IO size exceeds optimal
> iosize. In
> -			 * this way, iosize of the first disk will
> be optimal
> -			 * iosize at least. iosize of the second
> disk might be
> -			 * small, but not a big deal since when the
> second disk
> -			 * starts IO, the first disk is likely still
> busy.
> -			 */
> -			if (nonrot && opt_iosize > 0 &&
> -			    mirror->seq_start !=3D MaxSector &&
> -			    mirror->next_seq_sect > opt_iosize &&
> -			    mirror->next_seq_sect - opt_iosize >=3D
> -			    mirror->seq_start) {
> -				choose_next_idle =3D 1;
> -				continue;
> -			}
> -			break;
> -		}
> =20
> -		if (choose_next_idle)
> +			if (choose_first_disk =3D=3D -1)
> +				choose_first_disk =3D best_disk;
>  			continue;
> +		}
> =20
>  		if (min_pending > pending) {
>  			min_pending =3D pending;
> @@ -763,7 +766,7 @@ static int read_balance(struct r1conf *conf,
> struct r1bio *r1_bio, int *max_sect
>  	 * If all disks are rotational, choose the closest disk. If
> any disk is
>  	 * non-rotational, choose the disk with less pending request
> even the
>  	 * disk is rotational, which might/might not be optimal for
> raids with
> -	 * mixed ratation/non-rotational disks depending on workload.
> +	 * mixed rotation/non-rotational disks depending on workload.
>  	 */
>  	if (best_disk =3D=3D -1) {
>  		if (has_nonrot_disk || min_pending =3D=3D 0)
> @@ -772,8 +775,44 @@ static int read_balance(struct r1conf *conf,
> struct r1bio *r1_bio, int *max_sect best_disk =3D best_dist_disk;
>  	}
> =20
> +	if (choose_first_disk >=3D 0)
> +		best_disk =3D choose_first_disk;
> +
>  	if (best_disk >=3D 0) {
> -		rdev =3D conf->mirrors[best_disk].rdev;
> +		if (avail_disks > 1) {
> +
> +			/* Only set Failfast if we have at least 2
> available disks. */
> +			set_bit(R1BIO_FailFast, &r1_bio->state);
> +
> +			/* There are many reasons why round robin
> might not be the best
> +			 * choice...
> +			 */
> +			if (has_nonrot_disk && !choose_first &&
> avail_disks <=3D MAX_RR_DISKS
> +				&& sectors > RR_16K_IN_SECS &&
> sequential =3D=3D true) { +
> +				conf->mirrors->read_thresh +=3D
> sectors;
> +				conf->mirrors->rr_index =3D best_index;
> +				/* Only switch over after a certain
> transfer threshold per
> +				 * disk, based on empirical data for
> non rotational media.
> +				 */
> +				if (conf->mirrors->read_thresh >=3D
> RR_128K_IN_SECS) {
> +					conf->mirrors->read_thresh =3D
> 0; +
> +					if (any_pending > 1) {
> +						/* We store the
> index into the mirrors array that
> +						 * represents the N
> available disks and round robin
> +						 * that index into
> the array to get the next disk
> +						 * number to use.
> +						 */
> +						best_index =3D
> (best_index + 1) % avail_disks;
> +
> conf->mirrors->rr_index =3D best_index;
> +						best_disk =3D
> avail_disk[best_index];
> +					}
> +				}
> +			}
> +		}
> +
> +		rdev =3D
> rcu_dereference(conf->mirrors[best_disk].rdev); if (!rdev)
>  			goto retry;
>  		atomic_inc(&rdev->nr_pending);
> diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
> index 14d4211a123a..e7c3a3334d2f 100644
> --- a/drivers/md/raid1.h
> +++ b/drivers/md/raid1.h
> @@ -42,6 +42,12 @@ struct raid1_info {
>  	struct md_rdev	*rdev;
>  	sector_t	head_position;
> =20
> +	/* The round robin trasnfer (sectors) threshold before we
> move to the next
> +	 * disk, and the mirrors[] index of the last used disk for
> round robin.
> +	 */
> +	int read_thresh;
> +	int rr_index;
> +
>  	/* When choose the best device for a read (read_balance())
>  	 * we try to keep sequential reads one the same device
>  	 */

