Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEE41426C
	for <linux-raid@vger.kernel.org>; Wed,  5 Mar 2025 01:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741137892; cv=none; b=kma5CrDkY48Iq3zUMz2kSba+Kwl7ZYt7Bm02f4801e4KDODvbUPH+vl0IMUqS/5FSrUkmUaghNVdUmkqL23VGJOoMyw26VVdV4LtTh//+zB5dOU507hVb3ZXwBAPZENwZr48h+ShK33dS7ohm1FbtPcu7W2PRfk8CUW9Fri/Ld8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741137892; c=relaxed/simple;
	bh=4fdK8ZrZ+58JcE7T3Bu+ac5iBqeGMs9JI7Ety2n7Lag=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=a6vMjIkpOSUAtCWt6juuZXYzIOTiN9hutAizyaL+b441ff/7cIFTjBV+JQTuXExz8wzk5aRYl74/w0Ww/vrezWIJoqdPL/S5CfRyOEzg5mPj0dC5hzZaXRbjqtO3LV6hxRGIRCBppoJ+u0be+cLYd0bxlzZBB6yo8a98gI9QFlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Z6vsG4rBrz9w9H;
	Wed,  5 Mar 2025 09:21:38 +0800 (CST)
Received: from kwepemg500011.china.huawei.com (unknown [7.202.181.72])
	by mail.maildlp.com (Postfix) with ESMTPS id 6EFDE140137;
	Wed,  5 Mar 2025 09:24:46 +0800 (CST)
Received: from [10.174.177.167] (10.174.177.167) by
 kwepemg500011.china.huawei.com (7.202.181.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 5 Mar 2025 09:24:45 +0800
Message-ID: <1e97a27a-2b03-ec9f-a137-0fccc9ae8b04@huawei.com>
Date: Wed, 5 Mar 2025 09:24:44 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH] mdadm: Don't set bad_blocks flag when initializing
 metadata
To: Yu Kuai <yukuai1@huaweicloud.com>, Mariusz Tkaczyk
	<mariusz.tkaczyk@linux.intel.com>
CC: <ncroxon@redhat.com>, <linux-raid@vger.kernel.org>, <liubo254@huawei.com>,
	"yukuai (C)" <yukuai3@huawei.com>
References: <d78cbb12-9a9c-7965-db9a-70b4b277f908@huawei.com>
 <42e56670-e595-1c66-208c-40c103262890@huaweicloud.com>
From: Wu Guanghao <wuguanghao3@huawei.com>
In-Reply-To: <42e56670-e595-1c66-208c-40c103262890@huaweicloud.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemg500011.china.huawei.com (7.202.181.72)



在 2025/3/4 20:26, Yu Kuai 写道:
> Hi,
> 
> 在 2025/03/04 14:12, Wu Guanghao 写道:
>> When testing the raid1, I found that adding disk to raid1 fails.
>> Here's how to reproduce it:
>>
>>     1. modprobe brd rd_nr=3 rd_size=524288
>>     2. mdadm -Cv /dev/md0 -l1 -n2 -e1.0 /dev/ram0 /dev/ram1
>>
>>     3. mdadm /dev/md0 -f /dev/ram0
>>     4. mdadm /dev/md0 -r /dev/ram0
>>
>>     5. echo "10000 100" > /sys/block/md0/md/dev-ram1/bad_blocks
>>     6. echo "write_error" > /sys/block/md0/md/dev-ram1/state
>>
>>     7. mkfs.xfs /dev/md0
>>     8. mdadm --examine-badblocks /dev/ram1  # Bad block records can be seen
>>        Bad-blocks on /dev/ram1:
>>                    10000 for 100 sectors
>>
>>     9. mdadm /dev/md0 -a /dev/ram2
>>        mdadm: add new device failed for /dev/ram2 as 2: Invalid argument
> 
> Can you add a new regression test as well?
> 

Yeah, I will add in v2.

>>
>> When adding a disk to a RAID1 array, the metadata is read from the existing
>> member disks for synchronization. However, only the bad_blocks flag are copied,
>> the bad_blocks records are not copied, so the bad_blocks records are all zeros.
>> The kernel function super_1_load() detects bad_blocks flag and reads the
>> bad_blocks record, then sets the bad block using badblocks_set().
>>
>> After the kernel commit 1726c7746("badblocks: improve badblocks_set() for
>> multiple ranges handling"), if the length of a bad_blocks record is 0, it will
>> return a failure. Therefore the device addition will fail.
>>
>> So, don't set the bad_blocks flag when initializing the metadata, kernel can
>> handle it.
>>
>> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
>> ---
>>   super1.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/super1.c b/super1.c
>> index fe3c4c64..03578e5b 100644
>> --- a/super1.c
>> +++ b/super1.c
>> @@ -2139,6 +2139,9 @@ static int write_init_super1(struct supertype *st)
>>           if (raid0_need_layout)
>>               sb->feature_map |= __cpu_to_le32(MD_FEATURE_RAID0_LAYOUT);
>>
>> +        if (sb->feature_map & MD_FEATURE_BAD_BLOCKS)
>> +            sb->feature_map &= ~__cpu_to_le32(MD_FEATURE_BAD_BLOCKS);
> 
> There are also other flags that is per rdev, like MD_FEATURE_REPLACEMENT
> and MD_FEATURE_JOURNAL, they should be excluded as well.
> 
OK， These will be modified in v2.

> Thanks,
> Kuai
> 
>> +
>>           sb->sb_csum = calc_sb_1_csum(sb);
>>           rv = store_super1(st, di->fd);
>>
> 
> .
