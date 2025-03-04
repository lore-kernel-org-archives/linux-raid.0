Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681F5B640
	for <linux-raid@vger.kernel.org>; Tue,  4 Mar 2025 11:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741086197; cv=none; b=IBd05QlqU0kJ3CedT7lmvL8GD8e+wJjmX286mDsbAwmtveXVbewU5kCzl31dvqwKcvdS0++2ECgYmc1rLSe9JsiyyTZ+Fidm6fBnL3yJXxbNTgllLmoaKK5TX7mDZkDaeTYJM2KUTFHUE1vYCRhq+0QhagCt1PwIE0cJ37hX9j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741086197; c=relaxed/simple;
	bh=Rany87zxFvBBk8cgMhQ3F/KH3pp+e4V99PyoDuogOIE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iYpJyI/zXAgsRSaNEu0sAS/zgeFljdXjzfN0Nn2mY5Px6l3gowg2LukcPu4EbflhBOB1Y9yFCTmmcWVPWAF4Vous5mKfx55eiO6T34DM22eUGOpZq/MuVLAKfypbVuMGByCN8pb7nIW+95VVUK14/TyJ8/jbWaEqd+MkykBd8AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id B52CD61E64795;
	Tue, 04 Mar 2025 12:02:57 +0100 (CET)
Message-ID: <2c14d833-12ce-42ef-80ba-a02c5e489195@molgen.mpg.de>
Date: Tue, 4 Mar 2025 12:02:57 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] md/raid10: wait barrier before returning discard
 request with REQ_NOWAIT
To: Xiao Ni <xni@redhat.com>
Cc: yukuai1@huaweicloud.com, song@kernel.org, linux-raid@vger.kernel.org
References: <20250304104159.19102-1-xni@redhat.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20250304104159.19102-1-xni@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Xiao,


Thank you for your patch. A minor thing, I’d add a verb to the 
summary/title:

> Add wait barrier before …

Am 04.03.25 um 11:41 schrieb Xiao Ni:
> raid10_handle_discard should wait barrier before returning a discard bio
> which has REQ_NOWAIT. And there is no need to print warning calltrace
> if a discard bio has REQ_NOWAIT flag. Quality engineer usually checks
> dmesg and reports error if dmesg has warning/error calltrace.

As written in the other thread, please add, why the warning is not 
useful. Somebody added that warning probably with some reason.

> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>   drivers/md/raid10.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 15b9ae5bf84d..7bbc04522f26 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1631,11 +1631,10 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
>   	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
>   		return -EAGAIN;
>   
> -	if (WARN_ON_ONCE(bio->bi_opf & REQ_NOWAIT)) {
> +	if (!wait_barrier(conf, bio->bi_opf & REQ_NOWAIT)) {
>   		bio_wouldblock_error(bio);
>   		return 0;
>   	}
> -	wait_barrier(conf, false);
>   
>   	/*
>   	 * Check reshape again to avoid reshape happens after checking


Kind regards,

Paul
