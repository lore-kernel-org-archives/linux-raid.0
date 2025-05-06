Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992F57262E;
	Tue,  6 May 2025 19:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746559019; cv=none; b=csukqwZ0WIA/G+3R6uYSFObu7VVwtiCgzHMDYhvEw9T6lpubz8hTd0qZj+Mq+d0PZcqQQQeBUFX9+bTWhaDaXxy020w9OEOuG0Pu+QtyKYSOvijus2kY9aG4rE8C4axJIzCXXwjih5SnFcNVmnyYoyMROM6fEciMRe1J02hDZsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746559019; c=relaxed/simple;
	bh=cTGn3W13b1idqhLyLVhZGrB/2jdhPxdlZZSJp5a8S9E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W/oWQNTqNHipckQwhRpeQ2lA/AM7Wexl/TGAbpM2jZvbqlNuiO7Lxnk/u37gpLVx5WEmu9YI5kSnkuYVdt2q8EbWbO1Ig4Qr/WAaR7AAQDU5XyeOqHxbAJLBOCTKz2i3SbTtze2vqYBYAT/JMNe+QPAyrCAKLap9RRkzhagbImg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TwUBxjHx; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TwUBxjHx"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-acec5b99052so1208816466b.1;
        Tue, 06 May 2025 12:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746559016; x=1747163816; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ubuq//ZeHtaxcD//b9pKvYn5y/1Jx/tBXIw5jB8LuWA=;
        b=TwUBxjHxkJ2hLMjBbjtjsAb/+duW95hvp01nFRybc8VfATXR6K1+h5IJRCMPAoh+cT
         dYdV5L+zFO85+7ECmGB3L/d27hBq7wD1gEJY1sIkB4dSO7ZlOb1d2XjQthoTmW4gISzf
         4RhcHuInrPs1sZc2rYLRE5a8OTYY69yU8i3WLduxFLLTPVIpZM7Q/XimdAfh3WPBCjr/
         gN/bU7vmx9Rgu3RQb7svNaNOtz80iKut0himS2t4P0aAL4m7lixY+EqeEWzcF6jB8ePX
         gPSYNLwS0cmKD4bEYcjuf7NVP7VZ9n2k+xKmFDKk2RwCkLbIshRrNp2mO4moMNN0nCux
         6Bqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746559016; x=1747163816;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ubuq//ZeHtaxcD//b9pKvYn5y/1Jx/tBXIw5jB8LuWA=;
        b=EzwnDe0VTR6xvp+HnEJXUNYWiLI/7ysZmGIcVYFQA4jjFfsnuvjpnNTcWCz3h6zz/W
         m1sIZUPRmsfn9pkMelWN7rmzbQkequvi+SlSIePpO6QmYvweqqpcAukS474P33yrBjBT
         U1Dtdj56ZjH2iGhayct3tlv9/LFOdbVbuHSABkwSg94ac7yuzid/yDMk2AK7IVYcJvG3
         VvLfm5vEasHQEaBfQHtEzKi1PHh6o7zDyH7bYyQxDLMiG3LcHRtVupZZoKp6oAAFU6vL
         SEbG/p0lUv1Sa1jgYOOC+yPiWiX8KwcXZ6NxSdZWWtAfFpsLdi0Og2BDYjEYgdphP02O
         Za0A==
X-Forwarded-Encrypted: i=1; AJvYcCW+SBKFHrM7Hcs2tROQ1jJg8j/pwP8a3KJMQqZbL0UShM61CThz6Jwq/CimKPkKU730jJL+9BdzbjL1bpk=@vger.kernel.org, AJvYcCW/eOl2+IpiBYe1r0n7xW2JDQckykLRhL7HMDzGeiEN5I7ZPCpbTy2MXLbTpRIdjSyhtL2VOX+mwVyjXg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyM8VyNi21ghbBTi5PLc2uskIzOjKQbtb52L6OAVJBLtFmC1ZwW
	m5cwQw2x86ndXReL0nSUWsj31G4GZFHS5OylZm3P6A6n1G8JyzSR
X-Gm-Gg: ASbGncsGCM6BYYaL2TfUJCDpHG0nDLRhoOEsmP6wvON/zVCimE9+k7CS/gihSTN896J
	L/aMOU2bf8KuLCcGxp0QcjV6JF8WZZWkli4I4xvYGicNbUUzHEoj3+XtjHjanEdT0VzGaddZ1XZ
	eFx3KaivnNilWDJI/aaRWbfBZ1r1c+RVUj2zUhpm6zVrjvkBSennS5qLFiIk6xP4kqFNOuoHmxT
	s9EEk/9kwhTGlmiK6MuoB/b3KMg9nDF2pmzT+CE4HCZRm953qEFUA2ja33fSx5PWiCizg4Jloub
	prtFxIWkBKQulmPGn/4qYCyPR/lteyjG+1rn2F7R5qEZBV1o2CeC2p1Ul5CZGM4N9h1/euJsVA=
	=
X-Google-Smtp-Source: AGHT+IEEpeE4FWLIAArnF7WRSOU+aUwT2NdirIpUEuE0HcczvKtqRDe+dH2QFZm7rjPa10s+faFRKA==
X-Received: by 2002:a17:907:7b8e:b0:ac7:3912:5ea5 with SMTP id a640c23a62f3a-ad1e8d89ce1mr67520266b.58.1746559015613;
        Tue, 06 May 2025 12:16:55 -0700 (PDT)
Received: from eldamar.lan (c-82-192-244-13.customer.ggaweb.ch. [82.192.244.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad1891f04absm753665166b.78.2025.05.06.12.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 12:16:54 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id 2B986BE2DE0; Tue, 06 May 2025 21:16:54 +0200 (CEST)
Date: Tue, 6 May 2025 21:16:54 +0200
From: Salvatore Bonaccorso <carnil@debian.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: stable@vger.kernel.org, gregkh@linuxfoundation.org, song@kernel.org,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
	yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: Re: [PATCH v6.1] md: move initialization and destruction of
 'io_acct_set' to md.c
Message-ID: <aBpgJiIRCvTLNgTV@eldamar.lan>
References: <20250506012417.312790-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250506012417.312790-1-yukuai1@huaweicloud.com>

Hi,

On Tue, May 06, 2025 at 09:24:17AM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> commit c567c86b90d4715081adfe5eb812141a5b6b4883 upstream.
> 
> 'io_acct_set' is only used for raid0 and raid456, prepare to use it for
> raid1 and raid10, so that io accounting from different levels can be
> consistent.
> 
> By the way, follow up patches will also use this io clone mechanism to
> make sure 'active_io' represents in flight io, not io that is dispatching,
> so that mddev_suspend will wait for io to be done as designed.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> Reviewed-by: Xiao Ni <xni@redhat.com>
> Signed-off-by: Song Liu <song@kernel.org>
> Link: https://lore.kernel.org/r/20230621165110.1498313-2-yukuai1@huaweicloud.com
> [Yu Kuai: This is the relied patch for commit 4a05f7ae3371 ("md/raid10:
> fix missing discard IO accounting"), kernel will panic while issuing
> discard to raid10 without this patch]
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md.c    | 27 ++++++++++-----------------
>  drivers/md/md.h    |  2 --
>  drivers/md/raid0.c | 16 ++--------------
>  drivers/md/raid5.c | 41 +++++++++++------------------------------
>  4 files changed, 23 insertions(+), 63 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d5fbccc72810..a9fcfcbc2d11 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5965,6 +5965,13 @@ int md_run(struct mddev *mddev)
>  			goto exit_bio_set;
>  	}
>  
> +	if (!bioset_initialized(&mddev->io_acct_set)) {
> +		err = bioset_init(&mddev->io_acct_set, BIO_POOL_SIZE,
> +				  offsetof(struct md_io_acct, bio_clone), 0);
> +		if (err)
> +			goto exit_sync_set;
> +	}
> +
>  	spin_lock(&pers_lock);
>  	pers = find_pers(mddev->level, mddev->clevel);
>  	if (!pers || !try_module_get(pers->owner)) {
> @@ -6142,6 +6149,8 @@ int md_run(struct mddev *mddev)
>  	module_put(pers->owner);
>  	md_bitmap_destroy(mddev);
>  abort:
> +	bioset_exit(&mddev->io_acct_set);
> +exit_sync_set:
>  	bioset_exit(&mddev->sync_set);
>  exit_bio_set:
>  	bioset_exit(&mddev->bio_set);
> @@ -6374,6 +6383,7 @@ static void __md_stop(struct mddev *mddev)
>  	percpu_ref_exit(&mddev->active_io);
>  	bioset_exit(&mddev->bio_set);
>  	bioset_exit(&mddev->sync_set);
> +	bioset_exit(&mddev->io_acct_set);
>  }
>  
>  void md_stop(struct mddev *mddev)
> @@ -8744,23 +8754,6 @@ void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
>  }
>  EXPORT_SYMBOL_GPL(md_submit_discard_bio);
>  
> -int acct_bioset_init(struct mddev *mddev)
> -{
> -	int err = 0;
> -
> -	if (!bioset_initialized(&mddev->io_acct_set))
> -		err = bioset_init(&mddev->io_acct_set, BIO_POOL_SIZE,
> -			offsetof(struct md_io_acct, bio_clone), 0);
> -	return err;
> -}
> -EXPORT_SYMBOL_GPL(acct_bioset_init);
> -
> -void acct_bioset_exit(struct mddev *mddev)
> -{
> -	bioset_exit(&mddev->io_acct_set);
> -}
> -EXPORT_SYMBOL_GPL(acct_bioset_exit);
> -
>  static void md_end_io_acct(struct bio *bio)
>  {
>  	struct md_io_acct *md_io_acct = bio->bi_private;
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 4f0b48097455..1fda5e139beb 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -746,8 +746,6 @@ extern void md_error(struct mddev *mddev, struct md_rdev *rdev);
>  extern void md_finish_reshape(struct mddev *mddev);
>  void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
>  			struct bio *bio, sector_t start, sector_t size);
> -int acct_bioset_init(struct mddev *mddev);
> -void acct_bioset_exit(struct mddev *mddev);
>  void md_account_bio(struct mddev *mddev, struct bio **bio);
>  
>  extern bool __must_check md_flush_request(struct mddev *mddev, struct bio *bio);
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 7c6a0b4437d8..c50a7abda744 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -377,7 +377,6 @@ static void raid0_free(struct mddev *mddev, void *priv)
>  	struct r0conf *conf = priv;
>  
>  	free_conf(mddev, conf);
> -	acct_bioset_exit(mddev);
>  }
>  
>  static int raid0_run(struct mddev *mddev)
> @@ -392,16 +391,11 @@ static int raid0_run(struct mddev *mddev)
>  	if (md_check_no_bitmap(mddev))
>  		return -EINVAL;
>  
> -	if (acct_bioset_init(mddev)) {
> -		pr_err("md/raid0:%s: alloc acct bioset failed.\n", mdname(mddev));
> -		return -ENOMEM;
> -	}
> -
>  	/* if private is not null, we are here after takeover */
>  	if (mddev->private == NULL) {
>  		ret = create_strip_zones(mddev, &conf);
>  		if (ret < 0)
> -			goto exit_acct_set;
> +			return ret;
>  		mddev->private = conf;
>  	}
>  	conf = mddev->private;
> @@ -432,15 +426,9 @@ static int raid0_run(struct mddev *mddev)
>  
>  	ret = md_integrity_register(mddev);
>  	if (ret)
> -		goto free;
> +		free_conf(mddev, conf);
>  
>  	return ret;
> -
> -free:
> -	free_conf(mddev, conf);
> -exit_acct_set:
> -	acct_bioset_exit(mddev);
> -	return ret;
>  }
>  
>  /*
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 4315dabd3202..6e80a439ec45 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7770,19 +7770,12 @@ static int raid5_run(struct mddev *mddev)
>  	struct md_rdev *rdev;
>  	struct md_rdev *journal_dev = NULL;
>  	sector_t reshape_offset = 0;
> -	int i, ret = 0;
> +	int i;
>  	long long min_offset_diff = 0;
>  	int first = 1;
>  
> -	if (acct_bioset_init(mddev)) {
> -		pr_err("md/raid456:%s: alloc acct bioset failed.\n", mdname(mddev));
> +	if (mddev_init_writes_pending(mddev) < 0)
>  		return -ENOMEM;
> -	}
> -
> -	if (mddev_init_writes_pending(mddev) < 0) {
> -		ret = -ENOMEM;
> -		goto exit_acct_set;
> -	}
>  
>  	if (mddev->recovery_cp != MaxSector)
>  		pr_notice("md/raid:%s: not clean -- starting background reconstruction\n",
> @@ -7813,8 +7806,7 @@ static int raid5_run(struct mddev *mddev)
>  	    (mddev->bitmap_info.offset || mddev->bitmap_info.file)) {
>  		pr_notice("md/raid:%s: array cannot have both journal and bitmap\n",
>  			  mdname(mddev));
> -		ret = -EINVAL;
> -		goto exit_acct_set;
> +		return -EINVAL;
>  	}
>  
>  	if (mddev->reshape_position != MaxSector) {
> @@ -7839,15 +7831,13 @@ static int raid5_run(struct mddev *mddev)
>  		if (journal_dev) {
>  			pr_warn("md/raid:%s: don't support reshape with journal - aborting.\n",
>  				mdname(mddev));
> -			ret = -EINVAL;
> -			goto exit_acct_set;
> +			return -EINVAL;
>  		}
>  
>  		if (mddev->new_level != mddev->level) {
>  			pr_warn("md/raid:%s: unsupported reshape required - aborting.\n",
>  				mdname(mddev));
> -			ret = -EINVAL;
> -			goto exit_acct_set;
> +			return -EINVAL;
>  		}
>  		old_disks = mddev->raid_disks - mddev->delta_disks;
>  		/* reshape_position must be on a new-stripe boundary, and one
> @@ -7863,8 +7853,7 @@ static int raid5_run(struct mddev *mddev)
>  		if (sector_div(here_new, chunk_sectors * new_data_disks)) {
>  			pr_warn("md/raid:%s: reshape_position not on a stripe boundary\n",
>  				mdname(mddev));
> -			ret = -EINVAL;
> -			goto exit_acct_set;
> +			return -EINVAL;
>  		}
>  		reshape_offset = here_new * chunk_sectors;
>  		/* here_new is the stripe we will write to */
> @@ -7886,8 +7875,7 @@ static int raid5_run(struct mddev *mddev)
>  			else if (mddev->ro == 0) {
>  				pr_warn("md/raid:%s: in-place reshape must be started in read-only mode - aborting\n",
>  					mdname(mddev));
> -				ret = -EINVAL;
> -				goto exit_acct_set;
> +				return -EINVAL;
>  			}
>  		} else if (mddev->reshape_backwards
>  		    ? (here_new * chunk_sectors + min_offset_diff <=
> @@ -7897,8 +7885,7 @@ static int raid5_run(struct mddev *mddev)
>  			/* Reading from the same stripe as writing to - bad */
>  			pr_warn("md/raid:%s: reshape_position too early for auto-recovery - aborting.\n",
>  				mdname(mddev));
> -			ret = -EINVAL;
> -			goto exit_acct_set;
> +			return -EINVAL;
>  		}
>  		pr_debug("md/raid:%s: reshape will continue\n", mdname(mddev));
>  		/* OK, we should be able to continue; */
> @@ -7922,10 +7909,8 @@ static int raid5_run(struct mddev *mddev)
>  	else
>  		conf = mddev->private;
>  
> -	if (IS_ERR(conf)) {
> -		ret = PTR_ERR(conf);
> -		goto exit_acct_set;
> -	}
> +	if (IS_ERR(conf))
> +		return PTR_ERR(conf);
>  
>  	if (test_bit(MD_HAS_JOURNAL, &mddev->flags)) {
>  		if (!journal_dev) {
> @@ -8125,10 +8110,7 @@ static int raid5_run(struct mddev *mddev)
>  	free_conf(conf);
>  	mddev->private = NULL;
>  	pr_warn("md/raid:%s: failed to run raid set.\n", mdname(mddev));
> -	ret = -EIO;
> -exit_acct_set:
> -	acct_bioset_exit(mddev);
> -	return ret;
> +	return -EIO;
>  }
>  
>  static void raid5_free(struct mddev *mddev, void *priv)
> @@ -8136,7 +8118,6 @@ static void raid5_free(struct mddev *mddev, void *priv)
>  	struct r5conf *conf = priv;
>  
>  	free_conf(conf);
> -	acct_bioset_exit(mddev);
>  	mddev->to_remove = &raid5_attrs_group;
>  }
>  
> -- 
> 2.39.2

FWIW, this was tested for people in Debian affected by
https://bugs.debian.org/1104460 .

Regards,
Salvatore
