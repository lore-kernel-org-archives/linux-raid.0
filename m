Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFD84CF474
	for <linux-raid@vger.kernel.org>; Sat, 17 Oct 2026 03:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792207683; cv=none; b=edJ+CVStIQ2pTtGSrRyxOas8m/gn6VveD5ZJ+ueDwMYPjQIPA9velWMBASJ2ckBNWqinpfFCh9TRF+F+8M/9lx/9Rq2LMFWd+saItLDM1liB4PYmdWxh6Zyrk2BEpJe/XA5qBByZAKelAb8BHdKG7bqMA0QEIb9G41FT2ciqtP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792207683; c=relaxed/simple;
	bh=rDEY5FeElvmR472BvB13V/iJTQ+xkKqjrmGLTIBwXoQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N0qyJfOGxk8VZ0DlHxs5KgxKlO+FXVmRoFG67kEajUDx3tZOYydQGhJMjwsoDRUOzdFNcBLRlzLamQ0lEQ4tTOxBOLdYHyRVn2yDAi71GiztOn7fuazFgl7YHyfnlfzznge8iS7EoYjLKv9g0xQ+yD0yVoT/K6D49aj0J740N48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4j66g63gQVzYQv0p
	for <linux-raid@vger.kernel.org>; Sat, 17 Oct 2026 11:26:58 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 0343340576
	for <linux-raid@vger.kernel.org>; Sat, 17 Oct 2026 11:27:56 +0800 (CST)
Received: from [10.174.178.164] (unknown [10.174.178.164])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgB3sO8669Jq6dv1Ag--.37358S3;
	Sat, 17 Oct 2026 11:27:55 +0800 (CST)
Message-ID: <77b7d816-61c2-4496-861d-7d1fa7cfd683@huaweicloud.com>
Date: Sat, 17 Oct 2026 11:27:53 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] md/raid0: reject a takeover whose zones cannot cover
 the array
To: sashiko-reviews@lists.linux.dev, Zizhi Wo <wozizhi@huaweicloud.com>,
 linux-raid@vger.kernel.org
Cc: yukuai@fygo.io, yangerkun <yangerkun@huawei.com>,
 "chengzhihao1@huawei.com" <chengzhihao1@huawei.com>
References: <20261017005802.2212102-1-wozizhi@huaweicloud.com>
 <20261017005802.2212102-2-wozizhi@huaweicloud.com>
 <sashiko-outbox-175120@kernel.org>
From: Zizhi Wo <wozizhi@huaweicloud.com>
In-Reply-To: <sashiko-outbox-175120@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3sO8669Jq6dv1Ag--.37358S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Gr45ZFyrCF1DurWfAF1DKFg_yoWxur47p3
	yxX3ZFgr4fJryfJw1qvrnru3ySyrWrGr4UtFn3Jw18WwnIkrWkKay5ZF45WayUC3s5Aw1U
	tw4UJrZrAF9YgFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkm14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_JF0_
	Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI
	42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYCJmUUUUU
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/



在 2026/10/17 9:26, sashiko-bot@kernel.org 写道:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] md/raid0: raid0_takeover_check() sums member sizes instead of checking zones
> - [Medium] md/raid0: raid0_takeover_check() counts inactive devices in coverage
> --
> 
> commit bf35a10fdad5f2b5f8c0ec6f68f21e7ed3e9a106
> Author: Zizhi Wo <wozizhi@huawei.com>
> 
> md/raid0: reject a takeover whose zones cannot cover the array
> 
> This patch adds raid0_takeover_check() to reject takeovers into raid0 when
> the sum of chunk-aligned member sizes is smaller than the capacity
> advertised by the gendisk.
> 
>> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
>> index 35e103f0c2c3e..fccc62a5feccd 100644
>> --- a/drivers/md/raid0.c
>> +++ b/drivers/md/raid0.c
>> @@ -643,6 +643,34 @@ static void raid0_error(struct mddev *mddev, struct md_rdev *rdev)
>>   	}
>>   }
>>   
>> +/*
>> + * Refuse a takeover whose strip zones cannot cover the capacity the gendisk
>> + * advertises: raid0 derives those zones from the sizes of its members, so
>> + * find_zone() cannot map I/O that falls beyond them.
>> + */
>> +static int raid0_takeover_check(struct mddev *mddev, int chunk)
>> +{
>> +	sector_t capacity = get_capacity(mddev->gendisk);
>> +	sector_t coverage = 0;
>> +	struct md_rdev *rdev;
>> +
>> +	rdev_for_each(rdev, mddev) {
>> +		sector_t sectors = rdev->sectors;
>> +
>> +		sector_div(sectors, chunk);
>> +		coverage += sectors * chunk;
>> +	}
> 
> [Severity: Medium]
> Does rdev_for_each() in raid0_takeover_check() also count faulty or spare
> devices that are still attached to mddev->disks with rdev->raid_disk < 0?
> 
> When a mirror drive fails in raid1 or raid10, remove_and_add_spares() ->
> hot_remove_disk() sets rdev->raid_disk = -1, but the rdev remains in
> mddev->disks until unbound (as do spares).
> 
> If the active member in a degraded raid1 or raid10 array was imported
> without metadata (rdev->sectors == 0) while a failed or spare rdev in
> mddev->disks has rdev->sectors >= capacity, raid0_takeover_check() will
> count the inactive rdev's sectors and return 0.
> 
> Then raid0_takeover_raid1() and raid0_takeover_raid10() will mutate live
> mddev state (such as mddev->chunk_sectors, mddev->degraded,
> mddev->resync_offset, and mddev->flags) before create_strip_zones() fails,
> and level_store() in drivers/md/md.c does not restore those fields on
> error.
> 
> Should raid0_takeover_check() skip devices with rdev->raid_disk < 0?

Yes, rdev_for_each() walks every device on mddev->disks including spare
rdevs that left there with raid_disks < 0.

Although create_strip_zones() will eventually reject sunch as set(e.g. j
< 0 for raid45), skipping them in raid0_takeover_check makes the
semantics more explicit: the coverage should only be computed over
devices that can actually become raid0 members.

I will send a v2 with this change.

> 
>> +
>> +	if (coverage < capacity) {
>> +		pr_warn("md/raid0:%s: refusing takeover, zones cover only %llu of %llu sectors\n",
>> +			mdname(mddev), (unsigned long long)coverage,
>> +			(unsigned long long)capacity);
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>   static void *raid0_takeover_raid45(struct mddev *mddev)
>>   {
>>   	struct md_rdev *rdev;
>> @@ -665,6 +693,9 @@ static void *raid0_takeover_raid45(struct mddev *mddev)
>>   		rdev->sectors = mddev->dev_sectors;
>>   	}
>>   
>> +	if (raid0_takeover_check(mddev, mddev->chunk_sectors))
>> +		return ERR_PTR(-EINVAL);
>> +
>>   	/* Set new parameters */
>>   	mddev->new_level = 0;
>>   	mddev->new_layout = 0;
>> @@ -707,6 +738,9 @@ static void *raid0_takeover_raid10(struct mddev *mddev)
>>   		return ERR_PTR(-EINVAL);
>>   	}
>>   
>> +	if (raid0_takeover_check(mddev, mddev->chunk_sectors))
>> +		return ERR_PTR(-EINVAL);
> 
> [Severity: High]
> Can a larger member mask a zero-sized or undersized member during a
> raid10 -> raid0 takeover when raid0_takeover_check() only checks the sum
> of rdev->sectors?
> 
> Unlike raid0_takeover_raid45(), which assigns rdev->sectors =
> mddev->dev_sectors for each device, raid0_takeover_raid10() leaves each
> member's rdev->sectors unchanged.
> 
> Consider a 4-disk degraded raid10 (near=2) array with 2 active disks where
> one active member was imported without metadata (rdev2->sectors == 0) and
> the other active member has rdev0->sectors >= capacity (2 * dev_sectors).
> raid0_takeover_check() sums rdev->sectors across members, sees
> coverage >= capacity, and succeeds.
> 
> create_strip_zones() then builds two zones:
> 
> drivers/md/raid0.c:create_strip_zones() {
> 	...
> 	zone->nb_dev = cnt;
> 	zone->zone_end = smallest->sectors * cnt;
> 	...
> }
> 
> Here strip_zone[0] gets nb_dev = 2, smallest = rdev2 (0), and
> zone_end = 0, while strip_zone[1] gets dev_start = 0, nb_dev = 1
> (containing only rdev0), and zone_end = capacity. Because
> strip_zone[1].nb_dev == 1, create_strip_zones() succeeds even with
> default_layout == 0.
> 
> On subsequent I/O, find_zone() checks sector < z[i].zone_end, so
> strip_zone[0] (with zone_end == 0) is skipped completely and all array I/O
> is mapped linearly onto rdev0 alone in strip_zone[1], dropping rdev2 from
> the stripe layout and reading/writing past mddev->dev_sectors on rdev0.
> 

In this example, coverage >= capacity, so no BUG() can happen; the IO
going to rdev0 is a degenerate layout, not an OOB access as it stays
within rdev0->sectors. Isn't this in line with expectations?

> Similarly, if there are 3 or more active disks with mismatched
> rdev->sectors whose sum is >= capacity, raid0_takeover_check() succeeds
> and raid0_takeover_raid10() sets mddev->degraded = 0,
> mddev->resync_offset = MaxSector, and clears UNSUPPORTED_MDDEV_FLAGS
> before create_strip_zones() fails with -EOPNOTSUPP, leaving the raid10
> array with corrupted state.
> 

This is the pre-exiting issue as every failure of create_strip_zones()
after those fields are set leaves the same residue, and level_store()
never rolls back.

Thanks,
Zizhi Wo

> Should raid0 takeovers require every active member to have enough sectors
> (e.g., checking each active member against mddev->dev_sectors, or checking
> that a single uniform zone covers capacity)?
> 
> [ ... ]
> 
>>
>>
>>
> 
> 完美！ (Note: remove this, only plain text ending with a blank line). Let's make sure the output ends cleanly after the last line with a blank line.
> Wait—I accidentally wrote "完美！" in the output! Let me not do that!
> Wait: I am still in the response generation! Let me check if I can avoid that. Oh, I already emitted it in the response text!
> Wait—no, I haven't finished generating, wait: what is above is already in the output stream!
> Let me stop immediately without adding anything else.Placing a newline.
>   Let me just end right here.
> 

