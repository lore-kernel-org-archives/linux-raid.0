Received: from mail-108-mta96.mxroute.com (mail-108-mta96.mxroute.com [136.175.108.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFFB3E3C48
	for <linux-raid@vger.kernel.org>; Mon, 15 Jun 2026 11:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.96
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781521907; cv=none; b=qJ4ywDCZjfWPN3vMy9czZuKK/jtuSsd0D5vViVVSkQswtvYrC11j4nWNCGglXG77Q8upq746DcwKzD3NXHyIcbMXIGrDY8nrrWmpQcqJVS0iWN4J1xLp9XxGbDErEzyv+p0R/hNluMZ/q780KN8igsadGEHnzNFJAcr1s2eb4Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781521907; c=relaxed/simple;
	bh=Fx4jtCVJwUBAQKObV+eiIzAWUdKlzPqpjFGtTp2I1X8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=uf7zh+RQ/SUNtXpbsQwkHDD+iGwtztJ2FKbkvqaHBkNbZX8a2M7j9baodH28hMBfX54Gd0IXzDbZM/vHUoAvy6jjMLtzZkefY83SDNVImMNbiOp1BSRKX1F56oTKD8KqeV3RUw5J5sLgMFaDkCkpD4ZxefmlTSaj5GgkHeUenPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=JAdZSRP6; arc=none smtp.client-ip=136.175.108.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="JAdZSRP6"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta96.mxroute.com (ZoneMTA) with ESMTPSA id 19ecaf62d0600067f7.007
 for <linux-raid@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Mon, 15 Jun 2026 11:06:31 +0000
X-Zone-Loop: 8594eaa46d3f8f3a502322b7040cd2a67d1a7471e1b6
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Message-ID:Date:References:In-Reply-To:
	Subject:Cc:To:From:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=xhN9+Ovm0IRX7RjfmlOK2I6GMgea8nh9m7Evv4gWBMU=; b=JAdZSRP6l+72HWOl/faa+xcV8V
	FAFJFb8ALac3zfsYwHkXYzjTjsgJZJfnqjt4ryXncVLoxdNiAmuhnuCMPT36rs+ASFmsQxg8FW8hk
	D0miHOrNAeXH5NgSuD7T9n1Jrs8Xi94xN8eIUD+h4GA5P3u+41e+TTVAgy652LfqpDpevJ7yDXwUX
	Qb/BD7m7M6nG5hUvM5v0H/JSG3DBW58lOyFhHRxelDqJBNon1aWICabN/3vEX/EUJbjQ6wBzzG4LR
	Ctf567zZvfA98b0f+i9pNhws8X62rYK2Ojv7KF7jJ/jNOOcqlVBpRan8SvC8aQnmSkMYaDwvIotaB
	BYgBBsBw==;
From: Su Yue <l@damenly.org>
To: Yu Kuai <yukuai@kernel.org>
Cc: Song Liu <song@kernel.org>,  Yu Kuai <yukuai@fygo.io>,  Li Nan
 <magiclinan@didiglobal.com>,  Xiao Ni <xiao@kernel.org>,
  linux-raid@vger.kernel.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md/md-llbitmap: allocate page controls independently
In-Reply-To: <20260605091527.2463539-6-yukuai@kernel.org> (Yu Kuai's message
	of "Fri, 5 Jun 2026 17:15:12 +0800")
References: <20260605091527.2463539-1-yukuai@kernel.org>
	<20260605091527.2463539-6-yukuai@kernel.org>
User-Agent: mu4e 1.12.7; emacs 30.2
Date: Mon, 15 Jun 2026 19:06:23 +0800
Message-ID: <h5n4awr4.fsf@damenly.org>
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
> Allocate one llbitmap page-control object at a time and free 
> each
> object through the same model.
>
> Let llbitmap_read_page() return a zeroed page without reading 
> disk when
> the page index is beyond the current bitmap size, so 
> page-control
> allocation no longer needs a separate read_existing flag.
>
> This keeps the llbitmap page-control lifetime self-consistent 
> and
> prepares the page-cache code for later in-place growth.
>
> Signed-off-by: Yu Kuai <yukuai@fygo.io>
>

Straight enough.

Reviewed-by: Su Yue <glass.su@suse.com>

> ---
>  drivers/md/md-llbitmap.c | 99 
>  +++++++++++++++++++++++++---------------
>  1 file changed, 62 insertions(+), 37 deletions(-)
>
> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index ecf3ed712315..2f2896fe4d6f 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
> @@ -510,24 +510,32 @@ static void llbitmap_write(struct llbitmap 
> *llbitmap, enum llbitmap_state state,
>  		llbitmap_set_page_dirty(llbitmap, idx, bit, true);
>  	else if (state == BitNeedSyncUnwritten)
>  		llbitmap_set_page_dirty(llbitmap, idx, bit, false);
>  }
>
> +static unsigned int llbitmap_used_pages(struct llbitmap 
> *llbitmap,
> +					unsigned long chunks)
> +{
> +	return DIV_ROUND_UP(chunks + BITMAP_DATA_OFFSET, PAGE_SIZE);
> +}
> +
>  static struct page *llbitmap_read_page(struct llbitmap 
>  *llbitmap, int idx)
>  {
>  	struct mddev *mddev = llbitmap->mddev;
>  	struct page *page = NULL;
>  	struct md_rdev *rdev;
>
> -	if (llbitmap->pctl && llbitmap->pctl[idx])
> +	if (llbitmap->pctl && idx < llbitmap->nr_pages && 
> llbitmap->pctl[idx])
>  		page = llbitmap->pctl[idx]->page;
>  	if (page)
>  		return page;
>
>  	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
>  	if (!page)
>  		return ERR_PTR(-ENOMEM);
> +	if (idx >= llbitmap_used_pages(llbitmap, llbitmap->chunks))
> +		return page;
>
>  	rdev_for_each(rdev, mddev) {
>  		sector_t sector;
>
>  		if (rdev->raid_disk < 0 || test_bit(Faulty, &rdev->flags) 
>  ||
> @@ -594,65 +602,82 @@ static void llbitmap_free_pages(struct 
> llbitmap *llbitmap)
>  		return;
>
>  	for (i = 0; i < llbitmap->nr_pages; i++) {
>  		struct llbitmap_page_ctl *pctl = llbitmap->pctl[i];
>
> -		if (!pctl || !pctl->page)
> -			break;
> -
> -		__free_page(pctl->page);
> +		if (!pctl)
> +			continue;
> +		if (pctl->page)
> +			__free_page(pctl->page);
>  		percpu_ref_exit(&pctl->active);
> +		kfree(pctl);
>  	}
>
> -	kfree(llbitmap->pctl[0]);
>  	kfree(llbitmap->pctl);
>  	llbitmap->pctl = NULL;
>  }
>
> -static int llbitmap_cache_pages(struct llbitmap *llbitmap)
> +static struct llbitmap_page_ctl *
> +llbitmap_alloc_page_ctl(struct llbitmap *llbitmap, int idx)
>  {
>  	struct llbitmap_page_ctl *pctl;
> -	unsigned int nr_pages = DIV_ROUND_UP(llbitmap->chunks +
> -					     BITMAP_DATA_OFFSET, PAGE_SIZE);
> +	struct page *page;
>  	unsigned int size = struct_size(pctl, dirty, BITS_TO_LONGS(
>  						llbitmap->blocks_per_page));
> -	int i;
> -
> -	llbitmap->pctl = kmalloc_array(nr_pages, sizeof(void *),
> -				       GFP_KERNEL | __GFP_ZERO);
> -	if (!llbitmap->pctl)
> -		return -ENOMEM;
>
>  	size = round_up(size, cache_line_size());
> -	pctl = kmalloc_array(nr_pages, size, GFP_KERNEL | __GFP_ZERO);
> -	if (!pctl) {
> -		kfree(llbitmap->pctl);
> -		return -ENOMEM;
> +	pctl = kzalloc(size, GFP_KERNEL);
> +	if (!pctl)
> +		return ERR_PTR(-ENOMEM);
> +
> +	page = llbitmap_read_page(llbitmap, idx);
> +
> +	if (IS_ERR(page)) {
> +		kfree(pctl);
> +		return ERR_CAST(page);
>  	}
>
> -	llbitmap->nr_pages = nr_pages;
> +	if (percpu_ref_init(&pctl->active, active_release,
> +			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
> +		__free_page(page);
> +		kfree(pctl);
> +		return ERR_PTR(-ENOMEM);
> +	}
>
> -	for (i = 0; i < nr_pages; i++, pctl = (void *)pctl + size) {
> -		struct page *page = llbitmap_read_page(llbitmap, i);
> +	pctl->page = page;
> +	pctl->state = page_address(page);
> +	init_waitqueue_head(&pctl->wait);
> +	return pctl;
> +}
>
> -		llbitmap->pctl[i] = pctl;
> +static unsigned int llbitmap_reserved_pages(struct llbitmap 
> *llbitmap)
> +{
> +	return DIV_ROUND_UP(llbitmap->mddev->bitmap_info.space << 
> SECTOR_SHIFT,
> +			    PAGE_SIZE);
> +}
>
> -		if (IS_ERR(page)) {
> -			llbitmap_free_pages(llbitmap);
> -			return PTR_ERR(page);
> -		}
> +static int llbitmap_alloc_pages(struct llbitmap *llbitmap)
> +{
> +	unsigned int used_pages = llbitmap_used_pages(llbitmap, 
> llbitmap->chunks);
> +	unsigned int nr_pages = max(used_pages, 
> llbitmap_reserved_pages(llbitmap));
> +	int i;
> +
> +	llbitmap->pctl = kcalloc(nr_pages, sizeof(*llbitmap->pctl), 
> GFP_KERNEL);
> +	if (!llbitmap->pctl)
> +		return -ENOMEM;
>
> -		if (percpu_ref_init(&pctl->active, active_release,
> -				    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
> -			__free_page(page);
> +	llbitmap->nr_pages = nr_pages;
> +
> +	for (i = 0; i < nr_pages; i++) {
> +		llbitmap->pctl[i] = llbitmap_alloc_page_ctl(llbitmap, i);
> +		if (IS_ERR(llbitmap->pctl[i])) {
> +			int ret = PTR_ERR(llbitmap->pctl[i]);
> +
> +			llbitmap->pctl[i] = NULL;
>  			llbitmap_free_pages(llbitmap);
> -			return -ENOMEM;
> +			return ret;
>  		}
> -
> -		pctl->page = page;
> -		pctl->state = page_address(page);
> -		init_waitqueue_head(&pctl->wait);
>  	}
>
>  	return 0;
>  }
>
> @@ -921,11 +946,11 @@ static int llbitmap_init(struct llbitmap 
> *llbitmap)
>  	llbitmap->chunksize = chunksize;
>  	llbitmap->chunks = chunks;
>  	llbitmap->sync_size = blocks;
>  	mddev->bitmap_info.daemon_sleep = DEFAULT_DAEMON_SLEEP;
>
> -	ret = llbitmap_cache_pages(llbitmap);
> +	ret = llbitmap_alloc_pages(llbitmap);
>  	if (ret)
>  		return ret;
>
>  	llbitmap_state_machine(llbitmap, 0, llbitmap->chunks - 1,
>  			       BitmapActionInit);
> @@ -1030,11 +1055,11 @@ static int llbitmap_read_sb(struct 
> llbitmap *llbitmap)
>  	llbitmap->barrier_idle = DEFAULT_BARRIER_IDLE;
>  	llbitmap->chunksize = chunksize;
>  	llbitmap->chunks = DIV_ROUND_UP_SECTOR_T(sync_size, 
>  chunksize);
>  	llbitmap->chunkshift = ffz(~chunksize);
>  	llbitmap->sync_size = sync_size;
> -	ret = llbitmap_cache_pages(llbitmap);
> +	ret = llbitmap_alloc_pages(llbitmap);
>
>  out_put_page:
>  	__free_page(sb_page);
>  	kunmap_local(sb);
>  	return ret;
