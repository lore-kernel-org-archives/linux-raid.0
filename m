Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66F222FF2B;
	Mon,  7 Apr 2025 11:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744025152; cv=none; b=RpAtjYkHcguWxb56Pe2W9wQ3iU43vTu1TtSqdjGrdr5cxdaO7LgvcrV7GlQfGDGEjqDaN2CGl4flFYVW7p8C1t3MqwphRi5enXW+xG/+vwJGwOobyB2UwH7eqmOZrPgPPznIO4MiEAPU8pg9WeQwrnFTl5X8KKyXvJqDoItUO+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744025152; c=relaxed/simple;
	bh=9lfVYwaGB5Ix4SRhjWAJHjlYC3VmoMPXG7TqKuhJoN8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DcGsICAgiQ0te27gZaNd5ovAkggMYRCmbTNIZzgzHOIVrdMCoJk9LGwOpC7CMkrtr2TrNgbBxbbj/2nCvwAOpffE7b9NKxHanCbVAgyln5tfbQ160+oDpe5r1u9PxcUilUJn49QCcyni7wd7I1jzHNc5/BbBsBRcGCikCWcOSNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZWRhc1vd6z4f3m6j;
	Mon,  7 Apr 2025 19:25:20 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 2DB601A01A5;
	Mon,  7 Apr 2025 19:25:45 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP4 (Coremail) with SMTP id gCh0CgCH6181tvNniAYcIw--.43994S3;
	Mon, 07 Apr 2025 19:25:44 +0800 (CST)
Message-ID: <2e030fad-7f46-6fab-faa3-9727835f02ee@huaweicloud.com>
Date: Mon, 7 Apr 2025 19:25:41 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 1/4] block: factor out a helper to set logical/physical
 block size
To: Bart Van Assche <bvanassche@acm.org>, linan666@huaweicloud.com,
 axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hare@suse.de,
 martin.petersen@oracle.com
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, wanghai38@huawei.com
References: <20250304121918.3159388-1-linan666@huaweicloud.com>
 <20250304121918.3159388-2-linan666@huaweicloud.com>
 <2ca75746-c630-4a15-bf5d-e9cb10b6e83c@acm.org>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <2ca75746-c630-4a15-bf5d-e9cb10b6e83c@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCH6181tvNniAYcIw--.43994S3
X-Coremail-Antispam: 1UD129KBjvdXoWruFWUKrWUGry5uF4UZw13urg_yoW3KwbEq3
	Z7JFs2yr42vF1Sv3WxCF4ftFWrKa10gr9rZa1UGw47X3s5JF4kGF1kt398WFZ8XayrZr9Y
	gr1ku3y8Gw4aqjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbqxFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIF
	xwACI402YVCY1x02628vn2kIc2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14
	v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8C
	rVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8Zw
	CIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x02
	67AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr
	0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbQV
	y7UUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

Hi, Bart:

Apologies for the delayed response.

在 2025/3/4 22:32, Bart Van Assche 写道:
> On 3/4/25 4:19 AM, linan666@huaweicloud.com wrote:
>> +EXPORT_SYMBOL(blk_set_block_size);
> 
> This function is exported without documenting what the requirements are
> for calling this function? Yikes.
> 

Thank you for your reply, I'll add more
documentation in the next version.


> Is my understanding correct that it is only safe to apply changes made with 
> blk_set_block_size() by calling
> queue_limits_commit_update_frozen()?
> 

Exported func blk_set_block_size() is only used in RAID, with expected
usage similar to queue_limits_stack_bdev(): callers must ensure no pending
IO and use queue_limits_start_update/queue_limits_commit_update to prevent
concurrent modifications.

> Thanks,
> 
> Bart.
> 
> 
> .

-- 
Thanks,
Nan

