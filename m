Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 355DEC433EF
	for <linux-raid@archiver.kernel.org>; Fri, 17 Jun 2022 21:53:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236184AbiFQVxA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 17 Jun 2022 17:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236194AbiFQVw6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 17 Jun 2022 17:52:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ADF213F1A;
        Fri, 17 Jun 2022 14:52:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA909620CE;
        Fri, 17 Jun 2022 21:52:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A843C341C0;
        Fri, 17 Jun 2022 21:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655502777;
        bh=CHYf7wPblugaOOHON/B4cUZtYdtCO/G6QCOlC6YwWBU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ALU3NVZKdfyEBaJrg+gRyGt1phOVFMXGhZPBQV1ed/5iu0tDxdy+GjpvYV75Jp+C+
         XnJAayrbg5tR1zP4LKDqG1uH2Sl2uCp4yvyB3Mh6BPMfX0njDXlk+7EvhGIZrKNPVA
         65/j4+y5QILpPEzaGKh7QtTrGxdKT64KVTPfu+1zULBBwD0uNv3UJWkyMrPoCXvxQw
         EwliwL2onf1+97ogkDqsLoqGozpz5B2XcO4Ne1BlU8IdvqIqK6GgApilLcqctVdwkj
         L5DhlBwquIulFbX2Gf/rBp9yTvyYRgp4LWPKoDgCxBW6LBwcB90Mz92vJq3jbeDxpj
         70qDcu81hX23g==
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-317741c86fdso52483497b3.2;
        Fri, 17 Jun 2022 14:52:57 -0700 (PDT)
X-Gm-Message-State: AJIora9mvYOWs8MImCXOBmCxNHBef4HBrSWADdCwjxxL2LQ4Ycz0RKsm
        GxC1PFdLnMEiciRt6k1PUXh8eASHltTbPY60bPI=
X-Google-Smtp-Source: AGRyM1vQ8Sa8Q4UM+oDO3hrf72jWP5A0jUUFHNSLXlE5u2/U9YUgyIoEz9eu2Q4f9c46TQJjSp0bcXR4wcwL4qzps80=
X-Received: by 2002:a81:7505:0:b0:30c:45e3:71bc with SMTP id
 q5-20020a817505000000b0030c45e371bcmr14301902ywc.460.1655502776275; Fri, 17
 Jun 2022 14:52:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220608162756.144600-1-logang@deltatee.com> <20220608162756.144600-2-logang@deltatee.com>
 <Yqwe6NXL9sedvx7v@infradead.org>
In-Reply-To: <Yqwe6NXL9sedvx7v@infradead.org>
From:   Song Liu <song@kernel.org>
Date:   Fri, 17 Jun 2022 14:52:45 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7Vqn3Njf5nt1Pgu9A9+Ov2DUZnGvScfdFjsoiLX5CPeA@mail.gmail.com>
Message-ID: <CAPhsuW7Vqn3Njf5nt1Pgu9A9+Ov2DUZnGvScfdFjsoiLX5CPeA@mail.gmail.com>
Subject: Re: [PATCH v4 01/11] md/raid5-ppl: Fix argument order in bio_alloc_bioset()
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>,
        open list <linux-kernel@vger.kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>, Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Jun 16, 2022 at 11:28 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> While I think this whole series needs to get in of course, this one
> seems even morge urgent.  Song, can you send it to Jens ASAP, please?

This is already in Jens' block-5.19 branch. :)

https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/commit/?h=block-5.19&id=f34fdcd4a0e7a0b92340ad7e48e7bcff9393fab5

Thanks,
Song
