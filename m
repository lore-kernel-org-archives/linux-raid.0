Received: from mail-108-mta213.mxroute.com (mail-108-mta213.mxroute.com [136.175.108.213])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA33236D4F1
	for <linux-raid@vger.kernel.org>; Mon, 15 Jun 2026 10:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781520831; cv=none; b=MPLE+EiIl3mufGcn8RrnrCe8fEjQCIjG2qeV1pBbvy1BCfW3vm9te3tXawy3JNejJS9ydhA0+d4hGrs9i4WL7zkVOu3ltVGdaTNCKYhwyCnDpNiSuuDi/7kAsYWuEkrMwwPQd13wrtIGNPFMhdC11vM8gpKXDk6aWXDG3ZFncQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781520831; c=relaxed/simple;
	bh=K/0muZ1d849+ln4djHkHDXhWA79egeDs7Bm1rvHQR08=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Bh+pp8Ijyvu/LUPzWNJai+lzAvFDkAB8JTeh1wIqbLgi/P0/1eXaAaSd1DXe90ciY5if9yfQ0YsJMFXe5Q1xs29QhGda9KdZsm7fnHD4towdeUUDgWMKFXZVt5yZe0IFQz2dWp0sy4pog2gRqM345Hoo62ji+wRdS2J7TURLDZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=b/FuDnKE; arc=none smtp.client-ip=136.175.108.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="b/FuDnKE"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta213.mxroute.com (ZoneMTA) with ESMTPSA id 19ecae5bffe00067f7.007
 for <linux-raid@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Mon, 15 Jun 2026 10:48:35 +0000
X-Zone-Loop: e3c61b5dc2281362cfdc605d9e1a495ac7de573594f8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Message-ID:Date:References:In-Reply-To:
	Subject:Cc:To:From:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2WqbZsPZb8CmALgcOOV3PxpQvbiGInyNdWXHjKo3Alw=; b=b/FuDnKE3rC2Ry3xjSrkwHhtib
	DmXCQItThmdMvk+2lthAl/aHqqZv99mZeM+63zlGlQ6q9LC4svBb4PQcIZe9tq+L0omDZhelWILE3
	yujzRVaIGWIXyFrAUc8nWSuczBy0NAoGE7MG7W8Lb5vbkPZGLS3Hsag/c9+wL/soCYjXmGNpzNwOw
	HcGoPV64gzIDMfFVxK5S9y9Y/S4Pu8vWVuuR7OB59BL1Xg/EZ+WsBCVNTZcu0nVRS4xpAJwXhoFYz
	YdOvdPXp7I5/9zYBmGO6DmGH5h12e1aBL3brQkEVLsPwEQxF8ZB7w/bQ4JhBh+KL67ozsfDpzmZsA
	YyLauhrw==;
From: Su Yue <l@damenly.org>
To: Yu Kuai <yukuai@kernel.org>
Cc: Song Liu <song@kernel.org>,  Yu Kuai <yukuai@fygo.io>,  Li Nan
 <magiclinan@didiglobal.com>,  Xiao Ni <xiao@kernel.org>,
  linux-raid@vger.kernel.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md/md-llbitmap: track bitmap sync_size explicitly
In-Reply-To: <20260605091527.2463539-5-yukuai@kernel.org> (Yu Kuai's message
	of "Fri, 5 Jun 2026 17:15:11 +0800")
References: <20260605091527.2463539-1-yukuai@kernel.org>
	<20260605091527.2463539-5-yukuai@kernel.org>
User-Agent: mu4e 1.12.7; emacs 30.2
Date: Mon, 15 Jun 2026 18:48:25 +0800
Message-ID: <pl1saxl2.fsf@damenly.org>
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
> Track llbitmap's own sync_size instead of always using
> mddev->resync_max_sectors directly.
>
> This is the minimal bookkeeping needed before llbitmap can track 
> old
> and new reshape geometry independently.
>
> Signed-off-by: Yu Kuai <yukuai@fygo.io>
>
Reviewed-by: Su Yue <glass.su@suse.com>
> ---
>  drivers/md/md-llbitmap.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index bcf34f0c9af6..ecf3ed712315 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
> @@ -285,10 +285,12 @@ struct llbitmap {
>  	unsigned long chunkshift;
>  	/* size of one chunk in sector */
>  	unsigned long chunksize;
>  	/* total number of chunks */
>  	unsigned long chunks;
> +	/* total number of sectors tracked by current bitmap geometry 
> */
> +	sector_t sync_size;
>  	unsigned long last_end_sync;
>  	/*
>  	 * time in seconds that dirty bits will be cleared if the page 
>  is not
>  	 * accessed.
>  	 */
> @@ -916,10 +918,11 @@ static int llbitmap_init(struct llbitmap 
> *llbitmap)
>
>  	llbitmap->barrier_idle = DEFAULT_BARRIER_IDLE;
>  	llbitmap->chunkshift = ffz(~chunksize);
>  	llbitmap->chunksize = chunksize;
>  	llbitmap->chunks = chunks;
> +	llbitmap->sync_size = blocks;
>  	mddev->bitmap_info.daemon_sleep = DEFAULT_DAEMON_SLEEP;
>
>  	ret = llbitmap_cache_pages(llbitmap);
>  	if (ret)
>  		return ret;
> @@ -936,10 +939,11 @@ static int llbitmap_read_sb(struct 
> llbitmap *llbitmap)
>  {
>  	struct mddev *mddev = llbitmap->mddev;
>  	unsigned long daemon_sleep;
>  	unsigned long chunksize;
>  	unsigned long events;
> +	sector_t sync_size;
>  	struct page *sb_page;
>  	bitmap_super_t *sb;
>  	int ret = -EINVAL;
>
>  	if (!mddev->bitmap_info.offset) {
> @@ -985,10 +989,13 @@ static int llbitmap_read_sb(struct 
> llbitmap *llbitmap)
>  	if (test_and_clear_bit(BITMAP_FIRST_USE, &llbitmap->flags)) {
>  		ret = llbitmap_init(llbitmap);
>  		goto out_put_page;
>  	}
>
> +	sync_size = le64_to_cpu(sb->sync_size);
> +	if (!sync_size)
> +		sync_size = mddev->resync_max_sectors;
>  	chunksize = le32_to_cpu(sb->chunksize);
>  	if (!is_power_of_2(chunksize)) {
>  		pr_err("md/llbitmap: %s: chunksize not a power of 2",
>  		       mdname(mddev));
>  		goto out_put_page;
> @@ -1020,12 +1027,13 @@ static int llbitmap_read_sb(struct 
> llbitmap *llbitmap)
>  	mddev->bitmap_info.chunksize = chunksize;
>  	mddev->bitmap_info.daemon_sleep = daemon_sleep;
>
>  	llbitmap->barrier_idle = DEFAULT_BARRIER_IDLE;
>  	llbitmap->chunksize = chunksize;
> -	llbitmap->chunks = 
> DIV_ROUND_UP_SECTOR_T(mddev->resync_max_sectors, chunksize);
> +	llbitmap->chunks = DIV_ROUND_UP_SECTOR_T(sync_size, 
> chunksize);
>  	llbitmap->chunkshift = ffz(~chunksize);
> +	llbitmap->sync_size = sync_size;
>  	ret = llbitmap_cache_pages(llbitmap);
>
>  out_put_page:
>  	__free_page(sb_page);
>  	kunmap_local(sb);
> @@ -1151,10 +1159,11 @@ static int llbitmap_resize(struct mddev 
> *mddev, sector_t blocks, int chunksize)
>  	}
>
>  	llbitmap->chunkshift = ffz(~chunksize);
>  	llbitmap->chunksize = chunksize;
>  	llbitmap->chunks = chunks;
> +	llbitmap->sync_size = blocks;
>
>  	return 0;
>  }
>
>  static int llbitmap_load(struct mddev *mddev)
> @@ -1524,11 +1533,11 @@ static void llbitmap_update_sb(void 
> *data)
>
>  	sb = kmap_local_page(sb_page);
>  	sb->events = cpu_to_le64(mddev->events);
>  	sb->state = cpu_to_le32(llbitmap->flags);
>  	sb->chunksize = cpu_to_le32(llbitmap->chunksize);
> -	sb->sync_size = cpu_to_le64(mddev->resync_max_sectors);
> +	sb->sync_size = cpu_to_le64(llbitmap->sync_size);
>  	sb->events_cleared = cpu_to_le64(llbitmap->events_cleared);
>  	sb->sectors_reserved = cpu_to_le32(mddev->bitmap_info.space);
>  	sb->daemon_sleep = 
>  cpu_to_le32(mddev->bitmap_info.daemon_sleep);
>
>  	kunmap_local(sb);
> @@ -1542,10 +1551,11 @@ static int llbitmap_get_stats(void 
> *data, struct md_bitmap_stats *stats)
>  	memset(stats, 0, sizeof(*stats));
>
>  	stats->missing_pages = 0;
>  	stats->pages = llbitmap->nr_pages;
>  	stats->file_pages = llbitmap->nr_pages;
> +	stats->sync_size = llbitmap->sync_size;
>
>  	stats->behind_writes = atomic_read(&llbitmap->behind_writes);
>  	stats->behind_wait = wq_has_sleeper(&llbitmap->behind_wait);
>  	stats->events_cleared = llbitmap->events_cleared;
