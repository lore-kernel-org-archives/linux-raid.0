Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B4DC433DB
	for <linux-raid@archiver.kernel.org>; Mon, 22 Mar 2021 17:29:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9704B61994
	for <linux-raid@archiver.kernel.org>; Mon, 22 Mar 2021 17:29:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbhCVR2w (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 22 Mar 2021 13:28:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230381AbhCVR2k (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 22 Mar 2021 13:28:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9ADE6198E
        for <linux-raid@vger.kernel.org>; Mon, 22 Mar 2021 17:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616434120;
        bh=esQXG1/EJmCWFJd7zMttx3mNc3Uo6GCS+wrrenp/8og=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=psXJnnxJWfaVJbWvFsswJZGiW6Lpd1m5uxeIIIVsBrSVbW13k0TeOQcRe1TRtQRBw
         dURzbHIyCs8m2cgH7QdICRODOzRyqXHTUfKPRZ+NDTWfYT3iysXNJl+lDbtg2LRa8G
         caAoh2NtM9s/OGkSWH1cCose9W/keOWIJai8HC8g7rZSNhgPr0EMHh1clzEFAdLC16
         9Aoh4DJPIs8tuK6O/nVyx2yf2cIzdu+H3r8SrYOlemXktFKj52c1AFP4txEpMfT2ZZ
         L+wiCl5xa/089Pd2GYpXYDWmRuMx3E7udT+0wTpG+hyHNtb0+Eg/S7UcM6/NwOQFUj
         7nfBy87l7+kpw==
Received: by mail-lj1-f177.google.com with SMTP id z25so22089604lja.3
        for <linux-raid@vger.kernel.org>; Mon, 22 Mar 2021 10:28:39 -0700 (PDT)
X-Gm-Message-State: AOAM532vGUYaTz+oNm3DZ5/S2Rstl9/dBAYEW6noAf7sSc42jTZmNd4x
        /ZVE2pl4ee/e3USttnBCDUG61kM2EeDwd6m3FgM=
X-Google-Smtp-Source: ABdhPJzQ++TrTCoKi+CAXS7boMiyRabjJXylnFw6N19ZVBDrGdPdhZHUNa42+x8tavaU8ZgRN1a7scdoSMMcT6Hksfk=
X-Received: by 2002:a2e:8508:: with SMTP id j8mr401085lji.270.1616434117861;
 Mon, 22 Mar 2021 10:28:37 -0700 (PDT)
MIME-Version: 1.0
References: <225718c0-475c-7bd7-e067-778f7097a923@redhat.com> <cdb11ed6-646e-85e6-79f7-cbf38c92b324@huawei.com>
In-Reply-To: <cdb11ed6-646e-85e6-79f7-cbf38c92b324@huawei.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 22 Mar 2021 10:28:26 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5hV_-0+hcoK4b18h8gP6yy8UffV=wRQKtoCZbfXVu6fw@mail.gmail.com>
Message-ID: <CAPhsuW5hV_-0+hcoK4b18h8gP6yy8UffV=wRQKtoCZbfXVu6fw@mail.gmail.com>
Subject: Re: raid5 crash on system which PAGE_SIZE is 64KB
To:     Yufen Yu <yuyufen@huawei.com>
Cc:     Xiao Ni <xni@redhat.com>, linux-raid <linux-raid@vger.kernel.org>,
        Nigel Croxon <ncroxon@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        kent.overstreet@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Mar 16, 2021 at 2:20 AM Yufen Yu <yuyufen@huawei.com> wrote:
>
>
>
> On 2021/3/15 21:44, Xiao Ni wrote:
> > Hi all
> >
> > We encounter one raid5 crash problem on POWER system which PAGE_SIZE is 64KB.
> > I can reproduce this problem 100%.  This problem can be reproduced with latest upstream kernel.
> >
> > The steps are:
> > mdadm -CR /dev/md0 -l5 -n3 /dev/sda1 /dev/sdc1 /dev/sdd1
> > mkfs.xfs /dev/md0 -f
> > mount /dev/md0 /mnt/test
> >
> > The error message is:
> > mount: /mnt/test: mount(2) system call failed: Structure needs cleaning.
> >
> > We can see error message in dmesg:
> > [ 6455.761545] XFS (md0): Metadata CRC error detected at xfs_agf_read_verify+0x118/0x160 [xfs], xfs_agf block 0x2105c008
> > [ 6455.761570] XFS (md0): Unmount and run xfs_repair
> > [ 6455.761575] XFS (md0): First 128 bytes of corrupted metadata buffer:
> > [ 6455.761581] 00000000: fe ed ba be 00 00 00 00 00 00 00 02 00 00 00 00  ................
> > [ 6455.761586] 00000010: 00 00 00 00 00 00 03 c0 00 00 00 01 00 00 00 00  ................
> > [ 6455.761590] 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > [ 6455.761594] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > [ 6455.761598] 00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > [ 6455.761601] 00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > [ 6455.761605] 00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > [ 6455.761609] 00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > [ 6455.761662] XFS (md0): metadata I/O error in "xfs_read_agf+0xb4/0x1a0 [xfs]" at daddr 0x2105c008 len 8 error 74
> > [ 6455.761673] XFS (md0): Error -117 recovering leftover CoW allocations.
> > [ 6455.761685] XFS (md0): Corruption of in-memory data detected. Shutting down filesystem
> > [ 6455.761690] XFS (md0): Please unmount the filesystem and rectify the problem(s)
> >
> > This problem doesn't happen when creating raid device with --assume-clean. So the crash only happens when sync and normal
> > I/O write at the same time.
> >
> > I tried to revert the patch set "Save memory for stripe_head buffer" and the problem can be fixed. I'm looking at this problem,
> > but I haven't found the root cause. Could you have a look?
>
> Thanks for reporting this bug. Please give me some times to debug it,
> recently time is very limited for me.
>
> Thanks,
> Yufen

Hi Yufen,

Have you got time to look into this?

>
> >
> > By the way, there is a place that I can't understand. Is it a bug? Should we do in this way:
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index 5d57a5b..4a5e8ae 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -1479,7 +1479,7 @@ static struct page **to_addr_page(struct raid5_percpu *percpu, int i)
> >   static addr_conv_t *to_addr_conv(struct stripe_head *sh,
> >                                   struct raid5_percpu *percpu, int i)
> >   {
> > -       return (void *) (to_addr_page(percpu, i) + sh->disks + 2);
> > +       return (void *) (to_addr_page(percpu, i) + sizeof(struct page*)*(sh->disks + 2));

I guess we don't need this change. to_add_page() returns "struct page **", which
should have same size of "struct page*", no?

Thanks,
Song
