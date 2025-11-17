Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2ED830F7F0;
	Mon, 17 Nov 2025 06:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763362660; cv=none; b=L4IYUH4DwLFnzsMjPpwYU3hq/vyORbjgsSnaSPDqBqTmN74f52Y0eLiar05s19THrFPS7mUAmeTnyiPnTk/oTOZ8kih8hGmzbVHBD05OnHHAwhz7Dyq7kWZf1UORF/NzL4suDU8fDPkHysYkuTgoREwxUw7QZ5ntICJk7KKEnlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763362660; c=relaxed/simple;
	bh=JaOUN5OwWBREJv2PUTbJssQu5LAZ2AwlLhG5qxA4DgE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N4sN7R9XvGDrFf0WtQdHwayoi11I46k9bzooEfJonpw5tJ82U8UNB2hmk2ae7i401HQ6r2Dw9+Okuv9+RvTMrIE3/OEvbZNs7lrMn33fFIiEcvh/eBan3+KTEHRxqsbxnmjP/H50MZ7b4oqDhtfQDBmkqViRAxoLjGe9RHnDfUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4d8z7Z6M2gzYQtpk;
	Mon, 17 Nov 2025 14:56:58 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 4C6A51A155B;
	Mon, 17 Nov 2025 14:57:35 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP2 (Coremail) with SMTP id Syh0CgD3VHtbxxppd60kBA--.24199S3;
	Mon, 17 Nov 2025 14:57:33 +0800 (CST)
Message-ID: <a21b5d3c-c71a-90dc-1712-9c283c6bf851@huaweicloud.com>
Date: Mon, 17 Nov 2025 14:57:31 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] md/raid0: fix NULL pointer dereference in
 create_strip_zones() for dm-raid
To: Yu Kuai <yukuai@fnnas.com>, song@kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: xni@redhat.com, czhong@redhat.com
References: <20251116021816.107648-1-yukuai@fnnas.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20251116021816.107648-1-yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgD3VHtbxxppd60kBA--.24199S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Zr4rXF4DGw1DKw48AFW5ZFb_yoW8CrWUpa
	n7K3ZxW348KrWfuasrXrWDu3WSg348GrWvkFZIy34rXryavr15WFW7WFZ8WrWxAas5Zr1a
	qw15WFs2qr98Kr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU90b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
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



在 2025/11/16 10:18, Yu Kuai 写道:
> Commit 2107457e31fa ("md/raid0: Move queue limit setup before r0conf
> initialization") dereference mddev->gendisk unconditionally, which is
> NULL for dm-raid.
> 
> Fix this problem by reverting to old codes for dm-raid.
> 
> Fixes: 2107457e31fa ("md/raid0: Move queue limit setup before r0conf initialization")
> Reported-and-tested-by: Changhui Zhong <czhong@redhat.com>
> Closes: https://lore.kernel.org/all/CAGVVp+VqVnvGeneUoTbYvBv2cw6GwQRrR3B-iQ-_9rVfyumoKA@mail.gmail.com/
> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
> ---
>   drivers/md/raid0.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 47aee1b1d4d1..985c377356eb 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -68,7 +68,10 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
>   	struct strip_zone *zone;
>   	int cnt;
>   	struct r0conf *conf = kzalloc(sizeof(*conf), GFP_KERNEL);
> -	unsigned int blksize = queue_logical_block_size(mddev->gendisk->queue);
> +	unsigned int blksize = 512;
> +
> +	if (!mddev_is_dm(mddev))
> +		blksize = queue_logical_block_size(mddev->gendisk->queue);
>   
>   	*private_conf = ERR_PTR(-ENOMEM);
>   	if (!conf)
> @@ -84,6 +87,10 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
>   		sector_div(sectors, mddev->chunk_sectors);
>   		rdev1->sectors = sectors * mddev->chunk_sectors;
>   
> +		if (mddev_is_dm(mddev))
> +			blksize = max(blksize, queue_logical_block_size(
> +				      rdev1->bdev->bd_disk->queue));
> +
>   		rdev_for_each(rdev2, mddev) {
>   			pr_debug("md/raid0:%s:   comparing %pg(%llu)"
>   				 " with %pg(%llu)\n",

LGTM

Reviewed-by: Li Nan <linan122@huawei.com>
-- 
Thanks,
Nan

