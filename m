Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695C72101AF;
	Mon,  7 Apr 2025 01:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743988891; cv=none; b=KCfzjs5w038FwrVk+mQ09LvLIwhj3Sg7rJsv+H9PWaDe/dqdZz79Wpc8aDJ7OtTlan4aE63BTP0AmkOpmnFmoYSZiCTClZUS5MZN8qlYUyxrqR2hZLmdNLDVoqrD9kLXI8dXbs/C+3pKhCb1LSxmrS7PhucUamBz5s6GKXCjc8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743988891; c=relaxed/simple;
	bh=6L77+RRua/4acu1pIvF8GpxjPnFtzZwigbVkXSwVkU8=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Vu4SGTX4FQOJ7mK8t51ADFt5pvjf8pPz1ajp6w2t6eorSeEOAKrJYQjoqLP+YxAjLKd8+xDEGWo6DLOE/eYB9IGK+ugJkQeAYwEGzM0qYSu/tTXHMleWLWboL/75b40hRgd/A8NjiaCW9rEmpchgz9te2g4qpEoY/ed2UPLZuM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZWBHQ6KSjz4f3jt7;
	Mon,  7 Apr 2025 09:21:06 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id CB4EC1A0D62;
	Mon,  7 Apr 2025 09:21:24 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgB321+UKPNnv2fyIg--.50539S3;
	Mon, 07 Apr 2025 09:21:24 +0800 (CST)
Subject: Re: [PATCH V2] md/md-bitmap: fix stats collection for external
 bitmaps
To: Zheng Qixing <zhengqixing@huaweicloud.com>, song@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, zhengqixing@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250403015322.2873369-1-zhengqixing@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <50e45490-2d68-f882-97d8-a4548730caab@huaweicloud.com>
Date: Mon, 7 Apr 2025 09:21:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250403015322.2873369-1-zhengqixing@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB321+UKPNnv2fyIg--.50539S3
X-Coremail-Antispam: 1UD129KBjvJXoW7AFyxArWrurW8Kr13ur1Utrb_yoW8Xr4kpF
	ZxG3W5urWrJr10gF1UZFy8ZFyrJ3ZxtrZrKr1rG3s5uFZFyF9xKry8Gas0g3ZIvryrZF4q
	qrW5ta45Ca4j9F7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AF
	wI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUFB
	T5DUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2025/04/03 9:53, Zheng Qixing Ð´µÀ:
> From: Zheng Qixing <zhengqixing@huawei.com>
> 
> The bitmap_get_stats() function incorrectly returns -ENOENT for external
> bitmaps.
> 
> Remove the external bitmap check as the statistics should be available
> regardless of bitmap storage location.
> 
> Return -EINVAL only for invalid bitmap with no storage (neither in
> superblock nor in external file).
> 
> Note: "bitmap_info.external" here refers to a bitmap stored in a separate
> file (bitmap_file), not to external metadata.
> 
> Fixes: 8d28d0ddb986 ("md/md-bitmap: Synchronize bitmap_get_stats() with bitmap lifetime")
> Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
> ---
>   drivers/md/md-bitmap.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
> 
Applied to md-6.15
Thanks

> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 44ec9b17cfd3..37b08f26c62f 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -2357,9 +2357,8 @@ static int bitmap_get_stats(void *data, struct md_bitmap_stats *stats)
>   
>   	if (!bitmap)
>   		return -ENOENT;
> -	if (bitmap->mddev->bitmap_info.external)
> -		return -ENOENT;
> -	if (!bitmap->storage.sb_page) /* no superblock */
> +	if (!bitmap->mddev->bitmap_info.external &&
> +	    !bitmap->storage.sb_page)
>   		return -EINVAL;
>   	sb = kmap_local_page(bitmap->storage.sb_page);
>   	stats->sync_size = le64_to_cpu(sb->sync_size);
> 

