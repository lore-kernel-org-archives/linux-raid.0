Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18CA4963A;
	Tue, 13 Aug 2024 07:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723534266; cv=none; b=WiKbvqQ0tLI8lBCQOxCh4I4BspakHH5LCHztdbhika9t1H/NsJVz215VSmugUYSL+0Z5ZNLkvO8l+qR47edKyrzlikRY6au2MvVEWf/FixIaVH5/Iur2UCl2ZTKGzFHn60wSBY2ptHuI1wJDlyjj+zp5s9y3sPXFLKCHkb9yKsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723534266; c=relaxed/simple;
	bh=6DsmWakHreIAbC56i4NT9jkuhHsis9SKdMYocwe4eYc=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=TIAbIRt5hJofTwbSZUB6j5bgkXdbca9JoAsyGhnK2jeBfZ6E6SPAm6HFxr+EUI1gd9ZNyPXS95CqSv8qc5L4+aLgjaSIFlbsAKD7TMbJa9kiTwYIZB3cIKjnRhl3/yU0cPAKcwXKdfqLRuDzOZVwJ29Ma3vUh/rebwSR95O5fvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WjjjJ5225z4f3jLc;
	Tue, 13 Aug 2024 15:30:44 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 5A1A81A0568;
	Tue, 13 Aug 2024 15:30:59 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgBXzIKxC7tmYfw9Bg--.41817S3;
	Tue, 13 Aug 2024 15:30:59 +0800 (CST)
Subject: Re: [PATCH RFC -next 03/26] md/md-bitmap: merge md_bitmap_load() into
 bitmap_operations
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
 Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240810020854.797814-1-yukuai1@huaweicloud.com>
 <20240810020854.797814-4-yukuai1@huaweicloud.com>
 <20240813090726.000032cd@linux.intel.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <8f561148-761a-a487-5dc2-1567588c49b0@huaweicloud.com>
Date: Tue, 13 Aug 2024 15:30:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240813090726.000032cd@linux.intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXzIKxC7tmYfw9Bg--.41817S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWw47AFy3AFWktw1fur4DArb_yoW5uFy7pF
	Z7ta45Cw45JrWagF12vFyv93WFqw1ktr9xKrWxGw1fuF9rXFnxGF4rWF4Ykw1rGF13GFsI
	vw15tr1rur1xXFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
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

ÔÚ 2024/08/13 15:07, Mariusz Tkaczyk Ð´µÀ:
> On Sat, 10 Aug 2024 10:08:31 +0800
> Yu Kuai <yukuai1@huaweicloud.com> wrote:
> 
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> So that the implementation won't be exposed, and it'll be possible
>> to invent a new bitmap by replacing bitmap_operations.
> 
> I don't like repeating same commit message for few patches.
> 
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> ---
>>   drivers/md/md-bitmap.c |  6 +++---
>>   drivers/md/md-bitmap.h | 10 +++++++++-
>>   2 files changed, 12 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
>> index d731f7d4bbbb..9a9f0fe3ebd0 100644
>> --- a/drivers/md/md-bitmap.c
>> +++ b/drivers/md/md-bitmap.c
>> @@ -1965,7 +1965,7 @@ static struct bitmap *bitmap_create(struct mddev
>> *mddev, int slot) return ERR_PTR(err);
>>   }
>>   
>> -int md_bitmap_load(struct mddev *mddev)
>> +static int bitmap_load(struct mddev *mddev)
>>   {
>>   	int err = 0;
>>   	sector_t start = 0;
>> @@ -2021,7 +2021,6 @@ int md_bitmap_load(struct mddev *mddev)
>>   out:
>>   	return err;
>>   }
>> -EXPORT_SYMBOL_GPL(md_bitmap_load);
>>   
>>   /* caller need to free returned bitmap with md_bitmap_free() */
>>   struct bitmap *get_bitmap_from_slot(struct mddev *mddev, int slot)
>> @@ -2411,7 +2410,7 @@ location_store(struct mddev *mddev, const char *buf,
>> size_t len) }
>>   
>>   			mddev->bitmap = bitmap;
>> -			rv = md_bitmap_load(mddev);
>> +			rv = bitmap_load(mddev);
>>   			if (rv) {
>>   				mddev->bitmap_info.offset = 0;
>>   				md_bitmap_destroy(mddev);
>> @@ -2710,6 +2709,7 @@ const struct attribute_group md_bitmap_group = {
>>   
>>   static struct bitmap_operations bitmap_ops = {
>>   	.create			= bitmap_create,
>> +	.load			= bitmap_load,
>>   };
>>   
>>   void mddev_set_bitmap_ops(struct mddev *mddev)
>> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
>> index a7cbf0c692fc..de7fbe5903dd 100644
>> --- a/drivers/md/md-bitmap.h
>> +++ b/drivers/md/md-bitmap.h
>> @@ -236,6 +236,7 @@ struct bitmap {
>>   
>>   struct bitmap_operations {
>>   	struct bitmap* (*create)(struct mddev *mddev, int slot);
>> +	int (*load)(struct mddev *mddev);
>>   };
>>   
>>   /* the bitmap API */
>> @@ -250,7 +251,14 @@ static inline struct bitmap *md_bitmap_create(struct
>> mddev *mddev, int slot) return mddev->bitmap_ops->create(mddev, slot);
>>   }
>>   
>> -int md_bitmap_load(struct mddev *mddev);
>> +static inline int md_bitmap_load(struct mddev *mddev)
>> +{
>> +	if (!mddev->bitmap_ops->load)
>> +		return -EOPNOTSUPP;
>> +
>> +	return mddev->bitmap_ops->load(mddev);
>> +}
> 
> At this point we have only on bitmpa op (at that probably won't change), so if
> we we have bitmap_ops assigned (mddev->bitmap_ops != NULL) then ->load is must
> have, hence I don't see a need for this wrapper.

Yes, we must define the load op otherwise the bitmap_ops is meaningless.

> 
> you probably made this to avoid changes across code. If yes, please mention it
> in commit message but I still would prefer to replace them all by calls to
> mddev->bitmap_ops->load().

I'll replace to use mddev->bitmap_ops->load() directly, and other
places. And I'll keep this inline helper for some ops that is used for
md-cluster, because I'm not planning to support md-cluster for the new
bitmap first.

Thanks,
Kuai

> 
> Mariusz
> 
> 
> .
> 

