Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D714427FD5D
	for <linux-raid@vger.kernel.org>; Mon, 29 Sep 2025 09:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759136773; cv=none; b=loZw19TPy2VnXh0xjKsAqFUgbnQ63ourukEahLR+zGzcP8YB8bNEh73bYzpmlFhZ3xBMKbnXU3fYjeOzsP2BvlnbAdYH77czaU/8DJbjElT1JA2NeRVQ7d/XSr9lgMotMefL5NL8aqrrTx4fVpxrhH4kDFv7xdXE9fnMzeab7Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759136773; c=relaxed/simple;
	bh=h20zga2nnwLDKD8XyAhIXSHzNVlupUyq0eKdA9B4hYM=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=k9/9wh2Ug8FNIzyzzfZ3Cc5l3KATJgtol3kt9bXVsjTX6Z8BR2keEWTrKJPlw2geHC6jCd9glBO6TbQeeO+/ajC1tN5zNr2mB/vN0TkHDMXsyGl7g5nFYuXAijuVW/ELr2j7BkaHsY0EzqLB5Zs3HvKaarphe7W4+lfrs/rZnvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cZwJp6tPgzYQvBD
	for <linux-raid@vger.kernel.org>; Mon, 29 Sep 2025 17:05:46 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A1D921A1440
	for <linux-raid@vger.kernel.org>; Mon, 29 Sep 2025 17:06:02 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgD3CGH4S9potwHPBA--.8S3;
	Mon, 29 Sep 2025 17:06:02 +0800 (CST)
Subject: Re: [PATCH RFC] md: disable atomic writes if any bad blocks found
To: Li Nan <linan666@huaweicloud.com>, John Garry <john.g.garry@oracle.com>,
 song@kernel.org, hch@lst.de
Cc: linux-raid@vger.kernel.org, martin.petersen@oracle.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250926125825.3015322-1-john.g.garry@oracle.com>
 <035a04da-7663-e9f3-fc05-3b84ec2554e5@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <1a548dd4-50f4-4332-977e-c29a2fb68194@huaweicloud.com>
Date: Mon, 29 Sep 2025 17:06:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <035a04da-7663-e9f3-fc05-3b84ec2554e5@huaweicloud.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3CGH4S9potwHPBA--.8S3
X-Coremail-Antispam: 1UD129KBjvJXoW7uFy7AFy5KFy8uryDWF1xZrb_yoW8Aw1fpF
	ZrJ345KrsFgF1293WDZ3WxCw1rKw4kAFWSqw4rGryUW34DWw1xtFs2gryFvFyjvr1ft3s0
	qw45Wry7Wr95KaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
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
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUBVbkUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/09/28 15:13, Li Nan 写道:
> 
> 
> 在 2025/9/26 20:58, John Garry 写道:
>> RAID1 and RAID10 personalities support bad blocks management. In handling
>> read or writing from a region which has bad blocks, the read and write 
>> bio
>> is split as to not access the bad block sectors.
>>
>> Splitting of writes is not allowed for atomic writes. As such, bad blocks
>> are incompatible with atomic writes. If an atomic write ever occurs over
>> a region which has bad blocks, then the write is rejected.
>>
>> It is not ever expected in practice that we will ever see devices which
>> support atomic writes and also require bad block kernel support. However
>> it is not proper to say that atomic writes are supported for a device
>> which actually has bad blocks.
>>
>> md maintains a persistent feature flag to say whether bad block 
>> management
>> is active on the array, MD_FEATURE_BAD_BLOCKS.
>>
> 
> MD_FEATURE_BAD_BLOCKS is not set at RAID creation time. It is set later if
> badblocks recorded due to read/write error. Therefore, checking it at
> creation time does not work.

Yes, this flag just indicate if there are already badblocks records, and
AFAIK, badblocks is always enabled by default, and user space tools
doesn't support to disable it for now, no-bbl and force-no-bbl option is
just use to clear badblocks records.
> 
> If badblocks is disabled, devices that have been recorded badblocks will be
> marked Faulty and kicked out of the array, becoming unreadable and
> unwritable. That outcome is worse than a single atomic write failing — is
> this the expected behavior?
> 

Yes, I think we want to create the array with badblocks disabled, not
disable it for a created array. John just want to disabled atomic writes
if there is badblocks, I think it's fine as well.

Thanks,
Kuai

