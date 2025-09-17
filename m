Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5BE27B327;
	Wed, 17 Sep 2025 10:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758103601; cv=none; b=hZaKWiCY+OgzTysJGVLFrikmTJ6tj4xsMbIQ/q3TM0aMq667Mebg6E/eS6ZWOvMwo0mjAAqLAfpi8qe7JrJ4LnoreOhmLR6fSQOHsTrzfzSoFO0dBAy/2rNz038k04mZXystr8fbeGj4fKWPv0RJBRzSTlhFylrC/tszU2PGP20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758103601; c=relaxed/simple;
	bh=4H7w74kOVrwbV2irBRMsmDZlOg38mt3/G8I4umuYaQY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aBjCfTbDBR5HGmA0ob4oH794272vmAnVb2xQz5uW9+5nZPOzxb69YmorjdiTykqfilEyAvm/O+b3QczvcgD/0sbvKRn9GgxPaObnpFbwg4yN3kL+lXmdWpp/QmsxQeopJHExnpXQvcCmFx45aL6dNkMobGIxrILFbGO82SYK+0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cRZDV4CkzzKHMrh;
	Wed, 17 Sep 2025 18:06:34 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 4F0661A1C8C;
	Wed, 17 Sep 2025 18:06:35 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP4 (Coremail) with SMTP id gCh0CgDnMY4piMpoO6U3Cw--.50656S3;
	Wed, 17 Sep 2025 18:06:35 +0800 (CST)
Message-ID: <cd9aa561-7a0a-3400-1896-8afed3d7cbb3@huaweicloud.com>
Date: Wed, 17 Sep 2025 18:06:33 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v4 6/9] md/raid1,raid10: Fix missing retries Failfast
 write bios on no-bbl rdevs
To: Kenta Akagi <k@mgml.me>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>, Mariusz Tkaczyk <mtkaczyk@kernel.org>,
 Shaohua Li <shli@fb.com>, Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250915034210.8533-1-k@mgml.me>
 <20250915034210.8533-7-k@mgml.me>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20250915034210.8533-7-k@mgml.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDnMY4piMpoO6U3Cw--.50656S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ZrW5ury5KrWrCrWktFyDGFg_yoW8ArWkpF
	Z3KFyftryqq34I93W3A347XF1rA3yxG3y7Jr4fG348u345ur1xGF48Wa10gFyDCryfWw12
	qF4UCryDWFWUWa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Fb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487
	Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aV
	AFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xF
	o4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcS
	sGvfC2KfnxnUUI43ZEXa7IU1d-PUUUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/9/15 11:42, Kenta Akagi 写道:
> In the current implementation, write failures are not retried on rdevs
> with badblocks disabled. This is because narrow_write_error, which issues
> retry bios, immediately returns when badblocks are disabled. As a result,
> a single write failure on such an rdev will immediately mark it as Faulty.
> 

IMO, there's no need to add extra logic for scenarios where badblocks
is not enabled. Do you have real-world scenarios where badblocks is
disabled?

> The retry mechanism appears to have been implemented under the assumption
> that a bad block is involved in the failure. However, the retry after
> MD_FAILFAST write failure depend on this code, and a Failfast write request
> may fail for reasons unrelated to bad blocks.
> 
> Consequently, if failfast is enabled and badblocks are disabled on all
> rdevs, and all rdevs encounter a failfast write bio failure at the same
> time, no retries will occur and the entire array can be lost.
> 
> This commit adds a path in narrow_write_error to retry writes even on rdevs
> where bad blocks are disabled, and failed bios marked with MD_FAILFAST will
> use this path. For non-failfast cases, the behavior remains unchanged: no
> retry writes are attempted to rdevs with bad blocks disabled.
> 
> Fixes: 1919cbb23bf1 ("md/raid10: add failfast handling for writes.")
> Fixes: 212e7eb7a340 ("md/raid1: add failfast handling for writes.")
> Signed-off-by: Kenta Akagi <k@mgml.me>
> ---
>   drivers/md/raid1.c  | 44 +++++++++++++++++++++++++++++---------------
>   drivers/md/raid10.c | 37 ++++++++++++++++++++++++-------------
>   2 files changed, 53 insertions(+), 28 deletions(-)
> 				 !test_bit(Faulty, &rdev->flags) &&

-- 
Thanks,
Nan

