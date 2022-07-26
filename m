Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B85BC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 26 Jul 2022 05:15:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbiGZFPh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 26 Jul 2022 01:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiGZFPg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 26 Jul 2022 01:15:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5012FBF43
        for <linux-raid@vger.kernel.org>; Mon, 25 Jul 2022 22:15:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B24FE611ED
        for <linux-raid@vger.kernel.org>; Tue, 26 Jul 2022 05:15:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18AD5C341C0
        for <linux-raid@vger.kernel.org>; Tue, 26 Jul 2022 05:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658812532;
        bh=pmTqeTYpJPQfx9YsXPos61vEA4ZAiGY4J1h7jg+cQWg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=BP3PAZrqTfzdUr5/rKfyWS3OlTQk2Oocb5EVIJbUKoNK5gXbEvKOHWK3+8k9znqkw
         J0u3w2nivQk2vZemF90pMseLE95FIBiKkK/8ORe50ULR4N9527JoJLPJWFyEW7aTB/
         hJERLjAY8m9eXcA5DaHUsoKPVorrc1sLtljJ40UIvmqw+3FRMnSLkb0UJVmjKpSCJH
         j5tcFgGSoz/rjNbb7X/61b08ccNh1+dEw0GCpobsppagnN4FKf3VXlTMSNOgHn1/PT
         arfawSWe0PIA1MzQ1NKp8iCk6zRpSqqEhD1Emhxmg3QdotrSGSlUiPoX8pgPXuFHlI
         rmnY57HrPBAPA==
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-31e7055a61dso130778917b3.11
        for <linux-raid@vger.kernel.org>; Mon, 25 Jul 2022 22:15:32 -0700 (PDT)
X-Gm-Message-State: AJIora8j/ieDTCKp79/IR0L/hNopZYNpbFMQHjAT30wwe2SaCz905CPK
        fSWLo6VViqrYVpf/rOAaaRriJQwvywvviF5C6FM=
X-Google-Smtp-Source: AGRyM1v4oXOth8dCg84lUmOQtogDXKbc4VxxtZZagOfxfYnKzViVT1tIMa9RM4xg8bv5nYiIf4nFvQYWPw5oPL7V07c=
X-Received: by 2002:a81:2389:0:b0:31e:6212:5bb6 with SMTP id
 j131-20020a812389000000b0031e62125bb6mr12797129ywj.472.1658812531114; Mon, 25
 Jul 2022 22:15:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220723062429.2210193-1-hch@lst.de> <8663e200-a825-d169-cb27-dff774f0a9ed@deltatee.com>
In-Reply-To: <8663e200-a825-d169-cb27-dff774f0a9ed@deltatee.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 25 Jul 2022 22:15:20 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4Lp+BaTxGVVLVV=T_zpGPTCzdDOXdbcmq5hqd-bq+XhQ@mail.gmail.com>
Message-ID: <CAPhsuW4Lp+BaTxGVVLVV=T_zpGPTCzdDOXdbcmq5hqd-bq+XhQ@mail.gmail.com>
Subject: Re: md device allocation cleanups
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Jul 25, 2022 at 9:30 AM Logan Gunthorpe <logang@deltatee.com> wrote:
>
>
>
> On 2022-07-23 00:24, Christoph Hellwig wrote:
> > Hi all,
> >
> > this small series cleans up the mddev allocation a bit by returning
> > the structure to callers that want it instead of requiring another
> > lookup.

Applied to md-next. Thanks!

>
> I've reviewed and tested these two patches and they look good to me.
>
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

I changed this to

Reviewed-and-tested-by: Logan Gunthorpe <logang@deltatee.com>

Please let me know if you think this is not appropriate.

Thanks,
Song
