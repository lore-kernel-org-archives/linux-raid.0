Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA10560263;
	Sat, 13 Jul 2024 11:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720868776; cv=none; b=k+W3VRPBcyOPjy3dpeq4UsqaCBF1X618Gh82Udb07x0qpxMJ0VlAu+7jOGAMbpspn+vSHA6zMUO9D1hO7guSeu+A2fxX8w9r0DBGomA2JhBq6fouUm+JlxpeLhIYNEwVvQoIO1/ROLjQUdmB0eEyEYH1wfVOLGpE8OZ/hBNyCJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720868776; c=relaxed/simple;
	bh=mRhenjtZ8GBircd/QZnMybGcJZi3aKBbUL+eVyT/kmQ=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=R3iZwvbimoN8Vx5PG6D+urtms1n6evhxtJxLLT86a2nWs5rpl60RUk+g9mEK1UyfqcYJFSnMDwyTgBTGU09k7VrN26x2F6KNR7RtC8ifi0lubEo/XbKbjJ5XKUn4rKjg3uONBDtYTKlSgaNn1D1g2kzXRUYHMZdYdViT5rLmqBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4WLlxz0PLnz4f3jMl;
	Sat, 13 Jul 2024 19:05:59 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D6CFA1A0170;
	Sat, 13 Jul 2024 19:06:10 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgA3GzmiX5Jm5q8JAA--.5687S3;
	Sat, 13 Jul 2024 19:06:10 +0800 (CST)
Subject: Re: Lockup of (raid5 or raid6) + vdo after taking out a disk under
 load
To: Konstantin Kharlamov <Hi-Angel@yandex.ru>,
 Yu Kuai <yukuai1@huaweicloud.com>, Song Liu <song@kernel.org>,
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yangerkun@huawei.com" <yangerkun@huawei.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <a6d068a26a90057fb3cdaa59f9d57a2af41a6b22.camel@yandex.ru>
 <1f879e67-4d64-4df0-5817-360d84ff8b89@huaweicloud.com>
 <29d69e586e628ef2e5f2fd7b9fe4e7062ff36ccf.camel@yandex.ru>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <517243f0-77c5-9d67-a399-78c449f6afc6@huaweicloud.com>
Date: Sat, 13 Jul 2024 19:06:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <29d69e586e628ef2e5f2fd7b9fe4e7062ff36ccf.camel@yandex.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgA3GzmiX5Jm5q8JAA--.5687S3
X-Coremail-Antispam: 1UD129KBjvdXoW7JrWDXFy5Ar47Aw17Ww1ftFb_yoWkKrgE9a
	yYkasYkas8Ars7GF40gr4UZFnrG395WF1UXw18CrWI9ryFvanxCF4kG3s3Xr1fXrZagF9x
	Jws7Cr1ruw1a9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb38FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
	1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7Mxk0xIA0c2IEe2xFo4CE
	bIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
	v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
	1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
	AIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI
	42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWI
	evJa73UjIFyTuYvjfUr2-eDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/07/12 20:11, Konstantin Kharlamov 写道:
> Good news: you diff seems to have fixed the problem! I would have to
> test more extensively in another environment to be completely sure, but
> by following the minimal steps-to-reproduce I can no longer reproduce
> the problem, so it seems to have fixed the problem.

That's good. :)
> 
> Bad news: there's a new lockup now 😄 This one seems to happen after
> the disk is returned back; unless the action of returning back matches
> accidentally the appearing stacktraces, which still might be possible
> even though I re-tested multiple times. It's because the traces
> (below) seems not to always appear. However, even when traces do not
> appear, IO load on the fio that's running in the background drops to
> zero, so something seems definitely wrong.

Ok, I need to investigate more for this. The call stack is not much
helpful.

At first, can the problem reporduce with raid1/raid10? If not, this is
probably a raid5 bug.

The best will be that if I can reporduce this problem myself.
The problem is that I don't understand the step 4: turning off jbod
slot's power, is this only possible for a real machine, or can I do
this in my VM?

Thanks,
Kuai


