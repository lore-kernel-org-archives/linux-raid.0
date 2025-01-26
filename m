Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED5917E;
	Sun, 26 Jan 2025 06:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737872837; cv=none; b=TQriI4R2V/TXtYCJHbLRkfFz9j0G1Ud0XjklMgHraUnSnu05lLxsR/HVMlOwbvN2g9YL/J/eslySbsTdUVBTKaGrCZhlHWejan9HNfkn/wgVeJbi0a/PhcaIq1ZA5rcoYcBW84a8YlaVQiv6RnZS8MqMhaJrOuodJHFanF2bNp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737872837; c=relaxed/simple;
	bh=EbrCYOVreN936dWOoelmcd4QS2KNlVwAhQOmwCHBKlo=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=bqJq35YpTW2e/EwdJN4Hxfq0/Ril4VCxxrSQGIJCvxB84pxcEb8JF7uK79BLvyIyVwYUmJLd0+4ADE2cf6l69e33rZB7HL4fgf2MAAeW0s7sRSYFPiYx+o5PBcWPgHBv2n82s4uTI5fxkl7ehJZhBahplaPD6aGksS2o8B5xYio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YghQv5vX1z4f3jMF;
	Sun, 26 Jan 2025 14:26:47 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id D95121A0C6D;
	Sun, 26 Jan 2025 14:27:09 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP3 (Coremail) with SMTP id _Ch0CgCn+sS81ZVnl832Bw--.64829S3;
	Sun, 26 Jan 2025 14:27:09 +0800 (CST)
Subject: Re: [PATCH 1/2] md/raid5: skip stripes with bad reads during reshape
 to avoid stall
To: Doug V Johnson <dougvj@dougvj.net>
Cc: Doug Johnson <dougvj@gmail.com>, Song Liu <song@kernel.org>,
 "open list:SOFTWARE RAID (Multiple Disks) SUPPORT"
 <linux-raid@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250125012702.18773-1-dougvj@dougvj.net>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <9c3420a9-8f6a-1102-37d2-8f32787b2f9a@huaweicloud.com>
Date: Sun, 26 Jan 2025 14:27:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250125012702.18773-1-dougvj@dougvj.net>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgCn+sS81ZVnl832Bw--.64829S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZr4fKF13CF1rZw17tw17Awb_yoW5AFW7p3
	yUtw4Y9FWDKF13Kay7Aw4UWrWUC34kWay5Gw45X34Uuas8ZrySyryDKa4UJa4Utr1Fqa4j
	qw1Uur98JF4qkaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkKb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AK
	xVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1l
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1veHD
	UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/01/25 9:26, Doug V Johnson Ð´µÀ:
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
> This patch handles bad reads during a reshape by unmarking the
> STRIPE_EXPANDING and STRIPE_EXPAND_READY bits effectively skipping the
> stripe and then reports the issue in dmesg.
> 
> Signed-off-by: Doug V Johnson <dougvj@dougvj.net>
> ---
>   drivers/md/raid5.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 5c79429acc64..0ae9ac695d8e 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -4987,6 +4987,14 @@ static void handle_stripe(struct stripe_head *sh)
>   			handle_failed_stripe(conf, sh, &s, disks);
>   		if (s.syncing + s.replacing)
>   			handle_failed_sync(conf, sh, &s);
> +		if (test_bit(STRIPE_EXPANDING, &sh->state)) {
> +			pr_warn_ratelimited("md/raid:%s: read error during reshape at %lu",
> +					    mdname(conf->mddev),
> +					    (unsigned long)sh->sector);
> +			/* Abort the current stripe */
> +			clear_bit(STRIPE_EXPANDING, &sh->state);
> +			clear_bit(STRIPE_EXPAND_READY, &sh->state);
> +		}
>   	}

Thanks for the patch, however, for example:

before reshape, three disks raid5:
rdev0           rdev1           rdev2
chunk0          chunk1          P0
chunk2(BB)      P1(BB)          chunk3
P2              chunk4          chunk5
chunk6          chunk7          P3
chunk8          P4              chunk9
P5              chunk10         chunk11

after reshape, four disks raid5:
rdev0           rdev1           rdev2           rdev3
chunk0          chunk1          chunk2(lost)    P0
chunk3(BB)      chunk4(BB)      P1              chunk5
chunk6          P2              chunk7          chunk8
P3              chunk9          chunk10         chunk11

In this case, before reshape, data from chunk2 is lost, however,
after reshape, chunk2 is lost as well, need to set badblocks to rdev2 to
prevent user get wrong data. Meanwhile, chunk3 and chunk4 are all lost,
because rdev0 and rdev1 has badblocks.

So, perhaps just abort the reshape will make more sense to me, because
user will lost more data if so.

Thanks,
Kuai

>   
>   	/* Now we check to see if any write operations have recently
> 

