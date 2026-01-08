Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EBF136351;
	Thu,  8 Jan 2026 03:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767843083; cv=none; b=l6EYyDTmowlG81ow5+L5+HKeiiiTVBpvBSEO14W1dMMcZKS/+0W8A4GERNrJfXua+oxbBXjkzLbc+Wyr+FomycFOSxoNBCk7MMR8P5jE3YPOBjgFEIKDYNo8mUJLAieB1SDxdy9okyqk+0QYX06/eS9VW/co3GYq+Kogc3XpI7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767843083; c=relaxed/simple;
	bh=++RExKdcmoYZnx2vs3zO8w67KwHD6Pc/fdhZIbE7590=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JZF0sEw+I6/n2b+1csdrIbD1eN8rkKSiHwJfVPxy8jNziBZ7BYuLZzWTcR1m+YajOtuwrCz8sZ0VV1dPhBxd8Q5aKCTIFxc/Hjq/ayyeppmTneostbYtJtvYXo3Xd00uT8qQK6wgq5y1pGlTKkUYDcoadAYrqLU0IJ5+gllUbOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dmr5R1d2WzKHMN2;
	Thu,  8 Jan 2026 11:30:35 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 732874057B;
	Thu,  8 Jan 2026 11:31:17 +0800 (CST)
Received: from [10.174.178.72] (unknown [10.174.178.72])
	by APP4 (Coremail) with SMTP id gCh0CgAHZ_cDJV9pvhwbDA--.41038S3;
	Thu, 08 Jan 2026 11:31:17 +0800 (CST)
Message-ID: <d648e6f0-ad19-4428-9e0d-f6ce609faacf@huaweicloud.com>
Date: Thu, 8 Jan 2026 11:31:13 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/5] md: add helpers for requested sync action
To: Li Nan <linan666@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, houtao1@huawei.com,
 linan122@h-partners.com, Song Liu <song@kernel.org>, yukuai@fnnas.com,
 zhengqixing@huawei.com
References: <20251231070952.1233903-1-zhengqixing@huaweicloud.com>
 <20251231070952.1233903-2-zhengqixing@huaweicloud.com>
 <3b5e935b-0a1b-bf23-8ceb-b45e0b5f1b4b@huaweicloud.com>
From: Zheng Qixing <zhengqixing@huaweicloud.com>
In-Reply-To: <3b5e935b-0a1b-bf23-8ceb-b45e0b5f1b4b@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHZ_cDJV9pvhwbDA--.41038S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Aw45XFWfJFyUKr1fAFyrZwb_yoW8Zr4Dpr
	Z5tF4qkrWUGr1fJFWUtFyDAFWIvr17J3sFvryxWa48JrsIkr1v9F1YqF1q9ryvyr48Xr1Y
	vas8WF43ZF13CrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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


在 2026/1/6 20:59, Li Nan 写道:
>>
>> +
>> +static int handle_requested_sync_action(struct mddev *mddev,
>> +                    enum sync_action action)
>> +{
>> +    if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
>> +        return -EBUSY;
>
> This return change origin logic; split factor out and fix into two 
> patches.

Make sense to me.

>
>> +    return __handle_requested_sync_action(mddev, action);
>> +}
>> +
>
> __handle_requested_sync_action does not need to be split.
>
>> +static enum sync_action __get_recovery_sync_action(struct mddev *mddev)
>> +{
>> +    if (test_bit(MD_RECOVERY_CHECK, &mddev->recovery))
>> +        return ACTION_CHECK;
>> +    if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
>> +        return ACTION_REPAIR;
>> +    return ACTION_RESYNC;
>> +}
>> +
>> +static enum sync_action get_recovery_sync_action(struct mddev *mddev)
>> +{
>> +    return __get_recovery_sync_action(mddev);
>> +}
>> +
>
> __get_recovery_sync_action also does not need to be split.
>
Okay.
>
>> +static void init_recovery_position(struct mddev *mddev)
>> +{
>> +    mddev->resync_min = 0;
>> +}
>> +
>> +static void set_requested_position(struct mddev *mddev, sector_t value)
>> +{
>> +    mddev->resync_min = value;
>> +}
>> +
>> +static sector_t get_requested_position(struct mddev *mddev)
>> +{
>> +    return mddev->resync_min;
>> +}
>> +
>
> There is no need to factor the operations of resync_min;
> 'rectify_min' that follows can re-use 'resync_min' directly.
>
If we share resync_min with check/repair, bad blocks may be missed

during repair:

When check/repair is halfway through execution and then frozen,

followed by a rectify operation, any bad blocks that exist before

resync_min will not be repaired. This would require an additional

rectify operation.


Thanks,

Qixing

