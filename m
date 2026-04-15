Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32CFC298CAB;
	Wed, 15 Apr 2026 02:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776220052; cv=none; b=YAGt9Rzq6quW0M2q1dC3wrwJpyE7Nbu+8nQKPFU1gOTSs8QOpViE7KwziV8v1a8yXHrS3dyRVCY5K876MT4mh6T0qCnhPhozXyp4Q9I/eCbafk0BnY3klxZQPR5r+p34Ix7QJ4KEzlmdwJFiTLHZoDN1j/Y8G0NLv9N/ml+lE4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776220052; c=relaxed/simple;
	bh=Kai6Wm0JZg+urHODZCuK3fiQlizZtTUe0YE4FSYq8AU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LADGYzWK1ryrMjtVJ1k8eo6FkzFHY9UozvDOvvBaB3O50Lflk9MgJHNgnGJoah/GhfSyd3EmhuxJH2JPhmwP99NVzmtLkSTDKYM3y6lHZLdE9jkqEwMGUGlMD1xntzDfsSo6UNr+HvQT65rCAxRxsGiszmVfGhdk7zLN8s+uF1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fwQ5d5C5nzKHMMJ;
	Wed, 15 Apr 2026 10:27:17 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id B81F14056E;
	Wed, 15 Apr 2026 10:27:26 +0800 (CST)
Received: from [10.174.178.255] (unknown [10.174.178.255])
	by APP3 (Coremail) with SMTP id _Ch0CgBH9b6N995pICjKAQ--.36923S3;
	Wed, 15 Apr 2026 10:27:26 +0800 (CST)
Message-ID: <3785a0dd-a673-2551-1fdd-523ff4aca512@huaweicloud.com>
Date: Wed, 15 Apr 2026 10:27:24 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] md: factor out cloned bio cleanup into md_free_bio()
To: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>, song@kernel.org,
 yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yangerkun@huawei.com" <yangerkun@huawei.com>
References: <20260414103813.307601-1-abd.masalkhi@gmail.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20260414103813.307601-1-abd.masalkhi@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgBH9b6N995pICjKAQ--.36923S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAw1xKr1xXFWxJry8CFyUWrg_yoW5GrW3pF
	s7uFy5Grs5XF4ruay7Cayq9FyrJr4qqrW0ya4xt34rArnxAr9Yya1xu3ZYqry5GFZruF92
	q3WvgF17Gw4UtF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Yb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
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



在 2026/4/14 18:38, Abd-Alrhman Masalkhi 写道:
> Refactor duplicated cloned bio completion and cleanup logic into
> a new helper, md_free_bio().
> 
> md_end_clone_io() and md_free_cloned_bio() previously shared nearly
> identical teardown code, differing only in whether the original
> bio’s endio callback was invoked. Introduce a boolean parameter
> orig_endio to control this behavior and consolidate the logic.
> 
> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
> ---
>   drivers/md/md.c | 26 +++++++++-----------------
>   1 file changed, 9 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ac71640ff3a8..707d605fee61 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9208,7 +9208,7 @@ static void md_bitmap_end(struct mddev *mddev, struct md_io_clone *md_io_clone)
>   	fn(mddev, md_io_clone->offset, md_io_clone->sectors);
>   }
>   
> -static void md_end_clone_io(struct bio *bio)
> +static void md_free_bio(struct bio *bio, bool orig_endio)
>   {
>   	struct md_io_clone *md_io_clone = bio->bi_private;
>   	struct bio *orig_bio = md_io_clone->orig_bio;
> @@ -9224,10 +9224,16 @@ static void md_end_clone_io(struct bio *bio)
>   		bio_end_io_acct(orig_bio, md_io_clone->start_time);
>   
>   	bio_put(bio);
> -	bio_endio(orig_bio);
> +	if (orig_endio)
> +		bio_endio(orig_bio);
>   	percpu_ref_put(&mddev->active_io);
>   }
>   
> +static void md_end_clone_io(struct bio *bio)
> +{
> +	md_free_bio(bio, true);
> +}
> +
>   static void md_clone_bio(struct mddev *mddev, struct bio **bio)
>   {
>   	struct block_device *bdev = (*bio)->bi_bdev;
> @@ -9262,21 +9268,7 @@ EXPORT_SYMBOL_GPL(md_account_bio);
>   
>   void md_free_cloned_bio(struct bio *bio)
>   {
> -	struct md_io_clone *md_io_clone = bio->bi_private;
> -	struct bio *orig_bio = md_io_clone->orig_bio;
> -	struct mddev *mddev = md_io_clone->mddev;
> -
> -	if (bio_data_dir(orig_bio) == WRITE && md_bitmap_enabled(mddev, false))
> -		md_bitmap_end(mddev, md_io_clone);
> -
> -	if (bio->bi_status && !orig_bio->bi_status)
> -		orig_bio->bi_status = bio->bi_status;
> -
> -	if (md_io_clone->start_time)
> -		bio_end_io_acct(orig_bio, md_io_clone->start_time);
> -
> -	bio_put(bio);
> -	percpu_ref_put(&mddev->active_io);
> +	md_free_bio(bio, false);
>   }
>   EXPORT_SYMBOL_GPL(md_free_cloned_bio);
>   

md_free_bio() is redundant. Can md_end_clone_io() directly call
md_free_cloned_bio()?

We do not need to consider the compatibility of the EXPORT_SYMBOL in
mainline.

-- 
Thanks,
Nan

