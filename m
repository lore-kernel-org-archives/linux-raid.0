Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C8D1D12FF;
	Sat, 31 Aug 2024 01:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725066807; cv=none; b=o7M06s5Cl82E0LGaqe0kpAnwUAp+abzCAmp04UgeK0+KdTK1185Dp5Revvl8FfNSq2h2SwyejE8DGliAUpHhYiU3NinwgwsVZTAqVlcTa3lka/KHwiquzIR3VcqOa1hIvmYBGgFp2eG97VS52IrEMKaXc2ansB2GsAKoztDrF7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725066807; c=relaxed/simple;
	bh=hTaqNnY/k0MH65E7HCPHNjhF7wH80l4GfI57DHlvTh4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=JGBvjhSahjwi0f5Nn4mu/BSbwz+REU9PeBPhqInC8oGJNwCjS3C5zYGtWv4h3F7wocJm6FL8xZpu4D8INHnSvwsiJH00zL/SB4XOqUI3FvZJhH4TzFLv+3Gm3+ONAKJC8u8+uk3cSV8s3jbXkuOOyUM9mXm8TaPx29Tx69drwEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WwcTG0Tqbz4f3kvq;
	Sat, 31 Aug 2024 09:13:06 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A809A1A0568;
	Sat, 31 Aug 2024 09:13:21 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgAXPoQvbtJmk8zEDA--.20351S3;
	Sat, 31 Aug 2024 09:13:21 +0800 (CST)
Subject: Re: [PATCH md-6.12 4/7] md/raid1: factor out helper to handle blocked
 rdev from raid1_write_request()
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
 Yu Kuai <yukuai1@huaweicloud.com>
Cc: mariusz.tkaczyk@intel.com, song@kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240830072721.2112006-1-yukuai1@huaweicloud.com>
 <20240830072721.2112006-5-yukuai1@huaweicloud.com>
 <20240830130645.000076c6@linux.intel.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <3de92a0d-1650-ec6b-3a5a-d447682d1b9e@huaweicloud.com>
Date: Sat, 31 Aug 2024 09:13:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240830130645.000076c6@linux.intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXPoQvbtJmk8zEDA--.20351S3
X-Coremail-Antispam: 1UD129KBjvJXoW7CF47WF4DAw47CF4DAFy3CFg_yoW8Zr4fpw
	4fGFW3Ar48ury3A3ZIqFyUWFyFqw10qFW8Aryft3WxXrZrZryrGayrtryrWr95ArWayryY
	vF1UWrZrC3WI9FDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUbGQ6JUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/08/30 19:06, Mariusz Tkaczyk Ð´µÀ:
> On Fri, 30 Aug 2024 15:27:18 +0800
> Yu Kuai <yukuai1@huaweicloud.com> wrote:
> 
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> Currently raid1 is preparing IO for underlying disks while checking if
>> any disk is blocked, if so allocated resources must be released, then
>> waiting for rdev to be unblocked and try to prepare IO again.
>>
>> Make code cleaner by checking blocked rdev first, it doesn't matter if
>> rdev is blocked while issuing this IO.
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> ---
>>   drivers/md/raid1.c | 84 ++++++++++++++++++++++++++--------------------
>>   1 file changed, 48 insertions(+), 36 deletions(-)
>>
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index f55c8e67d059..aa30c3240c85 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -1406,6 +1406,49 @@ static void raid1_read_request(struct mddev *mddev,
>> struct bio *bio, submit_bio_noacct(read_bio);
>>   }
>>   
>> +static bool wait_blocked_rdev(struct mddev *mddev, struct bio *bio)
>> +{
>> +	struct r1conf *conf = mddev->private;
>> +	int disks = conf->raid_disks * 2;
>> +	int i;
>> +
>> +retry:
>> +	for (i = 0; i < disks; i++) {
>> +		struct md_rdev *rdev = conf->mirrors[i].rdev;
>> +
>> +		if (!rdev)
>> +			continue;
>> +
>> +		if (test_bit(Blocked, &rdev->flags)) {
> Don't we need unlikely here?
> 
> 
>> +			if (bio->bi_opf & REQ_NOWAIT)
>> +				return false;
>> +
>> +			mddev_add_trace_msg(rdev->mddev, "raid1 wait rdev %d
>> blocked",
>> +					    rdev->raid_disk);
>> +			atomic_inc(&rdev->nr_pending);
> 
> 
> retry moves us before for (ugh, ugly) and "theoretically" we can back here
> with the same disk and increase nr_pending twice or more because rdve can become
> block again from different thread.

Rety is always after md_wait_for_blocked_rdev(), which decrease the
nr_pending.

Thanks,
Kuai

> 
> This is what I suspect but it could be wrong.
> 
> Mariusz
> 
> 
> 
> .
> 

