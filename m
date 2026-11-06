Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.94.104
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793953250;
	b=ubZKisebeimoeIX5T6nsOfARt4YzyBn4PWWSmUuAZqDthilUdwZsn4ZJ3mUWSP7abrUL
	 iURJsvlre8H3kHk36UTwkpJ+VBupXWLHL2Be3ECtEPxqPPsrgdgoJsvj4HRB0eeO5pr6m
	 9Ps7xHhfVUUQy/bc8+oahIdkOjRsYQ0VeYx+5XfWz01ArpBm4yFymhoCi1+Y+IOfTlkuM
	 AisbK6TvQHkbanegIoiccpOSPcjwxegi0duSu14xu10RUa6IfX+st5CDsl6E43g3E4L4v
	 3NsEufUvK7thSpl/ur55yOfllFxo6r2j/cCRhH2MIQepI0CVwEGD3+cf5QexN3Vb2Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793953250;
	h=DMARC-Filter:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=sjimZu/Y/vfHM2ZHLcATzWAft1nruP4f5emXh0QnSE8=;
	b=VyvQsmufdh5PJtOqiblHA7jTNuUANIoQoFsxjiUmxELvT/julTuB5VEwzrDZmFkV/NH1
	 8EcXhYr51yPruDLtbl/ZuvKyKxva4e4aRNut3aZPLbLOUM2GXd36KnNkYOYGb80qcc8e+
	 pCag8BpcXPhwelrsK3+p0GwiR8ymvQxUu4BSFwAbmCm5rMBitB2cC7lVEN1c8/sdncFht
	 Jmkf4ox5imJxmAvV/rdsebjgRqhREYFPIbNv6Vaa4yGvJLUH8RaBWxBsHfr2Q/T6jUCZj
	 vhnx3XCxT4WvVsTtMqm2uuNAP5jrPRzk302bSNsJQWel3N8SmGXlwGue7F7dX5EQ+rA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.94.104
Received: from dggmsgout13.his.huawei.com (dggmsgout13.his.huawei.com [124.71.94.104])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C947606A328;
	Fri,  6 Nov 2026 08:20:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C947606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggmsgout13.his.huawei.com (SkyGuard) with ESMTP id 4jLXD62Gn0z1rqsk;
	Fri,  6 Nov 2026 16:20:06 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B078940614;
	Fri,  6 Nov 2026 16:20:36 +0800 (CST)
Received: from [10.174.178.164] (unknown [10.174.178.164])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgAnZvXTje1qRlQlDQ--.48330S3;
	Fri, 06 Nov 2026 16:20:36 +0800 (CST)
Message-ID: <ecaeda04-e90b-450b-a591-3cc3cc85fb5f@huaweicloud.com>
Date: Fri, 6 Nov 2026 16:20:33 +0800
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 1/3] md/raid0: reject a takeover whose zones cannot
 cover the array
To: yukuai@fygo.io, song@kernel.org, magiclinan@didiglobal.com,
 xiao@kernel.org, linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yangerkun@huawei.com,
 chengzhihao1@huawei.com, wozizhi@huawei.com
References: <20261102083815.127751-1-wozizhi@huaweicloud.com>
 <20261102083815.127751-2-wozizhi@huaweicloud.com>
 <bc03d165-55fa-4029-b653-eb5359a2816c@fygo.io>
From: Zizhi Wo <wozizhi@huaweicloud.com>
In-Reply-To: <bc03d165-55fa-4029-b653-eb5359a2816c@fygo.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAnZvXTje1qRlQlDQ--.48330S3
X-Coremail-Antispam: 1UD129KBjvJXoWxtrWxCFWkKry5Xry8Jw47Arb_yoWxJryDp3
	y0qFnIqr4kJryfAwnFqr1DGa4FyryrGr4UtF9xJ348Ww13Ar97GFy7G34Y9a4UCr95urWj
	yw4UJrZFkF9YgFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyGb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7
	CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8C
	rVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4
	IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0E
	wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
	80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0
	I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04
	k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7Cj
	xVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU17KsUUUUUU==
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/

Hi，yukuai

在 2026/11/6 14:34, yu kuai 写道:
> Hi,
> 
> 在 2026/11/2 16:38, Zizhi Wo 写道:
>> From: Zizhi Wo <wozizhi@huawei.com>
>>
>> If a raid0 takeover builds strip zones that cover less than the advertised
>> array size, the block layer still accepts I/O for the whole size.
>> raid0_make_request() hands any request past the zones to the mapping code,
>> which fails to map it and triggers a BUG_ON.
>>
>> The zones are built from the member sizes in rdev->sectors, which may not
>> match the size the array already advertises, so the zones can come out
>> covering less than it. The extreme case is a member with no size recorded
>> at all: an array created without metadata imports its devices through
>> md_import_device(dev, -1, -1), which never sets rdev->sectors, and
>> bind_rdev_to_array() does not reject such a member either, because its
>> check that mddev->dev_sectors fits inside a member is skipped when
>> rdev->sectors is zero.
>>
>> Refuse a raid0 takeover when its zones cannot cover the size the gendisk
>> advertises. This prevents the takeover from silently shrinking the array,
>> mirroring the rule raid5_start_reshape() and raid10_start_reshape() apply
>> to a reshape.
>>
>> The check iterates the same devices and uses the same rounding as
>> create_strip_zones(). It does not skip devices with rdev->raid_disk < 0:
>> such devices cannot be raid0 members, so counting them only overestimates
>> the coverage and, if present, the takeover fails later in
>> create_strip_zones() anyway.
>>
>> Fixes: 9af204cf720c ("md: Add support for Raid5->Raid0 and Raid10->Raid0 takeover")
>> Fixes: fc3a08b85b7a ("Add raid1->raid0 takeover support")
>> Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
>> ---
>>    drivers/md/raid0.c | 37 +++++++++++++++++++++++++++++++++++++
>>    1 file changed, 37 insertions(+)
>>
>> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
>> index 35e103f0c2c3..fccc62a5fecc 100644
>> --- a/drivers/md/raid0.c
>> +++ b/drivers/md/raid0.c
>> @@ -643,6 +643,34 @@ static void raid0_error(struct mddev *mddev, struct md_rdev *rdev)
>>    	}
>>    }
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
>> +
>> +	if (coverage < capacity) {
>> +		pr_warn("md/raid0:%s: refusing takeover, zones cover only %llu of %llu sectors\n",
>> +			mdname(mddev), (unsigned long long)coverage,
>> +			(unsigned long long)capacity);
> 
> Other than raid1, other levels already have mddev->chunk_secotrs set, and raid456/raid10 already
> have a full functional raid0, their takeover can not fail.
> 
> Noted normally mdadm will set rdev->sectors and 1.x metadata will reject zero rdev->sectors in super_1_load.
> However, it's still possible raid1 can be created with rdev->sectors be zero, this is the root cause of the
> problem syzbot reported.
> 

Please consider the following two cases, both of which reproduce the
same BUG_ON locally for me:

1. An array created without metadata leaves rdev->sectors at 0. This
isn't raid1-specific — raid10 hits the same BUG_ON too. raid45 only
escapes because raid0_takeover_raid45() overwrites rdev->sectors with
mddev->dev_sectors first; raid0_takeover_raid10() doesn't.

2. Even with valid non-zero rdev->sectors, growing the chunk of a
running raid45 can make the post-takeover coverage smaller than the
previously advertised gendisk capacity. E.g. create a raid5 with
component_size=8K, chunk=4K, run it, then change chunk to 16K and run
raid0_takeover_raid45().

So I think the real root cause is that the size changes across the
takeover, and rdev->sectors == 0 is just one special case of it. That's
why the patch compares coverage against the gendisk capacity on every
takeover path.

For case 2, the problem exists even without a takeover: if the chunk
change shrinks the usable size, I/O from the upper filesystem will break
just the same. So I'm now inclined to reject a chunk change in raid5/10
when it would shrink the usable array size, and additionally check rdev-
 >sectors for raid1/10 at the takeover path. What do you think?

Thanks,
Zizhi Wo

> Although raid0_takeover_raid1() already calculate chunksect by mddev->array_sectors, which is exactly the
> real rdev->sectors for raid1, and it should be guaranteed such takeover can succeed. However, as it's legacy
> usage that rdev->sectors can be zero, I'll suggest just checking rdev->sectors in raid0_takeover_raid1() and
> reject if it's 0.
> 
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>    static void *raid0_takeover_raid45(struct mddev *mddev)
>>    {
>>    	struct md_rdev *rdev;
>> @@ -665,6 +693,9 @@ static void *raid0_takeover_raid45(struct mddev *mddev)
>>    		rdev->sectors = mddev->dev_sectors;
>>    	}
>>    
>> +	if (raid0_takeover_check(mddev, mddev->chunk_sectors))
>> +		return ERR_PTR(-EINVAL);
>> +
>>    	/* Set new parameters */
>>    	mddev->new_level = 0;
>>    	mddev->new_layout = 0;
>> @@ -707,6 +738,9 @@ static void *raid0_takeover_raid10(struct mddev *mddev)
>>    		return ERR_PTR(-EINVAL);
>>    	}
>>    
>> +	if (raid0_takeover_check(mddev, mddev->chunk_sectors))
>> +		return ERR_PTR(-EINVAL);
>> +
>>    	/* Set new parameters */
>>    	mddev->new_level = 0;
>>    	mddev->new_layout = 0;
>> @@ -750,6 +784,9 @@ static void *raid0_takeover_raid1(struct mddev *mddev)
>>    		/* array size does not allow a suitable chunk size */
>>    		return ERR_PTR(-EINVAL);
>>    
>> +	if (raid0_takeover_check(mddev, chunksect))
>> +		return ERR_PTR(-EINVAL);
>> +
>>    	/* Set new parameters */
>>    	mddev->new_level = 0;
>>    	mddev->new_layout = 0;
> 

