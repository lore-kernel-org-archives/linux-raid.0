Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FBBDC433F5
	for <linux-raid@archiver.kernel.org>; Thu, 16 Dec 2021 23:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbhLPXue (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 16 Dec 2021 18:50:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhLPXud (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 16 Dec 2021 18:50:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4457DC061574
        for <linux-raid@vger.kernel.org>; Thu, 16 Dec 2021 15:50:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06AF6B82647
        for <linux-raid@vger.kernel.org>; Thu, 16 Dec 2021 23:50:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E8EC36AE2
        for <linux-raid@vger.kernel.org>; Thu, 16 Dec 2021 23:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639698630;
        bh=cfu7Wn4JYRwv8JtZUbmMMDnlkv0MWtR+jabCDrJGb3k=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=R86l83/eoKs9wXOCx0pNHAiWjP6G4XauZ/vTCGjVOeTJa8af8D2ybqzsO84dQaV9g
         OqBiW7rtK9ix7uqSERojp/MeP8bovME71Hqn7h3NgQSLa9ADX1SYEv6ssUVragUnx/
         k0D4FYL66s4DAm/oAXOdM7AtzhC+n5g+NgFNv5wTWWhU4cuhcEfCSJP9KxUeOlxr6I
         Rr5KTEcRwG3IvYepqTAlHO9DNRZpvBbA6orVy+BG+QRNfO43/eskq43sThpuTntLIO
         gz2GprqXBtg2h78HGKZrmorTGVuzHb4728vpOhtbhpqQpYxFFDhibu71IqvkDxlajt
         g9mOFEr/VdCWg==
Received: by mail-yb1-f174.google.com with SMTP id q74so1421605ybq.11
        for <linux-raid@vger.kernel.org>; Thu, 16 Dec 2021 15:50:30 -0800 (PST)
X-Gm-Message-State: AOAM53351uhJVBhlVX/bQJeor/KUJn0hs9Wm2+EaTO/mejkScraXSM7p
        lDXZjfJE4rk+ZnRl4OqZ3tBu01Vnri+T9pm1Rx0=
X-Google-Smtp-Source: ABdhPJxNRW49ovNL1Qykkzdk5frd7Hzm1pLa34hNX9UX/uNT6S3OHR4ZcyE7cec6G5xjcZGMvXuB0ivvsnd2jCvI0m4=
X-Received: by 2002:a25:b519:: with SMTP id p25mr705152ybj.195.1639698629823;
 Thu, 16 Dec 2021 15:50:29 -0800 (PST)
MIME-Version: 1.0
References: <CAPhsuW7OY+5-F6Vk6z=ngSMXEayz3si=Sdf69r4vexRo202X_Q@mail.gmail.com>
 <20211215060906.3230-1-vverma@digitalocean.com> <20211215060906.3230-3-vverma@digitalocean.com>
 <CAPhsuW5=GLRW9g2QxgBfcx_OKq08x5GqGO4iC86x6YzDHRz8fA@mail.gmail.com>
 <9a85af03-a551-6650-3807-c177659cd17b@digitalocean.com> <7592d323-a07f-e333-220c-e9a7321a16f3@digitalocean.com>
 <4d246589-2184-91ec-613c-a3e8926a2b92@kernel.dk> <d93019e5-1669-0eb6-1e8e-73768aa6f917@digitalocean.com>
 <051b25ce-3b6b-b156-f6fa-2da36bbd9144@kernel.dk> <dbd77650-7a27-1a7b-935c-aba1057d385b@digitalocean.com>
 <CAPhsuW44Y-Lw01yEzVJH4J=JvBLbcKBOyva-75ivT2mdfsS2fg@mail.gmail.com> <50e23aee-af38-4da2-0f2f-da16af4fc477@digitalocean.com>
In-Reply-To: <50e23aee-af38-4da2-0f2f-da16af4fc477@digitalocean.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 16 Dec 2021 15:50:18 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5X7T67odWhZ=AqQMGvZATmHrxNeGOuLH-fmhy_L1r+Ag@mail.gmail.com>
Message-ID: <CAPhsuW5X7T67odWhZ=AqQMGvZATmHrxNeGOuLH-fmhy_L1r+Ag@mail.gmail.com>
Subject: Re: [PATCH v5 3/4] md: raid10 add nowait support
To:     Vishal Verma <vverma@digitalocean.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>, rgoldwyn@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Dec 16, 2021 at 12:38 PM Vishal Verma <vverma@digitalocean.com> wrote:
>
[...]

> >> [  740.106431] invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
> >>
> > What's the exact command line that triggers this? I am not able to
> > trigger it with
> > either fio or t/io_uring.
> >
> > Song
> I only had 1 nvme so was creating 4 partitions on it and creating a
> raid10 and doing:
>
> mdadm -C /dev/md10 -l 10 -n 4 /dev/nvme4n1p1 /dev/nvme4n1p2
> /dev/nvme4n1p3 /dev/nvme4n1p4
> ./t/io_uring /dev/md10-d 256 -p 0 -a 0 -r 100
>
> on top of commit: c14704e1cb556 (md-next branch) + "md: add support for
> REQ_NOWAIT" patch
> Also, applied the commit (75feae73a28) Jens pointed earlier today.
>

I am able to trigger the following error. I will look into it.

Thanks,
Song

[ 1583.149004] ==================================================================
[ 1583.150100] BUG: KASAN: use-after-free in raid10_end_read_request+0x91/0x310
[ 1583.151042] Read of size 8 at addr ffff888160a1c928 by task io_uring/1165
[ 1583.152016]
[ 1583.152247] CPU: 0 PID: 1165 Comm: io_uring Not tainted 5.16.0-rc3+ #660
[ 1583.153159] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.13.0-2.module_el8.4.0+547+a85d02ba 04/01/2014
[ 1583.154572] Call Trace:
[ 1583.155005]  <IRQ>
[ 1583.155338]  dump_stack_lvl+0x44/0x57
[ 1583.155950]  print_address_description.constprop.8.cold.17+0x12/0x339
[ 1583.156969]  ? raid10_end_read_request+0x91/0x310
[ 1583.157578]  ? raid10_end_read_request+0x91/0x310
[ 1583.158272]  kasan_report.cold.18+0x83/0xdf
[ 1583.158889]  ? raid10_end_read_request+0x91/0x310
[ 1583.159554]  raid10_end_read_request+0x91/0x310
[ 1583.160201]  ? raid10_resize+0x270/0x270
[ 1583.160724]  ? bio_uninit+0xc7/0x1e0
[ 1583.161274]  blk_update_request+0x21f/0x810
[ 1583.161893]  blk_mq_end_request_batch+0x11c/0xa70
[ 1583.162497]  ? blk_mq_end_request+0x460/0x460
[ 1583.163204]  ? nvme_complete_batch_req+0x12/0x30
[ 1583.163888]  nvme_irq+0x6ad/0x6f0
[ 1583.164354]  ? io_queue_count_set+0xe0/0xe0
[ 1583.164980]  ? nvme_unmap_data+0x1e0/0x1e0
[ 1583.165504]  ? rcu_read_lock_bh_held+0xb0/0xb0
[ 1583.166149]  ? io_queue_count_set+0xe0/0xe0
[ 1583.166721]  __handle_irq_event_percpu+0x79/0x440
[ 1583.167446]  handle_irq_event_percpu+0x6f/0xe0
[ 1583.168101]  ? __handle_irq_event_percpu+0x440/0x440
[ 1583.168734]  ? lock_contended+0x6e0/0x6e0
[ 1583.169349]  ? do_raw_spin_unlock+0xa2/0x130
[ 1583.169961]  handle_irq_event+0x54/0x90
[ 1583.170442]  handle_edge_irq+0x121/0x300
[ 1583.171012]  __common_interrupt+0x7d/0x170
[ 1583.171538]  common_interrupt+0xa0/0xc0
[ 1583.172103]  </IRQ>
[ 1583.172389]  <TASK>
