Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084752C187;
	Wed,  3 Sep 2025 03:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756869811; cv=none; b=ZeEamtX8wIkJ1yPebzvjnTvjHxBAeT5mJpu+seVzpS2vjbNTdhZk7fV54O8XZocYBiTpD9BoBcv+KyPCF+xhM1jFjV4T6FPb7cuVHjQTD3Z8hGe3cWhHfg1CZSHN7nTLqyw4s+fwY/SMJu/MyDCuUdslAlGL62fuQr5EqSfpkaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756869811; c=relaxed/simple;
	bh=jtBor+0N+XLsoAEgxlwnVEOgxrlLnu7Ksl5pxr2bZ54=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R6lqfdIJNTubUcepkOqlhUF6Gsutig9ORPFsG9Lnq1PTMkOG8n+yNaVjOtjDlP9W19ZRLzWerZ+oDFbHqXx50WG0srJY2iKsN8/2+fLu6cixdISAm8qbo2W1kyJdOFi8iRc7rwuyY7VkjidNMXtOYiRbAU4GZzyNIqL+iPBVhQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cGnxj5mltzYQvBX;
	Wed,  3 Sep 2025 11:23:21 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 500E31A1932;
	Wed,  3 Sep 2025 11:23:20 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP4 (Coremail) with SMTP id gCh0CgDXIY6ltLdoMErZBA--.46215S3;
	Wed, 03 Sep 2025 11:23:18 +0800 (CST)
Message-ID: <f95856f8-117a-9b4a-f417-d65f951931c5@huaweicloud.com>
Date: Wed, 3 Sep 2025 11:23:17 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] md/raid1: fix data lost for writemostly rdev
To: Yu Kuai <yukuai1@huaweicloud.com>, song@kernel.org,
 ian@beware.dropbear.id.au
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com
References: <20250903014140.3690499-1-yukuai1@huaweicloud.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20250903014140.3690499-1-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDXIY6ltLdoMErZBA--.46215S3
X-Coremail-Antispam: 1UD129KBjvJXoW7KF48Kr4DJF47Xr18ZFy8AFb_yoW8GrWkpa
	1kW34Y93yrCry7Ca4DZa9ruFyrZ3WjqryfurWaqryj9ry2vFy5W3yjgFZ5KrykZFWrCFyU
	Xrn0y347Xay5Xa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9K14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIF
	xwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI4
	8JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xv
	wVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjx
	v20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20E
	Y4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267
	AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUOmhFUUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/9/3 9:41, Yu Kuai 写道:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> If writemostly is enabled, alloc_behind_master_bio() will allocate a new
> bio for rdev, with bi_opf set to 0. Later, raid1_write_request() will
> clone from this bio, hence bi_opf is still 0 for the cloned bio. Submit
> this cloned bio will end up to be read, causing write data lost.
> 
> Fix this problem by inheriting bi_opf from original bio for
> behind_mast_bio.
> 
> Fixes: e879a0d9cb08 ("md/raid1,raid10: don't ignore IO flags")
> Reported-and-tested-by: Ian Dall <ian@beware.dropbear.id.au>
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220507
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   drivers/md/raid1.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index f8434049f9b1..f391fd56d67f 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1225,7 +1225,7 @@ static void alloc_behind_master_bio(struct r1bio *r1_bio,
>   	int i = 0;
>   	struct bio *behind_bio = NULL;
>   
> -	behind_bio = bio_alloc_bioset(NULL, vcnt, 0, GFP_NOIO,
> +	behind_bio = bio_alloc_bioset(NULL, vcnt, bio->bi_opf, GFP_NOIO,
>   				      &r1_bio->mddev->bio_set);
>   
>   	/* discard op, we don't support writezero/writesame yet */

LGTM

Reviewed-by: Li Nan <linan122@huawei.com>
-- 
Thanks,
Nan

