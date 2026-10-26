Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.94.104
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792983910;
	b=ghJXG2CONrnjKvCRrdk3fJMc+z0yaAHkQjeh8VwYck10AP8AUoZTMQU/BpEfC7EqxLRn
	 kCHXKt3hrmQgKiLayzEW18EMMJrL33ZISv7JkM5oRvdnyMT94Arf1HMMPYViA3B6m5cDZ
	 NwFZK54otVQK7LCQtVuv9PHYd/xRIlVeSRIJ49HmpIde1k6F7jeporWqJo04gHfDFUoGL
	 gkQQDFY43+IIabJaMhYIvRurbpJhInVW8Re8j3Tc4fpXw3lHjPEqSw5A+XM7O+7Ja9x4H
	 6GJMdQLzYSXbwmpeaCo5mHA3HqJLso8zfLh/GbKvKOJ0qDETAAukY9QPlDQt2sW/QoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792983910;
	h=DMARC-Filter:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:From:Subject:To:Cc:References:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=3C1HfW0t1PxdGu8skpXHCT6VgAMEgQcIBtnY1rFsIuU=;
	b=xXhEYfk/Egf9XsosKWYHinqKyPic1gCvI5Od5O6oesJf6+2XnY+W+cKUVjcy2AY2fbqW
	 dmcphRDkpB4rJKYPu1AWRJmT5OTx/99kWbK4bIJcfL0qg46X3RQH7TPUa935tFwMCdJ5I
	 ZzpFGUXGwxpm0TRLgWL1uvVliICLfcgRhJ3U3RiRKyYSA3j2YGyf4TJ1to8BZUeGLGMpz
	 7piiFr7HGpOB2se1ub62I1bEYIprCycF1uW4mv+XWRz8oB+dWpn/qTfu8PNAUT9KyId4J
	 +9LHogqGqGY1S2tziyUHiux9X/Aa2u8D1+A0hJNdnOhQ7iXQhBppgtulnYpDcDWMb+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.94.104
Received: from dggmsgout13.his.huawei.com (dggmsgout13.his.huawei.com [124.71.94.104])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65FD606A31A
	for <linux-raid@vger.kernel.org>; Mon, 26 Oct 2026 03:05:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D65FD606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggmsgout13.his.huawei.com (SkyGuard) with ESMTP id 4jCdlW54dRz1rrSW
	for <linux-raid@vger.kernel.org>; Mon, 26 Oct 2026 11:04:55 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id DA37D40576
	for <linux-raid@vger.kernel.org>; Mon, 26 Oct 2026 11:05:05 +0800 (CST)
Received: from [10.174.178.164] (unknown [10.174.178.164])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgB3tfRgw95qUHZvBw--.29140S3;
	Mon, 26 Oct 2026 11:05:05 +0800 (CST)
Message-ID: <f4ff3d74-c6ca-49d2-aeb5-fdf6c6276e98@huaweicloud.com>
Date: Mon, 26 Oct 2026 11:05:03 +0800
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
From: Zizhi Wo <wozizhi@huaweicloud.com>
Subject: Re: [PATCH V2 1/6] md/raid0: don't leave mddev in an inconsistent
 state when takeover fails
To: Bruce Johnston <bjohnsto@redhat.com>, Zizhi Wo <wozizhi@huaweicloud.com>
Cc: song@kernel.org, yukuai@fygo.io, magiclinan@didiglobal.com,
 xiao@kernel.org, linux-raid@vger.kernel.org, yangerkun@huawei.com,
 chengzhihao1@huawei.com
References: <20261019010827.2922617-1-wozizhi@huaweicloud.com>
 <20261019010827.2922617-2-wozizhi@huaweicloud.com>
 <CAOjDE+C8KFcTsaWjMfmcWcQOwv8qetm-QKvYts+cUGFzgUB8uA@mail.gmail.com>
In-Reply-To: <CAOjDE+C8KFcTsaWjMfmcWcQOwv8qetm-QKvYts+cUGFzgUB8uA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3tfRgw95qUHZvBw--.29140S3
X-Coremail-Antispam: 1UD129KBjvJXoWxtrykJF4rKry5Aw1DJFy7Jrb_yoWxtF1Up3
	yxWFnFgrWDJry3Z3sFqryDC3yFv3y8Gr4vyF93XayUGw12krykGa45Wr45Ja4DC3s5Ar4j
	qw18Ar4DCFZrKFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkm14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
	1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r1q
	6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
	IxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUoWlkDUUUU
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/



在 2026/10/23 21:29, Bruce Johnston 写道:
> On Sun, Oct 18, 2026 at 9:16 PM Zizhi Wo <wozizhi@huaweicloud.com> wrote:
>>
>> From: Zizhi Wo <wozizhi@huawei.com>
>>
>> raid0_takeover_raid45(), raid0_takeover_raid10() and raid0_takeover_raid1()
>> update mddev before create_strip_zones(), which can fail.
>>
>> On failure, level_store() only rolls back new_level, new_layout,
>> new_chunk_sectors, raid_disks and delta_disks. The old personality is
>> therefore left with a reset resync_offset, cleared feature flags, and, for
>> raid1, the wrong chunk size.
>>
>> Set only what create_strip_zones() needs before calling it, and move the
>> rest after it succeeds.
>>
>> create_strip_zones() also rounds rdev->sectors, but the old levels do not
>> use it for I/O, so that is harmless. And mddev->degraded is already reset
>> by level_store() on success, so drop the redundant assignment in
>> raid0_takeover_raid10().
>>
> 
> The rounding of sectors is not too much of a concern of mine. I'm more concerned
> about rdev->sectors getting set to mddev->dev_sectors in the
> raid0_takeover_raid45.
> While I think I understand why it is done and I agree rdev->sectors
> isn't used by the 4/5 raid
> level I/O, I'm pretty sure the field is still used in sysfs fields and
> things like mdstat. On
> a takeover failure, I feel like we are losing what the old
> rdev->sectors value was when
> we go back to raid 4/5 (rdev->sectors and mddev->dev_sectors can be
> different values)
> 
> Do you have any thoughts on this? I know it would be a pain to backup
> / restore every
> rdev.

Thanks for the review.

If I understand you correctly: since rdev->sectors is exposed to
userspace via sysfs (and similar interfaces), it's better to keep it
consistent across a failed takeover, i.e. restore the original value on
the error path.

Looking at the takeover flow, there are two places that modify
rdev->sectors:

1. In create_strile_zones(), here the value is adjusted by at most
*chunk_sectors - 1*, so the discrepancy is small?

2. In raid0_takeover_raid45(), where it gets overwritten by
mddev->dev_sectors — here the difference can be much larger.

In principle both would leave a stale value behind on failure. My
understanding is that you consider the first one "not too much of a
concern" because the delta is tiny, while the second is the one that
really matters. Is that correct?

However, if the user has dynamically changed chunk_sectors to a large
value at runtime, and the corresponding rdev->sectors was originally
small, then the difference presented to the user could actually be quite
significant. RAID0 doesn't allow modifying chunk_sectors at runtime, but 
RAID4/5/etc. do. Is this something we need to be concerned about?

I currently see two possible approaches:

1. In raid0_takeover_raid45(), allocate a temporary array up front to
save the old values, and restore them on failure — a targeted fix for
just the raid45 case.

2. In create_strip_zones(), allocate a temporary array up front to save
the old values; then remove the rdev->sectors assignment from
raid0_takeover_raid45() and consolidate all the assignment logic into
create_strip_zones() (which already assigns this field anyway), choosing
between rdev->sectors and mddev->dev_sectors based on the level. The
error path would then restore the saved values, fixing both places at
once.

Do you have a preference between these two, or is there a simpler
approach you'd suggest?

Thanks,
Zizhi Wo

> 
>> Fixes: 9af204cf720c ("md: Add support for Raid5->Raid0 and Raid10->Raid0 takeover")
>> Fixes: fc3a08b85b7a ("Add raid1->raid0 takeover support")
>> Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
>> ---
>>   drivers/md/raid0.c | 36 +++++++++++++++++++++++-------------
>>   1 file changed, 23 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
>> index 35e103f0c2c3..8157e1058a24 100644
>> --- a/drivers/md/raid0.c
>> +++ b/drivers/md/raid0.c
>> @@ -669,15 +669,16 @@ static void *raid0_takeover_raid45(struct mddev *mddev)
>>          mddev->new_level = 0;
>>          mddev->new_layout = 0;
>>          mddev->new_chunk_sectors = mddev->chunk_sectors;
>>          mddev->raid_disks--;
>>          mddev->delta_disks = -1;
>> -       /* make sure it will be not marked as dirty */
>> -       mddev->resync_offset = MaxSector;
>> -       mddev_clear_unsupported_flags(mddev, UNSUPPORTED_MDDEV_FLAGS);
>>
>> -       create_strip_zones(mddev, &priv_conf);
>> +       if (!create_strip_zones(mddev, &priv_conf)) {
>> +               /* make sure it will be not marked as dirty */
>> +               mddev->resync_offset = MaxSector;
>> +               mddev_clear_unsupported_flags(mddev, UNSUPPORTED_MDDEV_FLAGS);
>> +       }
>>
>>          return priv_conf;
>>   }
>>
>>   static void *raid0_takeover_raid10(struct mddev *mddev)
>> @@ -711,23 +712,25 @@ static void *raid0_takeover_raid10(struct mddev *mddev)
>>          mddev->new_level = 0;
>>          mddev->new_layout = 0;
>>          mddev->new_chunk_sectors = mddev->chunk_sectors;
>>          mddev->delta_disks = - mddev->raid_disks / 2;
>>          mddev->raid_disks += mddev->delta_disks;
>> -       mddev->degraded = 0;
>> -       /* make sure it will be not marked as dirty */
>> -       mddev->resync_offset = MaxSector;
>> -       mddev_clear_unsupported_flags(mddev, UNSUPPORTED_MDDEV_FLAGS);
>>
>> -       create_strip_zones(mddev, &priv_conf);
>> +       if (!create_strip_zones(mddev, &priv_conf)) {
>> +               /* make sure it will be not marked as dirty */
>> +               mddev->resync_offset = MaxSector;
>> +               mddev_clear_unsupported_flags(mddev, UNSUPPORTED_MDDEV_FLAGS);
>> +       }
>> +
>>          return priv_conf;
>>   }
>>
>>   static void *raid0_takeover_raid1(struct mddev *mddev)
>>   {
>>          struct r0conf *priv_conf;
>>          int chunksect;
>> +       int old_chunk_sectors;
>>
>>          /* Check layout:
>>           *  - (N - 1) mirror drives must be already faulty
>>           */
>>          if ((mddev->raid_disks - 1) != mddev->degraded) {
>> @@ -748,22 +751,29 @@ static void *raid0_takeover_raid1(struct mddev *mddev)
>>
>>          if ((chunksect << 9) < PAGE_SIZE)
>>                  /* array size does not allow a suitable chunk size */
>>                  return ERR_PTR(-EINVAL);
>>
>> +       /* Save for rollback if create_strip_zones() fails */
>> +       old_chunk_sectors = mddev->chunk_sectors;
>> +
>>          /* Set new parameters */
>>          mddev->new_level = 0;
>>          mddev->new_layout = 0;
>>          mddev->new_chunk_sectors = chunksect;
>>          mddev->chunk_sectors = chunksect;
>>          mddev->delta_disks = 1 - mddev->raid_disks;
>>          mddev->raid_disks = 1;
>> -       /* make sure it will be not marked as dirty */
>> -       mddev->resync_offset = MaxSector;
>> -       mddev_clear_unsupported_flags(mddev, UNSUPPORTED_MDDEV_FLAGS);
>>
>> -       create_strip_zones(mddev, &priv_conf);
>> +       if (!create_strip_zones(mddev, &priv_conf)) {
>> +               /* make sure it will be not marked as dirty */
>> +               mddev->resync_offset = MaxSector;
>> +               mddev_clear_unsupported_flags(mddev, UNSUPPORTED_MDDEV_FLAGS);
>> +       } else {
>> +               mddev->chunk_sectors = old_chunk_sectors;
>> +       }
>> +
>>          return priv_conf;
>>   }
>>
>>   static void *raid0_takeover(struct mddev *mddev)
>>   {
>> --
>> 2.52.0
>>
>>
> 
> 

