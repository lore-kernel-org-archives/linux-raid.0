Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B762AF1D;
	Fri, 21 Nov 2025 09:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763715635; cv=none; b=OyHZDzhf3RyyEuqdu+Lr+RFX1wR8u3Xx30kjTil6MvURbzSLI5Mda4tu2/uaxVGaFSaD3+RS1RucNbsR1Pp3lDG+KkvopTIsuI2B8+vZwRLTGOm5Dhqey1R0YyNQbs5TqN9ZXCX4hDWSm+eYdNMKW8wcAP+CcFpd17iwximKYSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763715635; c=relaxed/simple;
	bh=d2rZzKXf3TeEEsEXMHx1cDtMpXFRMVGDGBjm550UXkA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oCOTrPWXD8Fb1fNeazksfY+jOAZ467r5XilZKwNCMqQyR8abNQoW+TLMvEn97fsl4b0oTShfg4IdRumvaGtPehhA+wfXweOh9S9RBNLZIOgy46sxnRdK5rTnlTMtzIPdIfv7UMJRj9EpiSiT653hOOkr+0ONqKYZIw57Cy1VrLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.5] (ip5f5af75f.dynamic.kabel-deutschland.de [95.90.247.95])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 9023F61CC3FE7;
	Fri, 21 Nov 2025 09:59:55 +0100 (CET)
Message-ID: <9a59de9d-0512-445a-a051-5e98fd295f6b@molgen.mpg.de>
Date: Fri, 21 Nov 2025 09:59:54 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] md/raid0: align bio to io_opt
To: Yu Kuai <yukuai@fnnas.com>
Cc: song@kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, linan122@huawei.com, xni@redhat.com
References: <20251121051406.1316884-1-yukuai@fnnas.com>
 <20251121051406.1316884-9-yukuai@fnnas.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20251121051406.1316884-9-yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Dear Kuai,


Thank you for your patches.

Am 21.11.25 um 06:14 schrieb Yu Kuai:
> The impact is not so significant for raid0 compared to raid5, however
> it's still more appropriate to issue IOs evenly to underlying disks.

Could you please elaborate, what the problem is, and also share your 
benchmark results and test setups?

> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
> ---
>   drivers/md/raid0.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 47aee1b1d4d1..332f413bcf51 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -388,6 +388,8 @@ static int raid0_set_limits(struct mddev *mddev)
>   	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
>   	if (err)
>   		return err;
> +
> +	md_config_align_limits(mddev, &lim);
>   	return queue_limits_set(mddev->gendisk->queue, &lim);
>   }
>   


Kind regards,

Paul
