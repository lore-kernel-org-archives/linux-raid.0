Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E52A2E7631;
	Sat, 21 Mar 2026 06:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774074579; cv=none; b=eC4B3jnW5L8Cy1rfDBdihE5JtM0KyyOMtxsj8nurt+F4c3jZrr61HYlnPlum9usZpvMnTBCKIC68a/rpS4vVoEjdw5qRr+Bm3RaOo7DIyQ05r/NjmSBC3LeGSZxeJz+m2NPXDV4lzapb1pNY3ayM3Rlg/FgVJlnlg7uy8Fxk1ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774074579; c=relaxed/simple;
	bh=0k4mpUkaidgk/QoWN4SXhKG5D8a+EUcmf/8uDLK8Ss8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qFfXhYdWzb28S1GP590akteVS6bMet+aK2Xr30rrxndH1JSi9kdINckqHiwau/mxftV0kAyzWDSUE4a7kplu9ThJ+6SIlsUjwd1XNIGX4Lytue6kmDiqWM8iHl5K3S+6DVKK+VKfGoMhE7MH8eBody7HlrLftl8Bsa5WLeZmN2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fd8f048CDzKHMPg;
	Sat, 21 Mar 2026 14:28:56 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 96D414056E;
	Sat, 21 Mar 2026 14:29:28 +0800 (CST)
Received: from [10.174.178.255] (unknown [10.174.178.255])
	by APP1 (Coremail) with SMTP id cCh0CgA3OtrGOr5pzkW0Bg--.21396S3;
	Sat, 21 Mar 2026 14:29:28 +0800 (CST)
Message-ID: <84ec0c9e-4651-b66b-8793-36ba823fce75@huaweicloud.com>
Date: Sat, 21 Mar 2026 14:29:34 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] md/raid0: use kvzalloc/kvfree for strip_zone and devlist
 allocations
To: Gregory Price <gourry@gourry.net>, song@kernel.org, yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, syzbot+924649752adf0d3ac9dd@syzkaller.appspotmail.com,
 akpm@linux-foundation.org
References: <69adaba8.a00a0220.b130.0005.GAE@google.com>
 <20260308234202.3118119-1-gourry@gourry.net>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20260308234202.3118119-1-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgA3OtrGOr5pzkW0Bg--.21396S3
X-Coremail-Antispam: 1UD129KBjvJXoW7CFyUXr1rCw4UXw4UZw1xAFb_yoW5JF4kpa
	1rW3Z8JrWrJrn8GFyDJ3yxua4agw4fJrW0kFZ3Xay8ZFZIvrWktrW3AFyYgr1IkFyxCa4r
	XFWYkFZ5Ja1DJrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9jb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l
	5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67
	AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07Al
	zVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
	MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvf
	C2KfnxnUUI43ZEXa7IU8rWrtUUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2026/3/9 7:42, Gregory Price 写道:
> syzbot reported a WARNING at mm/page_alloc.c:__alloc_frozen_pages_noprof()
> triggered by create_strip_zones() in the RAID0 driver.
> 
> When raid_disks is large, the allocation size exceeds MAX_PAGE_ORDER (4MB
> on x86), causing WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER).
> 
> Convert the strip_zone and devlist allocations from kzalloc/kzalloc_objs to
> kvzalloc/kvzalloc_objs, which first attempts a contiguous allocation with
> __GFP_NOWARN and then falls back to vmalloc for large sizes. Convert the
> corresponding kfree calls to kvfree.
> 
> Both arrays are pure metadata lookup tables (arrays of pointers and zone
> descriptors) accessed only via indexing, so they do not require physically
> contiguous memory.
> 
> Reported-by: syzbot+924649752adf0d3ac9dd@syzkaller.appspotmail.com
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>   drivers/md/raid0.c | 18 +++++++++---------
>   1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index ef0045db409f..5e38a51e349a 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -143,13 +143,13 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
>   	}
>   
>   	err = -ENOMEM;
> -	conf->strip_zone = kzalloc_objs(struct strip_zone, conf->nr_strip_zones);
> +	conf->strip_zone = kvzalloc_objs(struct strip_zone, conf->nr_strip_zones);
>   	if (!conf->strip_zone)
>   		goto abort;
> -	conf->devlist = kzalloc(array3_size(sizeof(struct md_rdev *),
> -					    conf->nr_strip_zones,
> -					    mddev->raid_disks),
> -				GFP_KERNEL);
> +	conf->devlist = kvzalloc(array3_size(sizeof(struct md_rdev *),
> +					     conf->nr_strip_zones,
> +					     mddev->raid_disks),
> +				 GFP_KERNEL);
>   	if (!conf->devlist)
>   		goto abort;
>   
> @@ -291,8 +291,8 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
>   
>   	return 0;
>   abort:
> -	kfree(conf->strip_zone);
> -	kfree(conf->devlist);
> +	kvfree(conf->strip_zone);
> +	kvfree(conf->devlist);
>   	kfree(conf);
>   	*private_conf = ERR_PTR(err);
>   	return err;
> @@ -373,8 +373,8 @@ static void raid0_free(struct mddev *mddev, void *priv)
>   {
>   	struct r0conf *conf = priv;
>   
> -	kfree(conf->strip_zone);
> -	kfree(conf->devlist);
> +	kvfree(conf->strip_zone);
> +	kvfree(conf->devlist);
>   	kfree(conf);
>   }
>   


LGTM

Reviewed-by: Li Nan <linan122@huawei.com>

-- 
Thanks,
Nan

