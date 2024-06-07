Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA2514EC78
	for <linux-raid@vger.kernel.org>; Fri,  7 Jun 2024 06:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717740516; cv=none; b=OeugISOiqSnBgvDNBumo0SO4IymdTj5YCR0Q6ULGl8qMLNxH8aMaRyguOm3q5L9uArjD4E/bmuM84Y1KylyzlgMg348EgEsF5FFVMa6D9dymxt70gYJZPZ/4YJlPXmoJHZ7a3pvll78naq6UHE+pNcdaPrGo3YanvpR7ONZzuSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717740516; c=relaxed/simple;
	bh=R+m5Zmpe8ADjmQNFsQ8cowmP20nMkLefU+armm7X9eQ=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=j1DazVEZwYEDVxOIrntHxD/+uYk8U0e/V6unD5m53+38kT7OpXJ1TWHCdtfOOUwwguknAoCgE5sI/tRigX25KLLxTiLqnD4OtFI4mqfRU+bEjr9hm/1QNeGutVf4MaKmWt9XpLkstR2W8NYk+HLKP0v+/F9eRJyNjZbJYs7qKSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4VwW333J94z4f3jJ5
	for <linux-raid@vger.kernel.org>; Fri,  7 Jun 2024 14:08:15 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 3BB541A06DC
	for <linux-raid@vger.kernel.org>; Fri,  7 Jun 2024 14:08:25 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgAX6RHXo2Jmdd4vOw--.18704S3;
	Fri, 07 Jun 2024 14:08:25 +0800 (CST)
Subject: Re: [PATCH 1/2] md/raid0: don't free conf on raid0_run failure
To: Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20240604172607.3185916-1-hch@lst.de>
 <20240604172607.3185916-2-hch@lst.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <45ab7eb3-02d4-dbc2-8956-1387a008e53f@huaweicloud.com>
Date: Fri, 7 Jun 2024 14:08:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240604172607.3185916-2-hch@lst.de>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAX6RHXo2Jmdd4vOw--.18704S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Kr1rXr1UWFyUZFy7uFWxZwb_yoW8WFy8pw
	4aga4UXr4Utr98Ka1DAFWkua4F9a17trWvkFy7A34rXFs3Ar92ya45u34jgryUGryxA34r
	AayYyrn5CF1DtrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
	c7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1CPfJUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2024/06/05 1:25, Christoph Hellwig Ð´µÀ:
> The core md code calls the ->free method which already frees conf.
> 
> Fixes: 0c031fd37f69 ("md: Move alloc/free acct bioset in to personality")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

LGTM
Reviewed-by: Yu Kuai <yukuai3@huawei.com>

> ---
>   drivers/md/raid0.c | 21 +++++----------------
>   1 file changed, 5 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index c5d4aeb68404c9..81c01347cd24e6 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -365,18 +365,13 @@ static sector_t raid0_size(struct mddev *mddev, sector_t sectors, int raid_disks
>   	return array_sectors;
>   }
>   
> -static void free_conf(struct mddev *mddev, struct r0conf *conf)
> -{
> -	kfree(conf->strip_zone);
> -	kfree(conf->devlist);
> -	kfree(conf);
> -}
> -
>   static void raid0_free(struct mddev *mddev, void *priv)
>   {
>   	struct r0conf *conf = priv;
>   
> -	free_conf(mddev, conf);
> +	kfree(conf->strip_zone);
> +	kfree(conf->devlist);
> +	kfree(conf);
>   }
>   
>   static int raid0_set_limits(struct mddev *mddev)
> @@ -415,7 +410,7 @@ static int raid0_run(struct mddev *mddev)
>   	if (!mddev_is_dm(mddev)) {
>   		ret = raid0_set_limits(mddev);
>   		if (ret)
> -			goto out_free_conf;
> +			return ret;
>   	}
>   
>   	/* calculate array device size */
> @@ -427,13 +422,7 @@ static int raid0_run(struct mddev *mddev)
>   
>   	dump_zones(mddev);
>   
> -	ret = md_integrity_register(mddev);
> -	if (ret)
> -		goto out_free_conf;
> -	return 0;
> -out_free_conf:
> -	free_conf(mddev, conf);
> -	return ret;
> +	return md_integrity_register(mddev);
>   }
>   
>   /*
> 

