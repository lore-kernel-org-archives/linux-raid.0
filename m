Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31CE715E97;
	Mon, 18 Aug 2025 02:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755482714; cv=none; b=ZwwWROYAdYGUieFJ2vWVVjY9Dm3P3DfonXMSriZFVnf7GVKNpG6CemO0hSOGgzzpCe5fnmMRLDFDDbF6gsXbFpLaKw18RCLeAdRkywAQYc67MJDhRYbaNLdjcEiN2oNSn6h8MgZ2fig2S+VvS+FBX3NUj0ywprBDm+N62HAUYVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755482714; c=relaxed/simple;
	bh=zIckleAHEtqp0WedWH4RukHF3s/Rm6dh2MlDh+DXb7c=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=UNwaveMoVU8iGSMOfRfv5vG31N7lX0SWZ/7uq16MxNjghIWAiTS4FR4s/wM8K1fGqJ2tDgolZITRAr9dD4Ps7iNI2rMC0zxgBpvIYjx/MNvYXI3+FqrKn5ihYOBELtB9g4eOXrRpVQa9Q1ZyyASiaomhECk7BQ4pdyb08UX8PlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4c4wys6dHFzYQv7p;
	Mon, 18 Aug 2025 10:05:09 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 82EB21A15AC;
	Mon, 18 Aug 2025 10:05:08 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgBHwhJSiqJowZw3EA--.37666S3;
	Mon, 18 Aug 2025 10:05:08 +0800 (CST)
Subject: Re: [PATCH v2 1/3] md/raid1,raid10: don't broken array on failfast
 metadata write fails
To: Kenta Akagi <k@mgml.me>, Song Liu <song@kernel.org>,
 Mariusz Tkaczyk <mtkaczyk@kernel.org>, Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250817172710.4892-1-k@mgml.me>
 <20250817172710.4892-2-k@mgml.me>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <51efe62a-6190-1fd5-7f7b-b17c3d1af54b@huaweicloud.com>
Date: Mon, 18 Aug 2025 10:05:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250817172710.4892-2-k@mgml.me>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHwhJSiqJowZw3EA--.37666S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Ar13GF4xWF13ZF1UZF1fZwb_yoWxWF1Upa
	97XFWrArWqv34Ut3WUGFyUuayYgw48K3yYkryfC34xuFy5WrWUKFs5GryUtryDJayfCw1U
	Xa15J39rCFyqg3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AF
	wI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1D
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUwx
	hLUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/08/18 1:27, Kenta Akagi Ð´µÀ:
> A super_write IO failure with MD_FAILFAST must not cause the array
> to fail.
> 
> Because a failfast bio may fail even when the rdev is not broken,
> so IO must be retried rather than failing the array when a metadata
> write with MD_FAILFAST fails on the last rdev.

Why just last rdev? If failfast can fail when the rdev is not broken, I
feel we should retry for all the rdev.
> 
> A metadata write with MD_FAILFAST is retried after failure as
> follows:
> 
> 1. In super_written, MD_SB_NEED_REWRITE is set in sb_flags.
> 
> 2. In md_super_wait, which is called by the function that
> executed md_super_write and waits for completion,
> -EAGAIN is returned because MD_SB_NEED_REWRITE is set.
> 
> 3. The caller of md_super_wait (such as md_update_sb)
> receives a negative return value and then retries md_super_write.
> 
> 4. The md_super_write function, which is called to perform
> the same metadata write, issues a write bio without MD_FAILFAST
> this time.
> 
> When a write from super_written without MD_FAILFAST fails,
> the array may broken, and MD_BROKEN should be set.
> 
> After commit 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10"),
> calling md_error on the last rdev in RAID1/10 always sets
> the MD_BROKEN flag on the array.
> As a result, when failfast IO fails on the last rdev, the array
> immediately becomes failed.
> 
> This commit prevents MD_BROKEN from being set when a super_write with
> MD_FAILFAST fails on the last rdev, ensuring that the array does
> not become failed due to failfast IO failures.
> 
> Failfast IO failures on any rdev except the last one are not retried
> and are marked as Faulty immediately. This minimizes array IO latency
> when an rdev fails.
> 
> Fixes: 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10")
> Signed-off-by: Kenta Akagi <k@mgml.me>
> ---
>   drivers/md/md.c     |  9 ++++++---
>   drivers/md/md.h     |  7 ++++---
>   drivers/md/raid1.c  | 12 ++++++++++--
>   drivers/md/raid10.c | 12 ++++++++++--
>   4 files changed, 30 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ac85ec73a409..61a8188849a3 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -999,14 +999,17 @@ static void super_written(struct bio *bio)
>   	if (bio->bi_status) {
>   		pr_err("md: %s gets error=%d\n", __func__,
>   		       blk_status_to_errno(bio->bi_status));
> +		if (bio->bi_opf & MD_FAILFAST)
> +			set_bit(FailfastIOFailure, &rdev->flags);

I think it's better to retry the bio with the flag cleared, then all
underlying procedures can stay the same.

Thanks,
Kuai

>   		md_error(mddev, rdev);
>   		if (!test_bit(Faulty, &rdev->flags)
>   		    && (bio->bi_opf & MD_FAILFAST)) {
> +			pr_warn("md: %s: Metadata write will be repeated to %pg\n",
> +				mdname(mddev), rdev->bdev);
>   			set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
> -			set_bit(LastDev, &rdev->flags);
>   		}
>   	} else
> -		clear_bit(LastDev, &rdev->flags);
> +		clear_bit(FailfastIOFailure, &rdev->flags);
>   
>   	bio_put(bio);
>   
> @@ -1048,7 +1051,7 @@ void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
>   
>   	if (test_bit(MD_FAILFAST_SUPPORTED, &mddev->flags) &&
>   	    test_bit(FailFast, &rdev->flags) &&
> -	    !test_bit(LastDev, &rdev->flags))
> +	    !test_bit(FailfastIOFailure, &rdev->flags))
>   		bio->bi_opf |= MD_FAILFAST;
>   
>   	atomic_inc(&mddev->pending_writes);
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 51af29a03079..cf989aca72ad 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -281,9 +281,10 @@ enum flag_bits {
>   				 * It is expects that no bad block log
>   				 * is present.
>   				 */
> -	LastDev,		/* Seems to be the last working dev as
> -				 * it didn't fail, so don't use FailFast
> -				 * any more for metadata
> +	FailfastIOFailure,	/* A device that failled a metadata write
> +				 * with failfast.
> +				 * error_handler must not fail the array
> +				 * if last device has this flag.
>   				 */
>   	CollisionCheck,		/*
>   				 * check if there is collision between raid1
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 408c26398321..fc7195e58f80 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1746,8 +1746,12 @@ static void raid1_status(struct seq_file *seq, struct mddev *mddev)
>    *	- recovery is interrupted.
>    *	- &mddev->degraded is bumped.
>    *
> - * @rdev is marked as &Faulty excluding case when array is failed and
> - * &mddev->fail_last_dev is off.
> + * If @rdev is marked with &FailfastIOFailure, it means that super_write
> + * failed in failfast and will be retried, so the @mddev did not fail.
> + *
> + * @rdev is marked as &Faulty excluding any cases:
> + *	- when @mddev is failed and &mddev->fail_last_dev is off
> + *	- when @rdev is last device and &FailfastIOFailure flag is set
>    */
>   static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>   {
> @@ -1758,6 +1762,10 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>   
>   	if (test_bit(In_sync, &rdev->flags) &&
>   	    (conf->raid_disks - mddev->degraded) == 1) {
> +		if (test_bit(FailfastIOFailure, &rdev->flags)) {
> +			spin_unlock_irqrestore(&conf->device_lock, flags);
> +			return;
> +		}
>   		set_bit(MD_BROKEN, &mddev->flags);
>   
>   		if (!mddev->fail_last_dev) {
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index b60c30bfb6c7..ff105a0dcd05 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1995,8 +1995,12 @@ static int enough(struct r10conf *conf, int ignore)
>    *	- recovery is interrupted.
>    *	- &mddev->degraded is bumped.
>    *
> - * @rdev is marked as &Faulty excluding case when array is failed and
> - * &mddev->fail_last_dev is off.
> + * If @rdev is marked with &FailfastIOFailure, it means that super_write
> + * failed in failfast, so the @mddev did not fail.
> + *
> + * @rdev is marked as &Faulty excluding any cases:
> + *	- when @mddev is failed and &mddev->fail_last_dev is off
> + *	- when @rdev is last device and &FailfastIOFailure flag is set
>    */
>   static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
>   {
> @@ -2006,6 +2010,10 @@ static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
>   	spin_lock_irqsave(&conf->device_lock, flags);
>   
>   	if (test_bit(In_sync, &rdev->flags) && !enough(conf, rdev->raid_disk)) {
> +		if (test_bit(FailfastIOFailure, &rdev->flags)) {
> +			spin_unlock_irqrestore(&conf->device_lock, flags);
> +			return;
> +		}
>   		set_bit(MD_BROKEN, &mddev->flags);
>   
>   		if (!mddev->fail_last_dev) {
> 

