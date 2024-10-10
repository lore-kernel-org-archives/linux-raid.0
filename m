Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9C81C460F;
	Thu, 10 Oct 2024 12:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728563923; cv=none; b=h1I8vLCEpDnXtkWFJnS2ZNjH978LBQMaQQkw4HUEI8MD5nxP+QftI3WDJN5naUdLt80Ovu88G/LXwjZaT1rfGdBYJbc1XjDHv1MmNOZ3RINMvyecjAdSoWByJDZXYPztF8R2DlSSOfHSX3dJ7A21zqSnF8ync2aJENLAqpHnJYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728563923; c=relaxed/simple;
	bh=Swsw14X74fndgEQG0s9is/8Fg8PAFlZhqVC6mxKKMGQ=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=k+LFZP/vHhJkvQkh3x8msAQSQJr4Oct7P0ItjfIn9omycTrjLisy+3+PBce07HPMTpNFr/RujBWLke3y6iLxsR6+NTmB77pE5Lrofn/02rhWvADF9VCz7j+oDCxn7cqMDbGT/0bzvQ7CE2sM/22LcUsZ7soBifOf/RMBziG4bWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4XPTnS2qcCz4f3jXX;
	Thu, 10 Oct 2024 20:38:20 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 472E71A018D;
	Thu, 10 Oct 2024 20:38:37 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgD3LMnLygdnN0vVDg--.51151S3;
	Thu, 10 Oct 2024 20:38:37 +0800 (CST)
Subject: Re: [PATCH md-6.12 0/7] md: enhance faulty chekcing for blocked
 handling
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
 Yu Kuai <yukuai1@huaweicloud.com>
Cc: mariusz.tkaczyk@intel.com, song@kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240830072721.2112006-1-yukuai1@huaweicloud.com>
 <20241009091432.00001c26@linux.intel.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <2c218cb8-c553-92f4-b203-54f02328d781@huaweicloud.com>
Date: Thu, 10 Oct 2024 20:38:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241009091432.00001c26@linux.intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3LMnLygdnN0vVDg--.51151S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ZFWDJrWrCF13JrWfCryfJFb_yoW8Kr13pw
	sxJaya9r4UWr17Wasavr1UWryFgw4xJry3Jr9rJw18u34UZr1xAw4kt3WrWF98Zryavan0
	vr15GFZxWFyrAa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
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

ÔÚ 2024/10/09 15:14, Mariusz Tkaczyk Ð´µÀ:
> On Fri, 30 Aug 2024 15:27:14 +0800
> Yu Kuai <yukuai1@huaweicloud.com> wrote:
> 
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> The lifetime of badblocks:
>>
>> - IO error, and decide to record badblocks, and record sb_flags;
>> - write IO found rdev has badblocks and not yet acknowledged, then this
>> IO is blocked;
>> - daemon found sb_flags is set, update superblock and flush badblocks;
>> - write IO continue;
>>
>> Main idea is that badblocks will be set in memory fist, before badblocks
>> are acknowledged, new write request must be blocked to prevent reading
>> old data after power failure, and this behaviour is not necessary if rdev
>> is faulty in the first place.
>>
>> Yu Kuai (7):
>>    md: add a new helper rdev_blocked()
>>    md: don't wait faulty rdev in md_wait_for_blocked_rdev()
>>    md: don't record new badblocks for faulty rdev
>>    md/raid1: factor out helper to handle blocked rdev from
>>      raid1_write_request()
>>    md/raid1: don't wait for Faulty rdev in wait_blocked_rdev()
>>    md/raid10: don't wait for Faulty rdev in wait_blocked_rdev()
>>    md/raid5: don't set Faulty rdev for blocked_rdev
>>
>>   drivers/md/md.c     |  8 +++--
>>   drivers/md/md.h     | 24 +++++++++++++++
>>   drivers/md/raid1.c  | 75 +++++++++++++++++++++++----------------------
>>   drivers/md/raid10.c | 40 +++++++++++-------------
>>   drivers/md/raid5.c  | 13 ++++----
>>   5 files changed, 92 insertions(+), 68 deletions(-)
>>
> 
> 
> Hi,
> We tested this patchset.
> 
> mdmon rework:
> https://github.com/md-raid-utilities/mdadm/pull/66
> 
> Kernel build torvalds/linux.git master:
> commit e32cde8d2bd7d251a8f9b434143977ddf13dcec6
> 
> I applied this patchset on top of that.
> 
> My tests proved that:
> - If only mdmon PR is applied - hangs are reproducible.
> - If only this patchset is applied - hangs are reproducible.
> - If both kernel patchset and mdmon rework are applied- hangs are not
>    reproducible (at least until now).
> 
> It was tricky topic (I needed to deal with weird issues related to shared
> descriptors in mdmon).
> 
> What the most important- there is no regression detected.

Good to here that, I'll send a V2 then. Usually this set will land in
v6.13, because this doesn't look like a fix in kernel. :)

Thanks,
Kuai

> 
> Thanks,
> Mariusz
> 
> .
> 

