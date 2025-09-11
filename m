Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B004329F17
	for <linux-raid@vger.kernel.org>; Thu, 11 Sep 2025 06:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757573166; cv=none; b=F3Ze5/sgOQImbq+NM2UbTtnMP9xd7jcc9QaiYm4IPS+HlM2/uRTfv0qIbxYRbDR883PdRy8lfSB2RY1tnmSI2t7fQVrYW0tOR2shd/HJk5entHvBGBi8ngPrnS5685/lev/wBcMAHjmwcQGqNYAgoMOhJEXBN/Vtgpcof+NyuiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757573166; c=relaxed/simple;
	bh=B5kcMDFoGgokKoFjXEDFBqKtgtZIO+m/k3uBb24IJKA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qXkUjFnc5UUWUIPwtJEAIwIpLPXyp9rw+U9TdHUdS6ihn4Wm1LY+i/SNH62YSmyGq1Nke4tOPgwp4Z6aGHQE/QaC4sKH/ZXjYdrrm3G0MvpMqlkvJApq+ljGZjb/ZTLHvNh80znUdfRh8ztBh2WoTGPNLT27+hu44tgg6dGmfFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.192] (ip5f5af7f6.dynamic.kabel-deutschland.de [95.90.247.246])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 6B56660213B25;
	Thu, 11 Sep 2025 08:45:31 +0200 (CEST)
Message-ID: <e5e0569e-58a3-47b9-9221-cc6df190bfa6@molgen.mpg.de>
Date: Thu, 11 Sep 2025 08:45:31 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] Factor out code into md_should_do_recovery()
To: Wu Guanghao <wuguanghao3@huawei.com>
Cc: Yu Kuai <yukuai3@huawei.com>, song@kernel.org, yangyun50@huawei.com,
 linux-raid@vger.kernel.org
References: <e62894c8-d916-94bc-ef48-3c60e6e1fc5d@huawei.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <e62894c8-d916-94bc-ef48-3c60e6e1fc5d@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Guanghao,


Thank you for your patch. The prefix is missing in the summary. (I 
believe, I didn’t write it explicitly in my answer to version 1.)

Some minor comments:

Am 08.09.25 um 10:20 schrieb Wu Guanghao:
> In md_check_recovery(), use new helper to make code cleaner.

… and add comments.

> v2: split judgment conditions and add comments

The change-log often goes below the separator ---.

> 
> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
> ---

(I mean here.)

Also, as the subject changed, a link to the first version would also 
help a few people.

https://lore.kernel.org/all/b6af99f8-dc0c-89c7-cd97-688a5cec1560@huawei.com/

>   drivers/md/md.c | 59 +++++++++++++++++++++++++++++++++++++++----------
>   1 file changed, 47 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 1baaf52c603c..58ce3518f51b 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9741,6 +9741,52 @@ static void unregister_sync_thread(struct mddev *mddev)
>   	md_reap_sync_thread(mddev);
>   }
> 
> +static bool md_should_do_recovery(struct mddev *mddev)
> +{
> +	/*
> +	 * As long as one of the following flags is set,
> +	 * recovery needs to do or cleanup.

The first part of the comment is redundant, as it’s exactly what the 
code does. The second part about “cleanup” would warrant more 
information, in my humble opinion.

> +	 */
> +	if (test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
> +	    test_bit(MD_RECOVERY_DONE, &mddev->recovery))
> +		return true;
> +
> +	/*
> +	 * If no flags are set and it is in read-only status,
> +	 * there is nothing to do.
> +	 */
> +	if (!md_is_rdwr(mddev))
> +		return false;

The comment is redundant.

> +
> +	/*
> +	 * MD_SB_CHANGE_PENDING indicates that the array is switching from clean to
> +	 * active, and no action is needed for now.
> +	 * All other MD_SB_* flags require to update the superblock.
> +	 */
> +	if (mddev->sb_flags & ~ (1<<MD_SB_CHANGE_PENDING))
> +		return true;

The function name includes `do_recovery`. Isn’t that an “action”?

> +
> +	/*
> +	 * If the array is not using external metadata and there has been no data
> +	 * written for some time, then the array's status needs to be set to
> +	 * in_sync.
> +	 */
> +	if (mddev->external == 0 && mddev->safemode == 1)
> +		return true;

The comment confuses me. What does `in_sync` have to do with the code?

> +
> +	/*
> +	 * When the system is about to restart or the process receives an signal,

a signal (no *n*)

> +	 * the array needs to be synchronized as soon as possible.
> +	 * Once the data synchronization is completed, need to change the array
> +	 * status to in_sync.
> +	 */
> +	if (mddev->safemode == 2 && !mddev->in_sync &&

(I guess macros/enums should be defined for the different safe modes. 
This would be a separate patch though.)

> +	    mddev->resync_offset == MaxSector)

Excuse my ignorance, but why the last condition? Would this be something 
to add to the comment?

> +		return true;
> +
> +	return false;
> +}
> +
>   /*
>    * This routine is regularly called by all per-raid-array threads to
>    * deal with generic issues like resync and super-block update.
> @@ -9777,18 +9823,7 @@ void md_check_recovery(struct mddev *mddev)
>   		flush_signals(current);
>   	}
> 
> -	if (!md_is_rdwr(mddev) &&
> -	    !test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) &&
> -	    !test_bit(MD_RECOVERY_DONE, &mddev->recovery))
> -		return;
> -	if ( ! (
> -		(mddev->sb_flags & ~ (1<<MD_SB_CHANGE_PENDING)) ||
> -		test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
> -		test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
> -		(mddev->external == 0 && mddev->safemode == 1) ||
> -		(mddev->safemode == 2
> -		 && !mddev->in_sync && mddev->resync_offset == MaxSector)
> -		))
> +	if (!md_should_do_recovery(mddev))
>   		return;
> 
>   	if (mddev_trylock(mddev)) {

Did you check, if the compiler generates different code? If you do/did, 
please add it to the commit message.


Kind regards,

Paul
