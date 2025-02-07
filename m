Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338D332C8B
	for <linux-raid@vger.kernel.org>; Fri,  7 Feb 2025 09:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738921834; cv=none; b=f1sg6O8RbKptHtNd2KQ9fkIdbmVEIp3C0EOmQyd6Grf06fh0rubSG3QdtEGpeqTZEA4D1f/MEyFQ5IEoOPoLl54a/O6YrvbCM6IfGjgzVKocF1YxXe3vm5OIV4uWD/rh6c74dMR2+eTvRXC076W8MvCBF+hav85xE8HtBpPzDNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738921834; c=relaxed/simple;
	bh=dHhQ2WXrYsvlhebn9Bbl+ZvyTDm1ULiwxYGZYTE1Ogs=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=c5uwzDOTdbxNTs6d71UXdMqT3C49af1OgUoz2Xp3BW8srm55pN0OOi0I3EiA5Pfoep40coG0nAPdTfh5j7TJBALVgR/Yvm3xfSq7LKmP9zqMcRxJCXFA5BHOfQz3R7+37Ui10rxhgH1mgnPJNN3qw7c8pPF7wTBohmJaIAAQJUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Yq8Mx30LSz4f3jHv
	for <linux-raid@vger.kernel.org>; Fri,  7 Feb 2025 17:50:05 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 943BF1A08AD
	for <linux-raid@vger.kernel.org>; Fri,  7 Feb 2025 17:50:26 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDHK2Bh16VnRcOiDA--.51546S3;
	Fri, 07 Feb 2025 17:50:26 +0800 (CST)
Subject: Re: [PATCH V3] md-linear: optimize which_dev() for small disks number
To: colyli@kernel.org, linux-raid@vger.kernel.org
Cc: Song Liu <song@kernel.org>, "yukuai (C)" <yukuai3@huawei.com>
References: <20250207023505.86967-1-colyli@kernel.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <86dbb33c-c762-0987-50f1-150b5c41a348@huaweicloud.com>
Date: Fri, 7 Feb 2025 17:50:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250207023505.86967-1-colyli@kernel.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHK2Bh16VnRcOiDA--.51546S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAF15Zr17XFW8Kr4kWr4rKrg_yoWrtr47pF
	WUCay3GFWUJr93WasrX3ykua4aq3yxGFW3GFyfG34q9Fs8WryDtFWYqr45Zr13AryrCr1a
	qw4UWF4DuFyrJr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyGb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0E
	wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
	80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0
	I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04
	k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7Cj
	xVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1CPfJUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/02/07 10:35, colyli@kernel.org Ð´µÀ:
> From: Coly Li <colyli@kernel.org>
> 
> which_dev() is a top hot function in md-linear.c, every I/O request will
> call it to find out which component disk the bio should be issued to.
> 
> Current witch_dev() performs a standard binary search, indeed this is
> not the fastest algorithm in practice. When the whole conf->disks array
> can be stored within a single cache line, simple linear search is faster
> than binary search for a small disks number.
> 
>>From micro benchmark, around 20%~30% latency reduction can be observed.
> Of course such huge optimization cannot be achieved in real workload, in
> my benchmark with,
> 1) One md linear device assembled by 2 or 4 Intel Optane memory block
>     device on Lenovo ThinkSystem SR650 server.
> 2) Random write I/O issued by fio, with I/O depth 1 and 512 bytes block
>     size.

> 
> The percentage of I/O latencies completed with 750 nsec increases from
> 97.186% to 99.324% in average, in a rough estimation the write latency
> improves (reduces) around 2.138%.
> 
> This is quite ideal result, I believe on slow hard drives such small
> code-running optimization will be overwhelmed by hardware latency and
> hard to be recognized.
> 
> This patch will go back to binary search when the linear device grows
> and conf->disks array cannot be placed within a single cache line.
> 
> Although the optimization result is tiny in most of cases, it is good to
> have it since we don't pay any other cost.
> 
> Signed-off-by: Coly Li <colyli@kernel.org>
> Cc: Song Liu <song@kernel.org>
> Cc: Yu Kuai <yukuai3@huawei.com>
> ---
> Changelog,
> v3: fix typo and email address which are reported by raid kernel ci.
> v2: return last item of conf->disks[] if fast search missed.
> v1: initial version.
> 
> 
>   drivers/md/md-linear.c | 45 +++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 44 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
> index a382929ce7ba..cdb59f2b2a1c 100644
> --- a/drivers/md/md-linear.c
> +++ b/drivers/md/md-linear.c
> @@ -25,10 +25,12 @@ struct linear_conf {
>   	struct dev_info         disks[] __counted_by(raid_disks);
>   };
>   
> +static int prefer_linear_dev_search;

Why using global variable instead of per linear? There are still hole in
the linear_conf() that you can use.
> +
>   /*
>    * find which device holds a particular offset
>    */
> -static inline struct dev_info *which_dev(struct mddev *mddev, sector_t sector)
> +static inline struct dev_info *__which_dev(struct mddev *mddev, sector_t sector)
>   {
>   	int lo, mid, hi;
>   	struct linear_conf *conf;
> @@ -53,6 +55,34 @@ static inline struct dev_info *which_dev(struct mddev *mddev, sector_t sector)
>   	return conf->disks + lo;
>   }
>   
> +/*
> + * If conf->disk[] can be hold within a L1 cache line,
> + * linear search is fater than binary search.
> + */
> +static inline struct dev_info *which_dev(struct mddev *mddev, sector_t sector)
> +{
> +	int i;
> +
> +	if (prefer_linear_dev_search) {
> +		struct linear_conf *conf;
> +		struct dev_info *dev;
> +		int max;
> +
> +		conf = mddev->private;
> +		dev = conf->disks;
> +		max = conf->raid_disks;
> +		for (i = 0; i < max; i++, dev++) {
> +			if (sector < dev->end_sector)
> +				return dev;
> +		}
> +		return &conf->disks[max-1];
> +	}
> +
> +	/* slow path */
> +	return __which_dev(mddev, sector);
> +}
> +
> +
>   static sector_t linear_size(struct mddev *mddev, sector_t sectors, int raid_disks)
>   {
>   	struct linear_conf *conf;
> @@ -222,6 +252,18 @@ static int linear_add(struct mddev *mddev, struct md_rdev *rdev)
>   	md_set_array_sectors(mddev, linear_size(mddev, 0, 0));
>   	set_capacity_and_notify(mddev->gendisk, mddev->array_sectors);
>   	kfree_rcu(oldconf, rcu);
> +
> +	/*
> +	 * When elements in linear_conf->disks[] becomes large enough,
> +	 * set prefer_linear_dev_search as 0 to indicate linear search
> +	 * in which_dev() is not optimized. Slow path in __which_dev()
> +	 * might be faster.
> +	 */
> +	if ((mddev->raid_disks * sizeof(struct dev_info)) >
> +	     cache_line_size() &&

BTW, you said in the case *a single cache line*, however, the field
disks is 32 bytes offset in linear_conf, you might want to align it to
cacheline, or add sizeof(struct linear_conf) on the left and align
linear_conf to the cacheline.

Thanks,
Kuai
> +	    prefer_linear_dev_search == 1)
> +		prefer_linear_dev_search = 0;
> +
>   	return 0;
>   }
>   
> @@ -337,6 +379,7 @@ static struct md_personality linear_personality = {
>   
>   static int __init linear_init(void)
>   {
> +	prefer_linear_dev_search = 1;
>   	return register_md_personality(&linear_personality);
>   }
>   
> 

