Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4BA31355F;
	Fri, 26 Dec 2025 08:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766738045; cv=none; b=bLRWA+ETgSlb7bECvdcKYutdnLVujJZwokvRtz4cR5Its65QOCNrin9373x/uSoy6eE+1GnmkyoAC0fjwLCCwlRALCoZEGEPJKYEwk6+92DPPD2aZjrrBWyilDuLaV9sz/Q9g5ZlEJN+0iUkdyCkRlMI2LRVoDi6a+Ue9Ej/03w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766738045; c=relaxed/simple;
	bh=TeOvDZthguYF45HXN0FJCynCvSkk/IsyZBZt8LEuUH8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WOO6VRfx5HTxw/Hov6WTHiOrBVPOmmsEtRuP+nl7QaK+MQg+heroA1akVZcvbAigkI26J9ukri+XjqYEymJOHlx/OCQBqos82T9zQ32rUt8yC45cK6HzjaLOV5zdBz8lfnkSslCyu/26me7tK2rEbG/imgJvTCpSuGIjXQxipys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dczQj10xczYQtlM;
	Fri, 26 Dec 2025 16:33:17 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D79D34056D;
	Fri, 26 Dec 2025 16:33:58 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgAXePh1SE5poJ4iBg--.9916S3;
	Fri, 26 Dec 2025 16:33:58 +0800 (CST)
Message-ID: <343e3081-7d24-f783-b040-2f61aad4ea4f@huaweicloud.com>
Date: Fri, 26 Dec 2025 16:33:57 +0800
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
X-CM-TRANSID:gCh0CgAXePh1SE5poJ4iBg--.9916S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ZFW7Jr1xAw4UXryrZFykuFg_yoW8Cr1rpw
	sIga43urWUZ3sxGFZxJ3yUuFWF9an2yrWjkrW7Z3ySqFsY9rWfAr15JryrXryDXFWft348
	WF15Krn5WFsYqrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

[...]

> @@ -7374,6 +7380,10 @@ static void free_conf(struct r5conf *conf)
>   	bioset_exit(&conf->bio_split);
>   	kfree(conf->stripe_hashtbl);
>   	kfree(conf->pending_data);
> +
> +	if (conf->ctx_pool)
> +		mempool_destroy(conf->ctx_pool);
> +
>   	kfree(conf);
>   }
>   
> @@ -8057,6 +8067,13 @@ static int raid5_run(struct mddev *mddev)
>   			goto abort;
>   	}
>   
> +	conf->ctx_pool = mempool_create_kmalloc_pool(NR_RAID_BIOS,
> +					sizeof(struct stripe_request_ctx));
> +	if (!conf->ctx_pool) {
> +		ret = -ENOMEM;
> +		goto abort;
> +	}
> +

What about moving create to setup_conf()? If so, call destroy in
free_conf() without checks.

>   	if (log_init(conf, journal_dev, raid5_has_ppl(conf)))
>   		goto abort;
>   
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index eafc6e9ed6ee..6e3f07119fa4 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -690,6 +690,8 @@ struct r5conf {
>   	struct list_head	pending_list;
>   	int			pending_data_cnt;
>   	struct r5pending_data	*next_pending_data;
> +
> +	mempool_t		*ctx_pool;
>   };
>   
>   #if PAGE_SIZE == DEFAULT_STRIPE_SIZE

-- 
Thanks,
Nan

