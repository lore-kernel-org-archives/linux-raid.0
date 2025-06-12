Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3762F4321;
	Thu, 12 Jun 2025 11:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749729513; cv=none; b=KbzKr4wtb5YuUknYJOu+3RSbKERnWg5IpQd3HVlUtHdn8Km7XJk/9znzb4F1zkqGAogCDhoIM0a9IuZ4cWe293ce5oUriX8FnaA5+Rol5udw46Eobtmggh8WPBvTvUCiapJ9qa6oIqFIuFmVDZqgAufMvrn5MFv/G61h7HjJRjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749729513; c=relaxed/simple;
	bh=MYb2U93hAacbu5nblNG9qrABkU95v4tIkpaLQ3OPPaI=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ItH5Ti7E5vbK3DmyRiZafQlkTz92G/rkJa0v2CI/pwi1zbyZwM3uhg3N+UmCot5635rJV36PO4GEhnLyQzsKAcA4hm527F/nGzeXDhNYT3P9P30Vs/PvJ5noMvJd7DpihwQabjZqVu9MDjO9NI+Z01iL1HYd9eMxgVitO1BFeus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bJ1JP00hPzKHLyv;
	Thu, 12 Jun 2025 19:58:28 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 5788B1A0194;
	Thu, 12 Jun 2025 19:58:27 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgD3Wl_hwEpolgUqPQ--.15627S3;
	Thu, 12 Jun 2025 19:58:27 +0800 (CST)
Subject: Re: [PATCH v2] md/raid1: Fix stack memory use after return in
 raid1_reshape
To: Wang Jinchao <wangjinchao600@gmail.com>, Yu Kuai
 <yukuai1@huaweicloud.com>, Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250611090203.271488-1-wangjinchao600@gmail.com>
 <5143c5c3-3a77-919f-0d38-8adb0e8923e9@huaweicloud.com>
 <06935480-a959-4e3f-8e41-286d7f54754a@gmail.com>
 <9c7d5e66-4f5f-b984-c291-f19c3d568b85@huaweicloud.com>
 <938b0969-cace-4998-8e4a-88d445c220b1@gmail.com>
 <8a876d8f-b8d1-46c0-d969-cbabb544eb03@huaweicloud.com>
 <726fe46d-afd5-4247-86a0-14d7f0eeb3b3@gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <c328bc72-0143-d11c-2345-72d307920428@huaweicloud.com>
Date: Thu, 12 Jun 2025 19:58:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <726fe46d-afd5-4247-86a0-14d7f0eeb3b3@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3Wl_hwEpolgUqPQ--.15627S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tw1rCFyfWry8AFy7uFWUCFg_yoW8Ww4xpF
	W3tas5CrsxX3srCrZ8ua18Xryrta1SgFW3Jr1Sqry7ury3KF9agFsrGr909F98Xan7Xw40
	qFWrJFWkZ3WUu3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
	1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
	b7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
	vE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUbSfO7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/06/12 19:46, Wang Jinchao 写道:
> On 2025/6/12 19:23, Yu Kuai wrote:
>> Hi,
>>
>> 在 2025/06/12 17:55, Wang Jinchao 写道:
>>> Now that we have the same information, I prefer patch-v1 before 
>>> refactoring raid1_reshape,
>>> because it’s really simple (only one line) and clearer to show the 
>>> backup and restore logic.
>>> Another reason is that v2 freezes the RAID longer than v1.
>>> Would you like me to provide a v3 patch combining the v2 explanation 
>>> with the v1 diff?
>>> Thanks for your reviewing.
>>
>> I don't have preference here, feel free to do this.
>>
>> BTW, I feel raid1_reshape can be better coding with following：
>>
>> - covert r1bio_pool to use mempool_create_kmalloc_pool(use create
>> instead of init to get rid of the werid assigment);
> mempool_create_kmalloc_pool also calls init_waitqueue_head(&pool->wait) 
> internally, just like mempool_init.

Please notice that creat will allocate memory for mempool, the list is
no longer a stack value, the field bio_pool inside conf should also
covert to a pointer.

> So the issue only exists if newpool is allocated on the stack.
>> - no need to reallocate pool_info;
>> - convert raid1_info to use krealloc;
> I think reallocating pool_info is only for backup and restore, similar 
> to newpool.

You can just change the old value directly, after everything is ready,
with the first mempool change, pool_info is not needed for bio_pool.
>>
>> Welcome if you are willing to, otherwise I'll find myself sometime.
> I'm a newcomer to RAID and can't quite catch up with it right now.
> Maybe I can refactor it later, and I look forward to your guidance.
>>

No hurry, take you time :)

Thanks,
Kuai

