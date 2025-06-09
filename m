Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2CEC144304
	for <linux-raid@vger.kernel.org>; Mon,  9 Jun 2025 15:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749482407; cv=none; b=GHlASobQ8AtYxM+8RtIS9GYtrbaeaQhgYKWmDx+gfIn5ghzlpcnoZjY6lpfl2NI7pmnMOHI6VgzVGs6Mf57LLu62RfqB+NBPMsptMv68ILIjpohbfsE/iJtXOBERxNjxa00Dhwn/9o6zIkXNxwYWORAxki7xN+gYPBQLr5geO3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749482407; c=relaxed/simple;
	bh=DbYVzzhSqIADIaQMs6OG1P3hPZjhzCK8znSCdbbc6U4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=GgUunKWRgajde16Ui/usr26kYCuIqPv+w5pThf7fBaVyXM5vDpseRTHbA1h96byEXJzMthdV6mrCbejvW589phGCafunoB1u6ozemguPovd3Duvtkhnmae3J7GrDH2nqyeWLMvURTCCYqZ13elaMMA2YdGKZ45CftqAadx81VYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Utv56Xt9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Utv56Xt9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749482405;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5mlAQYytM8B2b5zdqsGWE01G/dEOVGIx1BTCzzndcRo=;
	b=Utv56Xt9Frk3G611MWnNuDjCIvvPU3MJp8p8KyzMsfm9tc1AOOfRzUHzlRh2Tl4yOnAxv9
	Hpmcg5In7lg5weCp1OwulyGTURMIWRRZya2s/eKzcxhdIdoaEaY9qXMFMxwHhhwsm/R38H
	5x/VNgP/RED+n/+XavxgleO8kEltT1A=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-482-tR-w92DaNcuUZOIUi-Gaag-1; Mon,
 09 Jun 2025 11:20:01 -0400
X-MC-Unique: tR-w92DaNcuUZOIUi-Gaag-1
X-Mimecast-MFC-AGG-ID: tR-w92DaNcuUZOIUi-Gaag_1749482399
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D8F71180028C;
	Mon,  9 Jun 2025 15:19:58 +0000 (UTC)
Received: from [10.22.80.249] (unknown [10.22.80.249])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8F53719560A3;
	Mon,  9 Jun 2025 15:19:54 +0000 (UTC)
Date: Mon, 9 Jun 2025 17:19:51 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: John Garry <john.g.garry@oracle.com>
cc: agk@redhat.com, snitzer@kernel.org, song@kernel.org, yukuai3@huawei.com, 
    hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, 
    linux-block@vger.kernel.org, ojaswin@linux.ibm.com, 
    martin.petersen@oracle.com
Subject: Re: [PATCH RFC 3/4] dm-stripe: limit chunk_sectors to the stripe
 size
In-Reply-To: <20250605150857.4061971-4-john.g.garry@oracle.com>
Message-ID: <e7e147a8-f22e-e420-1497-5b31be9ab4e3@redhat.com>
References: <20250605150857.4061971-1-john.g.garry@oracle.com> <20250605150857.4061971-4-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40



On Thu, 5 Jun 2025, John Garry wrote:

> Currently we use min io size as the chunk size when deciding on the limit
> of atomic write size.
> 
> Using min io size is not reliable, as this may be mutated when stacking
> the bottom device limits.
> 
> The block stacking limits will rely on chunk_sectors in future, so set
> this value (to the chunk size).
> 
> Introduce a flag - DM_TARGET_STRIPED - and check this in
> dm_set_device_limits() when setting this limit.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  drivers/md/dm-stripe.c        | 3 ++-
>  drivers/md/dm-table.c         | 4 ++++
>  include/linux/device-mapper.h | 3 +++
>  3 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
> index a7dc04bd55e5..c30df6715149 100644
> --- a/drivers/md/dm-stripe.c
> +++ b/drivers/md/dm-stripe.c
> @@ -466,7 +466,8 @@ static struct target_type stripe_target = {
>  	.name   = "striped",
>  	.version = {1, 7, 0},
>  	.features = DM_TARGET_PASSES_INTEGRITY | DM_TARGET_NOWAIT |
> -		    DM_TARGET_ATOMIC_WRITES | DM_TARGET_PASSES_CRYPTO,
> +		    DM_TARGET_ATOMIC_WRITES | DM_TARGET_PASSES_CRYPTO |
> +		    DM_TARGET_STRIPED,
>  	.module = THIS_MODULE,
>  	.ctr    = stripe_ctr,
>  	.dtr    = stripe_dtr,
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 24a857ff6d0b..4f1f7173740c 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -430,6 +430,10 @@ static int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
>  		return 0;
>  	}
>  
> +	/* For striped types, limit the chunk_sectors to the chunk size */
> +	if (dm_target_supports_striped(ti->type))
> +		limits->chunk_sectors = len >> SECTOR_SHIFT;
> +

len is already in sectors, so why do we shift it right?

Could this logic be moved to the function stripe_io_hints, so that we 
don't have to add a new flag for that and that we don't have to modify the 
generic dm code?

Mikulas

>  	mutex_lock(&q->limits_lock);
>  	/*
>  	 * BLK_FEAT_ATOMIC_WRITES is not inherited from the bottom device in
> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> index cb95951547ab..a863523b69ee 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -309,6 +309,9 @@ struct target_type {
>  #define DM_TARGET_ATOMIC_WRITES		0x00000400
>  #define dm_target_supports_atomic_writes(type) ((type)->features & DM_TARGET_ATOMIC_WRITES)
>  
> +#define DM_TARGET_STRIPED		0x00000800
> +#define dm_target_supports_striped(type) ((type)->features & DM_TARGET_STRIPED)
> +
>  struct dm_target {
>  	struct dm_table *table;
>  	struct target_type *type;
> -- 
> 2.31.1
> 

