Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20E58C38142
	for <linux-raid@archiver.kernel.org>; Wed,  1 Feb 2023 16:36:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbjBAQgU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Feb 2023 11:36:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232449AbjBAQgH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Feb 2023 11:36:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0884A7B406
        for <linux-raid@vger.kernel.org>; Wed,  1 Feb 2023 08:35:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 992B8B821D4
        for <linux-raid@vger.kernel.org>; Wed,  1 Feb 2023 16:35:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5158CC433EF
        for <linux-raid@vger.kernel.org>; Wed,  1 Feb 2023 16:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675269345;
        bh=iX0rvDotfBf1+15Lm+h21EAWkxtym6gQvSTGB6PJa9I=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Ycw76S7CVnK/D4iW6CQNzofQmOF5wpj2KrRa/jGjLjaBnE5ej/wJe2busE3PwZ8hJ
         s7qD4640Ey9+RXA4E0ALd+Y+AcAW3rwJRDSCECVTH+tnP8eVNWs6tZi78gK7ezVsHJ
         HkV2zR028kp00eKBjyAF4OhrXvdDRj4yL4M4YC6/ix2NpO8OfkLKdMGulbAS8BGntq
         dbEL1McePUOdUYs6Pd3ARZg9D1c/5XoYBGqpd78LK/4EobvABJI+fJlJJctfq8aoRj
         j1kvYPdsfahCtdIuBgqA0IEuBq6cPzH3G9yxI9KyMH8nElONcSPSZfyKt9cCp5eW5J
         2Uo1Q3k6XnUew==
Received: by mail-lf1-f41.google.com with SMTP id u12so19558447lfq.0
        for <linux-raid@vger.kernel.org>; Wed, 01 Feb 2023 08:35:45 -0800 (PST)
X-Gm-Message-State: AO0yUKWF+k0cugoz6c+Ogci+bF8In18k4L/3jTjvot3hgFTNeCNNZFcn
        vo09nVHF3lrWwlC06eLT4iO8DBFi9wjIp+EutD4=
X-Google-Smtp-Source: AK7set9wNIc9S127qbu4DXYxJEirumoSg+EGbMfN7XI7BNN9tp8BJPgXemao0cD9J5wWQY/CPcRUoUG7nPhvXwO7HJw=
X-Received: by 2002:ac2:5441:0:b0:4d8:7740:47d2 with SMTP id
 d1-20020ac25441000000b004d8774047d2mr439561lfn.87.1675269343393; Wed, 01 Feb
 2023 08:35:43 -0800 (PST)
MIME-Version: 1.0
References: <20230131070719.1702279-1-houtao@huaweicloud.com>
In-Reply-To: <20230131070719.1702279-1-houtao@huaweicloud.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 1 Feb 2023 08:35:30 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4s9U3FVZOh7NJGZAnWACVeJgWUNd=bZVtjg4B+h+ox1Q@mail.gmail.com>
Message-ID: <CAPhsuW4s9U3FVZOh7NJGZAnWACVeJgWUNd=bZVtjg4B+h+ox1Q@mail.gmail.com>
Subject: Re: [PATCH] md: don't update recovery_cp when curr_resync is ACTIVE
To:     Hou Tao <houtao@huaweicloud.com>
Cc:     linux-raid@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Logan Gunthorpe <logang@deltatee.com>, houtao1@huawei.com,
        linan122@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Jan 30, 2023 at 10:39 PM Hou Tao <houtao@huaweicloud.com> wrote:
>
> From: Hou Tao <houtao1@huawei.com>
>
> Don't update recovery_cp when curr_resync is MD_RESYNC_ACTIVE, otherwise
> md may skip the resync of the first 3 sectors if the resync procedure is
> interrupted before the first calling of ->sync_request() as shown below:
>
> md_do_sync thread          control thread
>   // setup resync
>   mddev->recovery_cp = 0
>   j = 0
>   mddev->curr_resync = MD_RESYNC_ACTIVE
>
>                              // e.g., set array as idle
>                              set_bit(MD_RECOVERY_INTR, &&mddev_recovery)
>   // resync loop
>   // check INTR before calling sync_request
>   !test_bit(MD_RECOVERY_INTR, &mddev->recovery
>
>   // resync interrupted
>   // update recovery_cp from 0 to 3
>   // the resync of three 3 sectors will be skipped
>   mddev->recovery_cp = 3
>
> Fixes: eac58d08d493 ("md: Use enum for overloaded magic numbers used by mddev->curr_resync")
> Signed-off-by: Hou Tao <houtao1@huawei.com>

By the way, how did you find this issue? Is it from users/production?
Or just from reading the code?

Thanks,
Song
