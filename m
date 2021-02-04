Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E567C433DB
	for <linux-raid@archiver.kernel.org>; Thu,  4 Feb 2021 08:13:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E787C64F51
	for <linux-raid@archiver.kernel.org>; Thu,  4 Feb 2021 08:13:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234927AbhBDINK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 4 Feb 2021 03:13:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:57286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234918AbhBDINJ (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 4 Feb 2021 03:13:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 161CF64F4D
        for <linux-raid@vger.kernel.org>; Thu,  4 Feb 2021 08:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612426348;
        bh=cLikH0Gaf6kB2lziknnT4r7OB6z2hHvDYKt15YW8GpA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=XxaFZrSoP12UTObG4p5dfA3jjZEGea2EYFaCc1Z/oVtBM36KVioIjXD3VPxwt1Vno
         bPsenmdSFYX1yyVyPkGY9b9CdnSydHyyfm58oYFcBSW843kUcBhzJkMf92wSb7czFg
         XXgWeS+AyuUeK5YSFXsh9Pd6pmFfgN+N6N/SBHlOIjHaN9u1SzfZMcbp2iA/t9wGup
         f87XRSxBe0nU+44mR48VhPgEDUB/qZaAc7pAcjTm0pDaMpJ/8MAOiuubJ6z/MeoFb1
         P60UvISGR7YynLs33oKQHQYuofxvEqjAp6PHgzex+dnzYav0BmXysEQEvAUzEN4l2W
         DoHOqJTiq4izw==
Received: by mail-lj1-f171.google.com with SMTP id y14so2310077ljn.8
        for <linux-raid@vger.kernel.org>; Thu, 04 Feb 2021 00:12:27 -0800 (PST)
X-Gm-Message-State: AOAM532OTiuBqK4d9gBNlfjnD0TkD/oD4bvkoof9Bh7Nc/MaUTUe5Qnk
        A37/nfgN2/GlSKuySLRqeuAsN0hRTZf9NFFGXao=
X-Google-Smtp-Source: ABdhPJxSrfMcsTv2YQzj3Anxg8uUPYknFhxUEhyfp4LO2wVen/tYqT9ciGUhoZK05gze/CrKJX8QU2y20xPcWLw1KWg=
X-Received: by 2002:a2e:918f:: with SMTP id f15mr4007603ljg.357.1612426346259;
 Thu, 04 Feb 2021 00:12:26 -0800 (PST)
MIME-Version: 1.0
References: <1612418238-9976-1-git-send-email-xni@redhat.com> <6359e6e0-4e50-912c-1f97-ae07db3eba70@redhat.com>
In-Reply-To: <6359e6e0-4e50-912c-1f97-ae07db3eba70@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 4 Feb 2021 00:12:15 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6paostmNby1sHTPYM+2mmz_wxKBTw7e1G6tGFtema7Ow@mail.gmail.com>
Message-ID: <CAPhsuW6paostmNby1sHTPYM+2mmz_wxKBTw7e1G6tGFtema7Ow@mail.gmail.com>
Subject: Re: [PATCH V2 0/5] md/raid10: Improve handling raid10 discard request
To:     Xiao Ni <xni@redhat.com>
Cc:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Matthew Ruffell <matthew.ruffell@canonical.com>,
        Coly Li <colyli@suse.de>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Nigel Croxon <ncroxon@redhat.com>, hch@infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Feb 3, 2021 at 11:42 PM Xiao Ni <xni@redhat.com> wrote:
>
> Hi Song
>
> Please ignore the v2 version. There is a place that needs to be fix.
> I'll re-send
> v2 version again.

What did you change in the new v2? Removing "extern" in the header?
For small changes like this, I can just update it while applying the patches.
If we do need resend (for bigger changes), it's better to call it v3.

I was testing the first v2 in the past hour or so, it looks good in the test.
I will take a closer look tomorrow. On the other hand, we are getting close
to the 5.12 merge window, so it is a little too late for bigger
changes like this.
Therefore, I would prefer to wait until 5.13. If you need it in 5.12 for some
reason, please let me know.

Thanks,
Song

>
> Regards
> Xiao
>
> On 02/04/2021 01:57 PM, Xiao Ni wrote:
> > Hi all
> >
> > Now mkfs on raid10 which is combined with ssd/nvme disks takes a long time.
> > This patch set tries to resolve this problem.
> >
> > This patch set had been reverted because of a data corruption problem. This
> > version fix this problem. The root cause which causes the data corruption is
> > the wrong calculation of start address of near copies disks.
> >
> > Now we use a similar way with raid0 to handle discard request for raid10.
> > Because the discard region is very big, we can calculate the start/end
> > address for each disk. Then we can submit the discard request to each disk.
> > But for raid10, it has copies. For near layout, if the discard request
> > doesn't align with chunk size, we calculate a start_disk_offset. Now we only
> > use start_disk_offset for the first disk, but it should be used for the
> > near copies disks too.
> >
> > [  789.709501] discard bio start : 70968, size : 191176
> > [  789.709507] first stripe index 69, start disk index 0, start disk offset 70968
> > [  789.709509] last stripe index 256, end disk index 0, end disk offset 262144
> > [  789.709511] disk 0, dev start : 70968, dev end : 262144
> > [  789.709515] disk 1, dev start : 70656, dev end : 262144
> >
> > For example, in this test case, it has 2 near copies. The start_disk_offset
> > for the first disk is 70968. It should use the same offset address for second disk.
> > But it uses the start address of this chunk. It discard more region. This version
> > simply spilt the un-aligned part with strip size.
> >
> > And it fixes another problem. The calculation of stripe_size is wrong in reverted version.
> >
> > V2: Fix problems pointed by Christoph Hellwig.
> >
> > Xiao Ni (5):
> >    md: add md_submit_discard_bio() for submitting discard bio
> >    md/raid10: extend r10bio devs to raid disks
> >    md/raid10: pull the code that wait for blocked dev into one function
> >    md/raid10: improve raid10 discard request
> >    md/raid10: improve discard request for far layout
> >
> >   drivers/md/md.c     |  20 +++
> >   drivers/md/md.h     |   2 +
> >   drivers/md/raid0.c  |  14 +-
> >   drivers/md/raid10.c | 434 +++++++++++++++++++++++++++++++++++++++++++++-------
> >   drivers/md/raid10.h |   1 +
> >   5 files changed, 402 insertions(+), 69 deletions(-)
> >
>
