Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E2817B43A
	for <linux-raid@vger.kernel.org>; Tue, 11 Jun 2024 11:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718107171; cv=none; b=uklC9k36Cn7NE7QQHkoKSloPrwjzUmPDHHV3WPZayW6R0EMSiLEuSEeqk/yIppq4MFbkCNsSwOJM7l0pVaty735paM73iQhWsuEfGh5RBGuCjuU+ixKzidfSyui4gzm1OKtiBT66K2quHLThySlbbNpYmqWrwDKBb/jkOdNYvt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718107171; c=relaxed/simple;
	bh=kYv0Y31lTvNJ0oJ3+q5r9HozbVXLevpnYyl4zGrce5Q=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=YMlIgVa+Knd93PeIsB4gf2QZ1BuwcopMnezYzwaRRYuBGSIxxxYHXOFxhnblcEn2sF2C5nT8F+q87Ednt8RBpuKNsF0FQ6XztEDTyEX5am65wCFlJg6Imq/fi+zjoNheuBeaVknf4NqGQBFN5oZ3345yCWi8iWcZ+JqlCr/RSdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Vz6fG0P8lz4f3jkB
	for <linux-raid@vger.kernel.org>; Tue, 11 Jun 2024 19:59:18 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 961881A0FCD
	for <linux-raid@vger.kernel.org>; Tue, 11 Jun 2024 19:59:24 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgBHZQ4YPGhmIAu_PA--.39626S3;
	Tue, 11 Jun 2024 19:59:22 +0800 (CST)
Subject: Re: [RFC V5] md/raid5: optimize Scattered Address Space and
 Thread-Level Parallelism to improve RAID5 performance
To: Shushu Yi <teddyxym@outlook.com>, linux-raid@vger.kernel.org
Cc: Shushu Yi <firnyee@gmail.com>, Song Liu <song@kernel.org>,
 hch@infradead.org, Paul Luse <paul.e.luse@intel.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <SJ0PR10MB574112619D4A62D4EBC891E9D8F92@SJ0PR10MB5741.namprd10.prod.outlook.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <db32af65-572c-0742-1080-19417790615b@huaweicloud.com>
Date: Tue, 11 Jun 2024 19:59:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <SJ0PR10MB574112619D4A62D4EBC891E9D8F92@SJ0PR10MB5741.namprd10.prod.outlook.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBHZQ4YPGhmIAu_PA--.39626S3
X-Coremail-Antispam: 1UD129KBjvJXoWxCw4fCrWUZr1DAw48tF4UXFb_yoW5Aw4xpr
	ZxJFWayr4kXr1xZw17Zw18WFyrW3saqrW3KrZxC34rurW5ZFyfurWIkrZ8tF9rGrn3uan2
	qF18uF1DuF1Y9rDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
	c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UWE__UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

I just take a quick look, a design problem below. There are some style
problems, however, we can work on that later.

ÔÚ 2024/06/06 0:53, Shushu Yi Ð´µÀ:
> Optimize scattered address space. Achieves significant improvements in
> both throughput and latency.
> 
> Maximize thread-level parallelism and reduce CPU suspension time caused
> by lock contention. Achieve increased overall storage throughput by
> 89.4% and decrease the 99.99th percentile I/O latency by 85.4% on a
> system with four PCIe 4.0 SSDs. (Set the iodepth to 32 and employ
> libaio. Configure the I/O size as 4 KB with sequential write and 16
> threads. In RAID5 consist of 2+1 1TB Samsung 980Pro SSDs, throughput
> went from 5218MB/s to 9884MB/s.)
> 
> Note: Publish this work as a paper and provide the URL
> (https://www.hotstorage.org/2022/camera-ready/hotstorage22-5/pdf/
> hotstorage22-5.pdf).
> 
> Co-developed-by: Yiming Xu <teddyxym@outlook.com>
> Signed-off-by: Yiming Xu <teddyxym@outlook.com>
> Signed-off-by: Shushu Yi <firnyee@gmail.com>
> Tested-by: Paul Luse <paul.e.luse@intel.com>
> ---
> V1 -> V2: Cleaned up coding style and divided into 2 patches (HemiRAID
> and ScalaRAID corresponding to the paper mentioned above). ScalaRAID
> equipped every counter with a counter lock and employ our D-Block.
> HemiRAID increased the number of stripe locks to 128

This is still just one patch.
> V2 -> V3: Adjusted the language used in the subject and changelog.
> Since patch 1/2 in V2 cannot be used independently and does not
> encompass all of our work, it has been merged into a single patch.
> V3 -> V4: Fixed incorrect sending address and changelog format.
> V4 -> V5: Resolved a adress conflict on main (commit
> f0e729af2eb6bee9eb58c4df1087f14ebaefe26b (HEAD -> md-6.10, tag:
> md-6.10-20240502, origin/md-6.10)).
> 
>   drivers/md/md-bitmap.c | 197 ++++++++++++++++++++++++++++++-----------
>   drivers/md/md-bitmap.h |  12 ++-
>   drivers/md/raid5.h     |   7 +-

So, you should split changes to md-bitmap and send a patch seperately,
and probably tests raid1/raid10 as well.
>   3 files changed, 155 insertions(+), 61 deletions(-)
> 
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
...

>   
> +	/* initialize bmc locks */
> +	num_bmclocks = DIV_ROUND_UP(chunks, BITMAP_COUNTER_LOCK_RATIO);
> +
> +	new_bmclocks = kvcalloc(num_bmclocks, sizeof(*new_bmclocks), GFP_KERNEL);

Can you give a calculation result for additional memory overhead here,
especially when CONFIG_DEBUG_LOCK_ALLOC and CONFIG_DEBUG_SPINLOCK are
enabled/disabled, and mention that in commit message. The
BITMAP_COUNTER_LOCK_RATIO is set to 1, so I suspect this can be
acceptable. You probably must choose an acceptable value based on
chunks.

And please notice that if the above configs are disabled, spinlock
is 4 bytes, and multiple locks will be put in the same cacheline,
and this is meaningless because lock contention for these locks are
the same, due to false sharing.

Thanks,
Kuai

