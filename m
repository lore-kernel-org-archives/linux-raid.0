Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3502B9B9
	for <linux-raid@vger.kernel.org>; Sun,  5 Oct 2025 17:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759685772; cv=none; b=U27OElSUmI2d+5ESdYBUVlDhm8hz0Ut4fNr7A9ix4LZwKLy2qf4kpw7t3okZivRlNtNEwfQ0BVmEcsEhQa7Wk+EnGZ1Kgk7x9QVwJCZ8Mpjr/cBp1gJ7RhKDcdpfLSqj+7cM9/PT6qYzBINqw5JzHgsj8RYnCF5FtqCqSUFBG+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759685772; c=relaxed/simple;
	bh=RrrTqir+n+mift3hsNCGTPZenm28ZY/U1LPgnT0A6cY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=c3AkIq+eTFiX+pxyxYNQnd5QZtpsmF4tS2jTLu/sRsQbigmEiYoYh3/lUFFCa5tDBmznVxV9v7q5fKeFG24g1fNK1xvZDFjnxOINpjFJPu8cctRFLQ8hOxVD17F43/gdR04mAkLuOhLTC+QLXvnvxEKCUpp7tv+UIuuGQJTXtu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [10.0.57.137] (unknown [62.214.191.67])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 7797A61E6484C;
	Sun, 05 Oct 2025 19:35:44 +0200 (CEST)
Message-ID: <ae9a4a36-5dd6-4d66-8b04-8d6f09494b7f@molgen.mpg.de>
Date: Sun, 5 Oct 2025 19:35:42 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md: don't add empty badblocks record table in
 super_1_load()
To: Coly Li <colyli@fnnas.com>
References: <20251005162159.25864-1-colyli@fnnas.com>
Content-Language: en-US
Cc: linux-raid@vger.kernel.org
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20251005162159.25864-1-colyli@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Coly,


Thank you for your patch.

Am 05.10.25 um 18:21 schrieb colyli@fnnas.com:
> From: Coly Li <colyli@fnnas.com>
> 
> In super_1_load() when badblocks table is loaded from component disk,
> current code adds all records including empty ones into in-memory
> badblocks table. Because empty record's sectors count is 0, calling
> badblocks_set() with parameter sectors=0 will return -EINVAL. This isn't
> expected behavior and adding a correct component disk into the array
> will incorrectly fail.
> 
> This patch fixes the issue by checking the badblock record before call-
> ing badblocks_set(). If this badblock record is empty (bb == 0), then
> skip this one and continue to try next bad record.

It’d be great if you added the commands to reproduce this.

> Signed-off-by: Coly Li <colyli@fnnas.com>
> ---
>   drivers/md/md.c | 11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 41c476b40c7a..b4b5799b4f9f 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1873,9 +1873,14 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
>   		bbp = (__le64 *)page_address(rdev->bb_page);
>   		rdev->badblocks.shift = sb->bblog_shift;
>   		for (i = 0 ; i < (sectors << (9-3)) ; i++, bbp++) {
> -			u64 bb = le64_to_cpu(*bbp);
> -			int count = bb & (0x3ff);
> -			u64 sector = bb >> 10;
> +			u64 bb, sector;
> +			int count;
> +
> +			bb = le64_to_cpu(*bbp);
> +			if (bb == 0)
> +				continue;
> +			count = bb & (0x3ff);
> +			sector = bb >> 10;
>   			sector <<= sb->bblog_shift;
>   			count <<= sb->bblog_shift;
>   			if (bb + 1 == 0)

Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul
