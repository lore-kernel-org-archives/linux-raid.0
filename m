Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A57B35975;
	Thu, 21 Aug 2025 09:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755769336; cv=none; b=LRsnrhsQ/ZFrANvE3A5LegFiXUVnh1cWi7gf7euhk10zHdyPklGYlNpKCbe3SDK0Bebm/CAlOzctHFLZN5K2Iw3kiLpQX9+OCru/uIyX41PQEOamJSA95lZ/XhrCHxLa7qhdfavfAy3BECIzYDtT2QHdUafVXibbbCxfKgztK/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755769336; c=relaxed/simple;
	bh=nSeIorMmRmBVL1NRH30V5TAmMQCnj1rs/AYqG4xMiG4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=QH/OGVfnGrsBa20CdrMmZqxKT5+Z1pMzyxC1aG6sf9EzNp2a7OyYjM4ozUhO4TBj60qNTSTmBkAOxbwQaf85ckoIXptPGXHkSEan3A8yhYViOkuY8aOc9ZjRfHgY3+vGaHQWfH+89SLS2e+/p9ixc9XeQQYmhiuY4qpwvCmk8oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4c6yyp52x7zKHMvx;
	Thu, 21 Aug 2025 17:42:10 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 3068D1A1EB1;
	Thu, 21 Aug 2025 17:42:10 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgAHgxPw6aZoYbqxEQ--.6848S3;
	Thu, 21 Aug 2025 17:42:09 +0800 (CST)
Subject: Re: [PATCH] block: fix disordered IO in the case recursive split
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>,
 Yu Kuai <yukuai1@huaweicloud.com>
Cc: axboe@kernel.dk, neil@brown.name, akpm@linux-foundation.org,
 linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, colyli@kernel.org, xni@redhat.com,
 yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250821074707.2604640-1-yukuai1@huaweicloud.com>
 <aKbcM1XDEGeay6An@infradead.org>
 <54fc027f-f4dc-0412-0d6d-b44a3e644c39@huaweicloud.com>
 <aKbgqoF0UN4_FbXO@infradead.org>
 <7db2eb2c-9566-4d6b-9f82-a0f65110a807@suse.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <c145302a-175e-da38-2d28-f92dd285b819@huaweicloud.com>
Date: Thu, 21 Aug 2025 17:42:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <7db2eb2c-9566-4d6b-9f82-a0f65110a807@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHgxPw6aZoYbqxEQ--.6848S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar13XrykAF1kuFyUXw4kCrg_yoW8AF1fpr
	4vqF1jyrWUJrsYkFnrJw4jqa4rtr1UJ34Fyr1rX3W7X34UJrnFqr45WrWY9r98XF48Kr12
	yr48Jry5Zw1UtFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUZYFZUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/08/21 17:33, Hannes Reinecke 写道:
> On 8/21/25 11:02, Christoph Hellwig wrote:
>> On Thu, Aug 21, 2025 at 04:56:33PM +0800, Yu Kuai wrote:
>>> Can you give some examples as how to chain the right way?
>>
>> fs/xfs/xfs_bio_io.c: xfs_rw_bdev
>> fs/xfs/xfs_buf.c: xfs_buf_submit_bio
>> fs/xfs/xfs_log.c: xlog_write_iclog
>>
>>> BTW, for all
>>> the io split case, should this order be fixed? I feel we should, this
>>> disorder can happen on any stack case, where top max_sector is greater
>>> than stacked disk.
>>
>> Yes, I've been trying get Bart to fix this for a while instead of
>> putting in a workaround very similar to the one proposed here,
>> but so far nothing happened.
>>
>>
> This feels like a really stupid fix, but wouldn't that help?
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 023649fe2476..2b342bb59612 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5478,7 +5478,6 @@ static struct bio *chunk_aligned_read(struct mddev 
> *mddev, struct bio *raid_bio)
>                  split = bio_split(raid_bio, sectors, GFP_NOIO, 
> &conf->bio_split);
>                  bio_chain(split, raid_bio);
>                  submit_bio_noacct(raid_bio);
> -               raid_bio = split;
>          }
> 

I do not understand how can this help, do you miss that submit split
instead?

And with this change, this can help, however, I think we'll still submit
the last lba bio first, like bio_last -> bio0 -> bio1 ... where the
following is sequential.

BTW, this is not just a raid5 problem, this is also possible for
raid0/10 and all other recursive split case.

Thanks,
Kuai

> 
> Cheers,
> 
> Hannes

