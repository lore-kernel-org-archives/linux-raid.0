Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807552586E8;
	Fri, 29 Aug 2025 07:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756451142; cv=none; b=eq3p9py/U4LOGYCA0dB0n71dshcFi+bRZghAjlz+z9gvO9CjPJD03pXwcljNBnNfAlSWIVTQ/aJ7af/Qzcvy4q86EEYloXIOHPNVa09SYFZZ5Q/0OBxjZzHJjBJQoZbbrgs/OWhepxYf3Tfy+dkS7O8kIoTf2cLo3g771ZjMbnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756451142; c=relaxed/simple;
	bh=kDP21w3A+Z3cfPBamzVxmKC8I69mxY7D9dP4oF2OuZo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uwVKrHWnAltnbSV6KiE2GN3t4DdpJQ+5p9w8y8cmnGhqIvJRgTMWBKI/uNTa7LEhuqHgse0XjS1lfoDDjX2DJfDJBP/c2VVICltLIUavB3DNjk7iAf1qPMAWt1xo3pssmiS3wGIeUQArwU88jj7k7r/rYOJqdtJzUZG9WO2C1hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.192] (ip5f5af7a9.dynamic.kabel-deutschland.de [95.90.247.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id E57786020198E;
	Fri, 29 Aug 2025 09:05:12 +0200 (CEST)
Message-ID: <4f5090da-55a0-400b-b2d6-1b8234d9e5b5@molgen.mpg.de>
Date: Fri, 29 Aug 2025 09:05:12 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] md/raid0: Use str_plural() to simplify the code
To: Xichao Zhao <zhao.xichao@vivo.com>
Cc: song@kernel.org, yukuai3@huawei.com, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250829065835.531330-1-zhao.xichao@vivo.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20250829065835.531330-1-zhao.xichao@vivo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Xichao,


Thank you for your patch.


Am 29.08.25 um 08:58 schrieb Xichao Zhao:
> Use the string choice helper function str_plural() to simplify the code.
> 
> Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
> ---
> v2:
>    - correct the subject of the v1 version patch.
> v1: https://lore.kernel.org/all/20250828112714.633108-1-zhao.xichao@vivo.com/
> ---
>   drivers/md/raid0.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index cbe2a9054cb9..a2e59a8d441f 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -41,7 +41,7 @@ static void dump_zones(struct mddev *mddev)
>   	int raid_disks = conf->strip_zone[0].nb_dev;
>   	pr_debug("md: RAID0 configuration for %s - %d zone%s\n",
>   		 mdname(mddev),
> -		 conf->nr_strip_zones, conf->nr_strip_zones==1?"":"s");
> +		 conf->nr_strip_zones, str_plural(conf->nr_strip_zones));
>   	for (j = 0; j < conf->nr_strip_zones; j++) {
>   		char line[200];
>   		int len = 0;

I guess some will debate, whether this helper is an improvement or not, 
especially as the helper implementation has no advantage. But as it’s 
under `include/`, why not use it. I see the only advantage, that it 
denotes some kind of semantic meaning.

Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul
