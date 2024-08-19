Received: from mail-108-mta26.mxroute.com (mail-108-mta26.mxroute.com [136.175.108.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22A91459E0
	for <linux-raid@vger.kernel.org>; Mon, 19 Aug 2024 08:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724055496; cv=none; b=rixYS0m3w/hgQuyIcL2TBael9EtW1MmeDRdxawESwIrlwuTNs/mTMcYywBF39N/dRwPWKSvRWhLF5eXuo0AWBNfxGcg6CRiSbeRg83jqsbEaY8Z1ZrO0F4aqeoNlF3TAvcnHzi6NjH1oMNSPjMNcNVvIcbznOLX856uCvJrwe1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724055496; c=relaxed/simple;
	bh=B1sL1nqIbqxp1OMCQlFelTdXlJbTmr29dEDJRJGp9zg=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=LdxklJ07X73ocnRrhFbMh64GlHc4BeI6ihE6rNJKZ6iD0sxpZR1wTXz0T86BW/sPeN3IVIAAoDAh///Bc0qQcEIe6gYaOuDlNI1X4+xNBP+8bi/sYFoauZdL740sMiVnVqZ4t4e8CSdtPaAfP3p60qCoFvKVBDpRX+cY/Y8laQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=uoxIxAcA; arc=none smtp.client-ip=136.175.108.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="uoxIxAcA"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta26.mxroute.com (ZoneMTA) with ESMTPSA id 19169b254af0000a78.009
 for <linux-raid@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Mon, 19 Aug 2024 08:13:00 +0000
X-Zone-Loop: 2b8c46add1bfb5f77c41d1bcb0984a9f7dcfb73b555d
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Message-ID:In-reply-to:Date:Subject:Cc:To:
	From:References:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=c/T5CP31W4/nzsuZs/z4SAyLpBks2D9t3TvDABw9ZCg=; b=uoxIxAcAIhhkCtyexSkiUGdCmJ
	St1np7r6rG7Xn8OuADMQjO5vTlNmOXg/GLecyIv2ykY1n0V81C6mu5lDp23bvVOYYT69he46eClcR
	5actZfuHnAgpqBBgeKENMAQwOw+tT11bsmNovVv/Gw4dODSCBTDtNXhJRb776ofwUFK2PyS2OeXMj
	Qr7pAJwZKCGc1/EpshtHfH5YYR82V/mW4rgj/FwtswT+eWWezzWYVW4yAV+bPfghjg7cO14e6a4gt
	c4HuzrGF3Udg+oP+R3Y/cl9qusF0GJNoI69uYN6/8ouh5qxbgEqi0mdAPbQb0NkcYRiqqdptNf96w
	7my8IfFg==;
References: <20240814071113.346781-1-yukuai1@huaweicloud.com>
 <20240814071113.346781-12-yukuai1@huaweicloud.com>
User-agent: mu4e 1.7.5; emacs 28.2
From: Su Yue <l@damenly.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: mariusz.tkaczyk@linux.intel.com, hch@infradead.org, song@kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH RFC -next v2 11/41] md/md-bitmap: simplify
 md_bitmap_create() + md_bitmap_load()
Date: Mon, 19 Aug 2024 16:10:39 +0800
In-reply-to: <20240814071113.346781-12-yukuai1@huaweicloud.com>
Message-ID: <ikvxorrl.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Authenticated-Id: l@damenly.org


On Wed 14 Aug 2024 at 15:10, Yu Kuai <yukuai1@huaweicloud.com> 
wrote:

> From: Yu Kuai <yukuai3@huawei.com>
>
> Other than internal api get_bitmap_from_slot(), all other places 
> will
> set returned bitmap to mddev->bitmap. So move the setting of
> mddev->bitmap into md_bitmap_create() to simplify code.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md-bitmap.c | 23 +++++++++++++++--------
>  drivers/md/md-bitmap.h |  2 +-
>  drivers/md/md.c        | 30 +++++++++---------------------
>  3 files changed, 25 insertions(+), 30 deletions(-)
>
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index eed3b930ade4..75e58da9a1a5 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -1879,7 +1879,7 @@ void md_bitmap_destroy(struct mddev 
> *mddev)
>   * if this returns an error, bitmap_destroy must be called to 
>   do clean up
>   * once mddev->bitmap is set
>   */
> -struct bitmap *md_bitmap_create(struct mddev *mddev, int slot)
> +static struct bitmap *bitmap_create(struct mddev *mddev, int 
> slot)
>  {
>  	struct bitmap *bitmap;
>  	sector_t blocks = mddev->resync_max_sectors;
> @@ -1966,6 +1966,17 @@ struct bitmap *md_bitmap_create(struct 
> mddev *mddev, int slot)
>  	return ERR_PTR(err);
>  }
>
> +int md_bitmap_create(struct mddev *mddev, int slot)
>
NIT: We have two functions named md_bitmap_create() now. The 
static
one will be renamed to __md_bitmap_create in next patch. Better to 
rename
in this patch.

--
Su

> +{
> +	struct bitmap *bitmap = bitmap_create(mddev, slot);
> +
> +	if (IS_ERR(bitmap))
> +		return PTR_ERR(bitmap);
> +
> +	mddev->bitmap = bitmap;
> +	return 0;
> +}
> +
>  int md_bitmap_load(struct mddev *mddev)
>  {
>  	int err = 0;
> @@ -2030,7 +2041,7 @@ struct bitmap *get_bitmap_from_slot(struct 
> mddev *mddev, int slot)
>  	int rv = 0;
>  	struct bitmap *bitmap;
>
> -	bitmap = md_bitmap_create(mddev, slot);
> +	bitmap = bitmap_create(mddev, slot);
>  	if (IS_ERR(bitmap)) {
>  		rv = PTR_ERR(bitmap);
>  		return ERR_PTR(rv);
> @@ -2381,7 +2392,6 @@ location_store(struct mddev *mddev, const 
> char *buf, size_t len)
>  	} else {
>  		/* No bitmap, OK to set a location */
>  		long long offset;
> -		struct bitmap *bitmap;
>
>  		if (strncmp(buf, "none", 4) == 0)
>  			/* nothing to be done */;
> @@ -2408,13 +2418,10 @@ location_store(struct mddev *mddev, 
> const char *buf, size_t len)
>  			}
>
>  			mddev->bitmap_info.offset = offset;
> -			bitmap = md_bitmap_create(mddev, -1);
> -			if (IS_ERR(bitmap)) {
> -				rv = PTR_ERR(bitmap);
> +			rv = md_bitmap_create(mddev, -1);
> +			if (rv)
>  				goto out;
> -			}
>
> -			mddev->bitmap = bitmap;
>  			rv = md_bitmap_load(mddev);
>  			if (rv) {
>  				mddev->bitmap_info.offset = 0;
> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
> index a8a5d4804174..e187f9099f2e 100644
> --- a/drivers/md/md-bitmap.h
> +++ b/drivers/md/md-bitmap.h
> @@ -252,7 +252,7 @@ struct bitmap_operations {
>  void mddev_set_bitmap_ops(struct mddev *mddev);
>
>  /* these are used only by md/bitmap */
> -struct bitmap *md_bitmap_create(struct mddev *mddev, int slot);
> +int md_bitmap_create(struct mddev *mddev, int slot);
>  int md_bitmap_load(struct mddev *mddev);
>  void md_bitmap_flush(struct mddev *mddev);
>  void md_bitmap_destroy(struct mddev *mddev);
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index f67f2540fd6c..6e130f6c2abd 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6211,16 +6211,10 @@ int md_run(struct mddev *mddev)
>  	}
>  	if (err == 0 && pers->sync_request &&
>  	    (mddev->bitmap_info.file || mddev->bitmap_info.offset)) {
> -		struct bitmap *bitmap;
> -
> -		bitmap = md_bitmap_create(mddev, -1);
> -		if (IS_ERR(bitmap)) {
> -			err = PTR_ERR(bitmap);
> +		err = md_bitmap_create(mddev, -1);
> +		if (err)
>  			pr_warn("%s: failed to create bitmap (%d)\n",
>  				mdname(mddev), err);
> -		} else
> -			mddev->bitmap = bitmap;
> -
>  	}
>  	if (err)
>  		goto bitmap_abort;
> @@ -7275,14 +7269,10 @@ static int set_bitmap_file(struct mddev 
> *mddev, int fd)
>  	err = 0;
>  	if (mddev->pers) {
>  		if (fd >= 0) {
> -			struct bitmap *bitmap;
> -
> -			bitmap = md_bitmap_create(mddev, -1);
> -			if (!IS_ERR(bitmap)) {
> -				mddev->bitmap = bitmap;
> +			err = md_bitmap_create(mddev, -1);
> +			if (!err)
>  				err = md_bitmap_load(mddev);
> -			} else
> -				err = PTR_ERR(bitmap);
> +
>  			if (err) {
>  				md_bitmap_destroy(mddev);
>  				fd = -1;
> @@ -7291,6 +7281,7 @@ static int set_bitmap_file(struct mddev 
> *mddev, int fd)
>  			md_bitmap_destroy(mddev);
>  		}
>  	}
> +
>  	if (fd < 0) {
>  		struct file *f = mddev->bitmap_info.file;
>  		if (f) {
> @@ -7559,7 +7550,6 @@ static int update_array_info(struct mddev 
> *mddev, mdu_array_info_t *info)
>  			goto err;
>  		}
>  		if (info->state & (1<<MD_SB_BITMAP_PRESENT)) {
> -			struct bitmap *bitmap;
>  			/* add the bitmap */
>  			if (mddev->bitmap) {
>  				rv = -EEXIST;
> @@ -7573,12 +7563,10 @@ static int update_array_info(struct 
> mddev *mddev, mdu_array_info_t *info)
>  				mddev->bitmap_info.default_offset;
>  			mddev->bitmap_info.space =
>  				mddev->bitmap_info.default_space;
> -			bitmap = md_bitmap_create(mddev, -1);
> -			if (!IS_ERR(bitmap)) {
> -				mddev->bitmap = bitmap;
> +			rv = md_bitmap_create(mddev, -1);
> +			if (!rv)
>  				rv = md_bitmap_load(mddev);
> -			} else
> -				rv = PTR_ERR(bitmap);
> +
>  			if (rv)
>  				md_bitmap_destroy(mddev);
>  		} else {
