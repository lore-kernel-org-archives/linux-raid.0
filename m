Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4486256D;
	Mon, 26 May 2025 08:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748246555; cv=none; b=Kn6yibNx/2D8pywXxDnp49qERjSbDrHuBJoJMJlYHWSjsnvW6thgZto5ya4Qa8luev7vso8cdh/LNdi32984OClVAc4gyBaNbIZswqIfFxWO20+6v4NMFHn41oz4ju44BMaVVShwkZWP/xJdfxKMRdMtIhjqm/S9k67RFUyCUtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748246555; c=relaxed/simple;
	bh=2WZfcenAuyb88BR7HoppgHFTyOrp6pSc6DAHx/BeDW0=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ul4hYDU0tOJum6y0QRHgvH+Oft+SLxGtS60Adl1ArB4Rg982kmr2R2KkeyqOlFHTE77RMdVzRabqbh1FVuJmy/+1edyTnZcyiAufKlCDM1BMlynUPlFnU9WFC5WP5dlIsxe0vdhYoi7r9UwFvs/qrJ/1UBj954EhM7cmaVL9Yak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4b5Ssz6zpczKHMmr;
	Mon, 26 May 2025 16:02:31 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 6E19A1A1569;
	Mon, 26 May 2025 16:02:30 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgBHrGAVIDRoL0k3Ng--.24830S3;
	Mon, 26 May 2025 16:02:30 +0800 (CST)
Subject: Re: [PATCH 06/23] md/md-bitmap: add a new sysfs api bitmap_type
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, colyli@kernel.org, song@kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-7-yukuai1@huaweicloud.com>
 <CALTww2_sxkU83=F+BqBJB29-gada2=sF-cZR98e5UiARJQuNjg@mail.gmail.com>
 <0e527b24-3980-2126-67f0-0958f2bc3789@huaweicloud.com>
 <CALTww2_wuO+uf2rf=VWvUChY1-zOdkoXPRT7dSLr69Nfkkoz8g@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <b224a35f-b88b-8bb4-f2b6-e3a2cea15fd3@huaweicloud.com>
Date: Mon, 26 May 2025 16:02:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CALTww2_wuO+uf2rf=VWvUChY1-zOdkoXPRT7dSLr69Nfkkoz8g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHrGAVIDRoL0k3Ng--.24830S3
X-Coremail-Antispam: 1UD129KBjvJXoW7WFWDWrW5ZF1fXrWDZF4rAFb_yoW8GFyfp3
	yxXFnxGFs8JrZa9asrAFyjg3WFqwnrJ3sFqryFgr90kF98GFna9F4rGF4UK34jyr10k3WD
	ZayYq348Xw1j9FDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUZYFZUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/05/26 13:11, Xiao Ni 写道:
> On Mon, May 26, 2025 at 9:14 AM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> Hi,
>>
>> 在 2025/05/26 0:32, Xiao Ni 写道:
>>>> The api will be used by mdadm to set bitmap_ops while creating new array
>>> Hi Kuai
>>>
>>> Maybe you want to say "set bitmap type" here? And can you explain more
>>> here, why does it need this sys file while creating a new array? The
>>> reason I ask is that it doesn't use a sys file when creating an array
>>> with bitmap.
>>
>> I do mean mddev->bitmap_ops here, this is the same as mddev->pers and
>> the md/level api. The mdadm patch will write the new helper before
>> running array.
> 
> + if (s->btype == BitmapLockless &&
> +    sysfs_set_str(&info, NULL, "bitmap_type", "llbitmap") < 0)
> + goto abort_locked;
> 
> The three lines of code are in the Create function. From an intuitive
> perspective, it's used to set bitmap type to llbitmap rather than
> bitmap ops. And in this patch, it adds the bitmap_type sysfs api to
> set mddev->bitmap_id. After adding some debug logs, I understand you.
> It's better to describe here more. Because the sysfs file api is used
> to set bitmap type. Then it can be used to choose the bitmap ops when
> creating array in md_create_bitmap
> 

Yes, sorry about the misleading, we're setting mddev->bitmap_id by
sysfs, and mddev->bitmap_ops by mddev->bitmap_id later in kernel(the
next patch).

Thanks,
Kuai

