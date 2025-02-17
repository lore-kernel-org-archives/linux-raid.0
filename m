Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE33C372;
	Mon, 17 Feb 2025 06:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739773661; cv=none; b=uJQwXtS3kxZbq98rUZtm3aa9j6Q7/V0lQ612y8j0tqZuwWL5zCRTBGsEHy8h9pzvUa2SbmZJzGOXnCG6o1WM/Hx5ksl8fLuU1Fm7aZbzy6SOS5saY0bahn3/YNCPKMjSha5afyPNyFrfLyQQg2JzpmH2t7gzczEB8X6U/O/nFF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739773661; c=relaxed/simple;
	bh=2usFcAws6QzOKmnEwyW2U0O7ypWnF4oYHyikiazOvFQ=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=BD8om76GSVLmMljmO9oQmX1W6nzIJhgj9Zk7euMzuNjeEFkt+YH2dGCY8ZPc3/8gCuKop46XY0GAm6JZXCUKjD3vZyNGlt3CPMMEmyZ4kk6zSMtbmBlwRUq28h3qdDnEtgyM4VrlAH+OxIhpx7zKUywF30WsA4/FvzStXxTfZXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4YxCPC4fznz4f3jXg;
	Mon, 17 Feb 2025 14:27:11 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 2B9661A0AD8;
	Mon, 17 Feb 2025 14:27:33 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgCH61_T1rJnoBJVEA--.2650S3;
	Mon, 17 Feb 2025 14:27:32 +0800 (CST)
Subject: Re: [PATCH] md/raid1: fix memory leak in raid1_run() if no active
 rdev
To: Zheng Qixing <zhengqixing@huaweicloud.com>, song@kernel.org,
 axboe@kernel.dk, martin.petersen@oracle.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, zhengqixing@huawei.com,
 Christoph Hellwig <hch@lst.de>, "yukuai (C)" <yukuai3@huawei.com>
References: <20250215020137.3703757-1-zhengqixing@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <2559f238-4a76-4acc-02bf-38008671c9ce@huaweicloud.com>
Date: Mon, 17 Feb 2025 14:27:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250215020137.3703757-1-zhengqixing@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCH61_T1rJnoBJVEA--.2650S3
X-Coremail-Antispam: 1UD129KBjvJXoW7uF45ur1kAF17Zr1fWry7GFg_yoW8XFWrpa
	n7Jas8GrWxWryfGayDAFWDuayYva1DKrWvkFyxWw15ZFn3KFZ8Wa98ua4jgr9rArW8W345
	J390grWDGFyUKFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Ib4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IE
	e2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4I
	kC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWU
	WwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr
	0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWU
	JVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJb
	IYCTnIWIevJa73UjIFyTuYvjxUF1v3UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

+CC Christohp

ÔÚ 2025/02/15 10:01, Zheng Qixing Ð´µÀ:
> From: Zheng Qixing <zhengqixing@huawei.com>
> 
> When `raid1_set_limits()` fails or when the array has no active
> `rdev`, the allocated memory for `conf` is not properly freed.
> 
> Add raid1_free() call to properly free the conf in error path.
> 
> Fixes: 799af947ed13 ("md/raid1: don't free conf on raid0_run failure")
> Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
> ---
>   drivers/md/raid1.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 

LGTM
Applied to md-6.15

Thanks,
Kuai

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 9d57a88dbd26..a87eb9a3b016 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -45,6 +45,7 @@
>   
>   static void allow_barrier(struct r1conf *conf, sector_t sector_nr);
>   static void lower_barrier(struct r1conf *conf, sector_t sector_nr);
> +static void raid1_free(struct mddev *mddev, void *priv);
>   
>   #define RAID_1_10_NAME "raid1"
>   #include "raid1-10.c"
> @@ -3258,8 +3259,11 @@ static int raid1_run(struct mddev *mddev)
>   
>   	if (!mddev_is_dm(mddev)) {
>   		ret = raid1_set_limits(mddev);
> -		if (ret)
> +		if (ret) {
> +			if (!mddev->private)
> +				raid1_free(mddev, conf);
>   			return ret;
> +		}
>   	}
>   
>   	mddev->degraded = 0;
> @@ -3273,6 +3277,8 @@ static int raid1_run(struct mddev *mddev)
>   	 */
>   	if (conf->raid_disks - mddev->degraded < 1) {
>   		md_unregister_thread(mddev, &conf->thread);
> +		if (!mddev->private)
> +			raid1_free(mddev, conf);
>   		return -EINVAL;
>   	}
>   
> 

