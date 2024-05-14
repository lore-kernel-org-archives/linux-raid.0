Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4DE3EA9B
	for <linux-raid@vger.kernel.org>; Tue, 14 May 2024 09:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715678279; cv=none; b=Ih6Z4t5km/fHzt9QhsJ/Z5h0U5bE+wBLyLdgkR0x6o7Sxd7LlLImAISfVOGWbHNeR7VUlijXSZqgBNT22Ht6fcGyLt4PnITqKXhUnUY66kCKrNssLO209K+YLFeJ7Q+HXRdQ4qqz9Z7sQjVVWjj3fO4i5LFAQJelefiKUVibNME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715678279; c=relaxed/simple;
	bh=S7xc2UmDEAUgDjRjQLg0rNQww93cc6nHbAqBffrVARc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JUV10R9My6Fu0RlQtw4urdAYF1qT/Bb6esNnbCHhRS/hdq1Q6KPJRkHPGxQuNKMstuDgMATfb3yPzVWC6u5EwAYarnyfmDw/MbmTpk6YuChlSgcOSw8R+N8UlrHFBIE/LhjSR3V8OrDGnlLUe32M6M0ZS4LPPvlwp/wCHFHGa0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [141.14.220.56] (g56.guest.molgen.mpg.de [141.14.220.56])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id D4D3061E5FE06;
	Tue, 14 May 2024 11:17:16 +0200 (CEST)
Message-ID: <fcae76b9-32e5-40f4-b3d4-f927ef28aea3@molgen.mpg.de>
Date: Tue, 14 May 2024 11:17:16 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] Wait for mdmon when it is stared via systemd
To: Kinga Stefaniuk <kinga.stefaniuk@intel.com>
Cc: linux-raid@vger.kernel.org, jes@trained-monkey.org,
 mariusz.tkaczyk@linux.intel.com
References: <20240507033856.2195-1-kinga.stefaniuk@intel.com>
 <20240507033856.2195-3-kinga.stefaniuk@intel.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20240507033856.2195-3-kinga.stefaniuk@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Kinga,


Thank you for the patch. There is a small typo in the summary: star*t*ed.

Am 07.05.24 um 05:38 schrieb Kinga Stefaniuk:
> When mdmon is being started it may need few seconds to start.
> For now, we didn't wait for it. Introduce wait_for_mdmon()
> function, which waits up to 5 seconds for mdmon to start completely.
> 
> Signed-off-by: Kinga Stefaniuk <kinga.stefaniuk@intel.com>
> ---
>   Assemble.c |  4 ++--
>   Grow.c     |  7 ++++---
>   mdadm.h    |  2 ++
>   util.c     | 29 +++++++++++++++++++++++++++++
>   4 files changed, 37 insertions(+), 5 deletions(-)
> 
> diff --git a/Assemble.c b/Assemble.c
> index f6c5b99e25e2..9cb1747df0a3 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -2175,8 +2175,8 @@ int assemble_container_content(struct supertype *st, int mdfd,
>   			if (!mdmon_running(st->container_devnm))
>   				start_mdmon(st->container_devnm);
>   			ping_monitor(st->container_devnm);
> -			if (mdmon_running(st->container_devnm) &&
> -			    st->update_tail == NULL)
> +			if (wait_for_mdmon(st->container_devnm) == MDADM_STATUS_SUCCESS &&
> +			    !st->update_tail)
>   				st->update_tail = &st->updates;
>   		}
>   
> diff --git a/Grow.c b/Grow.c
> index 074f19956e17..0e44fae4891e 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -2085,7 +2085,7 @@ int Grow_reshape(char *devname, int fd,
>   			if (!mdmon_running(st->container_devnm))
>   				start_mdmon(st->container_devnm);
>   			ping_monitor(container);
> -			if (mdmon_running(st->container_devnm) == false) {
> +			if (wait_for_mdmon(st->container_devnm) != MDADM_STATUS_SUCCESS) {
>   				pr_err("No mdmon found. Grow cannot continue.\n");
>   				goto release;
>   			}
> @@ -3176,7 +3176,8 @@ static int reshape_array(char *container, int fd, char *devname,
>   			if (!mdmon_running(container))
>   				start_mdmon(container);
>   			ping_monitor(container);
> -			if (mdmon_running(container) && st->update_tail == NULL)
> +			if (wait_for_mdmon(container) == MDADM_STATUS_SUCCESS &&
> +			    !st->update_tail)
>   				st->update_tail = &st->updates;
>   		}
>   	}
> @@ -5140,7 +5141,7 @@ int Grow_continue_command(char *devname, int fd,
>   			start_mdmon(container);
>   		ping_monitor(container);
>   
> -		if (mdmon_running(container) == false) {
> +		if (wait_for_mdmon(container) != MDADM_STATUS_SUCCESS) {
>   			pr_err("No mdmon found. Grow cannot continue.\n");
>   			ret_val = 1;
>   			goto Grow_continue_command_exit;
> diff --git a/mdadm.h b/mdadm.h
> index af4c484afdf7..9b8fb3f6f8d8 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -1769,6 +1769,8 @@ extern struct superswitch *version_to_superswitch(char *vers);
>   
>   extern int mdmon_running(const char *devnm);
>   extern int mdmon_pid(const char *devnm);
> +extern mdadm_status_t wait_for_mdmon(const char *devnm);
> +
>   extern int check_env(char *name);
>   extern __u32 random32(void);
>   extern void random_uuid(__u8 *buf);
> diff --git a/util.c b/util.c
> index 65056a19e2cd..df12cf2bb2b1 100644
> --- a/util.c
> +++ b/util.c
> @@ -1921,6 +1921,35 @@ int mdmon_running(const char *devnm)
>   	return 0;
>   }
>   
> +/*
> + * wait_for_mdmon() - Waits for mdmon within specified time.
> + * @devnm: Device for which mdmon should start.
> + *
> + * Function waits for mdmon to start. It may need few seconds
> + * to start, we set timeout to 5, it should be sufficient.
> + * Do not wait if mdmon has been started.
> + *
> + * Return: MDADM_STATUS_SUCCESS if mdmon is running, error code otherwise.
> + */
> +mdadm_status_t wait_for_mdmon(const char *devnm)
> +{
> +	const time_t mdmon_timeout = 5;
> +	time_t start_time = time(0);
> +
> +	if (mdmon_running(devnm))
> +		return MDADM_STATUS_SUCCESS;
> +
> +	pr_info("Waiting for mdmon to start\n");
> +	while (time(0) - start_time < mdmon_timeout) {
> +		sleep_for(0, MSEC_TO_NSEC(200), true);
> +		if (mdmon_running(devnm))
> +			return MDADM_STATUS_SUCCESS;
> +	};
> +
> +	pr_err("Timeout waiting for mdmon\n");

Please print the timeout limit.

> +	return MDADM_STATUS_ERROR;
> +}
> +
>   int start_mdmon(char *devnm)
>   {
>   	int i;

Doesn’t systemd have some interface sd_ on how to notify about a 
successful start?


Kind nregards,

Paul
