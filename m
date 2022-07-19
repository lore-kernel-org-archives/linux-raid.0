Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7D45C43334
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jul 2022 18:42:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236217AbiGSSmb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jul 2022 14:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbiGSSma (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Jul 2022 14:42:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3305B5D0C4;
        Tue, 19 Jul 2022 11:42:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE741B81CDB;
        Tue, 19 Jul 2022 18:42:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8806AC341CE;
        Tue, 19 Jul 2022 18:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658256146;
        bh=PaLly4fEPRRRJWCJAvo0cqxPZdJcwGkVOv6UF4jnb8A=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=RmbGBdkscX6CVy8msySbOXe4ptmLPXHsxXFo8Pv3GqDiu8fhCS/3+Vlxo+iwnESq+
         DvA7cBpEUF0b6Ly2lD6SqffO2vvpbA8KIlUGOkMzr49dOjR06B6W7T+lfocYuaUFUl
         6ogEv9dqSNqQs5Hq0O2GdLV3dw6S/iQP9Q+/RbrwhBFUrQ7UGrfiNfGjy0Qiol0vnO
         Ai4uqIbvbXr8CxV2766hMG7tDINCw1ZLmJcKX55KoPtZe6HDYoCy9J3Wj4qjXXGUiQ
         8Iyp376wO9H0do41ccGHGFOqMcoerU/+UmAC0K9nKrw7/3HtkjdzmLc/Zdzk60RTzW
         OWv94/BcO562g==
Received: by mail-yb1-f175.google.com with SMTP id e69so28125810ybh.2;
        Tue, 19 Jul 2022 11:42:26 -0700 (PDT)
X-Gm-Message-State: AJIora/kBDVpsDet+3Qos8ID7BiejvebIo88ETi7xjvlWz04DkBp3icO
        VZu9OCO0qzuMvS3v2pAIM67t5m+RzmkR0SHwr1s=
X-Google-Smtp-Source: AGRyM1vkrjCo7H/e9AXojAEaQuh1HP2MGSdeSJ4DY8rYzc/xLMjDxQByLBMLcJCjP/huHaCkhMNK+lWi/+BeHX1VGeo=
X-Received: by 2002:a25:805:0:b0:670:4237:cddf with SMTP id
 5-20020a250805000000b006704237cddfmr11661239ybi.9.1658256145605; Tue, 19 Jul
 2022 11:42:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220719091824.1064989-1-hch@lst.de>
In-Reply-To: <20220719091824.1064989-1-hch@lst.de>
From:   Song Liu <song@kernel.org>
Date:   Tue, 19 Jul 2022 11:42:14 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7hYzg-o6a7rdLs4==fv+0hqFtEyUVS0XtPjOqLHYg3eg@mail.gmail.com>
Message-ID: <CAPhsuW7hYzg-o6a7rdLs4==fv+0hqFtEyUVS0XtPjOqLHYg3eg@mail.gmail.com>
Subject: Re: fix md disk_name lifetime problems v4
To:     Christoph Hellwig <hch@lst.de>
Cc:     Logan Gunthorpe <logang@deltatee.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Jul 19, 2022 at 2:18 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Hi all,
>
> this series tries to fix a problem repored by Logan where we see
> duplicate sysfs file name in md.  It is due to the fact that the
> md driver only checks for duplicates on currently live mddevs,
> while the sysfs name can live on longer.  It is an old problem,
> but the race window got longer due to waiting for the device freeze
> earlier in del_gendisk.
>
> Changes since v3:
>  - remove a now superflous mddev->gendisk NULL check
>  - use a bit in mddev->flags instead of a new field
>
> Changes since v2:
>  - delay mddev->kobj initialization
>
> Changes since v1:
>  - rebased to the md-next branch
>  - fixed error handling in md_alloc for real
>  - add a little cleanup patch

Applied to md-next. Thanks!

Song

>
> Diffstat:
>  md.c |  310 +++++++++++++++++++++++++++++++++++--------------------------------
>  md.h |    2
>  2 files changed, 165 insertions(+), 147 deletions(-)
