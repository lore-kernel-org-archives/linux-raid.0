Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D19C1FF1D1;
	Wed, 16 Jul 2025 09:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752658241; cv=none; b=dIwNIJcAH6zzrzQX5xmEs0OICX+gkz87JosuT/8xsByOyx3WRl36dDGogcZ+m/L2WCW1rCuQMD/0v706TUk2U8uExOcEl5jI9rTL6CfP5vLVzgagS03vUDmxj2nFB9y0WRBNWJYapAX0S2aIQOpgUtQTXxXMHaf5hDtbyahSAT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752658241; c=relaxed/simple;
	bh=HQX5vVvKOg++t/tKq595zg3QzRYd1IFoh8IT5DrOqWk=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=YZWIx2kqI2WdTV2omkBZh5mHJPhvns2/kOlXwPs9uM+Liq1K5+YzZqWgFAREE1WaS8hphbDn7DZVAiAEnX5MIojRJju75YwY915NSoqLwaGK1vWmQEuYQag1KzkpwzsqsKIc5s9L9T7hbXHWho9Xzpg8BqyCaPShZhgpzhL6z1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bhrQ43B3jzYQvW0;
	Wed, 16 Jul 2025 17:30:36 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 3307F1A19C2;
	Wed, 16 Jul 2025 17:30:35 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgD3chM3cXdonY7IAQ--.5121S3;
	Wed, 16 Jul 2025 17:30:32 +0800 (CST)
Subject: Re: [RFC PATCH] md: split bio by io_opt size in md_submit_bio()
To: Coly Li <colyli@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
 Xiao Ni <xni@redhat.com>, Hannes Reinecke <hare@suse.de>,
 Martin Wilck <mwilck@suse.com>, Christoph Hellwig <hch@lst.de>,
 Keith Busch <kbusch@kernel.org>, "yukuai (C)" <yukuai3@huawei.com>
References: <20250715180241.29731-1-colyli@kernel.org>
 <f158675c-7bbe-45d4-413b-3e984589d08f@huaweicloud.com>
 <5fgrmteq5ltqi4o6bvsohcc33u3jiblyqmqv7b3g7cwawofjdl@xk4nvl3w7ndr>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <e29d71ac-6744-41ad-d4ce-1d9eb2bfb439@huaweicloud.com>
Date: Wed, 16 Jul 2025 17:30:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <5fgrmteq5ltqi4o6bvsohcc33u3jiblyqmqv7b3g7cwawofjdl@xk4nvl3w7ndr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3chM3cXdonY7IAQ--.5121S3
X-Coremail-Antispam: 1UD129KBjvJXoWxtr1DXrWUCF47JFyfAr1fWFg_yoW3tw4Dpr
	WUWF9IyrWkJFnFkwnIq3W29FnYv3yrXry5AryfJ3yUCrn0gwnrKFWxWw1ruFy3Gr48C3yj
	vw40vFy3C3Z0yFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/07/16 16:50, Coly Li 写道:
> On Wed, Jul 16, 2025 at 02:58:13PM +0800, Yu Kuai wrote:
>> Hi,
>>
>> 在 2025/07/16 2:02, colyli@kernel.org 写道:
>>> From: Coly Li <colyli@kernel.org>
>>>
>>> Currently in md_submit_bio() the incoming request bio is split by
>>> bio_split_to_limits() which makes sure the bio won't exceed
>>> max_hw_sectors of a specific raid level before senting into its
>>> .make_request method.
>>>
>>> For raid level 4/5/6 such split method might be problematic and hurt
>>> large read/write perforamnce. Because limits.max_hw_sectors are not
>>> always aligned to limits.io_opt size, the split bio won't be full
>>> stripes covered on all data disks, and will introduce extra read-in I/O.
>>> Even the bio's bi_sector is aligned to limits.io_opt size and large
>>> enough, the resulted split bio is not size-friendly to corresponding
>>> raid456 level.
>>>
>>> This patch introduces bio_split_by_io_opt() to solve the above issue,
>>> 1, If the incoming bio is not limits.io_opt aligned, split the non-
>>>      aligned head part. Then the next one will be aligned.
>>> 2, If the imcoming bio is limits.io_opt aligned, and split is necessary,
>>>      then try to split a by multiple of limits.io_opt but not exceed
>>>      limits.max_hw_sectors.
>>>
>>> Then for large bio, the sligned split part will be full-stripes covered
>>> to all data disks, no extra read-in I/Os when rmw_level is 0. And for
>>> rmw_level > 0 condistions, the limits.io_opt aligned bios are welcomed
>>> for performace as well.
>>>
>>> This RFC patch only tests on 8 disks raid5 array with 64KiB chunk size.
>>> By this patch, 64KiB chunk size for a 8 disks raid5 array, sequential
>>> write performance increases from 900MiB/s to 1.1GiB/s by fio bs=10M.
>>> If fio bs=488K (exact limits.io_opt size) the peak sequential write
>>> throughput can reach 1.51GiB/s.
>>>
>>> (Resend to include Christoph and Keith in CC list.)
>>>
>>> Signed-off-by: Coly Li <colyli@kernel.org>
>>> Cc: Yu Kuai <yukuai3@huawei.com>
>>> Cc: Xiao Ni <xni@redhat.com>
>>> Cc: Hannes Reinecke <hare@suse.de>
>>> Cc: Martin Wilck <mwilck@suse.com>
>>> Cc: Christoph Hellwig <hch@lst.de>
>>> Cc: Keith Busch <kbusch@kernel.org>
>>> ---
>>>    drivers/md/md.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++-
>>>    1 file changed, 62 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>> index 0f03b21e66e4..363cff633af3 100644
>>> --- a/drivers/md/md.c
>>> +++ b/drivers/md/md.c
>>> @@ -426,6 +426,67 @@ bool md_handle_request(struct mddev *mddev, struct bio *bio)
>>>    }
>>>    EXPORT_SYMBOL(md_handle_request);
>>> +static struct bio *bio_split_by_io_opt(struct bio *bio)
>>> +{
>>> +	sector_t io_opt_sectors, sectors, n;
>>> +	struct queue_limits lim;
>>> +	struct mddev *mddev;
>>> +	struct bio *split;
>>> +	int level;
>>> +
>>> +	mddev = bio->bi_bdev->bd_disk->private_data;
>>> +	level = mddev->level;
>>> +	if (level == 1 || level == 10 || level == 0 || level == LEVEL_LINEAR)
>>> +		return bio_split_to_limits(bio);
>>
>> There is another patch that provide a helper raid_is_456()
>> https://lore.kernel.org/all/20250707165202.11073-3-yukuai@kernel.org/
>>
>> You might want to use it here.
> 
> Copied, I will use raid_is_456() after it gets merged.
> 
>>> +
>>> +	lim = mddev->gendisk->queue->limits;
>>> +	io_opt_sectors = min3(bio_sectors(bio), lim.io_opt >> SECTOR_SHIFT,
>>> +			      lim.max_hw_sectors);
>>
>> You might want to use max_sectors here, to honor user setting.
>>
>> And max_hw_sectors is just for normal read and write, for other IO like
>> discard, atomic write, write zero, the limit is different.
>>
> 
> Yeah, this is a reason why I want your comments :-) Originally I want to
> change bio_split_to_limits(), but the raid5 logic cannot be accessed
> there. If I write a clone of bio_split_to_limits(), it seems too heavy
> and unncessary.
> 
> How about only handle read/write bio here, and let bio_split_to_limits()
> to do the rested, like,
> 
> 	level = mddev->level;
> 	if (level == 1 || level == 10 || level == 0 || level == LEVEL_LINEAR ||
> 	    (bio_op(bio) != REQ_OP_READ && bio_op(bio) != REQ_OP_WRITE))
> 		return bio_split_to_limits(bio);
> 
> 
>>> +
>>> +	/* No need to split */
>>> +	if (bio_sectors(bio) == io_opt_sectors)
>>> +		return bio;
>>> +
>>
>> If the bio happend to accross two io_opt, do you think it's better to
>> split it here? For example:
>>
> 
> I assume raid5 code will handle this, the pages of this bio will belong
> to different stripe pages belong to different chunks. So no need to
> split here. For such condition, it is same handling process as calling
> bio_split_to_limits().
> 
>> io_opt is 64k(chunk size) * 7 = 448k, issue an IO start from 444k with
>> len = 8k. raid5 will have to use 2 stripes to handle such IO.
>>
> 
> Yes, I assume although this bio is not split, raid5 will have different
> cloned bio to map different stripe pages in __add_stripe_bio().
> 
> And because they belong to difference chunks, extra read-in for XOR (when
> rmw_level == 0) cannot be avoided.
>   
>>> +	n = bio->bi_iter.bi_sector;
>>> +	sectors = do_div(n, io_opt_sectors);
>>> +	/* Aligned to io_opt size and no need to split for radi456 */
>>> +	if (!sectors && (bio_sectors(bio) <=  lim.max_hw_sectors))
>>> +		return bio;
>>
>> I'm confused here, do_div doesn't mean aligned, should bio_offset() be
>> taken into consideration? For example, issue an IO start from 4k with
>> len = 448 * 2 k, if I read the code correctly, the result is:
>>
>> 4 + 896 -> 4 + 896 (not split if within max_sectors)
>>
>> What we really expect is:
>>
>> 4 + 896 -> 4 + 444, 448 + 448, 892 + 4
> 
> Yes you are right. And I do this on purpose, becasue the size of bio
> is small (less then max_hw_sectors). Even split the bio as you exampled,
> the full-stripes-write in middle doesn't help performance because the
> extra read-in will happen for head and tail part when rmw_level == 0.
> 
> For small bio (size < io_opt x 2 in this case), there is almost no
> performance difference. The performance loss of incorrect bio split will
> show up when the bio is large enough and many split bios in middle are
> not full-stripes covered.
> 
> For bio size < max_hw_sectors, just let raid5 handle it as what it does.

I'm still a bit confused :( I do understand that in the above case that
IO size < max_sectors, raid5 can handle it and there is not much
difference, what I don't understand is why not aligned to io_opt, for
example, in the above case if I increase io size to 448 *n, I would
expect the result as following:(assume max_sectors = 1M)

4 + 444, 448 + 448*2, 448*3 + 448*2, ..., 448*n + 4;

Other than the head and tail, all splited bio in the middle will end up
with full stripes.

And in this patch, becasue do_div can pass, then splited bio will end up
like:

4 + 448*2, 4+448*2 + 448*2, ...

And each bio will not end up with full stripes, I don't get it how this
behaviour have any difference without this patch, raid5 will have to try
fill in stripes with different bio.

Thanks,
Kuai

>>> +
>>> +	if (sectors) {
>>> +		/**
>>> +		 * Not aligned to io_opt, split
>>> +		 * non-aligned head part.
>>> +		 */
>>> +		sectors = io_opt_sectors - sectors;
>>> +	} else {
>>> +		/**
>>> +		 * Aligned to io_opt, split to the largest multiple
>>> +		 * of io_opt within max_hw_sectors, to make full
>>> +		 * stripe write/read for underlying raid456 levels.
>>> +		 */
>>> +		n = lim.max_hw_sectors;
>>> +		do_div(n, io_opt_sectors);
>>> +		sectors = n * io_opt_sectors;
>>
>> roundown() ?
> 
> Yes, of course :-)
> 
> 
>>> +	}
>>> +
>>> +	/* Almost won't happen */
>>> +	if (unlikely(sectors >= bio_sectors(bio))) {
>>> +		pr_warn("%s raid level %d: sectors %llu >= bio_sectors %u, not split\n",
>>> +			__func__, level, sectors, bio_sectors(bio));
>>> +		return bio;
>>> +	}
>>> +
>>> +	split = bio_split(bio, sectors, GFP_NOIO,
>>> +			  &bio->bi_bdev->bd_disk->bio_split);
>>> +	if (!split)
>>> +		return bio;
>>> +	split->bi_opf |= REQ_NOMERGE;
>>> +	bio_chain(split, bio);
>>> +	submit_bio_noacct(bio);
>>> +	return split;
>>> +}
>>> +
>>>    static void md_submit_bio(struct bio *bio)
>>>    {
>>>    	const int rw = bio_data_dir(bio);
>>> @@ -441,7 +502,7 @@ static void md_submit_bio(struct bio *bio)
>>>    		return;
>>>    	}
>>> -	bio = bio_split_to_limits(bio);
>>> +	bio = bio_split_by_io_opt(bio);
>>>    	if (!bio)
>>>    		return;
>>>
>>
> 
> Thanks for the review.
> 
> Coly Li
> 
> .
> 

