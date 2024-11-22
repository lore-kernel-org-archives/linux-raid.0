Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22EA171D2
	for <linux-raid@vger.kernel.org>; Fri, 22 Nov 2024 01:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732238006; cv=none; b=FtUvrd6BNe/aBkmYTv+ID4yzadoEpDci3Q4fZoYY4bZdcpDuPRPHkZbrOz8ZnNOhxcLzkjVSUJTk60zEb6JMOGB9vEAFsuKKKlM+IegdzPDNk1kFaY4irYjuVB/jGeteSid2q1mq6I4sUlZnAYyOWcKdRwTxQidGC5iVdohYZ0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732238006; c=relaxed/simple;
	bh=xXZ/62PEXZ+c81yEkRaSWgdAT8C0hofId2Bp+v/6UjA=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ZXwZfLZT6aSDCjvGz8gpJBOZr1h8kLL5Mv6a+zC3qK2zZhthVBGzlErnOYBZQR62JU82wSTAwyIHsSK9vD35ztx9MolMI8UG3CeP2Py6G3HrLg9F1daj/QekA2XYdcZ9zv+2jlk3MX8FHvPsQXBTpd4kdvZ2S1r9PVqOVKVyIyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XvcXr2mxMz4f3m7V
	for <linux-raid@vger.kernel.org>; Fri, 22 Nov 2024 09:13:00 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D5DF41A0194
	for <linux-raid@vger.kernel.org>; Fri, 22 Nov 2024 09:13:19 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCXcYWu2j9nLYTiCQ--.49797S3;
	Fri, 22 Nov 2024 09:13:19 +0800 (CST)
Subject: Re: [PATCH v3 3/4] mdadm: remove bitmap file support
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
 Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20241120064637.3657385-1-yukuai1@huaweicloud.com>
 <20241120064637.3657385-4-yukuai1@huaweicloud.com>
 <20241120112730.00002cbe@linux.intel.com>
 <6e8270ba-a188-96ff-d8c5-30a3dc614be6@huaweicloud.com>
 <20241121091500.00004ce6@linux.intel.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <122fe099-6e2b-8b1e-a9c2-d027cadb08b8@huaweicloud.com>
Date: Fri, 22 Nov 2024 09:13:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241121091500.00004ce6@linux.intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCXcYWu2j9nLYTiCQ--.49797S3
X-Coremail-Antispam: 1UD129KBjvJXoWxuF48CF45ZFyrtF15tFy7ZFb_yoW5XFWfpF
	s8KF1rKF18Ar18ur47tFyIgF10kw1kJr47Gw17J3s5Za98GFna9r1rKF40vFW7ZrZ7X34Y
	9w45ZryxuFn0vaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
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



ÔÚ 2024/11/21 16:15, Mariusz Tkaczyk Ð´µÀ:
> On Thu, 21 Nov 2024 09:25:50 +0800
> Yu Kuai <yukuai1@huaweicloud.com> wrote:
> 
>>> BitmapUnknown should be used only if we failed to parse bitmap setting in
>>> cmdline. Otherwise first and default value should be always BitmapNone
>>> because data access is always highest priority and dropping bitmap is always
>>> safe. We can print warning in config parse failed or bitmap value is
>>> repeated- it is reasonable. If I'm wrong here, please let me know.
>>
>> Hi, there is a little difference betewwn BitmapNone and BitmapUnknow, if
>> user doesn't pass in the "bitmap=xxx", then the BitmapUnkonw will be
>> used to decide choosing BitmapNone or BimtapInternal based on the disk
>> size. In Create:
>>
>>           if (!s->bitmap_file &&
>>           ©®   !st->ss->external &&
>>           ©®   s->level >= 1 &&
>>           ©®   st->ss->add_internal_bitmap &&
>>           ©®   s->journaldisks == 0 &&
>>           ©®   (s->consistency_policy != CONSISTENCY_POLICY_RESYNC &&
>>           ©®    s->consistency_policy != CONSISTENCY_POLICY_PPL) &&
>>           ©®   (s->write_behind || s->size > 100*1024*1024ULL)) {
>>                   if (c->verbose > 0)
>>                           pr_err("automatically enabling write-intent
>> bitmap on large array\n");
>>                   s->bitmap_file = "internal";
>>           }
>>
>> And I realized that I should used BitmapUnknow here, not BimtapNone.
> 
> Oh yes.. Looking on that from the interface perspective suggest me that we
> should remove it and always let user to decide. If the are not satisfied with
> resync times they can enable bitmap in any moment but it may cause functional
> regression for users that are used to this auto turning on.
> 
> Maybe, we can move it to main() and ask without checking raid size, assuming
> that array size <100GB is used mainly for testing nowadays?
> 
> Here, proposal based on current code, your change may require some adjustments:
> 
> diff --git a/mdadm.c b/mdadm.c
> index 8cb4ba66ac20..2e803d441dd4 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -1535,6 +1535,13 @@ int main(int argc, char *argv[])
>                          break;
>                  }
> 
> +               if (!s->bitmap_file && !c.runstop != 1 && s->level >= 1) {
> +                       int response = ask("To optimalize resync speed, it is
>    recommended to enable write-indent bitmap, do you want to enable it now?");
> +
> +                       if (response)
> +                               s->bitmap_file = "internal";
> +               }
> +
>                  rv = Create(ss, &ident, devs_found - 1, devlist->next, &s, &c);
>                  break;
>          case MISC:
> 
> This is more reasonable than auto-forcing bitmap without possibility
> to skip it (even for testing). I added c->runstop verification because it is
> often used in Create to skip some errors and questions.
> 
> What do you think?

I think it's good! I used to be curious why bitmap is not enabled by
default for testing, and have to look into the source code.

Thanks,
Kuai

> 
> Thanks,
> Mariusz
> 
> .
> 

