Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 573B4C433EF
	for <linux-raid@archiver.kernel.org>; Wed,  1 Jun 2022 23:18:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232576AbiFAXSx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Jun 2022 19:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbiFAXSw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Jun 2022 19:18:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33052224123
        for <linux-raid@vger.kernel.org>; Wed,  1 Jun 2022 16:18:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4243B81D7B
        for <linux-raid@vger.kernel.org>; Wed,  1 Jun 2022 23:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750ADC385A5
        for <linux-raid@vger.kernel.org>; Wed,  1 Jun 2022 23:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654125528;
        bh=rCImaJxfkOLbDwOv74E3IxMXnhMYDsrhfhZGEsR51Xo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=o7nmm3nicoLVRAib3saOSjboH4t0vvo5XqCEuhXWhBIhA65vvZqgWFS3fEWN6ggcA
         ZwOxvt4XZsCM1N2s6ETe4Q7XTcBOd1bvp8MKkjeSYvVUvhYXWV3KkOLyEE5TZH9aEm
         /opytve6yNdhimnJ3ta2cOkxDJ6tOh64qOFi3Fx/jn/ix93pnPP4Y1MjXAfUMInrxd
         kVWbpDs+v0D4XUcDEGNigO7DaQkhtjamQj7JSkEc5d9wlAAE9SHUnEW/bHFGDEqmnR
         iv+sDeAjo4Se4chgyq0U56MatSxMCbE5shPCq/xZQ5SAhziP4B8nbtLAIjDrMxeLf9
         iFY3CpzmF8n1Q==
Received: by mail-yb1-f182.google.com with SMTP id t31so5510936ybi.2
        for <linux-raid@vger.kernel.org>; Wed, 01 Jun 2022 16:18:48 -0700 (PDT)
X-Gm-Message-State: AOAM532HokakV/Q6VqN0/BlnckhvHlyW7vbtsO2Cw9nWJxLJMlqG45wk
        p5ypyEriTSUKqNsHk3Q3fJyJRjPuufEVk/jvk6E=
X-Google-Smtp-Source: ABdhPJxxjIeVUolhQ1W8+iVQFFL7oKR6MpnttQZOtaIj3FjnNDW/hxmQ/hD7UmK61NglmBuQFlZsDcyZJcmF5KrE6Gs=
X-Received: by 2002:a05:6902:114c:b0:641:87a7:da90 with SMTP id
 p12-20020a056902114c00b0064187a7da90mr2479168ybu.561.1654125527492; Wed, 01
 Jun 2022 16:18:47 -0700 (PDT)
MIME-Version: 1.0
References: <YpdHay7qyUzbvnxg@arachsys.com>
In-Reply-To: <YpdHay7qyUzbvnxg@arachsys.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 1 Jun 2022 16:18:36 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7cRbVvPVR+A9wosezMdOaYEw9HD00o04m+QY9ETv1P-w@mail.gmail.com>
Message-ID: <CAPhsuW7cRbVvPVR+A9wosezMdOaYEw9HD00o04m+QY9ETv1P-w@mail.gmail.com>
Subject: Re: [PATCH v2] md: Explicitly create command-line configured devices
To:     Chris Webb <chris@arachsys.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Jun 1, 2022 at 4:03 AM Chris Webb <chris@arachsys.com> wrote:
>
> Boot-time assembly of arrays with md= command-line arguments breaks when
> CONFIG_BLOCK_LEGACY_AUTOLOAD is unset. md_setup_drive() in md-autodetect.c
> calls blkdev_get_by_dev(), assuming this implicitly creates the block
> device.
>
> Fix this by attempting to md_alloc() the array first. As in the probe path,
> ignore any error as failure is caught by blkdev_get_by_dev() anyway.
>
> Signed-off-by: Chris Webb <chris@arachsys.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Applied to md-next.

Thanks!
Song
