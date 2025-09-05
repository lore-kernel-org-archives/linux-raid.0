Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00C62D0636;
	Fri,  5 Sep 2025 09:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757062956; cv=none; b=Xg1kSogxzcxcRUt2vgygDZ1gFPPInPLlMAZ0LFGyz1gtMRNftmqu46yAYMF8VGqJAfRmlLq9hSz/Ft+ZkST1S1b1KKbaSAxDBahI6Q77O4Y3CsAKprahNUxDseSrG3ZbRPC/esgU+58u4fkMkOm6xh1yPNjtr8kZ2tP7n7PKpAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757062956; c=relaxed/simple;
	bh=KT7TYlwSF7ukf4zSB0FdcwITV86mOnoX+raOv04H5Pg=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=GPR7IAfnDoiPD0J5V6Ymte/kVCvrUfbfL3gix8+4Wdi+VoLnl9GjIXQEa12ZVLiYJ2x8WYqo5JWfNwKteC2DIZm061g6xTGQHPcM/DN9BJY3vF/UBBPgK8V93YiaJX7nMuWs7xyYk3HcLobMR9EJAieGCSaS8Vcr7+fgqYHQF3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cJ9N74331zYQtJF;
	Fri,  5 Sep 2025 17:02:31 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 140161A1965;
	Fri,  5 Sep 2025 17:02:30 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgB3wY0lp7powuzYBQ--.44441S3;
	Fri, 05 Sep 2025 17:02:29 +0800 (CST)
Subject: Re: [PATCH] md/md-linear: Enable atomic writes
To: John Garry <john.g.garry@oracle.com>, song@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 martin.petersen@oracle.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250903161052.3326176-1-john.g.garry@oracle.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <b6820280-cc1f-beae-2c1c-077d46bbf721@huaweicloud.com>
Date: Fri, 5 Sep 2025 17:02:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250903161052.3326176-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3wY0lp7powuzYBQ--.44441S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Aw4DZFWDAw1DCFy5Gr17Wrg_yoW8Gw4Dp3
	yxXa4IyFyDJFyUWay5X3yxuF4Fgr98Jr47KFy3Xw40kFn5WrnrCFy3tws8XF9rAw1ru3Zr
	J3W0kryqv3Wqg3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AF
	wI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1D
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8
	JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7IUb
	iF4tUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2025/09/04 0:10, John Garry Ð´µÀ:
> All the infrastructure has already been plumbed to support this for
> stacked devices, so just enable the request_queue limits features flag.
> 
> A note about chunk sectors for linear arrays:
> While it is possible to set a chunk sectors param for building a linear
> array, this is for specifying the granularity at which data sectors from
> the device are used. It is not the same as a stripe size, like for RAID0.
> 
> As such, it is not appropriate to set chunk_sectors request queue limit to
> the same value, as chunk_sectors request limit is a boundary for which
> requests cannot straddle.
> 
> However, request_queue limit max_hw_sectors is set to chunk sectors, which
> almost has the same effect as setting chunk_sectors limit.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> 
> diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
> index 5d9b081153757..30ac29b990c9b 100644
> --- a/drivers/md/md-linear.c
> +++ b/drivers/md/md-linear.c
> @@ -74,6 +74,7 @@ static int linear_set_limits(struct mddev *mddev)
>   	lim.max_hw_sectors = mddev->chunk_sectors;
>   	lim.max_write_zeroes_sectors = mddev->chunk_sectors;
>   	lim.io_min = mddev->chunk_sectors << 9;
> +	lim.features |= BLK_FEAT_ATOMIC_WRITES;
>   	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
>   	if (err)
>   		return err;
> 

LGRM
Reviewed-by: Yu Kuai <yukuai3@huawei.com>

