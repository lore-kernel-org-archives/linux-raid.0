Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B2017C7F;
	Tue, 28 May 2024 13:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716903168; cv=none; b=GpFpkI0OnT4vz7yk9KpPauB/0BgExGYyKVPOOvPmtnQrrcaLeYGuKZK/3AWhtqP0Qp0SsNjj+FE9g0wiU1QVA0g60fTevhhSkw31qYuwH3/ApceXa+RqFPUBxDpCS4QqKVtUzMKpM6DEpOPE+fViRH0XBD8laSYp1MPWCnVmbmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716903168; c=relaxed/simple;
	bh=1PhnMJDZWj2BGHeJ5Cta1tAR85uMdgv9y7/GJ2QDmgI=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=s+ov27bzAcK2MYSM4I60aKIDzDoRsIzs4pD9Wdo3OkfxIckZ3LDCkmcLyKcKa77+584d9broDBxm4yga8qYEn3xhPLm8La3N5KvnhP02tNQv0GZcMKie1uWp6huMstRCTPD4TFDMLIb14Q6cwv/s5vRsMTU4UfQlWVkquU7FCkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4VpYNJ5Rjwz4f3jXt;
	Tue, 28 May 2024 21:32:32 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 04F071A0568;
	Tue, 28 May 2024 21:32:42 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgAXKwT43FVmvE2rNw--.10284S3;
	Tue, 28 May 2024 21:32:41 +0800 (CST)
Subject: Re: [PATCH v2] md: make md_flush_request() more readable
To: linan666@huaweicloud.com, song@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240528203149.2383260-1-linan666@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <8dc33d99-4b50-fdb7-e81b-581939dadeaa@huaweicloud.com>
Date: Tue, 28 May 2024 21:32:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240528203149.2383260-1-linan666@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAXKwT43FVmvE2rNw--.10284S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tF13WF4DuFW7CrW3AFW8JFb_yoW8AF47p3
	9akasxAr4rtw4DCw47JF4kJwn8Wa1SyFWUtFWaywn5ZFy3ZF1kGw1ag39YqFykGryfC3y8
	JFs8A395Cay0vwUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Jr0_
	Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXdbU
	UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/05/29 4:31, linan666@huaweicloud.com Ð´µÀ:
> From: Li Nan <linan122@huawei.com>
> 
> Setting bio to NULL and checking 'if(!bio)' is redundant and looks strange,
> just consolidate them into one condition. There are no functional changes.
> 
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
> v2: Rewrite the code according to Christoph's suggestion.
> 
>   drivers/md/md.c | 28 +++++++++++++---------------
>   1 file changed, 13 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index aff9118ff697..9598b4898ea9 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -654,24 +654,22 @@ bool md_flush_request(struct mddev *mddev, struct bio *bio)
>   		WARN_ON(percpu_ref_is_zero(&mddev->active_io));
>   		percpu_ref_get(&mddev->active_io);
>   		mddev->flush_bio = bio;
> -		bio = NULL;
> -	}
> -	spin_unlock_irq(&mddev->lock);
> -
> -	if (!bio) {
> +		spin_unlock_irq(&mddev->lock);
>   		INIT_WORK(&mddev->flush_work, submit_flushes);
>   		queue_work(md_wq, &mddev->flush_work);
> -	} else {
> -		/* flush was performed for some other bio while we waited. */
> -		if (bio->bi_iter.bi_size == 0)
> -			/* an empty barrier - all done */
> -			bio_endio(bio);
> -		else {
> -			bio->bi_opf &= ~REQ_PREFLUSH;
> -			return false;
> -		}
> +		return true;
>   	}
> -	return true;
> +
> +	/* flush was performed for some other bio while we waited. */
> +	spin_unlock_irq(&mddev->lock);
> +	if (bio->bi_iter.bi_size == 0) {

It's better to use bio_sectors() here.

Thanks,
Kuai

> +		/* pure flush without data - all done */
> +		bio_endio(bio);
> +		return true;
> +	}
> +
> +	bio->bi_opf &= ~REQ_PREFLUSH;
> +	return false;
>   }
>   EXPORT_SYMBOL(md_flush_request);
>   
> 

