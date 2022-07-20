Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C412C43334
	for <linux-raid@archiver.kernel.org>; Wed, 20 Jul 2022 06:05:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235016AbiGTGFl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 20 Jul 2022 02:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiGTGFk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 20 Jul 2022 02:05:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA66A67CB9;
        Tue, 19 Jul 2022 23:05:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 693E3B81CE5;
        Wed, 20 Jul 2022 06:05:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BCCAC341CE;
        Wed, 20 Jul 2022 06:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658297137;
        bh=2YrQLYs5gODiDSTIt6yQd0LT7Ol1+/wI9gSCBMib1OE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=h1YUMzxwlfzjRnMLkBv4mImrD6Qn6U9m6/SovAKOpkyQ30hoZDM59bAOMY7/8Ye2p
         D02oOvoi++t7FlcwUjWNEbf11LhcdD/WGdLWB+HhR5cB1Ihfi4Brn7VuXjtdfotmFh
         DQScdDHZvOIjRMSCZP8BZzn/hpCrYWU4n7TdmULdab49SxYqMBr8HLYUi9kxR0clHM
         jUWDaE+mG+9q3+3SIsL8nwE/wGo6WAxxD+HOJYrpeond7OpqAG9u2hpKHrf0NGZCY1
         1lt9FWkx+oQh8Jyk0xOkP+tFgS40F0Y/kZ1avQp4TZ79vjjnCiyWdfseny+O74kD7G
         aVy/hJMZreVDg==
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-31e7055a61dso1015437b3.11;
        Tue, 19 Jul 2022 23:05:37 -0700 (PDT)
X-Gm-Message-State: AJIora9PaDw7kDRZUt6Vvln6kzdXPKDr8lJkEmSvXBGl0+4W15rw4jwm
        pUKps2gIKGOeW93WzfoOhPDdMErUMw8Fi+WklLI=
X-Google-Smtp-Source: AGRyM1snP5obLo3duzhTE4Di39is0dpG5RVm9hi8CY+wECR4pNIpkal5VuC0Y4qn64JVfQXekDnTa4lZdtVRZE26irs=
X-Received: by 2002:a81:2389:0:b0:31e:6212:5bb6 with SMTP id
 j131-20020a812389000000b0031e62125bb6mr5270090ywj.472.1658297135817; Tue, 19
 Jul 2022 23:05:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220719091824.1064989-1-hch@lst.de> <CAPhsuW7hYzg-o6a7rdLs4==fv+0hqFtEyUVS0XtPjOqLHYg3eg@mail.gmail.com>
 <f601eb55-54cf-ff0f-8ec0-586ca4dbe38a@deltatee.com>
In-Reply-To: <f601eb55-54cf-ff0f-8ec0-586ca4dbe38a@deltatee.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 19 Jul 2022 23:05:25 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6j8UFEZSAKwJCVXTRi5Mj_CRX+r8Bb-MpvZ0DNWqJ9uA@mail.gmail.com>
Message-ID: <CAPhsuW6j8UFEZSAKwJCVXTRi5Mj_CRX+r8Bb-MpvZ0DNWqJ9uA@mail.gmail.com>
Subject: Re: fix md disk_name lifetime problems v4
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        linux-raid <linux-raid@vger.kernel.org>,
        linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Jul 19, 2022 at 11:44 AM Logan Gunthorpe <logang@deltatee.com> wrote:
>
>
>
> On 2022-07-19 12:42, Song Liu wrote:
> > On Tue, Jul 19, 2022 at 2:18 AM Christoph Hellwig <hch@lst.de> wrote:
> >>
> >> Hi all,
> >>
> >> this series tries to fix a problem repored by Logan where we see
> >> duplicate sysfs file name in md.  It is due to the fact that the
> >> md driver only checks for duplicates on currently live mddevs,
> >> while the sysfs name can live on longer.  It is an old problem,
> >> but the race window got longer due to waiting for the device freeze
> >> earlier in del_gendisk.
> >>
> >> Changes since v3:
> >>  - remove a now superflous mddev->gendisk NULL check
> >>  - use a bit in mddev->flags instead of a new field
> >>
> >> Changes since v2:
> >>  - delay mddev->kobj initialization
> >>
> >> Changes since v1:
> >>  - rebased to the md-next branch
> >>  - fixed error handling in md_alloc for real
> >>  - add a little cleanup patch
> >
> > Applied to md-next. Thanks!
>
> I've only just finished my testing on this and it all looks good to me.
>
> I've also reviewed the last 2 patches, for what it's worth.

Thanks!

I added your reviewed-by to the last two patches.

Song
