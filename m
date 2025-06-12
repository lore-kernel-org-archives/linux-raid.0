Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE93013C8E8;
	Thu, 12 Jun 2025 07:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749713496; cv=none; b=LWgHsFKo3Pnwe1fcUF2+w1JgwVkxgdRIxCd5ZzoJf/IQQ7Wk+a8LkfpV/LRxlFpm4ju/ycCHxzqqhOAzYeakOZmxdpzhaaAIOJB918Hffm9b28QB3hYNHz4hfolmrEoNw8NOh5A8j6wHK+NHLbuS8aBFFjypYwOdacoovkbohrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749713496; c=relaxed/simple;
	bh=BDWPz4pfRS16MrKQBhKAc9wBKiHzpdvJil2AusBPgZU=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=JnzriDI1YcM+YIanfc9G8xk+T2P/gJtCbK0PGonsd/OQlSo2uEFQOn+4l+/FpWOdbTZ5vM8xdl7B6vO4f37dHgHiK2HP2VeKpNGWunLIHVQFhkieD/kRzsjun2nM4qmlu/vBnRGDE0XSLnn9ZHotaFfPcHcw1SOYLirzfyrjJRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bHvNF3f7mzKHNCF;
	Thu, 12 Jun 2025 15:31:25 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D64511A1F9E;
	Thu, 12 Jun 2025 15:31:23 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDHK2BKgkpoqJQWPQ--.23647S3;
	Thu, 12 Jun 2025 15:31:23 +0800 (CST)
Subject: Re: [PATCH v2] md/raid1: Fix stack memory use after return in
 raid1_reshape
To: Wang Jinchao <wangjinchao600@gmail.com>, Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250611090203.271488-1-wangjinchao600@gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <5143c5c3-3a77-919f-0d38-8adb0e8923e9@huaweicloud.com>
Date: Thu, 12 Jun 2025 15:31:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250611090203.271488-1-wangjinchao600@gmail.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHK2BKgkpoqJQWPQ--.23647S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWr47Kw48Ar1UJrWUWrWrAFb_yoWrJr4Dpw
	sIqas3uFW5Z34fWr4UZF4UGFWYvanagFyxGr17J3y0vF95WFyrJ3yUCrW5JryjvFZrGr48
	XFs5ArZruF1qgFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
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
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jjVb
	kUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/06/11 16:55, Wang Jinchao Ð´µÀ:
> In the raid1_reshape function, newpool is
> allocated on the stack and assigned to conf->r1bio_pool.
> This results in conf->r1bio_pool.wait.head pointing
> to a stack address.
> Accessing this address later can lead to a kernel panic.
> 
> Example access path:
> 
> raid1_reshape()
> {
> 	// newpool is on the stack
> 	mempool_t newpool, oldpool;
> 	// initialize newpool.wait.head to stack address
> 	mempool_init(&newpool, ...);
> 	conf->r1bio_pool = newpool;
> }
> 
> raid1_read_request() or raid1_write_request()
> {
> 	alloc_r1bio()
> 	{
> 		mempool_alloc()
> 		{
> 			// if pool->alloc fails
> 			remove_element()
> 			{
> 				--pool->curr_nr;
> 			}
> 		}
> 	}
> }
> 
> mempool_free()
> {
> 	if (pool->curr_nr < pool->min_nr) {
> 		// pool->wait.head is a stack address
> 		// wake_up() will try to access this invalid address
> 		// which leads to a kernel panic
> 		return;
> 		wake_up(&pool->wait);
> 	}
> }
> 
> Fix:
> The solution is to avoid using a stack-based newpool.
> Instead, directly initialize conf->r1bio_pool.
> 
> Signed-off-by: Wang Jinchao <wangjinchao600@gmail.com>
> ---
> v1 -> v2:
> - change subject
> - use mempool_init(&conf->r1bio_pool) instead of reinitializing the list on stack
> ---
>   drivers/md/raid1.c | 34 +++++++++++++++++++---------------
>   1 file changed, 19 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 19c5a0ce5a40..f2436262092a 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -3366,7 +3366,7 @@ static int raid1_reshape(struct mddev *mddev)
>   	 * At the same time, we "pack" the devices so that all the missing
>   	 * devices have the higher raid_disk numbers.
>   	 */
> -	mempool_t newpool, oldpool;
> +	mempool_t oldpool;
>   	struct pool_info *newpoolinfo;
>   	struct raid1_info *newmirrors;
>   	struct r1conf *conf = mddev->private;
> @@ -3375,9 +3375,6 @@ static int raid1_reshape(struct mddev *mddev)
>   	int d, d2;
>   	int ret;
>   
> -	memset(&newpool, 0, sizeof(newpool));
> -	memset(&oldpool, 0, sizeof(oldpool));
> -
>   	/* Cannot change chunk_size, layout, or level */
>   	if (mddev->chunk_sectors != mddev->new_chunk_sectors ||
>   	    mddev->layout != mddev->new_layout ||
> @@ -3408,26 +3405,33 @@ static int raid1_reshape(struct mddev *mddev)
>   	newpoolinfo->mddev = mddev;
>   	newpoolinfo->raid_disks = raid_disks * 2;
>   
> -	ret = mempool_init(&newpool, NR_RAID_BIOS, r1bio_pool_alloc,
> -			   rbio_pool_free, newpoolinfo);
> -	if (ret) {
> -		kfree(newpoolinfo);
> -		return ret;
> -	}
>   	newmirrors = kzalloc(array3_size(sizeof(struct raid1_info),
> -					 raid_disks, 2),
> -			     GFP_KERNEL);
> +	raid_disks, 2),
> +	GFP_KERNEL);
>   	if (!newmirrors) {
>   		kfree(newpoolinfo);
> -		mempool_exit(&newpool);
>   		return -ENOMEM;
>   	}
>   
> +	/* stop everything before switching the pool */
>   	freeze_array(conf, 0);
>   
> -	/* ok, everything is stopped */
> +	/* backup old pool in case restore is needed */
>   	oldpool = conf->r1bio_pool;
> -	conf->r1bio_pool = newpool;
> +
> +	ret = mempool_init(&conf->r1bio_pool, NR_RAID_BIOS, r1bio_pool_alloc,
> +			   rbio_pool_free, newpoolinfo);
> +	if (ret) {
> +		kfree(newpoolinfo);
> +		kfree(newmirrors);
> +		mempool_exit(&conf->r1bio_pool);
> +		/* restore the old pool */
> +		conf->r1bio_pool = oldpool;
> +		unfreeze_array(conf);
> +		pr_err("md/raid1:%s: cannot allocate r1bio_pool for reshape\n",
> +			mdname(mddev));
> +		return ret;
> +	}
>   
>   	for (d = d2 = 0; d < conf->raid_disks; d++) {
>   		struct md_rdev *rdev = conf->mirrors[d].rdev;
> 

Any specific reason not to use mempool_resize() and krealloc() here?
In the case if new raid_disks is greater than the old one.

Thanks,
Kuai

