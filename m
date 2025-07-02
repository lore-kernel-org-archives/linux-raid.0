Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A16F2F42;
	Wed,  2 Jul 2025 11:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751454202; cv=none; b=gsWBsOFh/Pt32N5noli+GAoYrDtT71BwhQEV1RZ6nrPqUlyOru//t90cuDeZgAhV2UR6f8BoOd5172eeEhey2b0Mnn8u4nCb9HkYIX4SbzdxbwOubUSwscq+3kLpzTebUofxuQCa109ZxW6imzyIE+jVHSV06xDg066v+tnJx0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751454202; c=relaxed/simple;
	bh=W8R1Pijrf5KsnFWMU5ENBfyC/tgH3DgIl3/2uP5y6q8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ICuwEVfbYFfTVAELpo4CFnrcbdyAvy6LEF9nMil+WCarvcjnQm2Xnn84Dq4UOWBEOqPk13VMOCfkS+1KxMUHBW7Ro/SV1SyVWR+jNzB3Sapv2ANevi2f/mLFrFIPFRlnO/ak11ZJt9wfJsbWrYUgN0sYXD2ng6Io8p+9/T4uS7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [141.14.220.36] (g36.guest.molgen.mpg.de [141.14.220.36])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 87E706028825A;
	Wed, 02 Jul 2025 13:02:33 +0200 (CEST)
Message-ID: <8d4fd6e0-ebaf-4351-be17-5be24de8b2af@molgen.mpg.de>
Date: Wed, 2 Jul 2025 13:02:32 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/raid1,raid10: strip REQ_NOWAIT from member bios
To: Zheng Qixing <zhengqixing@huaweicloud.com>
Cc: song@kernel.org, yukuai3@huawei.com, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 houtao1@huawei.com, zhengqixing@huawei.com
References: <20250702102341.1969154-1-zhengqixing@huaweicloud.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20250702102341.1969154-1-zhengqixing@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Qixing,


Thank you for your patch.


Am 02.07.25 um 12:23 schrieb Zheng Qixing:
> From: Zheng Qixing <zhengqixing@huawei.com>
> 
> RAID layers don't implement proper non-blocking semantics for
> REQ_NOWAIT, making the flag potentially misleading when propagated
> to member disks.
> 
> This patch clear REQ_NOWAIT from cloned bios in raid1/raid10. Retain
> original bio's REQ_NOWAIT flag for upper layer error handling.

clear*s* or just Clear REQ_NOWAIT …

> Maybe we can implement non-blocking I/O handling mechanisms within
> RAID in future work.

Excuse my ignorance. Is this going to cause a regression for people 
depending on this feature, despite not working reliably?

Also, is there a reproducer to check, that it’s not misleading anymore?

> Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
> ---
>   drivers/md/raid1.c  | 3 ++-
>   drivers/md/raid10.c | 2 ++
>   2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 19c5a0ce5a40..213ad5b7e20b 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1399,7 +1399,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
>   	}
>   	read_bio = bio_alloc_clone(mirror->rdev->bdev, bio, gfp,
>   				   &mddev->bio_set);
> -
> +	read_bio->bi_opf &= ~REQ_NOWAIT;
>   	r1_bio->bios[rdisk] = read_bio;
>   
>   	read_bio->bi_iter.bi_sector = r1_bio->sector +
> @@ -1649,6 +1649,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>   				wait_for_serialization(rdev, r1_bio);
>   		}
>   
> +		mbio->bi_opf &= ~REQ_NOWAIT;
>   		r1_bio->bios[i] = mbio;
>   
>   		mbio->bi_iter.bi_sector	= (r1_bio->sector + rdev->data_offset);
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index b74780af4c22..951b9b443cd1 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1221,6 +1221,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
>   		r10_bio->master_bio = bio;
>   	}
>   	read_bio = bio_alloc_clone(rdev->bdev, bio, gfp, &mddev->bio_set);
> +	read_bio->bi_opf &= ~REQ_NOWAIT;
>   
>   	r10_bio->devs[slot].bio = read_bio;
>   	r10_bio->devs[slot].rdev = rdev;
> @@ -1256,6 +1257,7 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
>   			     conf->mirrors[devnum].rdev;
>   
>   	mbio = bio_alloc_clone(rdev->bdev, bio, GFP_NOIO, &mddev->bio_set);
> +	mbio->bi_opf &= ~REQ_NOWAIT;
>   	if (replacement)
>   		r10_bio->devs[n_copy].repl_bio = mbio;
>   	else


Kind regards,

Paul
