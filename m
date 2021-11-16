Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C2C7C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 16 Nov 2021 08:36:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35EA961B2B
	for <linux-raid@archiver.kernel.org>; Tue, 16 Nov 2021 08:36:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbhKPIjr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 16 Nov 2021 03:39:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49378 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232144AbhKPIjq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 16 Nov 2021 03:39:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637051809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GcFix/tkfs9YHtdCP+XpsjHOWfdgliS+ytBTeyjBro4=;
        b=g2t1Ny/2WYLgUgBsqBWxJ5fpQxIjcWmTZTGP6Y1x+79iyvURTjK6/RrHKX2VG10edw/gI+
        Nqmkaon1HfjGLlbKUnmXvf3Un3Io8oIlGmHP5lHgPeO5ewy37knDAg4hOaIFWtlCRiadDo
        CysUiqhxMtJctT3HL2uFCJM02osc87o=
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com
 [209.85.221.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-112-Qyaf7XS2OjOArfBg4KuySA-1; Tue, 16 Nov 2021 03:36:45 -0500
X-MC-Unique: Qyaf7XS2OjOArfBg4KuySA-1
Received: by mail-vk1-f198.google.com with SMTP id k19-20020a05612212f300b002f9b9e6a997so7817871vkp.19
        for <linux-raid@vger.kernel.org>; Tue, 16 Nov 2021 00:36:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GcFix/tkfs9YHtdCP+XpsjHOWfdgliS+ytBTeyjBro4=;
        b=IQYhGRl/JSi7VeiQjq0ar1hDdqQu05ZjVDEPGgfzULt/wTJIempoR7lo6S/HmSNEj9
         ww7j51d6+XGEpO5lPTqeLy4SRONv5JHd1KRswHPhxOq6RtAVez1+5KfWowX6UWGIoPgR
         fXqn8yINET1MnhJR5Z8loVzLRIzdyXHNXRTh2VPT8XATDluKahNrkBYmRnRwXdC0V1wi
         GzJA77SwcPiqb8Bv4Kkh7COZgqhgawZQLtvsd6DqjYE79k3sYR9tKccGc78hAj47XHIO
         CjN6RSqh+LzZOnTEQySAYe/WCLCfJNMLnRea14VPinQYjkNGi6mQv9ZVn2cmqqC31FT7
         6pWQ==
X-Gm-Message-State: AOAM5337b+yvRDBaql22/lTJdikeqjkTqfwkLBMRWkcExThQvDAsboSu
        UshxfpfWOhH/k8QnYZaT8S1QOnQisiN1CjUQEFBLz2JGT1ODIW1y+mus0T+pXNPwFfV98dVnPib
        sJf7iWRUoq4BsrvNExqUhPvYXH3cBv1i+G0SHPQ==
X-Received: by 2002:ab0:1c02:: with SMTP id a2mr8208753uaj.115.1637051804564;
        Tue, 16 Nov 2021 00:36:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxtDyjOdp1P6lieRsJSTmot1mQCqnHW4Iq/3au7RMisue4jWsbuNbrsMY0aDbbJDsnB10ZKT2boCYNSt2TzCqA=
X-Received: by 2002:ab0:1c02:: with SMTP id a2mr8208731uaj.115.1637051804420;
 Tue, 16 Nov 2021 00:36:44 -0800 (PST)
MIME-Version: 1.0
References: <20211112142822.813606-1-markus@hochholdinger.net>
In-Reply-To: <20211112142822.813606-1-markus@hochholdinger.net>
From:   Xiao Ni <xni@redhat.com>
Date:   Tue, 16 Nov 2021 16:36:33 +0800
Message-ID: <CALTww29WySQFumqc1Qo44Xj85pqDA5POz_AXZryY3YLM3-L+Uw@mail.gmail.com>
Subject: Re: [PATCH] md: fix update super 1.0 on rdev size change
To:     Markus Hochholdinger <markus@hochholdinger.net>
Cc:     Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Nov 12, 2021 at 10:29 PM <markus@hochholdinger.net> wrote:
>
> From: Markus Hochholdinger <markus@hochholdinger.net>
>
> The superblock of version 1.0 doesn't get moved to the new position on a
> device size change. This leads to a rdev without a superblock on a known
> position, the raid can't be re-assembled.
>
> Fixes: commit d9c0fa509eaf ("md: fix max sectors calculation for super 1.0")
> ---
>  drivers/md/md.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 6c0c3d0d905a..ad968cfc883d 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2193,6 +2193,7 @@ super_1_rdev_size_change(struct md_rdev *rdev, sector_t num_sectors)
>
>                 if (!num_sectors || num_sectors > max_sectors)
>                         num_sectors = max_sectors;
> +               rdev->sb_start = sb_start;
>         }
>         sb = page_address(rdev->sb_page);
>         sb->data_size = cpu_to_le64(num_sectors);
> --
> 2.30.2
>

Reviewd-by: Xiao Ni <xni@redhat.com>

