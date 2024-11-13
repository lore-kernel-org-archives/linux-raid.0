Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04ACF79FD;
	Wed, 13 Nov 2024 01:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731460706; cv=none; b=GxkfHfKKe+xVjUljF+Be9Rdy8Cz4/8fjU519zMjClMum8LUFe9Idqi8DsqBj2RqKSbD9ArmavnmsPYJnSNVRd2YwXvV3wfcAR3i8iQALyLtIIuW/FTQoDarxVaFOotKZlKy52JU7a4Z/9NZj+ILpfCHE9eYtZoPj/dcQS8e8tc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731460706; c=relaxed/simple;
	bh=S5icxSpgV5ZcqCdzdHkatsAbGiZx8iKb891tf5NZZ5w=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=HW/x+7incrpLO7nKiXIMcXuCrwctUf5W13PLq8IQh1AQ0wmip9G7sTNea2CWGqrf/P7aZya3at7T6pnQp3dRy65jB2zsytg+DahNzrcBjMuzMiSII/hKJCH8opz7vsNv44A7RccX6Ye+DsHKo5uEgbYwMcAfg/NS+DuVVcif0uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Xp54j1JhCz4f3lgL;
	Wed, 13 Nov 2024 09:17:57 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 44DD21A0197;
	Wed, 13 Nov 2024 09:18:16 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCXcYVW_jNnwgiCBg--.65432S3;
	Wed, 13 Nov 2024 09:18:16 +0800 (CST)
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
 <8dc1ee79-fd64-70d7-bb48-b38920c1cddd@huaweicloud.com>
 <cf00703f-f4bd-4b6a-9626-72d839ebaf7b@pkm-inc.com>
 <e9fd5484-619b-e8a9-984c-359bf5475b9f@huaweicloud.com>
 <e32688e7-310e-49fc-9f52-44dd183f9666@pkm-inc.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <adae6bff-8401-b641-438c-d212b20a7430@huaweicloud.com>
Date: Wed, 13 Nov 2024 09:18:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <e32688e7-310e-49fc-9f52-44dd183f9666@pkm-inc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCXcYVW_jNnwgiCBg--.65432S3
X-Coremail-Antispam: 1UD129KBjvJXoW7KrykCF1DWw47Kr15AF1rCrg_yoW8WrW5pa
	y8ur1akryktr1Iy34qyr4xJFy0qrZ3Jw15XrsYgwn5t3s8XFyIqrW09a1Y9as7Zr4Ig34v
	vw48Aasxu34UZrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUbGQ6JUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/11/11 22:07, Dragan Milivojević 写道:
> Reads are fine but writes are many times slower ...
> 
> 
>>
>> I still can't believe your test result, and I can't figure out why
>> internal bitmap is so slow. Hence I use ramdisk(10GB) to create a raid5,
>> and use the same fio script to test, the result is quite different from
>> yours:
>>
>> ram0:            981MiB/s
>> non-bitmap:        132MiB/s
>> internal-bitmap:    95.5MiB/s
>>>

So, I waited for Paul to have a chance to give it a test for real disks,
still, results are similar to above.
> 
> I don't know, I can provide full fio test logs including fio "tracing" 
> for these iodepth 8
> tests if that would make any difference.
> 

No, I don't need fio logs.
> 
> 
>> There is absolutely something wrong here, it doesn't make sense to me
>> that internal bitmap is so slow. However, I have no idea until you can
>> provide the perf result.
> 
> I may be able to find time to do that over the weekend, but don’t hold 
> me to it.
> The test setup will not be the same, server is in production ...
> I did leave some "spare" partitions on all drives to investigate this 
> issue further
> but did not find the time.
> 
> Please send me an example of how would you like me to run the perf tool, 
> I haven't used
> it much.

You can see examples here:

https://github.com/brendangregg/FlameGraph

To be short, while test is running:

perf record -a -g -- sleep 10
perf script -i perf.data | ./stackcollapse-perf.pl | ./flamegraph.pl

BTW, you said that you're using production environment, this will
probably make it hard to analyze performance.

Thanks,
Kuai

