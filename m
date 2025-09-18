Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE74E1EEF9;
	Thu, 18 Sep 2025 01:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758157473; cv=none; b=lVHH+xRFNGSwII5WYdAVDdLT2yP8fOgf9pV1FzVSJ/QS55Ze0Rtrz9VRjfyzcEGsaUSBe21+4rwx/D3v639sqgdCoGUsexABuytxCHYJd6xirtisTW5IdKrQjFPcxMPIgE4Jbx6/sLTR4mDiFxNAJd3vGpBUiYHD4PcIdZCi4js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758157473; c=relaxed/simple;
	bh=F1FmOKUhQw8DTrpWvz9CifXC8DB0ZTDyx6xPpsX/uSc=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=b77Pf5BQiR7RrNtGZxMDBfWp6W+rq4Qp8eaNaWJ0UCXT7uLeLEZwhjoomlbEHjvdfgXvXbG5X6EiyZnGCBMR5wRV6hi1aOFvuuDFWK1a6iicjQlE35gGBhUz9XzZ6yJsBPFzo3yvioHYQAjmwVvXUk5s2LaPqUH25zhvYeLVw3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cRy8V56B0zKHMZS;
	Thu, 18 Sep 2025 09:04:26 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 798011A0F21;
	Thu, 18 Sep 2025 09:04:27 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgCn8IyaWstoB5B+Cw--.65245S3;
	Thu, 18 Sep 2025 09:04:27 +0800 (CST)
Subject: Re: [PATCH v4 2/9] md: serialize md_error()
To: Kenta Akagi <k@mgml.me>, Song Liu <song@kernel.org>,
 Mariusz Tkaczyk <mtkaczyk@kernel.org>, Shaohua Li <shli@fb.com>,
 Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250915034210.8533-1-k@mgml.me>
 <20250915034210.8533-3-k@mgml.me>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <d42ef125-3c47-3524-140c-0df76ea85c12@huaweicloud.com>
Date: Thu, 18 Sep 2025 09:04:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250915034210.8533-3-k@mgml.me>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCn8IyaWstoB5B+Cw--.65245S3
X-Coremail-Antispam: 1UD129KBjvJXoWxCr4ftry5Kr45tF17JF45Awb_yoW5ur48pF
	W8tas8Cr4UZ3yYg3WDAFWDua4YgwnYkr9rtryfJ34xtrnIgrn3GF1YqF1Ygr98Cay3Zwnr
	X3W5KFZ8uryIqrUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AF
	wI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUot
	CzDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/09/15 11:42, Kenta Akagi 写道:
> md_error is mainly called when a bio fails, so it can run in parallel.
> Each personality’s error_handler locks with device_lock, so concurrent
> calls are safe.
> 
> However, RAID1 and RAID10 require changes for Failfast bio error handling,
> which needs a special helper for md_error. For that helper to work, the
> regular md_error must also be serialized.
> 
> The helper function md_bio_failure_error for failfast will be introduced
> in a subsequent commit.
> 
> This commit serializes md_error for all RAID personalities. While
> unnecessary for RAID levels other than 1 and 10, it has no performance
> impact as it is a cold path.
> 
> Signed-off-by: Kenta Akagi <k@mgml.me>
> ---
>   drivers/md/md.c | 10 +++++++++-
>   drivers/md/md.h |  4 ++++
>   2 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 268410b66b83..5607578a6db9 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -705,6 +705,7 @@ int mddev_init(struct mddev *mddev)
>   	atomic_set(&mddev->openers, 0);
>   	atomic_set(&mddev->sync_seq, 0);
>   	spin_lock_init(&mddev->lock);
> +	spin_lock_init(&mddev->error_handle_lock);

Instead of introduing a new lock, can we use device_lock directly?
it's held inside pers->error_handler() now, just move it forward
to md_error().

Thanks,
Kuai

>   	init_waitqueue_head(&mddev->sb_wait);
>   	init_waitqueue_head(&mddev->recovery_wait);
>   	mddev->reshape_position = MaxSector;
> @@ -8262,7 +8263,7 @@ void md_unregister_thread(struct mddev *mddev, struct md_thread __rcu **threadp)
>   }
>   EXPORT_SYMBOL(md_unregister_thread);
>   
> -void md_error(struct mddev *mddev, struct md_rdev *rdev)
> +void _md_error(struct mddev *mddev, struct md_rdev *rdev)
>   {
>   	if (!rdev || test_bit(Faulty, &rdev->flags))
>   		return;
> @@ -8287,6 +8288,13 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
>   		queue_work(md_misc_wq, &mddev->event_work);
>   	md_new_event();
>   }
> +
> +void md_error(struct mddev *mddev, struct md_rdev *rdev)
> +{
> +	spin_lock(&mddev->error_handle_lock);
> +	_md_error(mddev, rdev);
> +	spin_unlock(&mddev->error_handle_lock);
> +}
>   EXPORT_SYMBOL(md_error);
>   
>   /* seq_file implementation /proc/mdstat */
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index ec598f9a8381..5177cb609e4b 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -619,6 +619,9 @@ struct mddev {
>   	/* The sequence number for sync thread */
>   	atomic_t sync_seq;
>   
> +	/* Lock for serializing md_error */
> +	spinlock_t			error_handle_lock;
> +
>   	bool	has_superblocks:1;
>   	bool	fail_last_dev:1;
>   	bool	serialize_policy:1;
> @@ -901,6 +904,7 @@ extern void md_write_start(struct mddev *mddev, struct bio *bi);
>   extern void md_write_inc(struct mddev *mddev, struct bio *bi);
>   extern void md_write_end(struct mddev *mddev);
>   extern void md_done_sync(struct mddev *mddev, int blocks, int ok);
> +void _md_error(struct mddev *mddev, struct md_rdev *rdev);
>   extern void md_error(struct mddev *mddev, struct md_rdev *rdev);
>   extern void md_finish_reshape(struct mddev *mddev);
>   void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
> 

