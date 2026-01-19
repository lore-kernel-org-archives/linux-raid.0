Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2807A13A;
	Mon, 19 Jan 2026 02:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768791093; cv=none; b=he/5kZIfJLY9FKySYhgRPj0kg5GBwkV/HAdUPGOGlfqzTSWT8D4HHAoPtNwU69IccnM1qVjLiOYcWtTfveHZiS8g3JS17M5+EID218YxRpAZ0PGFx748NOZvUQoQvxv23Iua/yduBWEB2/lniTXgoSBRDNHSS7NFn+exh1Xnzb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768791093; c=relaxed/simple;
	bh=08s7M0sLEB1+cMPPDkFqQjadEetQOVNy7V5xeFMrC0k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kgT7q7u6+VBgVTZNoYSnRjM3orpX6NFWeW4CfZaHQWKW6fPjK6tJZl2w0ntrKKuuZynHz3F6YT4UPzARS7aZNnsuR5mXboQasc8Gqwog0qg1qNf2Ycy5/5P1JExCUo0AAftj1umFgPfiC05KtYg+atnAFLXdag5Ge0tdbmJ1c3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dvZhp1XyyzYQtly;
	Mon, 19 Jan 2026 10:51:06 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A2E2C40594;
	Mon, 19 Jan 2026 10:51:27 +0800 (CST)
Received: from [10.174.178.72] (unknown [10.174.178.72])
	by APP4 (Coremail) with SMTP id gCh0CgD3WPkunG1p5VNCEQ--.15040S3;
	Mon, 19 Jan 2026 10:51:27 +0800 (CST)
Message-ID: <ca387132-4e33-4084-92dc-5418e2801acb@huaweicloud.com>
Date: Mon, 19 Jan 2026 10:51:26 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 5/5] md/raid1: introduce rectify action to repair
 badblocks
To: Li Nan <linan666@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, houtao1@huawei.com,
 linan122@h-partners.com, song@kernel.org, yukuai@fnnas.com,
 Zheng Qixing <zhengqixing@huawei.com>
References: <20251231070952.1233903-1-zhengqixing@huaweicloud.com>
 <20251231070952.1233903-6-zhengqixing@huaweicloud.com>
 <905c81d3-a235-dd36-e17b-37acb8a6128b@huaweicloud.com>
From: Zheng Qixing <zhengqixing@huaweicloud.com>
In-Reply-To: <905c81d3-a235-dd36-e17b-37acb8a6128b@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3WPkunG1p5VNCEQ--.15040S3
X-Coremail-Antispam: 1UD129KBjvdXoWrtr43Xw17Kw4xAr18XFykuFg_yoW3Awb_ua
	yDZw1kWr93X3yUuw1UX347uFn8Xr1qg3Z8XF4Fvr1UG34kJrn8Zrn5Ar93Zw1j9rW5Cr1Y
	qw15CFy3ZF1xWjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbVkFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUb_Ma5UUUUU==
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

Hi,

>> @@ -700,21 +738,34 @@ static enum sync_action __get_recovery_sync_action(struct mddev *mddev)
>>     static enum sync_action get_recovery_sync_action(struct mddev *mddev)
>>   {
>> +    if (test_bit(MD_RECOVERY_BADBLOCKS_RECTIFY, &mddev->recovery))
>> +        return ACTION_RECTIFY;
>>       return __get_recovery_sync_action(mddev);
>>   }
>>     static void init_recovery_position(struct mddev *mddev)
>>   {
>>       mddev->resync_min = 0;
>> +    mddev->rectify_min = 0;
>> +}
>
> As mentioned in patch 1, can we directly reuse resync_min?


To keep rectify's progress separate from check and repair, it's better to use
a dedicated variable to record it.

I'll update the other suggestions in v2.


Thanks,

Qixing

