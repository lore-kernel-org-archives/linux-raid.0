Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.93.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794190027;
	b=KCbQ9x1F9pmX9cRLr1mgNu9NC6h9ExGe7stxSYa42a3wf/OiQpfzVZdzPVLyUKOXfmBT
	 Gl5AcKT293t8plM3D5ZHDPURTy66E2XlMoixNx3+7yFoYi1EMFI21FzUvKLbxuWvlj1jp
	 d7aWJ0WS3lQq4i7Jy/YXzG4Y9/tGP0yPOYVibN6c8d/hguH8XWVUM8QTxJQARtJ9BFlDd
	 5U0J1VnzfxSoLDQFr2a/IQBenOVR3tBAOpPJtVjtlgEAdHEG6PcvtBEjn6xT38xrBGlF6
	 e//s+KiZKp2iSMFGxZFPUkAPVqoAIQx4Qocn1OqWgWJTpF33+iy9SKaev4YKwE5LUhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794190027;
	h=DMARC-Filter:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=lCEuoUUgwAK74uid5ekbPJrWySmOuTvo4m+1iRiAFug=;
	b=1Ft9G7dxuh7Zn9HLvt5D/y3b772VOcKZgzI+bJsoCQH5J2DgrTU3mLFOzew5gOspTMH7
	 NR2Wrb7bhS14NggVq4PSgucyoy9J0zq11yfFAFvQrOyYd9eRlLl0+phEFV2Z0XdPAYAIw
	 wGktrMI5iuW/OJG5dK1jGigPOsHstQ3QPNXuF4jB60WK+CtjMx7EzPzgTnG5G42lH7Ti2
	 KK0y6zq25iTLz+KLWWU1qwipL/eFZMaU1vIH3BBVPgf3a9GP8eMmKJOpQzMatNsFlxffi
	 OoS34+uqJhoxoKtF67COH1e4WjTA/wwhUQjdgY8S7GCZhBtcLjNfycA2icT4ykwCtBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.93.99
Received: from dggmsgout11.his.huawei.com (dggmsgout11.his.huawei.com [124.71.93.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F71F606A31C;
	Mon,  9 Nov 2026 02:07:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2F71F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggmsgout11.his.huawei.com (SkyGuard) with ESMTP id 4jNCnZ5jKcz1c1n2;
	Mon,  9 Nov 2026 10:06:26 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A272940573;
	Mon,  9 Nov 2026 10:07:02 +0800 (CST)
Received: from [10.174.178.164] (unknown [10.174.178.164])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgCn5fTEKvFq2COKDg--.45663S3;
	Mon, 09 Nov 2026 10:07:02 +0800 (CST)
Message-ID: <9521a3f6-890e-4f7c-b8a5-a355ffd3b1f2@huaweicloud.com>
Date: Mon, 9 Nov 2026 10:06:59 +0800
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
To: yukuai@fygo.io, Zizhi Wo <wozizhi@huaweicloud.com>, song@kernel.org,
 magiclinan@didiglobal.com, xiao@kernel.org, linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yangerkun@huawei.com,
 chengzhihao1@huawei.com
References: <20261102083815.127751-1-wozizhi@huaweicloud.com>
 <20261102083815.127751-2-wozizhi@huaweicloud.com>
 <bc03d165-55fa-4029-b653-eb5359a2816c@fygo.io>
 <ecaeda04-e90b-450b-a591-3cc3cc85fb5f@huaweicloud.com>
 <f3d1b920-9e57-479d-8169-25e68bfe8bac@fygo.io>
From: Zizhi Wo <wozizhi@huaweicloud.com>
In-Reply-To: <f3d1b920-9e57-479d-8169-25e68bfe8bac@fygo.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCn5fTEKvFq2COKDg--.45663S3
X-Coremail-Antispam: 1UD129KBjvJXoW3XFWfAw1kWFWxCFWxZw15CFg_yoWfJF45p3
	y8tF4YqrWrGr93AwnFqw1UWFyFyry8Gw4UtFn3Xa48GwsxArn2grWUXr909a4UArZ5Ar1j
	qw1UJrZruFyqgrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkm14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
	1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r1q
	6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
	IxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/

Hi, yukuai

在 2026/11/8 10:34, yu kuai 写道:
> Hi,
> 
> 在 2026/11/6 16:20, Zizhi Wo 写道:
>> Hi，yukuai
>>
>> 在 2026/11/6 14:34, yu kuai 写道:
>>> Hi,
>>>
>>> 在 2026/11/2 16:38, Zizhi Wo 写道:
>>>> From: Zizhi Wo <wozizhi@huawei.com>
>>>>
>>>> If a raid0 takeover builds strip zones that cover less than the
>>>> advertised
>>>> array size, the block layer still accepts I/O for the whole size.
>>>> raid0_make_request() hands any request past the zones to the mapping
>>>> code,
>>>> which fails to map it and triggers a BUG_ON.
>>>>
>>>> The zones are built from the member sizes in rdev->sectors, which
>>>> may not
>>>> match the size the array already advertises, so the zones can come out
>>>> covering less than it. The extreme case is a member with no size
>>>> recorded
>>>> at all: an array created without metadata imports its devices through
>>>> md_import_device(dev, -1, -1), which never sets rdev->sectors, and
>>>> bind_rdev_to_array() does not reject such a member either, because its
>>>> check that mddev->dev_sectors fits inside a member is skipped when
>>>> rdev->sectors is zero.
>>>>
>>>> Refuse a raid0 takeover when its zones cannot cover the size the
>>>> gendisk
>>>> advertises. This prevents the takeover from silently shrinking the
>>>> array,
>>>> mirroring the rule raid5_start_reshape() and raid10_start_reshape()
>>>> apply
>>>> to a reshape.
>>>>
>>>> The check iterates the same devices and uses the same rounding as
>>>> create_strip_zones(). It does not skip devices with rdev->raid_disk
>>>> < 0:
>>>> such devices cannot be raid0 members, so counting them only
>>>> overestimates
>>>> the coverage and, if present, the takeover fails later in
>>>> create_strip_zones() anyway.
>>>>
>>>> Fixes: 9af204cf720c ("md: Add support for Raid5->Raid0 and
>>>> Raid10->Raid0 takeover")
>>>> Fixes: fc3a08b85b7a ("Add raid1->raid0 takeover support")
>>>> Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
>>>> ---
>>>>     drivers/md/raid0.c | 37 +++++++++++++++++++++++++++++++++++++
>>>>     1 file changed, 37 insertions(+)
>>>>
>>>> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
>>>> index 35e103f0c2c3..fccc62a5fecc 100644
>>>> --- a/drivers/md/raid0.c
>>>> +++ b/drivers/md/raid0.c
>>>> @@ -643,6 +643,34 @@ static void raid0_error(struct mddev *mddev,
>>>> struct md_rdev *rdev)
>>>>         }
>>>>     }
>>>>     +/*
>>>> + * Refuse a takeover whose strip zones cannot cover the capacity
>>>> the gendisk
>>>> + * advertises: raid0 derives those zones from the sizes of its
>>>> members, so
>>>> + * find_zone() cannot map I/O that falls beyond them.
>>>> + */
>>>> +static int raid0_takeover_check(struct mddev *mddev, int chunk)
>>>> +{
>>>> +    sector_t capacity = get_capacity(mddev->gendisk);
>>>> +    sector_t coverage = 0;
>>>> +    struct md_rdev *rdev;
>>>> +
>>>> +    rdev_for_each(rdev, mddev) {
>>>> +        sector_t sectors = rdev->sectors;
>>>> +
>>>> +        sector_div(sectors, chunk);
>>>> +        coverage += sectors * chunk;
>>>> +    }
>>>> +
>>>> +    if (coverage < capacity) {
>>>> +        pr_warn("md/raid0:%s: refusing takeover, zones cover only
>>>> %llu of %llu sectors\n",
>>>> +            mdname(mddev), (unsigned long long)coverage,
>>>> +            (unsigned long long)capacity);
>>>
>>> Other than raid1, other levels already have mddev->chunk_secotrs set,
>>> and raid456/raid10 already
>>> have a full functional raid0, their takeover can not fail.
>>>
>>> Noted normally mdadm will set rdev->sectors and 1.x metadata will
>>> reject zero rdev->sectors in super_1_load.
>>> However, it's still possible raid1 can be created with rdev->sectors
>>> be zero, this is the root cause of the
>>> problem syzbot reported.
>>>
>>
>> Please consider the following two cases, both of which reproduce the
>> same BUG_ON locally for me:
>>
>> 1. An array created without metadata leaves rdev->sectors at 0. This
>> isn't raid1-specific — raid10 hits the same BUG_ON too. raid45 only
>> escapes because raid0_takeover_raid45() overwrites rdev->sectors with
>> mddev->dev_sectors first; raid0_takeover_raid10() doesn't.
> 
> This is still legacy usage, and root cause is still that rdev->sectors be 0.
> 

This case is.

>>
>> 2. Even with valid non-zero rdev->sectors, growing the chunk of a
>> running raid45 can make the post-takeover coverage smaller than the
>> previously advertised gendisk capacity. E.g. create a raid5 with
>> component_size=8K, chunk=4K, run it, then change chunk to 16K and run
>> raid0_takeover_raid45().
> 
> How can chunksize grow to 16k in this case?

1. mdadm --create /dev/md0 -l5 -n3 --layout=parity-last --chunk=4 
--size=8 --assume-clean xxx
2. echo 16384 > /sys/block/md0/md/chunk_size
3. echo reshape > /sys/block/md0/md/sync_action
4. Discard the verification disk
5. echo raid0 > /sys/block/md0/md/level

The check in raid5_check_reshape() is whether new_chunk divides mddev-
 >array_sectors evenly, which in my 2-data-disk case is also satisfied.
(I think checking mddev->dev_sectors would be more appropriate — a
divisible total size doesn't imply each disk is divisible, which can
still impact later IO. Still, detecting whether the total size shrinks
after the change should suffice to block this case?)

And raid5_start_reshape() still uses the previous chunk_sectors and
prev_chunk_sectors values when doing the raid5_size < 
mddev->array_sectors comparison,
it fails to catch the fact that modifying the chunk size has actually
reduced raid5_size.

And in raid5_finish_reshape(), mddev->chunk_sectors has set to 16KB.

> 
>>
>> So I think the real root cause is that the size changes across the
>> takeover, and rdev->sectors == 0 is just one special case of it. That's
>> why the patch compares coverage against the gendisk capacity on every
>> takeover path.
>>
>> For case 2, the problem exists even without a takeover: if the chunk
>> change shrinks the usable size, I/O from the upper filesystem will break
>> just the same. So I'm now inclined to reject a chunk change in raid5/10
>> when it would shrink the usable array size, and additionally check rdev-
>>> sectors for raid1/10 at the takeover path. What do you think?
> 
> There is always a top rule that running array can be mounted, hence any
> changes should not introduce data lost.
> 

Yes.

Thanks,
Zizhi Wo

>>
>> Thanks,
>> Zizhi Wo
>>
>>> Although raid0_takeover_raid1() already calculate chunksect by
>>> mddev->array_sectors, which is exactly the
>>> real rdev->sectors for raid1, and it should be guaranteed such
>>> takeover can succeed. However, as it's legacy
>>> usage that rdev->sectors can be zero, I'll suggest just checking
>>> rdev->sectors in raid0_takeover_raid1() and
>>> reject if it's 0.
>>>
>>>> +        return -EINVAL;
>>>> +    }
>>>> +
>>>> +    return 0;
>>>> +}
>>>> +
>>>>     static void *raid0_takeover_raid45(struct mddev *mddev)
>>>>     {
>>>>         struct md_rdev *rdev;
>>>> @@ -665,6 +693,9 @@ static void *raid0_takeover_raid45(struct mddev
>>>> *mddev)
>>>>             rdev->sectors = mddev->dev_sectors;
>>>>         }
>>>>     +    if (raid0_takeover_check(mddev, mddev->chunk_sectors))
>>>> +        return ERR_PTR(-EINVAL);
>>>> +
>>>>         /* Set new parameters */
>>>>         mddev->new_level = 0;
>>>>         mddev->new_layout = 0;
>>>> @@ -707,6 +738,9 @@ static void *raid0_takeover_raid10(struct mddev
>>>> *mddev)
>>>>             return ERR_PTR(-EINVAL);
>>>>         }
>>>>     +    if (raid0_takeover_check(mddev, mddev->chunk_sectors))
>>>> +        return ERR_PTR(-EINVAL);
>>>> +
>>>>         /* Set new parameters */
>>>>         mddev->new_level = 0;
>>>>         mddev->new_layout = 0;
>>>> @@ -750,6 +784,9 @@ static void *raid0_takeover_raid1(struct mddev
>>>> *mddev)
>>>>             /* array size does not allow a suitable chunk size */
>>>>             return ERR_PTR(-EINVAL);
>>>>     +    if (raid0_takeover_check(mddev, chunksect))
>>>> +        return ERR_PTR(-EINVAL);
>>>> +
>>>>         /* Set new parameters */
>>>>         mddev->new_level = 0;
>>>>         mddev->new_layout = 0;
>>>
>>

