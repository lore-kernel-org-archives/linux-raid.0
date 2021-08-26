Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D606C432BE
	for <linux-raid@archiver.kernel.org>; Thu, 26 Aug 2021 16:18:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22F1261073
	for <linux-raid@archiver.kernel.org>; Thu, 26 Aug 2021 16:18:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232509AbhHZQTO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 26 Aug 2021 12:19:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:44258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243068AbhHZQTL (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 26 Aug 2021 12:19:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EA466108F
        for <linux-raid@vger.kernel.org>; Thu, 26 Aug 2021 16:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629994704;
        bh=Wkj3V+mEOzxowqGpf8EhkZNUQMWdwIaDITq6MinWkmc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=t/5jIqfgMEqRgaWxP5ipG/h0kGaHJdxxFEHdD50DFLNC3pifPTEcseTjCiSqomyBz
         vvkCon9SDalH+3WvrDqkVLIUHmbBkPrP1BqlkewMw0wiZoR4b3/d/RLpHIsvwTMGiH
         Fglk0fCnMIooKr+TEDa2cnuMdYlKuCN+vzSm5/xLjlL84zb0rGLSjh3oBqcqvJoQh+
         afdQhWdVup2dy+k6L9oGEzeJoUY+iO4l3ya8GRgCMUBLUysgAwPPb+gFpl+QZBKn7K
         yIeYsn5h7FnHZ9Dk1f5+jb1Q8LWLUdlqMKwvLIc9CW0JHzyjWEZurhkZDa+qQt23YQ
         v8UXVBhLmpWbg==
Received: by mail-lj1-f178.google.com with SMTP id q21so6134684ljj.6
        for <linux-raid@vger.kernel.org>; Thu, 26 Aug 2021 09:18:24 -0700 (PDT)
X-Gm-Message-State: AOAM533KuQl9R58C7kw85m9fkfI+3gcHN7MWVACw2XtbNWV9RdM7eAs5
        NNBwvKUzq86aq3jsySlWvzndak85WRNmVKFK124=
X-Google-Smtp-Source: ABdhPJxcqaNzUVb0lSygB9GRNx62ZZfLzVuARZHoiotHosEelqs7v+DrqVTViq7SwETSuXnFhU0IlDNg+SnZoWPk1U8=
X-Received: by 2002:a05:651c:390:: with SMTP id e16mr3939975ljp.344.1629994702751;
 Thu, 26 Aug 2021 09:18:22 -0700 (PDT)
MIME-Version: 1.0
References: <1629266268-3624-1-git-send-email-xni@redhat.com> <CAPhsuW73qcuf-a=ENW+f3ecb548uL2zHxir7dYixrnz5838gZw@mail.gmail.com>
In-Reply-To: <CAPhsuW73qcuf-a=ENW+f3ecb548uL2zHxir7dYixrnz5838gZw@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 26 Aug 2021 09:18:11 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7dZXX2i-3pBMWX0C5q+RBrmCuMUz=6_KkKYPu3USQBhQ@mail.gmail.com>
Message-ID: <CAPhsuW7dZXX2i-3pBMWX0C5q+RBrmCuMUz=6_KkKYPu3USQBhQ@mail.gmail.com>
Subject: Re: [PATCH v2] md/raid10: Remove rcu_dereference when it doesn't need
 rcu lock to protect
To:     Xiao Ni <xni@redhat.com>
Cc:     Nigel Croxon <ncroxon@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Aug 20, 2021 at 5:31 PM Song Liu <song@kernel.org> wrote:
>
> On Tue, Aug 17, 2021 at 10:58 PM Xiao Ni <xni@redhat.com> wrote:
> >
> > One warning message is triggered like this:
> > [  695.110751] =============================
> > [  695.131439] WARNING: suspicious RCU usage
> > [  695.151389] 4.18.0-319.el8.x86_64+debug #1 Not tainted
> > [  695.174413] -----------------------------
> > [  695.192603] drivers/md/raid10.c:1776 suspicious
> > rcu_dereference_check() usage!
> > [  695.225107] other info that might help us debug this:
> > [  695.260940] rcu_scheduler_active = 2, debug_locks = 1
> > [  695.290157] no locks held by mkfs.xfs/10186.
> >
> > In the first loop of function raid10_handle_discard. It already
> > determines which disk need to handle discard request and add the
> > rdev reference count rdev->nr_pending. So the conf->mirrors will
> > not change until all bios come back from underlayer disks. It
> > doesn't need to use rcu_dereference to get rdev.
> >
> > Fixes: d30588b2731f ('md/raid10: improve raid10 discard request')
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > Acked-by: Guoqing Jiang <guoqing.jiang@linux.dev>
>
> Applied to md-fixes. Thanks!

Moved to md-next as we are too close to 5.14 release.

Thanks,
Song
