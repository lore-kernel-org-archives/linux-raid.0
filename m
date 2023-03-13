Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD264C61DA4
	for <linux-raid@archiver.kernel.org>; Mon, 13 Mar 2023 21:39:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjCMVjV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 13 Mar 2023 17:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjCMVjU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 13 Mar 2023 17:39:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A857BA39
        for <linux-raid@vger.kernel.org>; Mon, 13 Mar 2023 14:39:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33C13B81200
        for <linux-raid@vger.kernel.org>; Mon, 13 Mar 2023 21:39:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8596C433A0
        for <linux-raid@vger.kernel.org>; Mon, 13 Mar 2023 21:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678743545;
        bh=Pl5QSD46K76D/yrV91+xswHqeKn6Da2JW0wUI1a830E=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=pQYiP9j1HqeZZwkx56YrEAUktSu8EE6jqr45xfE4bVyF2S4v7dNEO74zZvSSQiPKr
         p6u4MWEeisK9c13jinKLEiXq+vF5FowjPz5PVv2384RdKJ26QCnoIbeyQiDKKllPbr
         hZ8lZTeJRnVlfYxsgZ0GMNX45MZFqkWt8NBfb9S3BSQ/94buhWpiPMZ0K06IxX3E0y
         7P+3WhmWcK/iQNLuf8zHuP2sVviLE+pXnF1CkbSBm3j6qnUUEHgUJdeG9JMzMP/Ae9
         VKRWLMCs/E61Tcx3ujDaPYX92WZ9xGJomzzPJ9mcy5vC1vQ6FyRkyoOCq9Zn/fODxE
         NgsgxEiH03PWQ==
Received: by mail-lj1-f178.google.com with SMTP id h9so14094491ljq.2
        for <linux-raid@vger.kernel.org>; Mon, 13 Mar 2023 14:39:05 -0700 (PDT)
X-Gm-Message-State: AO0yUKUUFlIBJ5YBrUQZRy2KPITMh+WIm3Eh91r1tFfl3tsdLMNBx7x8
        /CClWBoEhkDC9xJIcPFHNFEh/tsmwWiH0qs4t8E=
X-Google-Smtp-Source: AK7set9j5YSwuUKMgKfraPJeXgqEzCCFfjSxtWq4b3w+7u8kjOengqclAn0U92glY1OcgcdGR2RAK1RYZ8jQUBA9/sQ=
X-Received: by 2002:a2e:aaa3:0:b0:295:a64f:9d50 with SMTP id
 bj35-20020a2eaaa3000000b00295a64f9d50mr11154491ljb.5.1678743543877; Mon, 13
 Mar 2023 14:39:03 -0700 (PDT)
MIME-Version: 1.0
References: <20230224183323.638-1-jonathan.derrick@linux.dev>
In-Reply-To: <20230224183323.638-1-jonathan.derrick@linux.dev>
From:   Song Liu <song@kernel.org>
Date:   Mon, 13 Mar 2023 14:38:51 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5BzOuZvMgf75PxbK5wDcMhGAFMP1io52hw8cg5BQoR3A@mail.gmail.com>
Message-ID: <CAPhsuW5BzOuZvMgf75PxbK5wDcMhGAFMP1io52hw8cg5BQoR3A@mail.gmail.com>
Subject: Re: [PATCH v5 0/3] md/bitmap: Optimal last page size
To:     Jonathan Derrick <jonathan.derrick@linux.dev>
Cc:     linux-raid@vger.kernel.org, Reindl Harald <h.reindl@thelounge.net>,
        Xiao Ni <xni@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Christoph Hellwig <hch@infradead.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Sushma Kalakota <sushma.kalakota@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Feb 24, 2023 at 10:35=E2=80=AFAM Jonathan Derrick
<jonathan.derrick@linux.dev> wrote:
>
> From: Jon Derrick <jonathan.derrick@linux.dev>
>
> Currently the last bitmap page write will size itself down to the logical=
 block
> size. This could cause less performance for devices which have atomic wri=
te
> units larger than the block size, such as many NVMe devices with 4kB writ=
e
> units and 512B block sizes. There is usually a large amount of space afte=
r the
> bitmap and using the optimal I/O size could favor speed over size.
>
> This was tested on an Intel/Solidigm P5520 drive with lba format 512B,
> optimal I/O size of 4kB, resulting in a > 10x IOPS increase.
>
> See patch 3 log for results.
>
> v4->v5: Initialized rdev (kernel test bot)
> v3->v4: Fixed reviewers concerns
> v2->v3: Prep patch added and types fixed
> Added helpers for optimal I/O sizes
>

Applied to md-next. Thanks!

I also added

Tested-by: Xiao Ni <xni@redhat.com>

Thanks,
Song
