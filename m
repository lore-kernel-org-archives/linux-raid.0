Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C54B1EF09B;
	Sat, 24 Jan 2026 01:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769219922; cv=none; b=nFqD2w7mi6KtihkKUR503EwSh3P/jdmdXoFEkSrQstgscBtehgHEQJpfrslR9NakkVi3rvSg06DFIpdpODJDrR0gWBKjJZqSvuat7IC0+UFVVDhhZARJT7zlKn5koi9kTMOUk3EEYiRwPsrVWFYuj91WheS5RePBMeYDPETBByA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769219922; c=relaxed/simple;
	bh=hMTIz3FD9kWHY1lDN55PY9YkcUtF/zYmEsdmq0uVsSY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eMXkP3fXZTz1icfujqZdQ3tRkSeru2COWsFmDAz7SO/AFt7rS0GOJRi+7N47hS9g6dGbXGUDpkF9tAHS9UfgST/3sCjdXYF7ZSxmoNL0NIy1eplc+K8DfbSf9aL6tARlmnpqaiRTWe18HAWXK7hM7b0i1H7Nw2hO9Q6ZXw/5ixE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dydHD53dczYQtGF;
	Sat, 24 Jan 2026 09:58:00 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 78D114058D;
	Sat, 24 Jan 2026 09:58:30 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgBHp_dEJ3RpkPSWEw--.35737S3;
	Sat, 24 Jan 2026 09:58:30 +0800 (CST)
Message-ID: <85477dfd-708c-44f8-26ee-19d3328fb9ae@huaweicloud.com>
Date: Sat, 24 Jan 2026 09:58:28 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 2/2] md/md-llbitmap: fix percpu_ref not resurrected on
 suspend timeout
To: Yu Kuai <yukuai@fnnas.com>, axboe@kernel.dk, linux-block@vger.kernel.org,
 linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, xni@redhat.com
References: <20260123182623.3718551-1-yukuai@fnnas.com>
 <20260123182623.3718551-3-yukuai@fnnas.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20260123182623.3718551-3-yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHp_dEJ3RpkPSWEw--.35737S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tw4UJw47XF1rGFWkJF13Arb_yoW8GFWfpr
	WxK3yYyF4rJF10g3WUJrZ8AFySvan7trZ7GFWkA34rC3ZxCFnYgw4rGFyqqrn7ursxGFn8
	Xr4Ygan8W3WUZrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU90b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487
	Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aV
	AFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xF
	o4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIda
	VFxhVjvjDU0xZFpf9x07UMnQUUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2026/1/24 2:26, Yu Kuai 写道:
> When llbitmap_suspend_timeout() times out waiting for percpu_ref to
> become zero, it returns -ETIMEDOUT without resurrecting the percpu_ref.
> The caller (md_llbitmap_daemon_fn) then continues to the next page
> without calling llbitmap_resume(), leaving the percpu_ref in a killed
> state permanently.
> 
> Fix this by resurrecting the percpu_ref before returning the error,
> ensuring the page control structure remains usable for subsequent
> operations.
> 
> Fixes: 5ab829f1971d ("md/md-llbitmap: introduce new lockless bitmap")
> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
> ---
>   drivers/md/md-llbitmap.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index b482a1db0861..7df15756142d 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
> @@ -779,8 +779,10 @@ static int llbitmap_suspend_timeout(struct llbitmap *llbitmap, int page_idx)
>   	percpu_ref_kill(&pctl->active);
>   
>   	if (!wait_event_timeout(pctl->wait, percpu_ref_is_zero(&pctl->active),
> -			llbitmap->mddev->bitmap_info.daemon_sleep * HZ))
> +			llbitmap->mddev->bitmap_info.daemon_sleep * HZ)) {
> +		percpu_ref_resurrect(&pctl->active);
>   		return -ETIMEDOUT;
> +	}
>   
>   	return 0;
>   }

LGTM

Reviewed-by: Li Nan <linan122@huawei.com>

-- 
Thanks,
Nan

