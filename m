Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 660EAC05027
	for <linux-raid@archiver.kernel.org>; Fri, 20 Jan 2023 17:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbjATRTF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 20 Jan 2023 12:19:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbjATRTE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 20 Jan 2023 12:19:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9243A7DFB4
        for <linux-raid@vger.kernel.org>; Fri, 20 Jan 2023 09:18:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D2E6B82941
        for <linux-raid@vger.kernel.org>; Fri, 20 Jan 2023 17:18:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB6BC433EF
        for <linux-raid@vger.kernel.org>; Fri, 20 Jan 2023 17:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674235127;
        bh=9p9UsSpPmRTSNopCN2sjOWf+SId2ZcoPGPpaMslYbJQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=kI0OBM2CuSAHSTIaex+7QNwx5b4MNGjEVUoCqYZJ6GhyOVO6KSZOo10VGFMTjbxKB
         PYtMsfcCa/FSobKBZyUgucepY+Q59l03pHpPpaHhzA0HsoUyDWGfxSxF9gmrNnIsCP
         amy0mhRvCUuPA7pUtjkiulfqbTLoj4GqK9fJtWcnzkJrL+QqUZUJANnYqgI+vnD79S
         tpaJAak9Rj8XSdF4QOoq2y6Z2WV4WvBYNu5bN5+pUVa2c5V3O/NEa8heKTL2wNJByI
         JR/+s+OS9Fc9LO4HC/C7SB+bsIjbeb7/8eiKQoIbSVbwCHhmHdd2ZcO336JHPFfIq/
         MQ/mm39YKVmWA==
Received: by mail-lf1-f48.google.com with SMTP id x40so9047768lfu.12
        for <linux-raid@vger.kernel.org>; Fri, 20 Jan 2023 09:18:46 -0800 (PST)
X-Gm-Message-State: AFqh2kodFpir2/vFmEZ18aVTxT75xwPWUR9ye5nc1z6aHE4LnyKHo66d
        o/6QtXJnnrpj5ltXRO/yOufrR4gZXcYgCRHTXwo=
X-Google-Smtp-Source: AMrXdXuOANlCbv+0F/200Uyt+bYg+j1hCzLkElx8sGdke2HOhbOz8ZAD3Cvwfwit+w0OWqjd5x310BvcJm0uCwxh7aE=
X-Received: by 2002:ac2:48b7:0:b0:4b6:e71d:94a6 with SMTP id
 u23-20020ac248b7000000b004b6e71d94a6mr1205526lfg.476.1674235124981; Fri, 20
 Jan 2023 09:18:44 -0800 (PST)
MIME-Version: 1.0
References: <20230118093008.67170-1-xni@redhat.com>
In-Reply-To: <20230118093008.67170-1-xni@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 20 Jan 2023 09:18:32 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7b2MNX-8vTb5Gr3smKxzjiYW3qfckX1FQMt9K_K82XiQ@mail.gmail.com>
Message-ID: <CAPhsuW7b2MNX-8vTb5Gr3smKxzjiYW3qfckX1FQMt9K_K82XiQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] Change some counters to percpu type
To:     Xiao Ni <xni@redhat.com>
Cc:     linux-raid@vger.kernel.org, ming.lei@redhat.com,
        ncroxon@redhat.com, heinzm@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Jan 18, 2023 at 1:30 AM Xiao Ni <xni@redhat.com> wrote:
>
> Hi all
>
> There are two main changes in the patch set.
>
> The first is to change ->active_io to percpu(patch02). The second
> one is adding a counter for io_acct(patch03).
>

Hi Xiao,

If I understand correctly,

> Xiao Ni (4):
>   Factor out is_md_suspended helper
>   Change active_io to percpu

Patch 1 and 2 are performance optimization?

>   Add mddev->io_acct_cnt for raid0_quiesce
>   Free writes_pending in md_stop

And patch 3 and 4 fixes two issues?

It is probably better to send them as 3 separate patches (sets).

Also, please provide more information on why we need these
changes.

Thanks,
Song

>
>  drivers/md/md.c    | 69 ++++++++++++++++++++++++++++++++++------------
>  drivers/md/md.h    | 11 +++++---
>  drivers/md/raid0.c |  6 ++++
>  3 files changed, 65 insertions(+), 21 deletions(-)
>
> --
> 2.32.0 (Apple Git-132)
>
