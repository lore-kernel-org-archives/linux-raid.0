Return-Path: <SRS0=xKAG=B6=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D63F2C433DF
	for <linux-raid@archiver.kernel.org>; Thu, 20 Aug 2020 00:25:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF982207FB
	for <linux-raid@archiver.kernel.org>; Thu, 20 Aug 2020 00:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597883126;
	bh=kPZc4agHNOeUkg6oXVSqKJURMdqaP7obAYjX8E7uDkc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=xpAugvj5gNAzFI2Xnjyd7VxWFHcUHi4WHrq3JMGxPc9IMYgzKO4wb+GO+fSOEABCq
	 CaH4NpHARvuXrM33uRJiFqCmQAetVqR+5irLSW0d8+xckBa0kgUmGvVteyeHJLrGYO
	 nOBIXvfaNSs+2Su+vWAuwXGH6deAyC3jksSOJOUo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbgHTAZZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 Aug 2020 20:25:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:51070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726700AbgHTAZY (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 19 Aug 2020 20:25:24 -0400
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 596CD207FB
        for <linux-raid@vger.kernel.org>; Thu, 20 Aug 2020 00:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597883124;
        bh=kPZc4agHNOeUkg6oXVSqKJURMdqaP7obAYjX8E7uDkc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=lx7Kq5MMArdOJY99gOFE1eY9u5vPbPGl5LHSnLJzqeF3g/gxXxIdVtkBwbMWNm79C
         oxawxOl2cLZhukPkq6B9hLKCs4x8cbsDgtASiTTQf2Ln+DJgSBEXiGufXdv08FXuke
         7EIsRmZMjZMo2ZdgPo/M5Hc7Ed1X1zG7xoWCJ0rk=
Received: by mail-lj1-f178.google.com with SMTP id t23so285375ljc.3
        for <linux-raid@vger.kernel.org>; Wed, 19 Aug 2020 17:25:24 -0700 (PDT)
X-Gm-Message-State: AOAM5319KnO9zObzhaRlUwSKLQq93yjiUe6BS4SAT9C8Nu5hHvrw3PLt
        fzGrq1I/2qPZMd1FngVd/Wv8j7TMC4MNIDe34mQ=
X-Google-Smtp-Source: ABdhPJzPenB5yf5Kb9yYj3ESk17v8unA4nauH74ZGaWx1ue69TRxpPDUvC8lXZ+YJCdzgbVBBY0OwAVAT/Bn3zMClqU=
X-Received: by 2002:a2e:81c2:: with SMTP id s2mr335101ljg.10.1597883122665;
 Wed, 19 Aug 2020 17:25:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200812124931.2584743-1-yuyufen@huawei.com>
In-Reply-To: <20200812124931.2584743-1-yuyufen@huawei.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 19 Aug 2020 17:25:11 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6rB-+APsw77CqOz8ipdneRyCDBdgx_rxi0ep22xC5gVw@mail.gmail.com>
Message-ID: <CAPhsuW6rB-+APsw77CqOz8ipdneRyCDBdgx_rxi0ep22xC5gVw@mail.gmail.com>
Subject: Re: [PATCH 00/12] Save memory for stripe_head buffer
To:     Yufen Yu <yuyufen@huawei.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        NeilBrown <neilb@suse.com>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Hou Tao <houtao1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Aug 12, 2020 at 5:48 AM Yufen Yu <yuyufen@huawei.com> wrote:
>
> Hi, all
>
>  In current implementation, grow_buffers() uses alloc_page() to allocate
>  the buffers for each stripe_head, i.e. allocate a page for each dev[i]
>  in stripe_head.
>
>  After setting stripe_size as a configurable value by writing sysfs entry,
>  it means that we always allocate 64K buffers, but just use 4K of them when
>  stripe_size is 4K in 64KB arm64.
>
>  To save memory, we try to let multiple buffers of stripe_head to share only
>  one real page when page size is bigger than stripe_size. Detail can be
>  seen in patch #10.
>
>  This patch set is subsequent optimization for configurable stripe_size,
>  which based on the origin patches[1] but reorganized them.
>
>  Patch 1 ~ 2 try to replace current page offset '0' with dev[i].offset.
>  Patch 3 ~ 5 let xor compute functions support different page offset for raid5.
>  Patch 6 ~ 9 let syndrome and recovery function support different page offset for raid6.
>  All of these patch are preparing for shared page. There is no functional change.
>
>  Patch 10 ~ 11 actually implement shared page between multiple devices of
>  stripe_head. But they only make sense for PAGE_SIZE != 4096, likely, 64KB arm64
>  system. It doesn't make any difference for PAGE_SIZE == 4096 system, likely x86.

Thanks for the patches.

I went through the first half of the set, most of the code looks fine.
However, there is
one issue: the way you split the changes into 12 patches is not ideal. The most
significant issue is that build failed after 5/12 or 6/12 (and was
fixed after 9/12). We
would like every commit build successfully. I think the proper fix is
to break 9/12 and
merge changes in raid5.c to proper patches. Also, I think we can merge
1/12 and 2/12.

Please resubmit after these changes.

Thanks,
Song
