Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B22DCC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 26 Jul 2022 04:55:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbiGZEzv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 26 Jul 2022 00:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbiGZEzu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 26 Jul 2022 00:55:50 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2182A13F60
        for <linux-raid@vger.kernel.org>; Mon, 25 Jul 2022 21:55:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 56379CE1726
        for <linux-raid@vger.kernel.org>; Tue, 26 Jul 2022 04:55:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641E1C341C8
        for <linux-raid@vger.kernel.org>; Tue, 26 Jul 2022 04:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658811346;
        bh=Y2lQ/cuiu70vdHDc8JR5TqbuUY4BVSg6FUBKWmQCbMw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=nMvATbg9CPtSLyMi2pNjK94yn9mdjDYARGJO7hHSslj2rYbt9b66N6kdE+AGl+4nL
         NJ5gxKMtlixLA7uxbOOkG8A2PWoqZnq4nAGQxiZokYpdHyD1DJrfZmsY4W9rqeBJtt
         IKeJwdzrv3qL0ncM3FBThuoQrDIEKSvIgGGwc2kfLf9iCRXjHz7s7BZ5BAhUhX8jnW
         gspYLO4ocGet8CbA/6XKR3zOaWQnkkVq8vzGBFFCCV/tP4bqCr7IacA8AxzoN3uCon
         dC7iVqWBX+ByCEsH9c8bVHCfxLTeAgFQ9rYdvv8xfiobSACy4fLmGU0eKcnxlSdWhC
         p16374qDzNa1g==
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-31f379a0754so27866467b3.2
        for <linux-raid@vger.kernel.org>; Mon, 25 Jul 2022 21:55:46 -0700 (PDT)
X-Gm-Message-State: AJIora/zEA1mi5Gf/UbPO/FO0fXMZpXNOaWBDieM1Sy7vTcoeHLjRbuu
        cCvNSeCwHoDvr6BJLbxYIhiE9f+2n+UanaciCOg=
X-Google-Smtp-Source: AGRyM1ssaYcXL2K1PVRkAqVhYds/GC7qi7/sWoHkblKFRolnpc3Zdlu5aUh8H+6muIepiVa/QgBWDddE9W0n0cTuvrA=
X-Received: by 2002:a0d:d890:0:b0:31f:3957:2f49 with SMTP id
 a138-20020a0dd890000000b0031f39572f49mr3720813ywe.130.1658811345466; Mon, 25
 Jul 2022 21:55:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220723062512.2210253-1-hch@lst.de>
In-Reply-To: <20220723062512.2210253-1-hch@lst.de>
From:   Song Liu <song@kernel.org>
Date:   Mon, 25 Jul 2022 21:55:34 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4z-LszwzYSVsuP6c5bGJmeS=osC3ywW0XeNgmqmFyW1Q@mail.gmail.com>
Message-ID: <CAPhsuW4z-LszwzYSVsuP6c5bGJmeS=osC3ywW0XeNgmqmFyW1Q@mail.gmail.com>
Subject: Re: [PATCH] md: remove a superfluous semicolon
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Jul 22, 2022 at 11:25 PM Christoph Hellwig <hch@lst.de> wrote:
>
> No use for a semicolon at the end of a loop block.
>
> Reporte-by:  kernel test robot <lkp@intel.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This is a duplicate of

https://lore.kernel.org/all/20220722002755.71703-1-yang.lee@linux.alibaba.com/t/

Added Christoph's signed-off-by and the reported-by to that commit.

Thanks,
Song

> ---
>  drivers/md/md.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 673a39042208c..2b2267be5c329 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8205,7 +8205,7 @@ static void *md_seq_next(struct seq_file *seq, void *v, loff_t *pos)
>                         break;
>                 mddev = next_mddev;
>                 tmp = mddev->all_mddevs.next;
> -       };
> +       }
>         spin_unlock(&all_mddevs_lock);
>
>         if (to_put)
> --
> 2.30.2
>
