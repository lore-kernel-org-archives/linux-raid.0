Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE61711185
	for <linux-raid@vger.kernel.org>; Wed,  5 Mar 2025 01:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741137949; cv=none; b=HcJTBRFuoNGXhF0wraxxEfOrK5Qi1yOb5Q5kfa1ipQpc04LEt/UAED9viFfPLAqPwe8/DbJCeUYowCR1ENncWnmRF1jLzHFmL2E9Drtq1G4mFp9CrLU4bbqATAB1ar5TmLLL4VoCoWC2l4GyWe5xbC5v48OrhSlwbLK/9qMaDb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741137949; c=relaxed/simple;
	bh=AiozLmGAftXkgjkkSDeAtXhYy/5ekeV3plZsc9BzYPo=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=N2eNopaewouuodayFLukWBakOBoCAja7korK14I88MA2QJggEvthf2NSvXH1pgKn7gEs8yF6qIHTbO/ssr0RfJrQwQ+IuLlHB9MCySLcE7aYLoCAOacPCTCcGBCkmqa2YHxdLQbdNVHRJvqal4hRWv6OdqogXasq43Z0+EJZEjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Z6vxV4hNHz4f3m6S
	for <linux-raid@vger.kernel.org>; Wed,  5 Mar 2025 09:25:18 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 38DF41A058E
	for <linux-raid@vger.kernel.org>; Wed,  5 Mar 2025 09:25:42 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgCnCl8UqMdnsq5KFg--.54991S3;
	Wed, 05 Mar 2025 09:25:42 +0800 (CST)
Subject: Re: [PATCH v3] md/md-bitmap: fix wrong bitmap_limit for clustermd
 when write sb
To: Su Yue <glass.su@suse.com>, linux-raid@vger.kernel.org
Cc: hch@lst.de, ofir.gal@volumez.com, heming.zhao@suse.com, l@damenly.org,
 "yukuai3 >> yukuai (C)" <yukuai3@huawei.com>
References: <20250303033918.32136-1-glass.su@suse.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <47caca95-7bd9-69d0-6a28-231e0b0f1831@huaweicloud.com>
Date: Wed, 5 Mar 2025 09:25:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250303033918.32136-1-glass.su@suse.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnCl8UqMdnsq5KFg--.54991S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ArWDWrW8JF18trWDKr13twb_yoW5Jry7pr
	Zxu3Z3Cr45J3409F1UJFykZF15CwnrJ3yxKrWfG3yrCF13Cr98KF18KF1rt34xGrWrZF4U
	AF4rGryUCF1v9aDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

ÔÚ 2025/03/03 11:39, Su Yue Ð´µÀ:
> In clustermd, separate write-intent-bitmaps are used for each cluster
> node:
> 
> 0                    4k                     8k                    12k
> -------------------------------------------------------------------
> | idle                | md super            | bm super [0] + bits |
> | bm bits[0, contd]   | bm super[1] + bits  | bm bits[1, contd]   |
> | bm super[2] + bits  | bm bits [2, contd]  | bm super[3] + bits  |
> | bm bits [3, contd]  |                     |                     |
> 
> So in node 1, pg_index in __write_sb_page() could equal to
> bitmap->storage.file_pages. Then bitmap_limit will be calculated to
> 0. md_super_write() will be called with 0 size.
> That means the first 4k sb area of node 1 will never be updated
> through filemap_write_page().
> This bug causes hang of mdadm/clustermd_tests/01r1_Grow_resize.
> 
> Here use (pg_index % bitmap->storage.file_pages) to make calculation
> of bitmap_limit correct.
> 
> Fixes: ab99a87542f1 ("md/md-bitmap: fix writing non bitmap pages")
> Signed-off-by: Su Yue <glass.su@suse.com>
> ---
> Changelog:
> v3:
>      Amend commit message suggested by Heming.
> v2:
>      Remove unintended change calling md_super_write().
> ---
>   drivers/md/md-bitmap.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 

Applied to md-6.15
Thanks,
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 23c09d22fcdb..9ae6cc8e30cb 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -426,8 +426,8 @@ static int __write_sb_page(struct md_rdev *rdev, struct bitmap *bitmap,
>   	struct block_device *bdev;
>   	struct mddev *mddev = bitmap->mddev;
>   	struct bitmap_storage *store = &bitmap->storage;
> -	unsigned int bitmap_limit = (bitmap->storage.file_pages - pg_index) <<
> -		PAGE_SHIFT;
> +	unsigned long num_pages = bitmap->storage.file_pages;
> +	unsigned int bitmap_limit = (num_pages - pg_index % num_pages) << PAGE_SHIFT;
>   	loff_t sboff, offset = mddev->bitmap_info.offset;
>   	sector_t ps = pg_index * PAGE_SIZE / SECTOR_SIZE;
>   	unsigned int size = PAGE_SIZE;
> @@ -436,7 +436,7 @@ static int __write_sb_page(struct md_rdev *rdev, struct bitmap *bitmap,
>   
>   	bdev = (rdev->meta_bdev) ? rdev->meta_bdev : rdev->bdev;
>   	/* we compare length (page numbers), not page offset. */
> -	if ((pg_index - store->sb_index) == store->file_pages - 1) {
> +	if ((pg_index - store->sb_index) == num_pages - 1) {
>   		unsigned int last_page_size = store->bytes & (PAGE_SIZE - 1);
>   
>   		if (last_page_size == 0)
> 

