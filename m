Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3A434C990;
	Mon, 23 Feb 2026 07:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771831694; cv=none; b=nkcMA/6bhxLnJahDf6Kp0vO5X6e5pD3uCojWO/N4g+wfG1yxuJDGGoTebgepKT8ygX8iolgvCiyjPyrDR6awgXAwB6vmh1qnXJsshgmDW0J4ygdeqz8gOlzg/5LaN2kExlouwhHkHAgNF2ycKliyq560RJGMuobnb09DbTrvYMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771831694; c=relaxed/simple;
	bh=HLa0K24m1IDBJ6SjbvrYWT/98Mgs7cu2ZiietMCQKUY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ArCTdPA2XZGOUjReaMgIcPOlHhGi249mbnaqFfXMQd/bbAmueDFu2ukQs80cNnmikAIHuTvouaiDFOIbe8RphRxr2qkPBAF/1GPrhKWDkO9j7zXHITbaUJV5FZMV3NVV89bVf2EJSltTkqBgNFaO0hoTPFdkhEHbYKUNw8AHXGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.2.221] (p5dc55210.dip0.t-ipconnect.de [93.197.82.16])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 0AB2C4C2C37D45;
	Mon, 23 Feb 2026 08:26:33 +0100 (CET)
Message-ID: <a48b64d7-e40f-49e3-a118-b27723b09c39@molgen.mpg.de>
Date: Mon, 23 Feb 2026 08:26:33 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/raid5: set chunk_sectors to enable full stripe I/O
 splitting
To: Yu Kuai <yukuai@fnnas.com>
Cc: hch@infradead.org, song@kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, linan122@huawei.com
References: <20260223035834.3132498-1-yukuai@fnnas.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20260223035834.3132498-1-yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Dear Kuai,


Thank you for your patch.

Am 23.02.26 um 04:58 schrieb Yu Kuai:
> Set chunk_sectors to the full stripe width (io_opt) so that the block
> layer splits I/O at full stripe boundaries. This ensures that large
> writes are aligned to full stripes, avoiding the read-modify-write
> overhead that occurs with partial stripe writes in RAID-5/6.
> 
> When chunk_sectors is set, the block layer's bio splitting logic in
> get_max_io_size() uses blk_boundary_sectors_left() to limit I/O size
> to the boundary. This naturally aligns split bios to full stripe
> boundaries, enabling more efficient full stripe writes.
> 
> Test results with 24-disk RAID5 (chunk_size=64k):
>    dd if=/dev/zero of=/dev/md0 bs=10M oflag=direct
>    Before: 461 MB/s
>    After:  520 MB/s  (+12.8%)

Sweet.

> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Yu Kuai <yukuai@fnnas.com>

Once committed, should this be backported to the longterm and stable series?

> ---
>   drivers/md/raid5.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 8854e024f311..810d936560d1 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7783,6 +7783,7 @@ static int raid5_set_limits(struct mddev *mddev)
>   	lim.logical_block_size = mddev->logical_block_size;
>   	lim.io_min = mddev->chunk_sectors << 9;
>   	lim.io_opt = lim.io_min * (conf->raid_disks - conf->max_degraded);
> +	lim.chunk_sectors = lim.io_opt >> 9;
>   	lim.features |= BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE;
>   	lim.discard_granularity = stripe;
>   	lim.max_write_zeroes_sectors = 0;

Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul
