Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729153C38;
	Mon, 29 Jul 2024 01:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722216656; cv=none; b=Mc34os4jDKuCebgXJJxSsFehfzcz35FbzuqUQLpg0ofXXwA/HNPxjpVY4LJWah0ajhj0e3d3MnkBZHNLtEv4JeaKJw7/vrtXLpoejq4HhFdajQEYQ9FzxeQM9Lcx0GDysm2MAxzIs/n+6SVXHOTEW3rUU6DFnBciTRM7+rQ8lM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722216656; c=relaxed/simple;
	bh=upCWLiNXAtGGPHNk6wpjfBFQeE1LIzrtuCNdQSCEB1w=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ilqv78wfIiKWkG/mNEdgj285t4+hrSC+pR1HNY6U5EfwSY7zHnQfNjTAeA/2V1VQvIKieZhl7FKetTvyklopGU+KUAVPEgSGrGxZmJvSXOLrraAf82iO80k9hmM+QwVGwFEQ4hQInaJoHPRYM0wNDCcFolNYK9OldUR2DZm+XU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4WXLQZ3sBBz4f3jcx;
	Mon, 29 Jul 2024 09:30:30 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 4D0191A018D;
	Mon, 29 Jul 2024 09:30:43 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgB3n4W_8KZmg5uYAA--.20791S3;
	Mon, 29 Jul 2024 09:30:41 +0800 (CST)
Subject: Re: [PATCH] [DEBUG] md/raid1: check recovery_offset in
 raid1_check_read_range
To: =?UTF-8?Q?Mateusz_Jo=c5=84czyk?= <mat.jonczyk@o2.pl>,
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Song Liu <song@kernel.org>, stable@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <9952f532-2554-44bf-b906-4880b2e88e3a@o2.pl>
 <20240728103634.208234-1-mat.jonczyk@o2.pl>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <cb2c26e4-1c1f-8a0a-040e-0c25d0c37e6c@huaweicloud.com>
Date: Mon, 29 Jul 2024 09:30:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240728103634.208234-1-mat.jonczyk@o2.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3n4W_8KZmg5uYAA--.20791S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ZF13Zw13uw1fWr4DAw47urg_yoW8Aw13pa
	yYqa43ur1DGrW8A3WDCa4UAa4rta9rGrW8WryYga4xZF9xZry5G3yfWryYgrWDGrn093y2
	qF4UW3yUua4qyaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AF
	wI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1D
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UK2N
	tUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/07/28 18:36, Mateusz Jończyk 写道:
> This should fix the filesystem corruption during RAID resync.
> 
> Checking this condition in raid1_check_read_range is not ideal, but this
> is only a debug patch.
> 
> Link: https://lore.kernel.org/lkml/20240724141906.10b4fc4e@peluse-desk5/T/#m671d6d3a7eda44d39d0882864a98824f52c52917
> Signed-off-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
> Cc: Yu Kuai <yukuai3@huawei.com>
> Cc: Song Liu <song@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>   drivers/md/raid1-10.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
> index 2ea1710a3b70..4ab896e8cb12 100644
> --- a/drivers/md/raid1-10.c
> +++ b/drivers/md/raid1-10.c
> @@ -252,6 +252,10 @@ static inline int raid1_check_read_range(struct md_rdev *rdev,
>   	sector_t first_bad;
>   	int bad_sectors;
>   
> +	if (!test_bit(In_sync, &rdev->flags) &&
> +	    rdev->recovery_offset < this_sector + *len)
> +		return 0;
> +

It's right this check is necessary, which means should not read from
rdev that the array is still in recovery and the read range is not
recoveried yet.

However, choose_first_rdev() is called during array resync, hence
the array will not be in recovery, and this is just dead code and not
needed.

And choose_bb_rdev() will only be called when the read range has bb,
which means the read range msut be accessed before and IO error must
occur first, and which indicates this rdev can't still be in recovery
for the read range.

So I think this check is only needed for slow disks.

BTW, looks like we don't have much tests for the case slow disks in
raid1.

Thanks,
Kuai

>   	/* no bad block overlap */
>   	if (!is_badblock(rdev, this_sector, *len, &first_bad, &bad_sectors))
>   		return *len;
> 

