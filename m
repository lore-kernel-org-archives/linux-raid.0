Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F21C5C433ED
	for <linux-raid@archiver.kernel.org>; Fri,  2 Apr 2021 05:59:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA6CD610CE
	for <linux-raid@archiver.kernel.org>; Fri,  2 Apr 2021 05:59:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbhDBF7I (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 2 Apr 2021 01:59:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229599AbhDBF7I (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 2 Apr 2021 01:59:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06B59610D1
        for <linux-raid@vger.kernel.org>; Fri,  2 Apr 2021 05:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617343147;
        bh=Drjb2ymMTsv3clbFfeNSD24Yku+0PZd8N0PRCgj6jjA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=uNxy//Oq5Hwct87BlvJmn8NmLKr97u0vXJx+uMvobiUZVUyGYWQZThJtSFae5+5Y+
         PolZNu+3X9VFWSFK/qaZ1zqzm/UtRm7q5sdGiCl7Vnd2sDduXrz+pNlXeHq6tqJTdA
         VvP6Yq3j4qRGGhz/mg+5KaJD8xANP312cfd6PX+7zCHbNW+1mIrzhiI/HL4MYqZEzE
         zjiqUNCHIoWW5i/Hyxm2M/poCG3UDdj6TQuVkzLSYbDGCUAVytAJ17WIyBGYrBRDGd
         0GIpt865Ab9zqN+K125xlixT1aAozVAMKuV+bX6t1lNUk/WLZp9suMKFcpVzvqoewP
         xd5uQKBocuJ+A==
Received: by mail-lf1-f54.google.com with SMTP id d13so6154528lfg.7
        for <linux-raid@vger.kernel.org>; Thu, 01 Apr 2021 22:59:06 -0700 (PDT)
X-Gm-Message-State: AOAM531aitXvdJTs9GjYWbMlo/fxMIN429fAgG8kr1PiIA9iT37mRWJj
        od/SR4FiL1o4v4uNxoxguQsvYXoJ6HcGW3YlnoY=
X-Google-Smtp-Source: ABdhPJycHNeRkYBiNJKyr3bBd7TgdJiR/wcRAOzY8A+XyV9YzU1JS/57HraqHGUdBom3yU1FPuh7Y7g/U0LfpuqUW9Q=
X-Received: by 2002:a05:6512:3582:: with SMTP id m2mr7897778lfr.10.1617343145354;
 Thu, 01 Apr 2021 22:59:05 -0700 (PDT)
MIME-Version: 1.0
References: <1617240896-15343-1-git-send-email-heming.zhao@suse.com>
 <20210401061722.GA1355765@infradead.org> <a96554cc-abbd-347c-ea24-37d2a41e6073@suse.com>
In-Reply-To: <a96554cc-abbd-347c-ea24-37d2a41e6073@suse.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 1 Apr 2021 22:58:54 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6_9av6H=1LkD5qqpyOcA8j2jj8d660FUpadn3Jfd79Vw@mail.gmail.com>
Message-ID: <CAPhsuW6_9av6H=1LkD5qqpyOcA8j2jj8d660FUpadn3Jfd79Vw@mail.gmail.com>
Subject: Re: [PATCH v2] md: don't create mddev in md_open
To:     "heming.zhao@suse.com" <heming.zhao@suse.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        lidong.zhong@suse.com, Xiao Ni <xni@redhat.com>,
        NeilBrown <neilb@suse.de>, Coly Li <colyli@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Apr 1, 2021 at 6:03 AM heming.zhao@suse.com
<heming.zhao@suse.com> wrote:
>
> On 4/1/21 2:17 PM, Christoph Hellwig wrote:
> > On Thu, Apr 01, 2021 at 09:34:56AM +0800, Zhao Heming wrote:
> >> commit d3374825ce57 ("md: make devices disappear when they are no longer
> >> needed.") introduced protection between mddev creating & removing. The
> >> md_open shouldn't create mddev when all_mddevs list doesn't contain
> >> mddev. With currently code logic, there will be very easy to trigger
> >> soft lockup in non-preempt env.
> >
> > As mention below, please don't make this even more of a mess than it
> > needs to.  We can just pick the two patches doing this from the series
> > I sent:
> >
>
> Hi,
>
> I already got your meaning on previously email.
> I sent v2 patch for Song's review comment. My patch is bugfix, it may need
> to back port into branch maintenance.
>
> Your attachment patch files is partly my patch.
> The left part is in md_open (response [PATCH 01/15] md: remove the code to flush
> an old instance in md_open)
> I still think you directly use bdev->bd_disk->private_data as mddev pointer is not safe.
>

Hi Christoph and Heming,

Trying to understand the whole picture here. Please let me know if I
misunderstood anything.

IIUC, the primary goal of Christoph's set is to get rid of the
ERESTARTSYS hack from md,
and eventually move bd_mutext. 02/15 to 07/15 of this set cleans up
code in md.c, and they
are not very important for the rest of the set (is this correct?).

Heming, you mentioned "the solution may simply return -EBUSY (instead
of -ENODEV) to
fail the open path". Could you please show the code? Maybe that would
be enough to unblock
the second half of Christoph's set (08/15 to 15/15)?

Once this part is resolved, the bug fix (this patch thread) and the
clean up (Christoph's 02 - 07)
should be easier.

Would this work?

Thanks,
Song
