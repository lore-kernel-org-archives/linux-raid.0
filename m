Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05574403
	for <linux-raid@vger.kernel.org>; Thu,  1 Feb 2024 01:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706751352; cv=none; b=bsVNSsYuCeRQttRBzaTzLnohI6rezXFKoK1EkzBJE0IMctEIxgxUIPqbSNmyvP7+GSuW31gCqduiicJROwEY3B64zDRArcL6QPX01wTiJANJfJgsXh1wNwiWLM3W2N35S+YM/KnkHcHgL5DyLCbS3rljF2gsbtZqBSXvDny4FUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706751352; c=relaxed/simple;
	bh=W+Rj/HcECjInLL0DLRzl2SiRp9Oa5qB5xJ+QS/BvSOE=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=XUmmHaMsBs6xeywtCVY3dprjH34dvK9hJHIbTzyO0TV6g6DwyhgPYgq093DZHUd2sa7/edYFSkmb4DR3vh06eVAv7IgfL/UJYhGnLFGBVdWmVcREc2P/oyruZHBGs6nW7cnVOxHHwCVFWIYHacvQmX+KfDPj6rK1wLi437jLkyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4TQM1569c3z4f3jqZ
	for <linux-raid@vger.kernel.org>; Thu,  1 Feb 2024 09:35:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 717451A0199
	for <linux-raid@vger.kernel.org>; Thu,  1 Feb 2024 09:35:40 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgAX6RFq9bplHphoCg--.11404S3;
	Thu, 01 Feb 2024 09:35:40 +0800 (CST)
Subject: Re: [bug report] md: also clone new io if io accounting is disabled
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <2cf10b2e-3703-414b-99b6-457dd4b14177@moroto.mountain>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <0efa13dc-f877-30b9-1f3f-e7ec500ad7f5@huaweicloud.com>
Date: Thu, 1 Feb 2024 09:35:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <2cf10b2e-3703-414b-99b6-457dd4b14177@moroto.mountain>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAX6RFq9bplHphoCg--.11404S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar4Dur45tFy8WF4fAF1fZwb_yoW8GFy7pF
	W0vry5GrW5XrW5C3y7Aw1UC3W3WanrGry5tFy0qry8ZFy5WryvkF4kWaykZrn5CFW7CF42
	qF10yF13Gr18AaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1Y6r17MIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
	c7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1CPfJUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/01/31 19:17, Dan Carpenter Ð´µÀ:
> Hello Yu Kuai,
> 
> The patch c687297b8845: "md: also clone new io if io accounting is
> disabled" from Jun 22, 2023 (linux-next), leads to the following
> Smatch static checker warning:
> 
> 	drivers/md/md.c:8718 md_clone_bio()
> 	potential NULL container_of 'clone'
> 
> drivers/md/md.c
>      8711 static void md_clone_bio(struct mddev *mddev, struct bio **bio)
>      8712 {
>      8713         struct block_device *bdev = (*bio)->bi_bdev;
>      8714         struct md_io_clone *md_io_clone;
>      8715         struct bio *clone =
>      8716                 bio_alloc_clone(bdev, *bio, GFP_NOIO, &mddev->io_clone_set);

If you ever look at the comment, you'll know that this will never fail.

  * If %__GFP_DIRECT_RECLAIM is set then bio_alloc will always be able to
  * allocate a bio.  This is due to the mempool guarantees.

Thanks,
Kuai

> 
> Generally in the kernel, you have to check for allocation failure.  In
> this case if the allocation fails it leads to a NULL dereference.
> 
>      8717
> --> 8718         md_io_clone = container_of(clone, struct md_io_clone, bio_clone);
>      8719         md_io_clone->orig_bio = *bio;
>      8720         md_io_clone->mddev = mddev;
>      8721         if (blk_queue_io_stat(bdev->bd_disk->queue))
>      8722                 md_io_clone->start_time = bio_start_io_acct(*bio);
>      8723
>      8724         clone->bi_end_io = md_end_clone_io;
>      8725         clone->bi_private = md_io_clone;
>      8726         *bio = clone;
>      8727 }
> 
> regards,
> dan carpenter
> .
> 

