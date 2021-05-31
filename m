Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B9B6C47080
	for <linux-raid@archiver.kernel.org>; Mon, 31 May 2021 22:53:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2C5261186
	for <linux-raid@archiver.kernel.org>; Mon, 31 May 2021 22:53:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbhEaWzd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 31 May 2021 18:55:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231859AbhEaWzc (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 31 May 2021 18:55:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 277BD61186
        for <linux-raid@vger.kernel.org>; Mon, 31 May 2021 22:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622501632;
        bh=dVVQITWqJH7P49l5yiySRFppoKhbGuFeVKzK6cZCzBo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Y6FCAYrnjb4qHsCZ42j+WPnOrdU0uuQZnHpIg1UZSEDhvV+qrDwCFoi1RQhd2KueV
         RhmbRl6JygsXzmu3BWiNWfWsYCp7ZVrXXU66BvpDvhB0i3cInxVecUtZatAQlZyG/d
         a0sFQE1Go+i1s1mRm/VtRykYK/z8Nbk/OfzmT/7Il4YQhYeiN66a8+H1gHaGzsQnmZ
         hewUBz3n7dhpWDLlLCFNBGK6lszrbcMWIJFhmToS2eilJIJiN3B2sZwWCVbpRHd17u
         lXwJNVlUij1vrmuz4ZvI9qSNDnI18uZVeEPTGqYGwxB4ScbGY+VFBFm2L5a72zbKmi
         7entNypOTCeYQ==
Received: by mail-lf1-f47.google.com with SMTP id f30so18838464lfj.1
        for <linux-raid@vger.kernel.org>; Mon, 31 May 2021 15:53:52 -0700 (PDT)
X-Gm-Message-State: AOAM533L6Ex4zLM2UAYVkpGjt1r966f7EF6nuZwaTey59QZDuXx4ER9j
        TnXn0uFk9wzVqnvhXHm3Zj463S96fSjTssfrW2Q=
X-Google-Smtp-Source: ABdhPJzlEpzfMlIZkvDTMSEJ25VKhqrt98t736p2Np3H8Dmi/BykuXyvWcT/0mWYsD5YzCCW7VBXjfyMa+YalbY92pM=
X-Received: by 2002:a19:c70c:: with SMTP id x12mr7663025lff.281.1622501630521;
 Mon, 31 May 2021 15:53:50 -0700 (PDT)
MIME-Version: 1.0
References: <1622182598-13110-1-git-send-email-xni@redhat.com>
In-Reply-To: <1622182598-13110-1-git-send-email-xni@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 31 May 2021 15:53:39 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5O0ii77JFpYTB+RyPKzHmqQDGdr+8wMC4=CNtv=_daNg@mail.gmail.com>
Message-ID: <CAPhsuW5O0ii77JFpYTB+RyPKzHmqQDGdr+8wMC4=CNtv=_daNg@mail.gmail.com>
Subject: Re: [PATCH 1/1] It needs to check offset array is NULL or not in async_xor_offs
To:     Xiao Ni <xni@redhat.com>, oleksandr.shchirskyi@linux.intel.com
Cc:     Nigel Croxon <ncroxon@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, May 27, 2021 at 11:16 PM Xiao Ni <xni@redhat.com> wrote:
>
> Now we support sharing one big page when PAGE_SIZE is not equal 4096.
> 4096 bytes is the default stripe size. To support this it adds a
> page offset array in raid5_percpu's scribble. It passes the page
> offset array to async_xor_offs. But there are some users that don't
> use the page offset array. In raid5-ppl.c, async_xor passes NULL to
> asynx_xor_offs. So it needs to check src_offs is NULL or not.
>
> Fixes: ceaf2966ab08(async_xor: increase src_offs when dropping destination page)
> Reported-by: Oleksandr Shchirskyi <oleksandr.shchirskyi@linux.intel.com>
> Signed-off-by: Xiao Ni <xni@redhat.com>

Oleksandr,

Could you please verify this fixes the issue, and reply with your Tested-by?

Thanks,
Song

> ---
>  crypto/async_tx/async_xor.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
> index 6cd7f70..d8a9152 100644
> --- a/crypto/async_tx/async_xor.c
> +++ b/crypto/async_tx/async_xor.c
> @@ -233,7 +233,8 @@ async_xor_offs(struct page *dest, unsigned int offset,
>                 if (submit->flags & ASYNC_TX_XOR_DROP_DST) {
>                         src_cnt--;
>                         src_list++;
> -                       src_offs++;
> +                       if (src_offs)
> +                               src_offs++;
>                 }
>
>                 /* wait for any prerequisite operations */
> --
> 2.7.5
>
