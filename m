Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E5B19E98E;
	Mon,  2 Sep 2024 12:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725280653; cv=none; b=mde7daXhVO7BF03hYpmbvWoft5HO8C5AZoxFQRSvrvCMogLzd3z2l/+NvVLDqEqVgMjwMUpy/PKg2wuSWySdchH4JThnxMUMpO7HsFqxZu/XEfITxhrdPEmuJ5j1eQ4B9phOdcea0Dws+Sn3x58Qi/2PMNbsUJYt7ZzpPaZAjSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725280653; c=relaxed/simple;
	bh=ndZB4etJas4dKkxxuzhbNLrh6RPaMuLCbVWOGFDUQKs=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=d+eVevQTN9ZQC64uQkN3RXeiJwQ8vmXUuV70YTvAQLOOUvl164hw9JYLgLQfntTZ3DvY1qVoq+I+/dLaS0vucooHVEdS/B79z4nmQcV3PsE/N3KIyVeYcrrtdpmJrfD6OdDCW37sm+a3yWmxj4TtV8706J/5ACCd4ffh0G0n2Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Wy7Yh70Ypz4f3jM9;
	Mon,  2 Sep 2024 20:37:12 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id DA4291A14A0;
	Mon,  2 Sep 2024 20:37:27 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgAnXMiEsdVmMBm_AA--.24651S3;
	Mon, 02 Sep 2024 20:37:26 +0800 (CST)
Subject: Re: [PATCH md-6.12 3/7] md: don't record new badblocks for faulty
 rdev
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
 Yu Kuai <yukuai1@huaweicloud.com>
Cc: mariusz.tkaczyk@intel.com, song@kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240830072721.2112006-1-yukuai1@huaweicloud.com>
 <20240830072721.2112006-4-yukuai1@huaweicloud.com>
 <20240830122831.0000127d@linux.intel.com>
 <c9af88ac-111e-19a2-b135-d2a379ed23fc@huaweicloud.com>
 <20240902105539.00007655@linux.intel.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <f704a35f-bb4c-67d5-e32e-37bed99a1f9e@huaweicloud.com>
Date: Mon, 2 Sep 2024 20:37:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240902105539.00007655@linux.intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAnXMiEsdVmMBm_AA--.24651S3
X-Coremail-Antispam: 1UD129KBjvJXoWxCw43JrykuFWkKFW5Wry3Arb_yoW5GFW3pF
	WfJFW3CF4DWr17Zw10vw1xJa4F934vgr48Xry3W34UGas0yryfWw4kKw4Y9ry09r9xWan8
	ZF48Ka4fZa4kX37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
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

在 2024/09/02 16:55, Mariusz Tkaczyk 写道:
> On Sat, 31 Aug 2024 09:14:39 +0800
> Yu Kuai <yukuai1@huaweicloud.com> wrote:
> 
>> Hi,
>>
>> 在 2024/08/30 18:28, Mariusz Tkaczyk 写道:
>>> On Fri, 30 Aug 2024 15:27:17 +0800
>>> Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>>    
>>>> From: Yu Kuai <yukuai3@huawei.com>
>>>>
>>>> Faulty will be checked before issuing IO to the rdev, however, rdev can
>>>> be faulty at any time, hence it's possible that rdev_set_badblocks()
>>>> will be called for faulty rdev. In this case, mddev->sb_flags will be
>>>> set and some other path can be blocked by updating super block.
>>>>
>>>> Since faulty rdev will not be accesed anymore, there is no need to
>>>> record new babblocks for faulty rdev and forcing updating super block.
>>>>
>>>> Noted this is not a bugfix, just prevent updating superblock in some
>>>> corner cases, and will help to slice a bug related to external
>>>> metadata[1].
>>>>
>>>> [1]
>>>> https://lore.kernel.org/all/f34452df-810b-48b2-a9b4-7f925699a9e7@linux.intel.com/
>>>>
>>>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>>>> ---
>>>>    drivers/md/md.c | 4 ++++
>>>>    1 file changed, 4 insertions(+)
>>>>
>>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>>> index 675d89597c7b..a3f7f407fe42 100644
>>>> --- a/drivers/md/md.c
>>>> +++ b/drivers/md/md.c
>>>> @@ -9757,6 +9757,10 @@ int rdev_set_badblocks(struct md_rdev *rdev,
>>>> sector_t s, int sectors, {
>>>>    	struct mddev *mddev = rdev->mddev;
>>>>    	int rv;
>>>> +
>>>> +	if (test_bit(Faulty, &rdev->flags))
>>>> +		return 1;
>>>> +
>>>
>>> Blame is volatile, this is why we need a comment here :)
>>> Otherwise, someone may remove that.
>>
>> Perhaps something like following?
>>
>> /*
>>    * record new babblocks for faulty rdev will force unnecessary
>>    * super block updating.
>>    */
>>
> 
> Almost, we need to refer to external context because this is important to
> mention where to expect issues:
> 
> /*
>   * Recording new badblocks for faulty rdev will force unnecessary
>   * super block updating. This is fragile for external management because
>   * userspace daemon may trying to remove this device and deadlock may
>   * occur. This will be probably solved in the mdadm, but it is safer to avoid
>   * it.
>   */
> 
> In my testing, I observed that it improves failing bios and device removal
> path (recording badblock is simply expensive if there are many badblocks) so
> the devices are removed faster but I don't have data here, this is what I saw.

I'll mention this in the commit message, and add the above comment in
v2.

Thanks,
Kuai

> 
> Obviously, it is optimization.
> 
> Mariusz
> 
> .
> 

