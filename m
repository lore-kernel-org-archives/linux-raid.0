Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC8B1D2F42
	for <linux-raid@vger.kernel.org>; Thu,  4 Sep 2025 12:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756987779; cv=none; b=HwXT08de1tY1QKurS+Yjc/ow0l6Z/Tua+xSQ+jbjo6QRd1OTzI2rACt4QOlrVYn1u9ecupJ3q5Et4NYmRhqeG/Lug9kXUVAtXHZIQQsan5+8pgobt5My0lBsCCA46z7KeobaCCQeiO6YWu2O333eCFPCnEK/9z+miF5+a4ZgKqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756987779; c=relaxed/simple;
	bh=cGtYQqouNYfdoBmV2cv2iLlqQUYn2Uyabun1wyk+TeA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dY847lxypMDaGx2gY5qGSJuiEkF/9UJszeUsHqCCreeY0ozllcqfjxYFO/wLz1pgROhJSusJaySK7W/S8HEXD+AN6SdPho+lG1WhGEose7O8KMtovqT0NiLgRwWYB+c/DfadLKFlX36h0Rs6Lm1dcSANXJRRcEwedN35RxsCzi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [141.14.220.42] (g42.guest.molgen.mpg.de [141.14.220.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 5243660288278;
	Thu, 04 Sep 2025 14:08:59 +0200 (CEST)
Message-ID: <423f39ec-beec-4537-8df6-4c02672a3d27@molgen.mpg.de>
Date: Thu, 4 Sep 2025 14:08:57 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md: cleanup md_check_recovery()
To: Wu Guanghao <wuguanghao3@huawei.com>
Cc: song@kernel.org, yukuai3@huawei.com, linux-raid@vger.kernel.org,
 yangyun50@huawei.com
References: <b6af99f8-dc0c-89c7-cd97-688a5cec1560@huawei.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <b6af99f8-dc0c-89c7-cd97-688a5cec1560@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Guanghao,


Thank you for your patch. For the summary I suggest:

Factor out code into md_should_do_recovery()

Am 04.09.25 um 13:13 schrieb Wu Guanghao:
> In md_check_recovery(), use new helpers to make code cleaner.

Singular *helper*?

> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
> ---
>   drivers/md/md.c | 41 +++++++++++++++++++++++++++++------------
>   1 file changed, 29 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 1baaf52c603c..cbbb9ac14cf6 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9741,6 +9741,34 @@ static void unregister_sync_thread(struct mddev *mddev)
>   	md_reap_sync_thread(mddev);
>   }
> 
> +
> +

Why so many blank lines.

> +static bool md_should_do_recovery(struct mddev *mddev)
> +{
> +	/*
> +	 * As long as one of the following flags is set,
> +	 * recovery needs to do.

… recovery needs to be do*ne*?

> +	 */
> +	if (test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
> +	    test_bit(MD_RECOVERY_DONE, &mddev->recovery))
> +		return true;
> +
> +	/*
> +	 * If no flags are set and it is in read-only status,
> +	 * there is nothing to do.

Ditto.

> +	 */
> +	if (!md_is_rdwr(mddev))
> +		return false;
> +
> +	if ((mddev->sb_flags & ~ (1<<MD_SB_CHANGE_PENDING)) ||
> +	     (mddev->external == 0 && mddev->safemode == 1) ||
> +	     (mddev->safemode == 2 && !mddev->in_sync &&
> +	      mddev->resync_offset == MaxSector))
> +		return true;
> +
> +	return false;
> +}
> +
>   /*
>    * This routine is regularly called by all per-raid-array threads to
>    * deal with generic issues like resync and super-block update.
> @@ -9777,18 +9805,7 @@ void md_check_recovery(struct mddev *mddev)
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

The code diff looks good.


Kind regards,

Paul
