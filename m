Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5591DFF0;
	Tue,  4 Nov 2025 03:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762227957; cv=none; b=OAw0CDsiakA3QYIytDrv2bz9S2DuB46LqKZr1348V866lwzWr6y5XzJYASUONwo8tkyR52H1dRL96BefV8yeS99cg096bc027SC4yRRse4H254pn6ld9Fig1ITMDVYSiS/B9d2jnJfMUyndEeBpM0QCYj0vy4AQp7YgkE8DrtsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762227957; c=relaxed/simple;
	bh=pRhxJLD0m7N+jNzwNyFTId/I+zQqH+FwaDM9WVDKpoU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=asEeHkUDNW8eYJ8yqw70I8H7nK6P2FUaABd3e4bHxQP9LRi2Sr7nSjryDykdkN6tRxYeD8CIMGYa8+Hbtjb7enN2NndsnWQGr0Agv2ISE+5b3S1UMOwIZdGe+LM7VzNT8lfalwpXZ729qeYym1vydo+hh0JmGuOl5dXkoEPVJCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4d0vVm3Fn9zYQthk;
	Tue,  4 Nov 2025 11:45:36 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id D87371A1A55;
	Tue,  4 Nov 2025 11:45:50 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP2 (Coremail) with SMTP id Syh0CgBnvUXtdglpwaSRCg--.51473S3;
	Tue, 04 Nov 2025 11:45:50 +0800 (CST)
Message-ID: <2e1ab3ee-06ac-3fca-8356-034afe813b57@huaweicloud.com>
Date: Tue, 4 Nov 2025 11:45:49 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] md/raid5: remove redundant __GFP_NOWARN
To: Huiwen He <hehuiwen@kylinos.cn>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251102152540.871568-1-hehuiwen@kylinos.cn>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20251102152540.871568-1-hehuiwen@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBnvUXtdglpwaSRCg--.51473S3
X-Coremail-Antispam: 1UD129KBjvdXoWruryrtF13Gw1fCF1DAw1xGrg_yoWDZrcE9a
	ySqr1Yqr4ayry2va1fuF1rZF95twnYqrWxuayxtrWavFyrWw48GFnxZr1xJ3y3GrW7KFWD
	CrWvqay8JryUZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb3kYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l
	5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67
	AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07Al
	zVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
	MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
	VFxhVjvjDU0xZFpf9x07jb2-nUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/11/2 23:25, Huiwen He 写道:
> The __GFP_NOWARN flag was included in GFP_NOWAIT since commit
> 16f5dfbc851b ("gfp: include __GFP_NOWARN in GFP_NOWAIT"). So
> remove the redundant __GFP_NOWARN flag.
> 
> Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
> ---
>   drivers/md/raid5-cache.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index ba768ca7f422..e29e69335c69 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -3104,7 +3104,7 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
>   		goto out_mempool;
>   
>   	spin_lock_init(&log->tree_lock);
> -	INIT_RADIX_TREE(&log->big_stripe_tree, GFP_NOWAIT | __GFP_NOWARN);
> +	INIT_RADIX_TREE(&log->big_stripe_tree, GFP_NOWAIT);
>   
>   	thread = md_register_thread(r5l_reclaim_thread, log->rdev->mddev,
>   				    "reclaim");

This patch seems to have been sent twice.

LGTM
Reviewed-by: Li Nan <linan122@huawei.com>

-- 
Thanks,
Nan

