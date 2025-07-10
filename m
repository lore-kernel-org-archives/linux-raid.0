Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902D521ABCB
	for <linux-raid@vger.kernel.org>; Thu, 10 Jul 2025 15:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752159846; cv=none; b=Amfy+vjw6y7cjRetmeCVD75kPYJ6I2TRGtYoKcMtsr4pADXdJCqrr7mtWYKaH0NAsaZYgPDs8sfoZ5eNpaEcm6/QUoXPGiYpWi935o11Cx2y4IlAP61QCdAWLKVvWPJAl733p5WviEUq0NQovL7ZKHVvVLoyoCBaFwDS+/73/6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752159846; c=relaxed/simple;
	bh=kttiDqozO+WQNGP1tvbnqpD9ilF2IK07GUI4Ye+djuA=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=kG4uV48hQT6N1/r08E+cTXF0DIsvquo3xyQszzwMAB6mrYmCWbdKMsYDWaSFcaV60mX5qKblFK8/lI58OSw02IyPO62jLV+OuFBqKUU8qJ5R4JgasPZrZWcdJJ0mBCBYza3GFbi6MO8EolFW0SBtG165UVF3/nlOs0rl406bank=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gqaAs8UI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gqaAs8UI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752159843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TQGHAobwwa27OfNzUbQzcEFwWIUKV1Qc4DtxoIyeEUQ=;
	b=gqaAs8UIIfVko4K9SnxECkkHuOkLrOe1MrCp4+uKpUe+fBz051soqTX9DfHFmTmWVT4KZG
	4zFIxEX+rfqD9nTyTD2644cVXziOvFdaMMR34aOvO0/RHMYv8S9/bcCL43fXumhoxOH8CO
	bEJWWWER3BCh86ORBIgI4SWhTxSahrU=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-692-vU9GuSbkM7K9mnx_sH6I4Q-1; Thu,
 10 Jul 2025 11:04:00 -0400
X-MC-Unique: vU9GuSbkM7K9mnx_sH6I4Q-1
X-Mimecast-MFC-AGG-ID: vU9GuSbkM7K9mnx_sH6I4Q_1752159836
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D62511956075;
	Thu, 10 Jul 2025 15:03:55 +0000 (UTC)
Received: from [10.22.80.10] (unknown [10.22.80.10])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6330F19560A3;
	Thu, 10 Jul 2025 15:03:50 +0000 (UTC)
Date: Thu, 10 Jul 2025 17:03:43 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: John Garry <john.g.garry@oracle.com>
cc: agk@redhat.com, snitzer@kernel.org, song@kernel.org, yukuai3@huawei.com, 
    hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk, cem@kernel.org, 
    dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
    linux-raid@vger.kernel.org, linux-block@vger.kernel.org, 
    ojaswin@linux.ibm.com, martin.petersen@oracle.com, 
    akpm@linux-foundation.org, linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v5 5/6] dm-stripe: limit chunk_sectors to the stripe
 size
In-Reply-To: <20250709100238.2295112-6-john.g.garry@oracle.com>
Message-ID: <5e2bbd34-e112-c15a-37ea-f97cbede910c@redhat.com>
References: <20250709100238.2295112-1-john.g.garry@oracle.com> <20250709100238.2295112-6-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40



On Wed, 9 Jul 2025, John Garry wrote:

> Same as done for raid0, set chunk_sectors limit to appropriately set the
> atomic write size limit.
> 
> Setting chunk_sectors limit in this way overrides the stacked limit
> already calculated based on the bottom device limits. This is ok, as
> when any bios are sent to the bottom devices, the block layer will still
> respect the bottom device chunk_sectors.
> 
> Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
> Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  drivers/md/dm-stripe.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
> index a7dc04bd55e5..5bbbdf8fc1bd 100644
> --- a/drivers/md/dm-stripe.c
> +++ b/drivers/md/dm-stripe.c
> @@ -458,6 +458,7 @@ static void stripe_io_hints(struct dm_target *ti,
>  	struct stripe_c *sc = ti->private;
>  	unsigned int chunk_size = sc->chunk_size << SECTOR_SHIFT;
>  
> +	limits->chunk_sectors = sc->chunk_size;
>  	limits->io_min = chunk_size;
>  	limits->io_opt = chunk_size * sc->stripes;
>  }
> -- 
> 2.43.5

Hi

This will conflict with the current dm code in linux-dm.git. Should I fix 
up the conflict and commit it through the linux-dm git?

Mikulas

