Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792821474;
	b=EeGqmvwdeQiOzq00txj+yTN660g4D/KOQ4Ssd/SrZud7n9tCvXqYPdKtdROrZhcTpfXu
	 ADE+A/z+i4TJ1J9R13am04Knmf+4hIY8a2oVqbP5L3g8MZRGw2Vx6hC/jxfSvPVf2STVl
	 9dxLJUls2e7s7Uqh3PSfZ+qk/mmEggora7uD5ZT3w/dhzfOFF/MVyAM2cf8yF1VcVKQCP
	 G3RjDCajH29QhCPbQt1E/KxTUbsKqaXMYnhTndTRp3hBNIqwEWEXUM4GAxPsS4ikk9qG1
	 TDKSsvkTpgmayw6QwbMAYbAgC/t+EYykvZOXiQ2vaoCIi8+27hlabQTgZMkKEYm0F5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792821474;
	h=DMARC-Filter:DKIM-Signature:Message-Id:References:Cc:Subject:
	 Received:To:Mime-Version:X-Original-From:Content-Type:From:Date:
	 Content-Transfer-Encoding:User-Agent:In-Reply-To:Reply-To:
	 X-Lms-Return-Path;
	bh=RN1C7SPj1a41MISMlj6iIRRPbs5JkFJog6L7oJ/j0z4=;
	b=wWrUgjOl7HkAkEkZcnrBKEj2uU0nexbwkXlB4zKxXSivnyV3zrmJfshjaofEkc+VUtth
	 pRpB1n+M3GPWffW1Dlk94PNMIbYklkh86W3m4aF/eBzdDHHBzDnwGOa5dN2RB43nFnCB7
	 kBUTQErgIMrh4jyH70srw6M+EmZvIB6avdG6cuv0lSsyzK8ejBZdY9zK6eP5R9SWiZfU7
	 0+rGtHJq9MAv+JzbQIcZC2XRTES16Sxw9q6Fcr+BQ4FtRHQGrmm5gUJVAN+G3i20xuWhN
	 UksXJlVrLX9I3Gyclu13p9ZMOg1+b1tJdtzsMGUkxh6VGM9mGZP1c9cQTe3CUg6y2PA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=jbly2iRY;
	arc=none smtp.remote-ip=209.127.231.54
Received: from va-2-54.ptr.blmpb.com (va-2-54.ptr.blmpb.com [209.127.231.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D23606A31A
	for <linux-raid@vger.kernel.org>; Sat, 24 Oct 2026 05:57:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82D23606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=jbly2iRY
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1792821469;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=RN1C7SPj1a41MISMlj6iIRRPbs5JkFJog6L7oJ/j0z4=;
 b=jbly2iRYviEswgqVS9FZ5C+NWG0gWJN05VrNoz92Kzf2rjWDIr0ZrX5PF6XF7oaiDEmKPx
 qyP31vwrP8YVsnBRxWPhs9nw+DScKNJplABGPIbITG15F3biUeytyeTDKZtOKVo81a5E1a
 cQZxpNSobzkJMWmfjAKjsosZ42Ju8ar+DRyYAI9h0HzUW78j6OvECJUB2YbH5M6kUr31qk
 O8vZs1MW2FQrihngOM4NcxfDQryXNxJiOeAJI0fVO+nSPovUy4vnHJha9bFZXNjBLCJQWk
 dsZnE+OjSgPw7dKR/xgFvJqh1fOkACOqdr0uxvtifZGBs2uUuap+VSmOhAQkyw==
Message-Id: <a138247b-287d-4e5b-b6da-6337b0ec7272@fygo.io>
References: <20261013133243.42145-1-yunye.zhao@linux.alibaba.com>
Cc: "Song Liu" <song@kernel.org>, "Li Nan" <magiclinan@didiglobal.com>, 
	"Xiao Ni" <xiao@kernel.org>, "Jan Kara" <jack@suse.cz>, 
	"John Garry" <john.g.garry@oracle.com>, 
	"Joseph Qi" <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH 6.6.y] md/raid0: fix data corruption when chunk size is below PAGE_SIZE
Received: from [192.168.1.104] ([39.182.0.21]) by smtp.larksuite.com with ESMTPS; Sat, 24 Oct 2026 05:57:47 +0000
To: "Yunye Zhao" <yunye.zhao@linux.alibaba.com>, 
	<linux-raid@vger.kernel.org>, "yu kuai" <yukuai@fygo.io>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Original-From: yu kuai <yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
From: "yu kuai" <yukuai@fygo.io>
Date: Sat, 24 Oct 2026 13:57:43 +0800
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
In-Reply-To: <20261013133243.42145-1-yunye.zhao@linux.alibaba.com>
Reply-To: yukuai@fygo.io
X-Lms-Return-Path: <lba+26adc48dc+5dc7a4+vger.kernel.org+yukuai@fygo.io>

Hi,

=E5=9C=A8 2026/10/13 21:32, Yunye Zhao =E5=86=99=E9=81=93:
> From: YunyeZhao <yunye.zhao@linux.alibaba.com>
>
> Commit 319ff40a5427 ("md/raid0: Fix performance regression for large sequ=
ential writes")
> assumes that bios reaching RAID0 are no larger than the chunk size.
>
> However, blk_queue_max_hw_sectors() raises limits smaller than
> PAGE_SIZE to one page. With 64 KiB pages and a 16 KiB RAID0 chunk, a
> bio can therefore span several chunks. raid0_make_request() splits it
> only once and maps the multi-chunk remainder to one member device,
> causing silent data corruption.
>
> Set the queue chunk boundary after stacking the member limits, combined
> with any inherited boundary using gcd(). This makes the block layer
> split bios at chunk boundaries before they reach RAID0. Only install a
> boundary aligned to the logical block size so that bio splitting
> always makes progress.
>
> Setting the boundary after disk_stack_limits() is required because
> stacking may clear or reduce a boundary installed earlier. This adapts
> the mechanism introduced by upstream commit 4b8beba60d32
> ("md/raid0: set chunk_sectors limit") to the queue limits API used by
> 6.6.y.

Please explain why backporting is not preferred, backporting is always the
first choice.

>
> The corruption was reproduced on arm64 with 64 KiB pages and a 16 KiB
> chunk. A 64 KiB chunk configuration is unaffected.
>
> Fixes: 319ff40a5427 ("md/raid0: Fix performance regression for large sequ=
ential writes")
> Signed-off-by: YunyeZhao <yunye.zhao@linux.alibaba.com>
> ---
>   drivers/md/raid0.c | 14 ++++++++++++++
>   1 file changed, 14 insertions(+)
>
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index c50a7abda744..5a57e327c6ba 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -11,6 +11,7 @@
>   */
>  =20
>   #include <linux/blkdev.h>
> +#include <linux/gcd.h>
>   #include <linux/seq_file.h>
>   #include <linux/module.h>
>   #include <linux/slab.h>
> @@ -382,6 +383,7 @@ static void raid0_free(struct mddev *mddev, void *pri=
v)
>   static int raid0_run(struct mddev *mddev)
>   {
>   	struct r0conf *conf;
> +	unsigned int chunk_limit;
>   	int ret;
>  =20
>   	if (mddev->chunk_sectors =3D=3D 0) {
> @@ -413,6 +415,18 @@ static int raid0_run(struct mddev *mddev)
>   			disk_stack_limits(mddev->gendisk, rdev->bdev,
>   					  rdev->data_offset << 9);
>   		}
> +
> +		/*
> +		 * Set the chunk boundary after stacking member limits, which
> +		 * may clear or reduce it. Without it a bio may span several
> +		 * chunks when chunk size < PAGE_SIZE. Keep it a multiple of
> +		 * the logical block size so the block layer can split at it.
> +		 */
> +		chunk_limit =3D gcd(mddev->queue->limits.chunk_sectors,
> +				  mddev->chunk_sectors);
> +		if (!(chunk_limit %
> +		      (mddev->queue->limits.logical_block_size >> SECTOR_SHIFT)))
> +			blk_queue_chunk_sectors(mddev->queue, chunk_limit);
>   	}
>  =20
>   	/* calculate array device size */

--=20
Thanks,
Kuai
