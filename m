Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E951DFD8B;
	Thu, 18 Sep 2025 01:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758158807; cv=none; b=GENYaY+8u7IFg6OubGLxGGgA7QVCyaEA1NIJXePBqJ3Dv4SyUgq9cirgii5UwNLxOrIjscaouHm79mUZiGEPGmLnNFXKl1T9wpLWwekrkutLRbaewAsUUhkn7yNH7dKsIlWyPrt/egkIK0J5A+rzL/GaxJFtzEZEsjNvmU9l7VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758158807; c=relaxed/simple;
	bh=2CfXdtCbteURsx4aWzaClFfUCSgP3SL2Ji98atJXIyU=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=CJOOU9w2eS+nGCSkUWPsgKWM0eE32go1xBuByHBKGYTSlhhUV/zXsfFGNa3ESEVPzaTjFAztvBcJTQtIUpMxwPdi7gDJfjGXnGCzN1Tb0FAzaXhHTR9Udq0Dnv3KzIpFYl1qnDqoGGz2ZPoYBaJuWo1LrPPqXEQtq28ZAmVVNvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cRyfC65WwzYQtGr;
	Thu, 18 Sep 2025 09:26:43 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 75F8C1A0FAB;
	Thu, 18 Sep 2025 09:26:42 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgAncY3QX8to_VSACw--.1184S3;
	Thu, 18 Sep 2025 09:26:42 +0800 (CST)
Subject: Re: [PATCH v4 4/9] md/raid1,raid10: Don't set MD_BROKEN on failfast
 bio failure
To: Kenta Akagi <k@mgml.me>, Song Liu <song@kernel.org>,
 Mariusz Tkaczyk <mtkaczyk@kernel.org>, Shaohua Li <shli@fb.com>,
 Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250915034210.8533-1-k@mgml.me>
 <20250915034210.8533-5-k@mgml.me>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <1c71d0c8-dc3a-9dbf-4e69-e444f94c7ab8@huaweicloud.com>
Date: Thu, 18 Sep 2025 09:26:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250915034210.8533-5-k@mgml.me>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAncY3QX8to_VSACw--.1184S3
X-Coremail-Antispam: 1UD129KBjvJXoW3WF4DJr48Cr1xGw15Kw18Grg_yoW3ZFWrpa
	y3Ja9YyrZ8J345X3WUtFWDWa4F9w13KFWjkr1fAw1xZwn0qr93tF4UWryYgryDurZ5uw15
	Xa98Jw4DAFsFgFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AF
	wI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUwx
	hLUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/09/15 11:42, Kenta Akagi Ð´µÀ:
> Failfast is a feature implemented only for RAID1 and RAID10. It instructs
> the block device providing the rdev to immediately return a bio error
> without retrying if any issue occurs. This allows quickly detaching a
> problematic rdev and minimizes IO latency.
> 
> Due to its nature, failfast bios can fail easily, and md must not mark
> an essential rdev as Faulty or set MD_BROKEN on the array just because
> a failfast bio failed.
> 
> When failfast was introduced, RAID1 and RAID10 were designed to continue
> operating normally even if md_error was called for the last rdev. However,
> with the introduction of MD_BROKEN in RAID1/RAID10
> in commit 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10"), calling
> md_error for the last rdev now prevents further writes to the array.
> Despite this, the current failfast error handler still assumes that
> calling md_error will not break the array.
> 
> Normally, this is not an issue because MD_FAILFAST is not set when a bio
> is issued to the last rdev. However, if the array is not degraded and a
> bio with MD_FAILFAST has been issued, simultaneous failures could
> potentially break the array. This is unusual but can happen; for example,
> this can occur when using NVMe over TCP if all rdevs depend on
> a single Ethernet link.
> 
> In other words, this becomes a problem under the following conditions:
> Preconditions:
> * Failfast is enabled on all rdevs.
> * All rdevs are In_sync - This is a requirement for bio to be submit
>    with MD_FAILFAST.
> * At least one bio has been submitted but has not yet completed.
> 
> Trigger condition:
> * All underlying devices of the rdevs return an error for their failfast
>    bios.
> 
> Whether the bio is a read or a write makes little difference to the
> outcome.
> In the write case, md_error is invoked on each rdev through its bi_end_io
> handler.
> In the read case, losing the first rdev triggers a metadata
> update. Next, md_super_write, unlike raid1_write_request, issues the bio
> with MD_FAILFAST if the rdev supports it, causing the bio to fail
> immediately - Before this patchset, LastDev was set only by the failure
> path in super_written. Consequently, super_written calls md_error on the
> remaining rdev.
> 
> Prior to this commit, the following changes were introduced:
> * The helper function md_bio_failure_error() that skips the error handler
>    if a failfast bio targets the last rdev.
> * Serialization md_error() and md_bio_failure_error().
> * Setting the LastDev flag for rdevs that must not be lost.
> 
> This commit uses md_bio_failure_error() instead of md_error() for failfast
> bio failures, ensuring that failfast bios do not stop array operations.
> 
> Fixes: 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10")
> Signed-off-by: Kenta Akagi <k@mgml.me>
> ---
>   drivers/md/md.c     |  5 +----
>   drivers/md/raid1.c  | 37 ++++++++++++++++++-------------------
>   drivers/md/raid10.c |  9 +++++----
>   3 files changed, 24 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 65fdd9bae8f4..65814bbe9bad 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1004,11 +1004,8 @@ static void super_written(struct bio *bio)
>   	if (bio->bi_status) {
>   		pr_err("md: %s gets error=%d\n", __func__,
>   		       blk_status_to_errno(bio->bi_status));
> -		md_error(mddev, rdev);
> -		if (!test_bit(Faulty, &rdev->flags)
> -		    && (bio->bi_opf & MD_FAILFAST)) {
> +		if (!md_bio_failure_error(mddev, rdev, bio))
>   			set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
> -		}
>   	}
>   
>   	bio_put(bio);
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 32ad6b102ff7..8fff9dacc6e0 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -470,7 +470,7 @@ static void raid1_end_write_request(struct bio *bio)
>   		    (bio->bi_opf & MD_FAILFAST) &&
>   		    /* We never try FailFast to WriteMostly devices */
>   		    !test_bit(WriteMostly, &rdev->flags)) {
> -			md_error(r1_bio->mddev, rdev);
> +			md_bio_failure_error(r1_bio->mddev, rdev, bio);
>   		}

Can following check of faulty replaced with return value?
>   
>   		/*
> @@ -2178,8 +2178,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
>   	if (test_bit(FailFast, &rdev->flags)) {
>   		/* Don't try recovering from here - just fail it
>   		 * ... unless it is the last working device of course */
> -		md_error(mddev, rdev);
> -		if (test_bit(Faulty, &rdev->flags))
> +		if (md_bio_failure_error(mddev, rdev, bio))
>   			/* Don't try to read from here, but make sure
>   			 * put_buf does it's thing
>   			 */
> @@ -2657,9 +2656,8 @@ static void handle_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
>   static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
>   {
>   	struct mddev *mddev = conf->mddev;
> -	struct bio *bio;
> +	struct bio *bio, *updated_bio;
>   	struct md_rdev *rdev;
> -	sector_t sector;
>   
>   	clear_bit(R1BIO_ReadError, &r1_bio->state);
>   	/* we got a read error. Maybe the drive is bad.  Maybe just
> @@ -2672,29 +2670,30 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
>   	 */
>   
>   	bio = r1_bio->bios[r1_bio->read_disk];
> -	bio_put(bio);
> -	r1_bio->bios[r1_bio->read_disk] = NULL;
> +	updated_bio = NULL;
>   
>   	rdev = conf->mirrors[r1_bio->read_disk].rdev;
> -	if (mddev->ro == 0
> -	    && !test_bit(FailFast, &rdev->flags)) {
> -		freeze_array(conf, 1);
> -		fix_read_error(conf, r1_bio);
> -		unfreeze_array(conf);
> -	} else if (mddev->ro == 0 && test_bit(FailFast, &rdev->flags)) {
> -		md_error(mddev, rdev);
> +	if (mddev->ro == 0) {
> +		if (!test_bit(FailFast, &rdev->flags)) {
> +			freeze_array(conf, 1);
> +			fix_read_error(conf, r1_bio);
> +			unfreeze_array(conf);
> +		} else {
> +			md_bio_failure_error(mddev, rdev, bio);
> +		}
>   	} else {
> -		r1_bio->bios[r1_bio->read_disk] = IO_BLOCKED;
> +		updated_bio = IO_BLOCKED;
>   	}

I'll suggest a separate patch to cleanup the conditions first, it's
better for code review.

BTW, I'll prefer if else chain insted of nested if else, perhaps
following is better:

if (mddev->ro != 0) {
  /* read-only */
} else if (!test_bit(FailFast, &rdev->flags) {
  /* read-write and failfast is not set */
} else {
  /* read-write and failfast is set */
}
>   
> +	bio_put(bio);
> +	r1_bio->bios[r1_bio->read_disk] = updated_bio;
> +
>   	rdev_dec_pending(rdev, conf->mddev);
> -	sector = r1_bio->sector;
> -	bio = r1_bio->master_bio;
>   
>   	/* Reuse the old r1_bio so that the IO_BLOCKED settings are preserved */
>   	r1_bio->state = 0;
> -	raid1_read_request(mddev, bio, r1_bio->sectors, r1_bio);
> -	allow_barrier(conf, sector);
> +	raid1_read_request(mddev, r1_bio->master_bio, r1_bio->sectors, r1_bio);
> +	allow_barrier(conf, r1_bio->sector);
>   }
>   
>   static void raid1d(struct md_thread *thread)
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index dc4edd4689f8..b73af94a88b0 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -488,7 +488,7 @@ static void raid10_end_write_request(struct bio *bio)
>   			dec_rdev = 0;
>   			if (test_bit(FailFast, &rdev->flags) &&
>   			    (bio->bi_opf & MD_FAILFAST)) {
> -				md_error(rdev->mddev, rdev);
> +				md_bio_failure_error(rdev->mddev, rdev, bio);
>   			}
>  

Same as raid1, can following check of faulty replaced of return value.
>   			/*
> @@ -2443,7 +2443,7 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
>   				continue;
>   		} else if (test_bit(FailFast, &rdev->flags)) {
>   			/* Just give up on this device */
> -			md_error(rdev->mddev, rdev);
> +			md_bio_failure_error(rdev->mddev, rdev, tbio);
>   			continue;
>   		}
>   		/* Ok, we need to write this bio, either to correct an
> @@ -2895,8 +2895,9 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
>   		freeze_array(conf, 1);
>   		fix_read_error(conf, mddev, r10_bio);
>   		unfreeze_array(conf);
> -	} else
> -		md_error(mddev, rdev);
> +	} else {
> +		md_bio_failure_error(mddev, rdev, bio);
> +	}
>   
>   	rdev_dec_pending(rdev, mddev);
>   	r10_bio->state = 0;
> 

And please split this patch for raid1 and raid10.

Thanks
Kuai

