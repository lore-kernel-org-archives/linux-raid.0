Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BE7BC433ED
	for <linux-raid@archiver.kernel.org>; Mon, 26 Apr 2021 06:32:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E76A561176
	for <linux-raid@archiver.kernel.org>; Mon, 26 Apr 2021 06:32:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231986AbhDZGcy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 26 Apr 2021 02:32:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231879AbhDZGcx (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 26 Apr 2021 02:32:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C48C61176
        for <linux-raid@vger.kernel.org>; Mon, 26 Apr 2021 06:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619418732;
        bh=YHDKRiWEtZpu0awMNhjU8k1WAJujacmHWaZD/hk7B/w=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=OhO0SskHAu0lnMp6HODQzl9xB+pJC9kfJORqWzhDH1sbiDXaazT/3XzeCYB8xs/8l
         o4/CrMUIdvMJ0gnNacWLrX8/wlhvwjLSFFV15SajxZYn3ubKd+kZxh7u+C5NTRFCoi
         avbRgXRqykQwaDNOlsplIjTuOlJ4fpOmiGIFxgpex5u0RmSPWL4X+OrCPCg60QQvzI
         bhIMouSe7jwCB2TQAhywzFo8NEeGhWi2R0CMvGchkflC0+RjagF84mUUIGZcVWf+cr
         ZX3BzmioJyaQEAwwlKztVFTEILgGtWAgNzWQg64TyVNKXCbjtHYGpfDyljoXsJFwUZ
         eckxXwtmfsRUg==
Received: by mail-lf1-f41.google.com with SMTP id x20so56276586lfu.6
        for <linux-raid@vger.kernel.org>; Sun, 25 Apr 2021 23:32:12 -0700 (PDT)
X-Gm-Message-State: AOAM533ovlYO6Bo4gcu7ExeVUyj0tvVJcDr3ljEFpfsByYy+UFkymDYt
        cxpjiw9p7HKmAsPQyL9r/2Z4Ia25zFOah5rzad0=
X-Google-Smtp-Source: ABdhPJznO+6bqlFJSPI46rG3DIKoFukhbmMdPaBVZMe46tzzvpLtVrlyjjF59kdPnXvvWFvMItXHu+tdLarxJTAZ1hk=
X-Received: by 2002:ac2:44c3:: with SMTP id d3mr11226485lfm.176.1619418730983;
 Sun, 25 Apr 2021 23:32:10 -0700 (PDT)
MIME-Version: 1.0
References: <1619342577-6034-1-git-send-email-xni@redhat.com>
In-Reply-To: <1619342577-6034-1-git-send-email-xni@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Sun, 25 Apr 2021 23:32:00 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4UskVrBPqEdTTZuTvWztoUtNk6tb06_9ZMR+pzbLgh-w@mail.gmail.com>
Message-ID: <CAPhsuW4UskVrBPqEdTTZuTvWztoUtNk6tb06_9ZMR+pzbLgh-w@mail.gmail.com>
Subject: Re: [PATCH 1/1] async_xor: It should add src_offs when dropping
 destination page
To:     Xiao Ni <xni@redhat.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Yufen Yu <yuyufen@huawei.com>,
        Nigel Croxon <ncroxon@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, Apr 25, 2021 at 2:23 AM Xiao Ni <xni@redhat.com> wrote:
>
> Now we support sharing one page if PAGE_SIZE is not equal stripe size. To support this,
> it needs to support calculating xor value with different offsets for each r5dev. One
> offset array is used to record those offsets.
>
> In RMW mode, parity page is used as a source page. It sets ASYNC_TX_XOR_DROP_DST before
> calculating xor value in ops_run_prexor5. So it needs to add src_list and src_offs at
> the same time. Now it only needs src_list. So the xor value which is calculated is wrong.
> It can cause data corruption problem.
>
> I can reproduce this problem 100% on a POWER8 machine. The steps are:
> mdadm -CR /dev/md0 -l5 -n3 /dev/sdb1 /dev/sdc1 /dev/sdd1 --size=3G
> mkfs.xfs /dev/md0
> mount /dev/md0 /mnt/test
> mount: /mnt/test: mount(2) system call failed: Structure needs cleaning.
>

Thanks for the fix! Applied to md-next.

A few nits for future patches:

> Fixes: 29bcff787 ("md/raid5: add new xor function to support different page offset")

Please use "Fixes" with the first 12 characters of the hash: 29bcff787a25.

Also please run checkpatch.pl for the patch. In this one, it complains:

WARNING: Possible unwrapped commit description (prefer a maximum 75
chars per line)

Thanks,
Song


> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  crypto/async_tx/async_xor.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
> index a057ecb..6cd7f70 100644
> --- a/crypto/async_tx/async_xor.c
> +++ b/crypto/async_tx/async_xor.c
> @@ -233,6 +233,7 @@ async_xor_offs(struct page *dest, unsigned int offset,
>                 if (submit->flags & ASYNC_TX_XOR_DROP_DST) {
>                         src_cnt--;
>                         src_list++;
> +                       src_offs++;
>                 }
>
>                 /* wait for any prerequisite operations */
> --
> 2.7.5
>
