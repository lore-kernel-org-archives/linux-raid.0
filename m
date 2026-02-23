Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FAF437BE67
	for <linux-raid@vger.kernel.org>; Mon, 23 Feb 2026 22:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771884128; cv=none; b=G8iu3eFUt55izdQEWHKpFc2KRGoZa/Gtd2UFHJu4H77L8vnOIp32jw6NW+WY90PWemutHoeaQDzk2uFjsagQKfYlk+FzILO0HevBOecVNejTrQRTFrHHx42t0MQZdmIbSkV61r9Ptp6FWG21erKfQQjws1jitU9pxWYIBE5AoPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771884128; c=relaxed/simple;
	bh=NuG140xeMhYp+LQYprO+nJJWF9LgzqsXF+9hEuZKbdI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u9UVVCzRp4Tz/EEmfeJ3Rz+1iF09tbuhuUJiENxch66slD6Raqbo3YZidROnsBE/VCVMNpSr7/Fg3uGg/qXLy7Vxd3E1cRZHXngQq75uHn4FkC04XsX356rV0t7aOLR4HDWjGrr27QwwRDP4trWtmum1J5xKgiN9Prx+z19Agak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.192] (ip5f5af75f.dynamic.kabel-deutschland.de [95.90.247.95])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 2CFDF4C2C37F01;
	Mon, 23 Feb 2026 23:01:06 +0100 (CET)
Message-ID: <a6bd98b4-916d-4c1e-842e-a4a5fc4a38aa@molgen.mpg.de>
Date: Mon, 23 Feb 2026 23:01:03 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 16/62] md: Make mddev_suspend() easier to analyze
To: Bart Van Assche <bvanassche@acm.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai@fnnas.com>, linux-raid@vger.kernel.org
References: <20260223214950.2153735-1-bvanassche@acm.org>
 <20260223214950.2153735-17-bvanassche@acm.org>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20260223214950.2153735-17-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Dear Bart,


Thank you for the patch.

Am 23.02.26 um 22:49 schrieb Bart Van Assche:
> Prepare for enabling Clang's thread-safety analysis by moving an
> if-statement. No functionality has been changed.

Why does the if-statement need to be moved? Could you explain it in the 
commit message?

> Cc: Song Liu <song@kernel.org>
> Cc: Yu Kuai <yukuai@fnnas.com>
> Cc: linux-raid@vger.kernel.org
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/md/md.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 3ce6f9e9d38e..b0d260d03a7d 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -475,12 +475,13 @@ int mddev_suspend(struct mddev *mddev, bool interruptible)
>   	 */
>   	lockdep_assert_not_held(&mddev->reconfig_mutex);
>   
> -	if (interruptible)
> +	if (interruptible) {
>   		err = mutex_lock_interruptible(&mddev->suspend_mutex);
> -	else
> +		if (err)
> +			return err;
> +	} else {
>   		mutex_lock(&mddev->suspend_mutex);
> -	if (err)
> -		return err;
> +	}
>   
>   	if (mddev->suspended) {
>   		WRITE_ONCE(mddev->suspended, mddev->suspended + 1);
> 


Kind regards,

Paul
