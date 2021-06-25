Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CE64C2B9F4
	for <linux-raid@archiver.kernel.org>; Fri, 25 Jun 2021 14:20:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FD3E61946
	for <linux-raid@archiver.kernel.org>; Fri, 25 Jun 2021 14:20:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbhFYOWo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 25 Jun 2021 10:22:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229653AbhFYOWl (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 25 Jun 2021 10:22:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C7476194D
        for <linux-raid@vger.kernel.org>; Fri, 25 Jun 2021 14:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624630821;
        bh=Z8k22WldToz+37xatq4AsmnptBZWHJX9DARMK/+tHxs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HoQauACcq/5vtTYIHL6htPAsD6Sry91y6HRwjHduUbvFthByzMAOY2ZrSVf/BpZUd
         oBWdJsjijs70VNL/IglKIlP9WrrgLHPZxgW9MtTui6sMs2iovi81jIS/DEHFO8ZSIQ
         ay8doMNdf/x+qqY61MzGWHevIec3xmbCw7ls2JZKaw8OwqnddDWxyJb5IixNmSB8+c
         lpMYWaJTIUfOQQnv/CIfGrnApsxedlLXuN9OyTG4s37qHp4pjCD9mEvlYMSrkfiRug
         be05Ob+P4kSKOmfM69UWEPOR4x8dHfgqTjmSZrWeJQ0rqpOQFlKo+GjzHwvqJN45ZY
         bNrLm98VDxz7Q==
Received: by mail-lf1-f41.google.com with SMTP id r5so16566499lfr.5
        for <linux-raid@vger.kernel.org>; Fri, 25 Jun 2021 07:20:21 -0700 (PDT)
X-Gm-Message-State: AOAM530IPZ6Euc7GIQVpu5rZyi9UTY2uBOZsMPjMs4nJgbh5+0V3tu5O
        45iJgqndR+dlvMkm3dsM6KZHvvXzrlvVZwN2klQ=
X-Google-Smtp-Source: ABdhPJy7/cCprSFPjjQKSJViMzfYSLIX0Bo/K2piZz+SgCMI4kvltU26dmUngEqLlAPdZ9Cnv3dS0qsQwPXgCuZmdio=
X-Received: by 2002:a05:6512:1292:: with SMTP id u18mr4140827lfs.261.1624630819602;
 Fri, 25 Jun 2021 07:20:19 -0700 (PDT)
MIME-Version: 1.0
References: <E1lwU4E-0029Uw-MM@dogben.com> <9245e56b-33f3-35f8-c02e-4d57a809c2c8@gmail.com>
 <26936ea3126d12df70fbdc274177cf9b@dogben.com>
In-Reply-To: <26936ea3126d12df70fbdc274177cf9b@dogben.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 25 Jun 2021 07:20:07 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7Fp=nrW4vdM1QbaTnFvPW22Ht7WEiuGv=+SDzOLJ1S0g@mail.gmail.com>
Message-ID: <CAPhsuW7Fp=nrW4vdM1QbaTnFvPW22Ht7WEiuGv=+SDzOLJ1S0g@mail.gmail.com>
Subject: Re: [PATCH] md/raid10: properly indicate failure when ending a failed
 write request
To:     Wei Shuyu <wsy@dogben.com>
Cc:     Guoqing Jiang <jgq516@gmail.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Paul Clements <paul.clements@us.sios.com>,
        Yufen Yu <yuyufen@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Jun 24, 2021 at 8:04 PM Wei Shuyu <wsy@dogben.com> wrote:
>
[...]
> > Thanks,
> > Guoqing
>
> Shall I make another patch that fix the comments in both files or just
> piggyback in V2?

Let's piggyback in V2.

Thanks,
Song
