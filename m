Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F4A35970
	for <linux-raid@vger.kernel.org>; Mon,  5 May 2025 15:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746460046; cv=none; b=YkNmZ1632ymc9x0lNHkSt+00ED024xmxmXNrffdQQN3J7mBuiJCVb6RFXeGQfsdU2p/Pu2eAef9+v/6SAJNgxuN0XfoJGiYv+Sa/gNpJaWMJZXFiF37NsL5uh8cn3VsPZfPAseiOmOifDKymbypfIjDotxut12xbtvp59OaZ8vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746460046; c=relaxed/simple;
	bh=LWVs2Nabud6Iuu1aRNyeePADFfH0UcFWLcbOQsobre0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jiozOSbIm4TNfDiqv65PlhwrFWXdM/enXXtpRiExXRNoEc4VG+DHqAksXcfGQtPpKOtykNXQ1pfRWrUuqmXoqnsXKEWcaLsmP7Xj+VDBnbpncxuwvsLd/Qxb/G/lzeiW/81SxkA6PuuLZra5YQP0hxek0A5GAbSgEnXikhoDntE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=owb9K4DN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="owb9K4DN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FF4C4CEE4;
	Mon,  5 May 2025 15:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746460045;
	bh=LWVs2Nabud6Iuu1aRNyeePADFfH0UcFWLcbOQsobre0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=owb9K4DNgXT8cqVU2UKMKPwGrNQYaQpwGRMOYACH4TlvFwt8b1Fzl+R4YstbndSAN
	 g988IWh1+Y3clEMKhtJg1hI7UuVLkDOMuRS+rPCkD84zTPP5/YlWRV3cUlJwYCQ0bK
	 xNmtkYs/kDnK6qQC9gqdrJFYbWjxqeAa+5YlVMqO/FrbiQzyQikrGsl8nEBPx8P12A
	 QezdJWtqGN1h7MjoRXfgj9HtqTkYCPq+M+tiHIkC4Qh+WnRAj8ACgg45zEdXxgbi+O
	 e9Lqa+8e5fFPa8Iq93ScQQ3AkMCW4TWobD23Kz2TCqPACa9o7kPN9aLCQOhSuba40T
	 OY80jOKBj85TA==
Date: Mon, 5 May 2025 23:47:18 +0800
From: Coly Li <colyli@kernel.org>
To: linux-raid@vger.kernel.org
Cc: Logan Gunthorpe <logang@deltatee.com>, Yu Kuai <yukuai3@huawei.com>, 
	Xiao Ni <xni@redhat.com>, Song Liu <song@kernel.org>
Subject: Re: [RFC PATCH] fix a reshape checking logic inside
 make_stripe_request()
Message-ID: <fgqrzhv5mbmrusocjkeybja6leaeeoi2r4hwihphi4lni2w3xg@meakhkiyuiab>
References: <20250505152831.5418-1-colyli@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250505152831.5418-1-colyli@kernel.org>

On Mon, May 05, 2025 at 11:28:31PM +0800, colyli@kernel.org wrote:
> From: Coly Li <colyli@kernel.org>
> 
> Commit f4aec6a09738 ("md/raid5: Factor out helper from
> raid5_make_request() loop") added the following code block to check

After read historical commits, I realize the change was from
commit 486f60558607 ("md/raid5: Check all disks in a stripe_head for
reshape progress").

> whether the reshape range passed the stripe head range during thetime to
> wait for a valid struct stripe_head object,
> 
> 5971         if (unlikely(previous) &&
> 5972             stripe_ahead_of_reshape(mddev, conf, sh)) {
> 5973                 /*
> 5974                  * Expansion moved on while waiting for a stripe.
> 5975                  * Expansion could still move past after this
> 5976                  * test, but as we are holding a reference to
> 5977                  * 'sh', we know that if that happens,
> 5978                  *  STRIPE_EXPANDING will get set and the expansion
> 5979                  * won't proceed until we finish with the stripe.
> 5980                  */
> 5981                 ret = STRIPE_SCHEDULE_AND_RETRY;
> 5982                 goto out_release;
> 5983         }
> 
> But from the code comments and context, the if statement should check
> whether stripe_ahead_of_reshape() returns false, then the code logic can
> match the context that reshape range went accross the sh range during
> raid5_get_active_stripe().

And the code logic might be correct, because inside
stripe_ahead_of_reshape(),
5788         if (!range_ahead_of_reshape(mddev, min_sector, max_sector,
5789                                      conf->reshape_progress))
5790                 /* mismatch, need to try again */
5791                 ret = true;

true is returned when the sh range is NOT ahead of reshape position.

Then the logic makes sense, but the function name stripe_ahead_of_reshape()
is really misleading IMHO. Maybe it should be named something like
stripe_behind_reshape()?

Should we change the name? Or I missed something important and still don't
understand the code correctly?

> 
> And unlikely(previous) seems useless inside the if statement, and the
> unlikely() should include all checking statemetns.
> 

This part still valid IMHO.

Thanks for comments.

> This patch has both of the above changes, hope it can make the code be
> more comfortable.
> 
> Fixes: f4aec6a09738 ("md/raid5: Factor out helper from raid5_make_request() loop")
> Signed-off-by: Coly Li <colyli@kernel.org>
> Cc: Logan Gunthorpe <logang@deltatee.com>
> Cc: Yu Kuai <yukuai3@huawei.com>
> Cc: Xiao Ni <xni@redhat.com>
> Cc: Song Liu <song@kernel.org>
> ---
>  drivers/md/raid5.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 39e7596e78c0..030e4672ab18 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5969,8 +5969,7 @@ static enum stripe_result make_stripe_request(struct mddev *mddev,
>  		return STRIPE_FAIL;
>  	}
>  
> -	if (unlikely(previous) &&
> -	    stripe_ahead_of_reshape(mddev, conf, sh)) {
> +	if (unlikely(previous && !stripe_ahead_of_reshape(mddev, conf, sh))) {
>  		/*
>  		 * Expansion moved on while waiting for a stripe.
>  		 * Expansion could still move past after this
> -- 
> 2.39.5
> 

-- 
Coly Li
