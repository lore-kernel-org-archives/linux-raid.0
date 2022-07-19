Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC859CCA47F
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jul 2022 18:41:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbiGSSlz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jul 2022 14:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbiGSSly (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Jul 2022 14:41:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A085D0C4;
        Tue, 19 Jul 2022 11:41:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DB4661790;
        Tue, 19 Jul 2022 18:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4BAC341CA;
        Tue, 19 Jul 2022 18:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658256110;
        bh=BR+j7FHA+Cyq4KBojhD77ByQwpkYF+J/UmnwKx01Xn4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=BfWSS/lTCJLbjL+acWG8sRsYN0ZhAvW72ommyQR7xq9VhVdoKy9DVmisYkYcA8dQl
         UjlW92bkxW4iXvzWX5n4gucMyeblr2zQ8pWUUIZugUCuvr0VGcwLhuDGY+a6D1rqFc
         PjzwE6VHunZvlTQy9WQ44iud5vSHKI+j+iRYhox25BzwD292TotBjyiOZr77GxBaG7
         V5WjQK5xv+1jEQ2yTI4ITClC7w16LpIe88XknRx8x94dqURKhWfCZOEN5LzOl4ZlPH
         ht7kmfrN0papbAGPynSljZg9WfKZySDtOoLKMsOeqo5y7RFGpAC7V3NncM5ZWMtqZ+
         8WQly1nCqLSig==
Received: by mail-yb1-f169.google.com with SMTP id j67so5529725ybb.3;
        Tue, 19 Jul 2022 11:41:50 -0700 (PDT)
X-Gm-Message-State: AJIora/rsmbXOury2HSJQxnjEa9s+RFVrm+PJIeLYc4xrewFEMQaYuHY
        JXzqEzD2KfeoaUFvswxcv2f7nkyx1+zy1lXQGGk=
X-Google-Smtp-Source: AGRyM1sWyxzwza0K8D6no1LLxmz5pfdLeOxDAGi7Om4GLmAz3nlqxRjH2unm/b4iC5vSRRbVlU9IDEvfWxLY+rhc9Vs=
X-Received: by 2002:a25:8611:0:b0:66e:d9e7:debc with SMTP id
 y17-20020a258611000000b0066ed9e7debcmr33507549ybk.257.1658256109602; Tue, 19
 Jul 2022 11:41:49 -0700 (PDT)
MIME-Version: 1.0
References: <YtZ90ZYlrVvucwr9@kili> <909f1c33-27e3-3f3a-7d8d-ba6fdb57cdb3@deltatee.com>
In-Reply-To: <909f1c33-27e3-3f3a-7d8d-ba6fdb57cdb3@deltatee.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 19 Jul 2022 11:41:38 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6ckCbzKjZnskuFFZrWm3-cDu9TH5Y6EinxzpFF0qaiAA@mail.gmail.com>
Message-ID: <CAPhsuW6ckCbzKjZnskuFFZrWm3-cDu9TH5Y6EinxzpFF0qaiAA@mail.gmail.com>
Subject: Re: [PATCH] md/raid5: missing error code in setup_conf()
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Jul 19, 2022 at 9:57 AM Logan Gunthorpe <logang@deltatee.com> wrote:
>
>
>
> On 2022-07-19 03:48, Dan Carpenter wrote:
> > Return -ENOMEM if the allocation fails.  Don't return success.
> >
> > Fixes: 8fbcba6b999b ("md/raid5: Cleanup setup_conf() error returns")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> Oops, nice catch.
>
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

Applied to md-fixes. Thanks!

Song
