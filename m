Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA563987D
	for <linux-raid@vger.kernel.org>; Tue, 13 May 2025 02:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747102440; cv=none; b=V6M6ndmg0fni8bEGPZiHxOhITZ6Mpjdo0Fn+N8YYSRkVUZJD68dPEfGYUF3sKF0Y0vJntwZZluGewxA1VUfSVnl8BBe7xQOcCD9isHCEOadgFXiNFlMP2BPNGvHiSXAIju1/NfSBFc3Pzeo19qYKn5uQhOEkpMMl0gD5P5ketmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747102440; c=relaxed/simple;
	bh=DsrjNSEfiRLeMZwPH6Hrw5Jm0LpjxRRfcnTyPwp0bzg=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=aoh8/G8pU4pRRp1HBbz6HXXeUtlzkqPfe7/HoPBJR5Poj6M4dKsY0cVPyWE5PiT13yrxPX3z/1f234anAD7jKCxm4JnsHL6H9EQ6+ebrXY/e9enO9zf6GFxFn2/dVnGSPleJvcvRlpntsIfa6JLMBTkyVH0Dvzo+HosyLubH6vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4ZxKlD1TvNz4f3jJ5
	for <linux-raid@vger.kernel.org>; Tue, 13 May 2025 10:13:28 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E8AE51A07BD
	for <linux-raid@vger.kernel.org>; Tue, 13 May 2025 10:13:52 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgBXvGDfqiJo9kL9MA--.1609S3;
	Tue, 13 May 2025 10:13:52 +0800 (CST)
Subject: Re: [GIT PULL] md-6.16-20250512
To: Jens Axboe <axboe@kernel.dk>, Yu Kuai <yukuai1@huaweicloud.com>,
 linux-raid@vger.kernel.org, song@kernel.org
Cc: yangerkun@huawei.com, yi.zhang@huawei.com, johnny.chenyi@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250513013837.4067413-1-yukuai1@huaweicloud.com>
 <4df296d5-e6cb-4d11-9d47-76d38a442d24@kernel.dk>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <a7f83029-a46a-e59b-8841-5ed67a1a0034@huaweicloud.com>
Date: Tue, 13 May 2025 10:13:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <4df296d5-e6cb-4d11-9d47-76d38a442d24@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXvGDfqiJo9kL9MA--.1609S3
X-Coremail-Antispam: 1UD129KBjvJXoWrZFyfZF4DXryxAFWUGFW5GFg_yoW8JrWkp3
	yYka90yrs8ZFy3WF4xJr1xtF15twn3J39Ikr15Jr4jkFy5ZF9Yvan2kFsYg3srW3WfJF4F
	9a4YkF95WFy8ZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUBVbkUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/05/13 10:01, Jens Axboe 写道:
> On 5/12/25 7:38 PM, Yu Kuai wrote:
>> Hi Jens,
>>
>> Please consider pulling following changes for md-6.6 on your for-6.16/block
>> branch, this pull request contains:
>>
>> - fix normal IO can be starved by sync IO, found by mkfs on newly created
>> large raid5, with some clean up patches for bdev inflight counters;
>> - add kconfig for md-bitmap, I have decided not to continue optimizing
>> based on the old bitmap implementation, and plan to invent a new lock-less
>> bitmap. And a new kconfig option is a good way for isolation;
> 
> Pulled, and then unpulled. This doesn't even build...
> 
> ERROR: modpost: "md_bitmap_exit" [drivers/md/md-mod.ko] undefined!
> ERROR: modpost: "md_bitmap_init" [drivers/md/md-mod.ko] undefined!
> make[2]: *** [scripts/Makefile.modpost:147: Module.symvers] Error 1
> make[1]: *** [/home/axboe/git/build/Makefile:1954: modpost] Error 2
> make: *** [Makefile:248: __sub-make] Error 2
> 
> Before you send out pull requests, at least ensure that it builds
> both built-in and modular.

My apologize for this, the v3 patchset have this problem and Paul
reported to me, fix it in v4 however, It's a long time and somehow
I picked the v3 set here. :(

Thanks,
Kuai

> 

