Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99AA4C63797
	for <linux-raid@archiver.kernel.org>; Wed,  1 Feb 2023 16:31:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbjBAQbt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Feb 2023 11:31:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbjBAQbp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Feb 2023 11:31:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D9979629
        for <linux-raid@vger.kernel.org>; Wed,  1 Feb 2023 08:31:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1ED46B821D5
        for <linux-raid@vger.kernel.org>; Wed,  1 Feb 2023 16:31:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE39EC433AA
        for <linux-raid@vger.kernel.org>; Wed,  1 Feb 2023 16:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675269097;
        bh=kedQtTraNB7DsNRl+nKEM6RmJXvNsoFopFn05grUXNY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=QVp0FuGumiKPhcKykyp+76qMvu6Ahzsew/2uThx4teH3kCAyvp2bZbUMqZOn6h7z6
         hgYCb+5f/vPldMut2R67tB4+eh91P/WwtveX0NMXw+NDq22D9CuSr748sUEzCRR7Sl
         coht/T+0C7naoDPvxcRVnnd6rgKUIpqTYThL4TU6WKImcb/thLGl1QfBcltnXBLufo
         OzKtI1Nb0c2ig1UrkNbIfq9zlDpz9BMNBCnOmSjJ9k5YyOuaV9oOOdskhr/d1490Ph
         KDKRabv4jxZ0aZJSJ59TLst2l2jkY53yncn1WUS49RcEKeBOM6kJikcIT/tI7bUs+P
         JqOwfyHqRGvmw==
Received: by mail-lf1-f43.google.com with SMTP id x40so30026241lfu.12
        for <linux-raid@vger.kernel.org>; Wed, 01 Feb 2023 08:31:37 -0800 (PST)
X-Gm-Message-State: AO0yUKWWdUgjKWyVlaRi2Io4z+ETW6dvyBZCntPU/BEQBuIXGco7XPs9
        ZTq5wHHk6lmeEqZxTDnmKbX1xqceGBNUt5QM+80=
X-Google-Smtp-Source: AK7set9bGSmYgOqCYcgfUvV0DrGR3HLY2af9mjQKYKCxtWm9ASO4PXLw3gE2oT5khPE6gzrQYfBj5r7biqcKJ9R6Pls=
X-Received: by 2002:ac2:547a:0:b0:4b5:c489:8cf7 with SMTP id
 e26-20020ac2547a000000b004b5c4898cf7mr522883lfn.242.1675269095837; Wed, 01
 Feb 2023 08:31:35 -0800 (PST)
MIME-Version: 1.0
References: <20230201075920.444720-1-houtao@huaweicloud.com>
In-Reply-To: <20230201075920.444720-1-houtao@huaweicloud.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 1 Feb 2023 08:31:23 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6iJcNeVBpigYXOpR2E4gSh1x_vmu5J=eiqui+GmLXzKA@mail.gmail.com>
Message-ID: <CAPhsuW6iJcNeVBpigYXOpR2E4gSh1x_vmu5J=eiqui+GmLXzKA@mail.gmail.com>
Subject: Re: [PATCH v2] md: use MD_RESYNC_* whenever possible
To:     Hou Tao <houtao@huaweicloud.com>
Cc:     linux-raid@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Logan Gunthorpe <logang@deltatee.com>, houtao1@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Jan 31, 2023 at 11:31 PM Hou Tao <houtao@huaweicloud.com> wrote:
>
> From: Hou Tao <houtao1@huawei.com>
>
> Just replace magic numbers by MD_RESYNC_* enumerations.
>
> Signed-off-by: Hou Tao <houtao1@huawei.com>

Applied to md-next. Thanks!

Song
