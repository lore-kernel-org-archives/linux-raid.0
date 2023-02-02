Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B70BFC05027
	for <linux-raid@archiver.kernel.org>; Thu,  2 Feb 2023 06:53:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbjBBGxz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Feb 2023 01:53:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjBBGxy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 2 Feb 2023 01:53:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19AA118ABE
        for <linux-raid@vger.kernel.org>; Wed,  1 Feb 2023 22:53:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9EADB8247A
        for <linux-raid@vger.kernel.org>; Thu,  2 Feb 2023 06:53:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E75C433D2
        for <linux-raid@vger.kernel.org>; Thu,  2 Feb 2023 06:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675320830;
        bh=B2a+wqjPKWfkjrFLaLmcLHj9IlKGXhK8t7vGX7iCMZA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=MwNvTM3eD+8+L/gyFX4+fhDPRAyfFuFf7OlKg/uhWHEtp0XcYptswCf978xPsAQ+j
         HM3IW90FKgqd3sGN+DQetKyEA9ZyxhaFbYzLHmcV1Z3Bf7DZ+6cYJLykNhOC+6T5PT
         WatojaHgnr6U1Gpqyt1hBGVf7ftxF4y3onMutm7QKEUxbfFOPdw9bo667aYdb4SW7k
         IWNQS2KOqyC/FijmYHfy2EuM77d8LHq4AjQ5x7JYimgTTg8OW1mBoSD1zvJfzOuotH
         Ns2pS2kfbj8bDTLehB56mO562Q5Rdzeg1gUb5KRxa+YC+1fKa/HFBAQxVw8w3nVqg7
         64yA5zVenvpFw==
Received: by mail-lj1-f169.google.com with SMTP id g14so893235ljh.10
        for <linux-raid@vger.kernel.org>; Wed, 01 Feb 2023 22:53:50 -0800 (PST)
X-Gm-Message-State: AO0yUKUgtn0KvieL3+Z18WHD0713kB44mN9jAD5WcJC/ioAPOf4JMfU4
        NDW3c2GFep3gyk5VNDFsub6WTdT3EE8VpliW11M=
X-Google-Smtp-Source: AK7set9tPIsyBkIDQhL0rNNPBsyggPUbAbx3x+0VfVcNmp5IRvye8Bpu9GyDP9FcllzYhiozdtXtnnciMtLAoJM3qlc=
X-Received: by 2002:a2e:9b17:0:b0:290:7c03:a98 with SMTP id
 u23-20020a2e9b17000000b002907c030a98mr759946lji.74.1675320828405; Wed, 01 Feb
 2023 22:53:48 -0800 (PST)
MIME-Version: 1.0
References: <20230131070719.1702279-1-houtao@huaweicloud.com>
 <CAPhsuW4s9U3FVZOh7NJGZAnWACVeJgWUNd=bZVtjg4B+h+ox1Q@mail.gmail.com> <6ec2c920-0d88-7bb6-e0aa-ef44865fa935@huaweicloud.com>
In-Reply-To: <6ec2c920-0d88-7bb6-e0aa-ef44865fa935@huaweicloud.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 1 Feb 2023 22:53:36 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7TrWtNh4hdB_8pcMHZQ6QVgHzE=DQK3oP3nc_76ZAe2g@mail.gmail.com>
Message-ID: <CAPhsuW7TrWtNh4hdB_8pcMHZQ6QVgHzE=DQK3oP3nc_76ZAe2g@mail.gmail.com>
Subject: Re: [PATCH] md: don't update recovery_cp when curr_resync is ACTIVE
To:     Hou Tao <houtao@huaweicloud.com>
Cc:     linux-raid@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Logan Gunthorpe <logang@deltatee.com>, houtao1@huawei.com,
        linan122@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Feb 1, 2023 at 4:51 PM Hou Tao <houtao@huaweicloud.com> wrote:
>
> Hi,
>
> On 2/2/2023 12:35 AM, Song Liu wrote:
> > On Mon, Jan 30, 2023 at 10:39 PM Hou Tao <houtao@huaweicloud.com> wrote:
> >> From: Hou Tao <houtao1@huawei.com>
> >>
> >> Don't update recovery_cp when curr_resync is MD_RESYNC_ACTIVE, otherwise
> >> md may skip the resync of the first 3 sectors if the resync procedure is
> >> interrupted before the first calling of ->sync_request() as shown below:
> >>
> >> md_do_sync thread          control thread
> >>   // setup resync
> >>   mddev->recovery_cp = 0
> >>   j = 0
> >>   mddev->curr_resync = MD_RESYNC_ACTIVE
> >>
> >>                              // e.g., set array as idle
> >>                              set_bit(MD_RECOVERY_INTR, &&mddev_recovery)
> >>   // resync loop
> >>   // check INTR before calling sync_request
> >>   !test_bit(MD_RECOVERY_INTR, &mddev->recovery
> >>
> >>   // resync interrupted
> >>   // update recovery_cp from 0 to 3
> >>   // the resync of three 3 sectors will be skipped
> >>   mddev->recovery_cp = 3
> >>
> >> Fixes: eac58d08d493 ("md: Use enum for overloaded magic numbers used by mddev->curr_resync")
> >> Signed-off-by: Hou Tao <houtao1@huawei.com>
> > By the way, how did you find this issue? Is it from users/production?
> > Or just from reading the code?
> Found the issue when reading the code and reproduced the problem to confirm that.

Thanks for the information!

Song
