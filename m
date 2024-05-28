Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F2A17E8F0;
	Tue, 28 May 2024 13:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716901963; cv=none; b=KK4a7nCqxlLzacobrIoOBpVVghzmJ85X5nKh9ogZoyKOAxP6lNXAvCaxJSyHqfkuknCmlil5cS7X+fhfdGbhawfkAF4/GcZRVjIEaxO3p45cJmrn8bw1kgLT6J2ktzxpg6kgRtHJnpau8SzmywjWXW9SryvcbHb09o7ozuczORI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716901963; c=relaxed/simple;
	bh=1tJtup21p2gY7WxyXDxf5/LpfCQwkQ11h5YeSFMOGK4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=OjXdZN5nrkktae8sLDkih9RVP7cWv9UaYZt4JHE59Us7ZVoR7RgFqh1sgBlR5KpoLH4PhiLf+imhvVfKD6rc8B4fLAUjhYje2LiZrI7zbx6TNsAsNJrSsghc8K9lt7lI/l6WRcSn9MgwhxSI9pWLGVirkrejEuTyCwoW/tnjt/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4VpXx74mPmz4f3jXh;
	Tue, 28 May 2024 21:12:27 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id E56CF1A0199;
	Tue, 28 May 2024 21:12:36 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgBnOBFD2FVmyP6pNw--.58409S3;
	Tue, 28 May 2024 21:12:36 +0800 (CST)
Subject: Re: [PATCH 2/2] md: fix deadlock between mddev_suspend and flush bio
To: linan666@huaweicloud.com, song@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240525185257.3896201-1-linan666@huaweicloud.com>
 <20240525185257.3896201-3-linan666@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <7dc44b53-8dac-d4ff-0af6-4a718967aa26@huaweicloud.com>
Date: Tue, 28 May 2024 21:12:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240525185257.3896201-3-linan666@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBnOBFD2FVmyP6pNw--.58409S3
X-Coremail-Antispam: 1UD129KBjvJXoWxur4kWw1ktFW5KFW8try5Jwb_yoW7Gr4rpr
	W8t3ZIyw48WFZ0kw43JFykXrn5W3WxAFyjqF4rA3yfCr1qgF1kG3y3Wry8Xry5Cr1fJ3yk
	Ww4DXr1qva4jvrDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHU
	DUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/05/26 2:52, linan666@huaweicloud.com Ð´µÀ:
> From: Li Nan <linan122@huawei.com>
> 
> Deadlock occurs when mddev is being suspended while some flush bio is in
> progress. It is a complex issue.
> 
> T1. the first flush is at the ending stage, it clears 'mddev->flush_bio'
>      and tries to submit data, but is blocked because mddev is suspended
>      by T4.
> T2. the second flush sets 'mddev->flush_bio', and attempts to queue
>      md_submit_flush_data(), which is already running (T1) and won't
>      execute again if on the same CPU as T1.
> T3. the third flush inc active_io and tries to flush, but is blocked because
>      'mddev->flush_bio' is not NULL (set by T2).
> T4. mddev_suspend() is called and waits for active_io dec to 0 which is inc
>      by T3.
> 
>    T1		T2		T3		T4
>    (flush 1)	(flush 2)	(third 3)	(suspend)
>    md_submit_flush_data
>     mddev->flush_bio = NULL;
>     .
>     .	 	md_flush_request
>     .	  	 mddev->flush_bio = bio
>     .	  	 queue submit_flushes
>     .		 .
>     .		 .		md_handle_request
>     .		 .		 active_io + 1
>     .		 .		 md_flush_request
>     .		 .		  wait !mddev->flush_bio
>     .		 .
>     .		 .				mddev_suspend
>     .		 .				 wait !active_io
>     .		 .
>     .		 submit_flushes
>     .		 queue_work md_submit_flush_data
>     .		 //md_submit_flush_data is already running (T1)
>     .
>     md_handle_request
>      wait resume
> 
> The root issue is non-atomic inc/dec of active_io during flush process.
> active_io is dec before md_submit_flush_data is queued, and inc soon
> after md_submit_flush_data() run.
>    md_flush_request
>      active_io + 1
>      submit_flushes
>        active_io - 1
>        md_submit_flush_data
>          md_handle_request
>          active_io + 1
>            make_request
>          active_io - 1
> 
> If active_io is dec after md_handle_request() instead of within
> submit_flushes(), make_request() can be called directly intead of
> md_handle_request() in md_submit_flush_data(), and active_io will
> only inc and dec once in the whole flush process. Deadlock will be
> fixed.
> 
> Additionally, the only difference between fixing the issue and before is
> that there is no return error handling of make_request(). But after
> previous patch cleaned md_write_start(), make_requst() only return error
> in raid5_make_request() by dm-raid, see commit 41425f96d7aa ("dm-raid456,
> md/raid456: fix a deadlock for dm-raid456 while io concurrent with
> reshape)". Since dm always splits data and flush operation into two
> separate io, io size of flush submitted by dm always is 0, make_request()
> will not be called in md_submit_flush_data(). To prevent future
> modifications from introducing issues, add WARN_ON to ensure
> make_request() no error is returned in this context.
> 
> Fixes: fa2bbff7b0b4 ("md: synchronize flush io with array reconfiguration")
> Signed-off-by: Li Nan <linan122@huawei.com>

The patch itself looks correct. However, there was a plan to remove
the flush handling and submit the flush bio directly to underlying
disks like dm. Because md_flush_request(), which is fast patch, grab a
disk level spinlock mddev->lock, and will affect performance.

I'm fine taking this patch first, I'll leave the decision to Song.

Thanks,
Kuai


> ---
>   drivers/md/md.c | 26 +++++++++++++++-----------
>   1 file changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 14d6e615bcbb..9bb7e627e57f 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -550,13 +550,9 @@ static void md_end_flush(struct bio *bio)
>   
>   	rdev_dec_pending(rdev, mddev);
>   
> -	if (atomic_dec_and_test(&mddev->flush_pending)) {
> -		/* The pair is percpu_ref_get() from md_flush_request() */
> -		percpu_ref_put(&mddev->active_io);
> -
> +	if (atomic_dec_and_test(&mddev->flush_pending))
>   		/* The pre-request flush has finished */
>   		queue_work(md_wq, &mddev->flush_work);
> -	}
>   }
>   
>   static void md_submit_flush_data(struct work_struct *ws);
> @@ -587,12 +583,8 @@ static void submit_flushes(struct work_struct *ws)
>   			rcu_read_lock();
>   		}
>   	rcu_read_unlock();
> -	if (atomic_dec_and_test(&mddev->flush_pending)) {
> -		/* The pair is percpu_ref_get() from md_flush_request() */
> -		percpu_ref_put(&mddev->active_io);
> -
> +	if (atomic_dec_and_test(&mddev->flush_pending))
>   		queue_work(md_wq, &mddev->flush_work);
> -	}
>   }
>   
>   static void md_submit_flush_data(struct work_struct *ws)
> @@ -617,8 +609,20 @@ static void md_submit_flush_data(struct work_struct *ws)
>   		bio_endio(bio);
>   	} else {
>   		bio->bi_opf &= ~REQ_PREFLUSH;
> -		md_handle_request(mddev, bio);
> +
> +		/*
> +		 * make_requst() will never return error here, it only
> +		 * returns error in raid5_make_request() by dm-raid.
> +		 * Since dm always splits data and flush operation into
> +		 * two separate io, io size of flush submitted by dm
> +		 * always is 0, make_request() will not be called here.
> +		 */
> +		if (WARN_ON_ONCE(!mddev->pers->make_request(mddev, bio)))
> +			bio_io_error(bio);;
>   	}
> +
> +	/* The pair is percpu_ref_get() from md_flush_request() */
> +	percpu_ref_put(&mddev->active_io);
>   }
>   
>   /*
> 

