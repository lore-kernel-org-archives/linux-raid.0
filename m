Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7E1259C84
	for <linux-raid@vger.kernel.org>; Fri, 19 Dec 2025 08:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766132566; cv=none; b=oCUct6UO9POKAqmVYbHY1M/CXNOf1TEJDXhzz2hkJaci+yFfDR+ieQEBT0wWSEEVIkiE18ZSsDMWdFKepTR/ruZMlkA39JLyw1olRcg6Q3I6wn2SxBLTDNRQ2ldVHQRKMz6REAnZTO/FlXZJubiTDsk/FLTVjKempdC1r3ZMNuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766132566; c=relaxed/simple;
	bh=bd95U3+j66G1DU3ndoZcgXRRGrPNEwMeq9WSVF8CGBo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ioaAVopXQQbr8111ZUMGR22kqigsWkCMI0nGvHYunyfJoiW5PP6h7jPJomwZhuiXyxzw2sWhAoZtRRHbxr9GC2jO3PlBpbJSmJ0vlaPVcAX3O0UcxZxySpZ3LYbqA4RDhmJlQ7JfazUiNfaCDQ8govgjwEHQILahOFmNff9NmYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dXgWS3q4rzKHMMl
	for <linux-raid@vger.kernel.org>; Fri, 19 Dec 2025 16:22:28 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 6891840576
	for <linux-raid@vger.kernel.org>; Fri, 19 Dec 2025 16:22:40 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgBHp_dMC0VpQCTjAg--.34657S3;
	Fri, 19 Dec 2025 16:22:38 +0800 (CST)
Message-ID: <909940cf-7fdf-edc1-84b5-8bfb8f75779b@huaweicloud.com>
Date: Fri, 19 Dec 2025 16:22:36 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Issues with md raid 1 on kernel 6.18 after booting kernel 6.19rc1
 once
To: BugReports <bugreports61@gmail.com>, Li Nan <linan666@huaweicloud.com>,
 yukuai@fnnas.com, linux-raid@vger.kernel.org, xni@redhat.com
References: <b3e941b0-38d1-4809-a386-34659a20415e@gmail.com>
 <8fd97a33-eb5a-4c88-ac8a-bfa1dd2ced61@fnnas.com>
 <825e532d-d1e1-44bb-5581-692b7c091796@huaweicloud.com>
 <af9b7a8e-be62-4b5a-8262-8db2f8494977@gmail.com>
 <c6389212-3651-c85a-a713-693351aaf690@huaweicloud.com>
 <abd640b6-6b14-4752-80ca-242fca19fe47@gmail.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <abd640b6-6b14-4752-80ca-242fca19fe47@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHp_dMC0VpQCTjAg--.34657S3
X-Coremail-Antispam: 1UD129KBjvJXoW7uF17tFyfGF48CFW8ZF4xZwb_yoW8tr4fpa
	y8J3WY9r4DJ34UG397Kr1S9345t397t3y5Wrn8Ja1fAFn0qryIvFWS9FZI9FnF93y5W3W2
	vr47tFn2vF1DCaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9E14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIF
	xwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI4
	8JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xv
	wVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjx
	v20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20E
	Y4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267
	AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjJ3vUUUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/12/19 0:04, BugReports 写道:
> Hi,
> 
> ok, so no easy way back for me to the original state sadly.
> 
> The patch for 6.18 here: 
> https://lore.kernel.org/stable/20251217130513.2706844-1-linan666@huaweicloud.com/T/#u 
> 
> 
> has the following in:
> 
> + memcmp(sb->pad3, sb->pad3+1, sizeof(sb->pad3) - sizeof(sb->pad3[1]))) { + 
> pr_warn("Some padding is non-zero on %pg, might be a new feature\n", + 
> rdev->bdev); + if (check_new_feature) + return -EINVAL; + 
> pr_warn("check_new_feature is disabled, data corruption possible\n"); + }
> 
> Data corruption (especially the one happening in the background without 
> noticing) would be the worst case.
> 
> So is it really safe to use that patch+module option with my modified md 
> raid  on kernel 6.18 (can easily apply the patch on my 6.18 kernel) ?
> 
> Br

These dmesg note that using an array with new features in an old kernel may
cause data loss. If you configured LBS in a new kernel and use that array 
in an old kernel, data loss will occur due to LBS changes.

However, this problem does not exist if your RAID was created in an old
kernel, as LBS will not change when rolling back.

> 
> Am 18.12.25 um 15:54 schrieb Li Nan:
>>
>>
>> 在 2025/12/18 18:41, Bugreports61 写道:
>>> Hi,
>>>
>>>
>>> reading the threads it was now decided that only newly created arrays 
>>> will get the lbs adjustment and patches to make it work on older kernels 
>>> will not happen:
>>>
>>>
>>> How do i get back my md raid1 to a state which makes it usable again on 
>>> older kernels ?
>>>
>>> Is it  safe to simply mdadm --create --assume-clean /dev/mdX /sdX /sdY 
>>> on kernel 6.18 to get the old superblock 1.2 information back without 
>>> loosing data ?
>>>
>>>
>>> My thx !
>>>
>>
>> In principle, this works but remains a high-risk operation. I still
>> recommend backporting this patch and add module parameters to mitigate the
>> risk.
>>
>> https://lore.kernel.org/stable/20251217130513.2706844-1-linan666@huaweicloud.com/T/#u 
>>
>>
>> This issue will be fixed upstream soon. The patch is under validation and
>> expected to be submitted tomorrow. However, the existing impact cannot be
>> undone – apologies for this.
>>
> 
> .

-- 
Thanks,
Nan

