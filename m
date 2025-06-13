Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AB3291C20;
	Fri, 13 Jun 2025 09:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749806992; cv=none; b=US7ARzxGSxY/QppRTpkOWbjMW1l5mTXU5wLCFZtwEmaOYcRB/pcPKvPOCGatuUx5ojhTRMwSUA3sU4RSwVBNp6O59jPBEdEKgMKIDd3STrJ+SMjqzcYtGz3Vx8kdgBKCZPta4pkcT7annXPPFOadkjLTUJixBwZUB0tgvx7gM8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749806992; c=relaxed/simple;
	bh=dTFe4i14xDT19JSJo8KCeKJsJ0q9GY1gJEdMW/eHGHw=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=rYh/kBDAoJ4O+QspnLbtCaooFJeZKR8/t4GHFWd605UcYrEQPXqdCR24ofezuYnlj9/m5KVC6zm2N4eBgYt4pmgZaH0dQzWcmMDzSIz06XfQSVfMHAuJzbNgXyKLJWB1gqQxLxjc2RCzENIJbQaJxuR2qoNxdJzl9WzXKytD/q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bJYyM5MHfzYQvlF;
	Fri, 13 Jun 2025 17:29:47 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B75C21A1538;
	Fri, 13 Jun 2025 17:29:46 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgBHrGCJ70toVayHPQ--.51121S3;
	Fri, 13 Jun 2025 17:29:46 +0800 (CST)
Subject: Re: [PATCH] md/raid1,raid10: fix IO handle for REQ_NOWAIT
To: Zheng Qixing <zhengqixing@huaweicloud.com>, song@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, zhengqixing@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250612132141.358202-1-zhengqixing@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <dfbb5d06-68aa-9acc-a13c-0863f5a25193@huaweicloud.com>
Date: Fri, 13 Jun 2025 17:29:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250612132141.358202-1-zhengqixing@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHrGCJ70toVayHPQ--.51121S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJF4xuw45Gr47XF4xZrW3Awb_yoW5tr48p3
	yUGa9Yv39rGFWUu3WDtFWUZayF9w4Ygay7C3yUJ34xXas09FZ8Aa1DJ34YgF4DXrWfuw4a
	q3ZYgw4DCFWayFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AF
	wI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUot
	CzDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/06/12 21:21, Zheng Qixing Ð´µÀ:
> From: Zheng Qixing <zhengqixing@huawei.com>
> 
> IO with REQ_NOWAIT should not set R1BIO_Uptodate when it fails,
> and bad blocks should also be cleared when REQ_NOWAIT IO succeeds.
> 
> Fixes: 9f346f7d4ea7 ("md/raid1,raid10: don't handle IO error for REQ_RAHEAD and REQ_NOWAIT")
> Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
> ---
>   drivers/md/raid1.c  | 11 ++++++-----
>   drivers/md/raid10.c |  9 +++++----
>   2 files changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 19c5a0ce5a40..a1cddd24b178 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -455,13 +455,13 @@ static void raid1_end_write_request(struct bio *bio)
>   	struct md_rdev *rdev = conf->mirrors[mirror].rdev;
>   	sector_t lo = r1_bio->sector;
>   	sector_t hi = r1_bio->sector + r1_bio->sectors;
> -	bool ignore_error = !raid1_should_handle_error(bio) ||
> -		(bio->bi_status && bio_op(bio) == REQ_OP_DISCARD);
> +	bool discard_error = bio->bi_status && bio_op(bio) == REQ_OP_DISCARD;
>   
>   	/*
>   	 * 'one mirror IO has finished' event handler:
>   	 */
> -	if (bio->bi_status && !ignore_error) {
> +	if (bio->bi_status && !discard_error &&
> +	    raid1_should_handle_error(bio)) {
>   		set_bit(WriteErrorSeen,	&rdev->flags);
>   		if (!test_and_set_bit(WantReplacement, &rdev->flags))
>   			set_bit(MD_RECOVERY_NEEDED, &
> @@ -507,12 +507,13 @@ static void raid1_end_write_request(struct bio *bio)
>   		 * check this here.
>   		 */
>   		if (test_bit(In_sync, &rdev->flags) &&
> -		    !test_bit(Faulty, &rdev->flags))
> +		    !test_bit(Faulty, &rdev->flags) &&
> +		    (!bio->bi_status || discard_error))
>   			set_bit(R1BIO_Uptodate, &r1_bio->state);

BTW, for nowait, the error value returned to user should be -EAGAIN, not
-EIO, you'd better cook another patch to change this.

Thanks,
Kuai

>   
>   		/* Maybe we can clear some bad blocks. */
>   		if (rdev_has_badblock(rdev, r1_bio->sector, r1_bio->sectors) &&
> -		    !ignore_error) {
> +		    !bio->bi_status) {
>   			r1_bio->bios[mirror] = IO_MADE_GOOD;
>   			set_bit(R1BIO_MadeGood, &r1_bio->state);
>   		}
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index b74780af4c22..1848947b0a6d 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -458,8 +458,8 @@ static void raid10_end_write_request(struct bio *bio)
>   	int slot, repl;
>   	struct md_rdev *rdev = NULL;
>   	struct bio *to_put = NULL;
> -	bool ignore_error = !raid1_should_handle_error(bio) ||
> -		(bio->bi_status && bio_op(bio) == REQ_OP_DISCARD);
> +	bool discard_error = bio->bi_status && bio_op(bio) == REQ_OP_DISCARD;
> +	bool ignore_error = !raid1_should_handle_error(bio) || discard_error;
>   
>   	dev = find_bio_disk(conf, r10_bio, bio, &slot, &repl);
>   
> @@ -522,13 +522,14 @@ static void raid10_end_write_request(struct bio *bio)
>   		 * check this here.
>   		 */
>   		if (test_bit(In_sync, &rdev->flags) &&
> -		    !test_bit(Faulty, &rdev->flags))
> +		    !test_bit(Faulty, &rdev->flags) &&
> +		    (!bio->bi_status || discard_error))
>   			set_bit(R10BIO_Uptodate, &r10_bio->state);
>   
>   		/* Maybe we can clear some bad blocks. */
>   		if (rdev_has_badblock(rdev, r10_bio->devs[slot].addr,
>   				      r10_bio->sectors) &&
> -		    !ignore_error) {
> +		    !bio->bi_status) {
>   			bio_put(bio);
>   			if (repl)
>   				r10_bio->devs[slot].repl_bio = IO_MADE_GOOD;
> 

