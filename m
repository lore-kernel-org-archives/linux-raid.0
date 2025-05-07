Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D1D156F5E;
	Wed,  7 May 2025 08:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746607108; cv=none; b=towzS5IIZROJNg8FTXQYMOV2Q9/GzSEZgeT1WncadKdiMgN9FJlWhCn530Kqbui3URqEYCXa6YDT5RXmP/7bdWv6goxEi9Qg9epRw1imLGwcwY/PFfqLt6ZnTluLoFSZkGfEriv2jVQW3ARZ/io3aNmt1BVU/CbahsMt9X8XaAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746607108; c=relaxed/simple;
	bh=J1Fe173IvhGk1hn2nprzjJLiSkhC8P1I6giWI0A34Kw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GqPPCF34KWRDKZRB9+JKZh911H+Ea50qM0mipsvpDlTpVYrPMegu7TfLsOsrThcTPOCTp7yD7pk/lctX/2jeJbb+tkH6ofnQQ9H3OJoZHvgPu54d9bwSOToCgWggpYupjulBb427ar9IHeRvpxIhPgp3H96FGvxdT8g9f57Vl48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ckajakYX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ckajakYX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BADB1C4CEE7;
	Wed,  7 May 2025 08:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746607107;
	bh=J1Fe173IvhGk1hn2nprzjJLiSkhC8P1I6giWI0A34Kw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ckajakYXrx67VCt/AGxZjU8/nISvYTy5YC12g0QG2bEnkm4BSLuSON3BmyZfHZiPZ
	 q+Xo4/1LXh03N6CPtTdnTUJ5E7BAhuChK4vXZGcOpdqyj4PEABBXKBveWrnWYBRfOy
	 AB8F/xRjHKp8TVaqgfdptu1tSRRSqOXoBcfzzuz8=
Date: Wed, 7 May 2025 10:38:24 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Salvatore Bonaccorso <carnil@debian.org>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, stable@vger.kernel.org,
	song@kernel.org, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, yukuai3@huawei.com,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
Subject: Re: [PATCH v6.1] md: move initialization and destruction of
 'io_acct_set' to md.c
Message-ID: <2025050716-lunar-grimy-9783@gregkh>
References: <20250506012417.312790-1-yukuai1@huaweicloud.com>
 <aBpgJiIRCvTLNgTV@eldamar.lan>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBpgJiIRCvTLNgTV@eldamar.lan>

On Tue, May 06, 2025 at 09:16:54PM +0200, Salvatore Bonaccorso wrote:
> Hi,
> 
> On Tue, May 06, 2025 at 09:24:17AM +0800, Yu Kuai wrote:
> > From: Yu Kuai <yukuai3@huawei.com>
> > 
> > commit c567c86b90d4715081adfe5eb812141a5b6b4883 upstream.
> > 
> > 'io_acct_set' is only used for raid0 and raid456, prepare to use it for
> > raid1 and raid10, so that io accounting from different levels can be
> > consistent.
> > 
> > By the way, follow up patches will also use this io clone mechanism to
> > make sure 'active_io' represents in flight io, not io that is dispatching,
> > so that mddev_suspend will wait for io to be done as designed.
> > 
> > Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> > Reviewed-by: Xiao Ni <xni@redhat.com>
> > Signed-off-by: Song Liu <song@kernel.org>
> > Link: https://lore.kernel.org/r/20230621165110.1498313-2-yukuai1@huaweicloud.com
> > [Yu Kuai: This is the relied patch for commit 4a05f7ae3371 ("md/raid10:
> > fix missing discard IO accounting"), kernel will panic while issuing
> > discard to raid10 without this patch]
> > Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> > ---
> >  drivers/md/md.c    | 27 ++++++++++-----------------
> >  drivers/md/md.h    |  2 --
> >  drivers/md/raid0.c | 16 ++--------------
> >  drivers/md/raid5.c | 41 +++++++++++------------------------------
> >  4 files changed, 23 insertions(+), 63 deletions(-)
> > 
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index d5fbccc72810..a9fcfcbc2d11 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -5965,6 +5965,13 @@ int md_run(struct mddev *mddev)
> >  			goto exit_bio_set;
> >  	}
> >  
> > +	if (!bioset_initialized(&mddev->io_acct_set)) {
> > +		err = bioset_init(&mddev->io_acct_set, BIO_POOL_SIZE,
> > +				  offsetof(struct md_io_acct, bio_clone), 0);
> > +		if (err)
> > +			goto exit_sync_set;
> > +	}
> > +
> >  	spin_lock(&pers_lock);
> >  	pers = find_pers(mddev->level, mddev->clevel);
> >  	if (!pers || !try_module_get(pers->owner)) {
> > @@ -6142,6 +6149,8 @@ int md_run(struct mddev *mddev)
> >  	module_put(pers->owner);
> >  	md_bitmap_destroy(mddev);
> >  abort:
> > +	bioset_exit(&mddev->io_acct_set);
> > +exit_sync_set:
> >  	bioset_exit(&mddev->sync_set);
> >  exit_bio_set:
> >  	bioset_exit(&mddev->bio_set);
> > @@ -6374,6 +6383,7 @@ static void __md_stop(struct mddev *mddev)
> >  	percpu_ref_exit(&mddev->active_io);
> >  	bioset_exit(&mddev->bio_set);
> >  	bioset_exit(&mddev->sync_set);
> > +	bioset_exit(&mddev->io_acct_set);
> >  }
> >  
> >  void md_stop(struct mddev *mddev)
> > @@ -8744,23 +8754,6 @@ void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
> >  }
> >  EXPORT_SYMBOL_GPL(md_submit_discard_bio);
> >  
> > -int acct_bioset_init(struct mddev *mddev)
> > -{
> > -	int err = 0;
> > -
> > -	if (!bioset_initialized(&mddev->io_acct_set))
> > -		err = bioset_init(&mddev->io_acct_set, BIO_POOL_SIZE,
> > -			offsetof(struct md_io_acct, bio_clone), 0);
> > -	return err;
> > -}
> > -EXPORT_SYMBOL_GPL(acct_bioset_init);
> > -
> > -void acct_bioset_exit(struct mddev *mddev)
> > -{
> > -	bioset_exit(&mddev->io_acct_set);
> > -}
> > -EXPORT_SYMBOL_GPL(acct_bioset_exit);
> > -
> >  static void md_end_io_acct(struct bio *bio)
> >  {
> >  	struct md_io_acct *md_io_acct = bio->bi_private;
> > diff --git a/drivers/md/md.h b/drivers/md/md.h
> > index 4f0b48097455..1fda5e139beb 100644
> > --- a/drivers/md/md.h
> > +++ b/drivers/md/md.h
> > @@ -746,8 +746,6 @@ extern void md_error(struct mddev *mddev, struct md_rdev *rdev);
> >  extern void md_finish_reshape(struct mddev *mddev);
> >  void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
> >  			struct bio *bio, sector_t start, sector_t size);
> > -int acct_bioset_init(struct mddev *mddev);
> > -void acct_bioset_exit(struct mddev *mddev);
> >  void md_account_bio(struct mddev *mddev, struct bio **bio);
> >  
> >  extern bool __must_check md_flush_request(struct mddev *mddev, struct bio *bio);
> > diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> > index 7c6a0b4437d8..c50a7abda744 100644
> > --- a/drivers/md/raid0.c
> > +++ b/drivers/md/raid0.c
> > @@ -377,7 +377,6 @@ static void raid0_free(struct mddev *mddev, void *priv)
> >  	struct r0conf *conf = priv;
> >  
> >  	free_conf(mddev, conf);
> > -	acct_bioset_exit(mddev);
> >  }
> >  
> >  static int raid0_run(struct mddev *mddev)
> > @@ -392,16 +391,11 @@ static int raid0_run(struct mddev *mddev)
> >  	if (md_check_no_bitmap(mddev))
> >  		return -EINVAL;
> >  
> > -	if (acct_bioset_init(mddev)) {
> > -		pr_err("md/raid0:%s: alloc acct bioset failed.\n", mdname(mddev));
> > -		return -ENOMEM;
> > -	}
> > -
> >  	/* if private is not null, we are here after takeover */
> >  	if (mddev->private == NULL) {
> >  		ret = create_strip_zones(mddev, &conf);
> >  		if (ret < 0)
> > -			goto exit_acct_set;
> > +			return ret;
> >  		mddev->private = conf;
> >  	}
> >  	conf = mddev->private;
> > @@ -432,15 +426,9 @@ static int raid0_run(struct mddev *mddev)
> >  
> >  	ret = md_integrity_register(mddev);
> >  	if (ret)
> > -		goto free;
> > +		free_conf(mddev, conf);
> >  
> >  	return ret;
> > -
> > -free:
> > -	free_conf(mddev, conf);
> > -exit_acct_set:
> > -	acct_bioset_exit(mddev);
> > -	return ret;
> >  }
> >  
> >  /*
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index 4315dabd3202..6e80a439ec45 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -7770,19 +7770,12 @@ static int raid5_run(struct mddev *mddev)
> >  	struct md_rdev *rdev;
> >  	struct md_rdev *journal_dev = NULL;
> >  	sector_t reshape_offset = 0;
> > -	int i, ret = 0;
> > +	int i;
> >  	long long min_offset_diff = 0;
> >  	int first = 1;
> >  
> > -	if (acct_bioset_init(mddev)) {
> > -		pr_err("md/raid456:%s: alloc acct bioset failed.\n", mdname(mddev));
> > +	if (mddev_init_writes_pending(mddev) < 0)
> >  		return -ENOMEM;
> > -	}
> > -
> > -	if (mddev_init_writes_pending(mddev) < 0) {
> > -		ret = -ENOMEM;
> > -		goto exit_acct_set;
> > -	}
> >  
> >  	if (mddev->recovery_cp != MaxSector)
> >  		pr_notice("md/raid:%s: not clean -- starting background reconstruction\n",
> > @@ -7813,8 +7806,7 @@ static int raid5_run(struct mddev *mddev)
> >  	    (mddev->bitmap_info.offset || mddev->bitmap_info.file)) {
> >  		pr_notice("md/raid:%s: array cannot have both journal and bitmap\n",
> >  			  mdname(mddev));
> > -		ret = -EINVAL;
> > -		goto exit_acct_set;
> > +		return -EINVAL;
> >  	}
> >  
> >  	if (mddev->reshape_position != MaxSector) {
> > @@ -7839,15 +7831,13 @@ static int raid5_run(struct mddev *mddev)
> >  		if (journal_dev) {
> >  			pr_warn("md/raid:%s: don't support reshape with journal - aborting.\n",
> >  				mdname(mddev));
> > -			ret = -EINVAL;
> > -			goto exit_acct_set;
> > +			return -EINVAL;
> >  		}
> >  
> >  		if (mddev->new_level != mddev->level) {
> >  			pr_warn("md/raid:%s: unsupported reshape required - aborting.\n",
> >  				mdname(mddev));
> > -			ret = -EINVAL;
> > -			goto exit_acct_set;
> > +			return -EINVAL;
> >  		}
> >  		old_disks = mddev->raid_disks - mddev->delta_disks;
> >  		/* reshape_position must be on a new-stripe boundary, and one
> > @@ -7863,8 +7853,7 @@ static int raid5_run(struct mddev *mddev)
> >  		if (sector_div(here_new, chunk_sectors * new_data_disks)) {
> >  			pr_warn("md/raid:%s: reshape_position not on a stripe boundary\n",
> >  				mdname(mddev));
> > -			ret = -EINVAL;
> > -			goto exit_acct_set;
> > +			return -EINVAL;
> >  		}
> >  		reshape_offset = here_new * chunk_sectors;
> >  		/* here_new is the stripe we will write to */
> > @@ -7886,8 +7875,7 @@ static int raid5_run(struct mddev *mddev)
> >  			else if (mddev->ro == 0) {
> >  				pr_warn("md/raid:%s: in-place reshape must be started in read-only mode - aborting\n",
> >  					mdname(mddev));
> > -				ret = -EINVAL;
> > -				goto exit_acct_set;
> > +				return -EINVAL;
> >  			}
> >  		} else if (mddev->reshape_backwards
> >  		    ? (here_new * chunk_sectors + min_offset_diff <=
> > @@ -7897,8 +7885,7 @@ static int raid5_run(struct mddev *mddev)
> >  			/* Reading from the same stripe as writing to - bad */
> >  			pr_warn("md/raid:%s: reshape_position too early for auto-recovery - aborting.\n",
> >  				mdname(mddev));
> > -			ret = -EINVAL;
> > -			goto exit_acct_set;
> > +			return -EINVAL;
> >  		}
> >  		pr_debug("md/raid:%s: reshape will continue\n", mdname(mddev));
> >  		/* OK, we should be able to continue; */
> > @@ -7922,10 +7909,8 @@ static int raid5_run(struct mddev *mddev)
> >  	else
> >  		conf = mddev->private;
> >  
> > -	if (IS_ERR(conf)) {
> > -		ret = PTR_ERR(conf);
> > -		goto exit_acct_set;
> > -	}
> > +	if (IS_ERR(conf))
> > +		return PTR_ERR(conf);
> >  
> >  	if (test_bit(MD_HAS_JOURNAL, &mddev->flags)) {
> >  		if (!journal_dev) {
> > @@ -8125,10 +8110,7 @@ static int raid5_run(struct mddev *mddev)
> >  	free_conf(conf);
> >  	mddev->private = NULL;
> >  	pr_warn("md/raid:%s: failed to run raid set.\n", mdname(mddev));
> > -	ret = -EIO;
> > -exit_acct_set:
> > -	acct_bioset_exit(mddev);
> > -	return ret;
> > +	return -EIO;
> >  }
> >  
> >  static void raid5_free(struct mddev *mddev, void *priv)
> > @@ -8136,7 +8118,6 @@ static void raid5_free(struct mddev *mddev, void *priv)
> >  	struct r5conf *conf = priv;
> >  
> >  	free_conf(conf);
> > -	acct_bioset_exit(mddev);
> >  	mddev->to_remove = &raid5_attrs_group;
> >  }
> >  
> > -- 
> > 2.39.2
> 
> FWIW, this was tested for people in Debian affected by
> https://bugs.debian.org/1104460 .

Thanks for the debugging, now queued up!
