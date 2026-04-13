Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937CE175A70
	for <linux-raid@vger.kernel.org>; Mon, 13 Apr 2026 07:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776066488; cv=none; b=srGLitSSzu4QA5nTCBJ3YYzLSgd8lTbyOJysmggy6riTxX4NRKokRgS/RyqseDeJPKZnT4E4bgrNfX8RpmZiXfZ5PSbFf+BBtLOu+wUtOY8ZgabQYcORDeyxNWu2mpkNDLiAZIj3qvnL79VipKGr6yyfYVFxnZI53SGTOoBtvK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776066488; c=relaxed/simple;
	bh=MdZqSAoavpDjz/YUz4lLQ90b4iR2ekzWEtGj6VG7JyQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OJLG6G857iR+a0Nd1KrM58vbG+jHGTXHcEQ3cvji9Fv5q5CWeCC97sSfFZ3g/+QjefVHolHYYDqwAo1rFj04UKaDnEhZu2+/H6W3G9mY6jh4BXne9NZXbtd7wU5GlY/VvnH6qySPs5OJ9KAun0dZWMiuB18hhaQs8MjdSoJ4oWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fvKJQ14K1zKHM01
	for <linux-raid@vger.kernel.org>; Mon, 13 Apr 2026 15:47:50 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 5967940539
	for <linux-raid@vger.kernel.org>; Mon, 13 Apr 2026 15:47:56 +0800 (CST)
Received: from [10.174.178.255] (unknown [10.174.178.255])
	by APP3 (Coremail) with SMTP id _Ch0CgAHtL2qn9xp_4fzAA--.58147S3;
	Mon, 13 Apr 2026 15:47:56 +0800 (CST)
Message-ID: <5fae3215-4280-fc77-f9e0-2f607176fcd3@huaweicloud.com>
Date: Mon, 13 Apr 2026 15:47:54 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 1/5] md/md-bitmap: call md_bitmap_create,destroy in
 location_store
To: Su Yue <glass.su@suse.com>, linux-raid@vger.kernel.org
Cc: song@kernel.org, xni@redhat.com, yukuai@fnnas.com, heming.zhao@suse.com,
 l@damenly.org
References: <20260407102625.5686-1-glass.su@suse.com>
 <20260407102625.5686-2-glass.su@suse.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20260407102625.5686-2-glass.su@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgAHtL2qn9xp_4fzAA--.58147S3
X-Coremail-Antispam: 1UD129KBjvJXoW7WF4UAr4fKw47WF1fGw1fXrb_yoW8WryDpa
	97Ja45C3y3JryFgF47uaykuFyrWan7Kr9rKryxuwn3uFnxJFnIgF4rWF15Aw1xGryrZFs8
	XFy5JF1rWF1j9FJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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



在 2026/4/7 18:26, Su Yue 写道:
> If bitmap/location is present, mdadm will call update_array_info()
> while growing bitmap from none to internal via location_store().
> md_bitmap_create() is needed to set mddev->bitmap_ops otherwise
> mddev->bitmap_ops->get_stats() in update_array_info() will trigger
> kernel NULL pointer dereference.
> 
> Fixes: fb8cc3b0d9db ("md/md-bitmap: delay registration of bitmap_ops until creating bitmap")
> Signed-off-by: Su Yue <glass.su@suse.com>
> ---
>   drivers/md/md-bitmap.c | 11 ++++++++---
>   drivers/md/md.c        |  4 ++--
>   drivers/md/md.h        |  2 ++
>   3 files changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 83378c033c72..2f24aae05552 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -2618,7 +2618,7 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
>   			goto out;
>   		}
>   
> -		bitmap_destroy(mddev);
> +		md_bitmap_destroy(mddev);
>   		mddev->bitmap_info.offset = 0;
>   		if (mddev->bitmap_info.file) {
>   			struct file *f = mddev->bitmap_info.file;
> @@ -2653,15 +2653,20 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
>   				goto out;
>   			}
>   
> +			/*
> +			 * lockless bitmap shoudle have set bitmap_id
> +			 * using bitmap_type, so always ID_BITMAP.
> +			 */
> +			mddev->bitmap_id = ID_BITMAP;
>   			mddev->bitmap_info.offset = offset;
> -			rv = bitmap_create(mddev);
> +			rv = md_bitmap_create(mddev);
>   			if (rv)
>   				goto out;
>   
>   			rv = bitmap_load(mddev);

mddev->bitmap_ops->load() should also be used here.

-- 
Thanks,
Nan

