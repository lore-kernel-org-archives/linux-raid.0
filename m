Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068C01A3166
	for <linux-raid@vger.kernel.org>; Mon, 13 Apr 2026 02:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776046033; cv=none; b=r1+zzSr3isvyFFwiyBYEZRybZUBw0/gMZeyjW6LWoFowloR6BoNj6vlg0oHp64bFqYMbWiNWKBHKpFNJW8R6GRQExLTxRZrXMUbzvIpr1+AAWmIb7ng1jIXCrvXb6F4Fo3djbv9BTSun7QOH9TmM8QuB/aJlRO+7aDxhU39Wce8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776046033; c=relaxed/simple;
	bh=7sFyGGauP5gNRuwlpPuHM175HkedoJqyzmdS/Bmjlzk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WB5jaWARrNIvjveI3Pku7X82s4xODzsYAXrdQWBakxN7rimo4iNT1vcc8ffRDMBXf/rdzDFpDoWVHHy3JSLQ51MrZimUBvb0suA3TimTekXceUjGjIphZwLGttX8FDOBXSgfotxle+T7c4XptqWtxpGpvLu5XezKHqbj/FzWYvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZwEhtmKZ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=D9XvBND8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZwEhtmKZ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="D9XvBND8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776046030;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MNKfdBox0aRE/GHZk1rNSRCiPUp1KxmcHVJkXtQYAjE=;
	b=ZwEhtmKZVPzW77HG6Odc/TImW3lPBzjlnMaugMn+fa1xUWa5qHEtXwxiX8TCAxdBO+u3BB
	PTKUqS9S35FMi0KdcCA5sxqJrUaSG/QCZ40kqSIYul6mDFnDu+0OI6gEPOybzPOdRQJ/PM
	DEi6T32uMZDg6b7gyspgb5TVphqK7Wg=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-sGksXqwsMBGvEc2RhyjYCA-1; Sun, 12 Apr 2026 22:07:09 -0400
X-MC-Unique: sGksXqwsMBGvEc2RhyjYCA-1
X-Mimecast-MFC-AGG-ID: sGksXqwsMBGvEc2RhyjYCA_1776046028
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-358e425c261so4531400a91.3
        for <linux-raid@vger.kernel.org>; Sun, 12 Apr 2026 19:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1776046028; x=1776650828; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MNKfdBox0aRE/GHZk1rNSRCiPUp1KxmcHVJkXtQYAjE=;
        b=D9XvBND8BhWy4JwFtl/wQTuraIbBf/o5jRYivhfGpb8/2ZbCiRwsYv8Aks1iHHffmv
         nlqepLt0uZf2Zb/Z7soPkLcVCbLF/3lknmw86vh8sAbWhRQxQptRq6F9UHqy6QCBdRce
         W/2x90vXU6sxkVxMFOvZzx/NepfvKrJAPshiu2hBrwgyBSgCNUcqoHu2IGBQyTUdXFGE
         BA0uXbHegeXxUa6IeVAkzqKq706gMPSNEmSe4sQUh1YJJRvCoLLQFOsBoUvJOXvp+F76
         b8IkGsjdAu/dEBUOAyCFGL6uPKTFq+f97wEFb23tukF/MmeULZLQGg9mHJ48/iPD0G4y
         uOZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776046028; x=1776650828;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MNKfdBox0aRE/GHZk1rNSRCiPUp1KxmcHVJkXtQYAjE=;
        b=ZKurDQSX+jMNEORFffXDhbCRD2gUzWYL2b5IywGbVtdy29F1OEdH5gY2RCu/4GS20F
         ih1xRg6OvNJhmkdqq8WoF34f7y3BXMHl1lrjVIyEma11EvR5cGDC1wVlfZ7OBAv4uare
         6Xlo4Kxo25TIx4n0vuobIzZASSG9d3NgkvGFFcx5R0sFKLv9iqyNmqWFPb7MoQoseVLa
         Joq4xK9mkxNiS6Reci/NMlSN4k5Vad0Zzi1+2eGsjUJ8aDzLSg/QJ/WRTzqB+mBIto5D
         U1mNDxBthNHF5HazqcJjabBGFkzwoiv34ses8KlaNkS1529bJgRe3DgrHKIrIzQiPT2x
         ukPA==
X-Gm-Message-State: AOJu0YzNv0C6yBrIRVZF59KQ1QG5H7SmaUXcv3dak7gDhX8id9FJQoCt
	FGfW+jwxgBZFfDiX84+2Cj8W/2AnRbm89CW/9WrqzV2K/utexQhVDZ/rssoRGqDgi2NVTRGl1O2
	6yEpMevHm1/hNTCa5LBCBhDumpSm4TrrztJVskkUdzCzqdZWByucw8gug8SZehRo=
X-Gm-Gg: AeBDietLhj9BvtLamKCjMlQcpc99+kP8WRu57bve6K3S9DFXbXFvLeZsvmpVn+YI0nX
	ACoVqFlqG5n5YNV0HqyhxEF93AhSr/Cx0Ecd2XFKnqz/eZz/bN+zcbVL8zAQbeNEoGrHhoVf7Mp
	96a1Dc3wG0/hI+5gbiqp1uETzh6/XJfzbCnPyCxL9ZGSg3OBwh4Zx1yBW6GyHsqPxIc7N0sTgxy
	EmNxUvdCv6L0S6Bufq3DS9A4R/g+AVKqXkLwo3UBXZVlJqal7ALEuAMeT4Q/mMXI02sCyUaUogF
	nntahkNOZuYT3a55mi5Y3nKpkIRtonVITdK9YCSKqPjupJbVFB8E5HYgBHo0fNRrjULHIrfoZ8F
	7qJc6wzLQ4U80cCBVLX0NY6xwo7CqUFeQVeS+U6G11EySZtu3O8hqOYbiadaG3w8H+G/a5xYWCp
	TLBCHrnlu1Q4X4wEh5FTtPX56dfLBme8qw
X-Received: by 2002:a05:6a20:9389:b0:39f:23d9:99bd with SMTP id adf61e73a8af0-39fe3d0e786mr11111020637.20.1776046028400;
        Sun, 12 Apr 2026 19:07:08 -0700 (PDT)
X-Received: by 2002:a05:6a20:9389:b0:39f:23d9:99bd with SMTP id adf61e73a8af0-39fe3d0e786mr11111002637.20.1776046027922;
        Sun, 12 Apr 2026 19:07:07 -0700 (PDT)
Received: from [10.72.112.77] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c50d874sm9298638b3a.59.2026.04.12.19.07.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Apr 2026 19:07:06 -0700 (PDT)
Message-ID: <3fed2f45-37a5-44cf-b862-f778ca685af9@redhat.com>
Date: Mon, 13 Apr 2026 10:07:01 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] md/raid5: Fix UAF on IO across the reshape position
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Yu Kuai <yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com>,
 Song Liu <song@kernel.org>, Li Nan <linan122@huawei.com>
Cc: linux-raid@vger.kernel.org, dm-devel@lists.linux.dev,
 Nigel Croxon <ncroxon@redhat.com>
References: <20260408043548.1695157-1-bmarzins@redhat.com>
From: Xiao Ni <xni@redhat.com>
In-Reply-To: <20260408043548.1695157-1-bmarzins@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2026/4/8 12:35, Benjamin Marzinski 写道:
> If make_stripe_request() returns STRIPE_WAIT_RESHAPE,
> raid5_make_request() will free the cloned bio. But raid5_make_request()
> can call make_stripe_request() multiple times, writing to the various
> stripes. If that bio got added to the toread or towrite lists of a
> stripe disk in an earlier call to make_stripe_request(), then it's not
> safe to just free the bio if a later part of it is found to cross the
> reshape position. Doing so can lead to a UAF error, when bio_endio()
> is called on the bio for the earlier stripes.
>
> Instead, raid5_make_request() needs to wait until all parts of the bio
> have called bio_endio(). To do this, bios that cross the reshape
> position while the reshape can't make progress are flagged as needing to
> wait for all parts to complete. When raid5_make_request() has a bio that
> failed make_stripe_request() with STRIPE_WAIT_RESHAPE, it sets
> bi->bi_private to a completion struct and waits for completion after
> ending the bio.  When the bio_endio() is called for the last time on a
> clone bio with bi->bi_private set, it wakes up the waiter. This
> guarantees that raid5_make_request() doesn't return until the cloned bio
> needing a retry for io across the reshape boundary is safely cleaned up.
>
> There is a simple reproducer available at [1]. Compile the kernel with
> KASAN for more useful reporting when the error is triggered (this is not
> necessary to see the bug).
>
> [1] https://gist.github.com/bmarzins/e48598824305cf2171289e47d7241fa5
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>
> Changes from v1:
> - Removed mddev->pending_retry_bios, mddev->retry_bios_wait, and
>    md_io_clone->must_retry. Instead, use a completion struct
>    pointed to by bi->bi_private, as suggested by Xiao Ni and Yu Kuai.
>
>   drivers/md/md.c    | 31 ++++++++-----------------------
>   drivers/md/md.h    |  1 -
>   drivers/md/raid5.c |  7 ++++++-
>   3 files changed, 14 insertions(+), 25 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 3ce6f9e9d38e..4318d875a5f6 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9215,9 +9215,11 @@ static void md_bitmap_end(struct mddev *mddev, struct md_io_clone *md_io_clone)
>   
>   static void md_end_clone_io(struct bio *bio)
>   {
> -	struct md_io_clone *md_io_clone = bio->bi_private;
> +	struct md_io_clone *md_io_clone = container_of(bio, struct md_io_clone,
> +						       bio_clone);
>   	struct bio *orig_bio = md_io_clone->orig_bio;
>   	struct mddev *mddev = md_io_clone->mddev;
> +	struct completion *reshape_completion = bio->bi_private;
>   
>   	if (bio_data_dir(orig_bio) == WRITE && md_bitmap_enabled(mddev, false))
>   		md_bitmap_end(mddev, md_io_clone);
> @@ -9229,7 +9231,10 @@ static void md_end_clone_io(struct bio *bio)
>   		bio_end_io_acct(orig_bio, md_io_clone->start_time);
>   
>   	bio_put(bio);
> -	bio_endio(orig_bio);
> +	if (unlikely(reshape_completion))
> +		complete(reshape_completion);
> +	else
> +		bio_endio(orig_bio);
>   	percpu_ref_put(&mddev->active_io);
>   }
>   
> @@ -9254,7 +9259,7 @@ static void md_clone_bio(struct mddev *mddev, struct bio **bio)
>   	}
>   
>   	clone->bi_end_io = md_end_clone_io;
> -	clone->bi_private = md_io_clone;
> +	clone->bi_private = NULL;
>   	*bio = clone;
>   }
>   
> @@ -9265,26 +9270,6 @@ void md_account_bio(struct mddev *mddev, struct bio **bio)
>   }
>   EXPORT_SYMBOL_GPL(md_account_bio);
>   
> -void md_free_cloned_bio(struct bio *bio)
> -{
> -	struct md_io_clone *md_io_clone = bio->bi_private;
> -	struct bio *orig_bio = md_io_clone->orig_bio;
> -	struct mddev *mddev = md_io_clone->mddev;
> -
> -	if (bio_data_dir(orig_bio) == WRITE && md_bitmap_enabled(mddev, false))
> -		md_bitmap_end(mddev, md_io_clone);
> -
> -	if (bio->bi_status && !orig_bio->bi_status)
> -		orig_bio->bi_status = bio->bi_status;
> -
> -	if (md_io_clone->start_time)
> -		bio_end_io_acct(orig_bio, md_io_clone->start_time);
> -
> -	bio_put(bio);
> -	percpu_ref_put(&mddev->active_io);
> -}
> -EXPORT_SYMBOL_GPL(md_free_cloned_bio);
> -
>   /* md_allow_write(mddev)
>    * Calling this ensures that the array is marked 'active' so that writes
>    * may proceed without blocking.  It is important to call this before
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index ac84289664cd..5d57fee22901 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -917,7 +917,6 @@ extern void md_finish_reshape(struct mddev *mddev);
>   void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
>   			struct bio *bio, sector_t start, sector_t size);
>   void md_account_bio(struct mddev *mddev, struct bio **bio);
> -void md_free_cloned_bio(struct bio *bio);
>   
>   extern bool __must_check md_flush_request(struct mddev *mddev, struct bio *bio);
>   void md_write_metadata(struct mddev *mddev, struct md_rdev *rdev,
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index a8e8d431071b..dc0c680ca199 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -6217,7 +6217,12 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
>   
>   	mempool_free(ctx, conf->ctx_pool);
>   	if (res == STRIPE_WAIT_RESHAPE) {
> -		md_free_cloned_bio(bi);
> +		DECLARE_COMPLETION_ONSTACK(done);
> +		WRITE_ONCE(bi->bi_private, &done);
> +
> +		bio_endio(bi);
> +
> +		wait_for_completion(&done);
>   		return false;
>   	}
>   


The patch looks good to me.
Reviewed-by: Xiao Ni <xni@redhat.com>


