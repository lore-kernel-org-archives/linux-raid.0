Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA9F746E;
	Thu,  3 Apr 2025 01:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743645211; cv=none; b=G5r38TyESrq/ij/fw925ryXRQxkoAhWaE4/lry+8iRV5KnQvEdNZ43IuSylhEB8aPfUsmx35+SD2lVmbcbzXGs91Ep/2Qz+sDh9bMGpuwT7yJEMI/wVX/p8Uiy6otIWdDwDIqv6+JcFQNvhTerGh1wx8CatsUt5Zimaio1VzcVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743645211; c=relaxed/simple;
	bh=03URNyBY2K6MhHGMe8DPNLNqV+qjQQH5T363c8CEDKQ=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=C6YgamCnWd0yGchkMDHIYYYHTihHd/ucVjm3DKGJxoXs4xAL9dgbbcO8wDmUd9YunBHnvJyqqNVCx7fQBUG7uKkiBu3N2Y9auGxQ9uXucUCIguIDXWgFuJVZ2M/LbEGQ14b3J3SpFjA+XfHUhWk+uimB+VOFTcbx6imDQAy8JI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZSlB40qgLz4f3jZd;
	Thu,  3 Apr 2025 09:53:00 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E3BC51A06DC;
	Thu,  3 Apr 2025 09:53:17 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgAni18M6u1nJtxmIQ--.59599S3;
	Thu, 03 Apr 2025 09:53:17 +0800 (CST)
Subject: Re: [PATCH] md/md-bitmap: fix stats collection for external bitmaps
To: Zheng Qixing <zhengqixing@huaweicloud.com>, song@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, zhengqixing@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250402011523.2271768-1-zhengqixing@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <15c25e4f-97d1-a517-fcce-8ae4c87ef2ef@huaweicloud.com>
Date: Thu, 3 Apr 2025 09:53:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250402011523.2271768-1-zhengqixing@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAni18M6u1nJtxmIQ--.59599S3
X-Coremail-Antispam: 1UD129KBjvJXoW7AFyxAry3CFW3Xw1kuFyDKFg_yoW8GrW8pF
	Z8G3W5uw4rJry0grn8Zry8AFyrJ3Zxtr9rKr1rG3s5CFZrAF9xKr48Ga4UZ3Wq9ry8ZF4j
	qrW5JFy2k3yjvFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AF
	wI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UK2N
	tUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/04/02 9:15, Zheng Qixing Ð´µÀ:
> From: Zheng Qixing <zhengqixing@huawei.com>
> 
> The bitmap_get_stats() function incorrectly returns -ENOENT for external
> bitmaps, preventing statistics collection when a valid superblock page
> exists.
> 
> Remove the external bitmap check as the statistics should be available
> regardless of bitmap storage location when sb_page is present.
> 
> Note: "bitmap_info.external" here refers to a bitmap stored in a separate
> file (bitmap_file), not to external metadata.
> 
> Fixes: 8d28d0ddb986 ("md/md-bitmap: Synchronize bitmap_get_stats() with bitmap lifetime")
> Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
> ---
>   drivers/md/md-bitmap.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 44ec9b17cfd3..afd01c93ddd9 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -2357,8 +2357,6 @@ static int bitmap_get_stats(void *data, struct md_bitmap_stats *stats)
>   
>   	if (!bitmap)
>   		return -ENOENT;
> -	if (bitmap->mddev->bitmap_info.external)
> -		return -ENOENT;
>   	if (!bitmap->storage.sb_page) /* no superblock */
>   		return -EINVAL;

bitmap_file doesn't have sb, so above condition still need to be fixed.

Thanks,
Kuai

>   	sb = kmap_local_page(bitmap->storage.sb_page);
> 

