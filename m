Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D626558B7;
	Tue, 13 Aug 2024 07:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723533920; cv=none; b=Xo7i23HKschoiHO0WwgbjnJqK69rQ82LUd8s8WM3yRXxVt345rllw4WUz3olBbxchrOgOiCGzjS2ubgwuBRNDofmrt/A/DQ5GZCPp7YTGmlwhPODifxLKrR8XcIVRsAuSevII0lF15sQHsVnFX4wCTANK37Pl7tfezNhxbYjkmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723533920; c=relaxed/simple;
	bh=CVsAp1OHWfxHoBvjNlGDkgbJMESb+MonK/Z1/KlALEw=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=nl8O49y7JTCZM3J3CLmjQQd4tCDSKbEoKm88YbA3qEsKnvC//3JuJBYYicaS9bVybpc7KyxyY403EZDL9ux3EmEwbKPp0SQDFb5/6qJOo66dch0x9oLCj28UsYjlZSVM4qUHiiIoik/lgMF1UzqRzTnlCUxV3BWSj/JkqlMCc4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4WjjZh6061z4f3js9;
	Tue, 13 Aug 2024 15:25:00 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 851971A0359;
	Tue, 13 Aug 2024 15:25:14 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgAXPoRZCrtmMJs9Bg--.10498S3;
	Tue, 13 Aug 2024 15:25:14 +0800 (CST)
Subject: Re: [PATCH RFC -next 01/26] md/md-bitmap: introduce struct
 bitmap_operations
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
 Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240810020854.797814-1-yukuai1@huaweicloud.com>
 <20240810020854.797814-2-yukuai1@huaweicloud.com>
 <20240813085806.00006ec3@linux.intel.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <87eb8b55-53af-e47c-8931-044a9ab77086@huaweicloud.com>
Date: Tue, 13 Aug 2024 15:25:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240813085806.00006ec3@linux.intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXPoRZCrtmMJs9Bg--.10498S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJryrKr1kZr47CF4rZrWUurg_yoW8Xr4DpF
	4fK39IkFsrJ34xu3WxWrZ7ArySyayvq39xJrn8GwsakFn8ZFn3tF1IkrWY9F9xWrZa9a9F
	qa12yr95Zw1UAFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUG0PhUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/08/13 14:58, Mariusz Tkaczyk Ð´µÀ:
> On Sat, 10 Aug 2024 10:08:29 +0800
> Yu Kuai <yukuai1@huaweicloud.com> wrote:
> 
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> The structure is empty for now, and will be used in later patches to
>> merge in bitmap operations, prepare to implement a new lock free
>> bitmap in the fulture.
> 
> 
> HI Kuai,
> 
> typo: future
> 
> I think that as "later" you meant next patches in this patchset, right? If yes,
> Please you "next" instead.
> 
> At this point bringing "lock free implementation in the future" looks like
> totally unnecessary. It may happen or may not. Eventually, You can mention it in
> cover letter. What we have now is the most important.
> 
> This is just a code rework. The main goal of this (as you mentioned in second
> patch):
> 
> "So that the implementation won't be exposed, and it'll be possible
> to invent a new bitmap by replacing bitmap_operations."
> 
> but please mention that you are not going to implement second mechanism to not
> confuse reader. You need it to improve code maintainability mainly I think.
> 
> I would mention something about common "struct _ops" pattern (the special
> structure to keep related operations together) that it is going to follow now.
> 
> For me, this one can be easy merged with the patch 2, so we will got struct +
> usage in one patch.

Thanks for the review. Got it.

BTW, v2 will look totally different with v1. You can leave v1 for now. :)

Kuai

> 
> Anyway, LGTM.
> 
> Thanks,
> Mariusz
> 
> .
> 

