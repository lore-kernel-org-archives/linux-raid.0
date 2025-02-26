Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53B420DD6B;
	Wed, 26 Feb 2025 08:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740558594; cv=none; b=Lr017MEBkjw1lMKjxkRiFLEU+Av2HLMEW/tRldRIyYYaUDz7dBpBUI3b1EGAoQ+Lostnou8rpBx6hpNDCPQxJg+jUpIaJqvclAyq86MoeSPTM2WjylporwYbmb4vOh5P6XaYxxwmAG4RUpAWZw+zYs7bQu/t5o3L8CNxKiBLrQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740558594; c=relaxed/simple;
	bh=0/AseWEK7iLht1u4pxAz1LzEQGLb0d2jc7rLNKvc9HI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nAKbKgaHio+y7bEXSkHG+9uwo7CGfHnzzdoWA2mfC2PGMU91pxSNGMUv7cwlFdxbUoTntvNjH3A1v0Qy0++GWr8RSZeoJBlLiVFpEQIaR2B/OHCSwdEO7rW6SRGpOqhwiLUFrBCag7YLmFG9Esbg1/jLdEEeo91+u7E9/Xk1Zyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.2] (ip5f5af4fc.dynamic.kabel-deutschland.de [95.90.244.252])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id C7C9861E647A7;
	Wed, 26 Feb 2025 09:29:11 +0100 (CET)
Message-ID: <5697c1c7-eb46-41e6-b0cb-31f120b416de@molgen.mpg.de>
Date: Wed, 26 Feb 2025 09:29:11 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/raid1,raid10: don't ignore IO flags
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, yukuai3@huawei.com, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com
References: <20250226063011.968761-1-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20250226063011.968761-1-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Kuai,


Thank you for your patch.

Am 26.02.25 um 07:30 schrieb Yu Kuai:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> If blk-wbt is enabled by default, it's found that raid write performance
> is quite bad because all IO are throttled by wbt of underlying disks,
> due to flag REQ_IDLE is ignored. And turns out this behaviour exist since
> blk-wbt is introduced.
> 
> Other than REQ_IDLE, other flags should not be ignored as well, for
> example REQ_META can be set for filesystems, clear it can cause priority

clear*ing*

> reverse problems; And REQ_NOWAIT should not be cleared as well, because

… problems. REQ…NOWAIT …

> io will wait instead of fail directly in underlying disks.

fail*ing*

> Fix those problems by keeping IO flags from master bio.

Add a Fixes: tag?

Do you have a test case, how to reproduce the issue?


Kind regards,

Paul


> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   drivers/md/raid1.c  | 5 -----
>   drivers/md/raid10.c | 8 --------
>   2 files changed, 13 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index a87eb9a3b016..347de0e36d59 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1316,8 +1316,6 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
>   	struct r1conf *conf = mddev->private;
>   	struct raid1_info *mirror;
>   	struct bio *read_bio;
> -	const enum req_op op = bio_op(bio);
> -	const blk_opf_t do_sync = bio->bi_opf & REQ_SYNC;
>   	int max_sectors;
>   	int rdisk, error;
>   	bool r1bio_existed = !!r1_bio;
> @@ -1405,7 +1403,6 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
>   	read_bio->bi_iter.bi_sector = r1_bio->sector +
>   		mirror->rdev->data_offset;
>   	read_bio->bi_end_io = raid1_end_read_request;
> -	read_bio->bi_opf = op | do_sync;
>   	if (test_bit(FailFast, &mirror->rdev->flags) &&
>   	    test_bit(R1BIO_FailFast, &r1_bio->state))
>   	        read_bio->bi_opf |= MD_FAILFAST;
> @@ -1654,8 +1651,6 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>   
>   		mbio->bi_iter.bi_sector	= (r1_bio->sector + rdev->data_offset);
>   		mbio->bi_end_io	= raid1_end_write_request;
> -		mbio->bi_opf = bio_op(bio) |
> -			(bio->bi_opf & (REQ_SYNC | REQ_FUA | REQ_ATOMIC));
>   		if (test_bit(FailFast, &rdev->flags) &&
>   		    !test_bit(WriteMostly, &rdev->flags) &&
>   		    conf->raid_disks - mddev->degraded > 1)
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index efe93b979167..e294ba00ea0e 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1146,8 +1146,6 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
>   {
>   	struct r10conf *conf = mddev->private;
>   	struct bio *read_bio;
> -	const enum req_op op = bio_op(bio);
> -	const blk_opf_t do_sync = bio->bi_opf & REQ_SYNC;
>   	int max_sectors;
>   	struct md_rdev *rdev;
>   	char b[BDEVNAME_SIZE];
> @@ -1228,7 +1226,6 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
>   	read_bio->bi_iter.bi_sector = r10_bio->devs[slot].addr +
>   		choose_data_offset(r10_bio, rdev);
>   	read_bio->bi_end_io = raid10_end_read_request;
> -	read_bio->bi_opf = op | do_sync;
>   	if (test_bit(FailFast, &rdev->flags) &&
>   	    test_bit(R10BIO_FailFast, &r10_bio->state))
>   	        read_bio->bi_opf |= MD_FAILFAST;
> @@ -1247,10 +1244,6 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
>   				  struct bio *bio, bool replacement,
>   				  int n_copy)
>   {
> -	const enum req_op op = bio_op(bio);
> -	const blk_opf_t do_sync = bio->bi_opf & REQ_SYNC;
> -	const blk_opf_t do_fua = bio->bi_opf & REQ_FUA;
> -	const blk_opf_t do_atomic = bio->bi_opf & REQ_ATOMIC;
>   	unsigned long flags;
>   	struct r10conf *conf = mddev->private;
>   	struct md_rdev *rdev;
> @@ -1269,7 +1262,6 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
>   	mbio->bi_iter.bi_sector	= (r10_bio->devs[n_copy].addr +
>   				   choose_data_offset(r10_bio, rdev));
>   	mbio->bi_end_io	= raid10_end_write_request;
> -	mbio->bi_opf = op | do_sync | do_fua | do_atomic;
>   	if (!replacement && test_bit(FailFast,
>   				     &conf->mirrors[devnum].rdev->flags)
>   			 && enough(conf, devnum))

