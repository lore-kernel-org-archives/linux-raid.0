Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71128C433F5
	for <linux-raid@archiver.kernel.org>; Wed, 17 Nov 2021 07:06:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5601D61BF9
	for <linux-raid@archiver.kernel.org>; Wed, 17 Nov 2021 07:06:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233663AbhKQHJb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 17 Nov 2021 02:09:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:49236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232468AbhKQHJa (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 17 Nov 2021 02:09:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B8D361BF8;
        Wed, 17 Nov 2021 07:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637132792;
        bh=deQ+3gejzFlrmih5ge8vkutNVzvY5ImiHHpeuLw/QWk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=mQn5dNlhb0fduIs8ZwcOnVMhxem3w6hCOM/fAADHtK+on2+/KWK3B3kOJstFcrmdZ
         1yP/MQA0HV3HY1peg2OtacmKdV0+L5kzhDdv7bMSRqPN77f8UPit75DmdvPeN2SJoP
         3/CQzXim+NO6KIzWOdBbkwS3PyAtZpQlbnnQTWkPFykzZ5HZg56fCVabGnzyQd74sq
         tgyjXnCxwPc49wnyoI4PypWdujqq4gsqP37dqrnUx4ZEfl3uzH9i5gnzl2QwH8hpU8
         g6R3cZ+pM9WuQNGof18FIwoSnNuS4liGj+kI9u0IazoXHSsS6vENBBOIdrV6bP/+z5
         Ou3x3VkQz0jlw==
Received: by mail-yb1-f169.google.com with SMTP id i194so4555594yba.6;
        Tue, 16 Nov 2021 23:06:32 -0800 (PST)
X-Gm-Message-State: AOAM533Abg9TPeseaRVFXxJOG7rz7M8hUy+sm+lki+BwJUXk8ecu8RM5
        S8ZEn3Fvt3cbsFNWV/1E3YRh6c8dUyskIcF3qkA=
X-Google-Smtp-Source: ABdhPJwp1vIoZpvK3B9DRiT0ofiXZ7TgZosM9giZ5+9CRcwiVKwTLxxnuVflxN8EdJkJYtpEmzPuLhi0GMBPZvOPfNc=
X-Received: by 2002:a25:344d:: with SMTP id b74mr15107301yba.317.1637132791830;
 Tue, 16 Nov 2021 23:06:31 -0800 (PST)
MIME-Version: 1.0
References: <20211115031817.4193-1-bernard@vivo.com>
In-Reply-To: <20211115031817.4193-1-bernard@vivo.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 16 Nov 2021 23:06:21 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6ui=wBrToYkqEOpLyLYhjHMoy0mL0UMcXnq0ObKLLhoA@mail.gmail.com>
Message-ID: <CAPhsuW6ui=wBrToYkqEOpLyLYhjHMoy0mL0UMcXnq0ObKLLhoA@mail.gmail.com>
Subject: Re: [PATCH] drivers/md: fix potential memleak
To:     bernard@vivo.com
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, Nov 14, 2021 at 7:18 PM Bernard Zhao <bernard@vivo.com> wrote:
>
> In function get_bitmap_from_slot, when md_bitmap_create failed,
> md_bitmap_destroy must be called to do clean up.

Could you please explain which variable(s) need clean up?

Thanks,
Song

>
> Signed-off-by: Bernard Zhao <bernard@vivo.com>
> ---
>  drivers/md/md-bitmap.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index bfd6026d7809..a227bd0b9301 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -1961,6 +1961,7 @@ struct bitmap *get_bitmap_from_slot(struct mddev *mddev, int slot)
>         bitmap = md_bitmap_create(mddev, slot);
>         if (IS_ERR(bitmap)) {
>                 rv = PTR_ERR(bitmap);
> +               md_bitmap_destroy(mddev)
>                 return ERR_PTR(rv);
>         }
>
> --
> 2.33.1
>
