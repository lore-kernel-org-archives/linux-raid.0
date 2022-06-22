Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9344C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 22 Jun 2022 23:33:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377492AbiFVXdd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Jun 2022 19:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377263AbiFVXdc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Jun 2022 19:33:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00CD32F657
        for <linux-raid@vger.kernel.org>; Wed, 22 Jun 2022 16:33:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0210B8204D
        for <linux-raid@vger.kernel.org>; Wed, 22 Jun 2022 23:33:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C2C9C34114
        for <linux-raid@vger.kernel.org>; Wed, 22 Jun 2022 23:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655940809;
        bh=8wMLZdRZNiogAPbMmzw2yAqFQzeZ9TR/hHdIWf2XlOk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=j+UIXbdolcqtkotm2LbVx0MgdaW68bDmzLPi0dSJRfnToRkokJtIkCWMnv0wXZ7KC
         cxJrreUr/g72p8sCO/PxwSRkFYeqmQiFepuqN1XjMzVzfaupHT+p+8A8oB+D6h0MGs
         9sBTCB7el//wlF4viaPiR8yVg6lAzbGQvKAqpfyfDRMgl52UNiHvWV5Y07g5Y0mBlH
         PwSzeH+IzrnpmFsFc/ExTW7mUGcrb0Jit2vAIQrV7E52du+7Np7NEt+qWepO+07yRf
         WFFKxc6S03a5Y1tzwK2omLJqnTn8R5FNgz7wLzeYXklHwwcq2a5pfBm6ucVslNr3th
         c3SVDOO1IPwGQ==
Received: by mail-yb1-f172.google.com with SMTP id x38so32873850ybd.9
        for <linux-raid@vger.kernel.org>; Wed, 22 Jun 2022 16:33:29 -0700 (PDT)
X-Gm-Message-State: AJIora82KClJc6ncLK9vkr3vgjpF/ScIcdo5+Yore/Bys6i5/ktu8UEq
        tVpc5IAqf0Qlk1Rc+5E5ROR3/Lif5C/K1dNWHWk=
X-Google-Smtp-Source: AGRyM1v0ky1UxcLy/P2WW6i1L+F2g/+bNm//1Jw7//g2SgIbiOgJrZlipCbmXFQeotan3XBvvWwYkc7hb09kvXnjpNI=
X-Received: by 2002:a05:6902:b:b0:668:e2a0:5c2 with SMTP id
 l11-20020a056902000b00b00668e2a005c2mr6261998ybh.389.1655940808482; Wed, 22
 Jun 2022 16:33:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220622073838.8295-1-guoqing.jiang@linux.dev>
In-Reply-To: <20220622073838.8295-1-guoqing.jiang@linux.dev>
From:   Song Liu <song@kernel.org>
Date:   Wed, 22 Jun 2022 16:33:17 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6qVcsk1TNqOWkESQYb_5cvvLohCKwyxJSWXmYZs=BG2A@mail.gmail.com>
Message-ID: <CAPhsuW6qVcsk1TNqOWkESQYb_5cvvLohCKwyxJSWXmYZs=BG2A@mail.gmail.com>
Subject: Re: [PATCH] md: add patchwork URL
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Jun 22, 2022 at 12:39 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>
> Finally, md has it's own patch tracking system, let's reflect it here.
>
> Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>

I already added this to md-next.

Thanks,
Song

> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3cf9842d9233..450159ded532 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -18492,6 +18492,7 @@ SOFTWARE RAID (Multiple Disks) SUPPORT
>  M:     Song Liu <song@kernel.org>
>  L:     linux-raid@vger.kernel.org
>  S:     Supported
> +Q:     http://patchwork.kernel.org/project/linux-raid/list/
>  T:     git git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git
>  F:     drivers/md/Kconfig
>  F:     drivers/md/Makefile
> --
> 2.31.1
>
