Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7060502762
	for <linux-raid@vger.kernel.org>; Tue, 13 Oct 2026 13:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791899053; cv=none; b=juoGD3z0AgMBpmz6/m91r6u2n3Z4ZKLpwenQ7bA+AQK8Wh4IHxLpFLhmaJCDJXjvozNglBPBjrZlnyM/YXiAnVQZsInMzdcarrAzrGBkZc8VXNasC+Z9rgbSZQAyj8GROOtHI7oic8NX1LKOGyoKP4UXQeh25EAjYYwFvV+fYpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791899053; c=relaxed/simple;
	bh=MgrzalUmbGC26c05zod6EpsljsaAM91BcdbZGoCbj24=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=FUENoAZE2ZLvbBzek2UsTinD17VSBEkZkeLPe/TSSifEotO92YaXv5op2oTfFHA1+mU7jKWQ5LrM5XsbfCScol8shhp9BqqA08OgGD2J1NFDAtL8XdD81WSznosq5VLEF0IfPo5okI4hulYoPxrB5F9mIYIU11oPdqA4wNRXjcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jh3WAr/Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jh3WAr/Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50ACD1F000FF;
	Tue, 13 Oct 2026 13:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791899052;
	bh=VPE2wXVSQkeVyaRfAIWeHJvIihqBn1MPPb0wtYz0OA0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Jh3WAr/Z2KVWcD7sOrz5ZP2LQSRvSHRS39Uj0lJ0XarisFzgTUcXez+ONcy5F+F6i
	 s+N+oR2Oy990WdPI8RqSTbRpeTbs09PxWw8Hqxiiq99cILoCEptZYugZ6+LSzNWGmY
	 txZEKjk4o4er9TIUlZPeiCBsqVL+D0f07Ov4d+7rs9Eb6STbEvVoVtItLH2VxtRC/6
	 3cJp0Ly20nSdNuYvzv5TZ9OAgJ1JLtiBjPgflZGExDSOAwX99PZep4wsQBBCZgL/As
	 rvpc+BQSb/eZe49eZtoRN0tLCvBpTcn0QoJOUZO/iAvWVRxuwYEa+PCA/+P1CBfwxO
	 kAFez/b2UNmqg==
Message-ID: <sashiko-outbox-169850@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.6.y] md/raid0: fix data corruption when chunk size is
 below PAGE_SIZE
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yunye Zhao" <yunye.zhao@linux.alibaba.com>, linux-raid@vger.kernel.org
Cc: yukuai@fygo.io
In-Reply-To: <20261013133243.42145-1-yunye.zhao@linux.alibaba.com>
References: <20261013133243.42145-1-yunye.zhao@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 13:44:11 +0000
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] md: missing queue freeze before blk_queue_chunk_sectors()
--

commit b6776719727e7cf128eed60b1bbe45a3b0836f15
Author: YunyeZhao <yunye.zhao@linux.alibaba.com>

md/raid0: fix data corruption when chunk size is below PAGE_SIZE

Fixes silent data corruption that occurs when bios spanning multiple RAID0
chunks are not split properly by the block layer. Sets the chunk boundary
after stacking member limits to ensure block-layer bio splitting respects
the RAID0 chunk size.

> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index c50a7abda744a..5a57e327c6ba4 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
[ ... ]
> @@ -413,6 +415,18 @@ static int raid0_run(struct mddev *mddev)
>  			disk_stack_limits(mddev->gendisk, rdev->bdev,
>  					  rdev->data_offset << 9);
>  		}
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

[Severity: High]
Could modifying the block queue limits here without freezing the queue expo=
se
the block layer to torn limit reads?

When an array is reconfigured, raid0_run() is invoked to update limits. Whi=
le
mddev_suspend() is used during reconfiguration, it only drains
mddev->active_io, which pauses bios deep in the MD stack at
md_handle_request().

It does not prevent new bios from entering the generic block layer via
submit_bio_noacct() and executing blk_queue_split(). Because the queue is n=
ot
frozen via blk_mq_freeze_queue(), these concurrent bios might read torn
values of q->limits.chunk_sectors while raid0_run() modifies it, potentially
leading to inconsistent splitting and silent data corruption.

>  	}
> =20
>  	/* calculate array device size */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013133243.4214=
5-1-yunye.zhao@linux.alibaba.com?part=3D1
