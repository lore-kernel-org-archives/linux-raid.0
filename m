Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B3C46B8;
	Thu, 24 Oct 2024 02:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729735836; cv=none; b=N1LzYrHFZT56d3qkYSUHwolQ0zjOuE9nfg04xQW1eap9YpN4PP+fHa+mMnYVIpY1CpeHRQSiF2gt0zp/B2DSpaTXtwINL5vbp4cqoYYTuv9y93b93+XrQe8W7T2GwbksGWmLRVH2dXbAuwTNQgu62ia7Qtid6+JyzwXouCc7IxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729735836; c=relaxed/simple;
	bh=cNgbH2+9NobYVXP1NzqgD2KkxDjkkFHJ2aTMXIzX79s=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=BX1T5s+G9ceJdrR/BZ5Vkhl0KyNzrHW4SG7BLgVNv8sM41goo/trc2m8Ezmw9ETZhJdnsyPaZwVxTTyAYOukp8iWCrqtAwJ+Ty888ssvYhWxMytxSf2dqk7/lFn4ZdAxKn+FWdhhaOBPTQLYaJocYFrgxYZLkeirH4q7us5/Oi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XYqBK5sRTz4f3jkd;
	Thu, 24 Oct 2024 10:10:17 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 29C491A0568;
	Thu, 24 Oct 2024 10:10:30 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCHusaUrBlnUXzOEw--.51256S3;
	Thu, 24 Oct 2024 10:10:29 +0800 (CST)
Subject: Re: [PATCH RFC 5/6] md/raid1: Handle bio_split() errors
To: John Garry <john.g.garry@oracle.com>, Geoff Back <geoff@demonlair.co.uk>,
 Yu Kuai <yukuai1@huaweicloud.com>, axboe@kernel.dk, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, martin.petersen@oracle.com,
 "yangerkun@huawei.com" <yangerkun@huawei.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240919092302.3094725-1-john.g.garry@oracle.com>
 <20240919092302.3094725-6-john.g.garry@oracle.com>
 <bc4c414c-a7aa-358b-71c1-598af05f005f@huaweicloud.com>
 <0161641d-daef-4804-b4d2-4a83f625bc77@oracle.com>
 <c03de5c7-20b8-3973-a843-fc010f121631@huaweicloud.com>
 <44806c6f-d96a-498c-83e1-e3853ee79d5a@oracle.com>
 <59a46919-6c6d-46cb-1fe4-5ded849617e1@huaweicloud.com>
 <6148a744-e62c-45f6-b273-772aaf51a2df@oracle.com>
 <be465913-80c7-762a-51f1-56021aa323dd@huaweicloud.com>
 <0cf7985e-e7ac-4503-827b-eb2a0fd6ef67@oracle.com>
 <098e65e7-53fb-4bf1-b973-2bda425139ae@demonlair.co.uk>
 <5a16f8c2-d868-48cf-96c8-a0d99e440ca5@oracle.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <ea19f2f4-32e8-e551-c59d-19185da1be0a@huaweicloud.com>
Date: Thu, 24 Oct 2024 10:10:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <5a16f8c2-d868-48cf-96c8-a0d99e440ca5@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCHusaUrBlnUXzOEw--.51256S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZF4fuw48tryrWry3Aw17Awb_yoW5ZrW3p3
	y5ta13Kr4DAr95AasrZw4xZ3WFy3y2ya43Grn8Gryq93s8XFySqr4rt3yY9a4rWrnag3Wj
	qFW8GFyDC3s5JFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/10/23 20:11, John Garry 写道:
> On 23/10/2024 12:46, Geoff Back wrote:
>>>> Yes, raid1/raid10 write are the same. If you want to enable atomic 
>>>> write
>>>> for raid1/raid10, you must add a new branch to handle badblocks now,
>>>> otherwise, as long as one copy contain any badblocks, atomic write will
>>>> fail while theoretically I think it can work.
>>> Can you please expand on what you mean by this last sentence, "I think
>>> it can work".

I mean in this case, for the write IO, there is no need to split this IO
for the underlying disks that doesn't have BB, hence atomic write can
still work. Currently solution is to split the IO to the range that all
underlying disks doesn't have BB.

>>>
>>> Indeed, IMO, chance of encountering a device with BBs and supporting
>>> atomic writes is low, so no need to try to make it work (if it were
>>> possible) - I think that we just report EIO.

If you want this, then make sure raid will set fail fast together with
atomic write. This way disk will just faulty with IO error instead of
marking with BB, hence make sure there are no BBs.

>>>
>>> Thanks,
>>> John
>>>
>>>
>> Hi all,
>>
>> Looking at this from a different angle: what does the bad blocks system
>> actually gain in modern environments?  All the physical storage devices
>> I can think of (including all HDDs and SSDs, NVME or otherwise) have
>> internal mechanisms for remapping faulty blocks, and therefore
>> unrecoverable blocks don't become visible to the Linux kernel level
>> until after the physical storage device has exhausted its internal
>> supply of replacement blocks.  At that point the physical device is
>> already catastrophically failing, and in the case of SSDs will likely
>> have already transitioned to a read-only state.  Using bad-blocks at the
>> kernel level to map around additional faulty blocks at this point does
>> not seem to me to have any benefit, and the device is unlikely to be
>> even marginally usable for any useful length of time at that point 
>> anyway.
>>
>> It seems to me that the bad-blocks capability is a legacy from the
>> distant past when HDDs did not do internal block remapping and hence the
>> kernel could usefully keep a disk usable by mapping out individual
>> blocks in software.
>> If this is the case and there isn't some other way that bad-blocks is
>> still beneficial, might it be better to drop it altogether rather than
>> implementing complex code to work around its effects?

No, we can't just kill it, unless all the disks behaves like:

never return IO error if the disk is still accessible, and once IO error
is returned, the disk is totally unusable.(This is what failfast means
in raid).

Thanks,
Kuai

> 
> I am not proposing to drop it. That is another topic.
> 
> I am just saying that I don't expect BBs for a device which supports 
> atomic writes. As such, the solution for that case is simple - for an 
> atomic write which cover BBs in any rdev, then just error that write.
> 
>>
>> Of course I'm happy to be corrected if there's still a real benefit to
>> having it, just because I can't see one doesn't mean there isn't one.
> 
> I don't know if there is really a BB support benefit for modern devices 
> at all.
> 
> Thanks,
> John
> 
> 
> .
> 

