Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3D133987;
	Tue, 23 Sep 2025 00:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758588200; cv=none; b=qVe05l4eHHw8lxZa0K0N3aQFQbDTleHcpbgPe2xL4DoVumfJYOBnGW5Kv2lC+UEBtDEm9t/yyDSqkShv8bwNoBrHtY3ENpHaDKF7bzzgg8AASo/wMqM2U6u4S7l1QsDCK8SwLObPz0BHy++45nBXRcL8PnDlWctdkk4JnIyhpmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758588200; c=relaxed/simple;
	bh=HE5mfb0LAC8q603gD5bfhbi27Q1T9M8MUnpbGnPCGu4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=oXMuLj0uIVMDrFoIjXavrYpPPUu2BYMIIgdT4qRuJNsI3fWzoY3yk4wAWvjXFun1bZSTfMEMhwEo2TFKrAyJdpInrdnSt1mdOW+fwcmySf7sIxsVJXJ1t9ogAlLQP3R2S+Ep1LUjGYZnAeH16r3UXLQQO+5VFKzt8te3dCgD22U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cW1Rb0VBYzYQtv3;
	Tue, 23 Sep 2025 08:43:07 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 315571A155D;
	Tue, 23 Sep 2025 08:43:12 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDn+GAe7dFoNdsCAg--.10273S3;
	Tue, 23 Sep 2025 08:43:12 +0800 (CST)
Subject: Re: [PATCH] md raid: fix hang when stopping arrays with metadata
 through dm-raid
To: Heinz Mauelshagen <heinzm@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <cover.1758201368.git.heinzm@redhat.com>
 <b58dddf537d5aa7519670a4df5838e7056a37c2a.1758201368.git.heinzm@redhat.com>
 <7df6e7be-0fd1-0277-038e-3cc4efe5bf9b@huaweicloud.com>
 <CAM23Vxp0wKNvo2+SvfEny+-BubGxebyErCiKR31G8HyA=9DH6g@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <414ae6e0-604a-f4d3-d7ce-260bd8564927@huaweicloud.com>
Date: Tue, 23 Sep 2025 08:43:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAM23Vxp0wKNvo2+SvfEny+-BubGxebyErCiKR31G8HyA=9DH6g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDn+GAe7dFoNdsCAg--.10273S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXFykZrWrArWxGFWxtr4DXFb_yoW5Zw1Up3
	97K3WYkr4DXry5KwnFvF4vgFyrtFn2krZaqr17Cw1fCw1qqFn3GFWYgF4ru34qv34kAw4I
	vw45trW3WF9YvFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUbSfO7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/09/22 21:32, Heinz Mauelshagen 写道:
> Hi Kuai,
> 
> you're right, it should be flushed in the dm-raid's raid_postsuspend()
> function by calling md_stop_writes() when upstack I/O is quiesced already.
> So we can't use mddev_is_dm() in __md_stop_writes() as it prevents flushing
> the bitmap with the current patch.
> 
> md_is_rdwr() looks is the appropriate condition, i.e. when true flush, when
> false, don't.
> 
> If md_is_rdwr() is ok for that logic, I'll create another patch leaving it
> true in postsuspend and false in the destructor call to md_stop() from
> dm-raid.
> 
> Thoughts?
> 
Yeah, this sounds correct.

Thanks,
Kuai

> - lvmguy
> 
> 
> On Mon, Sep 22, 2025 at 3:09 AM Yu Kuai <yukuai1@huaweicloud.com> wrote:
> 
>> Hi,
>>
>> 在 2025/09/18 21:42, Heinz Mauelshagen 写道:
>>> When using device-mapper's dm-raid target, stopping a RAID array can
>> cause the
>>> system to hang under specific conditions.
>>>
>>> This occurs when:
>>>
>>> -  A dm-raid managed device tree is suspended from top to bottom
>>>      (the top-level RAID device is suspended first, followed by its
>>>       underlying metadata and data devices)
>>>
>>> -  The top-level RAID device is then removed
>>>
>>> The hang happens because removing the top-level device triggers
>> md_stop() from the
>>> dm-raid destructor.  This function attempts to flush the write-intent
>> bitmap, which
>>> requires writing bitmap superblocks to the metadata sub-devices.
>> However, since
>>> these metadata devices are already suspended, the write operations
>> cannot complete,
>>> causing the system to hang.
>>>
>>> Fix:
>>>
>>> -  Prevent bitmap flushing when md_stop() is called from dm-raid contexts
>>>      and avoid a quiescing/unquescing cycle which could also cause I/O
>>
>> If bitmap flush is skipped, then bitmap can still be dirty after dm-raid
>> is stopped, and the next time when dm-raid is reloaded, looks like there
>> will be unnecessary data resync because there are dirty bits?
>>
>> Thanks,
>> Kuai
>>
>>>
>>> -  Avoid any I/O operations that might occur during the
>> quiesce/unquiesce process in md_stop()
>>>
>>> This ensures that RAID array teardown can complete successfully even
>> when the
>>> underlying devices are in a suspended state.
>>>
>>> Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
>>> ---
>>>    drivers/md/md.c | 12 +++++++-----
>>>    1 file changed, 7 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>> index 4e033c26fdd4..53e15bdd9ab2 100644
>>> --- a/drivers/md/md.c
>>> +++ b/drivers/md/md.c
>>> @@ -6541,12 +6541,14 @@ static void __md_stop_writes(struct mddev *mddev)
>>>    {
>>>        timer_delete_sync(&mddev->safemode_timer);
>>>
>>> -     if (mddev->pers && mddev->pers->quiesce) {
>>> -             mddev->pers->quiesce(mddev, 1);
>>> -             mddev->pers->quiesce(mddev, 0);
>>> -     }
>>> +     if (!mddev_is_dm(mddev)) {
>>> +             if (mddev->pers && mddev->pers->quiesce) {
>>> +                     mddev->pers->quiesce(mddev, 1);
>>> +                     mddev->pers->quiesce(mddev, 0);
>>> +             }
>>>
>>> -     mddev->bitmap_ops->flush(mddev);
>>> +             mddev->bitmap_ops->flush(mddev);
>>> +     }
>>>
>>>        if (md_is_rdwr(mddev) &&
>>>            ((!mddev->in_sync && !mddev_is_clustered(mddev)) ||
>>>
>>
>>
> 

