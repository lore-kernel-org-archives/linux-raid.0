Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8453B1CFBA;
	Mon, 13 Apr 2026 07:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776064748; cv=none; b=I96ugEm85oIJqQ8ySFelno9wI7/cRAMPHyxVm1fCw7F7WvxAYjlqeacehqx3EasAgQnxgGQ/1mVcqtTHMnUJlbDTcV7dIM8d3kuYJ/+WfVgamrFgUZf/+/tdR2wRVvmsq+PPp/m/EqsltYByqrT6TqEW9RsmJxFx+cxfWeRnMwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776064748; c=relaxed/simple;
	bh=PCxwkwQ/nEPnAV+H3AW6ufNrqFBBTHYyIsYx5DlkJt8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F4wYzf3r2FlrYGr67YzgZU2lsyhu8G0yY/Dne0nUb5WwJ6DocX3GWXOD8malJjFFOPxOdNZ12pQPSxCx1thavxAj1ShSUbePJqIzm6tE2D71Uca1j8CrjSQWUFuINs2g435qRwlbG7gGfhpDTCnQ9tcLlJo1xaZxzl8Y8G33bR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fvJfN5pMpzYQthh;
	Mon, 13 Apr 2026 15:18:20 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 10AF140573;
	Mon, 13 Apr 2026 15:19:03 +0800 (CST)
Received: from [10.174.178.255] (unknown [10.174.178.255])
	by APP3 (Coremail) with SMTP id _Ch0CgBnFL7mmNxp8BnxAA--.57565S3;
	Mon, 13 Apr 2026 15:19:02 +0800 (CST)
Message-ID: <f032ef85-8cd3-1615-3c42-e434011b0056@huaweicloud.com>
Date: Mon, 13 Apr 2026 15:19:02 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] md/raid5: fix race between reshape and chunk-aligned read
To: FengWei Shih <dannyshih@synology.com>, song@kernel.org, yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yangerkun@huawei.com" <yangerkun@huawei.com>
References: <20260409051722.2865321-1-dannyshih@synology.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20260409051722.2865321-1-dannyshih@synology.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgBnFL7mmNxp8BnxAA--.57565S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tF4xKw15tr47Aw43AF4DXFb_yoW8tw48p3
	yqkF93XrW5Zr9IkFsrJ34kuFyF9FWkJryfJw48Ww18uwnrXrn2k345GFn0qryUCr45uw40
	q3WUAFWDCFyj9a7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU90b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487
	Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aV
	AFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xF
	o4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIda
	VFxhVjvjDU0xZFpf9x07UG38nUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2026/4/9 13:17, FengWei Shih 写道:
> raid5_make_request() checks mddev->reshape_position to decide whether
> to allow chunk-aligned reads. However in raid5_start_reshape(), the
> layout configuration (raid_disks, algorithm, etc.) is updated before
> mddev->reshape_position is set:
> 
>    reshape (raid5_start_reshape)        read (raid5_make_request)
>    ==============================       ===========================
>    write_seqcount_begin
>    update raid_disks, algorithm...
>    set conf->reshape_progress
>    write_seqcount_end
>                                          check mddev->reshape_position
>                                            * still MaxSector, allow
>                                          raid5_read_one_chunk()
>                                            * use new layout
>    raid5_quiesce()
>    set mddev->reshape_position
> 
> Since reshape_position is not yet updated, raid5_make_request()
> considers no reshape is in progress and proceeds with the
> chunk-aligned path, but the layout has already changed, causing
> raid5_compute_sector() to return an incorrect physical address.
> 
> Fix this by reading conf->reshape_progress under gen_lock in
> raid5_read_one_chunk() and falling back to the stripe path if a
> reshape is in progress.
> 
> Signed-off-by: FengWei Shih <dannyshih@synology.com>
> ---
>   drivers/md/raid5.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index a8e8d431071b..bded2b86f0ef 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5421,6 +5421,11 @@ static int raid5_read_one_chunk(struct mddev *mddev, struct bio *raid_bio)
>   	sector_t sector, end_sector;
>   	int dd_idx;
>   	bool did_inc;
> +	int seq;
> +
> +	seq = read_seqcount_begin(&conf->gen_lock);
> +	if (unlikely(conf->reshape_progress != MaxSector))
> +		return 0;
>   
>   	if (!in_chunk_boundary(mddev, raid_bio)) {
>   		pr_debug("%s: non aligned\n", __func__);
> @@ -5431,6 +5436,9 @@ static int raid5_read_one_chunk(struct mddev *mddev, struct bio *raid_bio)
>   				      &dd_idx, NULL);
>   	end_sector = sector + bio_sectors(raid_bio);
>   
> +	if (read_seqcount_retry(&conf->gen_lock, seq))
> +		return 0;
> +
>   	if (r5c_big_stripe_cached(conf, sector))
>   		return 0;
>   

It seems that there might be race issues wherever raid5_compute_sector is
used? This fix only addresses one of the problems.

-- 
Thanks,
Nan

