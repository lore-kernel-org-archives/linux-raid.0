Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48EFD23D7C0
	for <linux-raid@vger.kernel.org>; Thu,  9 Oct 2025 03:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759982097; cv=none; b=XbkO5JSHk9qLbjrypJEwAPdmaRZl10+CYx1hfqKOiHOGGNBI0hOfUC6WjNplgT/Mgxd051WEqgGJsIH/Im8h2Z4fykrJo6SadPDp0EbpmZCUSafbTFQY+S1nrGtywh5A7LJ1UMa2ouiQjxa21Kg86NGgLlvtJzykseyUZRr/pr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759982097; c=relaxed/simple;
	bh=XcpFAWRDNVqYqgmIDDueIXpDwAfKS6zl3Jmzk+Acx2A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qUXuDEVAuRocJBX0zOzgfIZ4AAhzvnNG1A8zV0a25ee/8kx/rqZohnLGueWnRMms2aO4RdCsVZkRgSJetF/LJ5ksWmGEHkCU1Coilq3/q6CtDkW8EYHxhC+FaKsmqeEc8Qa5nYC942y8JJPrHBpy8BmK719FLlrKTeRioZ3b41c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4chwwv2tflzKHLy3
	for <linux-raid@vger.kernel.org>; Thu,  9 Oct 2025 11:54:23 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id AF3B21A01A6
	for <linux-raid@vger.kernel.org>; Thu,  9 Oct 2025 11:54:51 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgCna2MKMudoUkwoCQ--.34995S3;
	Thu, 09 Oct 2025 11:54:51 +0800 (CST)
Message-ID: <5223b88d-3003-9e3a-d16d-e1adf89eb421@huaweicloud.com>
Date: Thu, 9 Oct 2025 11:54:50 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] md: don't add empty badblocks record table in
 super_1_load()
To: Coly Li <colyli@fnnas.com>, Li Nan <linan666@huaweicloud.com>
Cc: linux-raid@vger.kernel.org
References: <20251005162159.25864-1-colyli@fnnas.com>
 <8b51544b-8ca0-3879-f878-e8bd42aaa148@huaweicloud.com>
 <j5b7kihtnmlnvnb3lqv6hcluvfex2ynk5nbnqhrvwu2yag4gbp@y5iaoqx5h2rw>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <j5b7kihtnmlnvnb3lqv6hcluvfex2ynk5nbnqhrvwu2yag4gbp@y5iaoqx5h2rw>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCna2MKMudoUkwoCQ--.34995S3
X-Coremail-Antispam: 1UD129KBjvJXoW7uw4UGr18Zw4rWFWfCr45KFg_yoW8Kw1rpr
	WDJFyayrZ7Xr1UuwnFvw48KFyF9397tF4DW3y5Aw1rur9ayr1fJF10qFyruFyqgF4ftFs2
	qa15Wasava4rGaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v
	4I1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_Jrv_JF1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUb0PfJUUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/10/9 10:59, Coly Li 写道:
> On Thu, Oct 09, 2025 at 10:18:59AM +0800, Li Nan wrote:
>>
>>
>> 在 2025/10/6 0:21, colyli@fnnas.com 写道:
>>> From: Coly Li <colyli@fnnas.com>
>>>
>>> In super_1_load() when badblocks table is loaded from component disk,
>>> current code adds all records including empty ones into in-memory
>>> badblocks table. Because empty record's sectors count is 0, calling
>>> badblocks_set() with parameter sectors=0 will return -EINVAL. This isn't
>>> expected behavior and adding a correct component disk into the array
>>> will incorrectly fail.
>>>
>>> This patch fixes the issue by checking the badblock record before call-
>>> ing badblocks_set(). If this badblock record is empty (bb == 0), then
>>> skip this one and continue to try next bad record.
>>>
>>> Signed-off-by: Coly Li <colyli@fnnas.com>
>>> ---
>>>    drivers/md/md.c | 11 ++++++++---
>>>    1 file changed, 8 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>> index 41c476b40c7a..b4b5799b4f9f 100644
>>> --- a/drivers/md/md.c
>>> +++ b/drivers/md/md.c
>>> @@ -1873,9 +1873,14 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
>>>    		bbp = (__le64 *)page_address(rdev->bb_page);
>>>    		rdev->badblocks.shift = sb->bblog_shift;
>>>    		for (i = 0 ; i < (sectors << (9-3)) ; i++, bbp++) {
>>> -			u64 bb = le64_to_cpu(*bbp);
>>> -			int count = bb & (0x3ff);
>>> -			u64 sector = bb >> 10;
>>> +			u64 bb, sector;
>>> +			int count;
>>> +
>>> +			bb = le64_to_cpu(*bbp);
>>> +			if (bb == 0)
>>> +				continue;
>>
>> Can we just break:
>>
>>     			if (bb + 1 == 0 || bb == 0)
>> 				break;
>>
> 
> I just realized even the badblock feature bit is set, it is also possible to
> have empty or cleared badblock record in the badblock table. So ignore the
> empty record is necessary.
> 
> An empty record could appear in any location inside the badblock table, ignore
> it by 'continue' is correct. If there is available badblock record after this
> empty record, 'break' will lose the available and non-empty record.
> 

I'm not sure how an empty record can occur, as the commit log says:

 > calling badblocks_set() with parameter sectors=0 will return -EINVAL

>> Otherwise LGTM.
> 
> Thanks for the review.
>>
>>> +			count = bb & (0x3ff);
>>> +			sector = bb >> 10;
>>>    			sector <<= sb->bblog_shift;
>>>    			count <<= sb->bblog_shift;
>>>    			if (bb + 1 == 0)
> 
> Coly Li
> 
> .

-- 
Thanks,
Nan

