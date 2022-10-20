Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2F23C433FE
	for <linux-raid@archiver.kernel.org>; Thu, 20 Oct 2022 06:44:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbiJTGoF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 Oct 2022 02:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbiJTGn7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 20 Oct 2022 02:43:59 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321581BE918
        for <linux-raid@vger.kernel.org>; Wed, 19 Oct 2022 23:43:57 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id v1so3455482wrt.11
        for <linux-raid@vger.kernel.org>; Wed, 19 Oct 2022 23:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vZ3WPnAwuuH8ZwPEokDYclQovYjngoRjcTiha/xFY3A=;
        b=GPNpMceknob9uMibQvsEwbkjSQeuxhlPGJ7Wlf8rOi+lAw9Yort7wghFBEsL7+NNv2
         YK6X2/WmIRYpOADRx+4aGg5okjqBmZBEDPA63E5Ir9yFBAVwLyC0OwIBdpVp4iq6KfH+
         kzqusdI7A3IcVYvktO5cAHkglwoJkBjOomYxeL/HRKmpuKWiYte9JMMxVy9IdVQ/h0SN
         mvx34Hp/A1r3acr9MmuY+Pk+IksG3gfjC9X1p5Lr1svnV7t21Sp8A9R3NujsKnOUlQe1
         a8L0trdczrVSKNLTQde8vZAov9Nz7tGLqKtvHTsgoaYnskVOlnytnufEWTTSnr1PrGIi
         2UhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vZ3WPnAwuuH8ZwPEokDYclQovYjngoRjcTiha/xFY3A=;
        b=EY3e7sdJBn2yXenxTtNQhI6f6m58aAmBeb8ZNGkcwSXXwMdCLm4AZ8PF2IoVHmKNi6
         HK2pq/pTQ5wz319AM3nXaTL+aQlkssJw9FxzzoQb1mtaMVGDBFiugpFXuI9MyUXauT8c
         D6no1LRBLkbc/vhO/NVw3wXIu1yIsyJu4nXhpuWynGZvlFL4N1o/UJKDSUg5bE5aGIN/
         eAhSQKzDswknmCnhTwzD0m4I6Yu+szbiG2dlGHBTdtrNxkJMTQfbPOC3ccySSuR7HYGE
         E/KGCeF4KLKfrsu8p9470YKOgcfab7iou5NFfC8LgdrRgyJRyugx4e9kd0TfhleNHRXE
         op5A==
X-Gm-Message-State: ACrzQf3knaGIIVobIQQjV+6ckP28r0zYigf7eyXogLnP4fDByoHve/JB
        BINBBlQF6W57qQNawrAsBJS+bveraDNENfZkHhw=
X-Google-Smtp-Source: AMsMyM7HFJLg0KzO5nopV6SOuipQ2sF1qGzUzMinAq//PGsat4hSKP27t4NBM+mzEQ91GwwUIO+PlbpcriTeQ4fosTM=
X-Received: by 2002:a05:6000:104:b0:22e:74bb:3a49 with SMTP id
 o4-20020a056000010400b0022e74bb3a49mr7025464wrx.349.1666248235181; Wed, 19
 Oct 2022 23:43:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAEQ-dADdRd91GBkTzVU0AQiXQ4tLitYsU2uLziWOi=hLtaBK0w@mail.gmail.com>
 <e9feaefd-9ddb-c07a-86b8-3640ca4201af@thelounge.net> <7ca2b272-4920-076f-ecaf-5109db0aae46@youngman.org.uk>
 <CAAMCDef4bGs_LnbxEie=2FkxD6YJ_A4WFzW8c647k9MNLGoY3A@mail.gmail.com>
In-Reply-To: <CAAMCDef4bGs_LnbxEie=2FkxD6YJ_A4WFzW8c647k9MNLGoY3A@mail.gmail.com>
From:   Umang Agarwalla <umangagarwalla111@gmail.com>
Date:   Thu, 20 Oct 2022 12:13:19 +0530
Message-ID: <CAEQ-dAAYRAg-t3ve9RJV-vJhzqMSe7YOw2bwJVJ_vk0BDp7NZw@mail.gmail.com>
Subject: Re: Performance Testing MD-RAID10 with 1 failed drive
To:     Roger Heflin <rogerheflin@gmail.com>
Cc:     Wols Lists <antlists@youngman.org.uk>,
        Reindl Harald <h.reindl@thelounge.net>,
        linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello Roger, All,

Thanks for your response.

Yes, the scenario is when the drive completely fails out of raid10. I
know it's not right to approach to run an array with a failed drive.
But what I am trying to understand is, how to benchmark the
performance hit in such a condition.
It's always a priority for us to get the failed drive replaced.

We run kafka brokers on these machines to be specific on the type of
the workload it is handling.

On Thu, Oct 20, 2022 at 4:54 AM Roger Heflin <rogerheflin@gmail.com> wrote:
>
> Is the  drive completely  failed out of the raid10?
>
> With a drive missing I would only expect read issues, but if the read
> load is high enough that it really needs both disks for the read load,
> then that would cause the writes to be slower if the total IO
> (read+write load) is overloading the disks.
>
> With 7200 rpm disks you can do a max of about 100-150 seeks and/or
> IOPS per second on each disk, any more than that and all performance
> on the disks will start to back up.   It will be worse if the
> application is writing sync to the disks (app guys love sync but fail
> to understand how it interacts with spinning disk hardware).
>
> Sar -d will show the disks and the tps (iops) and the wait time (7200
> disk has seek time of around 5-8ms).   It will also show similar stats
> on the md device itself.  If the device is getting backed up that
> means that app guys failed to understand the ability of the hardware
> and what their application needs.
>
> On Wed, Oct 19, 2022 at 5:11 PM Wols Lists <antlists@youngman.org.uk> wrote:
> >
> > On 19/10/2022 22:00, Reindl Harald wrote:
> > >
> > >
> > > Am 19.10.22 um 21:30 schrieb Umang Agarwalla:
> > >> Hello all,
> > >>
> > >> We run Linux RAID 10 in our production with 8 SAS HDDs 7200RPM.
> > >> We recently got to know from the application owners that the writes on
> > >> these machines get affected when there is one failed drive in this
> > >> RAID10 setup, but unfortunately we do not have much data around to
> > >> prove this and exactly replicate this in production.
> > >>
> > >> Wanted to know from the people of this mailing list if they have ever
> > >> come across any such issues.
> > >> Theoretically as per my understanding a RAID10 with even a failed
> > >> drive should be able to handle all the production traffic without any
> > >> issues. Please let me know if my understanding of this is correct or
> > >> not.
> > >
> > > "without any issue" is nonsense by common sense
> >
> > No need for the sark. And why shouldn't it be "without any issue"?
> > Common sense is usually mistaken. And common sense says to me the exact
> > opposite - with a drive missing that's one fewer write, so if anything
> > it should be quicker.
> >
> > Given that - on the system my brother was using - the ops guys didn't
> > notice their raid-6 was missing TWO drives, it seems like lost drives
> > aren't particularly noticeable by their absence ...
> >
> > Okay, with a drive missing it's DANGEROUS, but it should not have any
> > noticeable impact on a production system until you replace the drive and
> > it's rebuilding.
> >
> > Unfortunately, I don't know enough to say whether a missing drive would,
> > or should, impact performance.
> >
> > Cheers,
> > Wol
