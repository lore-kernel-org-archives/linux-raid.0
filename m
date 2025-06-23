Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C50223323
	for <linux-raid@vger.kernel.org>; Mon, 23 Jun 2025 09:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750672194; cv=none; b=ktNtM/7knp0clrJ9+YTY0ge7umj3BGJYbGiS4QCns9RIOpjjuVc46YLaLKCzJNCE3a0XYUkWsKwPkbL2OJKz/j2akXXPCJhlJKMXQHvSZRetJsCUHCbuw8/A8pT2hlji/dGRLJc6KUpiR1iIZLLejbLv1rNN071/If1ow1LNvOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750672194; c=relaxed/simple;
	bh=tYYN68KIhKpUm94dvkFIqNu0JEd7ylMdObP13UaACv0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Me2ZlvEPBVbDAcAaN4AMeC1YJJ3UpU7RB803DM6b8g5EfTlIuuZ/QEvEzWDRqWYPWWB+ic52+3zvaslywXmNuzJTu/l/56Z77zoQvazySi33aodVWiiDXTWEidCONEXTrA+aTUMCGXNd/MdwmMSNksDGpqfL5yM80rDUgC+WS84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aeQPrWeb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aeQPrWeb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750672191;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I3UBDVi5sXjr+Xruv6MaOfSJ09qNph1kaTFIkhQo8sc=;
	b=aeQPrWeblfjjLdQDCxsnWE58RmUEgBiNFjVP8oBwC9VZnXCZEh+WjXOqVS16/x5nASWAy/
	d3eWQFfQZkRI1zdpqnEj6AdSLY01J7AouWysb414d7RqgpljJoDCmAz88gtJtE1UkaESBG
	l04KggCMmslEjMbsRrGoTki1LrsDPLo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-100-wPkyuED1OGSDkcQVVfsOFQ-1; Mon,
 23 Jun 2025 05:49:46 -0400
X-MC-Unique: wPkyuED1OGSDkcQVVfsOFQ-1
X-Mimecast-MFC-AGG-ID: wPkyuED1OGSDkcQVVfsOFQ_1750672184
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9E2D21955F06;
	Mon, 23 Jun 2025 09:49:43 +0000 (UTC)
Received: from [10.22.80.93] (unknown [10.22.80.93])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4F36718046C7;
	Mon, 23 Jun 2025 09:49:34 +0000 (UTC)
Date: Mon, 23 Jun 2025 11:49:31 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: John Garry <john.g.garry@oracle.com>
cc: agk@redhat.com, snitzer@kernel.org, song@kernel.org, yukuai3@huawei.com, 
    hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, 
    linux-block@vger.kernel.org, ojaswin@linux.ibm.com, 
    martin.petersen@oracle.com
Subject: Re: [PATCH v2 4/5] dm-stripe: limit chunk_sectors to the stripe
 size
In-Reply-To: <20250618083737.4084373-5-john.g.garry@oracle.com>
Message-ID: <0ba540a3-9434-c02a-f2ea-fa5ce13325e3@redhat.com>
References: <20250618083737.4084373-1-john.g.garry@oracle.com> <20250618083737.4084373-5-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111



On Wed, 18 Jun 2025, John Garry wrote:

> Same as done for raid0, set chunk_sectors limit to appropriately set the
> atomic write size limit.
> 
> Setting chunk_sectors limit in this way overrides the stacked limit
> already calculated based on the bottom device limits. This is ok, as
> when any bios are sent to the bottom devices, the block layer will still
> respect the bottom device chunk_sectors.
> 
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
> 2.31.1

Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>

