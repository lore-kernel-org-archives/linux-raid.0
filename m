Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A2939FCE;
	Thu,  8 Jan 2026 01:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767836967; cv=none; b=nH94jTWZNeF2IKyDNLILWaJHUivLRpI9wCyriCEE00aMbob0nSUpyim61r9ug28sKCI82etSFVKoOjYnn9CkxUewu/aEeMgqzfn7zoFtYpBotLuvWPDPfs3VQouaiGvl17o3Gs6osU9JtBzC1muvHA65PKAFLyJDPFq5y8S9Nfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767836967; c=relaxed/simple;
	bh=ZCORfV1ZlilyXrZpGBTbRmGLUh1ONofEkEbkqI8qGH0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=noABEgOhY/jtkKch+enHShRmTNqJnZt8TD8zHWMlwZv9RpbKa/YS/R2uq494vOR0g6mpsvoK6g9vQeNfVfNI/gFytVlJ4jXfIjcmPQbYpZ6soCuJZWx3l/FH9TzPCKJKfYyFaWyxX1Mkll+Q4LtOgYH+f1xr2VeYI7ntbWkE8dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dmnST6VLmzKHMdM;
	Thu,  8 Jan 2026 09:31:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 0A0F54058C;
	Thu,  8 Jan 2026 09:32:36 +0800 (CST)
Received: from [10.174.178.72] (unknown [10.174.178.72])
	by APP4 (Coremail) with SMTP id gCh0CgBXuPgyCV9pk2MRDA--.43813S3;
	Thu, 08 Jan 2026 09:32:35 +0800 (CST)
Message-ID: <0f2e2b2e-2721-492e-a1a6-99e1814c52fc@huaweicloud.com>
Date: Thu, 8 Jan 2026 09:32:31 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/5] md/raid1: introduce a new sync action to repair
 badblocks
To: Pascal Hambourg <pascal@plouf.fr.eu.org>, Roman Mamedov <rm@romanrm.net>
Cc: song@kernel.org, yukuai@fnnas.com, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 houtao1@huawei.com, linan122@h-partners.com, zhengqixing@huawei.com
References: <20251231070952.1233903-1-zhengqixing@huaweicloud.com>
 <20251231161130.21ffe50f@nvm>
 <d00be167-741a-4569-a51e-38b36325826e@huaweicloud.com>
 <be20c929-4a81-49fe-9c0d-67f2e116732a@plouf.fr.eu.org>
From: Zheng Qixing <zhengqixing@huaweicloud.com>
In-Reply-To: <be20c929-4a81-49fe-9c0d-67f2e116732a@plouf.fr.eu.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXuPgyCV9pk2MRDA--.43813S3
X-Coremail-Antispam: 1UD129KBjvJXoW7WFW5try7WFWkZr18tFWkJFb_yoW8Ary8p3
	98K3W5KFsrGr1rt3ZrZ3yxWan5tw4ftFW7XryrKryUWr98WryaqFWUJrWY9rZ0vrsavw1j
	vF4DZFyxA3WvgFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
	ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1
	7KsUUUUUU==
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/


在 2026/1/6 23:36, Pascal Hambourg 写道:
> On 06/01/2026 at 03:44, Zheng Qixing wrote:
>> 在 2025/12/31 19:11, Roman Mamedov 写道:
>>> On Wed, 31 Dec 2025 15:09:47 +0800
>>>
>>> Could you also check here that it reads back successfully, and only 
>>> then clear?
>>>
>>> Otherwise there are cases when the block won't read even after 
>>> rewriting it.
>
> I confirm. The rewrite is reported successful but SMART reallocation 
> attributes did not change and a further read still fails.
>
>> I'm a bit worried that reading the data again before clearing the bad 
>> blocks might affect the performance of the bad block repair process.
>
> Isn't it more worrying to clear bad blocks while they may still be bad ?
> Bad blocks should be rare anyway, so performance impact should be low.
>
>>> Side note, on some hardware it might be necessary to rewrite a 
>>> larger area
>>> around the problematic block, to finally trigger a remap. Not 512B, 
>>> but at
>>> least the native sector size, which is often 4K.
>>
>> Are you referring to the case where we have logical 512B sectors but 
>> physical 4K sectors?
>
> Yes. Writing a single logical sector implies a read-modify-write of 
> the whole underlying physical sector and will not complete if the read 
> fails.

That makes sense. I will change it in the next version.

>
>> Can a physical 4K block have partial recovery (e.g., one 512B sector 
>> succeeds while the other 7 fail)?
>
> Not in my experience. There seems to be a single ECC for the whole 
> physical sector.

I will try to test with disks that have lbs=512 and pbs=4096.

If 512B IOs can be successfully issued, then the bad block repair logic 
does need to

consider the minimum repair length and alignment logic.


Thanks,

Qixing

