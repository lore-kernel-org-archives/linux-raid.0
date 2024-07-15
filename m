Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84EC94C6D;
	Mon, 15 Jul 2024 01:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721008580; cv=none; b=HdxDlgbBnFbaL9Vz4PHsfT4lJ7ua1edssDreimwISRJS57LpJ+aIspDFHXkMpUAHzKxPYyFlWgg6idVZ0uCVBUq0BPVHjC/iUGK1uY1mVywr9+QPox4VVZuNCRb5LMMr7l2JXVNGCvOYzY9LdlmSdxFJTFlR9/V+UFUt3srGZOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721008580; c=relaxed/simple;
	bh=KD4PlfZbPnMC3rkkwPMCI/J3H4+TVk6dGdxwy+F4UcQ=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=MhkWhaN0PFDgAI2re0yN1K5icDW+k+XKYdK1N42y6ELwSLxS5Z+wbX4p3ViG4sDPhSN7xg0OAVinoKrAsh5fnsLsgyfkzqHiPJ+54lpv1LNukGhLogfPMld7j9bIPGHSnnKziYnVV7DIB4bhQB6Q3uMap8gWG00axWHzDhiVxfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WMlfL4MmMz4f3kvR;
	Mon, 15 Jul 2024 09:55:54 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id AF8031A0181;
	Mon, 15 Jul 2024 09:56:07 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgA3Gzm2gZRmXtGlAA--.23571S3;
	Mon, 15 Jul 2024 09:56:07 +0800 (CST)
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
 <517243f0-77c5-9d67-a399-78c449f6afc6@huaweicloud.com>
 <810a319b846c7e16d85a7f52667d04252a9d0703.camel@yandex.ru>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <9c60881e-d28f-d8d5-099c-b9678bd69db9@huaweicloud.com>
Date: Mon, 15 Jul 2024 09:56:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <810a319b846c7e16d85a7f52667d04252a9d0703.camel@yandex.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgA3Gzm2gZRmXtGlAA--.23571S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAw4DZrWUCFyfGr1DJF45Awb_yoW5Zw4kpa
	93Gan0ga1DKF1I93s7tw1xXFyYyrs5trWUJr98GrWjy398WFyIqF1xKrs0gF98W34xWa1Y
	v348KFWUuFyUAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4U
	JVW0owA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
	1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
	b7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
	vE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa
	73UjIFyTuYvjfUYCJmUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/07/13 21:50, Konstantin Kharlamov 写道:
> On Sat, 2024-07-13 at 19:06 +0800, Yu Kuai wrote:
>> Hi,
>>
>> 在 2024/07/12 20:11, Konstantin Kharlamov 写道:
>>> Good news: you diff seems to have fixed the problem! I would have
>>> to
>>> test more extensively in another environment to be completely sure,
>>> but
>>> by following the minimal steps-to-reproduce I can no longer
>>> reproduce
>>> the problem, so it seems to have fixed the problem.
>>
>> That's good. :)
>>>
>>> Bad news: there's a new lockup now 😄 This one seems to happen
>>> after
>>> the disk is returned back; unless the action of returning back
>>> matches
>>> accidentally the appearing stacktraces, which still might be
>>> possible
>>> even though I re-tested multiple times. It's because the traces
>>> (below) seems not to always appear. However, even when traces do
>>> not
>>> appear, IO load on the fio that's running in the background drops
>>> to
>>> zero, so something seems definitely wrong.
>>
>> Ok, I need to investigate more for this. The call stack is not much
>> helpful.
> 
> Is it not helpful because of missing line numbers or in general? If
> it's the missing line numbers I'll try to fix that. We're using some
> Debian scripts that create deb packages, and well, they don't work well
> with debug information (it's being put to separate package, but even if
> it's installed the kernel traces still don't have line numbers). I
> didn't investigate into it, but I can if that will help.

Line number will be helpful. Meanwhile, can you check if the underlying
disks has IO while raid5 stuck, by /sys/block/[device]/inflight.
> 
>> At first, can the problem reporduce with raid1/raid10? If not, this
>> is
>> probably a raid5 bug.
> 
> This is not reproducible with raid1 (i.e. no lockups for raid1), I
> tested that. I didn't test raid10, if you want I can try (but probably
> only after the weekend, because today I was asked to give the nodes
> away, for the weekend at least, to someone else).

Yes, please try raid10 as well. For now I'll say this is a raid5
problem.
> 
>> The best will be that if I can reporduce this problem myself.
>> The problem is that I don't understand the step 4: turning off jbod
>> slot's power, is this only possible for a real machine, or can I do
>> this in my VM?
> 
> Well, let's say that if it is possible, I don't know a way to do that.
> The `sg_ses` commands that I used
> 
> 	sg_ses --dev-slot-num=9 --set=3:4:1   /dev/sg26 # turning off
> 	sg_ses --dev-slot-num=9 --clear=3:4:1 /dev/sg26 # turning on
> 
> …sets and clears the value of the 3:4:1 bit, where the bit is defined
> by the JBOD's manufacturer datasheet. The 3:4:1 specifically is defined
> by "AIC" manufacturer. That means the command as is unlikely to work on
> a different hardware.

I never do this before, I'll try.
> 
> Well, while on it, do you have any thoughts why just using a `echo 1 >
> /sys/block/sdX/device/delete` doesn't reproduce it? Does perhaps kernel
> not emulate device disappearance too well?

echo 1 > delete just delete the disk from kernel, and scsi/dm-raid will
know that this disk is deleted. However, the disk will stay in kernel
for the other way, dm-raid does not aware that underlying disks are
problematic and IO will still be generated and issued.

Thanks,
Kuai

> .
> 

