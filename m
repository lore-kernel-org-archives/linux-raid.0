Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3B3204698
	for <linux-raid@vger.kernel.org>; Thu,  6 Mar 2025 12:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741263860; cv=none; b=LekE/kJ0Dhj/5oIrz58pvH4xws0ETk9vyLennq5b3/iGk1l/9kJdL85PzZKH2ux7/oJfo+gEa9QYWrXzzAE2i+rEeZ4ZUWmF0xUaPrUiqY5X2tkowLhTA8VPab2hf25AOiBIiomwDi6Tjm6MWwE3z8Cuso5utRXhlqltJlp4uF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741263860; c=relaxed/simple;
	bh=Blq3zsE+yVjzaMO8SgouuPmN/ZeLmtCcpd+rNL68M20=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SLC3l+ti0WuTUWTly3A+ijzt3P6vSTGlu1lp855vFEJhu/3isemKeSpL+UQFLrPailnwLKqNkrzTNT/yWso/XassiGi0+YkloSP7YTIjQQpibBo8fDxVH4iZcTM5W22EinKOs1Ve5YdeAj8Yw7OOYk8A8KKu3g9lazYzer3+68I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=thFGIZNl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="thFGIZNl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DBAAC4CEE0;
	Thu,  6 Mar 2025 12:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741263859;
	bh=Blq3zsE+yVjzaMO8SgouuPmN/ZeLmtCcpd+rNL68M20=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=thFGIZNldMiZZmL8Hg3kAX0Gd3LunyUICTrM9f0HTvl7nS/DEFYVwU2SYVpLiNIQX
	 TcUIVBzYm3D633ZwbBkxddyZUtuDSL0T0kBl6dIql7mfEGW0hSgfIflgx19qkMURja
	 VqWdKh8NfGyVL0eIfIaDSlM5ts/Lob6Kd+Wgm9zov6DfaIMBlOMxXUWAdPiO2dgub3
	 zto47huBdAg69mGEuqeLE5TeNe3vAei28BWNwCDlie2RHHg92Sl7cExyX0UvT4uKA/
	 lSCku5bq4+Gbtq5lfFN48SZs2E3S77kNkKV/RqGBtNIHsCC41CC/IVzoPoF4iMwuX8
	 ygLYXnWhsGvZA==
Date: Thu, 6 Mar 2025 20:24:15 +0800
From: Coly Li <colyli@kernel.org>
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, yukuai1@huaweicloud.com, song@kernel.org, 
	pmenzel@molgen.mpg.de
Subject: Re: [PATCH md-6.15 V2 1/1] md/raid10: wait barrier before returning
 discard request with REQ_NOWAIT
Message-ID: <ft75ic2orxb73ywrgwq762ajwz2gb2zxcxsian24ugf46qfuuz@cj5mtsgv2she>
References: <20250306094938.48952-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250306094938.48952-1-xni@redhat.com>

On Thu, Mar 06, 2025 at 05:49:38PM +0800, Xiao Ni wrote:
> raid10_handle_discard should wait barrier before returning a discard bio
> which has REQ_NOWAIT. And there is no need to print warning calltrace
> if a discard bio has REQ_NOWAIT flag. Quality engineer usually checks
> dmesg and reports error if dmesg has warning/error calltrace.
> 
> Fixes: c9aa889b035f ("md: raid10 add nowait support")
> Signed-off-by: Xiao Ni <xni@redhat.com>

Acked-by: Coly Li <colyli@kernel.org>

Thanks.

> ---
> v2: add target version in title and add Fixes tag
>  drivers/md/raid10.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 15b9ae5bf84d..7bbc04522f26 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1631,11 +1631,10 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
>  	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
>  		return -EAGAIN;
>  
> -	if (WARN_ON_ONCE(bio->bi_opf & REQ_NOWAIT)) {
> +	if (!wait_barrier(conf, bio->bi_opf & REQ_NOWAIT)) {
>  		bio_wouldblock_error(bio);
>  		return 0;
>  	}
> -	wait_barrier(conf, false);
>  
>  	/*
>  	 * Check reshape again to avoid reshape happens after checking
> -- 
> 2.32.0 (Apple Git-132)
> 
> 

-- 
Coly Li
