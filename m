Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792823876;
	b=zB4wZ2hH++o4eiEZDSKDnisuOcPrih/F1QhbUDnG36TLeHEsBaG+QyJtNEUFjHvLEgii
	 Br5P0mkTQxnQmOYgSiQOyvPeSNBNfcJtWw0yeFUgx8GRFgfyEKJIQnV6d2C/VHxkHHyc9
	 Bk14NNl69KxfeWbFHSoDXIWjSDJoH0GD+1+I1QvEJV5MQXOllQ/d9otAFXOc2Shix6ZgK
	 a0fRGJ7gay3XHQWaOOVH3EAFjr55AjSLybv3ZRxOGY6F9RBQeKaMPQRh+RCfFEwShLsxe
	 stD+0XZWa6agYe2Xu7SFQ3njnanNL5l0Z34JawHVykyUyYm+myHMj7Ydr6QSMeKvbSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792823876;
	h=DMARC-Filter:DKIM-Signature:Message-Id:Content-Transfer-Encoding:
	 References:Subject:X-Original-From:From:Mime-Version:Content-Type:
	 Reply-To:Cc:Date:User-Agent:Received:In-Reply-To:X-Lms-Return-Path:
	 To;
	bh=B2AiRswYnCeCx43fY3qmEiXhARLxZVXarE6kOehd9kk=;
	b=Cdwz8bF/Fe/aANdd1RLbmy8O5HgTFog/B2eiYDUg5bAr9K786Wq4xXwqL4YeMH2eyXbF
	 zUqjc2fl7D8/cbgvP+dw+XvvSC4Cj1cR8agPqGyPIPH34LEz98xSl6zWR+C2gVUjSV4ro
	 4jzn6VzgriYmglTNwxv/j/a+bAG+mqVoS4XO1TLzupAtJQHP39kU77s2xpyT5vlpm3/hk
	 ixo+YjqRNHZl/uPb7LA9lVDtwnvHxUG3PhWRWMu90nQPZ5hLhKVD9X7sDE7NTaJbmg7Z+
	 Od4/8IlzuGUE1xL9zAFrfeKq+VRy5ycqEg3ZBX/Q3rgFtH5oVLiCVxuWvQs7M2WTa6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=RLRYHanX;
	arc=none smtp.remote-ip=209.127.231.58
Received: from va-2-58.ptr.blmpb.com (va-2-58.ptr.blmpb.com [209.127.231.58])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E84A606A31A
	for <linux-raid@vger.kernel.org>; Sat, 24 Oct 2026 06:37:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9E84A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=RLRYHanX
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1792823870;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=B2AiRswYnCeCx43fY3qmEiXhARLxZVXarE6kOehd9kk=;
 b=RLRYHanXjOmBoRr2CqsBKX+G7DrBiktmRZshmV+AS/5ubl08dreiDjJ4gwupU9NFOjuYG/
 sU4uq1cJNkDKerP1ny672uHyBDEMBphZV222ZUr4d2KR+vNrKnChLvR1nByN3oVO+jm3BA
 ED+FF8uMpBhb3s/QZCNE6CiVkH2WxD1bylQzanbQE8fzvrqy6JIrw0wkSGwZGWZRG/coGt
 vNyx+GwvpjDIdTcMlTYpMSL3haK4XIi25fKgj9gb7IO2GCgxjSEQ4YFe/ygtAxGf6pPN6J
 GB5Epa0Vjm8ew4kkATjhDvdpVUWLFfEIxBH81OEpA/N/WskJnXz2AnA+b+/oFw==
Message-Id: <34c07a33-808b-48c8-b749-54e0d81bb3ca@fygo.io>
Content-Transfer-Encoding: quoted-printable
References: <20261016042537.277516-1-me@dougvj.me> <010101a142f581e5-36ad5604-721c-4ad0-86f3-62ca283b6133-000000@us-west-2.amazonses.com>
Subject: Re: [PATCH v4 2/3] md/raid5: do not reshape if overlapping rdev bad block ranges prevent it
X-Original-From: yu kuai <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Reply-To: yukuai@fygo.io
Cc: <song@kernel.org>, <magiclinan@didiglobal.com>, <xiao@kernel.org>, 
	<chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>, 
	"Yu Kuai" <yukuai1@huaweicloud.com>
Date: Sat, 24 Oct 2026 14:37:45 +0800
User-Agent: Mozilla Thunderbird
Received: from [192.168.1.104] ([39.182.0.21]) by smtp.larksuite.com with ESMTPS; Sat, 24 Oct 2026 06:37:49 +0000
In-Reply-To: <010101a142f581e5-36ad5604-721c-4ad0-86f3-62ca283b6133-000000@us-west-2.amazonses.com>
X-Lms-Return-Path: <lba+26adc523e+31d1f5+vger.kernel.org+yukuai@fygo.io>
To: "Doug V Johnson" <me@dougvj.me>, <linux-raid@vger.kernel.org>, 
	"yu kuai" <yukuai@fygo.io>

Hi,

=E5=9C=A8 2026/10/16 12:25, Doug V Johnson =E5=86=99=E9=81=93:
> Ensure that a reshape is not started if there are more than max_degraded
> devices in the array that are either out of sync, faulty, missing,
> or have overlapping bad blocks such that a read is not recoverable.
>
> Cheaply verify that the number of bad or unavailable devices exceeds
> the max number of degraded drives and if so sweep the bad block lists
> on each device for overlaps using a new function array_has_badblock().
>
> Invoke this function in raid5_start_reshape() and if the array has
> unreadable blocks, return -EIO to report it to userspace.
>
> Leave in place the existing functionality to handle a failed reshape
> in progress because it's possible for bad blocks to be discovered or
> placed in metadata after a reshape has already been initiated.
>
> Link: https://lore.kernel.org/r/21f250f9-04b5-76f6-84c9-1fd245b748c6@huaw=
eicloud.com
> Link: https://lore.kernel.org/r/a9119707-4fa1-58cb-377c-63df67f88957@huaw=
eicloud.com
> Suggested-by: Yu Kuai <yukuai1@huaweicloud.com>
> Assisted-by: LLM
> Signed-off-by: Doug V Johnson <me@dougvj.me>
> ---
>   drivers/md/raid5.c | 88 ++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 88 insertions(+)

I think we can be more extreme here, by refusing to reshape if any rdev has=
 badblocks,
this is much simpler and if any disk already have badblocks, it's possible =
new badblocks
can happen during reshape.

>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 86ea65559576..23ff549fa363 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -8636,6 +8636,89 @@ static int check_reshape(struct mddev *mddev)
>   				     + mddev->delta_disks));
>   }
>  =20
> +static int rdev_is_unavailable(struct md_rdev *rdev)
> +{
> +	return !rdev || test_bit(Faulty, &rdev->flags) ||
> +	       !test_bit(In_sync, &rdev->flags);
> +}
> +
> +static int array_has_badblock(struct r5conf *conf)
> +{
> +	sector_t dev_sectors =3D conf->mddev->dev_sectors;
> +	sector_t stripe_sectors =3D RAID5_STRIPE_SECTORS(conf);
> +	sector_t max_sectors =3D round_down((sector_t)INT_MAX, stripe_sectors);
> +	sector_t offset =3D 0;
> +	int num_bad_devs =3D 0;
> +	int i;
> +
> +	/* Check if there are even enough bad disks for a bad block condition *=
/
> +	for (i =3D 0; i < conf->raid_disks; i++) {
> +		struct md_rdev *rdev =3D conf->disks[i].rdev;
> +
> +		if (rdev_is_unavailable(rdev) || rdev->badblocks.count)
> +			num_bad_devs++;
> +	}
> +	if (num_bad_devs <=3D conf->max_degraded)
> +		return 0;
> +
> +	/*
> +	 * Sweep the sectors of the array for bad blocks in constituent devices=
.
> +	 * Within a stripe if there are more bad disks than can be recoverable
> +	 * (max degraded) then the array has bad blocks.
> +	 *
> +	 * The offset tracks the sweep. We advance to the first bad stripe
> +	 * boundary found in any device.
> +	 */
> +	while (offset < dev_sectors) {
> +		sector_t len =3D min(dev_sectors - offset, max_sectors);
> +		int bad_disks =3D 0;
> +
> +		for (i =3D 0; i < conf->raid_disks; i++) {
> +			struct md_rdev *rdev =3D conf->disks[i].rdev;
> +			sector_t first_bad, bad_sectors, end;
> +
> +			if (rdev_is_unavailable(rdev)) {
> +				bad_disks++;
> +				continue;
> +			}
> +			if (!rdev->badblocks.count)
> +				continue;
> +			if (!badblocks_check(&rdev->badblocks,
> +					     rdev->data_offset + offset, len,
> +					     &first_bad, &bad_sectors))
> +				continue;
> +
> +			/*
> +			 * Rebase the bad blocks start and end to the device's data
> +			 * offset for consistent comparision
> +			 */
> +			end =3D first_bad + bad_sectors - rdev->data_offset;
> +			first_bad =3D max(first_bad, rdev->data_offset) -
> +				    rdev->data_offset;
> +
> +			/* Snap the range to the stripe boundary extent */
> +			first_bad =3D round_down(first_bad, stripe_sectors);
> +			end =3D round_up(end, stripe_sectors);
> +
> +			/*
> +			 * This device has a bad block at or overlapping the current
> +			 * sweep position, so it's a bad disk
> +			 */
> +			if (first_bad <=3D offset) {
> +				len =3D min(len, end - offset);
> +				bad_disks++;
> +			} else {
> +				len =3D min(len, first_bad - offset);
> +			}
> +		}
> +		if (bad_disks > conf->max_degraded)
> +			return 1;
> +		offset +=3D len;
> +		cond_resched();
> +	}
> +	return 0;
> +}
> +
>   static int raid5_start_reshape(struct mddev *mddev)
>   {
>   	struct r5conf *conf =3D mddev->private;
> @@ -8685,6 +8768,11 @@ static int raid5_start_reshape(struct mddev *mddev=
)
>   			mdname(mddev));
>   		return -EINVAL;
>   	}
> +	if (array_has_badblock(conf)) {
> +		pr_warn("md/raid:%s: reshape not possible due to bad block list\n",
> +			mdname(mddev));
> +		return -EIO;
> +	}
>   	if (md_bitmap_enabled(mddev, false) &&
>   	    mddev->bitmap_id =3D=3D ID_LLBITMAP) {
>   		i =3D mddev->bitmap_ops->resize(mddev, mddev->dev_sectors, 0);

--=20
Thanks,
Kuai
