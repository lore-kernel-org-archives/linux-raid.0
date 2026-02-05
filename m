Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2857E35CB67;
	Thu,  5 Feb 2026 07:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770276595; cv=none; b=FOlMqyZHWP4QFtGLLSX6e6kUWbqulek3m9cIUC4EQmyudzreY+4v38lT+A6qz7mFCo7dw5Xfo/QJfQia9HhUwpEQxgHT0NT/vA/omyFqb3nu2s1p0rA7Npuzp/xybf1a1Wqh5nL4oJr+oEETPQAgX5CP5QcD+2LXtK3MvlZy2b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770276595; c=relaxed/simple;
	bh=Zoife+9d2UG3d+FPrIhoXm1rOMPrGRy6CzD5VXTU9Uc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HTwefKi0OX3nAgSFsY6UK7/iFz0cwBAHFo0vXimPiw80J4N3WDVuqevUbi7VYKJZzjNFQ5fW/KzEnKRcGynFgLRciOJMUrVzsO8eSlMP8bnJVM6XPoq8X+BpsEvLDAp+1t83DlvlKGKDI6gSLNBxDKnPy3YhW6/rsncAf488V6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4f68464qBfzKHM0J;
	Thu,  5 Feb 2026 15:29:26 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 255014056E;
	Thu,  5 Feb 2026 15:29:51 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgAHZ_fuRoRpPupPGQ--.56823S3;
	Thu, 05 Feb 2026 15:29:50 +0800 (CST)
Message-ID: <23035df1-d550-ee86-337c-e43847712e3c@huaweicloud.com>
Date: Thu, 5 Feb 2026 15:29:50 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 14/14] md/raid1,raid10: fall back to smaller order if
 sync folio alloc fails
To: yukuai@fnnas.com, linan666@huaweicloud.com, song@kernel.org
Cc: xni@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yangerkun@huawei.com, yi.zhang@huawei.com
References: <20260128075708.2259525-1-linan666@huaweicloud.com>
 <20260128075708.2259525-15-linan666@huaweicloud.com>
 <887aa7a7-0b74-4b92-a053-0f019bac7d85@fnnas.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <887aa7a7-0b74-4b92-a053-0f019bac7d85@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHZ_fuRoRpPupPGQ--.56823S3
X-Coremail-Antispam: 1UD129KBjvdXoW7Jw1rXry5Ww1fAr4rAFyxZrb_yoWfArc_Cw
	10vFZ3Jr1UJFyIva45tr1fZr92kF4UZr1UAFyjqrW5Xa4rZF1kCr1DKrZxJw4UJFW8Crn8
	Ar1ktry8Aw42vjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbf8FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIF
	xwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI4
	8JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xv
	wVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjx
	v20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20E
	Y4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267
	AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbq-e5UUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2026/2/5 0:48, Yu Kuai 写道:
> Hi,
> 
> 在 2026/1/28 15:57, linan666@huaweicloud.com 写道:
>> From: Li Nan <linan122@huawei.com>
>>
>> RESYNC_BLOCK_SIZE (64K) has higher allocation failure chance than 4k,
>> so retry with lower orders to improve allocation reliability.
>>
>> A r1/10_bio may have different rf->folio orders. Use minimum order as
>> r1/10_bio sectors to prevent exceeding size when adding folio to IO later.
>>
>> Signed-off-by: Li Nan <linan122@huawei.com>
>> ---
>>    drivers/md/raid1-10.c | 14 +++++++++++---
>>    drivers/md/raid1.c    | 13 +++++++++----
>>    drivers/md/raid10.c   | 28 ++++++++++++++++++++++++++--
>>    3 files changed, 46 insertions(+), 9 deletions(-)
> 
> Looks like this patch should be merged into patch 5, there is no need to introduce
> that higher allocation failure and then fix it here.
> 

OK, I will merge abouve patches.

-- 
Thanks,
Nan

