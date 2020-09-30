Return-Path: <SRS0=vpcD=DH=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3446FC4363D
	for <linux-raid@archiver.kernel.org>; Wed, 30 Sep 2020 23:27:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFB7C2076A
	for <linux-raid@archiver.kernel.org>; Wed, 30 Sep 2020 23:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601508426;
	bh=cTv0UPt7W5kaDPE7q8O/rXFc97+zBmT2/eSXNMCtOq0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=AFg8zGctLgH901s5/ZjkHstfyCUxfPBP6SDsZKoeUEioEGvIKcpyxDuqR29xlj1me
	 JTzA191CfYWm5llPr8sv2Q9LmJp45kFM2FpDOufi6ZLv6FGTZ8jb1l77JNE9WofvIz
	 1hFYFRG6JHGI0N1yd2SrLV90XdRWbc6lUOgCiRbM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732323AbgI3X1F (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 30 Sep 2020 19:27:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730192AbgI3X1E (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 30 Sep 2020 19:27:04 -0400
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CA9C2076A
        for <linux-raid@vger.kernel.org>; Wed, 30 Sep 2020 23:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601508424;
        bh=cTv0UPt7W5kaDPE7q8O/rXFc97+zBmT2/eSXNMCtOq0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=vyKmp4LfRAMCb457ZHe3O2r0SFbydlqApdcwMlr7G5IkOr8bPuJozhCFS/rdayMrY
         +eflTNk9Hwt965C6SC+Iq/ygQlBnaei9EA1cJJJoHJiutosc4P/6Rsm3hLdOINfG+d
         BZWbZr4EbEuEToI7aBMNR8ZpWMclxHvaRGHYUoMc=
Received: by mail-lj1-f176.google.com with SMTP id u4so3027595ljd.10
        for <linux-raid@vger.kernel.org>; Wed, 30 Sep 2020 16:27:04 -0700 (PDT)
X-Gm-Message-State: AOAM532n/E0nIA08jcWwZMTM6LGnPibHYRxxT2JyUGq6V23FoJIx24av
        rDTlGQh+7pf3MwKZzYg7/Thpme+A+MEUMna0q1Q=
X-Google-Smtp-Source: ABdhPJwc5TbEqAbnFVmAmkPp0NjrqGRSUp+74pbnuKotogBi2GWWy9zurdOco4cGvVEAG/At5bJ9IQpGZ5efqD1lQ1Y=
X-Received: by 2002:a2e:9cd5:: with SMTP id g21mr1539505ljj.27.1601508422479;
 Wed, 30 Sep 2020 16:27:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200929064759.3605064-1-yanaijie@huawei.com>
In-Reply-To: <20200929064759.3605064-1-yanaijie@huawei.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 30 Sep 2020 16:26:51 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6fbjv2PjN+RVBO63eC+jkiXh-3K9UPjXQ8uiOChqdzzA@mail.gmail.com>
Message-ID: <CAPhsuW6fbjv2PjN+RVBO63eC+jkiXh-3K9UPjXQ8uiOChqdzzA@mail.gmail.com>
Subject: Re: [PATCH] md/raid0: remove unused function is_io_in_chunk_boundary()
To:     Jason Yan <yanaijie@huawei.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Sep 28, 2020 at 11:47 PM Jason Yan <yanaijie@huawei.com> wrote:
>
> This function is no longger needed after commit 20d0189b1012 ("block:
> Introduce new bio_split()").
>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Applied to md-next. Thanks!

Song
