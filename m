Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD11AC433F5
	for <linux-raid@archiver.kernel.org>; Tue, 10 May 2022 18:02:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244820AbiEJSGp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 10 May 2022 14:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234017AbiEJSGo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 10 May 2022 14:06:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC662FF1
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 11:02:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BE1C61978
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 18:02:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1372C385A6
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 18:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652205765;
        bh=RDG7D0Zi9JaVkgzx+fBs4sXLTVBn/P/6dPnUPY6E4F8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=PJb2q/Tj8Phr7ccKmwt5MlQJUstYztSzxf71nFVGrZZMzG6HvnZNR/P/e+MhEGnP7
         ds/7Gpeq42VAW1cVid28HX70E+CVCehuKM6+jKa/BV5+fHEgQZPc8gPuYuV0wtVfbt
         4e74oob+zy6kLFP6zfxKmjwHuGHbTr9iWPIPmLLjz/afTnpKyCmg5sBOPOyh+Upk4c
         FCZ2SRSbzF2Q4aX6Vf3xOw8x/l03EZJ30sW+6FlOMQbmAefWa7tMuGAObhdIh/YGH5
         N11BbZ2JORcN7ZFcxQm2dUkFH+XXfTOz8fa3hD/r92L+7TZAARDcE4tLeD0DAgBxXa
         Aasj9hx+89CmA==
Received: by mail-yb1-f181.google.com with SMTP id i11so10116679ybq.9
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 11:02:45 -0700 (PDT)
X-Gm-Message-State: AOAM533E5wwMYGKczHSyS/Npzm0pVmPJ3BYKOmjdJngutGQTLtXPIxuU
        Lpdh8HhxLU6E//fTwaekh8BxQDCOMiidAtwh/10=
X-Google-Smtp-Source: ABdhPJx5Ad4IaPPCeC3sU18Twez91pb+nhumMS4RCbdvID7P1QRo5xLL9xlgl3+nMn4RLL8UgH3ReuBWwfcZw+ztcRc=
X-Received: by 2002:a25:d9d5:0:b0:648:e2a8:c4f2 with SMTP id
 q204-20020a25d9d5000000b00648e2a8c4f2mr19218701ybg.322.1652205764828; Tue, 10
 May 2022 11:02:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220505081641.21500-1-guoqing.jiang@linux.dev>
 <20220506113656.25010-1-guoqing.jiang@linux.dev> <CAPhsuW6mGnkg4x5xm6x5n06JXxF-7PNubpQiZNmX0BH9Zo1ncA@mail.gmail.com>
 <141b4110-767e-7670-21d5-6a5f636d1207@linux.dev> <CAPhsuW6U3g-Xikbw4mAJOH1-kN42rYHLiq_ocv==436azhm33g@mail.gmail.com>
 <fdabab9e-e0ce-330d-b4db-0a11fde82615@molgen.mpg.de> <e50fa5ee-156a-aa22-fc49-390cefa3875f@linux.dev>
 <675626ff-f18b-78ab-f5a0-2ee44ab0d399@molgen.mpg.de>
In-Reply-To: <675626ff-f18b-78ab-f5a0-2ee44ab0d399@molgen.mpg.de>
From:   Song Liu <song@kernel.org>
Date:   Tue, 10 May 2022 11:02:33 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4ZVkzQa=UKz=TR52ye23RAyubUOgdhT7=OGqTR8uWwVw@mail.gmail.com>
Message-ID: <CAPhsuW4ZVkzQa=UKz=TR52ye23RAyubUOgdhT7=OGqTR8uWwVw@mail.gmail.com>
Subject: Re: [Update PATCH V3] md: don't unregister sync_thread with
 reconfig_mutex held
To:     Donald Buczek <buczek@molgen.mpg.de>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, May 10, 2022 at 5:35 AM Donald Buczek <buczek@molgen.mpg.de> wrote:
>
> On 5/10/22 2:09 PM, Guoqing Jiang wrote:
> >
> >
> > On 5/10/22 8:01 PM, Donald Buczek wrote:
> >>
> >>> I guess v2 is the best at the moment. I pushed a slightly modified v2 to
> >>> md-next.
> >>
> >> I think, this can be used to get a double-free from md_unregister_thread.
> >>
> >> Please review
> >>
> >> https://lore.kernel.org/linux-raid/8312a154-14fb-6f07-0cf1-8c970187cc49@molgen.mpg.de/
> >
> > That is supposed to be addressed by the second one, pls consider it too.
>
> Right, but this has not been pulled into md-next. I just wanted to note, that the current state of md-next has this problem.
>
> If the other patch is taken, too, and works as intended, that would be solved.
>
> > [PATCH 2/2] md: protect md_unregister_thread from reentrancy

Good catch!

Guoqing, current 2/2 doesn't apply cleanly. Could you please resend it on top of
md-next?

Thanks,
Song
