Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3374D24677C;
	Mon, 18 Aug 2025 06:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755497654; cv=none; b=r6n7CQ66Rk+xJbcL3XxrcpSkNVMXezo2GXF61N3GhcTN0HCaOv2CGNio8eA2Aw29RC6JiOj8LqjzC+06xk/1lGTSaysu94Ab+L6PKRkGfTbF22QTlHRpzUUvQG+/8PnN0yBpXUmnKGOdHxJ7c4y4xkyRg7eFK8MKPYLvKXZgX4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755497654; c=relaxed/simple;
	bh=4a6eaetvk6wzx/lvnxILyXpvYOH2nKUuPxZhM71N4Fk=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=oD+5+NYphtHiTCy/SShwi5FDWKvLp9PntqcfRHj9H0/R8dO1PwVtn1bUp5FupNCO+i6jDq38ZFyYBSNOn9hFIyJ/oaz9qMbndnQUPfBrNTCaBugQBDCftnfEasrPGuvDGQlwIzL0f1e/2yKZZfhqmdzAAkN/lorz2GDY81vVsBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4c52VB0VBFzYQtrj;
	Mon, 18 Aug 2025 14:14:10 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A13CC1A07BB;
	Mon, 18 Aug 2025 14:14:08 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgBXIBGuxKJoonNLEA--.47746S3;
	Mon, 18 Aug 2025 14:14:08 +0800 (CST)
Subject: Re: [PATCH 1/2] block: ignore underlying non-stack devices io_opt
To: Christoph Hellwig <hch@infradead.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, colyli@kernel.org,
 linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250817152645.7115-1-colyli@kernel.org>
 <756b587d-2a5c-4749-a03b-cfc786740684@kernel.org>
 <ffa13f8c-5dfe-20d4-f67d-e3ccd0c70b86@huaweicloud.com>
 <fd5c1916-936b-4253-a7b8-ba53591653f3@kernel.org>
 <4aa48545-7398-c346-5968-5d08f29748c4@huaweicloud.com>
 <aKLAhOxV1KViVw7w@infradead.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <de4fd44c-f8be-e787-27f4-9e9e09921e12@huaweicloud.com>
Date: Mon, 18 Aug 2025 14:14:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <aKLAhOxV1KViVw7w@infradead.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXIBGuxKJoonNLEA--.47746S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Wry3uF1xur15CrW8Xr1xGrg_yoW8uw4rpF
	95WFZrtanIyF40vrWkZ3W3GwsY9398KFWIkr1FywnYk34j9r12kry7tFZ8XF93Krs8u3y2
	q348tFZxuFWrua7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUf8nOUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/08/18 13:56, Christoph Hellwig Ð´µÀ:
> On Mon, Aug 18, 2025 at 11:40:54AM +0800, Yu Kuai wrote:
>> Then code will be much complex insdie md code, and we'll have to
>> reimplement the stack limits logical with the consideration if each rdev
>> is already a stacked rdev. I really do not like this ...
> 
> You don't.  You get the stacked value as input and then simply decide
> if you want to take it or override it.  The easiest way to do the
> latter is to just stash it away in a local variable before calling
> queue_limits_stack_bdev and then reapplying it afterwards.
> 
>> And in theroy, we can't handle this case just in md code:
>>
>> scsi disk -> mdarray -> device mapper/loop/nbd ... -> mdarray
> 
> I don't see how the code in this series could handle that either.
> 
> .
> 

Please take a look at the first patch, nothing special, the new flag
will be passed to the top device.

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 07874e9b609f..46ee538b2be9 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -782,6 +782,7 @@ int blk_stack_limits(struct queue_limits *t, struct 
queue_limits *b,
  		t->features &= ~BLK_FEAT_POLL;

  	t->flags |= (b->flags & BLK_FLAG_MISALIGNED);
+	t->flags |= (b->flags & BLK_FLAG_STACK_IO_OPT);

  	t->max_sectors = min_not_zero(t->max_sectors, b->max_sectors);
  	t->max_user_sectors = min_not_zero(t->max_user_sectors,
@@ -839,7 +840,10 @@ int blk_stack_limits(struct queue_limits *t, struct 
queue_limits *b,
  				     b->physical_block_size);

  	t->io_min = max(t->io_min, b->io_min);
-	t->io_opt = lcm_not_zero(t->io_opt, b->io_opt);
+	if (!t->io_opt || !(t->flags & BLK_FLAG_STACK_IO_OPT) ||
+	    (b->flags & BLK_FLAG_STACK_IO_OPT))
+		t->io_opt = lcm_not_zero(t->io_opt, b->io_opt);
+

For the case scsi->mdraid:

t->io_opt is set, the flag is set for t and not for b, hence
lcm_not_zero() is skipped

For the case mdraid->dm/loop/nbd ... -> mdarray:

the flag will be set for both t and b, lcm_not_zero() will not be
skipped.

Thanks,
Kuai
  	t->dma_alignment = max(t->dma_alignment, b->dma_alignment);

  	/* Set non-power-of-2 compatible chunk_sectors boundary */

