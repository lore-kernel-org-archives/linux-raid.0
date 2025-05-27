Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A7B24A05D;
	Tue, 27 May 2025 08:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748332825; cv=none; b=tk0nf2IyGwCNFr13QJ64u5ZhWOpkj+KF0Lnz/Bd0/dlygIwxxQGxIjMomoqFvvd5n8ZxdDf5hJwaw3z+sDzfqo5qVxk3rGAUe+5c6YOhE5TrSf2Lu2mUAnkKf67Gm+GS2WLKSVxAlw+D2QKH9ZNp88OldQkhzUKPXK+RsL7bi3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748332825; c=relaxed/simple;
	bh=r8RDJjk6vpZqacJc4pUOWihZY636pGcpae8WpRMJJlg=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=rsefPZUZxF3SjLPhcefZ2DZAgvfuEJ6rfD1DkkoM+C9jYqlRoblNrkMwGO85hZxSlOUdsnfHOX4hZg010Au4Lv9W4TXrkB29zRvnK3lQHE2PidoEDswaDH2FibyUc8VW0hvmLq3jpyF/NI+kgjZD/qSC6PYJuetTtmr4Qm6U2i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4b64mz10dxzYQv8P;
	Tue, 27 May 2025 16:00:19 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 434CA1A07E8;
	Tue, 27 May 2025 16:00:18 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgAHa18QcTVoZ9udNg--.29916S3;
	Tue, 27 May 2025 16:00:18 +0800 (CST)
Subject: Re: [PATCH 10/23] md: add a new recovery_flag
 MD_RECOVERY_LAZY_RECOVER
To: Hannes Reinecke <hare@suse.de>, Yu Kuai <yukuai1@huaweicloud.com>,
 hch@lst.de, xni@redhat.com, colyli@kernel.org, song@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-11-yukuai1@huaweicloud.com>
 <d41f0296-45b9-4264-adc8-f41601b36edd@suse.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <2c120387-cf9e-23e5-9442-ffcf320cf611@huaweicloud.com>
Date: Tue, 27 May 2025 16:00:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <d41f0296-45b9-4264-adc8-f41601b36edd@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHa18QcTVoZ9udNg--.29916S3
X-Coremail-Antispam: 1UD129KBjvdXoW7Xry5GF4rAF4fGr1UWFyfWFg_yoWkAFXE9a
	1DZa47Ww15GF4Sy3ZIyr13urW09r4UW34YqFW3tr1rJryDJr9xXF1rArZYvw1kGa90kanr
	A397ZrWxCrsFgjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbfAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7V
	AKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
	0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VU13ku3UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/05/27 14:17, Hannes Reinecke 写道:
> On 5/24/25 08:13, Yu Kuai wrote:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> This flag is used by llbitmap in later patches to skip raid456 initial
>> recover and delay building initial xor data to first write.
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> ---
>>   drivers/md/md.c | 12 +++++++++++-
>>   drivers/md/md.h |  2 ++
>>   2 files changed, 13 insertions(+), 1 deletion(-)
>>
> Wouldn't it be enough to check for the 'blocks_synced' callback to check
> if the array supports lazy recovery?

I think no, just to check the array supports lazy recovery is not
enough, we still have to distinguish the normal recovery and the lazy
recovery by new bitmap. For example:

+		if (test_bit(MD_RECOVERY_LAZY_RECOVER, &mddev->recovery) &&
+		    start == MaxSector)
+			start = 0;

For normal recovery, there is nothing to do, and for lazy recovery,
we'll register a new sync_thread later to recover bits that are
written the first time.

Thanks,
Kuai

> 
> Otherwise:
> 
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> 
> Cheers,
> 
> Hannes

