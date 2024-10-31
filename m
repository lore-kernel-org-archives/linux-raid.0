Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1390194C9E;
	Thu, 31 Oct 2024 11:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730373112; cv=none; b=Cs+8WDkHPz16weJsnLieh7KjVnw0laF6oRGJfE1CsSn5t0QUrkOSXBhePALYiZiOFoJThBTC8SZW9pm+ow7SjJTVwpP1LP5S0hwLHvnpJxMFYobEBNwR1BZcpTIg0orTqZf7qaMGY2zuYutjrPhsjhg89TnEvUhlrRzsM4OrHgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730373112; c=relaxed/simple;
	bh=5JvpDc2N4S/qlEJkYG/qMnle/efP0ULHY3LjRmuVLMw=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Yc0UBEY9t3pGHqswzvoGRZTgmkr7HSi0hFBvPRFq0yyS7dZZqKFAqX8kObbt8mwpvy/wfToF2MQTNHME4gaLOHr+IcwxzKuy2TDPhP2ZS5QIy+BFEo33VqCU13pvgfDJvw/R+iIMRoiXGGiIBwMREdgLa4oxHKAFPyatevfuOJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XfLsd4NbFz4f3jqL;
	Thu, 31 Oct 2024 19:11:33 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 4063A1A058E;
	Thu, 31 Oct 2024 19:11:46 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgDHo4fxZSNnlzLTAQ--.891S3;
	Thu, 31 Oct 2024 19:11:46 +0800 (CST)
Subject: Re: [PATCH v3 6/6] md/raid10: Handle bio_split() errors
To: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk, song@kernel.org,
 hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de,
 Johannes.Thumshirn@wdc.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20241031095918.99964-1-john.g.garry@oracle.com>
 <20241031095918.99964-7-john.g.garry@oracle.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <9ca4f8af-d826-ee33-dde8-f2984538971d@huaweicloud.com>
Date: Thu, 31 Oct 2024 19:11:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241031095918.99964-7-john.g.garry@oracle.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHo4fxZSNnlzLTAQ--.891S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZrWfGr1DZw1fXFy8AFyDGFg_yoWrAw18pr
	4qgF1rArW5JFZI9w13JFsrKasYyry0qrW2yrWxG34xJFnIqr98KF18XrWYgry5uFy5ury3
	X3Z5ur4DC39rtFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9ab4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IE
	e2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4I
	kC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWU
	WwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr
	0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWU
	JVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJr
	UvcSsGvfC2KfnxnUUI43ZEXa7IUbmii3UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2024/10/31 17:59, John Garry Ð´µÀ:
> Add proper bio_split() error handling. For any error, call
> raid_end_bio_io() and return. Except for discard, where we end the bio
> directly.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   drivers/md/raid10.c | 47 ++++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 46 insertions(+), 1 deletion(-)
> 
LGTM
Reviewed-by: Yu Kuai <yukuai3@huawei.com>

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index f3bf1116794a..ccd95459b192 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1159,6 +1159,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
>   	int slot = r10_bio->read_slot;
>   	struct md_rdev *err_rdev = NULL;
>   	gfp_t gfp = GFP_NOIO;
> +	int error;
>   
>   	if (slot >= 0 && r10_bio->devs[slot].rdev) {
>   		/*
> @@ -1206,6 +1207,10 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
>   	if (max_sectors < bio_sectors(bio)) {
>   		struct bio *split = bio_split(bio, max_sectors,
>   					      gfp, &conf->bio_split);
> +		if (IS_ERR(split)) {
> +			error = PTR_ERR(split);
> +			goto err_handle;
> +		}
>   		bio_chain(split, bio);
>   		allow_barrier(conf);
>   		submit_bio_noacct(bio);
> @@ -1236,6 +1241,11 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
>   	mddev_trace_remap(mddev, read_bio, r10_bio->sector);
>   	submit_bio_noacct(read_bio);
>   	return;
> +err_handle:
> +	atomic_dec(&rdev->nr_pending);
> +	bio->bi_status = errno_to_blk_status(error);
> +	set_bit(R10BIO_Uptodate, &r10_bio->state);
> +	raid_end_bio_io(r10_bio);
>   }
>   
>   static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
> @@ -1347,9 +1357,10 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
>   				 struct r10bio *r10_bio)
>   {
>   	struct r10conf *conf = mddev->private;
> -	int i;
> +	int i, k;
>   	sector_t sectors;
>   	int max_sectors;
> +	int error;
>   
>   	if ((mddev_is_clustered(mddev) &&
>   	     md_cluster_ops->area_resyncing(mddev, WRITE,
> @@ -1482,6 +1493,10 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
>   	if (r10_bio->sectors < bio_sectors(bio)) {
>   		struct bio *split = bio_split(bio, r10_bio->sectors,
>   					      GFP_NOIO, &conf->bio_split);
> +		if (IS_ERR(split)) {
> +			error = PTR_ERR(split);
> +			goto err_handle;
> +		}
>   		bio_chain(split, bio);
>   		allow_barrier(conf);
>   		submit_bio_noacct(bio);
> @@ -1503,6 +1518,26 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
>   			raid10_write_one_disk(mddev, r10_bio, bio, true, i);
>   	}
>   	one_write_done(r10_bio);
> +	return;
> +err_handle:
> +	for (k = 0;  k < i; k++) {
> +		int d = r10_bio->devs[k].devnum;
> +		struct md_rdev *rdev = conf->mirrors[d].rdev;
> +		struct md_rdev *rrdev = conf->mirrors[d].replacement;
> +
> +		if (r10_bio->devs[k].bio) {
> +			rdev_dec_pending(rdev, mddev);
> +			r10_bio->devs[k].bio = NULL;
> +		}
> +		if (r10_bio->devs[k].repl_bio) {
> +			rdev_dec_pending(rrdev, mddev);
> +			r10_bio->devs[k].repl_bio = NULL;
> +		}
> +	}
> +
> +	bio->bi_status = errno_to_blk_status(error);
> +	set_bit(R10BIO_Uptodate, &r10_bio->state);
> +	raid_end_bio_io(r10_bio);
>   }
>   
>   static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
> @@ -1644,6 +1679,11 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
>   	if (remainder) {
>   		split_size = stripe_size - remainder;
>   		split = bio_split(bio, split_size, GFP_NOIO, &conf->bio_split);
> +		if (IS_ERR(split)) {
> +			bio->bi_status = errno_to_blk_status(PTR_ERR(split));
> +			bio_endio(bio);
> +			return 0;
> +		}
>   		bio_chain(split, bio);
>   		allow_barrier(conf);
>   		/* Resend the fist split part */
> @@ -1654,6 +1694,11 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
>   	if (remainder) {
>   		split_size = bio_sectors(bio) - remainder;
>   		split = bio_split(bio, split_size, GFP_NOIO, &conf->bio_split);
> +		if (IS_ERR(split)) {
> +			bio->bi_status = errno_to_blk_status(PTR_ERR(split));
> +			bio_endio(bio);
> +			return 0;
> +		}
>   		bio_chain(split, bio);
>   		allow_barrier(conf);
>   		/* Resend the second split part */
> 

