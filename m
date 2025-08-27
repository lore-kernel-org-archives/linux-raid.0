Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6EB8343213;
	Wed, 27 Aug 2025 09:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756286951; cv=none; b=lfAUyXn9TCO3BvigJK848N84ndmOHKjA4iTOd8Wo0LwCEU880yczQefedUrREj4HjtC69Nb1BHobKaYTc8dJQ8SM8d7zApBohaYR20RmsVXED1HVkeXvcbQsKvRCwPUelkXUrVnTKBi82ptiTjH0tlsPwH4f0j7rJOgUh+IWH7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756286951; c=relaxed/simple;
	bh=846sVfsuK0Ju7cH3HlNLsCCgiTChNfLu+6T6Fn92+Qw=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=J/J/ykDQrWpy53gBDxQav4n9o3waMRZBkQImm3GuERwci0i64kHGIhVOoirG4tgoQv441MoOFGW68hhJG1uM8WywwUDhuxfof2gdAovaefxDc6+mwr7kOXNIuxpS6JIXSR9NHQRjnxO/56tGc8abxYGOB6T0H2GUYrYxs1NmlsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cBfNy20slzYQtx6;
	Wed, 27 Aug 2025 17:29:06 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C67BC1A09F5;
	Wed, 27 Aug 2025 17:29:04 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgAncY3ez65oPunVAQ--.55068S3;
	Wed, 27 Aug 2025 17:29:04 +0800 (CST)
Subject: Re: [PATCH v3 1/2] md: prevent adding disks with larger
 logical_block_size to active arrays
To: linan666@huaweicloud.com, song@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 martin.petersen@oracle.com, bvanassche@acm.org, hch@infradead.org,
 filipe.c.maia@gmail.com, yangerkun@huawei.com, yi.zhang@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250825075924.2696723-1-linan666@huaweicloud.com>
 <20250825075924.2696723-2-linan666@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <e1834dd0-ea69-09cf-82b7-0587ba3f3c3a@huaweicloud.com>
Date: Wed, 27 Aug 2025 17:29:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250825075924.2696723-2-linan666@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAncY3ez65oPunVAQ--.55068S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJF1UArWDGr13ur4fuw4Uurg_yoW8GFy8pa
	97Z3Z0k348AF12k347JFyrAFy5Wws7GrZ7Kry2yr1UXFZxJr17KF4akFZ8Wr1ktan3Ar13
	XF4UKws7C3WIqrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/08/25 15:59, linan666@huaweicloud.com Ð´µÀ:
> From: Li Nan <linan122@huawei.com>
> 
> When adding a disk to a md array, avoid updating the array's
> logical_block_size to match the new disk. This prevents accidental
> partition table loss that renders the array unusable.
> 
> The later patch will introduce a way to configure the array's
> logical_block_size.
> 
> Signed-off-by: Li Nan <linan122@huawei.com>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>   drivers/md/md.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 

Can you add a fix tag, as data loss is really serious.

Otherwise, feel free to add:

Reviewed-by: Yu Kuai <yukuai3@huawei.com>

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index cea8fc96abd3..206434591b97 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6064,6 +6064,13 @@ int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev)
>   	if (mddev_is_dm(mddev))
>   		return 0;
>   
> +	if (queue_logical_block_size(rdev->bdev->bd_disk->queue) >
> +	    queue_logical_block_size(mddev->gendisk->queue)) {
> +		pr_err("%s: incompatible logical_block_size, can not add\n",
> +		       mdname(mddev));
> +		return -EINVAL;
> +	}
> +
>   	lim = queue_limits_start_update(mddev->gendisk->queue);
>   	queue_limits_stack_bdev(&lim, rdev->bdev, rdev->data_offset,
>   				mddev->gendisk->disk_name);
> 

