Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F196073440;
	Tue, 13 Aug 2024 07:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723534442; cv=none; b=IWbyD71jURuyq/ppZEqGifGI/mbKMIFUApDnAdSZCxWGdpG6QEntcr8nhWmjKrYz1NMgrpEiljxOoyqTG2W+FQbFp/sqyUxsUJ4a9fO/8I526ZWRTS7tkrQPRAm8JuHNg6eaevtI5ehr49Enb0eHNUJrWu7L5S2tGpqDXfhZsPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723534442; c=relaxed/simple;
	bh=UBcpN/871lrqD8+vQDH3xAKr/yVFJeTgEcS6ucdR9Nc=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=eqLCM79j9vNjsqGhgUzw3BcyEKbVfMGyKgpNweDxtKJdZCep/n6Xd3VoF71IxuKHgebMeFehVZBB8XLYIkj6/3urA+oyeQ+F0XyD9r58uT7TYN+z0YV2nViNyuadfITJnl1qZME8HcuoLvSNgdLWz7slLWs6ZbejmA1wRXYQuNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Wjjmk0Wfrz4f3jM8;
	Tue, 13 Aug 2024 15:33:42 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B419A1A12CE;
	Tue, 13 Aug 2024 15:33:56 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgB37IJkDLtm8C4+Bg--.7844S3;
	Tue, 13 Aug 2024 15:33:56 +0800 (CST)
Subject: Re: [PATCH RFC -next 07/26] md/md-bitmap: merge md_bitmap_update_sb()
 into bitmap_operations
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
 Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240810020854.797814-1-yukuai1@huaweicloud.com>
 <20240810020854.797814-8-yukuai1@huaweicloud.com>
 <20240813091719.0000202a@linux.intel.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <84baf54c-338b-1822-c631-cf7d0da1f61a@huaweicloud.com>
Date: Tue, 13 Aug 2024 15:33:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240813091719.0000202a@linux.intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB37IJkDLtm8C4+Bg--.7844S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Gry5uFyDGr4rCF1fAry5urg_yoW7Xr1rpF
	WUJ3W5CF43tFWfXr17ZF929FyFva1ktr9xKFyfGa4rCFn0qrn3GF40gFn5twn8Ar13JFs8
	Aw15Jrs8GF1xZFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUQo7NUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/08/13 15:17, Mariusz Tkaczyk Ð´µÀ:
> On Sat, 10 Aug 2024 10:08:35 +0800
> Yu Kuai <yukuai1@huaweicloud.com> wrote:
> 
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> So that the implementation won't be exposed, and it'll be possible
>> to invent a new bitmap by replacing bitmap_operations.
> 
> Please update commit message.
> 
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> ---
>>   drivers/md/md-bitmap.c  | 15 ++++++++-------
>>   drivers/md/md-bitmap.h  | 11 ++++++++++-
>>   drivers/md/md-cluster.c |  3 ++-
>>   drivers/md/md.c         |  4 ++--
>>   4 files changed, 22 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
>> index 0ff733756043..b34f13aa2697 100644
>> --- a/drivers/md/md-bitmap.c
>> +++ b/drivers/md/md-bitmap.c
>> @@ -472,7 +472,7 @@ static void md_bitmap_wait_writes(struct bitmap *bitmap)
>>   
>>   
>>   /* update the event counter and sync the superblock to disk */
>> -void md_bitmap_update_sb(struct bitmap *bitmap)
>> +static void bitmap_update_sb(struct bitmap *bitmap)
>>   {
>>   	bitmap_super_t *sb;
>>   
>> @@ -510,7 +510,6 @@ void md_bitmap_update_sb(struct bitmap *bitmap)
>>   		write_sb_page(bitmap, bitmap->storage.sb_index,
>>   			      bitmap->storage.sb_page, 1);
>>   }
>> -EXPORT_SYMBOL(md_bitmap_update_sb);
>>   
>>   /* print out the bitmap file superblock */
>>   static void bitmap_print_sb(struct bitmap *bitmap)
>> @@ -893,7 +892,7 @@ static void md_bitmap_file_unmap(struct bitmap_storage
>> *store) static void md_bitmap_file_kick(struct bitmap *bitmap)
>>   {
>>   	if (!test_and_set_bit(BITMAP_STALE, &bitmap->flags)) {
>> -		md_bitmap_update_sb(bitmap);
>> +		bitmap_update_sb(bitmap);
>>   
>>   		if (bitmap->storage.file) {
>>   			pr_warn("%s: kicking failed bitmap file %pD4 from
>> array!\n", @@ -1796,7 +1795,7 @@ static void bitmap_flush(struct mddev *mddev)
>>   	md_bitmap_daemon_work(mddev);
>>   	if (mddev->bitmap_info.external)
>>   		md_super_wait(mddev);
>> -	md_bitmap_update_sb(bitmap);
>> +	bitmap_update_sb(bitmap);
>>   }
>>   
>>   /*
>> @@ -2014,7 +2013,7 @@ static int bitmap_load(struct mddev *mddev)
>>   	mddev_set_timeout(mddev, mddev->bitmap_info.daemon_sleep, true);
>>   	md_wakeup_thread(mddev->thread);
>>   
>> -	md_bitmap_update_sb(bitmap);
>> +	bitmap_update_sb(bitmap);
> 
> You changed function name here and it is harmful for git blame. What is the
> reason behind that? it must be described in commit message to help Song making
> the decision if it is worthy merging or not.
> 
>>   
>>   	if (test_bit(BITMAP_WRITE_ERROR, &bitmap->flags))
>>   		err = -EIO;
>> @@ -2075,7 +2074,7 @@ int md_bitmap_copy_from_slot(struct mddev *mddev, int
>> slot, }
>>   
>>   	if (clear_bits) {
>> -		md_bitmap_update_sb(bitmap);
>> +		bitmap_update_sb(bitmap);
>>   		/* BITMAP_PAGE_PENDING is set, but bitmap_unplug needs
>>   		 * BITMAP_PAGE_DIRTY or _NEEDWRITE to write ... */
>>   		for (i = 0; i < bitmap->storage.file_pages; i++)
>> @@ -2568,7 +2567,7 @@ backlog_store(struct mddev *mddev, const char *buf,
>> size_t len) mddev_create_serial_pool(mddev, rdev);
>>   	}
>>   	if (old_mwb != backlog)
>> -		md_bitmap_update_sb(mddev->bitmap);
>> +		bitmap_update_sb(mddev->bitmap);
>>   
>>   	mddev_unlock_and_resume(mddev);
>>   	return len;
>> @@ -2712,6 +2711,8 @@ static struct bitmap_operations bitmap_ops = {
>>   	.load			= bitmap_load,
>>   	.destroy		= bitmap_destroy,
>>   	.flush			= bitmap_flush,
>> +
>> +	.update_sb		= bitmap_update_sb,
>>   };
>>   
>>   void mddev_set_bitmap_ops(struct mddev *mddev)
>> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
>> index 935c5dc45b89..29c217630ae5 100644
>> --- a/drivers/md/md-bitmap.h
>> +++ b/drivers/md/md-bitmap.h
>> @@ -239,6 +239,8 @@ struct bitmap_operations {
>>   	int (*load)(struct mddev *mddev);
>>   	void (*destroy)(struct mddev *mddev);
>>   	void (*flush)(struct mddev *mddev);
>> +
>> +	void (*update_sb)(struct bitmap *bitmap);
>>   };
>>   
>>   /* the bitmap API */
>> @@ -277,7 +279,14 @@ static inline void md_bitmap_flush(struct mddev *mddev)
>>   	mddev->bitmap_ops->flush(mddev);
>>   }
>>   
>> -void md_bitmap_update_sb(struct bitmap *bitmap);
>> +static inline void md_bitmap_update_sb(struct mddev *mddev)
>> +{
>> +	if (!mddev->bitmap || !mddev->bitmap_ops->update_sb)
>> +		return;
> 
> I would like to avoid dead code here. !mddev->bitmap is probably not an option
> an this point in code. !mddev->bitmap_ops->update_sb i not an option because we
> have only one bitmap op. Do I miss something?

mddev->bitmap will be an option for the array with bitmap=none. However,
!mddev->bitmap_ops->update_sb is indeed not an option.

> 
> I will stop here for today now to give you a chance to reply, to be sure that
> we are on same page. I see that my comments are similar so it may not be worthy
> to go one by one and repeat same comment. I may miss something important.

Yes, but for the similiar commit message, I'm not sure how to improve
this for now. We don't want a large patch to merge all the ops at once.

Thanks,
Kuai

> 
> Thanks
> Mariusz
> 
> 
> .
> 

