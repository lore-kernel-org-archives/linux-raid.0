Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65AE82744B
	for <linux-raid@vger.kernel.org>; Thu, 21 Nov 2024 01:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732152359; cv=none; b=enkEro19kurAtYaZD0d0Zcl09iWLmM2LdoAIbjsdcijsmKD4HdszhuLIMxvtwlkMDa9N+/fOInPJjd/Pcf+htlRJ47mi4TiDmeDZ97kzNNo/JM723lm1Ky4bfu6rfRr4zQMq0XQfFnVys94NpYh8RJHSsz7bAcYOYid8eAR7dtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732152359; c=relaxed/simple;
	bh=Y+RGd1JtOfTw20VsynertqOqQD6s7q0mvpE0qol/g58=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=HG8p0Vq65v3FvwULg/kQihf/ImwCjca2OuLXCAxFNcUWWxIBBkjah6EK57OTNHu+H51+e3Cmc2Dv4sDr3exL0FrQ9gggNG5U03h7MkJLKtmjF5OmADTNvTO8M0tnBmaFuGq8CAR5ejjW43yvWXDNBlcO11WH/B53YfMRIndUu8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Xv0st3Nx3z4f3jkY
	for <linux-raid@vger.kernel.org>; Thu, 21 Nov 2024 09:25:38 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E400E1A018C
	for <linux-raid@vger.kernel.org>; Thu, 21 Nov 2024 09:25:51 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgB3U4cejD5n1PiDCQ--.17515S3;
	Thu, 21 Nov 2024 09:25:51 +0800 (CST)
Subject: Re: [PATCH v3 3/4] mdadm: remove bitmap file support
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
 Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20241120064637.3657385-1-yukuai1@huaweicloud.com>
 <20241120064637.3657385-4-yukuai1@huaweicloud.com>
 <20241120112730.00002cbe@linux.intel.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <6e8270ba-a188-96ff-d8c5-30a3dc614be6@huaweicloud.com>
Date: Thu, 21 Nov 2024 09:25:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241120112730.00002cbe@linux.intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3U4cejD5n1PiDCQ--.17515S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXFy5GrWxuw17Zr13Wr1xXwb_yoW5Wr15pF
	W0kr1Ykws3XrnxZ34xXa4xXayrKw1kJr9rJry0qasava1DCFnavr1rKayrCF9rZrn7ua45
	tr47ua4xC3W5Za7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUjuHq7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/11/20 18:27, Mariusz Tkaczyk Ð´µÀ:
> On Wed, 20 Nov 2024 14:46:36 +0800
> Yu Kuai <yukuai1@huaweicloud.com> wrote:
> 
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> Because it's marked deprecated for a long time now, and it's not worthy
>> to support it for new bitmap.
>>
>> Now that we don't need to store filename for bitmap, also declare a new
>> enum type bitmap_type to simplify code.
> 
> Thanks for the enum! I really appreciate the additional effort you took to
> make mdadm better.
> 
> I didn't not review it line by line because I see the problem that must
> be resolved first.
> 
> I see that you added BitmapNone and BitmapUnknown and their usage is not clear,
> let me help you!

Yeah, BitmapUnknow is used to match bitmap=NULL, and BitmapNonw is used
to match bitmap="none" before this patch.
> 
> BitmapUnknown should be used only if we failed to parse bitmap setting in
> cmdline. Otherwise first and default value should be always BitmapNone
> because data access is always highest priority and dropping bitmap is always
> safe. We can print warning in config parse failed or bitmap value is repeated-
> it is reasonable. If I'm wrong here, please let me know.

Hi, there is a little difference betewwn BitmapNone and BitmapUnknow, if
user doesn't pass in the "bitmap=xxx", then the BitmapUnkonw will be
used to decide choosing BitmapNone or BimtapInternal based on the disk
size. In Create:

         if (!s->bitmap_file &&
         ©®   !st->ss->external &&
         ©®   s->level >= 1 &&
         ©®   st->ss->add_internal_bitmap &&
         ©®   s->journaldisks == 0 &&
         ©®   (s->consistency_policy != CONSISTENCY_POLICY_RESYNC &&
         ©®    s->consistency_policy != CONSISTENCY_POLICY_PPL) &&
         ©®   (s->write_behind || s->size > 100*1024*1024ULL)) {
                 if (c->verbose > 0)
                         pr_err("automatically enabling write-intent 
bitmap on large array\n");
                 s->bitmap_file = "internal";
         }

And I realized that I should used BitmapUnknow here, not BimtapNone.

> 
> + It would be nice to add tests to cover these config/cmdline bitmap
>    possibilities to define clear set of expected behavior. It is something
>    already missed so I do not require that strongly from you know.

That's fine, just we need 100GB+ disk for the above default choice.

Thanks,
Kuai

> 
> I propose you to create mapping_t for bitmap and to use map_name() to match the
> bitmap strings, instead of hardcoding them but it is my recommendation not
> something strongly required.
> 
> Then, you would be able to remove some checks for both (s->btype != BitmapNone
> && s->btype != BitmapUnknown).
> 
> The change proposed by my will provide clear differentiation between error
> value and set of accepted values, messing that is always confusing for
> maintainers end readers. I don't see that kind of mess necessary in this case.
> 
> Thanks,
> Mariusz
> 
> .
> 

