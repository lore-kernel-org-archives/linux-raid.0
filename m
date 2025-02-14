Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21737081C;
	Fri, 14 Feb 2025 01:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739497243; cv=none; b=AjKzKgQbdYEP49hutJCH8H7TRMcXXi+R3PTddR0oAOeqs/alUsCogyUk/T3c8VDkbAcQTY3q/DGC46siRYQMBpMKBucvQC+o2XMWchGWB5fkjZPlDBttpVTTBTXzE4cg3MvYZ518tJLWgh59jdOhyUVG2GQeoWDHxaB6lc4T+nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739497243; c=relaxed/simple;
	bh=wKGJ6tYO+q7krcwCE2/HrveI7k4utcJIlrtLvxwlA+c=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ePSWkXgP2AAk5yZljFc3nB9I6KGVNzJNX+pOZg1OqRcP7Ey788zI31FB+KCLCCL0LSCNEmrSQUL/HCgO6xtidZQz6NAYG4fhuMjtfiW6P99Qh2LXlgySHHEodXaCipBQPqsR1FWAVqrTb0Ycy3k2k8K2vrTuQg4PrUbobygmajM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4YvF9W5SPRz4f3l2K;
	Fri, 14 Feb 2025 09:40:15 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 2868E1A154E;
	Fri, 14 Feb 2025 09:40:37 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDnSl8Tn65nCm4iDw--.24175S3;
	Fri, 14 Feb 2025 09:40:36 +0800 (CST)
Subject: Re: [PATCH] md: ensure resync is prioritized over recovery
To: Yu Kuai <yukuai1@huaweicloud.com>, linan666@huaweicloud.com,
 song@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yangerkun@huawei.com, zhangxiaoxu5@huawei.com, wanghai38@huawei.co,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250213131530.3698600-1-linan666@huaweicloud.com>
 <0c3dc2bb-c879-b58c-c7a3-b71618e7718d@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <e33da443-051a-d656-69b5-4b21407a344f@huaweicloud.com>
Date: Fri, 14 Feb 2025 09:40:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <0c3dc2bb-c879-b58c-c7a3-b71618e7718d@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDnSl8Tn65nCm4iDw--.24175S3
X-Coremail-Antispam: 1UD129KBjvdXoWrtryrXryDCFW8ur4xJw4fZrb_yoWfAwb_Aa
	1qya4fG3yxKa1IvF45urs3XrW09r47C34DCF1YgrW5X3y5JFW7GF4rKrZ8Xw1rWFs5Cw45
	X3yDWFW3Z39rKjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbVkFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
	1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
	b7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
	vE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUbGQ6JUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

在 2025/02/14 9:11, Yu Kuai 写道:
> 
> 在 2025/02/13 21:15, linan666@huaweicloud.com 写道:
>> From: Li Nan <linan122@huawei.com>
>>
>> If a new disk is added during resync, the resync process is interrupted,
>> and recovery is triggered, causing the previous resync to be lost. In
>> reality, disk addition should not terminate resync, fix it.
>>
>> Steps to reproduce the issue:
>>    mdadm -CR /dev/md0 -l1 -n3 -x1 /dev/sd[abcd]
>>    mdadm --fail /dev/md0 /dev/sdc
>>
>> Signed-off-by: Li Nan <linan122@huawei.com>
>> ---
>>   drivers/md/md.c | 14 +++++++-------
>>   1 file changed, 7 insertions(+), 7 deletions(-)
>> [...]
> 
> Applied to md-6.14, thanks!

I'm trying to find a fixtag, looks like following patch that is 20 years
ago. Or earlier :(

24dd469d728d ("[PATCH] md: allow a manual resync with md")

I'll move this patch to md-6.15 with this fixtag, thanks!

Kuai

> 
> Kuai
> 
> .
> 

