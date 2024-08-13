Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A3E1DDF4;
	Tue, 13 Aug 2024 07:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723532856; cv=none; b=B/YjG3Gi1TImOkmAAxjaJti+p/vvZiw839ed3KyRZoh1F/sfKepcjP0jgWKWW5dDmCzZnPFteay00smzDzNtXeNzP4JWDn4ECKHc1JfMhlcDeiCvS6ZJTt5qpCXaqBNFMC8A6q2oYsl6UBO1rJxNS7E3DKBQ/DnlaUsS8OhbG6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723532856; c=relaxed/simple;
	bh=7m/cYpy1qKdGcJ2s+JjySj+hloFpjff/3x0QGvDVe2E=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SaT28OSo93T+VTgvN/kKrFW9FOnoYksx5iBA8RTQuKvUkvrQ1dX2c1v0i3tj7nKvuH/UUC3D3RhoZUW+mmT5EdbF3hs8t8YUolCAtl7QcuWCnR91867zBGyNmq61D26G6FXrymsAVyDviuiY/GpCQxx/u8JHpDVcEbM4lacOJYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VGBTnaDF; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VGBTnaDF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723532855; x=1755068855;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7m/cYpy1qKdGcJ2s+JjySj+hloFpjff/3x0QGvDVe2E=;
  b=VGBTnaDF3poPq8s0RvVkZLB0y61zXZOClbfeiGxD+IMQAz6n/iFhr8+c
   otRjJmuq8chn/DuxRCnHVA8Y/GWtmf7n6KapAQndKE6INZDX63JkvGTjO
   znRSScV9BvSMuXgHPdf8aDPjHb8DB6Ymqrc9Jjcs497qbmD0z+A+qcd5m
   ODIrrM2VKwQnYTaIgJG+bfIsQLCxWWBPK7B6mru6m4Qp2dSx60UlmdQ8q
   spmgQGrwGlNyom0HCqy/UUYVSxfg6M8tEeicvqiuorOT6zw5tO+TjjHDe
   PzFRKc1D3GiCewBYF7fccHdGJ9MSfja7p1qUmhfadH3rOrnqBaSkM1dEy
   w==;
X-CSE-ConnectionGUID: ZRZU4VbaS/Wh2ZwWo0ogww==
X-CSE-MsgGUID: QaJkAAwXTJqUOM/Lk4LWCg==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="44199351"
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="44199351"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 00:07:33 -0700
X-CSE-ConnectionGUID: L74kXJI3Tf6IQYrBB6TvWQ==
X-CSE-MsgGUID: loXMFgDhT6GxNVWjjT8jmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="89232679"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.112.252])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 00:07:32 -0700
Date: Tue, 13 Aug 2024 09:07:26 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com,
 yangerkun@huawei.com
Subject: Re: [PATCH RFC -next 03/26] md/md-bitmap: merge md_bitmap_load()
 into bitmap_operations
Message-ID: <20240813090726.000032cd@linux.intel.com>
In-Reply-To: <20240810020854.797814-4-yukuai1@huaweicloud.com>
References: <20240810020854.797814-1-yukuai1@huaweicloud.com>
	<20240810020854.797814-4-yukuai1@huaweicloud.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 10 Aug 2024 10:08:31 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> From: Yu Kuai <yukuai3@huawei.com>
> 
> So that the implementation won't be exposed, and it'll be possible
> to invent a new bitmap by replacing bitmap_operations.

I don't like repeating same commit message for few patches.

> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md-bitmap.c |  6 +++---
>  drivers/md/md-bitmap.h | 10 +++++++++-
>  2 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index d731f7d4bbbb..9a9f0fe3ebd0 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -1965,7 +1965,7 @@ static struct bitmap *bitmap_create(struct mddev
> *mddev, int slot) return ERR_PTR(err);
>  }
>  
> -int md_bitmap_load(struct mddev *mddev)
> +static int bitmap_load(struct mddev *mddev)
>  {
>  	int err = 0;
>  	sector_t start = 0;
> @@ -2021,7 +2021,6 @@ int md_bitmap_load(struct mddev *mddev)
>  out:
>  	return err;
>  }
> -EXPORT_SYMBOL_GPL(md_bitmap_load);
>  
>  /* caller need to free returned bitmap with md_bitmap_free() */
>  struct bitmap *get_bitmap_from_slot(struct mddev *mddev, int slot)
> @@ -2411,7 +2410,7 @@ location_store(struct mddev *mddev, const char *buf,
> size_t len) }
>  
>  			mddev->bitmap = bitmap;
> -			rv = md_bitmap_load(mddev);
> +			rv = bitmap_load(mddev);
>  			if (rv) {
>  				mddev->bitmap_info.offset = 0;
>  				md_bitmap_destroy(mddev);
> @@ -2710,6 +2709,7 @@ const struct attribute_group md_bitmap_group = {
>  
>  static struct bitmap_operations bitmap_ops = {
>  	.create			= bitmap_create,
> +	.load			= bitmap_load,
>  };
>  
>  void mddev_set_bitmap_ops(struct mddev *mddev)
> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
> index a7cbf0c692fc..de7fbe5903dd 100644
> --- a/drivers/md/md-bitmap.h
> +++ b/drivers/md/md-bitmap.h
> @@ -236,6 +236,7 @@ struct bitmap {
>  
>  struct bitmap_operations {
>  	struct bitmap* (*create)(struct mddev *mddev, int slot);
> +	int (*load)(struct mddev *mddev);
>  };
>  
>  /* the bitmap API */
> @@ -250,7 +251,14 @@ static inline struct bitmap *md_bitmap_create(struct
> mddev *mddev, int slot) return mddev->bitmap_ops->create(mddev, slot);
>  }
>  
> -int md_bitmap_load(struct mddev *mddev);
> +static inline int md_bitmap_load(struct mddev *mddev)
> +{
> +	if (!mddev->bitmap_ops->load)
> +		return -EOPNOTSUPP;
> +
> +	return mddev->bitmap_ops->load(mddev);
> +}

At this point we have only on bitmpa op (at that probably won't change), so if
we we have bitmap_ops assigned (mddev->bitmap_ops != NULL) then ->load is must
have, hence I don't see a need for this wrapper.

you probably made this to avoid changes across code. If yes, please mention it
in commit message but I still would prefer to replace them all by calls to
mddev->bitmap_ops->load().

Mariusz

