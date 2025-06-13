Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B562DA772;
	Fri, 13 Jun 2025 08:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749801761; cv=none; b=OcFnwPgl3/pUFWTYQ1WDpPXYbqSVB1pTKW/w8WlXFiLSN4fnHhB0cV5URGC97aFLIEc1qWvcy8Eejbf2dc0EEPw0BO/VENCmw1eSI8qJqbHVQFX12wjKy+tU1W6lowsGK9YN9rHaJPvvEKR0q8YUkMlqxz/VaO6tDmgeg50r+qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749801761; c=relaxed/simple;
	bh=F+O1Z+Mot7lZF6wg2R1SqPqi0jvS0szJQYkBterefi0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YsqChHfsyxkwPPMSHPpPMIakcUh9HQHFGZU4R+t6iA/QojR7GqBwODspCi97bTO9AcvqqJKQIhnKlmjQ7ah0tVTj9p/mhVwv0xpIr55wNcU3uhcPBlV5RWfrueP7yTto5Gct/G8bUH5YWWwzR/ceyVdYlC+InvWm5bK8tH/KelU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.2.111] (p57bd96bf.dip0.t-ipconnect.de [87.189.150.191])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 6D47B61E647A3;
	Fri, 13 Jun 2025 10:02:09 +0200 (CEST)
Message-ID: <a67b2409-334b-4712-b31d-efcbd2e216f5@molgen.mpg.de>
Date: Fri, 13 Jun 2025 10:02:08 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/raid1,raid10: fix IO handle for REQ_NOWAIT
To: Zheng Qixing <zhengqixing@huaweicloud.com>
Cc: song@kernel.org, yukuai3@huawei.com, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 zhengqixing@huawei.com
References: <20250612132141.358202-1-zhengqixing@huaweicloud.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20250612132141.358202-1-zhengqixing@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Zheng,


Thank you for the patch.

Am 12.06.25 um 15:21 schrieb Zheng Qixing:
> From: Zheng Qixing <zhengqixing@huawei.com>
> 
> IO with REQ_NOWAIT should not set R1BIO_Uptodate when it fails,
> and bad blocks should also be cleared when REQ_NOWAIT IO succeeds.

It’d be great if you could add an explanation for the *should*. Why 
should it not be done?

Do you have a reproducer for this?

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

Excuse my ignorance. What is the difference between ignore and discard?

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


Kind regards,

Paul
