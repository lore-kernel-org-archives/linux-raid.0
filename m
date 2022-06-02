Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02231C43334
	for <linux-raid@archiver.kernel.org>; Thu,  2 Jun 2022 08:13:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbiFBINK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Jun 2022 04:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232093AbiFBINJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 2 Jun 2022 04:13:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7DF2B23D569
        for <linux-raid@vger.kernel.org>; Thu,  2 Jun 2022 01:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654157585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g4gniNX8/SfFZLtRRTdLDWgchWvkDNhdte2hr93FPGw=;
        b=JO95857vjXr86EtktSJ2L18avFxKu8mi8l3wEAQvoyJ1YADoHXK+3diC3AVCux0AWCUuqV
        r3BSYpLFTH6j1WtKIdr9WWR8y+4BJ6NZ3Jrkqo9tw3xQ9wtP+xbrFt+VFfe/x72uyIG/b3
        JD6qL6IOkYP2LzO6wJSfxIbSjliRqPw=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-185-wBbKiuPCN7CquLu7bgYgPA-1; Thu, 02 Jun 2022 04:13:04 -0400
X-MC-Unique: wBbKiuPCN7CquLu7bgYgPA-1
Received: by mail-oi1-f198.google.com with SMTP id j15-20020acaeb0f000000b0032b0d340a72so1866527oih.15
        for <linux-raid@vger.kernel.org>; Thu, 02 Jun 2022 01:13:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g4gniNX8/SfFZLtRRTdLDWgchWvkDNhdte2hr93FPGw=;
        b=7jMHXFEip/IpMrsmmaJXM/ZMkKqZ+bfpjgvOC+Jx4m4EzA+FgJ6+LeppuBh+y1tOLg
         40NoW2WzxCTiMSIlCsz/RLeqFvPPOJGOxvj1GTO2mTwqWE3dnXG8N2pFTt/XvysxIysI
         5rL/DeJwuO1U3IXWWM3UQuavk/iXIblAy75oyyby8grQ46ztU5MO1ud7BfdY/9shqLwK
         f54a33b36k+Q/ypKa6UvFrQ0soNd7CJnE2YEC5CBw7aSh6B5pEi4yst71Yu/GhLkWPKT
         5UbSgPMn7LbSX83xO0UeeXIzOdCxhrHtbMFcKIkfZIZTeO1h2g70WzVYymPNALA9a2fm
         6sTw==
X-Gm-Message-State: AOAM533mahYnSbKJrw/s8MZG5N9YIh793V4GK4hy7hL05SMDmdqGDigr
        BBEIgm8f4krc/eViNYTP2kAtWq1FF8oGf2lBLRuoVzt0V8mrCdT3JW+6OpyT06KexpKU/DBn3VG
        IvO82anEZ3q8nXDq8wClX4JeRmudQ1SMaiIiuiA==
X-Received: by 2002:a4a:a3c1:0:b0:411:6091:9f6e with SMTP id t1-20020a4aa3c1000000b0041160919f6emr1554988ool.16.1654157583467;
        Thu, 02 Jun 2022 01:13:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzwwFD3xJKdlcEofNPecMYzXZGZKQFGgighlu9WFUuuy+FX2Ws1H26k9jqDYT7Sk0NCUvx/8+7Z9pgeOdbbIak=
X-Received: by 2002:a4a:a3c1:0:b0:411:6091:9f6e with SMTP id
 t1-20020a4aa3c1000000b0041160919f6emr1554987ool.16.1654157583213; Thu, 02 Jun
 2022 01:13:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220505081641.21500-1-guoqing.jiang@linux.dev>
 <20220506113656.25010-1-guoqing.jiang@linux.dev> <CAPhsuW6mGnkg4x5xm6x5n06JXxF-7PNubpQiZNmX0BH9Zo1ncA@mail.gmail.com>
 <141b4110-767e-7670-21d5-6a5f636d1207@linux.dev> <CAPhsuW6U3g-Xikbw4mAJOH1-kN42rYHLiq_ocv==436azhm33g@mail.gmail.com>
 <b4244eab-d9e2-20a0-ebce-1a96e8fadb91@deltatee.com>
In-Reply-To: <b4244eab-d9e2-20a0-ebce-1a96e8fadb91@deltatee.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Thu, 2 Jun 2022 16:12:52 +0800
Message-ID: <CALTww29qH0vGywgfw3Hd3cUhwtQm1Vpp8ggR6qabgT4cAAPj6g@mail.gmail.com>
Subject: Re: [Update PATCH V3] md: don't unregister sync_thread with
 reconfig_mutex held
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     Song Liu <song@kernel.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Donald Buczek <buczek@molgen.mpg.de>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi all

I've tried the test and got the same result.  8b48ec23cc51(md: don't
unregister sync_thread with reconfig_mutex held)
introduces this problem.

My environment:
kernel: latest md-next branch
mdadm: Logan's tree bugfixes2 branch
(https://github.com/lsgunth/mdadm/) because Logan fixed some
errors for the test cases. I'm also trying to fix other failures based
on the tree.

Case1:
mdadm -CR /dev/md0 -amd -l5 -c 1024 -n2 --assume-clean /dev/loop1 /dev/loop2
mkfs.xfs /dev/md0
mount /dev/md0 /mnt/
mdadm /dev/md0 -a /dev/loop0
mdadm /dev/md0 --grow -n3
cat /proc/mdstat
umount  /mnt/
mdadm --stop /dev/md0
mdadm -A /dev/md0 /dev/loop[0-2]
cat /proc/mdstat (reshape doesn't happen)
mount /dev/md0 /mnt/  (fails here)
mount: /mnt: wrong fs type, bad option, bad superblock on /dev/md0,
missing codepage or helper program, or other error.

Case2:
I commented some codes, built the md module and insmod the new module
        //if (reconfig_mutex_held)
        //      mddev_unlock(mddev);
        /* resync has finished, collect result */
        md_unregister_thread(&mddev->sync_thread);
        //if (reconfig_mutex_held)
        //      mddev_lock_nointr(mddev);

The test Case1 can pass

Need to look more to find the root cause. It looks like some
information in superblock doesn't sync to member devices.
So after assemble, it can't do reshape again. Need more time to look at this.

Best Regards
Xiao

On Sat, May 21, 2022 at 2:27 AM Logan Gunthorpe <logang@deltatee.com> wrote:
>
>
> Hi,
>
> On 2022-05-10 00:44, Song Liu wrote:
> > On Mon, May 9, 2022 at 1:09 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
> >> On 5/9/22 2:37 PM, Song Liu wrote:
> >>> On Fri, May 6, 2022 at 4:37 AM Guoqing Jiang<guoqing.jiang@linux.dev>  wrote:
> >>>> From: Guoqing Jiang<guoqing.jiang@cloud.ionos.com>
> >>>>
> >>>> Unregister sync_thread doesn't need to hold reconfig_mutex since it
> >>>> doesn't reconfigure array.
> >>>>
> >>>> And it could cause deadlock problem for raid5 as follows:
> >>>>
> >>>> 1. process A tried to reap sync thread with reconfig_mutex held after echo
> >>>>     idle to sync_action.
> >>>> 2. raid5 sync thread was blocked if there were too many active stripes.
> >>>> 3. SB_CHANGE_PENDING was set (because of write IO comes from upper layer)
> >>>>     which causes the number of active stripes can't be decreased.
> >>>> 4. SB_CHANGE_PENDING can't be cleared since md_check_recovery was not able
> >>>>     to hold reconfig_mutex.
> >>>>
> >>>> More details in the link:
> >>>> https://lore.kernel.org/linux-raid/5ed54ffc-ce82-bf66-4eff-390cb23bc1ac@molgen.mpg.de/T/#t
> >>>>
> >>>> Let's call unregister thread between mddev_unlock and mddev_lock_nointr
> >>>> (thanks for the report from kernel test robot<lkp@intel.com>) if the
> >>>> reconfig_mutex is held, and mddev_is_locked is introduced accordingly.
> >>> mddev_is_locked() feels really hacky to me. It cannot tell whether
> >>> mddev is locked
> >>> by current thread. So technically, we can unlock reconfigure_mutex for
> >>> other thread
> >>> by accident, no?
> >>
> >> I can switch back to V2 if you think that is the correct way to do though no
> >> one comment about the change in dm-raid.
> >
> > I guess v2 is the best at the moment. I pushed a slightly modified v2 to
> > md-next.
> >
>
> I noticed a clear regression with mdadm tests with this patch in md-next
> (7e6ba434cc6080).
>
> Before the patch, tests 07reshape5intr and 07revert-grow would fail
> fairly infrequently (about 1 in 4 runs for the former and 1 in 30 runs
> for the latter).
>
> After this patch, both tests always fail.
>
> I don't have time to dig into why this is, but it would be nice if
> someone can at least fix the regression. It is hard to make any progress
> on these tests if we are continuing to further break them.
>
> Logan
>

