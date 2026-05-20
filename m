Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69E83D76
	for <linux-raid@vger.kernel.org>; Wed, 20 May 2026 13:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779282028; cv=none; b=IegtZBDHDRNMAK7hoJtioJBuKQi5xvihpv8wX0fwvn2vqKNTx4Oy7vrnAtpSkZAa3N92E6FSjBo24SeMG/2NFfLeEP1Q0nKdzHAjyyf5GC+R2JTnAth2yDEh0roi3a3UzLj9jXRgrXTtF4oGJksEsY1Xq8VR9qkB+oMfyuQJOUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779282028; c=relaxed/simple;
	bh=yC7d2+7mmczzqAaA3iSgC5WYrl3+G5bH2ZE9/gsmyck=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UEdgw19pTQf6spefluYs3xAtGUtJY710A2hX801fePZFJm/f5ACkdd68uWgKoa4O5UVkV3cnDaKlGKJHYyWYwD9pM3l8LlCntDkGMhZcTPstU71NgAK/gejLeQqgBMi2RmQwVusG8nyRILn6dEjejlIN8Cn96ZpEO5vYTKKAUZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ntjLy5nk; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ntjLy5nk"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-48fde648a71so35627855e9.0
        for <linux-raid@vger.kernel.org>; Wed, 20 May 2026 06:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779282025; x=1779886825; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VBgKpCt1/7Dv0saCawyTFbR0vQ6ctxhe2NKjIH0ysvE=;
        b=ntjLy5nk3+7qXUn+gdYzFwLA76EJBpiV0hC58PDAhT8F+RLtHbMPtzYM9tQRBVAqVV
         YBBRCcX78JGZAqk9Q1aBjyPf6tSd8YpopX1ZAIjJC7kpi4nClGTO5muTLNoSMoBikArj
         AQql3s0dX4sdqWQNbZJ9zkWERTHAA3jM9QySq8ahKSANmlDg42/HZbd4eTOUj/FBH31p
         kPs6BAhhWXNOMYY8sIUaUPVe1FljAs1/Eg3KG6nXdrJohkeQ9c+XRtGJ/NSU1DEDtZqz
         gjoyKXEXPLDIeMci41y4kkb3rMcpHjCjULl11awTu1YSUMNMjkJVMRfvyCmJ9hmoZRal
         ZUcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779282025; x=1779886825;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VBgKpCt1/7Dv0saCawyTFbR0vQ6ctxhe2NKjIH0ysvE=;
        b=jeEX/pLKjpkuJTrgGtBgL8Jr77XpLyGZkVcPQfoxm6kLsqujLRRutWzrcGrLOCkuyP
         CF+rqBAmEZtgvTpMmG0J9obO3K9DbbJWkenDePZmUtEty1glDDIE0J7wC3Csv7rhgMxT
         bdFf082UUrSy+BBwg5PqKmVvkdeXsVL8JVZ9UgK9xmidow3a7+heJUmGLG1VwbcWutpS
         MqET9Kx3j2xthzpgT1nRX9XQi4auTBjpJoor9bUR/WfUc80gXELWw8kzMI4gsAqq1QFx
         dzhJvCyivd/atwyo+cCI4oN4ObRdl9tyPbHnhvzR1NhkWaQ8bRma3M8DfDeCe8oPfkTj
         u1yQ==
X-Forwarded-Encrypted: i=1; AFNElJ9qgBJKc6oWnX16xzRg6MOW4A1CJmvU8j2jYqWki+996jQ/rDgqjm5M3Ab4m2pJSNQYZQcHuUUQa0A/@vger.kernel.org
X-Gm-Message-State: AOJu0YxmzUSgZdbC5AGThS66B7FY+0WmvQiizj0Q6p7g3RbCAqkeIzfS
	5vr+zT+v4fOfjNXEjbZt1jSVJgwBaHQanruAx2TOzOdFsJWzt+/McWU/
X-Gm-Gg: Acq92OHxb6U1C/C1V+fPNXl0DlJVW6n6vE19R3Utbvs8c2UbEkVkoBtB0xZStLFtXgr
	9rJ/WJNRE1Ci9bGnEG0DpVxoSEg2jsh/xRtwXUgkWqci5INkO5I39WJkRrSQC3Et8NLCOq+TSqJ
	LI5nV+Kyb9+cmv9XUu0v9zWbiXmrQJ2khLPeozC8KZonw+zxONlgNQPMSh09+Omprq61EeDQhtt
	HsAOXmWSqvp2CKoxdC2EIZb0y5SKzdvXQo2O7eFBrKeOG/CJ2lrHyTSAwZFALUDzfmsexsRxWuQ
	sQwjIaScu3oKtvQ/w19UUskYFzrnK5kdfvRj8kjohR9TZkkJvDWLtJwzS6NbJ5kzbpPztT15BQ0
	thRPqCNUt+Rv3U3V+YuKccYtkmujEihCcdYuTx6HxxO5x3ls2afb2MOHopm7wkHfPYyh+xonrSH
	uGhl7K9gs42g2M4XhKeVSpREDxXoLrPhfGUa6HHXFRkiPkbqtP7MG44gjXSusC4gyW
X-Received: by 2002:a05:600c:83c7:b0:48f:e230:29f5 with SMTP id 5b1f17b1804b1-48fe53a8eccmr362118815e9.16.1779282023422;
        Wed, 20 May 2026 06:00:23 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe53804aesm376693965e9.15.2026.05.20.06.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 06:00:23 -0700 (PDT)
Date: Wed, 20 May 2026 14:00:21 +0100
From: David Laight <david.laight.linux@gmail.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>, Li Nan
 <linan122@huawei.com>, Xiao Ni <xiao@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-raid@vger.kernel.org
Subject: Re: [PATCH 1/2] lib/raid: use kmalloc() in calibrate_xor_blocks()
Message-ID: <20260520140021.1d36c0b4@pumpkin>
In-Reply-To: <20260520-lib-v1-1-cb3045bef2d8@kernel.org>
References: <20260520-lib-v1-0-cb3045bef2d8@kernel.org>
	<20260520-lib-v1-1-cb3045bef2d8@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 20 May 2026 11:17:51 +0300
"Mike Rapoport (Microsoft)" <rppt@kernel.org> wrote:

> The xor benchmark allocates an order 2 (4 pages) scratch buffer that is
> used purely as a CPU-only XOR working area.
> 
> For such large allocations kmalloc() would fall back to alloc_pages() but
> still kmalloc() is a better API as it does not require unnecessary
> castings and may provide more debugging possibilities.
> 
> Replace __get_free_pages() call with kmalloc().

You might want to use kvalloc() here.
It is less likely to fail.

-- David

> 
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  lib/raid/xor/xor-core.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/raid/xor/xor-core.c b/lib/raid/xor/xor-core.c
> index bd4e6e434418..50931fbf0324 100644
> --- a/lib/raid/xor/xor-core.c
> +++ b/lib/raid/xor/xor-core.c
> @@ -8,6 +8,7 @@
>  
>  #include <linux/module.h>
>  #include <linux/gfp.h>
> +#include <linux/slab.h>
>  #include <linux/raid/xor.h>
>  #include <linux/jiffies.h>
>  #include <linux/preempt.h>
> @@ -114,7 +115,7 @@ static int __init calibrate_xor_blocks(void)
>  	if (forced_template)
>  		return 0;
>  
> -	b1 = (void *) __get_free_pages(GFP_KERNEL, 2);
> +	b1 = kmalloc(PAGE_SIZE * 4, GFP_KERNEL);
>  	if (!b1) {
>  		pr_warn("xor: Yikes!  No memory available.\n");
>  		return -ENOMEM;
> @@ -132,7 +133,7 @@ static int __init calibrate_xor_blocks(void)
>  	pr_info("xor: using function: %s (%d MB/sec)\n",
>  	       fastest->name, fastest->speed);
>  
> -	free_pages((unsigned long)b1, 2);
> +	kfree(b1);
>  	return 0;
>  }
>  
> 

