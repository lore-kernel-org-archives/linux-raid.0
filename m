Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F84B1A285;
	Mon, 19 Jan 2026 03:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768792016; cv=none; b=XXZct6T+rcKY5ddomscNtHHDr+fCh6pG8RO8PFhxv7y+bIrKCiZBpt1nE16SohY9Ei209dsSdpf+FTSozEYdPGjhpYZq4XiIONg9Gt/2wOqOYKoyS15iWtQ3pKIp0eg/tzpdpePx4BXjrgp2TyojZzatKZKcF62ABgS1mg/5yRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768792016; c=relaxed/simple;
	bh=OeWizlxUaSutI3sn22Pa8oo/Hkq2DvrazJBAxocAklk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GOIqiAuVTezGwFStXu65lDrZxn1PaoDieEqgOGiSn8e5Qffi3oazWo4GDN46k2WI5bzhkagMDCK2UlIOM5ulJCcf3yq7pATitlqt/rtfB2RBz8gibeJIQAtM5TbveteuptX3OkyuUiAwmLrOZpnK4VGRhA1uUIJsBdhsIOzzxhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dvb2Y1pbGzYQtw4;
	Mon, 19 Jan 2026 11:06:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id AC5164056F;
	Mon, 19 Jan 2026 11:06:50 +0800 (CST)
Received: from [10.174.178.72] (unknown [10.174.178.72])
	by APP4 (Coremail) with SMTP id gCh0CgBXuPjIn21pYZpDEQ--.11532S3;
	Mon, 19 Jan 2026 11:06:50 +0800 (CST)
Message-ID: <0deb1b82-a6bf-43cd-a0a5-16106e96ec80@huaweicloud.com>
Date: Mon, 19 Jan 2026 11:06:48 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 5/5] md/raid1: introduce rectify action to repair
 badblocks
To: Li Nan <linan666@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, houtao1@huawei.com,
 linan122@h-partners.com, song@kernel.org, yukuai@fnnas.com,
 Zheng Qixing <zhengqixing@huawei.com>
References: <20251231070952.1233903-1-zhengqixing@huaweicloud.com>
 <20251231070952.1233903-6-zhengqixing@huaweicloud.com>
 <434dd5ec-1cd9-4893-feb6-7936a0e82749@huaweicloud.com>
From: Zheng Qixing <zhengqixing@huaweicloud.com>
In-Reply-To: <434dd5ec-1cd9-4893-feb6-7936a0e82749@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXuPjIn21pYZpDEQ--.11532S3
X-Coremail-Antispam: 1UD129KBjvJXoWxGF48Cry3Ar48tw1DArW5ZFb_yoW5tFyrp3
	WkJFW8AryUGrn5Xr1DtFyUJFyFyr1UJ3WDJr48W3W7tFsFyry0gF4UXrn0gr1UAr48Gr4U
	ZF1UWrsrZr47JrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
	v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
	1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
	AIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI
	42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWI
	evJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/


在 2026/1/14 11:11, Li Nan 写道:
>
>
> 在 2025/12/31 15:09, Zheng Qixing 写道:
>> From: Zheng Qixing <zhengqixing@huawei.com>
>>
>> Add support for repairing known badblocks in RAID1. When disks
>> have known badblocks (shown in sysfs bad_blocks), data can be
>> read from other healthy disks in the array and written to repair
>> the badblock areas and clear it in bad_blocks.
>>
>> echo rectify > sync_action can trigger this action.
>>
>> Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
>
>> +static void end_rectify_read(struct bio *bio)
>> +{
>> +    struct r1bio *r1_bio = get_resync_r1bio(bio);
>> +    struct r1conf *conf = r1_bio->mddev->private;
>> +    struct md_rdev *rdev;
>> +    struct bio *next_bio;
>> +    bool all_fail = true;
>> +    int i;
>> +
>> +    update_head_pos(r1_bio->read_disk, r1_bio);
>> +
>> +    if (!bio->bi_status) {
>> +        set_bit(R1BIO_Uptodate, &r1_bio->state);
>> +        goto out;
>> +    }
>> +
>> +    for (i = r1_bio->read_disk + 1; i < conf->raid_disks; i++) {
>> +        rdev = conf->mirrors[i].rdev;
>> +        if (!rdev || test_bit(Faulty, &rdev->flags))
>> +            continue;
>> +
>> +        next_bio = r1_bio->bios[i];
>> +        if (next_bio->bi_end_io == end_rectify_read) {
>> +            next_bio->bi_opf &= ~MD_FAILFAST;
>
> Why set MD_FAILFAST and clear it soon?
> And submit_rectify_read() will clear it again.


Indeed.

>
>> +static void rectify_request_write(struct mddev *mddev, struct r1bio *r1_bio)
>> +{
>> +    struct r1conf *conf = mddev->private;
>> +    struct bio *wbio = NULL;
>> +    int wcnt = 0;
>> +    int i;
>> +
>> +    if (!test_bit(R1BIO_Uptodate, &r1_bio->state)) {
>> +        submit_rectify_read(r1_bio);
>> +        return;
>> +    }
>> +
>> +    atomic_set(&r1_bio->remaining, 0);
>> +    for (i = 0; i < conf->raid_disks; i++) {
>> +        wbio = r1_bio->bios[i];
>> +        if (wbio->bi_end_io == end_rectify_write) {
>> +            atomic_inc(&r1_bio->remaining);
>> +            wcnt++;
>> +            submit_bio_noacct(wbio);
>> +        }
>> +    }
>> +
>> +    if (unlikely(!wcnt)) {
>> +        md_done_sync(r1_bio->mddev, r1_bio->sectors);
>> +        put_buf(r1_bio);
>> +    }
>
> How can 'wcnt' be 0?


Oh, I forgot to check the faulty state of rdev.😳

>
>> +}
>> +
>> +static void handle_rectify_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
>> +{
>> +    struct md_rdev *rdev;
>> +    struct bio *bio;
>> +    int i;
>> +
>> +    for (i = 0; i < conf->raid_disks; i++) {
>> +        rdev = conf->mirrors[i].rdev;
>> +        bio = r1_bio->bios[i];
>> +        if (bio->bi_end_io == NULL)
>> +            continue;
>> +
>> +        if (!bio->bi_status && bio->bi_end_io == end_rectify_write &&
>> +            test_bit(R1BIO_MadeGood, &r1_bio->state)) {
>> +            rdev_clear_badblocks(rdev, r1_bio->sector,
>> +                         r1_bio->sectors, 0);
>> +        }
>
> Reuse handle_sync_write_finished() seems better.

Good point.


Thanks,

Qixing

