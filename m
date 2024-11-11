Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A892595;
	Mon, 11 Nov 2024 02:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731290667; cv=none; b=a2+MhvJvSWoL85ugYMcy0wJxCv9NUr3sC7OkSwg+fD5dkhBVnh+jqE13DOxs2Jre5Y1+w6y0/GX3S3FqPO4MdS4AJSOnLGqWtAPsuiaXzAj7WdFQPSRPoM46347iAfO/Zg0S+TRKFdd/Z7clSR2MhHOng/yokVFr489fk+M/B8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731290667; c=relaxed/simple;
	bh=LO7e434sgS9tJnUzWErguBOZODemuMKPExl6xxgCHq8=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=jLCTDxyK+crv/JICTdUC8NiUCCrDSKj5gZ5NZQpvhk0rESPkVTM8lcOk674Hz5G8NsgFUR02vhlCqRZKRhIAAcL6b67RTN58M+3BDmV5/ttVTaaxE/bUmkz19r8L33I2ODc2shJ5e0xbh8sMCvh7nu7rV5NZ8f1IxQ7i6VA8P10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XmtBm75lRz4f3lg9;
	Mon, 11 Nov 2024 10:04:00 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 088C11A018D;
	Mon, 11 Nov 2024 10:04:20 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgB3U4ciZjFnUELHBQ--.593S3;
	Mon, 11 Nov 2024 10:04:19 +0800 (CST)
Subject: Re: [PATCH md-6.13] md: remove bitmap file support
To: =?UTF-8?Q?Dragan_Milivojevi=c4=87?= <galileo@pkm-inc.com>,
 Yu Kuai <yukuai1@huaweicloud.com>, "yukuai (C)" <yukuai3@huawei.com>
Cc: Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 "Luse, Paul E" <paul.e.luse@intel.com>
References: <20241107125911.311347-1-yukuai1@huaweicloud.com>
 <CAPhsuW7Ry0iUs6X7P4jL5CX3+8EGfb5uL=g-q_8jVR-g19ummQ@mail.gmail.com>
 <ef4dcb9e-a2fa-d9dc-70c1-e58af6e71227@huaweicloud.com>
 <CAPhsuW4tcXqL3K3Pdgy_LDK9E6wnuzSkgWbmyXXqAa=qjAnv7A@mail.gmail.com>
 <CALtW_agCsNM66DppGO-0Trq2Nzyn3ytg1t8OKACnRT5Yar7vUQ@mail.gmail.com>
 <8ae77126-3e26-2c6a-edb6-83d2f1090ebe@huaweicloud.com>
 <CALtW_ajYN4byY_hWLyKadAyLa9Rmi==j6yCYjLLUuR_nttKMrQ@mail.gmail.com>
 <36659c34-08bf-2103-a762-ce9e75e8262e@huaweicloud.com>
 <CALtW_ai-xfkphuch64f2n544cfWzg__59bwX3Yxkf-N61K-SvA@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <8dc1ee79-fd64-70d7-bb48-b38920c1cddd@huaweicloud.com>
Date: Mon, 11 Nov 2024 10:04:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CALtW_ai-xfkphuch64f2n544cfWzg__59bwX3Yxkf-N61K-SvA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3U4ciZjFnUELHBQ--.593S3
X-Coremail-Antispam: 1UD129KBjvdXoWruFW8WFWfGrW3uFyUArW5ZFb_yoWDZrc_uF
	4j9r97Z343G39Fga1agF1SkrW5KayxGayUXrZ7XFyFgas3XFyUtrWkAr97uws3Aa45ZrnI
	gryvg3y7JrZxujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbVxFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7Mxk0xIA0c2IEe2xFo4CEbIxv
	r21lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
	0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
	17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
	C0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY
	6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
	73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/11/09 10:15, Dragan Milivojević 写道:
> On Sat, 9 Nov 2024 at 02:44, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> This is not what I expected, can you give the tests procedures in
>> details? Including test machine, create the array and test scrpits.
> 
> Server is Dell PowerEdge R7525, 2x AMD EPYC 7313 the rest
> is in the linked pastebin, let me know if you need more info.

Yes, as I said please show me you how you creat the array and your test
script. I must know what you are testing, like single threaded or high
concurrency. For example your result shows bitmap none close to bitmap
external, this is impossible in our previous results. I can only guess
that you're testing single threaded.

BTW, it'll be great if you can provide some perf results of the internal
bitmap in your case, that will show us directly where is the bottleneck.

> 
> BTW do you guys do performance tests? All of the raid levels are

We do, but we never test external bitmap.

+CC Paul

Hi, do you have time to add the external bitmap in our test?

Thanks,
Kuai

