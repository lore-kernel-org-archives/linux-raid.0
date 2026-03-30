Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78F736E477
	for <linux-raid@vger.kernel.org>; Mon, 30 Mar 2026 15:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774885512; cv=pass; b=kyGZ4b9Bbfry51ffcqexWcHzBqcBz48mV13d5CeUDT5eMhFgOXsjdgZgrkH7+Ae/fE8nhG6s/X4pQ7t5XxlY85utsHbzEA2YMeexobFdXAhcnsRHcjy/ejf/d7UfgAYIdWP+TrhlxHzQikJUMzD+HDO1L4nReXFD22zqSZH7w94=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774885512; c=relaxed/simple;
	bh=clMFn6LeqeExwLBSMwZg3FNUW8BmcLV/fu6N7kWmEho=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HyYkWg6eyfZZ5TDEEHoRnyI8+UD6ggbXZYW4rnkikvhsRBLC2WqkqJqUWmGHIt5en80wqMTrW4Yh4g8mbKKq9S2pJy0Y/J1r5CgGxvVAPYaSmUe0LEmoAU5SmEYZP+HMnIXfDNb2jdJ1RZ6XEISNZ/1e3xe2EKnwTw+cIv67VCc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aVKUOgw/; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=QUAfj4nv; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aVKUOgw/";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="QUAfj4nv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774885509;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q2fpwV21eEfYg1bRyhm2N0jS6bpZE9oTFvRhGC6h12M=;
	b=aVKUOgw/qGNUzymgcRQbwEiSUkSfQmNM5IezgWRFFK3xxTB8EaGDe1oYDm6pd0ANZSa9Y9
	TDMz2HKzhARy0ecMn6qI+ypJh/UI8WxMBz+0nRXYEsdicF6OS+MMR+ZNhKX+L5eo4IN8CJ
	7Y6N8LuqZ3wF2cC5zhKCgHcQFOHluQU=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-92PSYvD2PjG5w4z1xxoMIw-1; Mon, 30 Mar 2026 11:45:08 -0400
X-MC-Unique: 92PSYvD2PjG5w4z1xxoMIw-1
X-Mimecast-MFC-AGG-ID: 92PSYvD2PjG5w4z1xxoMIw_1774885507
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5a12f7bb92fso2692140e87.2
        for <linux-raid@vger.kernel.org>; Mon, 30 Mar 2026 08:45:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774885507; cv=none;
        d=google.com; s=arc-20240605;
        b=l3mxC0bgZYBfYpQSLHCPmtvmubLQnlkb0d5NbLjPAmFkD21oHSokBC/4Q+EnwIW0xE
         82N7kPZDv/GjusMhoJZYJy2ndsoFLqPpjYaeZEhWhTCyt6BDq553kExThgqexwEWCOfF
         5WY+YVbMGgCFvoGNKGK9oQEm7Tcdax9vFaFJmkvdzmI9yXQGC7GfJkYORr5Zr9XADgiO
         Di15QnhrAmRIee31+qGMMdfF82a/8BXqvVwpERhrzng3zmBLqRG7zLHCI2au3G4LoroY
         r37rBaZNsVpUqjRsVbUyNgiPaRxifMoAZYqz5gwbFKH/LLT2fowfnAOYfbz3Z9EGsKWt
         FUtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Q2fpwV21eEfYg1bRyhm2N0jS6bpZE9oTFvRhGC6h12M=;
        fh=36XfvzNQGI9qfXANvmQQ7NcoquSU7E24NLS13FfyM4s=;
        b=k/AcQFVpgcwp/ZiWgNYndlu4LrYGRPxWlUaTXf1M5Ty4DALxu2x3XKdU0KGUkBoiWp
         pE+VOqtIOlDE/uhZA+4SrCkx+RAGcQhoTHYH0dprcpxF/89tH57Ntsj9y2bCUbAMWAWh
         CzZEv4ycbxgMoc7iFfeYNxwSBXEKlES01JRNhDvS6c2uonXmUOB3Xx6CKhHqs41TVp5j
         hfdDzLxC7/1CUsoCBb0mtsV24I0ykVDB4HshdRwmVj1xYyMGfovHxVxNSez0CbKJqATh
         DZV2ewWn0Cwk/az/HpyThI8EwCHlf0nZiRAwk0yl/sunmLiaMDi+no5te5X9iH9FjcMj
         M7rg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1774885507; x=1775490307; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q2fpwV21eEfYg1bRyhm2N0jS6bpZE9oTFvRhGC6h12M=;
        b=QUAfj4nvp6+lf498F0HCSWp7UDQniTyVx1Q2fcVXNYqXyNVtl0Ri/A2/+A0wSBl1MX
         WEIgo8Um28pLaQXe8otUehdXAjHjIvGYoowKVqWVrYH/GmH0BWDc117AKLqSxfhJvsZ8
         YfjQe3AImYZEQFUynL2iRhr1YsGlzHxxx11qik7VgPCBUr4cZk2P3/y5Em4PIhWQO8w2
         qHUFtkbhKTQPhZwWAZo1mgwN+XLwgcAQ8JTjLiFxPTLo+BsSxM0SAT7WmQwPe2HbZzlz
         CO2KWedKcNH1pwibhbwz9RKs6osHj51fJdHHR0DihTIFzXaZAWoSog7NT2ntRvv8bkqJ
         Hspg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774885507; x=1775490307;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q2fpwV21eEfYg1bRyhm2N0jS6bpZE9oTFvRhGC6h12M=;
        b=GMKInXtgfHNJHiExF/darcKv47qrbuzWItzkvYNnXCYP50o4TOqLNsM5knffNB0Zin
         rl1Dk8GrJMDfi1hv+4AZHRONMVnIuHDcJgakGfV2ZHF+cnppGIXm7rxd0XrBCBPBxo3j
         5jSrt5+1s3JO3QZv1QIb8CWqfUJR5O3b5f2gs2S8VDMPM+pUSq0+LBENiGh/taNazsu7
         sCt3OpEeys0/oJ3aS0ulfZDCvhUD3JTnFEuJWoCmB8dvImg7uGayqidiSLclAZK7uYYH
         qEfvtxKALe4XUhsoSVUGxqwph+uRnAWwdSV0d+G7UA4oAzV7aCFk8LQdJMkmvRllixUB
         nnxg==
X-Forwarded-Encrypted: i=1; AJvYcCXnlb6FHeQ25OXS6U6agQ6elADkr6vl3ivpj7k7gDCiAME6Dij1LuOJeYQ6/KLgMsjUOm9bn8EPHaa5@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2vUNFCzxZYaX8hJVtd9O/IrFhFgYn+kBYYgMrKuxFWnueXAgb
	3yCG68tFoovYX4a4wE+14+b1u697LV7h78fBfUiFuSB3hyxcoMgQ0TeTE9Q/EyoASvVvk2sJk9B
	Dsbb/5e+G1x+RDuO/f5uF2DdW5RIGUCOeRrhVwrGamtg6Vt0wUQAV0DD009FzysADlUYodUNki5
	j2WQCniwN0ClCSUu+kvH+JXbnWVYnXUZ7zAlZGFg==
X-Gm-Gg: ATEYQzxH4w6apN07vFGAl+eXB53XnKA1n6TF6D3huLQiVe38lwVfE7oQju87/7D0Ua8
	KrQxu398VkomRBpaa64p+326Y5UteBqfz4//3PhJIsQJY/y5PFTouyL3NgqBe+tT5SIBoabrZTQ
	jhGFktW/g2siMaH86UXwT0gnLZuCoM36SDYdghK2fcgh7AVitj9Ew44KIN9f23PkPAHLHGGmYSH
	s+/Dm1l92/IJezpAWgPVHMFXtIT48YxFnL5KnswsbHpI7hLUm7/4MrKeH/KXtpbsaPiZ0DHbVhQ
	l0EmgQ==
X-Received: by 2002:ac2:5d68:0:b0:5a2:afe8:78b9 with SMTP id 2adb3069b0e04-5a2afe87992mr2267600e87.13.1774885506634;
        Mon, 30 Mar 2026 08:45:06 -0700 (PDT)
X-Received: by 2002:ac2:5d68:0:b0:5a2:afe8:78b9 with SMTP id
 2adb3069b0e04-5a2afe87992mr2267594e87.13.1774885505976; Mon, 30 Mar 2026
 08:45:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260323225836.1037060-1-bmarzins@redhat.com>
In-Reply-To: <20260323225836.1037060-1-bmarzins@redhat.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 30 Mar 2026 23:44:54 +0800
X-Gm-Features: AQROBzAusW0h_JAHf1ndCyc4ClNsKn5fTH_vR62bKIDn10uFapGpXm-4FYxhVvg
Message-ID: <CALTww29P_jZ-n9GMgFG0EW_N22vUsGAPJ5OGn5Lw8yfEpEoGOw@mail.gmail.com>
Subject: Re: [RFC PATCH] md/raid5: Fix UAF on IO across the reshape position
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Song Liu <song@kernel.org>, 
	Yu Kuai <yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com>, 
	Li Nan <linan122@huawei.com>, linux-raid@vger.kernel.org, dm-devel@lists.linux.dev, 
	Nigel Croxon <ncroxon@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 24, 2026 at 6:58=E2=80=AFAM Benjamin Marzinski <bmarzins@redhat=
.com> wrote:
>
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
> position while the reshape can't make progress are flagged as needing a
> retry, and mddev tracks the number of bios needing a retry which have
> not yet completed. When raid5_make_request() has a bio that failed
> make_stripe_request() with STRIPE_WAIT_RESHAPE, it waits for this
> counter to reach zero. When the bio_endio() is called for the last time
> on a bio needing a retry, it decrements mddev's count of outstanding
> bios needing a retry. This guarantees that raid5_make_request() doesn't
> return until the cloned bio needing a retry for io across the reshape
> boundary is safely cleaned up.
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
> I've tested this for regressions with the lvm2-testsuite raid tests. I
> have not run any md-specific tests on it.
>
>
>  drivers/md/md.c    | 30 +++++++++---------------------
>  drivers/md/md.h    |  5 ++++-
>  drivers/md/raid5.c |  8 +++++++-
>  3 files changed, 20 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 3ce6f9e9d38e..5ec116b9da32 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -776,9 +776,11 @@ int mddev_init(struct mddev *mddev)
>         atomic_set(&mddev->active, 1);
>         atomic_set(&mddev->openers, 0);
>         atomic_set(&mddev->sync_seq, 0);
> +       atomic_set(&mddev->pending_retry_bios, 0);
>         spin_lock_init(&mddev->lock);
>         init_waitqueue_head(&mddev->sb_wait);
>         init_waitqueue_head(&mddev->recovery_wait);
> +       init_waitqueue_head(&mddev->retry_bios_wait);
>         mddev->reshape_position =3D MaxSector;
>         mddev->reshape_backwards =3D 0;
>         mddev->last_sync_action =3D ACTION_IDLE;
> @@ -9218,6 +9220,7 @@ static void md_end_clone_io(struct bio *bio)
>         struct md_io_clone *md_io_clone =3D bio->bi_private;
>         struct bio *orig_bio =3D md_io_clone->orig_bio;
>         struct mddev *mddev =3D md_io_clone->mddev;
> +       unsigned int must_retry =3D md_io_clone->must_retry;
>
>         if (bio_data_dir(orig_bio) =3D=3D WRITE && md_bitmap_enabled(mdde=
v, false))
>                 md_bitmap_end(mddev, md_io_clone);
> @@ -9229,7 +9232,11 @@ static void md_end_clone_io(struct bio *bio)
>                 bio_end_io_acct(orig_bio, md_io_clone->start_time);
>
>         bio_put(bio);
> -       bio_endio(orig_bio);
> +       if (unlikely(must_retry)) {
> +               if (atomic_dec_and_test(&mddev->pending_retry_bios))
> +                       wake_up(&mddev->retry_bios_wait);
> +       } else
> +               bio_endio(orig_bio);
>         percpu_ref_put(&mddev->active_io);
>  }
>
> @@ -9243,6 +9250,7 @@ static void md_clone_bio(struct mddev *mddev, struc=
t bio **bio)
>         md_io_clone =3D container_of(clone, struct md_io_clone, bio_clone=
);
>         md_io_clone->orig_bio =3D *bio;
>         md_io_clone->mddev =3D mddev;
> +       md_io_clone->must_retry =3D 0;
>         if (blk_queue_io_stat(bdev->bd_disk->queue))
>                 md_io_clone->start_time =3D bio_start_io_acct(*bio);
>
> @@ -9265,26 +9273,6 @@ void md_account_bio(struct mddev *mddev, struct bi=
o **bio)
>  }
>  EXPORT_SYMBOL_GPL(md_account_bio);
>
> -void md_free_cloned_bio(struct bio *bio)
> -{
> -       struct md_io_clone *md_io_clone =3D bio->bi_private;
> -       struct bio *orig_bio =3D md_io_clone->orig_bio;
> -       struct mddev *mddev =3D md_io_clone->mddev;
> -
> -       if (bio_data_dir(orig_bio) =3D=3D WRITE && md_bitmap_enabled(mdde=
v, false))
> -               md_bitmap_end(mddev, md_io_clone);
> -
> -       if (bio->bi_status && !orig_bio->bi_status)
> -               orig_bio->bi_status =3D bio->bi_status;
> -
> -       if (md_io_clone->start_time)
> -               bio_end_io_acct(orig_bio, md_io_clone->start_time);
> -
> -       bio_put(bio);
> -       percpu_ref_put(&mddev->active_io);
> -}
> -EXPORT_SYMBOL_GPL(md_free_cloned_bio);
> -
>  /* md_allow_write(mddev)
>   * Calling this ensures that the array is marked 'active' so that writes
>   * may proceed without blocking.  It is important to call this before
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index ac84289664cd..49a231f11676 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -626,6 +626,9 @@ struct mddev {
>
>         /* The sequence number for sync thread */
>         atomic_t sync_seq;
> +
> +       wait_queue_head_t               retry_bios_wait;
> +       atomic_t                        pending_retry_bios;
>  };
>
>  enum recovery_flags {
> @@ -877,6 +880,7 @@ struct md_io_clone {
>         sector_t        offset;
>         unsigned long   sectors;
>         enum stat_group rw;
> +       unsigned int    must_retry;
>         struct bio      bio_clone;
>  };
>
> @@ -917,7 +921,6 @@ extern void md_finish_reshape(struct mddev *mddev);
>  void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
>                         struct bio *bio, sector_t start, sector_t size);
>  void md_account_bio(struct mddev *mddev, struct bio **bio);
> -void md_free_cloned_bio(struct bio *bio);
>
>  extern bool __must_check md_flush_request(struct mddev *mddev, struct bi=
o *bio);
>  void md_write_metadata(struct mddev *mddev, struct md_rdev *rdev,
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index a8e8d431071b..fb78a757f2fd 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -6217,7 +6217,13 @@ static bool raid5_make_request(struct mddev *mddev=
, struct bio * bi)
>
>         mempool_free(ctx, conf->ctx_pool);
>         if (res =3D=3D STRIPE_WAIT_RESHAPE) {
> -               md_free_cloned_bio(bi);
> +               struct md_io_clone *md_io_clone =3D bi->bi_private;
> +
> +               md_io_clone->must_retry =3D 1;
> +               atomic_inc(&mddev->pending_retry_bios);
> +               bio_endio(bi);
> +               wait_event(mddev->retry_bios_wait,
> +                          atomic_read(&mddev->pending_retry_bios)=3D=3D0=
);

Hi Ben

There is a problem here. The new counter pending_retry_bios above
doesn't represent the bios which have been added to stripes. So uaf
still can happen. Do we need to add a new counter? Because
md_end_clone_io is only called when all bios return. How about
something like:

md_end_clone_io
+       if (unlikely(READ_ONCE(md_io_clone->waiting_reshape))) {
+               complete(md_io_clone->reshape_completion);
+       } else {
+               bio_endio(orig_bio);
+       }

raid5_make_request:

        if (res =3D=3D STRIPE_WAIT_RESHAPE) {
-               md_free_cloned_bio(bi);
+               struct md_io_clone *md_io_clone =3D bi->bi_private;
+               struct completion done;
+
+               init_completion(&done);
+               md_io_clone->reshape_completion =3D &done;
+               WRITE_ONCE(md_io_clone->waiting_reshape, 1);
+
+               bio_endio(bi);
+
+               wait_for_completion(&done);

Best Regards
Xiao


>                 return false;
>         }

>
> --
> 2.53.0
>

