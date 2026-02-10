Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0E7306B37;
	Tue, 10 Feb 2026 07:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770709821; cv=none; b=pNaDq8/sYuGfYqJ0FHkS/KjriepEXrj1TFYdde9/0nWcyvGbtvA+/c3X6iPWSYEvt5bZN2w/DTAaL0tAYXj5+gKcEmtsjZ9YAyrYD33j2+eku/Ewdhuffs0aCqQ30RMSyvAtbTMxk92Jx85xpOsxb+xKlkmkC9a/eVbpFyTyRsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770709821; c=relaxed/simple;
	bh=uIyhLYEVgmaCdary2LhxZc/yrDGjFYC2BX2DPwAb5SU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=PzDLvpqkfW+Zl2tODDfTYtInmypeEEw5Qm2i6UUv2aTqCDpHff0uSNaMygKrv5/dYPS860nC9wzaB/WA3B/NZj6dDXsrhdnDOyxWO7kVIWUJIYfCHbODpnVZWTy70KBHsEf1UQ/DIMOYI+AiK0n1ofsynSQLYZ00UosJO09WlCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.192] (ip5f5af0ea.dynamic.kabel-deutschland.de [95.90.240.234])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id CB0044C4430C0E;
	Tue, 10 Feb 2026 08:49:53 +0100 (CET)
Message-ID: <420f4ae2-ce71-4a1f-b07d-787ce490bed7@molgen.mpg.de>
Date: Tue, 10 Feb 2026 08:49:52 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md: suppress spurious superblock update warning for
 dm-raid
To: chencheng@fnnas.com
References: <20260210124114.169207-1-chencheng@fnnas.com>
Content-Language: en-US
Cc: song@kernel.org, yukuai@fnnas.com, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20260210124114.169207-1-chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Chen,


Thank you for your patch.

Am 10.02.26 um 13:41 schrieb chencheng:
> dm-raid have external metadata management (mddev->external = 1) and
> no persistent superblock (mddev->persistent = 0). For these arrays,
> there's no superblock to update, so the warning is spurious.

Please paste the warning.

Please also add a Fixes: tag.

> Signed-off-by: chencheng <chencheng@fnnas.com>

Would Chen Cheng be the official (transcribed) spelling of your name. If 
you yes, it’d be great, if you updated it:

     git config --global user.name "Chen Cheng"
     git commit --amend -s --author="Chen Cheng <chencheng@fnnas.com>"

> ---
>   drivers/md/md.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 6d73f6e196a..e30b658641e 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2790,7 +2790,9 @@ void md_update_sb(struct mddev *mddev, int force_change)
>   	if (!md_is_rdwr(mddev)) {
>   		if (force_change)
>   			set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
> -		pr_err("%s: can't update sb for read-only array %s\n", __func__, mdname(mddev));
> +		if (!mddev_is_dm(mddev))
> +			pr_err_ratelimited("%s: can't update sb for read-only array %s\n",
> +					   __func__, mdname(mddev));

(It looks like it’s an error level message and not a warning level message.)

>   		return;
>   	}

With the commit message suggestions addressed, feel free to add:

Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul
