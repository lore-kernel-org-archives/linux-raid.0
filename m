Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF791C2DB0;
	Tue, 10 Dec 2024 16:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733847665; cv=none; b=cBgngLBfc40bG0DLcfWqmzAajOHTgjEohhwo4XEDcvEYKBKgk8H1+90iflQ4rQ0ulMOiTl+5wYVDKO/quhUnhC/EIdO684Yrg73h2xD63bWknirA+obMSmbLidAHUAqCgnQ7+4ujJeA1SPDOY66yu2aX2Iz2SWjx0wDebv5Bju4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733847665; c=relaxed/simple;
	bh=/tjE32TARFnM3qp++vZVKsPRMBVPqfRnvR/Aq73te3k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bKaQ/60RuRVxMpv7r+k0U6kp1iRSN5sdQV/Lf0r+eh5Nh0tRlUq9woZasaJbDyXzI+X8JARQS0/zMgVFlk9XnUhjon6wP7bvkihaIqvaeCiM/JWxtKibMom3ztAb2D9wPoIV2nZrzyWlugWBa2xE3Y80MiGhMs9/JHcykQ0PSPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZUzLO/XA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZUzLO/XA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1054DC4CEDD;
	Tue, 10 Dec 2024 16:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733847665;
	bh=/tjE32TARFnM3qp++vZVKsPRMBVPqfRnvR/Aq73te3k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZUzLO/XAWUnG3spslyUaxdemGuzRKgGn1gJj3G6w6DZHlycUmGAJkp5I1zyNmAA5N
	 r1kcaITSc2HYDUxTVBLK9C1z73aFCbD8X05hurJ5rKG55VNirBT7k9fNsnbDHObank
	 63l9dtutx5pmK9rMS1eSBb/Qy2C8RRhzFbt2uxXE+0ZpMTarvpN5GyJU8fRsKMtbwq
	 sct3vor4rDAdPk5GS1X44T6/7z7qhc6NZyvWrcI9x3pzsaO4OU4nrrVTTtNa4XkDnn
	 wwET3JO/DieUBMxPno0j2PwiY8sFtymw8aV35qjbV+lAb53uO9PIH32gIzsubJPKZU
	 SmwVlAniHV1yQ==
Date: Tue, 10 Dec 2024 11:21:03 -0500
From: Sasha Levin <sashal@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Yu Kuai <yukuai3@huawei.com>, Hannes Reinecke <hare@suse.de>,
	Jens Axboe <axboe@kernel.dk>, song@kernel.org,
	linux-raid@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.12 16/19] md/raid1: Handle bio_split() errors
Message-ID: <Z1hqbxa3PnQ86hs4@sashalap>
References: <20241124123912.3335344-1-sashal@kernel.org>
 <20241124123912.3335344-16-sashal@kernel.org>
 <77b6928d-020a-4df9-93b0-fef8ef38e891@oracle.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <77b6928d-020a-4df9-93b0-fef8ef38e891@oracle.com>

On Mon, Nov 25, 2024 at 08:55:19AM +0000, John Garry wrote:
>On 24/11/2024 12:38, Sasha Levin wrote:
>>From: John Garry<john.g.garry@oracle.com>
>>
>>[ Upstream commit b1a7ad8b5c4fa28325ee7b369a2d545d3e16ccde ]
>>
>>Add proper bio_split() error handling. For any error, call
>>raid_end_bio_io() and return.
>>
>>For the case of an in the write path, we need to undo the increment in
>>the rdev pending count and NULLify the r1_bio->bios[] pointers.
>>
>>For read path failure, we need to undo rdev pending count increment from
>>the earlier read_balance() call.
>>
>>Reviewed-by: Yu Kuai<yukuai3@huawei.com>
>>Reviewed-by: Hannes Reinecke<hare@suse.de>
>>Signed-off-by: John Garry<john.g.garry@oracle.com>
>>Link:https://urldefense.com/v3/__https://lore.kernel.org/ r/20241111112150.3756529-6-john.g.garry@oracle.com__;!!ACWV5N9M2RV99hQ! 
>>N4dieLgwxARnrFj9y51O80wHlzi_DtX0LRE- 
>>kw6X6c0oWji1y3NBy1HIbHaHEkfRZJ57mxEq0kY_YRAnPg$ Signed-off-by: Jens 
>>Axboe<axboe@kernel.dk>
>>Signed-off-by: Sasha Levin<sashal@kernel.org>
>
>I don't think that it is proper to backport this change without 
>bio_split() error handling update. And I don't think that it is worth 
>backporting the bio_split() error handling update.

I'll drop it, thanks!

-- 
Thanks,
Sasha
