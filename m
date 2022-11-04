Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8931C433FE
	for <linux-raid@archiver.kernel.org>; Fri,  4 Nov 2022 17:51:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbiKDRv3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 4 Nov 2022 13:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbiKDRv1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 4 Nov 2022 13:51:27 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F19332065
        for <linux-raid@vger.kernel.org>; Fri,  4 Nov 2022 10:51:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 74C69CE2D56
        for <linux-raid@vger.kernel.org>; Fri,  4 Nov 2022 17:51:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1BF6C433D7
        for <linux-raid@vger.kernel.org>; Fri,  4 Nov 2022 17:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667584282;
        bh=Pv88Ag5LxVD6hxIZWA46GgLLFvmX9lZoqyQU8mY3LHE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=J6WZb5gZJzspwLm9o/fca4xVPkFitl65RJF7krXrfPx/CYdaRZK9HHhIwv61wz6e8
         STh+6PpnIMbulRtfnaPSUlOo1P2Vs2gzpRKAcd6J+efkz1yYi7MX4QVKBejn/5joI6
         jOTQ1MdaPwjLoauVh+nXSLhamyJFcxIBYP1fiRKMkZ1MNS2pkgctBo0I9HGQNlaLLP
         eRiH9+H6C2w9d9L1ImHYB8NZJdmBgy1WqDBjSXmpgy0fHWQi9hHozRFpcBjML46jSe
         U/dju53hH1++s6EUa+q9RCVqmsKLxnBiXI9MBTvxqgkthfAAxJ6RzWbrv6cj2q6Mlf
         bYxNMA+7fgoAQ==
Received: by mail-ej1-f43.google.com with SMTP id f27so15273515eje.1
        for <linux-raid@vger.kernel.org>; Fri, 04 Nov 2022 10:51:22 -0700 (PDT)
X-Gm-Message-State: ACrzQf10440naSS6dT3x4If4nsL9i2FEyNQxUlhXat20Li0HIgEX1epN
        k5su5f1cTTsBTFONlP5LFULknV2rSmze6OdxvS0=
X-Google-Smtp-Source: AMsMyM4FQoE08GPVS1+lTsk+o0TMNS0jA8MWHR3CnFnNlqplZrUn8mIRhAHLhWbv6HyaZSAtjBIhv+d1HkfbWTda1Fc=
X-Received: by 2002:a17:906:eec1:b0:782:6384:76be with SMTP id
 wu1-20020a170906eec100b00782638476bemr35484081ejb.756.1667584281029; Fri, 04
 Nov 2022 10:51:21 -0700 (PDT)
MIME-Version: 1.0
References: <20221102020730.23815-1-xni@redhat.com> <CAFj5m9K8DiVz+KEOpO9NzYgjT=86NaFUOcZmL7eV0_5ni8_BQw@mail.gmail.com>
In-Reply-To: <CAFj5m9K8DiVz+KEOpO9NzYgjT=86NaFUOcZmL7eV0_5ni8_BQw@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 4 Nov 2022 10:51:09 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7v_BtKgXozRGejpki5ofz84EFXPC021B5auOW_ZCaUEA@mail.gmail.com>
Message-ID: <CAPhsuW7v_BtKgXozRGejpki5ofz84EFXPC021B5auOW_ZCaUEA@mail.gmail.com>
Subject: Re: [PATCH V2 1/1] md/raid0, raid10: Don't set discard sectors for
 request queue
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Xiao Ni <xni@redhat.com>, yi.zhang@redhat.com, ncroxon@redhat.com,
        linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Nov 1, 2022 at 7:16 PM Ming Lei <ming.lei@redhat.com> wrote:
>
> On Wed, Nov 2, 2022 at 10:07 AM Xiao Ni <xni@redhat.com> wrote:
> >
> > It should use disk_stack_limits to get a proper max_discard_sectors
> > rather than setting a value by stack drivers.
> >
> > And there is a bug. If all member disks are rotational devices,
> > raid0/raid10 set max_discard_sectors. So the member devices are
> > not ssd/nvme, but raid0/raid10 export the wrong value. It reports
> > warning messages in function __blkdev_issue_discard when mkfs.xfs
> > like this:
> >
> > [ 4616.022599] ------------[ cut here ]------------
> > [ 4616.027779] WARNING: CPU: 4 PID: 99634 at block/blk-lib.c:50 __blkdev_issue_discard+0x16a/0x1a0
> > [ 4616.140663] RIP: 0010:__blkdev_issue_discard+0x16a/0x1a0
> > [ 4616.146601] Code: 24 4c 89 20 31 c0 e9 fe fe ff ff c1 e8 09 8d 48 ff 4c 89 f0 4c 09 e8 48 85 c1 0f 84 55 ff ff ff b8 ea ff ff ff e9 df fe ff ff <0f> 0b 48 8d 74 24 08 e8 ea d6 00 00 48 c7 c6 20 1e 89 ab 48 c7 c7
> > [ 4616.167567] RSP: 0018:ffffaab88cbffca8 EFLAGS: 00010246
> > [ 4616.173406] RAX: ffff9ba1f9e44678 RBX: 0000000000000000 RCX: ffff9ba1c9792080
> > [ 4616.181376] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff9ba1c9792080
> > [ 4616.189345] RBP: 0000000000000cc0 R08: ffffaab88cbffd10 R09: 0000000000000000
> > [ 4616.197317] R10: 0000000000000012 R11: 0000000000000000 R12: 0000000000000000
> > [ 4616.205288] R13: 0000000000400000 R14: 0000000000000cc0 R15: ffff9ba1c9792080
> > [ 4616.213259] FS:  00007f9a5534e980(0000) GS:ffff9ba1b7c80000(0000) knlGS:0000000000000000
> > [ 4616.222298] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [ 4616.228719] CR2: 000055a390a4c518 CR3: 0000000123e40006 CR4: 00000000001706e0
> > [ 4616.236689] Call Trace:
> > [ 4616.239428]  blkdev_issue_discard+0x52/0xb0
> > [ 4616.244108]  blkdev_common_ioctl+0x43c/0xa00
> > [ 4616.248883]  blkdev_ioctl+0x116/0x280
> > [ 4616.252977]  __x64_sys_ioctl+0x8a/0xc0
> > [ 4616.257163]  do_syscall_64+0x5c/0x90
> > [ 4616.261164]  ? handle_mm_fault+0xc5/0x2a0
> > [ 4616.265652]  ? do_user_addr_fault+0x1d8/0x690
> > [ 4616.270527]  ? do_syscall_64+0x69/0x90
> > [ 4616.274717]  ? exc_page_fault+0x62/0x150
> > [ 4616.279097]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > [ 4616.284748] RIP: 0033:0x7f9a55398c6b
> >
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > Reported-by: Yi Zhang <yi.zhang@redhat.com>
>
> Reviewed-by: Ming Lei <ming.lei@redhat.com>

Applied to md-next.

Thanks,
Song

>
