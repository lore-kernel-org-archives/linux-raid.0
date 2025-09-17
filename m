Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE032EAB68;
	Wed, 17 Sep 2025 09:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758101104; cv=none; b=u5LgkhNliIDasCex3fD2V6ItQtMMBHsXALfD3o1F6Jg0FBofshmrQiJvotNKGmm0SiDSYxHxeMNOV73KGYHPfki/IgDsZ8lmilebmdenqlMsCZ1GDt4CORGJL3EzeVsJVH0wUxCC40/I6TEW2QA58OAb3/z8ORKUmLpH7QGK5YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758101104; c=relaxed/simple;
	bh=slEQ1mNfqMRsV3a08Jsr5k+RAqQYYttn6OA+jBPRlxw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AQ7dmlMake4BXIstblH9SBc4A8VVJsnoYL3wp0MNOq6ExPgWDQxQyYpReSzv+hrclG+39fVHyyxd7tnVG8TP9qJlS8s+bFagZ+aXGf9rXNzV6/pVpa9bcjnt7bB5FWnBgnCJjmgIdvLRP6Hw+OGE5RIm3fAZ/AF8CcEwyHqe6Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cRYJW4YrczYQvNY;
	Wed, 17 Sep 2025 17:24:59 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 40C7A1A148E;
	Wed, 17 Sep 2025 17:24:58 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP4 (Coremail) with SMTP id gCh0CgD3QY5pfspohUY0Cw--.51384S3;
	Wed, 17 Sep 2025 17:24:58 +0800 (CST)
Message-ID: <837a4dd4-045f-a956-a241-cab1e8bc20fe@huaweicloud.com>
Date: Wed, 17 Sep 2025 17:24:57 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v4 5/9] md/raid1,raid10: Set R{1,10}BIO_Uptodate when
 successful retry of a failed bio
To: Kenta Akagi <k@mgml.me>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>, Mariusz Tkaczyk <mtkaczyk@kernel.org>,
 Shaohua Li <shli@fb.com>, Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250915034210.8533-1-k@mgml.me>
 <20250915034210.8533-6-k@mgml.me>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20250915034210.8533-6-k@mgml.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3QY5pfspohUY0Cw--.51384S3
X-Coremail-Antispam: 1UD129KBjvJXoWxKF47Gw45AFWkCr4DKr18uFg_yoW7Ww48pa
	yDKasayFWqq342qrnrAFWUWF9Ykw1xtFW2kr4rG3srW3Z8tr93KF48XryYgryUZr9xu3W2
	qFs8WrWUCFsrJFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Yb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487
	Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aV
	AFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xF
	o4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjxUrsjjDUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/9/15 11:42, Kenta Akagi 写道:
> In the current implementation, when a write bio fails, the retry flow
> is as follows:
> * In bi_end_io, e.g. raid1_end_write_request, R1BIO_WriteError is
>    set on the r1bio.
> * The md thread calls handle_write_finished corresponding to this r1bio.
> * Inside handle_write_finished, narrow_write_error is invoked.
> * narrow_write_error rewrites the r1bio on a per-sector basis, marking
>    any failed sectors as badblocks. It returns true if all sectors succeed,
>    or if failed sectors are successfully recorded via rdev_set_badblock.
>    It returns false if rdev_set_badblock fails or if badblocks are disabled.
> * handle_write_finished faults the rdev if it receives false from
>    narrow_write_error. Otherwise, it does nothing.
> 
> This can cause a problem where an r1bio that succeeded on retry is
> incorrectly reported as failed to the higher layer, for example in the
> following case:
> * Only one In_sync rdev exists, and
> * The write bio initially failed but all retries in
>    narrow_write_error succeed.
> 
> This commit ensures that if a write initially fails but all retries in
> narrow_write_error succeed, R1BIO_Uptodate or R10BIO_Uptodate is set
> and the higher layer receives a successful write status.
> 
> Signed-off-by: Kenta Akagi <k@mgml.me>
> ---
>   drivers/md/raid1.c  | 32 ++++++++++++++++++++++++++------
>   drivers/md/raid10.c | 21 +++++++++++++++++++++
>   2 files changed, 47 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 8fff9dacc6e0..806f5cb33a8e 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2517,6 +2517,21 @@ static void fix_read_error(struct r1conf *conf, struct r1bio *r1_bio)
>   	}
>   }
>   
> +/**
> + * narrow_write_error() - Retry write and set badblock
> + * @r1_bio:	the r1bio containing the write error
> + * @i:		which device to retry
> + *
> + * Rewrites the bio, splitting it at the least common multiple of the logical
> + * block size and the badblock size. Blocks that fail to be written are marked
> + * as bad. If badblocks are disabled, no write is attempted and false is
> + * returned immediately.
> + *
> + * Return:
> + * * %true	- all blocks were written or marked bad successfully
> + * * %false	- bbl disabled or
> + *		  one or more blocks write failed and could not be marked bad
> + */
>   static bool narrow_write_error(struct r1bio *r1_bio, int i)
>   {
>   	struct mddev *mddev = r1_bio->mddev;
> @@ -2614,9 +2629,9 @@ static void handle_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
>   	int m, idx;
>   	bool fail = false;
>   
> -	for (m = 0; m < conf->raid_disks * 2 ; m++)
> +	for (m = 0; m < conf->raid_disks * 2 ; m++) {
> +		struct md_rdev *rdev = conf->mirrors[m].rdev;
>   		if (r1_bio->bios[m] == IO_MADE_GOOD) {
> -			struct md_rdev *rdev = conf->mirrors[m].rdev;
>   			rdev_clear_badblocks(rdev,
>   					     r1_bio->sector,
>   					     r1_bio->sectors, 0);
> @@ -2628,12 +2643,17 @@ static void handle_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
>   			 */
>   			fail = true;

'fail' should be false when re-write is successful.

>   			if (!narrow_write_error(r1_bio, m))
> -				md_error(conf->mddev,
> -					 conf->mirrors[m].rdev);
> +				md_error(conf->mddev, rdev);
>   				/* an I/O failed, we can't clear the bitmap */
> -			rdev_dec_pending(conf->mirrors[m].rdev,
> -					 conf->mddev);
> +			else if (test_bit(In_sync, &rdev->flags) &&
> +				 !test_bit(Faulty, &rdev->flags) &&
> +				 rdev_has_badblock(rdev,
> +						   r1_bio->sector,
> +						   r1_bio->sectors) == 0)

Clear badblock and set R10BIO_Uptodate if rdev has badblock.

> +				set_bit(R1BIO_Uptodate, &r1_bio->state);
> +			rdev_dec_pending(rdev, conf->mddev);
>   		}
> +	}
>   	if (fail) {
>   		spin_lock_irq(&conf->device_lock);
>   		list_add(&r1_bio->retry_list, &conf->bio_end_io_list);
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index b73af94a88b0..21c2821453e1 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2809,6 +2809,21 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
>   	}
>   }
>   
> +/**
> + * narrow_write_error() - Retry write and set badblock
> + * @r10_bio:	the r10bio containing the write error
> + * @i:		which device to retry
> + *
> + * Rewrites the bio, splitting it at the least common multiple of the logical
> + * block size and the badblock size. Blocks that fail to be written are marked
> + * as bad. If badblocks are disabled, no write is attempted and false is
> + * returned immediately.
> + *
> + * Return:
> + * * %true	- all blocks were written or marked bad successfully
> + * * %false	- bbl disabled or
> + *		  one or more blocks write failed and could not be marked bad
> + */
>   static bool narrow_write_error(struct r10bio *r10_bio, int i)
>   {
>   	struct bio *bio = r10_bio->master_bio;
> @@ -2975,6 +2990,12 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
>   				fail = true;
>   				if (!narrow_write_error(r10_bio, m))
>   					md_error(conf->mddev, rdev);
> +				else if (test_bit(In_sync, &rdev->flags) &&
> +					 !test_bit(Faulty, &rdev->flags) &&
> +					 rdev_has_badblock(rdev,
> +							   r10_bio->devs[m].addr,
> +							   r10_bio->sectors) == 0)

Same as raid1.

> +					set_bit(R10BIO_Uptodate, &r10_bio->state);
>   				rdev_dec_pending(rdev, conf->mddev);
>   			}
>   			bio = r10_bio->devs[m].repl_bio;

-- 
Thanks,
Nan

