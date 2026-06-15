Received: from mail-108-mta190.mxroute.com (mail-108-mta190.mxroute.com [136.175.108.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FB43E2745
	for <linux-raid@vger.kernel.org>; Mon, 15 Jun 2026 11:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781522491; cv=none; b=Nt0l/Zrr21zfjeR+229HqNhIgPqhQAXnESc3ZlMaBw3JvSXQS8O9CNtPytU5s/DzftNb06i6DV6uAgMZfmrpiBI3WipTNkOrj5MekchV5wca6RN5slmalrrG6c1R15imAsw5pnaBCvG3C0Y40lbPJ7Xyiup8Yrhh5xuso/h6Xfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781522491; c=relaxed/simple;
	bh=g4JgvE+ByV9gKQktaxyH8mzQRBx+XVG1zZPtUzeTJbQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=je9grHi8CEMYixiS7TgM5gjq5v5i0QnRLU1cChmt8x5uJj4DGx1j9qEBX3q0SgP/a43EYamc9r1Dpoi7UksOPveEEIWtoxBMaqD+dU3ZVmjqKcwAMuVIEv1NDoLQ0+X2A33iyEohIJjZhbcZRfDhqJRjJqBlJgfdCumCrXIYvew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=KjfFt5GT; arc=none smtp.client-ip=136.175.108.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="KjfFt5GT"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta190.mxroute.com (ZoneMTA) with ESMTPSA id 19ecaff11c700067f7.007
 for <linux-raid@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Mon, 15 Jun 2026 11:16:14 +0000
X-Zone-Loop: b20ba70242219d7fece09156d6694703e8b018298554
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Message-ID:Date:References:In-Reply-To:
	Subject:Cc:To:From:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9gmHWpXIoUUnji3WuGyLbPoPaEFcRZrRzXSyVp3C4zo=; b=KjfFt5GTiTTMSedeBv/zFaI3uj
	NX8CH78sVBh5NgZYRwxAO+0JA7fMjmkAN2ZQ9QCfAHeAsnM+ycqofeEeF/0Wva9RV64m+hqMxwRS8
	YdbndyDGijNQJTYTmKlJrU6x4yhQeN0OD4ky6UKUxCCDO8zsRS+xh/ZO9X+9wzyAAQs8+M5OqdCsu
	L9lAsM8VhM8cZTqZBaV2LZwN4eKg1TRk9dsSC2ASiY3uOesByt1r22JUkRSOYRPdKCumfWem8Q315
	kZxOREX5X72CWEl4OLLieBPcrV+Fp70S9eRqDKcvXm1BUjdCazL7IwicToaBFgi99rSwTvGVLi5ap
	gtV4O+Rw==;
From: Su Yue <l@damenly.org>
To: Yu Kuai <yukuai@kernel.org>
Cc: Song Liu <song@kernel.org>,  Yu Kuai <yukuai@fygo.io>,  Li Nan
 <magiclinan@didiglobal.com>,  Xiao Ni <xiao@kernel.org>,
  linux-raid@vger.kernel.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md/md-llbitmap: grow the page cache in place for reshape
In-Reply-To: <20260605091527.2463539-7-yukuai@kernel.org> (Yu Kuai's message
	of "Fri, 5 Jun 2026 17:15:13 +0800")
References: <20260605091527.2463539-1-yukuai@kernel.org>
	<20260605091527.2463539-7-yukuai@kernel.org>
User-Agent: mu4e 1.12.7; emacs 30.2
Date: Mon, 15 Jun 2026 19:16:04 +0800
Message-ID: <8q8gawaz.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Authenticated-Id: l@damenly.org

On Fri 05 Jun 2026 at 17:15, Yu Kuai <yukuai@kernel.org> wrote:

> From: Yu Kuai <yukuai@fygo.io>
>
> Use the page-control helpers to grow llbitmap's cached pages in 
> place
> for resize and later reshape preparation, instead of rebuilding 
> the
> whole cache.
>
> Signed-off-by: Yu Kuai <yukuai@fygo.io>
> ---
>  drivers/md/md-llbitmap.c | 139 
>  +++++++++++++++++++++++++++++++++++----
>  1 file changed, 127 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index 2f2896fe4d6f..91d3dec43d48 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
> @@ -414,10 +414,23 @@ static char 
> state_machine[BitStateCount][BitmapActionCount] = {
>  		[BitmapActionClearUnwritten]	= BitUnwritten,
>  	},
>  };
>
>  static void __llbitmap_flush(struct mddev *mddev);
> +static void llbitmap_flush(struct mddev *mddev);
> +static void llbitmap_update_sb(void *data);
> +
> +static void llbitmap_resize_chunks(struct mddev *mddev, 
> sector_t blocks,
> +				   unsigned long *chunksize,
> +				   unsigned long *chunks)
>
NIT: I would like call it llbitmap_calculate_chunks.

> +{
> +	*chunks = DIV_ROUND_UP_SECTOR_T(blocks, *chunksize);
> +	while (*chunks > mddev->bitmap_info.space << SECTOR_SHIFT) {
> +		*chunksize = *chunksize << 1;
> +		*chunks = DIV_ROUND_UP_SECTOR_T(blocks, *chunksize);
> +	}
> +}
>
>  static enum llbitmap_state llbitmap_read(struct llbitmap 
>  *llbitmap, loff_t pos)
>  {
>  	unsigned int idx;
>  	unsigned int offset;
> @@ -653,10 +666,52 @@ static unsigned int 
> llbitmap_reserved_pages(struct llbitmap *llbitmap)
>  {
>  	return DIV_ROUND_UP(llbitmap->mddev->bitmap_info.space << 
>  SECTOR_SHIFT,
>  			    PAGE_SIZE);
>  }
>
> +static int llbitmap_expand_pages(struct llbitmap *llbitmap,
> +				 unsigned long chunks)
> +{
> +	struct llbitmap_page_ctl **pctl;
> +	unsigned int old_nr_pages = llbitmap->nr_pages;
> +	unsigned int nr_pages = llbitmap_used_pages(llbitmap, chunks);
> +	int i;
> +	int ret;
> +
> +	if (nr_pages <= old_nr_pages)
> +		return 0;
> +
> +	pctl = kcalloc(nr_pages, sizeof(*pctl), GFP_KERNEL);
> +	if (!pctl)
> +		return -ENOMEM;
> +
> +	if (llbitmap->pctl)
> +		memcpy(pctl, llbitmap->pctl,
> +		       array_size(old_nr_pages, sizeof(*pctl)));
> +
> +	for (i = old_nr_pages; i < nr_pages; i++) {
> +		pctl[i] = llbitmap_alloc_page_ctl(llbitmap, i);
> +		if (IS_ERR(pctl[i]))
> +			goto err_alloc_ptr;
> +	}
> +
> +	kfree(llbitmap->pctl);
> +	llbitmap->pctl = pctl;
> +	llbitmap->nr_pages = nr_pages;
> +	return 0;
> +
> +err_alloc_ptr:
> +	ret = PTR_ERR(pctl[i]);
> +	for (i--; i >= (int)old_nr_pages; i--) {
>
Confused about why not just declare i as an unsigned int?


--
Su
> +		__free_page(pctl[i]->page);
> +		percpu_ref_exit(&pctl[i]->active);
> +		kfree(pctl[i]);
> +	}
> +	kfree(pctl);
> +	return ret;
> +}
> +
>  static int llbitmap_alloc_pages(struct llbitmap *llbitmap)
>  {
>  	unsigned int used_pages = llbitmap_used_pages(llbitmap, 
>  llbitmap->chunks);
>  	unsigned int nr_pages = max(used_pages, 
>  llbitmap_reserved_pages(llbitmap));
>  	int i;
> @@ -728,10 +783,38 @@ static bool llbitmap_zero_all_disks(struct 
> llbitmap *llbitmap)
>  	}
>
>  	return true;
>  }
>
> +static void llbitmap_mark_range(struct llbitmap *llbitmap,
> +				unsigned long start,
> +				unsigned long end,
> +				enum llbitmap_state state)
> +{
> +	while (start <= end) {
> +		llbitmap_write(llbitmap, state, start);
> +		start++;
> +	}
> +}
> +
> +static int llbitmap_prepare_resize(struct llbitmap *llbitmap,
> +				   unsigned long old_chunks,
> +				   unsigned long new_chunks,
> +				   unsigned long cache_chunks)
> +{
> +	int ret;
> +
> +	llbitmap_flush(llbitmap->mddev);
> +	ret = llbitmap_expand_pages(llbitmap, cache_chunks);
> +	if (ret)
> +		return ret;
> +	if (new_chunks > old_chunks)
> +		llbitmap_mark_range(llbitmap, old_chunks, new_chunks - 1,
> +				    BitUnwritten);
> +	return 0;
> +}
> +
>  static void llbitmap_init_state(struct llbitmap *llbitmap)
>  {
>  	struct mddev *mddev = llbitmap->mddev;
>  	enum llbitmap_state state = BitUnwritten;
>  	unsigned long i;
> @@ -1024,14 +1107,14 @@ static int llbitmap_read_sb(struct 
> llbitmap *llbitmap)
>  		pr_err("md/llbitmap: %s: chunksize not a power of 2",
>  		       mdname(mddev));
>  		goto out_put_page;
>  	}
>
> -	if (chunksize < 
> DIV_ROUND_UP_SECTOR_T(mddev->resync_max_sectors,
> +	if (chunksize < DIV_ROUND_UP_SECTOR_T(sync_size,
>  					      mddev->bitmap_info.space << 
>  SECTOR_SHIFT)) {
>  		pr_err("md/llbitmap: %s: chunksize too small %lu < %llu / 
>  %lu",
> -		       mdname(mddev), chunksize, 
> mddev->resync_max_sectors,
> +		       mdname(mddev), chunksize, sync_size,
>  		       mddev->bitmap_info.space);
>  		goto out_put_page;
>  	}
>
>  	daemon_sleep = le32_to_cpu(sb->daemon_sleep);
> @@ -1169,28 +1252,60 @@ static int llbitmap_create(struct mddev 
> *mddev)
>  }
>
>  static int llbitmap_resize(struct mddev *mddev, sector_t 
>  blocks, int chunksize)
>  {
>  	struct llbitmap *llbitmap = mddev->bitmap;
> +	sector_t old_blocks = llbitmap->sync_size;
> +	unsigned long old_chunks = llbitmap->chunks;
>  	unsigned long chunks;
> +	unsigned long cache_chunks;
> +	int ret = 0;
> +	unsigned long bitmap_chunksize;
> +	bool reshape;
>
>  	if (chunksize == 0)
>  		chunksize = llbitmap->chunksize;
>
> -	/* If there is enough space, leave the chunksize unchanged. */
> -	chunks = DIV_ROUND_UP_SECTOR_T(blocks, chunksize);
> -	while (chunks > mddev->bitmap_info.space << SECTOR_SHIFT) {
> -		chunksize = chunksize << 1;
> -		chunks = DIV_ROUND_UP_SECTOR_T(blocks, chunksize);
> -	}
> +	bitmap_chunksize = chunksize;
> +	llbitmap_resize_chunks(mddev, blocks, &bitmap_chunksize, 
> &chunks);
>
> -	llbitmap->chunkshift = ffz(~chunksize);
> -	llbitmap->chunksize = chunksize;
> -	llbitmap->chunks = chunks;
> -	llbitmap->sync_size = blocks;
> +	reshape = mddev->delta_disks || mddev->new_level != 
> mddev->level ||
> +		mddev->new_layout != mddev->layout ||
> +		mddev->new_chunk_sectors != mddev->chunk_sectors;
> +	if (!reshape && bitmap_chunksize != llbitmap->chunksize)
> +		return -EOPNOTSUPP;
> +	if (blocks == old_blocks && chunks == llbitmap->chunks)
> +		return 0;
> +
> +	mutex_lock(&mddev->bitmap_info.mutex);
>
> +	cache_chunks = reshape ? max(old_chunks, chunks) : chunks;
> +	ret = llbitmap_prepare_resize(llbitmap, old_chunks, chunks, 
> cache_chunks);
> +	if (ret)
> +		goto out;
> +
> +	if (reshape) {
> +		llbitmap->reshape_sync_size = blocks;
> +		llbitmap->reshape_chunksize = bitmap_chunksize;
> +		llbitmap->reshape_chunks = chunks;
> +		llbitmap->chunks = max(old_chunks, chunks);
> +	} else {
> +		if (blocks < old_blocks && chunks < old_chunks)
> +			llbitmap_mark_range(llbitmap, chunks, old_chunks - 1,
> +					    BitUnwritten);
> +		mddev->bitmap_info.chunksize = bitmap_chunksize;
> +		llbitmap->chunks = chunks;
> +		llbitmap->sync_size = blocks;
> +		llbitmap_update_sb(llbitmap);
> +	}
> +	__llbitmap_flush(mddev);
> +	mutex_unlock(&mddev->bitmap_info.mutex);
>  	return 0;
> +
> +out:
> +	mutex_unlock(&mddev->bitmap_info.mutex);
> +	return ret;
>  }
>
>  static int llbitmap_load(struct mddev *mddev)
>  {
>  	enum llbitmap_action action = BitmapActionReload;
