Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1AF6C433FE
	for <linux-raid@archiver.kernel.org>; Sun, 23 Oct 2022 09:16:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiJWJQ3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 23 Oct 2022 05:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbiJWJQ1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 23 Oct 2022 05:16:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF98D74CF1
        for <linux-raid@vger.kernel.org>; Sun, 23 Oct 2022 02:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666516567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AmyitK49/6nlQy2FbEwsH3UkZ1B0KJKXNOuLeG7C9E0=;
        b=PyCoNrOBWPuMI5jRBoxMCgfoIrxsIULtKJfjTv0SDBvpzn5F4xojLInB+z19feQd9JNzwg
        yWbD916T+1tH0AWiFeas8uteAadrqwExk6pewTFjRSgyNoGSmxWeyD4C49U2WKNURYlD1f
        UdNLWHX24KBUM7+tu3Bd+YZ4B+h1uYs=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-660-i_XOKMt9M2y6pPmexWduxA-1; Sun, 23 Oct 2022 05:16:06 -0400
X-MC-Unique: i_XOKMt9M2y6pPmexWduxA-1
Received: by mail-pg1-f197.google.com with SMTP id v18-20020a637a12000000b0046ed84b94efso1497778pgc.6
        for <linux-raid@vger.kernel.org>; Sun, 23 Oct 2022 02:16:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AmyitK49/6nlQy2FbEwsH3UkZ1B0KJKXNOuLeG7C9E0=;
        b=1NpcrK0rg5Qh9jgn7cCFGnuHcKhXAjFUmanzJJudRpVfhTQHsFPY0g08fUpGYphm34
         OSHqC3QPOsnMy/W2IlulUb6BHm034+I4lHg7ioXLcyU/BgYAcvc4bpFzqG4kzg5c7BL8
         OQKlMOBMeFttMSeAgMgTqd6jPg/tDuWnaEXUivc0oG4EEY7YB/wWn2dMaEVzIneK9zlL
         MduxMN4DiSlbYqpCDh7gG30ZGzb7v1E/YX6idTMT4KikQna3JZ3sqBJYi+b69XyODprK
         Zp9GNMArqt2aVfInr0y0uzqDHaJLd5ZWAcbNL/iDhre6M56V/pWtwWOUxiJe84W3+bVY
         MI9Q==
X-Gm-Message-State: ACrzQf0HsLZFksDDBJ03I/GbcGIPrqXpA2pDHngSFGh/vRXqm3E+v+RU
        nmHrC/aTX2l4FVlycE4S+Ca9IPu/dC8c/PDtpKRmsjm12eTYLewCR4AcmLniiVEiLC+8pD1XDpJ
        b7F/fpvvKK8MP/Qrt/hSajQ1n7D24PFOPtq6djg==
X-Received: by 2002:a63:d349:0:b0:460:b5ee:60ef with SMTP id u9-20020a63d349000000b00460b5ee60efmr22723297pgi.288.1666516563883;
        Sun, 23 Oct 2022 02:16:03 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6yWvAxKxHshUkQqh7bpo4R6XCJAqHWOzax4ZSfU9n/NSdOCKtsWqgW7aIA7ZZU3QB1UGpcP5/6DvtKKfceBsw=
X-Received: by 2002:a63:d349:0:b0:460:b5ee:60ef with SMTP id
 u9-20020a63d349000000b00460b5ee60efmr22723276pgi.288.1666516563554; Sun, 23
 Oct 2022 02:16:03 -0700 (PDT)
MIME-Version: 1.0
References: <20221017021116.39374-1-xni@redhat.com> <CAPhsuW5ptwgE193G44BQF_9DwfewO+de_YYeAQFVpCWfWvL-Xg@mail.gmail.com>
 <CALTww2_bDpuJrBFKos2bFCsk_Z=_=dCe8kKhxNoX-Mhb7i4wLg@mail.gmail.com> <CAPhsuW5p=Hu8r+8qH1sxWBmna68hjJ+=aZL-fmRbFbEpsb2vQQ@mail.gmail.com>
In-Reply-To: <CAPhsuW5p=Hu8r+8qH1sxWBmna68hjJ+=aZL-fmRbFbEpsb2vQQ@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Sun, 23 Oct 2022 17:15:51 +0800
Message-ID: <CALTww29M6sdefmCaP5Btd6BvR0i6YK9R-zo0YmnSTM76o2rTeA@mail.gmail.com>
Subject: Re: [PATCH 1/1] Add mddev->io_acct_cnt for raid0_quiesce
To:     Song Liu <song@kernel.org>
Cc:     guoqing.jiang@linux.dev, linux-raid@vger.kernel.org,
        ffan@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, Oct 22, 2022 at 5:10 AM Song Liu <song@kernel.org> wrote:
>
> On Fri, Oct 21, 2022 at 3:07 AM Xiao Ni <xni@redhat.com> wrote:
> >
> > On Fri, Oct 21, 2022 at 3:50 AM Song Liu <song@kernel.org> wrote:
> > >
> > > On Sun, Oct 16, 2022 at 7:11 PM Xiao Ni <xni@redhat.com> wrote:
> > > >
> > > > It has added io_acct_set for raid0/raid5 io accounting and it needs to
> > > > alloc md_io_acct in the i/o path. They are free when the bios come back
> > > > from member disks. Now we don't have a method to monitor if those bios
> > > > are all come back. In the takeover process, it needs to free the raid0
> > > > memory resource including the memory pool for md_io_acct. But maybe some
> > > > bios are still not returned. When those bios are returned, it can cause
> > > > panic bcause of introducing NULL pointer or invalid address.
> > > >
> > > > This patch adds io_acct_cnt. So when stopping raid0, it can use this
> > > > to wait until all bios come back.
> > > >
> > > > Reported-by: Fine Fan <ffan@redhat.com>
> > > > Signed-off-by: Xiao Ni <xni@redhat.com>
> > >
> > > I have seen a lot of warnings and errors in dmesg with this patch. For example:
> > >
> > > [  402.116463] =============================================================================
> > > [  402.117176] BUG bio-144 (Tainted: G    B   W         ): Right
> > > Redzone overwritten
> > > [  402.117837] -----------------------------------------------------------------------------
> > > [  402.117837]
> > > [  402.118713] 0xffff88816f683cd0-0xffff88816f683cd7 @offset=15568.
> > > First byte 0x0 instead of 0xcc
> > > [  402.119505] Allocated in mempool_alloc+0x79/0x1a0 age=1038 cpu=19 pid=1130
> > > [  402.120133]  kmem_cache_alloc+0x2dc/0x3c0
> > > [  402.120510]  mempool_alloc+0x79/0x1a0
> > > [  402.120840]  bio_alloc_bioset+0xcb/0x530
> > > [  402.121205]  bio_alloc_clone+0x20/0x60
> > > [  402.121560]  md_account_bio+0x41/0x80
> > > [  402.121890]  raid5_make_request+0x1cf/0x1450
> > > [  402.122327]  md_handle_request+0x26c/0x3f0
> > > [  402.122700]  __submit_bio+0x53/0x180
> > > [  402.123030]  submit_bio_noacct_nocheck+0xe8/0x2b0
> > > [  402.123453]  __blkdev_direct_IO_async+0x109/0x1d0
> > > [  402.123897]  generic_file_direct_write+0x9c/0x1e0
> > > [  402.124332]  __generic_file_write_iter+0x95/0x170
> > > [  402.124771]  blkdev_write_iter+0xe9/0x180
> > > [  402.125162]  aio_write+0x11a/0x2e0
> > > [  402.125503]  io_submit_one+0x627/0xd20
> > > [  402.125844]  __x64_sys_io_submit+0x88/0x250
> > > [  402.126223] Slab 0xffffea0005bda000 objects=51 used=51
> > > fp=0x0000000000000000 flags=0x200000000010200(slab|head|node=0|zone=2)
> > > [  402.127227] Object 0xffff88816f683c40 @offset=15424 fp=0x0000000000000000
> > > [  402.127227]
> > > [  402.127960] Redzone  ffff88816f683c00: cc cc cc cc cc cc cc cc cc
> > > cc cc cc cc cc cc cc  ................
> > > [  402.128797] Redzone  ffff88816f683c10: cc cc cc cc cc cc cc cc cc
> > > cc cc cc cc cc cc cc  ................
> > > [  402.129665] Redzone  ffff88816f683c20: cc cc cc cc cc cc cc cc cc
> > > cc cc cc cc cc cc cc  ................
> > > [  402.130503] Redzone  ffff88816f683c30: cc cc cc cc cc cc cc cc cc
> > > cc cc cc cc cc cc cc  ................
> > > [  402.131336] Object   ffff88816f683c40: 80 a3 68 6f 81 88 ff ff af
> > > 21 00 00 01 00 00 00  ..ho.....!......
> > > [  402.132166] Object   ffff88816f683c50: 00 00 00 00 00 00 00 00 80
> > > 23 09 0b 81 88 ff ff  .........#......
> > > [  402.132996] Object   ffff88816f683c60: 01 88 00 00 02 00 04 40 00
> > > 5a 5a 5a 00 00 00 00  .......@.ZZZ....
> > > [  402.133822] Object   ffff88816f683c70: 88 86 1c 00 00 00 00 00 00
> > > 10 00 00 00 00 00 00  ................
> > > [  402.134647] Object   ffff88816f683c80: 00 00 00 00 ff ff ff ff e0
> > > a9 a8 81 ff ff ff ff  ................
> > > [  402.135501] Object   ffff88816f683c90: 40 3c 68 6f 81 88 ff ff 00
> > > 00 00 00 00 00 00 00  @<ho............
> > > [  402.136354] Object   ffff88816f683ca0: 00 00 00 00 00 00 00 00 00
> > > 00 00 00 00 00 00 00  ................
> > > [  402.137174] Object   ffff88816f683cb0: 00 00 00 00 00 00 00 00 00
> > > 00 00 00 01 00 00 00  ................
> > > [  402.138027] Object   ffff88816f683cc0: 00 a4 68 6f 81 88 ff ff 40
> > > 2f c4 73 81 88 ff ff  ..ho....@/.s....
> > > [  402.138857] Redzone  ffff88816f683cd0: 00 20 c4 73 81 88 ff ff
> > >                     . .s....
> > > [  402.139657] Padding  ffff88816f683d20: 5a 5a 5a 5a 5a 5a 5a 5a 5a
> > > 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
> > > [  402.140510] Padding  ffff88816f683d30: 5a 5a 5a 5a 5a 5a 5a 5a 5a
> > > 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
> > > [  402.141345] CPU: 29 PID: 1092 Comm: md0_raid5 Tainted: G    B   W
> > >        6.1.0-rc1+ #145
> > > [  402.142083] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> > > BIOS rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014
> > > [  402.143127] Call Trace:
> > > [  402.143365]  <TASK>
> > > [  402.143563]  dump_stack_lvl+0x45/0x5d
> > > [  402.143899]  check_bytes_and_report.cold+0x6d/0x85
> > > [  402.144343]  check_object+0x1fa/0x2d0
> > > [  402.144675]  free_debug_processing+0x1bc/0x660
> > > [  402.145091]  ? md_end_io_acct+0x3c/0x80
> > > [  402.145464]  ? md_end_io_acct+0x3c/0x80
> > > [  402.145812]  kmem_cache_free+0x55f/0x5b0
> > > [  402.146164]  md_end_io_acct+0x3c/0x80
> > > [  402.146498]  handle_stripe+0x11a5/0x1d70
> > > [  402.146849]  handle_active_stripes.constprop.0+0x487/0x5e0
> > > [  402.147353]  raid5d+0x40d/0x680
> > > [  402.147640]  ? lock_acquire+0x1ad/0x310
> > > [  402.147989]  md_thread+0xc2/0x170
> > > [  402.148319]  ? prepare_to_wait_exclusive+0xe0/0xe0
> > > [  402.148749]  ? register_md_personality+0x90/0x90
> > > [  402.149162]  kthread+0xf2/0x120
> > > [  402.149455]  ? kthread_complete_and_exit+0x20/0x20
> > > [  402.149884]  ret_from_fork+0x22/0x30
> > > [  402.150211]  </TASK>
> > > [  402.150431] FIX bio-144: Restoring Right Redzone
> > > 0xffff88816f683cd0-0xffff88816f683cd7=0xcc
> > > [  402.151196] FIX bio-144: Object at 0xffff88816f683c40 not freed
> > >
> > > Please fix them and resend.
> > >
> > > Thanks,
> > > Song
> >
> > Hi Song
> >
> > What commands do you run? I've run some tests and didn't see the messages.
> > By the way, what disks do you use?
>
> I see these with regular IO. Some fio-libaio-direct workload should trigger it.
> This is running in Qemu on virtual nvme devices, and with some debug
> options enabled (KASAN, LOCKDEP, etc.).

Hi Song

I have reproduced this. Thanks for pointing this out. I'll fix this and re-send
v2.

Regards
Xiao

