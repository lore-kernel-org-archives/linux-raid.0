Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA7B156F3C;
	Sat, 28 Jun 2025 03:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751080658; cv=none; b=OVolykVFo1/XXLum/J3d8U8bFKocL3+T9LTp64bsUrBs1xqNUo14o1LyENdFjbDpSZGsKqrSZylRC9qLIwH94Qjiy2urkA9zRSdDgyN2juDoDASkxvDtVJXd52BtIDpP3EzfgecxUQ93L6bbF1cR9nAY2iZRMNN9e0mmSwoUw7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751080658; c=relaxed/simple;
	bh=VUaKHrP5LlBsFFjKY4glRjZXTfz/duADGENZ9kfi2xk=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=H8wmmn5BPdCTBnGMKC8eYArIYwvlmjjhV9ck3VO+Xf/7JVzd4XySACW0ZUlI09sbV/lSQUB+fmSev0QLRi7ZCe97S7QRQyLoLJgDGv4jmmPE2sad2da3ohZ41VnpyvqZ8Ddf6kdD6ucRrVMERqflkXivhMMCfMlahP3/8epYBZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bTczw5jrszYQtdR;
	Sat, 28 Jun 2025 11:17:32 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id AD28F1A0194;
	Sat, 28 Jun 2025 11:17:31 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgBXu1_KXl9o_GaGQw--.5346S3;
	Sat, 28 Jun 2025 11:17:31 +0800 (CST)
Subject: Re: [PATCH v3 1/2] md/raid1: change r1conf->r1bio_pool to a pointer
 type
To: Wang Jinchao <wangjinchao600@gmail.com>, Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250624015604.70309-1-wangjinchao600@gmail.com>
 <20250624015604.70309-2-wangjinchao600@gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <c5c4e3e2-930d-f4c1-4d30-f17984079e6e@huaweicloud.com>
Date: Sat, 28 Jun 2025 11:17:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250624015604.70309-2-wangjinchao600@gmail.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXu1_KXl9o_GaGQw--.5346S3
X-Coremail-Antispam: 1UD129KBjvJXoW3XF1xGw4Dur1DCr43Wr4Durg_yoW7ZryUpa
	13Jas3ur4UZ3sxGr4UJF4DuFyFv3WSgFWUJrWxJw40qFnaqryfXF1UCry5Gryqva4DGrs7
	JFn0yrZxZFnFqrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AF
	wI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1D
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU7I
	JmUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/06/24 9:55, Wang Jinchao Ð´µÀ:
> In raid1_reshape(), newpool is a stack variable.
> mempool_init() initializes newpool->wait with the stack address.
> After assigning newpool to conf->r1bio_pool, the wait queue
> need to be reinitialized, which is not ideal.
> 
> Change raid1_conf->r1bio_pool to a pointer type and
> replace mempool_init() with mempool_create_kmalloc_pool() to
> avoid referencing a stack-based wait queue.
> 
> Signed-off-by: Wang Jinchao <wangjinchao600@gmail.com>
> ---
>   drivers/md/raid1.c | 39 ++++++++++++++++++---------------------
>   drivers/md/raid1.h |  2 +-
>   2 files changed, 19 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index fd4ce2a4136f..8249cbb89fec 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -255,7 +255,7 @@ static void free_r1bio(struct r1bio *r1_bio)
>   	struct r1conf *conf = r1_bio->mddev->private;
>   
>   	put_all_bios(conf, r1_bio);
> -	mempool_free(r1_bio, &conf->r1bio_pool);
> +	mempool_free(r1_bio, conf->r1bio_pool);
>   }
>   
>   static void put_buf(struct r1bio *r1_bio)
> @@ -1305,9 +1305,8 @@ alloc_r1bio(struct mddev *mddev, struct bio *bio)
>   	struct r1conf *conf = mddev->private;
>   	struct r1bio *r1_bio;
>   
> -	r1_bio = mempool_alloc(&conf->r1bio_pool, GFP_NOIO);
> -	/* Ensure no bio records IO_BLOCKED */
> -	memset(r1_bio->bios, 0, conf->raid_disks * sizeof(r1_bio->bios[0]));
> +	r1_bio = mempool_alloc(conf->r1bio_pool, GFP_NOIO);
> +	memset(r1_bio, 0, offsetof(struct r1bio, bios[conf->raid_disks * 2]));
>   	init_r1bio(r1_bio, mddev, bio);
>   	return r1_bio;
>   }
> @@ -3084,6 +3083,7 @@ static struct r1conf *setup_conf(struct mddev *mddev)
>   	int i;
>   	struct raid1_info *disk;
>   	struct md_rdev *rdev;
> +	size_t r1bio_size;
>   	int err = -ENOMEM;
>   
>   	conf = kzalloc(sizeof(struct r1conf), GFP_KERNEL);
> @@ -3124,9 +3124,10 @@ static struct r1conf *setup_conf(struct mddev *mddev)
>   	if (!conf->poolinfo)
>   		goto abort;
>   	conf->poolinfo->raid_disks = mddev->raid_disks * 2;
> -	err = mempool_init(&conf->r1bio_pool, NR_RAID_BIOS, r1bio_pool_alloc,
> -			   rbio_pool_free, conf->poolinfo);
> -	if (err)
> +
> +	r1bio_size = offsetof(struct r1bio, bios[mddev->raid_disks * 2]);

The local variable doesn't look necessary, it's just used once anyway.
> +	conf->r1bio_pool = mempool_create_kmalloc_pool(NR_RAID_BIOS, r1bio_size);
> +	if (!conf->r1bio_pool)
>   		goto abort;
>   
>   	err = bioset_init(&conf->bio_split, BIO_POOL_SIZE, 0, 0);
> @@ -3197,7 +3198,7 @@ static struct r1conf *setup_conf(struct mddev *mddev)
>   
>    abort:
>   	if (conf) {
> -		mempool_exit(&conf->r1bio_pool);
> +		mempool_destroy(conf->r1bio_pool);
>   		kfree(conf->mirrors);
>   		safe_put_page(conf->tmppage);
>   		kfree(conf->poolinfo);
> @@ -3310,7 +3311,7 @@ static void raid1_free(struct mddev *mddev, void *priv)
>   {
>   	struct r1conf *conf = priv;
>   
> -	mempool_exit(&conf->r1bio_pool);
> +	mempool_destroy(conf->r1bio_pool);
>   	kfree(conf->mirrors);
>   	safe_put_page(conf->tmppage);
>   	kfree(conf->poolinfo);
> @@ -3366,17 +3367,14 @@ static int raid1_reshape(struct mddev *mddev)
>   	 * At the same time, we "pack" the devices so that all the missing
>   	 * devices have the higher raid_disk numbers.
>   	 */
> -	mempool_t newpool, oldpool;
> +	mempool_t *newpool, *oldpool;
>   	struct pool_info *newpoolinfo;
> +	size_t new_r1bio_size;
>   	struct raid1_info *newmirrors;
>   	struct r1conf *conf = mddev->private;
>   	int cnt, raid_disks;
>   	unsigned long flags;
>   	int d, d2;
> -	int ret;
> -
> -	memset(&newpool, 0, sizeof(newpool));
> -	memset(&oldpool, 0, sizeof(oldpool));
>   
>   	/* Cannot change chunk_size, layout, or level */
>   	if (mddev->chunk_sectors != mddev->new_chunk_sectors ||
> @@ -3408,18 +3406,18 @@ static int raid1_reshape(struct mddev *mddev)
>   	newpoolinfo->mddev = mddev;
>   	newpoolinfo->raid_disks = raid_disks * 2;
>   
> -	ret = mempool_init(&newpool, NR_RAID_BIOS, r1bio_pool_alloc,
> -			   rbio_pool_free, newpoolinfo);
> -	if (ret) {
> +	new_r1bio_size = offsetof(struct r1bio, bios[raid_disks * 2]);
same here. Otherwise looks good to me.

Reviewed-by: Yu Kuai <yukuai3@huawei.com>
> +	newpool = mempool_create_kmalloc_pool(NR_RAID_BIOS, new_r1bio_size);
> +	if (!newpool) {
>   		kfree(newpoolinfo);
> -		return ret;
> +		return -ENOMEM;
>   	}
>   	newmirrors = kzalloc(array3_size(sizeof(struct raid1_info),
>   					 raid_disks, 2),
>   			     GFP_KERNEL);
>   	if (!newmirrors) {
>   		kfree(newpoolinfo);
> -		mempool_exit(&newpool);
> +		mempool_destroy(newpool);
>   		return -ENOMEM;
>   	}
>   
> @@ -3428,7 +3426,6 @@ static int raid1_reshape(struct mddev *mddev)
>   	/* ok, everything is stopped */
>   	oldpool = conf->r1bio_pool;
>   	conf->r1bio_pool = newpool;
> -	init_waitqueue_head(&conf->r1bio_pool.wait);
>   
>   	for (d = d2 = 0; d < conf->raid_disks; d++) {
>   		struct md_rdev *rdev = conf->mirrors[d].rdev;
> @@ -3460,7 +3457,7 @@ static int raid1_reshape(struct mddev *mddev)
>   	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>   	md_wakeup_thread(mddev->thread);
>   
> -	mempool_exit(&oldpool);
> +	mempool_destroy(oldpool);
>   	return 0;
>   }
>   
> diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
> index 33f318fcc268..652c347b1a70 100644
> --- a/drivers/md/raid1.h
> +++ b/drivers/md/raid1.h
> @@ -118,7 +118,7 @@ struct r1conf {
>   	 * mempools - it changes when the array grows or shrinks
>   	 */
>   	struct pool_info	*poolinfo;
> -	mempool_t		r1bio_pool;
> +	mempool_t		*r1bio_pool;
>   	mempool_t		r1buf_pool;
>   
>   	struct bio_set		bio_split;
> 

