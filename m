Received: from mail-108-mta195.mxroute.com (mail-108-mta195.mxroute.com [136.175.108.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884C711712
	for <linux-raid@vger.kernel.org>; Thu, 19 Jun 2025 01:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750294892; cv=none; b=IR5ibrPsgICpJfE2eCbSdxHxOz57gBxarZi40VIsc/PHpc2HlgWosoGEkj6rbDzTBI1XrD4i7V5emoauIi6iY/ey7tgm1jfeFBGkjGYXLDmkDFJSdLhYtxAZ6MFGLE+3J3krKODMuPYyZnC44WFVoFHFMPR6bBFyMxY7ZDV7GfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750294892; c=relaxed/simple;
	bh=3Jc2Fm9nv+wkgv/eUvGNi1CYlnhZJZ7CXwNA/HMOmfA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Pikx9FeL582068HPRXNwIZmxI+gonTHB4fcE1p0gTRohELa9RtF57RF+ywYqQ9RQwQq8wVKyC1uN6hyrhL3ubTgAONa1kwQnPHn2BEyBGgLcDC5kTX1XmxIiGuhDNPTBQNGl4pWMoWn4cpm9o638axorW0YlrDQ9F26J+dW2tUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=alK0rHPC; arc=none smtp.client-ip=136.175.108.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="alK0rHPC"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta195.mxroute.com (ZoneMTA) with ESMTPSA id 19785afce520008631.005
 for <linux-raid@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Thu, 19 Jun 2025 00:56:20 +0000
X-Zone-Loop: bc540d29a1e174b61aa27e25b68db7538bc97ffd59bf
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Date:References:In-Reply-To:Subject:Cc:To:
	From:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description
	:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
	List-Archive; bh=huVSVOW5PqqvQeM/1I7oXUn9rtKvbf5hULoXQhbfxVE=; b=alK0rHPCUV4I
	eg+N9CJHWmHbFrt+N50t3cMEZjO4wRl8VYv/B3tar0MWAk4jEpPQQ4AKX9o8+8R+TdDfMPnSuOg/N
	MtuWxNc6OUEANsiIlggD4zQKVA2tTZtT6+z4ARAB/OOQzMIs8Tc4LQZ2Ou+zPEBHUleD7iLm144Cp
	Hg1HQs6bcHsIhd8Vdm0rlT76P2CT77oHuF1QJmnb9HUcBf5Xbucy2cC22sHx52L5lka4BbhQFr1YD
	V5vTS4rew28GqKjXFdvIhJBH9g+/v6PV++e7bNXTUl+qVFOB7FgfJV3cfBb9ZzTWV4Z7wfzwYMSuT
	DtB44CybSw8rcbaV4HWo8Q==;
From: Su Yue <l@damenly.org>
To: Wang Jinchao <wangjinchao600@gmail.com>
Cc: Song Liu <song@kernel.org>,  Yu Kuai <yukuai3@huawei.com>,
  linux-raid@vger.kernel.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md/raid1: change r1conf->r1bio_pool to a pointer type
In-Reply-To: <20250618114120.130584-1-wangjinchao600@gmail.com> (Wang
	Jinchao's message of "Wed, 18 Jun 2025 19:41:15 +0800")
References: <20250618114120.130584-1-wangjinchao600@gmail.com>
User-Agent: mu4e 1.12.7; emacs 30.1
Date: Thu, 19 Jun 2025 08:56:11 +0800
Message-ID: <ldpoy2fo.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Authenticated-Id: l@damenly.org

On Wed 18 Jun 2025 at 19:41, Wang Jinchao 
<wangjinchao600@gmail.com> wrote:

> In raid1_reshape(), newpool is a stack variable.
> mempool_init() initializes newpool->wait with the stack address.
> After assigning newpool to conf->r1bio_pool, the wait queue
> need to be reinitialized, which is not ideal.
>
> Change raid1_conf->r1bio_pool to a pointer type and
> replace mempool_init() with mempool_create() to
> avoid referencing a stack-based wait queue.
>
> Signed-off-by: Wang Jinchao <wangjinchao600@gmail.com>
> ---
>  drivers/md/raid1.c | 31 +++++++++++++------------------
>  drivers/md/raid1.h |  2 +-
>  2 files changed, 14 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index fd4ce2a4136f..4d4833915b5f 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -255,7 +255,7 @@ static void free_r1bio(struct r1bio *r1_bio)
>  	struct r1conf *conf = r1_bio->mddev->private;
>
>  	put_all_bios(conf, r1_bio);
> -	mempool_free(r1_bio, &conf->r1bio_pool);
> +	mempool_free(r1_bio, conf->r1bio_pool);
>  }
>
>  static void put_buf(struct r1bio *r1_bio)
> @@ -1305,7 +1305,7 @@ alloc_r1bio(struct mddev *mddev, struct 
> bio *bio)
>  	struct r1conf *conf = mddev->private;
>  	struct r1bio *r1_bio;
>
> -	r1_bio = mempool_alloc(&conf->r1bio_pool, GFP_NOIO);
> +	r1_bio = mempool_alloc(conf->r1bio_pool, GFP_NOIO);
>  	/* Ensure no bio records IO_BLOCKED */
>  	memset(r1_bio->bios, 0, conf->raid_disks * 
>  sizeof(r1_bio->bios[0]));
>  	init_r1bio(r1_bio, mddev, bio);
> @@ -3124,9 +3124,9 @@ static struct r1conf *setup_conf(struct 
> mddev *mddev)
>  	if (!conf->poolinfo)
>  		goto abort;
>  	conf->poolinfo->raid_disks = mddev->raid_disks * 2;
> -	err = mempool_init(&conf->r1bio_pool, NR_RAID_BIOS, 
> r1bio_pool_alloc,
> -			   rbio_pool_free, conf->poolinfo);
> -	if (err)
> +	conf->r1bio_pool = mempool_create(NR_RAID_BIOS, 
> r1bio_pool_alloc,
> +					  rbio_pool_free, conf->poolinfo);
> +	if (!conf->r1bio_pool)
>
err should be set to -ENOMEM.

--
Su

>  		goto abort;
>
>  	err = bioset_init(&conf->bio_split, BIO_POOL_SIZE, 0, 0);
> @@ -3197,7 +3197,7 @@ static struct r1conf *setup_conf(struct 
> mddev *mddev)
>
>   abort:
>  	if (conf) {
> -		mempool_exit(&conf->r1bio_pool);
> +		mempool_destroy(conf->r1bio_pool);
>  		kfree(conf->mirrors);
>  		safe_put_page(conf->tmppage);
>  		kfree(conf->poolinfo);
> @@ -3310,7 +3310,7 @@ static void raid1_free(struct mddev 
> *mddev, void *priv)
>  {
>  	struct r1conf *conf = priv;
>
> -	mempool_exit(&conf->r1bio_pool);
> +	mempool_destroy(conf->r1bio_pool);
>  	kfree(conf->mirrors);
>  	safe_put_page(conf->tmppage);
>  	kfree(conf->poolinfo);
> @@ -3366,17 +3366,13 @@ static int raid1_reshape(struct mddev 
> *mddev)
>  	 * At the same time, we "pack" the devices so that all the 
>  missing
>  	 * devices have the higher raid_disk numbers.
>  	 */
> -	mempool_t newpool, oldpool;
> +	mempool_t *newpool, *oldpool;
>  	struct pool_info *newpoolinfo;
>  	struct raid1_info *newmirrors;
>  	struct r1conf *conf = mddev->private;
>  	int cnt, raid_disks;
>  	unsigned long flags;
>  	int d, d2;
> -	int ret;
> -
> -	memset(&newpool, 0, sizeof(newpool));
> -	memset(&oldpool, 0, sizeof(oldpool));
>
>  	/* Cannot change chunk_size, layout, or level */
>  	if (mddev->chunk_sectors != mddev->new_chunk_sectors ||
> @@ -3408,18 +3404,18 @@ static int raid1_reshape(struct mddev 
> *mddev)
>  	newpoolinfo->mddev = mddev;
>  	newpoolinfo->raid_disks = raid_disks * 2;
>
> -	ret = mempool_init(&newpool, NR_RAID_BIOS, r1bio_pool_alloc,
> +	newpool = mempool_create(NR_RAID_BIOS, r1bio_pool_alloc,
>  			   rbio_pool_free, newpoolinfo);
> -	if (ret) {
> +	if (!newpool) {
>  		kfree(newpoolinfo);
> -		return ret;
> +		return -ENOMEM;
>  	}
>  	newmirrors = kzalloc(array3_size(sizeof(struct raid1_info),
>  					 raid_disks, 2),
>  			     GFP_KERNEL);
>  	if (!newmirrors) {
>  		kfree(newpoolinfo);
> -		mempool_exit(&newpool);
> +		mempool_destroy(newpool);
>  		return -ENOMEM;
>  	}
>
> @@ -3428,7 +3424,6 @@ static int raid1_reshape(struct mddev 
> *mddev)
>  	/* ok, everything is stopped */
>  	oldpool = conf->r1bio_pool;
>  	conf->r1bio_pool = newpool;
> -	init_waitqueue_head(&conf->r1bio_pool.wait);
>
>  	for (d = d2 = 0; d < conf->raid_disks; d++) {
>  		struct md_rdev *rdev = conf->mirrors[d].rdev;
> @@ -3460,7 +3455,7 @@ static int raid1_reshape(struct mddev 
> *mddev)
>  	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>  	md_wakeup_thread(mddev->thread);
>
> -	mempool_exit(&oldpool);
> +	mempool_destroy(oldpool);
>  	return 0;
>  }
>
> diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
> index 33f318fcc268..652c347b1a70 100644
> --- a/drivers/md/raid1.h
> +++ b/drivers/md/raid1.h
> @@ -118,7 +118,7 @@ struct r1conf {
>  	 * mempools - it changes when the array grows or shrinks
>  	 */
>  	struct pool_info	*poolinfo;
> -	mempool_t		r1bio_pool;
> +	mempool_t		*r1bio_pool;
>  	mempool_t		r1buf_pool;
>
>  	struct bio_set		bio_split;
