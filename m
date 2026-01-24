Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7E51494C3;
	Sat, 24 Jan 2026 06:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769236945; cv=none; b=Ts8dFFpQyedw7aicu3mVJAy0bETc41MlHb4JeLVKyaOVUC5ivA61OE0tdV7fjyVfk0k6sQ5n/epIRBcRy0GqGNRXcPd+0KKgCdQ4jaCJzR6Tew/Wxneav9VgD3j8vMtxpC+7a6CxynnY25M85aAORC2opJK9B9FPgVIHih4OvnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769236945; c=relaxed/simple;
	bh=kewW54hEEUzq1bMX2iROgbHAUNDHiRiZz4+yw/JHNss=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lUaJaP+YTSvCzF4fDTJOfPIXn5Onk4Sit/PXeG7dzhDfucXQlkCZc8KwD8VeSqT4a4QLtIlzUGwDNQ2SxRNCgfCWpmZTznQqZ5+sYod0IMPf3SSicoHXwOsqrePyyKRZR+j4cyTH47Ct01nx4f/fkUCnqqzGK76YS7EABNHg5Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dylb13P1tzKHMR3;
	Sat, 24 Jan 2026 14:42:05 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 698FB40539;
	Sat, 24 Jan 2026 14:42:11 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgAXxfXBaXRpiJCuEw--.25082S3;
	Sat, 24 Jan 2026 14:42:11 +0800 (CST)
Message-ID: <ee6b631b-79d4-09f7-da38-dfe1dea11d4b@huaweicloud.com>
Date: Sat, 24 Jan 2026 14:42:09 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 1/2] md/raid5: fix IO hang with degraded array with
 llbitmap
To: Yu Kuai <yukuai@fnnas.com>, axboe@kernel.dk, linux-block@vger.kernel.org,
 linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, xni@redhat.com
References: <20260123182623.3718551-1-yukuai@fnnas.com>
 <20260123182623.3718551-2-yukuai@fnnas.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20260123182623.3718551-2-yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXxfXBaXRpiJCuEw--.25082S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tw48WF1DtF17Ww45XrWUArb_yoW8Ww4Upa
	nay3Zxuw1jgFyjgFnxAFyUuF1Fgw48XrWxAFWxJ34fuFyDXr1fKr4fKa45tF13JayFvasx
	X3WDJ34UAFn5GrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU90b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l
	5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67
	AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07Al
	zVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
	MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
	VFxhVjvjDU0xZFpf9x07UMnQUUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2026/1/24 2:26, Yu Kuai 写道:
> When llbitmap bit state is still unwritten, any new write should force
> rcw, as bitmap_ops->blocks_synced() is checked in handle_stripe_dirting().

s/handle_stripe_dirting/handle_stripe_dirtying/

Besides this, LGTM

Reviewed-by: Li Nan <linan122@huawei.com>

> However, later the same check is missing in need_this_block(), causing
> stripe to deadloop during handling because handle_stripe() will decide
> to go to handle_stripe_fill(), meanwhile need_this_block() always return
> 0 and nothing is handled.
> 
> Fixes: 5ab829f1971d ("md/md-llbitmap: introduce new lockless bitmap")
> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
> ---
>   drivers/md/raid5.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 8dc98f545969..93e672b3432b 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3751,9 +3751,14 @@ static int need_this_block(struct stripe_head *sh, struct stripe_head_state *s,
>   	struct r5dev *dev = &sh->dev[disk_idx];
>   	struct r5dev *fdev[2] = { &sh->dev[s->failed_num[0]],
>   				  &sh->dev[s->failed_num[1]] };
> +	struct mddev *mddev = sh->raid_conf->mddev;
> +	bool force_rcw = false;
>   	int i;
> -	bool force_rcw = (sh->raid_conf->rmw_level == PARITY_DISABLE_RMW);
>   
> +	if (sh->raid_conf->rmw_level == PARITY_DISABLE_RMW ||
> +	    (mddev->bitmap_ops && mddev->bitmap_ops->blocks_synced &&
> +	     !mddev->bitmap_ops->blocks_synced(mddev, sh->sector)))
> +		force_rcw = true;
>   
>   	if (test_bit(R5_LOCKED, &dev->flags) ||
>   	    test_bit(R5_UPTODATE, &dev->flags))

-- 
Thanks,
Nan

