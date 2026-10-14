Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249BE368D47;
	Wed, 14 Oct 2026 06:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791959534; cv=none; b=rF2Dx8Hn+oIsYS53tUHMHZqllbBiWGdAIECyPf6TfjMb0Hq404Qx1UJ6bivwe9oXNV3+tHAPaR/Z7k5gTBe1BkCJaRQa80ZGmFeeOsEf1ZJLpwLo3iXrTP43UofAztpUM64zL4pJT8of1Oi6oHbKiA6xh2/9DXZJ3G8SF5FaIzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791959534; c=relaxed/simple;
	bh=M0CbVGu27IF62hJR158NCT+iCcmlZWlvdsXmCFU9ZBg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bXSsGJflSlFJ9X0TYKb7a+C/uzB5ACazzIM9faCNQoBLKbysxXP8LNO78dpkU/8tuLcMGP6iPpupkoKPYbcyVV77+1ukyfVYEV01+sHDXNvLKI8UgMmjeJsSLLLaY4VQJ+BLl44gDJIpLtonU8sv8EuVYpfqFtdFdnsksX1EuqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4j4Lv63sBhzYQtvr;
	Wed, 14 Oct 2026 14:31:14 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 11C9A40561;
	Wed, 14 Oct 2026 14:32:07 +0800 (CST)
Received: from [10.174.178.164] (unknown [10.174.178.164])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgB3tfTgIc9qqn2JAQ--.25361S3;
	Wed, 14 Oct 2026 14:32:02 +0800 (CST)
Message-ID: <b7fd32d5-ae6f-4eb4-b02f-ba27db86ab5d@huaweicloud.com>
Date: Wed, 14 Oct 2026 14:31:58 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/raid0: don't BUG() on a bio that lands off the end of
 the array
To: yukuai@fygo.io, Palla Raghunath <raghunathpalla.0209@gmail.com>,
 linux-kernel@vger.kernel.org
Cc: Shuah Khan <shuah@kernel.org>, Brigham Campbell <me@brighamcampbell.com>,
 linux-kernel-mentees@lists.linux.dev,
 syzbot+422b372cabfbaa528725@syzkaller.appspotmail.com,
 Song Liu <song@kernel.org>, Li Nan <magiclinan@didiglobal.com>,
 Xiao Ni <xiao@kernel.org>, NeilBrown <neil@brown.name>,
 "Trela, Maciej" <Maciej.Trela@intel.com>, linux-raid@vger.kernel.org,
 "chengzhihao1@huawei.com" <chengzhihao1@huawei.com>,
 yangerkun <yangerkun@huawei.com>
References: <20260923161729.122240-1-raghunathpalla.0209@gmail.com>
 <7f55f471-867b-47a9-8f02-f65adaf6cd29@fygo.io>
From: Zizhi Wo <wozizhi@huaweicloud.com>
In-Reply-To: <7f55f471-867b-47a9-8f02-f65adaf6cd29@fygo.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3tfTgIc9qqn2JAQ--.25361S3
X-Coremail-Antispam: 1UD129KBjvJXoW3JFyUCw43Xr4rCFy5ury8Xwb_yoWxCF4Up3
	y8Kaya9rWkGFWfZ3ZFva47Ga4rtryftrWUCF93J34rC3Z8Crn7tFyUKryYgFyUCryrCFyU
	t3WDWF9rCF98KrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
	ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1
	7KsUUUUUU==
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/



在 2026/10/6 1:22, yu kuai 写道:
> Hi,
> 
> 在 2026/9/24 0:17, Palla Raghunath 写道:
>> find_zone() looks for the strip zone holding a given sector and BUG()s if
>> it can't find one.  That is only a safe assumption while the capacity the
>> array advertises matches what the zones actually cover, and a personality
>> takeover can break exactly that.
>>
>> level_store() lets you switch a live array to a different personality.
>> The new ->run() recalculates mddev->array_sectors, but level_store() never
>> tells the gendisk about it - it is the one place in md that changes the
>> array size without a set_capacity_and_notify(), which do_md_run(),
>> array_size_store(), update_size(), md_reap_sync_thread() and linear_add()
>> all do.  So when a takeover makes the array smaller, the block device goes
>> on advertising the old size and I/O sails off the end of the new mapping.
>>
>> syzbot got there with a raid1 that had no metadata.  Such a member comes in
>> through md_import_device(dev, -1, -1), which never sets rdev->sectors, and
>> the check in bind_rdev_to_array() that keeps mddev->dev_sectors inside the
>> member is skipped precisely when rdev->sectors is 0:
>>
>> 	if (!test_bit(Journal, &rdev->flags) &&
>> 	    rdev->sectors &&
>> 	    (mddev->dev_sectors == 0 || rdev->sectors < mddev->dev_sectors)) {
>>
>> md/component_size had set dev_sectors to 2048, so raid1 came up with
>> array_sectors = 2048 and the disk got a 2048 sector capacity.  Writing
>> "raid0" to md/level then took the array over: create_strip_zones() rounded
>> rdev->sectors (0) down to a chunk multiple, so the single strip zone ended
>> at 0 and raid0_size() returned 0.  The capacity stayed at 2048, so the
>> partition scan on the next open of /dev/md0 read sector 0 and fell over:
> 
> This takeover looks like real problem in the first place, a takeover on live array
> can't shrink or mess up the user data, which means if there is a file system mounted
> on the array, the file system should still be consistent after take over.
> 
> I'll suggest rejecting such takeover to fix this problem.
> 

Hi Palla,

We've recently hit the same takeover issue on our side, so this is
definitely a real problem that still needs fixing.

I noticed the thread has been quiet for a while. If you haven't had the
bandwidth to follow up, I'd be happy to pick this up and send a patch
along the lines Yu Kuai suggested.

Please let me know if that works for you, or if someone is already
working on it so we don't duplicate effort.

Thanks,
Zizhi Wo

>>
>>     kernel BUG at drivers/md/raid0.c:318!
>>     RIP: 0010:find_zone drivers/md/raid0.c:318 [inline]
>>     RIP: 0010:raid0_map_submit_bio drivers/md/raid0.c:568 [inline]
>>     RIP: 0010:raid0_make_request+0xf17/0x10b0 drivers/md/raid0.c:626
>>     Call Trace:
>>      <TASK>
>>      md_handle_request+0xb0a/0xe60 drivers/md/md.c:417
>>      __submit_bio+0x27f/0x340 block/blk-core.c:681
>>      submit_bio_noacct_nocheck+0x4e8/0xa40 block/blk-core.c:792
>>      block_read_full_folio+0x7a6/0x810 fs/buffer.c:2373
>>      read_part_sector+0xb6/0x2b0 block/partitions/core.c:724
>>      adfspart_check_ICS+0xb1/0x960 block/partitions/acorn.c:357
>>      bdev_disk_changed+0x851/0x17a0 block/partitions/core.c:695
>>      blkdev_get_whole+0x372/0x510 block/bdev.c:793
>>      bdev_open+0x324/0xd70 block/bdev.c:1002
>>      blkdev_open+0x461/0x600 block/fops.c:674
>>      __x64_sys_openat+0x138/0x170 fs/open.c:1434
>>
>> Just refreshing the capacity in level_store() is not enough on its own.
>> If the size is managed externally - md/array_size written while the array
>> was stopped, which slips past array_size_store()'s -E2BIG check -
>> md_set_array_sectors() does nothing, array_sectors keeps the larger value
>> and we BUG() all the same.  level_store() cannot turn the takeover away
>> the way do_md_run() does either, because ->takeover() has already run and
>> the old personality has already been freed.
>>
>> md-linear has always just failed a sector outside its mapping instead of
>> asserting, so do the same here: let find_zone() return NULL and have its
>> two callers report the bio and end it with an I/O error.
>>
>> Tested both ways into this state - a takeover that leaves the array
>> zero-length, and one where md/array_size pins array_sectors at 2048.
>> Before, each panics in find_zone(); after, the read just fails:
>>
>>     md/raid0:md0: sector 0 out of bounds, array size 0
>>     md/raid0:md0: sector 0 out of bounds, array size 2048
>>
>> Reported-by: syzbot+422b372cabfbaa528725@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=422b372cabfbaa528725
>> Fixes: 9af204cf720c ("md: Add support for Raid5->Raid0 and Raid10->Raid0 takeover")
>> Signed-off-by: Palla Raghunath <raghunathpalla.0209@gmail.com>
>> ---
>>    drivers/md/raid0.c | 21 ++++++++++++++++++++-
>>    1 file changed, 20 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
>> index 35e103f0c2c3..04c022d74fae 100644
>> --- a/drivers/md/raid0.c
>> +++ b/drivers/md/raid0.c
>> @@ -301,6 +301,7 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
>>    
>>    /* Find the zone which holds a particular offset
>>     * Update *sectorp to be an offset in that zone
>> + * Returns NULL if the sector is off the end of the array.
>>     */
>>    static struct strip_zone *find_zone(struct r0conf *conf,
>>    				    sector_t *sectorp)
>> @@ -315,7 +316,16 @@ static struct strip_zone *find_zone(struct r0conf *conf,
>>    				*sectorp = sector - z[i-1].zone_end;
>>    			return z + i;
>>    		}
>> -	BUG();
>> +	return NULL;
>> +}
>> +
>> +static void raid0_out_of_bounds(struct mddev *mddev, struct bio *bio)
>> +{
>> +	pr_err_ratelimited("md/raid0:%s: sector %llu out of bounds, array size %llu\n",
>> +			   mdname(mddev),
>> +			   (unsigned long long)bio->bi_iter.bi_sector,
>> +			   (unsigned long long)mddev->array_sectors);
>> +	bio_io_error(bio);
>>    }
>>    
>>    /*
>> @@ -471,6 +481,10 @@ static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
>>    
>>    	orig_start = start;
>>    	zone = find_zone(conf, &start);
>> +	if (!zone) {
>> +		raid0_out_of_bounds(mddev, bio);
>> +		return;
>> +	}
>>    
>>    	if (bio_end_sector(bio) > zone->zone_end) {
>>    		bio = bio_submit_split_bioset(bio,
>> @@ -566,6 +580,11 @@ static void raid0_map_submit_bio(struct mddev *mddev, struct bio *bio)
>>    	md_account_bio(mddev, &bio);
>>    
>>    	zone = find_zone(mddev->private, &sector);
>> +	if (!zone) {
>> +		raid0_out_of_bounds(mddev, bio);
>> +		return;
>> +	}
>> +
>>    	switch (conf->layout) {
>>    	case RAID0_ORIG_LAYOUT:
>>    		tmp_dev = map_sector(mddev, zone, bio_sector, &sector);
> 

