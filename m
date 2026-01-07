Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DDA79CD;
	Wed,  7 Jan 2026 02:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767751775; cv=none; b=ahxO7vQzr6Grt+LR6+cxVaaESpusIEX0busXJm3rrhgToEd2mW26+5pGn/fM9X5C6omT2ICsy5KFiL+g0JRsJlUi/M+USEpS7Nf8IFWdb++gCrNKajBuqKFg/pVrNIRxKFGni7VVJcgqYb/O3xt/SRkynLwQ6PrCzycBVNhOg98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767751775; c=relaxed/simple;
	bh=Q6lpAgTVp2gIwawrtFG7TP1zq/X33aJHMXDPChZrzZQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YLaqIhmztF+gGmboLi7LicvATFCB52AiDbrlDr5QMAASiyV42UU4vOot9/jKo/a/jH8+LQASewbcMb65ZsQUCW0brYxYSv74bVhWkkPwQQH07xBYAIFl7I94ES+Fr38jfAK8oLxgB5DNZH4PPgQrj6cGkU1TA8N7gyOo9Av3fD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dmBKZ18KXzKHMPT;
	Wed,  7 Jan 2026 10:08:50 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C122840590;
	Wed,  7 Jan 2026 10:09:30 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgDXOPlYwF1p+zudCw--.21510S3;
	Wed, 07 Jan 2026 10:09:30 +0800 (CST)
Message-ID: <99d2ccd8-cd19-fd6f-50c5-a4eb9020f301@huaweicloud.com>
Date: Wed, 7 Jan 2026 10:09:28 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v6 1/2] md: Don't set MD_BROKEN for RAID1 and RAID10 when
 using FailFast
To: Kenta Akagi <k@mgml.me>, linan666@huaweicloud.com, xni@redhat.com,
 Yu Kuai <yukuai@fnnas.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 song@kernel.org, shli@fb.com, mtkaczyk@kernel.org
References: <0106019b9349bf39-5460c782-3d63-43cb-a56e-e34760ce51cd-000000@ap-northeast-1.amazonses.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <0106019b9349bf39-5460c782-3d63-43cb-a56e-e34760ce51cd-000000@ap-northeast-1.amazonses.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDXOPlYwF1p+zudCw--.21510S3
X-Coremail-Antispam: 1UD129KBjvJXoWxury3trykAF4fKw4ftFy5Arb_yoW5Xw18pa
	4xXan0krs8Jryrta1UGry0ga4ayrWfK3y7Wr1rC3sFywn0vr1Sqr4jgr1a9Fyq9w1xZFyU
	t3yUXr98uayDZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9E14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v
	4I1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwI
	xGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
	Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
	IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k2
	6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
	AFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbQVy7UUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2026/1/6 20:30, Kenta Akagi 写道:
> Hi,
> Thank you for reviewing.
> 
> On 2026/01/06 11:57, Li Nan wrote:
>>
>>
>> 在 2026/1/5 22:40, Kenta Akagi 写道:
>>> After commit 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10"),
>>> if the error handler is called on the last rdev in RAID1 or RAID10,
>>> the MD_BROKEN flag will be set on that mddev.
>>> When MD_BROKEN is set, write bios to the md will result in an I/O error.
>>>
>>> This causes a problem when using FailFast.
>>> The current implementation of FailFast expects the array to continue
>>> functioning without issues even after calling md_error for the last
>>> rdev.  Furthermore, due to the nature of its functionality, FailFast may
>>> call md_error on all rdevs of the md. Even if retrying I/O on an rdev
>>> would succeed, it first calls md_error before retrying.
>>>
>>> To fix this issue, this commit ensures that for RAID1 and RAID10, if the
>>> last In_sync rdev has the FailFast flag set and the mddev's fail_last_dev
>>> is off, the MD_BROKEN flag will not be set on that mddev.
>>>
>>> This change impacts userspace. After this commit, If the rdev has the
>>> FailFast flag, the mddev never broken even if the failing bio is not
>>> FailFast. However, it's unlikely that any setup using FailFast expects
>>> the array to halt when md_error is called on the last rdev.
>>>
>>
>> In the current RAID design, when an IO error occurs, RAID ensures faulty
>> data is not read via the following actions:
>> 1. Mark the badblocks (no FailFast flag); if this fails,
>> 2. Mark the disk as Faulty.
>>
>> If neither action is taken, and BROKEN is not set to prevent continued RAID
>> use, errors on the last remaining disk will be ignored. Subsequent reads
>> may return incorrect data. This seems like a more serious issue in my opinion.
> 
> I agree that data inconsistency can certainly occur in this scenario.
> 
> However, a RAID1 with only one remaining rdev can considered the same as a plain
> disk. From that perspective, I do not believe it is the mandatory responsibility
> of md raid to block subsequent writes nor prevent data inconsistency in this situation.
> 
> The commit 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10") that introduced
> BROKEN for RAID1/10 also does not seem to have done so for that responsibility.
> 
>>
>> In scenarios with a large number of transient IO errors, is FailFast not a
>> suitable configuration? As you mentioned: "retrying I/O on an rdev would
> 
> It seems be right about that. Using FailFast with unstable underlayer is not good.
> However, as md raid, which is issuer of FailFast bios,
> I believe it is incorrect to shutdown the array due to the failure of a FailFast bio.
> 
> Thanks,
> Akagi
> 

I get your point, Kuai, what's your take on this?

-- 
Thanks,
Nan

