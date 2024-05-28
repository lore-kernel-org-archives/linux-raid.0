Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE2E6F08A;
	Tue, 28 May 2024 12:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716900840; cv=none; b=XagDR6IExYxnL/JHlZa3TBlAh1Mhyruf8/uApY832Ho2hQg3qAeJK3zguQsUT7NAbf12kYG4cFwKs8Y4X5E5lAO3uFRfgqoEokOuJzeIxwN8P27MbZAIMzMxgTqcoyWr9YMAYzzQ9dFCIUx05Pea/b/1uE4eJ219DZQHpSXaS1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716900840; c=relaxed/simple;
	bh=K9M37Hvkq5xIoqEJdWpIX/4u+ONW84wTN5k5sEYzc7s=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=iauVz0lFeGOBUHNyHJ6WWsktwPKGXmfwM8/7U3kw7brMCVEZrofttnzD8aE7Cx2MZbDDKMT2L9EoA/u0gDC1nWveP+M7chmNmtXFfjcOISjUBtk4f1XCDfBr/HUgJhpEv3dK0Np+fuU4PWR08z34mcFVb6U3DugeNXX20apkup8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4VpXWW0hrTz4f3prW;
	Tue, 28 May 2024 20:53:43 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 1F99F1A0199;
	Tue, 28 May 2024 20:53:49 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgAXKwTb01VmF8qoNw--.9293S3;
	Tue, 28 May 2024 20:53:49 +0800 (CST)
Subject: Re: [PATCH 1/2] md: change the return value type of md_write_start to
 void
To: linan666@huaweicloud.com, song@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>, Yu Kuai <yukuai1@huaweicloud.com>
References: <20240525185257.3896201-1-linan666@huaweicloud.com>
 <20240525185257.3896201-2-linan666@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <e1c90554-2bfa-1237-bdf7-97a0c1e69489@huaweicloud.com>
Date: Tue, 28 May 2024 20:53:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240525185257.3896201-2-linan666@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAXKwTb01VmF8qoNw--.9293S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAF4xKF47KFW3Wr4rKrW5trb_yoWrZw1rp3
	y0yFy5Zw4jy3yUX3WUCFWDua45Xw1xKrZ2kFW7G34xXrnxWFWDGa15Xay8tr1Dua4fuwnx
	tan0ya47u3WIgFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_
	Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UU
	UUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2024/05/26 2:52, linan666@huaweicloud.com Ð´µÀ:
> From: Li Nan <linan122@huawei.com>
> 
> Commit cc27b0c78c79 ("md: fix deadlock between mddev_suspend() and
> md_write_start()") aborted md_write_start() with false when mddev is
> suspended, which fixed a deadlock if calling mddev_suspend() with
> holding reconfig_mutex(). Since mddev_suspend() now includes
> lockdep_assert_not_held(), it no longer holds the reconfig_mutex. This
> makes previous abort unnecessary. Now, remove unnecessary abort and
> change function return value to void.

Nice cleanup, feel free to add:

Reviewed-by: Yu Kuai <yukuai3@huawei.com>
> 
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>   drivers/md/md.h     |  2 +-
>   drivers/md/md.c     | 14 ++++----------
>   drivers/md/raid1.c  |  3 +--
>   drivers/md/raid10.c |  3 +--
>   drivers/md/raid5.c  |  3 +--
>   5 files changed, 8 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index ca085ecad504..487582058f74 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -785,7 +785,7 @@ extern void md_unregister_thread(struct mddev *mddev, struct md_thread __rcu **t
>   extern void md_wakeup_thread(struct md_thread __rcu *thread);
>   extern void md_check_recovery(struct mddev *mddev);
>   extern void md_reap_sync_thread(struct mddev *mddev);
> -extern bool md_write_start(struct mddev *mddev, struct bio *bi);
> +extern void md_write_start(struct mddev *mddev, struct bio *bi);
>   extern void md_write_inc(struct mddev *mddev, struct bio *bi);
>   extern void md_write_end(struct mddev *mddev);
>   extern void md_done_sync(struct mddev *mddev, int blocks, int ok);
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 509e5638cea1..14d6e615bcbb 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8638,12 +8638,12 @@ EXPORT_SYMBOL(md_done_sync);
>    * A return value of 'false' means that the write wasn't recorded
>    * and cannot proceed as the array is being suspend.
>    */
> -bool md_write_start(struct mddev *mddev, struct bio *bi)
> +void md_write_start(struct mddev *mddev, struct bio *bi)
>   {
>   	int did_change = 0;
>   
>   	if (bio_data_dir(bi) != WRITE)
> -		return true;
> +		return;
>   
>   	BUG_ON(mddev->ro == MD_RDONLY);
>   	if (mddev->ro == MD_AUTO_READ) {
> @@ -8676,15 +8676,9 @@ bool md_write_start(struct mddev *mddev, struct bio *bi)
>   	if (did_change)
>   		sysfs_notify_dirent_safe(mddev->sysfs_state);
>   	if (!mddev->has_superblocks)
> -		return true;
> +		return;
>   	wait_event(mddev->sb_wait,
> -		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) ||
> -		   is_md_suspended(mddev));
> -	if (test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags)) {
> -		percpu_ref_put(&mddev->writes_pending);
> -		return false;
> -	}
> -	return true;
> +		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
>   }
>   EXPORT_SYMBOL(md_write_start);
>   
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 7b8a71ca66dd..0d80ff471c73 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1687,8 +1687,7 @@ static bool raid1_make_request(struct mddev *mddev, struct bio *bio)
>   	if (bio_data_dir(bio) == READ)
>   		raid1_read_request(mddev, bio, sectors, NULL);
>   	else {
> -		if (!md_write_start(mddev,bio))
> -			return false;
> +		md_write_start(mddev,bio);
>   		raid1_write_request(mddev, bio, sectors);
>   	}
>   	return true;
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index a4556d2e46bf..f8d7c02c6ed5 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1836,8 +1836,7 @@ static bool raid10_make_request(struct mddev *mddev, struct bio *bio)
>   	    && md_flush_request(mddev, bio))
>   		return true;
>   
> -	if (!md_write_start(mddev, bio))
> -		return false;
> +	md_write_start(mddev, bio);
>   
>   	if (unlikely(bio_op(bio) == REQ_OP_DISCARD))
>   		if (!raid10_handle_discard(mddev, bio))
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 2bd1ce9b3922..a84389311dd1 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -6078,8 +6078,7 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
>   		ctx.do_flush = bi->bi_opf & REQ_PREFLUSH;
>   	}
>   
> -	if (!md_write_start(mddev, bi))
> -		return false;
> +	md_write_start(mddev, bi);
>   	/*
>   	 * If array is degraded, better not do chunk aligned read because
>   	 * later we might have to read it again in order to reconstruct
> 

