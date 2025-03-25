Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2DB1E522;
	Tue, 25 Mar 2025 11:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742903233; cv=none; b=eJeS3+3Z7ikn5ExkXCe13JqJTB+ejwvwnTJdA64eA3OaKBsgmWlrXerOk1l+qfd8Rovnr10+QIst4uDSWiEfR9QDQdPgftVfNAVUZKnQNmDuvsNarGtZ/7PSeIVmnUUI9dRuTz++GLBqmYhEiI2ulu/+sufFtZueJS4NrfQB28A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742903233; c=relaxed/simple;
	bh=XLp0TvOqsckFvhuTAuciwZwlKcCPC6apjRmY0eX+T0M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=elcma7STIgGZEU3tFL+G3tkBljv/jy7jhYTb4bH+k8KU7GBx5AZIMHH1hrjfnrHtuZI6I/RayJQoTvzHUggJFMO2K/wOpZ4+eN4dFIpuhA6HqMYuepLYlo1NU54fCWDEHW4o+nP+jkwkIpBv0dp+o8kvryrpGJ2NObqUkBHhzng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gksLvXmA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gksLvXmA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55EF2C4CEEE;
	Tue, 25 Mar 2025 11:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742903232;
	bh=XLp0TvOqsckFvhuTAuciwZwlKcCPC6apjRmY0eX+T0M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gksLvXmASdLOBVu0QQ1Uk79j3hAi8JiaFbt0kBP6WspeyrE67hKb3LXvgSVhQpC4O
	 uYhs7PzgtPOH6b/AuMhmHQx+2fNxp29O4q0nKA8ADjHD/F7hJmBWmS7iJt3qoBwTCs
	 D4LdGMOcqHYzSgKG++K27zj2CGInKU8WolpeIx5h399spLYPqzAzKjNAA6e4qjqnyu
	 Ugb323WWjEG/8ISzk5spqADvwA5Hp2hfSiSmGymd7kWOOhhosh+bTnqQUjcgmgjL8Q
	 4UUoP09BI2q4dXGslJgOvI1GSYBS5AxKocHJdelDsVXkadGRLOxxlz/Qkl7tla2CzC
	 rMZPE+OWHwnig==
Date: Tue, 25 Mar 2025 19:47:07 +0800
From: Coly Li <colyli@kernel.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, yukuai3@huawei.com, jgq516@gmail.com, 
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, 
	yangerkun@huawei.com
Subject: Re: [PATCH] md/raid10: fix missing discard IO accounting
Message-ID: <dn5n5g7mo5bwiw5qgbxcvryjw3b3yz3lnukrfpsnmzpvykqpvh@73w6yfprtzkj>
References: <20250325015746.3195035-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250325015746.3195035-1-yukuai1@huaweicloud.com>

On Tue, Mar 25, 2025 at 09:57:46AM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> md_account_bio() is not called from raid10_handle_discard(), now that we
> handle bitmap inside md_account_bio(), also fix missing
> bitmap_startwrite for discard.
> 
> Test whole disk discard for 20G raid10:
> 
> Before:
> Device   d/s     dMB/s   drqm/s  %drqm d_await dareq-sz
> md0    48.00     16.00     0.00   0.00    5.42   341.33
> 
> After:
> Device   d/s     dMB/s   drqm/s  %drqm d_await dareq-sz
> md0    68.00  20462.00     0.00   0.00    2.65 308133.65
> 
> Fixes: 528bc2cf2fcc ("md/raid10: enable io accounting")
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>


Acked-by: Coly Li <colyli@kernel.org>

Thanks.

> ---
>  drivers/md/raid10.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 9d8516acf2fd..6ef65b4d1093 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1735,6 +1735,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
>  	 * The discard bio returns only first r10bio finishes
>  	 */
>  	if (first_copy) {
> +		md_account_bio(mddev, &bio);
>  		r10_bio->master_bio = bio;
>  		set_bit(R10BIO_Discard, &r10_bio->state);
>  		first_copy = false;
> -- 
> 2.39.2
> 
> 

-- 
Coly Li
