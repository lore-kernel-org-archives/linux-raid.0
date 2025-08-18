Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6395E2D663B;
	Mon, 18 Aug 2025 08:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755504641; cv=none; b=VcTyGJAu6QXK3+Ccx4CAkvnpNYt0pOrt8iR82Ga8tVUjq68PATdCEyPYEHQDj6LLrJzTS2jKss16JLnNqdEPMvIb0WPq8ZXJIp9J5P0m+YLve2MegkbBzqEPhyvVbcn3uyL+0RZzHx5gvcJCzXUIzwhcrXX5NWsQFcVFoLDGcH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755504641; c=relaxed/simple;
	bh=LPXFM7GCH8Ak2LYE1V/XjLgtst7X5jpvYIsgxEqk14E=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=WXOVL3NoSe1aCH3tbu2u536yxLDNTW2Sb5bdnAeSKUXUpWjsEAD4gkduIFiCDM6c9IgIG4jETD5QgJtPbk5ItcP0OdnWvejE7600EfV2fpCKqaK53j5/8/lDaKKq78P3tuGIDhSFFhS1DwSY1NkXHC+QL0Ju8W4BeSTkhbdYR7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4c554W2YqXzYQvZt;
	Mon, 18 Aug 2025 16:10:35 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E928C1A0359;
	Mon, 18 Aug 2025 16:10:33 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgB3QBH436Jon6pUEA--.54659S3;
	Mon, 18 Aug 2025 16:10:33 +0800 (CST)
Subject: Re: [PATCH 1/2] block: ignore underlying non-stack devices io_opt
To: Christoph Hellwig <hch@infradead.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, colyli@kernel.org,
 linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250817152645.7115-1-colyli@kernel.org>
 <756b587d-2a5c-4749-a03b-cfc786740684@kernel.org>
 <ffa13f8c-5dfe-20d4-f67d-e3ccd0c70b86@huaweicloud.com>
 <fd5c1916-936b-4253-a7b8-ba53591653f3@kernel.org>
 <4aa48545-7398-c346-5968-5d08f29748c4@huaweicloud.com>
 <aKLAhOxV1KViVw7w@infradead.org>
 <de4fd44c-f8be-e787-27f4-9e9e09921e12@huaweicloud.com>
 <aKLFuQX8ndDxLTVs@infradead.org>
 <e00106ae-e373-9481-8377-5e69203f9de0@huaweicloud.com>
 <aKLdm4GPVfXOm0vO@infradead.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <aa12bb2b-0767-a30d-f7a6-a13722711828@huaweicloud.com>
Date: Mon, 18 Aug 2025 16:10:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <aKLdm4GPVfXOm0vO@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3QBH436Jon6pUEA--.54659S3
X-Coremail-Antispam: 1UD129KBjvJXoWrZr47AF1xtw4DuFWrJFWrKrg_yoW8Jr4kpr
	9ag3ZrKF4DAryIkwn2vr4UXr4Sk390g3s8Xr1rAr97Gr1DuFy0kayxKan09F90qrn7Cw1Y
	v3y09FykC3y5AaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUf8nOUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/08/18 16:00, Christoph Hellwig 写道:
> On Mon, Aug 18, 2025 at 02:31:20PM +0800, Yu Kuai wrote:
>> Hi,
>>
>> 在 2025/08/18 14:18, Christoph Hellwig 写道:
>>> On Mon, Aug 18, 2025 at 02:14:06PM +0800, Yu Kuai wrote:
>>>> Please take a look at the first patch, nothing special, the new flag
>>>> will be passed to the top device.
>>>
>>> But passing it on will be incorrect in many cases, e.g. for any
>>> write caching solution.  And that is a much more common use case
>>> than stacking different raid level using block layer stacking.
>>
>> I don't quite understand why it's incorrect for write caching solution,
>> can you please explain in details? AFAIK, the behaviour is only changed
>> for the first mdraid device is the stacking chain.
> 
> The way I read the patch, the flag is inherited if any underlying
> device sets it.
> 
> Now if you stack something that buffers most I/O the md raid limits
> aren't really that relevant, and you'd rather expose the limits
> for the writeback or read caching.

Why? We just set the flag for mdraid disks first, and then inherit to
top devices that is stacked by mdraid, so md raid limits should always
be relevant. I still don't understand the problem that you said :(

Thanks,
Kuai

> 
> 
> .
> 

