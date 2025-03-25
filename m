Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE311714A1;
	Tue, 25 Mar 2025 07:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742886284; cv=none; b=LoZvOAZBe5B0aW8PzPodQPearpe5pS3y1oRvIsLsfogqZ6/5+j16kJRkdw45kYttCkBilBwRYYvWHvrqSi4pCjdnJx74H+/ksXiZpu3DR/x/5bGgV1N+PU7+fTTOQ4bv/e3IAMYSA2fye310NgqUTemItwOn91AO6ofEJ+Jaykc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742886284; c=relaxed/simple;
	bh=31zbionqiWdB+efJdLuZ5Isy/glxu/5NOnadKIM/c5s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PeSGXce10HrdpsGlExHQwUe3nT0rmLMoZbMzj/FKchJrZPJa64O1H0rYm+xqBq2B71lsGENkIpl4XElsC9azeaLsOc+sYPvVLT+vlhNU0rJAGcFe9tf4sannCvSO0esxebVmcw6GFuPfpkFcNXaVR3czKGylakbUT/VgNvsgbmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M/0T9i1Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M/0T9i1Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57C1C4CEE8;
	Tue, 25 Mar 2025 07:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742886282;
	bh=31zbionqiWdB+efJdLuZ5Isy/glxu/5NOnadKIM/c5s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M/0T9i1Q0v6KVDxN7Vdw3Ye1YADlJGjQBJ/vwmmMixzgv41whxjjHzuLK5DGyPFAA
	 R/RoSBKYz6LG8AYHCy8orhf2KCY3gfXYjekiK+udtyh5KMHPyrs/t8LgMR4CnZPgno
	 hmjuDR3KmPTKYUx+tfJKH9cmMB+RRIbwX34xvEjS7a1hyd3ucwGowrBXD4H50NakMn
	 zCEVsKa/jnQWxvRfNeLKF/ZTw7zebaL7rwb2sD7TpKZ5ukCX93SlaMEb3aqSatK7lT
	 6ZuzVfJfV+LyioggEmDqyC/X9wjhM+3UMDsoCFOrSpOUeIXjBKZXcC266Yje+6KApz
	 Y2jUbEGzsFsRA==
Date: Tue, 25 Mar 2025 15:04:36 +0800
From: Coly Li <colyli@kernel.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, yukuai3@huawei.com, jgq516@gmail.com, 
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, 
	yangerkun@huawei.com
Subject: Re: [PATCH] md/raid10: fix missing discard IO accounting
Message-ID: <brtjiiejckcekwq4racmjgpzq7dod5bg2t4csj7caevnl4pkqm@zaanpogvtvus>
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

Should we treat discard request as real I/O?

Normally IMHO discard request should not be counted as real data transfer,
correct me if I am wrong.

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
