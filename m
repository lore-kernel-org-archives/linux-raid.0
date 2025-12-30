Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0132527FD49;
	Tue, 30 Dec 2025 09:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767087493; cv=none; b=XqvHeHe2ZRF5nklPIXu6vp3CFKJLm2JfQdw3V0haT3+bkaa2ekWmpsmUpq67b6oXSPsigs11RAlkoEn2rj7z7FZ7OHjJ3aFQmAiMwzLSecRURitcW/zaFX3SYM8tLQZTRPu7TAIA2nhPPtrcCKnrkFCeaaM4nWI8XmUZF8CFrIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767087493; c=relaxed/simple;
	bh=lVYB6S4ntAkTGk3taSE5KwbnII1hxpLcTIl7PshWr4M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RK1Rg9DG61lh84iufAzGVK+SbF8b+Phu2FRQajd8VNOUsEPRXKkkcYLaWery6czjCYYo+VQ0ne4oTaC+4v0o8/PT4e3YBc+/kXZcG/vk9fkUWhbj406rKUxMg6GaHrOGUySglYoeVDF21mB8tHheCOQDB0Uzn1HOPgxDQGXdQLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dgSg53lBjzKHMJs;
	Tue, 30 Dec 2025 17:37:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 577DF4058C;
	Tue, 30 Dec 2025 17:38:06 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgAXePh8nVNpOPcFCA--.35285S3;
	Tue, 30 Dec 2025 17:38:06 +0800 (CST)
Message-ID: <30ae98d1-7947-ff39-fde7-04f8fe94b433@huaweicloud.com>
Date: Tue, 30 Dec 2025 17:38:04 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 04/11] md/raid5: use mempool to allocate
 stripe_request_ctx
To: Yu Kuai <yukuai@fnnas.com>, song@kernel.org, linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, filippo@debian.org, colyli@fnnas.com
References: <20251124063203.1692144-1-yukuai@fnnas.com>
 <20251124063203.1692144-5-yukuai@fnnas.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20251124063203.1692144-5-yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXePh8nVNpOPcFCA--.35285S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXryUur4rKr15Kw1fGr4DJwb_yoW5tFWfpr
	sFya4avrWUXa17K3ZxJayUuFyrtayIqrWjkr4fu3y8uFy7urykGF15XayrWF1DXFW3GFWS
	qw1DCr4DCF4vqrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Yb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487
	Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aV
	AFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xF
	o4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjxUwGQDUUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/11/24 14:31, Yu Kuai 写道:
> On the one hand, stripe_request_ctx is 72 bytes, and it's a bit huge for
> a stack variable.
> 
> On the other hand, the bitmap sectors_to_do is a fixed size, result in
> max_hw_sector_kb of raid5 array is at most 256 * 4k = 1Mb, and this will
> make full stripe IO impossible for the array that chunk_size * data_disks
> is bigger. Allocate ctx during runtime will make it possible to get rid
> of this limit.
> 
> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
> ---
>   drivers/md/md.h       |  4 +++
>   drivers/md/raid1-10.c |  5 ----
>   drivers/md/raid5.c    | 61 +++++++++++++++++++++++++++----------------
>   drivers/md/raid5.h    |  2 ++
>   4 files changed, 45 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 6ee18045f41c..b8c5dec12b62 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -22,6 +22,10 @@
>   #include <trace/events/block.h>
>   
>   #define MaxSector (~(sector_t)0)
> +/*
> + * Number of guaranteed raid bios in case of extreme VM load:
> + */
> +#define	NR_RAID_BIOS 256
>   
>   enum md_submodule_type {
>   	MD_PERSONALITY = 0,
> diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
> index 521625756128..c33099925f23 100644
> --- a/drivers/md/raid1-10.c
> +++ b/drivers/md/raid1-10.c
> @@ -3,11 +3,6 @@
>   #define RESYNC_BLOCK_SIZE (64*1024)
>   #define RESYNC_PAGES ((RESYNC_BLOCK_SIZE + PAGE_SIZE-1) / PAGE_SIZE)
>   
> -/*
> - * Number of guaranteed raid bios in case of extreme VM load:
> - */
> -#define	NR_RAID_BIOS 256
> -
>   /* when we get a read error on a read-only array, we redirect to another
>    * device without failing the first device, or trying to over-write to
>    * correct the read error.  To keep track of bad blocks on a per-bio
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index f405ba7b99a7..0080dec4a6ef 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -6083,13 +6083,13 @@ static sector_t raid5_bio_lowest_chunk_sector(struct r5conf *conf,
>   static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
>   {
>   	DEFINE_WAIT_FUNC(wait, woken_wake_function);
> -	bool on_wq;
>   	struct r5conf *conf = mddev->private;
> -	sector_t logical_sector;
> -	struct stripe_request_ctx ctx = {};
>   	const int rw = bio_data_dir(bi);
> +	struct stripe_request_ctx *ctx;
> +	sector_t logical_sector;
>   	enum stripe_result res;
>   	int s, stripe_cnt;
> +	bool on_wq;
>   
>   	if (unlikely(bi->bi_opf & REQ_PREFLUSH)) {
>   		int ret = log_handle_flush_request(conf, bi);
> @@ -6101,11 +6101,6 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
>   				return true;
>   		}
>   		/* ret == -EAGAIN, fallback */
> -		/*
> -		 * if r5l_handle_flush_request() didn't clear REQ_PREFLUSH,
> -		 * we need to flush journal device
> -		 */
> -		ctx.do_flush = bi->bi_opf & REQ_PREFLUSH;
>   	}
>   
>   	md_write_start(mddev, bi);
> @@ -6128,16 +6123,24 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
>   	}
>   
>   	logical_sector = bi->bi_iter.bi_sector & ~((sector_t)RAID5_STRIPE_SECTORS(conf)-1);
> -	ctx.first_sector = logical_sector;
> -	ctx.last_sector = bio_end_sector(bi);
>   	bi->bi_next = NULL;
>   
> -	stripe_cnt = DIV_ROUND_UP_SECTOR_T(ctx.last_sector - logical_sector,
> +	ctx = mempool_alloc(conf->ctx_pool, GFP_NOIO | __GFP_ZERO);

In mempool_alloc_noprof():
	VM_WARN_ON_ONCE(gfp_mask & __GFP_ZERO);

__GFP_ZERO should be removed and ensure init before accessing the members.

-- 
Thanks,
Nan

