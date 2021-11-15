Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 066BBC433EF
	for <linux-raid@archiver.kernel.org>; Mon, 15 Nov 2021 09:48:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D222F61BD3
	for <linux-raid@archiver.kernel.org>; Mon, 15 Nov 2021 09:48:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbhKOJvE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 15 Nov 2021 04:51:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46976 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230414AbhKOJvB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 15 Nov 2021 04:51:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636969685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D5Vu+21xTAIQNDymHcjOVqSfvf0i8nOTxLCuZ+4oZ5o=;
        b=AglHNBMc7SVlDerua1BUmyJdWMQvC67HPb7/CwjGuwIQe5GRC+8EH+MkLp/xzXUB0jnnND
        K7sT9LcUX2Jb4vP6UH/A3xKiigSzUzcUoegntpEtac1jPEJQw3oaHFPANxgMJepz72SfLe
        wWjZZy2uLykl0oqDHB3KjnYdiVX+Tjw=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-DCzycm5hMUqQsQ6fdKNMUg-1; Mon, 15 Nov 2021 04:47:24 -0500
X-MC-Unique: DCzycm5hMUqQsQ6fdKNMUg-1
Received: by mail-ed1-f69.google.com with SMTP id h18-20020a056402281200b003e2e9ea00edso13452857ede.16
        for <linux-raid@vger.kernel.org>; Mon, 15 Nov 2021 01:47:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D5Vu+21xTAIQNDymHcjOVqSfvf0i8nOTxLCuZ+4oZ5o=;
        b=ZxIaBdTCjyZUs5XXAZ5pspmoVLrvH10SlAAvwmbT386KmkPCJ1j7q+QXcoxoYagvys
         mlVzB9AiTPhDaeWXMSgaKO2kyMylUGTwvdvJeLnmylGExhOlUncVuNE1Q+Ym1NTeS0ON
         XpOwEysNQOFH9gIdUf1JVoMsd+3aVjg9uzYxl2h5sd8G1eXaa9/G2ZIhoGBb8njN3JUg
         miYGd48a1J4AcxKVCj9sJztyNLFk7NoUA74ofxANrhZCSMC8O4flSLeIkmcV5EUsTvim
         PnuRGZzjASEgWd2mvZs2UXx5ngj1Va7MDf8zcIO+fSy0I+q6jELpnU4tA4Fn55sbLB+K
         aIew==
X-Gm-Message-State: AOAM533YiPI81O4Wc/rrr/sz/UbnNAExjMaxjoiAop9egllKVcfegiwU
        akH3HYNkpdjfAdXbJ9e3f2ivVwbI5ExVMPIcf+4svQRsvv+x++RdKdwczDDIVoPGUKLul77KDPu
        vFuKH+060f8fZWY1UCpbMz6MKt+xLoYeXXcEHSw==
X-Received: by 2002:aa7:dbca:: with SMTP id v10mr52658760edt.280.1636969643239;
        Mon, 15 Nov 2021 01:47:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy29CVcde6HuHTBTykC0EBr7ocHVI+0SgVt1dVzAjaFlmLtWSPycwslMgUz5FrnGDswtNdkP5uJ6ZPy1qnY9Co=
X-Received: by 2002:aa7:dbca:: with SMTP id v10mr52658736edt.280.1636969643106;
 Mon, 15 Nov 2021 01:47:23 -0800 (PST)
MIME-Version: 1.0
References: <20211112142822.813606-1-markus@hochholdinger.net>
In-Reply-To: <20211112142822.813606-1-markus@hochholdinger.net>
From:   Xiao Ni <xni@redhat.com>
Date:   Mon, 15 Nov 2021 17:47:12 +0800
Message-ID: <CALTww28689G2xbZ9sWFpviXLwB1WKPfQL6Y1girjiBMEvWcQRw@mail.gmail.com>
Subject: Re: [PATCH] md: fix update super 1.0 on rdev size change
To:     markus@hochholdinger.net
Cc:     Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Markus

The sb_start doesn't change in function super_1_rdev_size_change. For super1.0
the super start is always at a fixed position. Is there a possibility
the disk size
changes? sb_start is calculated based on i_size_read(rdev->bdev->bd_inode).

By the way, can you reproduce this problem? If so, could you share
your test steps?

Regards
Xiao

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

