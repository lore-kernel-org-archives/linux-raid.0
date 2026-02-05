Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF2D35C1AC;
	Thu,  5 Feb 2026 07:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770276448; cv=none; b=baACbs7aV857V6fSfgvO/kZLu6eRmQygSStrBB/h3n1EQK4krPbXfO2fRf+MaW8lTSWiIwGgGofo4rNtAbwbW8+jVmHicozzyiVw84iKwiPyfpGUYWyKU6TP2q2EXJ6her10roLADYWT6FjxyNLGZVYnV3S8zd/CSMczdQx8pwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770276448; c=relaxed/simple;
	bh=+FyywQNzZIykzMJUPPxjycZZA3EsBAtEGRfreL4omnc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rFdGMKDCwzfc2HYh7uyF/l0QwEV8POPiX8LSUYmO9Km80SdtQmrmNG8OnTwO7dcfpq1o3hVRIEQF3SL6Bxiciy2syol+XYE3vDYNrNTjJphqNX5sOuGma2Vl37REgbUB+ChXoOUmP7Qzv6jZYokr8R0pka3ybeKZMEOYSwxM06M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4f680q0GcBzYQv0Q;
	Thu,  5 Feb 2026 15:26:35 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 69E9A4058C;
	Thu,  5 Feb 2026 15:27:25 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgB3JPVcRoRpS7ZPGQ--.49252S3;
	Thu, 05 Feb 2026 15:27:25 +0800 (CST)
Message-ID: <8515452b-9479-05aa-eecb-a186001647fa@huaweicloud.com>
Date: Thu, 5 Feb 2026 15:27:24 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 06/14] md: Clean up folio sync support related code
To: yukuai@fnnas.com, linan666@huaweicloud.com, song@kernel.org
Cc: xni@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yangerkun@huawei.com, yi.zhang@huawei.com
References: <20260128075708.2259525-1-linan666@huaweicloud.com>
 <20260128075708.2259525-7-linan666@huaweicloud.com>
 <0b8ba3a3-ce7e-4fd0-aacb-3ea62876acc8@fnnas.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <0b8ba3a3-ce7e-4fd0-aacb-3ea62876acc8@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3JPVcRoRpS7ZPGQ--.49252S3
X-Coremail-Antispam: 1UD129KBjvdXoW7JFW8CrWfKr1ftw47ZFyrZwb_yoWDGFgEka
	y0yF9IqrW7uF1xCF1jkr1a9rZFkF48Xw1Uua4jgrWrZr9xZF1kAr98tr4rZw15ZFW8ZrZ8
	uryvq3yYyrnrZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbf8FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIF
	xwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI4
	8JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xv
	wVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjx
	v20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20E
	Y4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267
	AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbE1v3UUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2026/2/5 0:52, Yu Kuai 写道:
> Hi,
> 
> 在 2026/1/28 15:57, linan666@huaweicloud.com 写道:
>> From: Li Nan <linan122@huawei.com>
>>
>> 1. Remove resync_get_all_folio() and invoke folio_get() directly instead.
>> 2. Clean up redundant while(0) loop in md_bio_reset_resync_folio().
>> 3. Clean up bio variable by directly referencing r10_bio->devs[j].bio
>>      instead in r1buf_pool_alloc() and r10buf_pool_alloc().
>> 4. Clean up RESYNC_PAGES.
>>
>> Signed-off-by: Li Nan <linan122@huawei.com>
>> Reviewed-by: Xiao Ni <xni@redhat.com>
>> ---
>>    drivers/md/raid1-10.c | 22 ++++++----------------
>>    drivers/md/raid1.c    |  6 ++----
>>    drivers/md/raid10.c   |  6 ++----
>>    3 files changed, 10 insertions(+), 24 deletions(-)
> 
> I think this patch can be merged into patch 5.
> 

Thanks for your review.

Previously I modified them together, which made patch 5 difficult to review
as it is already large enough. I will merge them in the next version.

-- 
Thanks,
Nan

