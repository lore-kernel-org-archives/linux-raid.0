Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BC13A75A6;
	Fri, 20 Mar 2026 11:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774005949; cv=none; b=o+4x7uxQZE41bHyi5clELZxmmGkiySTaUIyQfgY4fjMVTHgouy7tasw0uBSDYGDUwIR0IINYiA67SKz6qYgau/kQc+/yAJ4gAsuwdtdsnXgHQLmJTGkmc4XK7vfX+/zst/Ah2qEyYUehUEQIKF/lLWNAZV9IFUa3d62yePQgkYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774005949; c=relaxed/simple;
	bh=+nFKA+r1tHCDYif61yQp79jumKxjcu1kDRv34WASEUg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nNxKhLKFHzYTSu02AC10kjuD5mKpUySTVjXUrOwKq3YMb9/ruDLTvjez5xi6zWlT+Nln2XLjw9WkAsHt10hxCIugtb3cjc27YkuSvKx37/H0Qv9T/nV52DTyLcH0locf15j68/1Yxftgl6XSGeMweW0bbHSGurIGnPfbe4JGgLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [141.14.220.42] (g42.guest.molgen.mpg.de [141.14.220.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id D4BD04C1F29997;
	Fri, 20 Mar 2026 12:24:45 +0100 (CET)
Message-ID: <9d714bbc-f003-4084-9d3d-a2c219ba7ee9@molgen.mpg.de>
Date: Fri, 20 Mar 2026 12:24:43 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND v3 2/3] lib/raid6: Optimizing the raid6_select_algo
 time through asynchronous processing
To: sunliming@linux.dev
Cc: song@kernel.org, yukuai@fnnas.com, akpm@linux-foundation.org,
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 sunliming@kylinos.cn
References: <20260320060750.31334-1-sunliming@linux.dev>
 <20260320060750.31334-3-sunliming@linux.dev>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20260320060750.31334-3-sunliming@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear sunliming,


Thank you for your patch. Two formal things, and one “real” question.


Am 20.03.26 um 07:07 schrieb sunliming@linux.dev:
> From: sunliming <sunliming@kylinos.cn>

It’d be great if you could spell your name with spaces. Sun Li Ming or 
Sunli Ming? (`git config --global user.name "Sun Li Ming"` would 
configure it.)

> Optimizing the raid6_select_algo time. In raid6_select_algo(), an raid6 gen
> algorithm is first selected quickly through synchronous processing, while
> the time-consuming process of selecting the optimal algorithm via benchmarking

Please adhere to the text width of 75 characters. 
(`scripts/checkpatch.pl` should have found this.)

> is handled asynchronously. This approach speeds up the overall startup time
> and ultimately ensures the selection of an optimal algorithm.

It’d be great if you shared the test system and exact numbers, and new 
log messages.

Is there any problem with the benchmark, if it is run asynchronously, 
because other things are run on the CPU?

If you are working on this, I was wondering if the current approach of 
selecting the algorithm during each boot is the best choice, and if it 
shouldn’t be dynamically configurable like schedulers and other things 
over sysfs and the Linux kernel command line, and also if the chosen 
algorithm can’t be cached as long as – I guess – the processor/CPU stays 
the same.

> Signed-off-by: sunliming <sunliming@kylinos.cn>

(Ditto regarding the name.)


Kind regards,

Paul


> ---
>   lib/raid6/algos.c | 30 ++++++++++++++++++++----------
>   1 file changed, 20 insertions(+), 10 deletions(-)
> 
> diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
> index c21e3ad99d97..b8b5515ac7a6 100644
> --- a/lib/raid6/algos.c
> +++ b/lib/raid6/algos.c
> @@ -12,6 +12,7 @@
>    */
>   
>   #include <linux/raid/pq.h>
> +#include <linux/workqueue.h>
>   #ifndef __KERNEL__
>   #include <sys/mman.h>
>   #include <stdio.h>
> @@ -166,7 +167,7 @@ static inline int raid6_choose_gen_fast(void)
>   
>   	if (best) {
>   		raid6_call = *best;
> -		pr_info("raid6: skipped pq benchmark and selected %s\n",
> +		pr_info("raid6: raid6: fast selected %s, async benchmark pending\n",
>   				best->name);
>   	} else {
>   		pr_err("raid6: No valid algorithm found even for fast selection!\n");
> @@ -213,7 +214,7 @@ static inline const struct raid6_calls *raid6_gen_benchmark(
>   	}
>   
>   	if (!best) {
> -		pr_err("raid6: Yikes! No algorithm found!\n");
> +		pr_warn("raid6: async benchmark failed to find any algorithm\n");
>   		goto out;
>   	}
>   
> @@ -289,24 +290,33 @@ static int raid6_choose_gen_benmark(void)
>   	return ret;
>   }
>   
> +static struct work_struct raid6_benchmark_work;
> +
> +static void benchmark_work_func(struct work_struct *work)
> +{
> +	raid6_choose_gen_benmark();
> +}
> +
>   int __init raid6_select_algo(void)
>   {
>   	int ret = 0;
>   	const struct raid6_recov_calls *rec_best = NULL;
>   
> -	/* select raid gen_syndrome functions */
> -	if (!IS_ENABLED(CONFIG_RAID6_PQ_BENCHMARK))
> -		ret = raid6_choose_gen_fast();
> -	else
> -		ret = raid6_choose_gen_benmark();
> -
> +	/* phase 1: synchronous fast selection generation algorithm */
> +	ret = raid6_choose_gen_fast();
>   	if (ret < 0)
>   		goto out;
>   
>   	/* select raid recover functions */
>   	rec_best = raid6_choose_recov();
> -	if (!rec_best)
> +	if (!rec_best) {
>   		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	/* phase 2: asynchronous performance benchmarking */
> +	INIT_WORK(&raid6_benchmark_work, benchmark_work_func);
> +	schedule_work(&raid6_benchmark_work);
>   
>   out:
>   	return ret;
> @@ -314,7 +324,7 @@ int __init raid6_select_algo(void)
>   
>   static void raid6_exit(void)
>   {
> -	do { } while (0);
> +	cancel_work_sync(&raid6_benchmark_work);
>   }
>   
>   subsys_initcall(raid6_select_algo);

