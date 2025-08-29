Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6731A83F8;
	Fri, 29 Aug 2025 02:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756436098; cv=none; b=SIfwzJ7iDQQv5GGd7CEIwUGgeqdoihZvQP62LxT35ZxS/D+cfQD136L12nrHsc0vS/nfDyTGz3fzvBw289NeRLFquE3fEE9Jou0qHP3SacUWT8JRDGDYhlOjOqbq6DbvwXQKlYDvkHCFfujjZudE85c0etqMYTFf9p4JFGtiPfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756436098; c=relaxed/simple;
	bh=M7CNDRmw/Hv42h05MffjEuSIitd+5uuOL7qXAPjIypE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z58wfeteAAJDLMzt6esV0oZc2u9VKoYXjWt4lMNwJjNfi/rKK9fe5UXe74l7UdoqMbvPN+HR5TZCuOjMwz8gKZq1Ob+lB+dke7jXMaVhXRwTe5D0Hl34xth2hLjwG7KX9sKbynFG9FV9yF4bz9PfVla+8X4TQaJCrfgnhcCNAk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cCjYB39VfzYQvN2;
	Fri, 29 Aug 2025 10:54:54 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id F07D11A12EE;
	Fri, 29 Aug 2025 10:54:52 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP4 (Coremail) with SMTP id gCh0CgAXYIx8FrFoCqycAg--.21597S3;
	Fri, 29 Aug 2025 10:54:52 +0800 (CST)
Message-ID: <dcb72e23-d0ea-c8b3-24db-5dd515f619a8@huaweicloud.com>
Date: Fri, 29 Aug 2025 10:54:52 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v3 1/3] md/raid1,raid10: Do not set MD_BROKEN on failfast
 io failure
To: Kenta Akagi <k@mgml.me>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>, Mariusz Tkaczyk <mtkaczyk@kernel.org>,
 Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250828163216.4225-1-k@mgml.me>
 <20250828163216.4225-2-k@mgml.me>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20250828163216.4225-2-k@mgml.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXYIx8FrFoCqycAg--.21597S3
X-Coremail-Antispam: 1UD129KBjvJXoWxtrW5XF1DGFy8tr4kur13twb_yoW7Zryfpa
	9rJa9YyrWjv3s8t3WUtFyDW3Wjvw4UKFZIkryfZ34xt3Z0qrW5GFs5WryUKF1DAay3C3W5
	X3y5Jws7A3W2gFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU90b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487
	Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aV
	AFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xF
	o4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIda
	VFxhVjvjDU0xZFpf9x07UG38nUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/


在 2025/8/29 0:32, Kenta Akagi 写道:
> This commit ensures that an MD_FAILFAST IO failure does not put
> the array into a broken state.
> 
> When failfast is enabled on rdev in RAID1 or RAID10,
> the array may be flagged MD_BROKEN in the following cases.
> - If MD_FAILFAST IOs to multiple rdevs fail simultaneously
> - If an MD_FAILFAST metadata write to the 'last' rdev fails

[...]

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 408c26398321..8a61fd93b3ff 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -470,6 +470,7 @@ static void raid1_end_write_request(struct bio *bio)
>   		    (bio->bi_opf & MD_FAILFAST) &&
>   		    /* We never try FailFast to WriteMostly devices */
>   		    !test_bit(WriteMostly, &rdev->flags)) {
> +			set_bit(FailfastIOFailure, &rdev->flags);
>   			md_error(r1_bio->mddev, rdev);
>   		}
>   
> @@ -1746,8 +1747,12 @@ static void raid1_status(struct seq_file *seq, struct mddev *mddev)
>    *	- recovery is interrupted.
>    *	- &mddev->degraded is bumped.
>    *
> - * @rdev is marked as &Faulty excluding case when array is failed and
> - * &mddev->fail_last_dev is off.
> + * If @rdev has &FailfastIOFailure and it is the 'last' rdev,
> + * then @mddev and @rdev will not be marked as failed.
> + *
> + * @rdev is marked as &Faulty excluding any cases:
> + *	- when @mddev is failed and &mddev->fail_last_dev is off
> + *	- when @rdev is last device and &FailfastIOFailure flag is set
>    */
>   static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>   {
> @@ -1758,6 +1763,13 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>   
>   	if (test_bit(In_sync, &rdev->flags) &&
>   	    (conf->raid_disks - mddev->degraded) == 1) {
> +		if (test_and_clear_bit(FailfastIOFailure, &rdev->flags)) {
> +			spin_unlock_irqrestore(&conf->device_lock, flags);
> +			pr_warn_ratelimited("md/raid1:%s: Failfast IO failure on %pg, "
> +				"last device but ignoring it\n",
> +				mdname(mddev), rdev->bdev);
> +			return;
> +		}
>   		set_bit(MD_BROKEN, &mddev->flags);
>   
>   		if (!mddev->fail_last_dev) {
> @@ -2148,6 +2160,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
>   	if (test_bit(FailFast, &rdev->flags)) {
>   		/* Don't try recovering from here - just fail it
>   		 * ... unless it is the last working device of course */
> +		set_bit(FailfastIOFailure, &rdev->flags);
>   		md_error(mddev, rdev);
>   		if (test_bit(Faulty, &rdev->flags))
>   			/* Don't try to read from here, but make sure
> @@ -2652,6 +2665,7 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
>   		fix_read_error(conf, r1_bio);
>   		unfreeze_array(conf);
>   	} else if (mddev->ro == 0 && test_bit(FailFast, &rdev->flags)) {
> +		set_bit(FailfastIOFailure, &rdev->flags);
>   		md_error(mddev, rdev);
>   	} else {
>   		r1_bio->bios[r1_bio->read_disk] = IO_BLOCKED;
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index b60c30bfb6c7..530ad6503189 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -488,6 +488,7 @@ static void raid10_end_write_request(struct bio *bio)
>   			dec_rdev = 0;
>   			if (test_bit(FailFast, &rdev->flags) &&
>   			    (bio->bi_opf & MD_FAILFAST)) {
> +				set_bit(FailfastIOFailure, &rdev->flags);
>   				md_error(rdev->mddev, rdev);
>   			}
>   

Thank you for the patch. There may be an issue with 'test_and_clear'.

If two write IO go to the same rdev, MD_BROKEN may be set as below:

IO1					IO2
set FailfastIOFailure
					set FailfastIOFailure		
  md_error
   raid1_error
    test_and_clear FailfastIOFailur
   					 md_error
					  raid1_error
					   //FailfastIOFailur is cleared
					   set MD_BROKEN

Maybe we should check whether FailfastIOFailure is already set before
setting it. It also needs to be considered in metadata writes.

> @@ -1995,8 +1996,12 @@ static int enough(struct r10conf *conf, int ignore)
>    *	- recovery is interrupted.
>    *	- &mddev->degraded is bumped.
>    *
> - * @rdev is marked as &Faulty excluding case when array is failed and
> - * &mddev->fail_last_dev is off.
> + * If @rdev has &FailfastIOFailure and it is the 'last' rdev,
> + * then @mddev and @rdev will not be marked as failed.
> + *
> + * @rdev is marked as &Faulty excluding any cases:
> + *	- when @mddev is failed and &mddev->fail_last_dev is off
> + *	- when @rdev is last device and &FailfastIOFailure flag is set
>    */
>   static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
>   {
> @@ -2006,6 +2011,13 @@ static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
>   	spin_lock_irqsave(&conf->device_lock, flags);
>   
>   	if (test_bit(In_sync, &rdev->flags) && !enough(conf, rdev->raid_disk)) {
> +		if (test_and_clear_bit(FailfastIOFailure, &rdev->flags)) {
> +			spin_unlock_irqrestore(&conf->device_lock, flags);
> +			pr_warn_ratelimited("md/raid10:%s: Failfast IO failure on %pg, "
> +				"last device but ignoring it\n",
> +				mdname(mddev), rdev->bdev);
> +			return;
> + >   		set_bit(MD_BROKEN, &mddev->flags);
>   
>   		if (!mddev->fail_last_dev) {
> @@ -2413,6 +2425,7 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
>   				continue;
>   		} else if (test_bit(FailFast, &rdev->flags)) {
>   			/* Just give up on this device */
> +			set_bit(FailfastIOFailure, &rdev->flags);
>   			md_error(rdev->mddev, rdev);
>   			continue;
>   		}
> @@ -2865,8 +2878,10 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
>   		freeze_array(conf, 1);
>   		fix_read_error(conf, mddev, r10_bio);
>   		unfreeze_array(conf);
> -	} else
> +	} else {
> +		set_bit(FailfastIOFailure, &rdev->flags);
>   		md_error(mddev, rdev);
> +	}
>   
>   	rdev_dec_pending(rdev, mddev);
>   	r10_bio->state = 0;

-- 
Thanks,
Nan

