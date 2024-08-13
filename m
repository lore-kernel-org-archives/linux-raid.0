Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9C013B791;
	Tue, 13 Aug 2024 07:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723533448; cv=none; b=PpPvSL56MxT+G6xvLaam1tdVBBp8mzv4hMZXMed2j6ipN67FDsK/hmX8w+Sq/UksViL8Hbq1IW302978WIPA1ksSO8xHLvTSBbToQilp6L8BYdYZ4TBHFfT34iJ9MXEmA7HGJw5/aRA3O5iFe6UbnVO0cHV124k1/HHjeKwqB+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723533448; c=relaxed/simple;
	bh=rSfOoHYLjbHwRzm1rpzMuYbKnXWG4cxuzGdhaGtJfSc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A1I70XqDcSjRJ/XnQNrqPrl7h276YWjh3PkpQ0FzunHoKCVkWbdcI7UiS1/7m2vi/U6VmyV6SFJpMOx5FePdUFBFXTlZmTOdrqsxW4NEXdAa1qPjcdXDlPivX4yPHeHl+AkdziI+/TFj84nVkX/zJ6CPVtmMPrB+AcaaZ6hYti8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jXeUCkpJ; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jXeUCkpJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723533448; x=1755069448;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rSfOoHYLjbHwRzm1rpzMuYbKnXWG4cxuzGdhaGtJfSc=;
  b=jXeUCkpJ7x/yQMbS8GD9suJVjKEelpkKMIfX/sI/eTIwT/AD/jYlHLP9
   tVFgCuQqVwHioU5ABfPIGouoGmxQvHxYgIKm4S+RinKxERi70/fV6tJeP
   qdP+d+tRevCtoXz3oXDC+nBibwU+OUwbJ8Yjtr+Qu1lkHnL3OTRIl58f9
   mPjoQAcnIyjgG0yq6Rk+SgSmB5u0eQRVdVaG3NwAaN+g9G74J872unOZr
   cI3FGm3sn1exKm9901GYAKFCI9n9dSPjHRjhR8axNjBHvTYhgXbHPElb8
   X9QCo9bJvaLCqJfDiUY5tNbXOypN0GfgD/M+DUWtw6jBY8NzBfIyOL/cI
   w==;
X-CSE-ConnectionGUID: +YgstOkZTACtm9RHZcWxsw==
X-CSE-MsgGUID: M1IenQ4wTH6yTYOSPXYQ0A==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="33061751"
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="33061751"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 00:17:27 -0700
X-CSE-ConnectionGUID: Y+c+3U4bSh2EZCW8Ec5PBQ==
X-CSE-MsgGUID: rgXa8TPsQ3mH98wmN5U1rg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="58443949"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.112.252])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 00:17:24 -0700
Date: Tue, 13 Aug 2024 09:17:19 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com,
 yangerkun@huawei.com
Subject: Re: [PATCH RFC -next 07/26] md/md-bitmap: merge
 md_bitmap_update_sb() into bitmap_operations
Message-ID: <20240813091719.0000202a@linux.intel.com>
In-Reply-To: <20240810020854.797814-8-yukuai1@huaweicloud.com>
References: <20240810020854.797814-1-yukuai1@huaweicloud.com>
	<20240810020854.797814-8-yukuai1@huaweicloud.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 10 Aug 2024 10:08:35 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> From: Yu Kuai <yukuai3@huawei.com>
> 
> So that the implementation won't be exposed, and it'll be possible
> to invent a new bitmap by replacing bitmap_operations.

Please update commit message.

> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md-bitmap.c  | 15 ++++++++-------
>  drivers/md/md-bitmap.h  | 11 ++++++++++-
>  drivers/md/md-cluster.c |  3 ++-
>  drivers/md/md.c         |  4 ++--
>  4 files changed, 22 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 0ff733756043..b34f13aa2697 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -472,7 +472,7 @@ static void md_bitmap_wait_writes(struct bitmap *bitmap)
>  
>  
>  /* update the event counter and sync the superblock to disk */
> -void md_bitmap_update_sb(struct bitmap *bitmap)
> +static void bitmap_update_sb(struct bitmap *bitmap)
>  {
>  	bitmap_super_t *sb;
>  
> @@ -510,7 +510,6 @@ void md_bitmap_update_sb(struct bitmap *bitmap)
>  		write_sb_page(bitmap, bitmap->storage.sb_index,
>  			      bitmap->storage.sb_page, 1);
>  }
> -EXPORT_SYMBOL(md_bitmap_update_sb);
>  
>  /* print out the bitmap file superblock */
>  static void bitmap_print_sb(struct bitmap *bitmap)
> @@ -893,7 +892,7 @@ static void md_bitmap_file_unmap(struct bitmap_storage
> *store) static void md_bitmap_file_kick(struct bitmap *bitmap)
>  {
>  	if (!test_and_set_bit(BITMAP_STALE, &bitmap->flags)) {
> -		md_bitmap_update_sb(bitmap);
> +		bitmap_update_sb(bitmap);
>  
>  		if (bitmap->storage.file) {
>  			pr_warn("%s: kicking failed bitmap file %pD4 from
> array!\n", @@ -1796,7 +1795,7 @@ static void bitmap_flush(struct mddev *mddev)
>  	md_bitmap_daemon_work(mddev);
>  	if (mddev->bitmap_info.external)
>  		md_super_wait(mddev);
> -	md_bitmap_update_sb(bitmap);
> +	bitmap_update_sb(bitmap);
>  }
>  
>  /*
> @@ -2014,7 +2013,7 @@ static int bitmap_load(struct mddev *mddev)
>  	mddev_set_timeout(mddev, mddev->bitmap_info.daemon_sleep, true);
>  	md_wakeup_thread(mddev->thread);
>  
> -	md_bitmap_update_sb(bitmap);
> +	bitmap_update_sb(bitmap);

You changed function name here and it is harmful for git blame. What is the
reason behind that? it must be described in commit message to help Song making
the decision if it is worthy merging or not.

>  
>  	if (test_bit(BITMAP_WRITE_ERROR, &bitmap->flags))
>  		err = -EIO;
> @@ -2075,7 +2074,7 @@ int md_bitmap_copy_from_slot(struct mddev *mddev, int
> slot, }
>  
>  	if (clear_bits) {
> -		md_bitmap_update_sb(bitmap);
> +		bitmap_update_sb(bitmap);
>  		/* BITMAP_PAGE_PENDING is set, but bitmap_unplug needs
>  		 * BITMAP_PAGE_DIRTY or _NEEDWRITE to write ... */
>  		for (i = 0; i < bitmap->storage.file_pages; i++)
> @@ -2568,7 +2567,7 @@ backlog_store(struct mddev *mddev, const char *buf,
> size_t len) mddev_create_serial_pool(mddev, rdev);
>  	}
>  	if (old_mwb != backlog)
> -		md_bitmap_update_sb(mddev->bitmap);
> +		bitmap_update_sb(mddev->bitmap);
>  
>  	mddev_unlock_and_resume(mddev);
>  	return len;
> @@ -2712,6 +2711,8 @@ static struct bitmap_operations bitmap_ops = {
>  	.load			= bitmap_load,
>  	.destroy		= bitmap_destroy,
>  	.flush			= bitmap_flush,
> +
> +	.update_sb		= bitmap_update_sb,
>  };
>  
>  void mddev_set_bitmap_ops(struct mddev *mddev)
> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
> index 935c5dc45b89..29c217630ae5 100644
> --- a/drivers/md/md-bitmap.h
> +++ b/drivers/md/md-bitmap.h
> @@ -239,6 +239,8 @@ struct bitmap_operations {
>  	int (*load)(struct mddev *mddev);
>  	void (*destroy)(struct mddev *mddev);
>  	void (*flush)(struct mddev *mddev);
> +
> +	void (*update_sb)(struct bitmap *bitmap);
>  };
>  
>  /* the bitmap API */
> @@ -277,7 +279,14 @@ static inline void md_bitmap_flush(struct mddev *mddev)
>  	mddev->bitmap_ops->flush(mddev);
>  }
>  
> -void md_bitmap_update_sb(struct bitmap *bitmap);
> +static inline void md_bitmap_update_sb(struct mddev *mddev)
> +{
> +	if (!mddev->bitmap || !mddev->bitmap_ops->update_sb)
> +		return;

I would like to avoid dead code here. !mddev->bitmap is probably not an option
an this point in code. !mddev->bitmap_ops->update_sb i not an option because we
have only one bitmap op. Do I miss something?

I will stop here for today now to give you a chance to reply, to be sure that
we are on same page. I see that my comments are similar so it may not be worthy
to go one by one and repeat same comment. I may miss something important.

Thanks
Mariusz

