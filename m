Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A71238C16;
	Thu, 18 Dec 2025 07:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766042088; cv=none; b=PR0SVPxbwLaFkesMb8k45gtRzNHkP6rEOlF7Jd5zI0XOxWwh82lG2nk2C+LR+uasV3VtVg4xixRH6JPnYA9Z5Irw0eynf4bCFoFqLSvGQaFUdzk1VQjcguYJu9AhT+sFL2r6cEjrIZp4kpwFlHv3c/xsdlbDJL3MkWeGdZm0lhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766042088; c=relaxed/simple;
	bh=12hvBI7tmR6b+75yzPgrew/tchQbJ4I82eNqbzJtfjY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hgBLE5DeqgNmHs/5m50AwWIHOcKNAEHiFOhzi33ydNdcdz7Dm2e0Xftnfv/exEUcXzo6lAJ1gX273xs2MEc3rRAVXn9HpuE1xqrAhElyrWoC0H2Av/1MJidvrHWR1Lfj9CyAOREM57g2JElAf3xHF83PXLvGBWoss64Chfz7AIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dX1gg00bXzKHMQ0;
	Thu, 18 Dec 2025 14:57:18 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 460154058F;
	Thu, 18 Dec 2025 14:57:29 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgBHp_fTpUNp5tFlAg--.8133S3;
	Thu, 18 Dec 2025 14:57:25 +0800 (CST)
Message-ID: <c34450ca-7359-7be0-1266-133a71f6c579@huaweicloud.com>
Date: Thu, 18 Dec 2025 14:57:23 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH stable/6.18-6.17] md: add check_new_feature module
 parameter
To: Greg KH <gregkh@linuxfoundation.org>, Roman Mamedov <rm@romanrm.net>
Cc: Yu Kuai <yukuai@fnnas.com>, linan666@huaweicloud.com,
 stable@vger.kernel.org, song@kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
References: <20251217130513.2706844-1-linan666@huaweicloud.com>
 <2025121700-pedicure-reckless-65b9@gregkh>
 <6979cd43-d38c-477d-857c-8d211bc85474@fnnas.com>
 <20251217223130.1c571fa5@nvm> <2025121800-doorframe-enviably-56d5@gregkh>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <2025121800-doorframe-enviably-56d5@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHp_fTpUNp5tFlAg--.8133S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZr45JFW5GryfKFyfGFWxZwb_yoW5Gw1rp3
	y8XFyYyFsrGr97Aw4kKw4jg3WrtrWfZry5Wwn8JryfZr90gr1qyF43KryF9r92gry093Wa
	9F4jq347Wa4jy3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUP214x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v
	4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7
	AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GF
	ylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbQV
	y7UUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/12/18 14:30, Greg KH 写道:
> On Wed, Dec 17, 2025 at 10:31:30PM +0500, Roman Mamedov wrote:
>> On Thu, 18 Dec 2025 01:11:43 +0800
>> "Yu Kuai" <yukuai@fnnas.com> wrote:
>>
>>> Hi,
>>>
>>> 在 2025/12/17 22:04, Greg KH 写道:
>>>> On Wed, Dec 17, 2025 at 09:05:13PM +0800, linan666@huaweicloud.com wrote:
>>>>> From: Li Nan <linan122@huawei.com>
>>>>>
>>>>> commit 9c47127a807da3e36ce80f7c83a1134a291fc021 upstream.
>>>>>
>>>>> Raid checks if pad3 is zero when loading superblock from disk. Arrays
>>>>> created with new features may fail to assemble on old kernels as pad3
>>>>> is used.
>>>>>
>>>>> Add module parameter check_new_feature to bypass this check.
>>>> This is a new feature, why does it need to go to stable kernels?
>>>>
>>>> And a module parameter?  Ugh, this isn't the 1990's anymore, this is not
>>>> good and will be a mess over time (think multiple devices...)
>>>
>>> Nan didn't mention the background. We won't backport the new feature to stable
>>> kernels(Although this fix a data lost problem in the case array is created
>>> with disks in different lbs, anyone is interested can do this). However, this
>>> backport is just used to provide a possible solution for user to still assemble
>>> arrays after switching to old LTS kernels when they are using the default lbs.
>>
>> This is still a bad scenario. Original problem:
>>
>> - Boot into a new kernel once, reboot into the old one, the existing array no
>>    longer works.
>>
>> After this patch:
>>
>> - Same. Unless you know how, where and which module parameter to add, to
>>    be passed to md module on load. Might be not convenient if the root FS
>>    didn't assemble and mount and is inaccessible.
>>
>> Not ideal whatsoever.
>>
>> Wouldn't it be possible to implement minimal *automatic* recognition (and
>> ignoring) of those newly utilized bits instead?
> 
> Yes, that should be done instead.
> 
> And again, a module parameter does not work for multiple devices in a
> system, the upstream change should also be reverted.
> 
> thanks,
> 
> greg k-h
> 
> .

We propose the following fix for this issue. After fix, md arrays created
on old kernels won't be affected by this feature.

https://lore.kernel.org/linux-raid/825e532d-d1e1-44bb-5581-692b7c091796@huaweicloud.com/T/#mb205fb97ab4af629cae9db8dfd236ceaa93f14ad

The method is:
 > only set lbs by default for new array, for assembling the array still
 > left the lbs field unset, in this case the data loss problem is not fixed,
 > we should also print a warning and guide users to set lbs to fix the 
problem,
 > with the notification the array will not be assembled in old kernels.

-- 
Thanks,
Nan

