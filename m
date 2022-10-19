Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4698C4332F
	for <linux-raid@archiver.kernel.org>; Wed, 19 Oct 2022 23:24:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiJSXYM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 Oct 2022 19:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231775AbiJSXYG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 19 Oct 2022 19:24:06 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DEFB15994A
        for <linux-raid@vger.kernel.org>; Wed, 19 Oct 2022 16:24:05 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id bp15so30677170lfb.13
        for <linux-raid@vger.kernel.org>; Wed, 19 Oct 2022 16:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EwZ014WOIybo+H4GoSnOgqk2bkfgSgxgQy26ghUjVnM=;
        b=DxSr8buCwVqNmo0DqmtzP6f7tPZCUdit226PGNKPkyRTCcLxfCX5FLt8BuCVP+f/TD
         +L3hB+9G2fpsHj+YWFNAjBV5cHgLTA8076q4/7qcl0y7cIGUL+k56/wW/6dFpmdH5qFm
         H081a8un8skesuRHfFOYIOm/lkrsOXmX28IJTD6+3akvX1DRuclI+LaYhgnNQFBOI9Pr
         PsHwSV7GviOTG5Q67zHdjAS7xto+8e3HTji9Rfm+cYoIh6gkF3sRotf51mZ9u70hOtgx
         5lNrhT36HnpMO2DfmDtCOeDgY/pskBJMu5J7XIL/iMp0NS5eoIGgCLsKAycEY7AjQ6/2
         eOOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EwZ014WOIybo+H4GoSnOgqk2bkfgSgxgQy26ghUjVnM=;
        b=zTZBy5fUVc5OQ3GpVcyswrDofNLzfKjfStdEqj0hKsj5iRjd53R+vY6tcZoUFfl1V3
         eYncFaCbzytSRD89ASfKyXc4E19MQyW13HkStK/NhDjuT9jAH1MoxoeZcD7HfOqDQaL8
         vjBG4RSe0GscBpjqfg4Fw+3DXAl0yU9QxpY5Twqj+FPl/RRSAf30uh+k/IL10wrOT6/X
         v/0AL/9kAoyTMULctwjmR86Z10bn77+y0FUwrPO1z5UsN8QOwOTBgaeClwMpMl8aI58G
         G9BfxP0GlmL3C3ffldUtbNnGr1AmkV8H2SOtaZ5ukss5mv5ULGi86VDd+rjAwS8veLtZ
         ZmzA==
X-Gm-Message-State: ACrzQf2hDFyBSC0H56stBl4ojgxmA2kCVpSJUhHIJNbc8Qfg+0VCaQoM
        wfk6j8AQH2sFnYIxAoUW7noIvigyNbdjVYFW9IBUw1R2
X-Google-Smtp-Source: AMsMyM6dj5RxjwrSVcBQSd9n8De/31xDqxOf0DvGV3hx8hnhUn+vj2vqlFuI0uxRj4uNeHjvNuT4DtLxL6JNK2PTMyQ=
X-Received: by 2002:a05:6512:4cb:b0:4a2:25b6:9e73 with SMTP id
 w11-20020a05651204cb00b004a225b69e73mr3931538lfq.30.1666221843178; Wed, 19
 Oct 2022 16:24:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAEQ-dADdRd91GBkTzVU0AQiXQ4tLitYsU2uLziWOi=hLtaBK0w@mail.gmail.com>
 <e9feaefd-9ddb-c07a-86b8-3640ca4201af@thelounge.net> <7ca2b272-4920-076f-ecaf-5109db0aae46@youngman.org.uk>
In-Reply-To: <7ca2b272-4920-076f-ecaf-5109db0aae46@youngman.org.uk>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Wed, 19 Oct 2022 18:23:50 -0500
Message-ID: <CAAMCDef4bGs_LnbxEie=2FkxD6YJ_A4WFzW8c647k9MNLGoY3A@mail.gmail.com>
Subject: Re: Performance Testing MD-RAID10 with 1 failed drive
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     Reindl Harald <h.reindl@thelounge.net>,
        Umang Agarwalla <umangagarwalla111@gmail.com>,
        linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Is the  drive completely  failed out of the raid10?

With a drive missing I would only expect read issues, but if the read
load is high enough that it really needs both disks for the read load,
then that would cause the writes to be slower if the total IO
(read+write load) is overloading the disks.

With 7200 rpm disks you can do a max of about 100-150 seeks and/or
IOPS per second on each disk, any more than that and all performance
on the disks will start to back up.   It will be worse if the
application is writing sync to the disks (app guys love sync but fail
to understand how it interacts with spinning disk hardware).

Sar -d will show the disks and the tps (iops) and the wait time (7200
disk has seek time of around 5-8ms).   It will also show similar stats
on the md device itself.  If the device is getting backed up that
means that app guys failed to understand the ability of the hardware
and what their application needs.

On Wed, Oct 19, 2022 at 5:11 PM Wols Lists <antlists@youngman.org.uk> wrote:
>
> On 19/10/2022 22:00, Reindl Harald wrote:
> >
> >
> > Am 19.10.22 um 21:30 schrieb Umang Agarwalla:
> >> Hello all,
> >>
> >> We run Linux RAID 10 in our production with 8 SAS HDDs 7200RPM.
> >> We recently got to know from the application owners that the writes on
> >> these machines get affected when there is one failed drive in this
> >> RAID10 setup, but unfortunately we do not have much data around to
> >> prove this and exactly replicate this in production.
> >>
> >> Wanted to know from the people of this mailing list if they have ever
> >> come across any such issues.
> >> Theoretically as per my understanding a RAID10 with even a failed
> >> drive should be able to handle all the production traffic without any
> >> issues. Please let me know if my understanding of this is correct or
> >> not.
> >
> > "without any issue" is nonsense by common sense
>
> No need for the sark. And why shouldn't it be "without any issue"?
> Common sense is usually mistaken. And common sense says to me the exact
> opposite - with a drive missing that's one fewer write, so if anything
> it should be quicker.
>
> Given that - on the system my brother was using - the ops guys didn't
> notice their raid-6 was missing TWO drives, it seems like lost drives
> aren't particularly noticeable by their absence ...
>
> Okay, with a drive missing it's DANGEROUS, but it should not have any
> noticeable impact on a production system until you replace the drive and
> it's rebuilding.
>
> Unfortunately, I don't know enough to say whether a missing drive would,
> or should, impact performance.
>
> Cheers,
> Wol
