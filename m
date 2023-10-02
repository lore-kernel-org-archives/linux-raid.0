Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAD71E74914
	for <linux-raid@archiver.kernel.org>; Mon,  2 Oct 2023 19:23:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238857AbjJBTX0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 2 Oct 2023 15:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjJBTX0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 2 Oct 2023 15:23:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2BDCCE
        for <linux-raid@vger.kernel.org>; Mon,  2 Oct 2023 12:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696274559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JrEyhlb8MAYDRVx2CSSsRATPxJkI5kGzkzwmoPYXqrI=;
        b=KHkL7bx1yKIsh3l9DCZdFBwVqO9Sdwb66NQ7lI0NS96+TXxZAwH94abbjYBgvum7VLu5dt
        QAOQCWHTrm6OoMfMmkZFXfCgeaK2yQZy1uux8S6BER+Qvb/k1FWlKysOtKGDMQg9FPGf2W
        anV0LNEGFUErCqIj+QD8FiqrloNWJ/M=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-Gu-iG11hP_28Z7pUjrc5-Q-1; Mon, 02 Oct 2023 15:22:37 -0400
X-MC-Unique: Gu-iG11hP_28Z7pUjrc5-Q-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-5a21c283542so1905427b3.3
        for <linux-raid@vger.kernel.org>; Mon, 02 Oct 2023 12:22:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696274556; x=1696879356;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JrEyhlb8MAYDRVx2CSSsRATPxJkI5kGzkzwmoPYXqrI=;
        b=JmFQgYwuX4dfhsgXA86FeOosDGABTX5wGuci63HI/OWbzyNrQrxoIrwGfwWu1nZsWl
         oqGL5+e99Ybgt/8gC6MrECEnO4TL75ospDVoujnJebV13JwafGX2a/jSRLfYKyvofr8i
         0Ryq/Qq0zeqzMXzlCukHMXZ5w4y+XAdpxESYrUM33MsY7aBE3nv/Thw+HkHCkxA2E2Cg
         46vBKfkAaHV4d6VzdCOM7hjXg5uL7xw/a/uPeVaxsqhZz8sTZFWgwa3xd/UFGbWIegzC
         j2HI1sTH6CSqH5YZGffb7CyGF9RDHGBuSPI2Yc0yOrdvyxkIxW+iy3JiHZXLXiDl/5Fw
         9Emg==
X-Gm-Message-State: AOJu0YwNgkd3GK6n3bLFEMg1/ZWTXXuWz/oVIftUPKBqAKjkUzx0Nm2Q
        pldEc4EcxOJpiJNGwuLETolFbYEpWhH/fzFKWm2EHkPVqwJJ2h1C4scMdYj2pFaKPTvZ0/fNv6a
        27P2rDyUaOkPDdgRmr1T24ysZuyCzvtimjL5Y6Q==
X-Received: by 2002:a0d:d651:0:b0:59b:e5f6:fa2c with SMTP id y78-20020a0dd651000000b0059be5f6fa2cmr11701258ywd.15.1696274556124;
        Mon, 02 Oct 2023 12:22:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHFlp37s2wO8FHsG8hovc/4mUWoH0MkTFVdIK8SJil8BFlkfqI9D1ftnPmHWRpdaFS2nKOYHuNUOvdSoeFrcpw=
X-Received: by 2002:a0d:d651:0:b0:59b:e5f6:fa2c with SMTP id
 y78-20020a0dd651000000b0059be5f6fa2cmr11701253ywd.15.1696274555899; Mon, 02
 Oct 2023 12:22:35 -0700 (PDT)
MIME-Version: 1.0
References: <20231002183422.13047-1-djeffery@redhat.com>
In-Reply-To: <20231002183422.13047-1-djeffery@redhat.com>
From:   John Pittman <jpittman@redhat.com>
Date:   Mon, 2 Oct 2023 15:21:59 -0400
Message-ID: <CA+RJvhxrkSXRPc9wELyfYYCy_dpRaa+9=fTY7NQR0tP=MO8xUQ@mail.gmail.com>
Subject: Re: [PATCH] md/raid5: release batch_last before waiting for another stripe_head
To:     David Jeffery <djeffery@redhat.com>
Cc:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        Laurence Oberman <loberman@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Thanks a lot David.  Song, as a note, David's patch was tested by a
Red Hat customer and it indeed resolved their hit on the deadlock.
cc. Laurence Oberman who assisted on that case.


On Mon, Oct 2, 2023 at 2:39=E2=80=AFPM David Jeffery <djeffery@redhat.com> =
wrote:
>
> When raid5_get_active_stripe is called with a ctx containing a stripe_hea=
d in
> its batch_last pointer, it can cause a deadlock if the task sleeps waitin=
g on
> another stripe_head to become available. The stripe_head held by batch_la=
st
> can be blocking the advancement of other stripe_heads, leading to no
> stripe_heads being released so raid5_get_active_stripe waits forever.
>
> Like with the quiesce state handling earlier in the function, batch_last
> needs to be released by raid5_get_active_stripe before it waits for anoth=
er
> stripe_head.
>
>
> Fixes: 3312e6c887fe ("md/raid5: Keep a reference to last stripe_head for =
batch")
> Signed-off-by: David Jeffery <djeffery@redhat.com>
>
> ---
>  drivers/md/raid5.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 6383723468e5..0644b83fd3f4 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -854,6 +854,13 @@ struct stripe_head *raid5_get_active_stripe(struct r=
5conf *conf,
>
>                 set_bit(R5_INACTIVE_BLOCKED, &conf->cache_state);
>                 r5l_wake_reclaim(conf->log, 0);
> +
> +               /* release batch_last before wait to avoid risk of deadlo=
ck */
> +               if (ctx && ctx->batch_last) {
> +                       raid5_release_stripe(ctx->batch_last);
> +                       ctx->batch_last =3D NULL;
> +               }
> +
>                 wait_event_lock_irq(conf->wait_for_stripe,
>                                     is_inactive_blocked(conf, hash),
>                                     *(conf->hash_locks + hash));
> --
> 2.41.0
>

