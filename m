Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D89313B7A3;
	Sat,  8 Feb 2025 02:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738982996; cv=none; b=Dqxm9+kzXewaG3jri/62pcKkBtdaLtCqzzs+jo4NhalbTiT8CTJ2wRmFGar2z5qTXa4AJ03llMa5P5q//QSRnfBWg05qa4lkRUApoGqZz/eIe9dwMiITgR+U8Ad5XpNllxPHA66IHiXTg6SbtoAuG2p6n0yeAfPBZYUGmJibgMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738982996; c=relaxed/simple;
	bh=ATACJNJ4XhCNhsp9+igAl7ToK86p8Dw1MpI9IPqXvUM=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=qSrQAJ06L2lApxPBsPQAJI9udDuUW/xr5HAEo/e7KNHGmSGI/SfZ+mys9EU9aV1LnLmpCiXZEL/keCwqrkWgaK64RV4uCWqPPZVEWt9SCAHjXV/mLDxC+tkbQ2afwnNKGi3+pIDXlRfxewbhtx7cEmwq2eGs2g4LSAtTPSXS1i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Yqb065Zgjz4f3kvl;
	Sat,  8 Feb 2025 10:49:26 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 59F311A12D3;
	Sat,  8 Feb 2025 10:49:49 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgB3219LxqZn8qbmDA--.64974S3;
	Sat, 08 Feb 2025 10:49:49 +0800 (CST)
Subject: Re: [PATCH v2 1/2] md/raid5: freeze reshape when encountering a bad
 read
To: Doug V Johnson <dougvj@dougvj.net>
Cc: Doug Johnson <dougvj@gmail.com>, Song Liu <song@kernel.org>,
 "open list:SOFTWARE RAID (Multiple Disks) SUPPORT"
 <linux-raid@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <9c3420a9-8f6a-1102-37d2-8f32787b2f9a@huaweicloud.com>
 <20250127090049.7952-1-dougvj@dougvj.net>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <21f250f9-04b5-76f6-84c9-1fd245b748c6@huaweicloud.com>
Date: Sat, 8 Feb 2025 10:49:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250127090049.7952-1-dougvj@dougvj.net>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3219LxqZn8qbmDA--.64974S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZr4fKF13Cr1kGw4rXF13urg_yoWrXryDpa
	98t3Z0kFWkGrsIgFZrWw4j9FyF93s7Way5Jw47W34UZ3Z8tFyfAFWDKa45uFW8try8Xa4q
	qFyUZr98CFWYkaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AF
	wI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1D
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UK2N
	tUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/01/27 17:00, Doug V Johnson Ð´µÀ:
> While adding an additional drive to a raid6 array, the reshape stalled
> at about 13% complete and any I/O operations on the array hung,
> creating an effective soft lock. The kernel reported a hung task in
> mdXX_reshape thread and I had to use magic sysrq to recover as systemd
> hung as well.
> 
> I first suspected an issue with one of the underlying block devices and
> as precaution I recovered the data in read only mode to a new array, but
> it turned out to be in the RAID layer as I was able to recreate the
> issue from a superblock dump in sparse files.
> 
> After poking around some I discovered that I had somehow propagated the
> bad block list to several devices in the array such that a few blocks
> were unreable. The bad read reported correctly in userspace during
> recovery, but it wasn't obvious that it was from a bad block list
> metadata at the time and instead confirmed my bias suspecting hardware
> issues
> 
> I was able to reproduce the issue with a minimal test case using small
> loopback devices. I put a script for this in a github repository:
> 
> https://github.com/dougvj/md_badblock_reshape_stall_test
> 
> This patch handles bad reads during a reshape by introducing a
> handle_failed_reshape function in a similar manner to
> handle_failed_resync. The function aborts the current stripe by
> unmarking STRIPE_EXPANDING and STRIP_EXPAND_READY, sets the
> MD_RECOVERY_FROZEN bit, reverts the head of the reshape to the safe
> position, and reports the situation in dmesg.
> 
> Signed-off-by: Doug V Johnson <dougvj@dougvj.net>
> ---
>   drivers/md/raid5.c | 23 +++++++++++++++++++++++
>   1 file changed, 23 insertions(+)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 5c79429acc64..bc0b0c2540f0 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3738,6 +3738,27 @@ handle_failed_sync(struct r5conf *conf, struct stripe_head *sh,
>   	md_done_sync(conf->mddev, RAID5_STRIPE_SECTORS(conf), !abort);
>   }
>   
> +static void
> +handle_failed_reshape(struct r5conf *conf, struct stripe_head *sh,
> +		      struct stripe_head_state *s)
> +{
> +	// Abort the current stripe
> +	clear_bit(STRIPE_EXPANDING, &sh->state);
> +	clear_bit(STRIPE_EXPAND_READY, &sh->state);
> +	pr_warn_ratelimited("md/raid:%s: read error during reshape at %lu, cannot progress",
> +			    mdname(conf->mddev),
> +			    (unsigned long)sh->sector);
pr_err() is fine here.

> +	// Freeze the reshape
> +	set_bit(MD_RECOVERY_FROZEN, &conf->mddev->recovery);
> +	// Revert progress to safe position
> +	spin_lock_irq(&conf->device_lock);
> +	conf->reshape_progress = conf->reshape_safe;
> +	spin_unlock_irq(&conf->device_lock);
> +	// report failed md sync
> +	md_done_sync(conf->mddev, 0, 0);
> +	wake_up(&conf->wait_for_reshape);

Just wonder, this will leave the array in the state that reshape is
still in progress, and forbid any other sync action(details in
md_choose_sync_action()). It's better to avoid that, not quite
sure yet how. :(

In theory, if user provide a new disk, this werid state can be resolved
by doing a recovery concurrent with the reshape. However, this is too
complicated and doesn't seem worth it.

Perhaps, check badblocks before starting reshape in the first place can
solve most problems in this case? We can keep this patch just in case
new badblocks are set while performing reshape.

Thanks,
Kuai

> +}
> +
>   static int want_replace(struct stripe_head *sh, int disk_idx)
>   {
>   	struct md_rdev *rdev;
> @@ -4987,6 +5008,8 @@ static void handle_stripe(struct stripe_head *sh)
>   			handle_failed_stripe(conf, sh, &s, disks);
>   		if (s.syncing + s.replacing)
>   			handle_failed_sync(conf, sh, &s);
> +		if (test_bit(STRIPE_EXPANDING, &sh->state))
> +			handle_failed_reshape(conf, sh, &s);
>   	}
>   
>   	/* Now we check to see if any write operations have recently
> 

