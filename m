Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428643A1E9F
	for <linux-raid@vger.kernel.org>; Tue,  6 Jan 2026 06:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767681750; cv=none; b=et8o47OGE9ZzfAgJT1pm8lgKMOkcNSsBVxqVn7MnTz10hz0DpIDbJ4fwmz5WN+9VJus+7LrL3N/7WE3CKPJQGLbZj8iGUojAnZAeCzgBUccNV2W57uWZrmKD45cZa6Ld+D0GkgoKDjIXVyLEXnz3tw7T4rqNs0IMr5L1ga3gxr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767681750; c=relaxed/simple;
	bh=7/ohazjprdwjU9nUwZNFXeLVpYWyswn8YvABIVzAnk0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oyMR4mvXNgK+niIPokDIZ04oJKEKJgsWK6545G5S4PY2xYHNP1KQmgFu+NIFPzCU6qSuRZz1KfwMIpbBl6otJefTqi//cfTvSuCS75lUZ1iFxyrMPznkczoDD3D3qUii3YoVzuftIPnnWlZTpBymgxWYEBjbURGrw7/fzEsXCg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dlhQq623fzKHMZx
	for <linux-raid@vger.kernel.org>; Tue,  6 Jan 2026 14:41:39 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 387A14056C
	for <linux-raid@vger.kernel.org>; Tue,  6 Jan 2026 14:42:19 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgAXxfXJrlxpz408Cw--.55740S3;
	Tue, 06 Jan 2026 14:42:19 +0800 (CST)
Message-ID: <8dee77f8-1616-a9f5-c129-3cd375604cb6@huaweicloud.com>
Date: Tue, 6 Jan 2026 14:42:17 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 06/11] md: support to align bio to limits
To: Yu Kuai <yukuai@fnnas.com>, linux-raid@vger.kernel.org
Cc: colyli@fnnas.com
References: <20260103154543.832844-1-yukuai@fnnas.com>
 <20260103154543.832844-7-yukuai@fnnas.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20260103154543.832844-7-yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXxfXJrlxpz408Cw--.55740S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJFy7ur15AF4UKr45ArWxXrb_yoW5ZryxpF
	WxGF9xZrWUJF17Ww13tayj9Fn5X3WfKr1jkrW7C3s5AFnxJFyDGF45W395t3sxGr1rWr1D
	C3ZYvFsxCwsxtrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487
	Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aV
	AFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xF
	o4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1Y6r17
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUzW
	lkUUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2026/1/3 23:45, Yu Kuai 写道:
> For personalities that report optimal IO size, it's indicate that users
> can get the best IO bandwidth if they issue IO with this size. However
> there is also an implicit condition that IO should also be aligned to the
> optimal IO size.
> 
> Currently, bio will only be split by limits, if bio offset is not aligned
> to limits, then all split bio will not be aligned. This patch add a new
> feature to align bio to limits first, and following patches will support
> this for each personality if necessary.
> 
> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
> ---
>   drivers/md/md.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>   drivers/md/md.h |  2 ++
>   2 files changed, 48 insertions(+)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 21b0bc3088d2..7292aedef01b 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -428,6 +428,48 @@ bool md_handle_request(struct mddev *mddev, struct bio *bio)
>   }
>   EXPORT_SYMBOL(md_handle_request);
>   
> +static struct bio *__md_bio_align_to_limits(struct mddev *mddev,
> +                                           struct bio *bio)
> +{
> +	unsigned int max_sectors = mddev->gendisk->queue->limits.max_sectors;
> +	sector_t start = bio->bi_iter.bi_sector;
> +	sector_t align_start = roundup(start, max_sectors);
> +	sector_t end;
> +	sector_t align_end;
> +
> +	/* already aligned */
> +	if (align_start == start)
> +		return bio;
> +
> +	end = start + bio_sectors(bio);
> +	align_end = rounddown(end, max_sectors);
> +
> +	/* bio is too small to split */
> +	if (align_end <= align_start)
> +		return bio;
> +
> +	return bio_submit_split_bioset(bio, align_start - start,
> +				       &mddev->gendisk->bio_split);
> +}
> +
> +static struct bio *md_bio_align_to_limits(struct mddev *mddev, struct bio *bio)
> +{
> +	if (!test_bit(MD_BIO_ALIGN, &mddev->flags))
> +		return bio;
> +
> +	/* atomic write can't split */
> +	if (bio->bi_opf & REQ_ATOMIC)
> +		return bio;
> +
> +	switch (bio_op(bio)) {
> +	case REQ_OP_READ:
> +	case REQ_OP_WRITE:
> +		return __md_bio_align_to_limits(mddev, bio);
> +	default:
> +		return bio;
> +	}
> +}
> +
>   static void md_submit_bio(struct bio *bio)
>   {
>   	const int rw = bio_data_dir(bio);
> @@ -443,6 +485,10 @@ static void md_submit_bio(struct bio *bio)
>   		return;
>   	}
>   
> +	bio = md_bio_align_to_limits(mddev, bio);
> +	if (!bio)
> +		return;
> +
>   	bio = bio_split_to_limits(bio);
>   	if (!bio)
>   		return;
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index b8c5dec12b62..e7aba83b708b 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -347,6 +347,7 @@ struct md_cluster_operations;
>    * @MD_HAS_SUPERBLOCK: There is persistence sb in member disks.
>    * @MD_FAILLAST_DEV: Allow last rdev to be removed.
>    * @MD_SERIALIZE_POLICY: Enforce write IO is not reordered, just used by raid1.
> + * @MD_BIO_ALIGN: Bio issued to the array will align to io_opt before split.
>    *
>    * change UNSUPPORTED_MDDEV_FLAGS for each array type if new flag is added
>    */
> @@ -366,6 +367,7 @@ enum mddev_flags {
>   	MD_HAS_SUPERBLOCK,
>   	MD_FAILLAST_DEV,
>   	MD_SERIALIZE_POLICY,
> +	MD_BIO_ALIGN,
>   };
>   
>   enum mddev_sb_flags {

LGTM

Reviewed-by: Li Nan <linan122@huawei.com>

-- 
Thanks,
Nan

