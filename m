Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E6F5C04FF3
	for <linux-raid@archiver.kernel.org>; Mon, 24 May 2021 06:04:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B23A61132
	for <linux-raid@archiver.kernel.org>; Mon, 24 May 2021 06:04:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbhEXGGL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 May 2021 02:06:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229633AbhEXGGL (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 24 May 2021 02:06:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88E6F61132
        for <linux-raid@vger.kernel.org>; Mon, 24 May 2021 06:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621836283;
        bh=Bwv9PWF/QIvO8DWSTp/vNZPSSyuI9dBZSnI18A3CjN0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Hwik3uYZrMjYvO9jbTm5EV3ekUa3YL/YH34mQOKsWxeAHXoGNa7wNAwDCUMHL1l8h
         W8ivDbwE0ouTvTFPALnuKwvZFnJQyk+GO8re+8HD7Rcfbtttko1ifqE1uxP9iVghY8
         XDtmuJvBgXUzUEiVPbuNbqPjUDlxtZEPFXk47eR7jUSadTpAXtm8QuifzpPx4b/aCa
         11GklQ5R/bc3CeZR1rOyQVmmoN+VQ01y1hJDlXtKbJf50XKXtyXbBU6pYhJplD2IBM
         HuJ+J0bt6Tu7nTub7y1l2zoGgZfBBOKsT/ZO81MCB3uBarckzKjJNjbGsRYbIG8Nmz
         heOn5XSvwhBhQ==
Received: by mail-lj1-f175.google.com with SMTP id f12so32044923ljp.2
        for <linux-raid@vger.kernel.org>; Sun, 23 May 2021 23:04:43 -0700 (PDT)
X-Gm-Message-State: AOAM533NP2St7DRL411TvhV5f9/mvIv93+daU9oL1rs0lDX0u4NSo25E
        zXNtxX/gzPYznfvilTAH3e5w4XaLMx9UtfCl0EI=
X-Google-Smtp-Source: ABdhPJxFQ4HVrRWxlAzQ4F2KrH0L5MvutvbQ+nKQP9pwWoqs4OHTDA6vCR2e/Ps0sMFafq2p7yD+3qmIcYhjwzihh+s=
X-Received: by 2002:a2e:7119:: with SMTP id m25mr15384573ljc.177.1621836281838;
 Sun, 23 May 2021 23:04:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210521005521.713106-1-jiangguoqing@kylinos.cn>
In-Reply-To: <20210521005521.713106-1-jiangguoqing@kylinos.cn>
From:   Song Liu <song@kernel.org>
Date:   Sun, 23 May 2021 23:04:30 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7FuNz_stvmvPSYsSypDxJadFEUFZ6Bq1U517EK7N25Og@mail.gmail.com>
Message-ID: <CAPhsuW7FuNz_stvmvPSYsSypDxJadFEUFZ6Bq1U517EK7N25Og@mail.gmail.com>
Subject: Re: [PATCH V2 0/7] md: io stats accounting
To:     Guoqing Jiang <jgq516@gmail.com>, Christoph Hellwig <hch@lst.de>,
        =?UTF-8?Q?Pawe=C5=82_Wiejacha?= <pawel.wiejacha@rtbhouse.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, May 20, 2021 at 5:56 PM Guoqing Jiang <jgq516@gmail.com> wrote:
>
> V2 changes:
>
> 1. add accounting_bio to md_personality.
> 2. cleanup in case bioset_integrity_create fails.
> 3. use bio_end_io_acct.
> 4. remove patch for enable io accounting for multipath.
> 5. add one patch to rename print_msg.
> 6. add one patch to deprecate linear, multipath and faulty.
>
> Artur Paszkiewicz (1):
>   md: the latest try for improve io stats accounting
>
> Guoqing Jiang (6):
>   md: revert io stats accounting
>   md: add accounting_bio for raid0 and raid5
>   md/raid1: rename print_msg with r1bio_existed
>   md/raid1: enable io accounting
>   md/raid10: enable io accounting
>   md: mark some personalities as deprecated

Thanks Guoqing! This version looks great to me. No need to send v3 for
those two minor comments.

Artur and Christoph, could you please share your comments on this version
and/or reply with your Reviewed-by tag?

Pawel, could you please run your tests with this set? Note that, the test should
be run after setting
   echo 1 > /sys/block/mdXXX/queue/iostats

Thanks,
Song

>
