Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7AE3A9618;
	Mon, 27 Apr 2026 14:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777301406; cv=none; b=LnL2QMzbosM1bYEm1bRzz88s4zKC5oc38Pzct1DL24vjvXjOwiw8n23r+M9GUtG+4jTc8Jcb//UgT4BP0kMg8kSoAQF/z37zVLb9GCmMF6hpCi/hDUT5HuUKK2nlVKijuQJD+ofl5Ix0Mb6Qp7LmZmPwUDn9VnyyYNrBI3KxWxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777301406; c=relaxed/simple;
	bh=D7IRaKBV2YwY4TVdSPFULkEV2LI8JltA1Rcms8R5cYM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=klY2zlM2zAfz0zHXtQv+ZTjmxe7Emh2+i2tGZnRSgmT+zsOeMIdi4Lvs2rCGvKfSzM+cnwc5KslW2xbanbwkv/cLw2NUkfBmttzGKL81N1Fto8YOm+s4UU0nCiXOIzVN/4lTGjbTygNheIZoXAas9bMj6iVEmhzMdZ7Br5U0pA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [141.14.220.42] (g42.guest.molgen.mpg.de [141.14.220.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 80E434C2C37D45;
	Mon, 27 Apr 2026 16:49:28 +0200 (CEST)
Message-ID: <c859ab17-cfc6-4e54-9a79-8b0d2b145adc@molgen.mpg.de>
Date: Mon, 27 Apr 2026 16:49:28 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/raid1: fix bio splitting in raid1 thread to avoid
 recursion and deadlock
To: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
References: <20260427103446.300378-1-abd.masalkhi@gmail.com>
Content-Language: en-US
Cc: song@kernel.org, yukuai@fnnas.com, shli@fb.com, neilb@suse.com,
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20260427103446.300378-1-abd.masalkhi@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Abd-Alrhman,


Thank you for your patch.

Am 27.04.26 um 12:34 schrieb Abd-Alrhman Masalkhi:
> Splitting a bio while executing in the raid1 thread can lead to
> recursion, as task->bio_list is NULL in this context.
> 
> In addition, resubmitting an md_cloned_bio after splitting may lead to
> a deadlock if the array is suspended before the md driver calls
> percpu_ref_tryget_live(&mddev->active_io) on it's path to
> pers->make_request().
> 
> Avoid splitting the bio in this context and require that it is either
> read in full or not at all.
> 
> This prevents recursion and avoids potential deadlocks during array
> suspension.

Do you have a reproducer?

> Fixes: 689389a06ce7 ("md/raid1: simplify handle_read_error().")
> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
> ---
> I sent an email about this issue two days ago, but at the time I was not
> sure whether it was a real problem or a misunderstanding on my part.
> 
> After further analysis, it appears that this issue can occur.
> 
> Apologies for the earlier confusion, and thank you for your time.
> 
> Abd-Alrhman

I suggest to always share the URL (lore.kernel.org), when referencing 
another thread. If relevant, maybe even reference your message with a 
Link: tag in the commit message.

> ---
>   drivers/md/raid1.c | 33 ++++++++++++++++++++++++---------
>   1 file changed, 24 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index cc9914bd15c1..14f6d6625811 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -607,7 +607,7 @@ static int choose_first_rdev(struct r1conf *conf, struct r1bio *r1_bio,
>   
>   		/* choose the first disk even if it has some bad blocks. */
>   		read_len = raid1_check_read_range(rdev, this_sector, &len);
> -		if (read_len > 0) {
> +		if (read_len > 0 && (!*max_sectors || read_len == r1_bio->sectors)) {
>   			update_read_sectors(conf, disk, this_sector, read_len);
>   			*max_sectors = read_len;
>   			return disk;
> @@ -704,8 +704,13 @@ static int choose_slow_rdev(struct r1conf *conf, struct r1bio *r1_bio,
>   	}
>   
>   	if (bb_disk != -1) {
> -		*max_sectors = bb_read_len;
> -		update_read_sectors(conf, bb_disk, this_sector, bb_read_len);
> +		if (!*max_sectors || bb_read_len == r1_bio->sectors) {
> +			*max_sectors = bb_read_len;
> +			update_read_sectors(conf, bb_disk, this_sector,
> +					    bb_read_len);
> +		} else {
> +			bb_disk = -1;
> +		}
>   	}
>   
>   	return bb_disk;
> @@ -852,8 +857,9 @@ static int choose_best_rdev(struct r1conf *conf, struct r1bio *r1_bio)
>    * disks and disks with bad blocks for now. Only pay attention to key disk
>    * choice.
>    *
> - * 3) If we've made it this far, now look for disks with bad blocks and choose
> - * the one with most number of sectors.
> + * 3) If we've made it this far and *max_sectors is 0 (i.e., we are tolerant
> + * of bad blocks), look for disks with bad blocks and choose the one with
> + * the most sectors.
>    *
>    * 4) If we are all the way at the end, we have no choice but to use a disk even
>    * if it is write mostly.
> @@ -882,11 +888,13 @@ static int read_balance(struct r1conf *conf, struct r1bio *r1_bio,
>   	/*
>   	 * If we are here it means we didn't find a perfectly good disk so
>   	 * now spend a bit more time trying to find one with the most good
> -	 * sectors.
> +	 * sectors. but only if we are tolerant of bad blocks.

s/but/But/

>   	 */
> -	disk = choose_bb_rdev(conf, r1_bio, max_sectors);
> -	if (disk >= 0)
> -		return disk;
> +	if (!*max_sectors) {
> +		disk = choose_bb_rdev(conf, r1_bio, max_sectors);
> +		if (disk >= 0)
> +			return disk;
> +	}
>   
>   	return choose_slow_rdev(conf, r1_bio, max_sectors);
>   }
> @@ -1346,7 +1354,14 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
>   	/*
>   	 * make_request() can abort the operation when read-ahead is being
>   	 * used and no empty request is available.
> +	 *
> +	 * If we allow splitting the bio while executing in the raid1 thread,
> +	 * we may end up recursing (current->bio_list is NULL), and we might
> +	 * also deadlock if we try to suspend the array, since we are
> +	 * resubmitting an md_cloned_bio. Therefore, we must be read either

… we must read …

> +	 * all the sectors or none.
>   	 */
> +	max_sectors = r1bio_existed;

Excuse my ignorance, but I do not get why a bool is assigned to an int 
representing the maximum sector value.

>   	rdisk = read_balance(conf, r1_bio, &max_sectors);
>   	if (rdisk < 0) {
>   		/* couldn't find anywhere to read from */


Kind regards,

Paul
