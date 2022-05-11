Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C4C7C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 11 May 2022 21:45:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348266AbiEKVpe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 11 May 2022 17:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243914AbiEKVpc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 11 May 2022 17:45:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126F3880F3
        for <linux-raid@vger.kernel.org>; Wed, 11 May 2022 14:45:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EBD461C5B
        for <linux-raid@vger.kernel.org>; Wed, 11 May 2022 21:45:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006F1C34115
        for <linux-raid@vger.kernel.org>; Wed, 11 May 2022 21:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652305531;
        bh=IxWMzcgZioHCDdMVwHdSOLoZjnGiCKzb+kLARvCDQmU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=aqLFtI6/qH3CGxn8+dZHu9Q+aUdU3SGwsj/izvxAbkyaqeVWADpuR+sanDK4UZMQq
         eoiJp5TYSXujx7SLRBNcQ03FIbhM4+izfNwgPS1gCmQInBHqWqjefWlYVIbn8tZQh1
         aXnc4mmSlcihn2CcMRtgRjfRz4nI7TnDl+utZZeByJrxpHtCYAtaU/EJp5EktLi3uN
         mNJqeiCvDQWatK467QaEeQutjGHIzXq3rdzkgcMA98MUqwE8jjKvYBLSSf2yHSeddD
         GVZRu5P0LuWdHOq1YcxemIB2fWnOXiKRfsalhQ2a+Qy6xFNez1tUjsHTo9a7pdh/cI
         eqausgOWOKW0Q==
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-2f16645872fso36578367b3.4
        for <linux-raid@vger.kernel.org>; Wed, 11 May 2022 14:45:30 -0700 (PDT)
X-Gm-Message-State: AOAM533oQGiNRWLQ6++9CuxQzAOJAmdrRt3NkmbTiNpViE+Gqzx4L1Qe
        bnEbOLiERRdaWUgT5ClSoWGYyOuKgkSS9kN5AKE=
X-Google-Smtp-Source: ABdhPJy6HpZCoHYZjcees1YT0ColuohVoeqAMlnr1IVMY8WRgWL/KJv6lAdJyD4mcvhm0/XToD6+BK9jo0ypFW7l5T8=
X-Received: by 2002:a81:9b57:0:b0:2f1:49eb:1ad9 with SMTP id
 s84-20020a819b57000000b002f149eb1ad9mr28165031ywg.130.1652305530008; Wed, 11
 May 2022 14:45:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220505081641.21500-1-guoqing.jiang@linux.dev>
 <20220506113656.25010-1-guoqing.jiang@linux.dev> <CAPhsuW6mGnkg4x5xm6x5n06JXxF-7PNubpQiZNmX0BH9Zo1ncA@mail.gmail.com>
 <141b4110-767e-7670-21d5-6a5f636d1207@linux.dev> <CAPhsuW6U3g-Xikbw4mAJOH1-kN42rYHLiq_ocv==436azhm33g@mail.gmail.com>
 <fdabab9e-e0ce-330d-b4db-0a11fde82615@molgen.mpg.de> <e50fa5ee-156a-aa22-fc49-390cefa3875f@linux.dev>
 <675626ff-f18b-78ab-f5a0-2ee44ab0d399@molgen.mpg.de> <CAPhsuW4ZVkzQa=UKz=TR52ye23RAyubUOgdhT7=OGqTR8uWwVw@mail.gmail.com>
 <52e9aa65-581a-63fc-272a-0477f8c6e873@linux.dev>
In-Reply-To: <52e9aa65-581a-63fc-272a-0477f8c6e873@linux.dev>
From:   Song Liu <song@kernel.org>
Date:   Wed, 11 May 2022 14:45:18 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5mai7WfnzdKHv=eUaYwcR1QHFc=6zuVZ8=WVW8Xn2Miw@mail.gmail.com>
Message-ID: <CAPhsuW5mai7WfnzdKHv=eUaYwcR1QHFc=6zuVZ8=WVW8Xn2Miw@mail.gmail.com>
Subject: Re: [Update PATCH V3] md: don't unregister sync_thread with
 reconfig_mutex held
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     Donald Buczek <buczek@molgen.mpg.de>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, May 11, 2022 at 1:10 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>
>
>
> On 5/11/22 2:02 AM, Song Liu wrote:
> > On Tue, May 10, 2022 at 5:35 AM Donald Buczek <buczek@molgen.mpg.de> wrote:
> >> On 5/10/22 2:09 PM, Guoqing Jiang wrote:
> >>>
> >>> On 5/10/22 8:01 PM, Donald Buczek wrote:
> >>>>> I guess v2 is the best at the moment. I pushed a slightly modified v2 to
> >>>>> md-next.
> >>>> I think, this can be used to get a double-free from md_unregister_thread.
> >>>>
> >>>> Please review
> >>>>
> >>>> https://lore.kernel.org/linux-raid/8312a154-14fb-6f07-0cf1-8c970187cc49@molgen.mpg.de/
> >>> That is supposed to be addressed by the second one, pls consider it too.
> >> Right, but this has not been pulled into md-next. I just wanted to note, that the current state of md-next has this problem.
>
> Thanks for reminder.
>
> >> If the other patch is taken, too, and works as intended, that would be solved.
> >>
> >>> [PATCH 2/2] md: protect md_unregister_thread from reentrancy
> > Good catch!
> >
> > Guoqing, current 2/2 doesn't apply cleanly. Could you please resend it on top of
> > md-next?
>
> Hmm, no issue from my side.
>
> ~/source/md> git am
> 0001-md-protect-md_unregister_thread-from-reentrancy.patch
> Applying: md: protect md_unregister_thread from reentrancy
>
> ~/source/md> git log --oneline |head -5
> dc7147a88766 md: protect md_unregister_thread from reentrancy
> 5a36c493dc82 md: don't unregister sync_thread with reconfig_mutex held
> 49c3b9266a71 block: null_blk: Improve device creation with configfs
> db060f54e0c5 block: null_blk: Cleanup messages
> b3a0a73e8a79 block: null_blk: Cleanup device creation and deletion
>
> Anyway, it is attached. I will rebase it to your latest tree if
> something gets wrong.

Applied to md-next. Thanks!

Song
