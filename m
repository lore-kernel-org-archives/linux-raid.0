Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AB79C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 19 Jan 2022 01:25:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344444AbiASBZp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 Jan 2022 20:25:45 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36912 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241868AbiASBZl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 18 Jan 2022 20:25:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE9B4B8188A
        for <linux-raid@vger.kernel.org>; Wed, 19 Jan 2022 01:25:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D338C340E5
        for <linux-raid@vger.kernel.org>; Wed, 19 Jan 2022 01:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642555539;
        bh=1XGM/JrbLzmEiA1+J9LfItr4lrg0bTJZmd6Y31lUn00=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=eB7BS1eMdHZJLSyfyXwXdrcdZg5dTNC9pn26IeK+n7YQgp2hCldxaOgBajh8TD118
         IVdxvGVucONZogP2FTbVqcRRg1cr/undwhXPcVNYWiAQmmRALiigP4IF6Qfl6Niet0
         Q4q7GhkE1E1WYCPul/avvbNzbUa2KL96BaUuMJOdL5hWV10Z6TwwEeVsZytr7na3Ys
         RWB5FXr557ae+uZ+AwEpRSz/GgZqgeZRARiaVC0YUDuKeqpkOPcY6NMVqeWvd+RriE
         SaPV9FHdB33IgyVeIOCSKDKHIpNGixCHpvvfcW6S+HaQbCSsZaA1sC8ufmC5IcbCLY
         V3yl9Ojc+POMw==
Received: by mail-yb1-f182.google.com with SMTP id l68so1877217ybl.0
        for <linux-raid@vger.kernel.org>; Tue, 18 Jan 2022 17:25:39 -0800 (PST)
X-Gm-Message-State: AOAM532c6yqQf6q9dYs5vhjqNGIeNR5LRqwr39dprtYCfBad6C+tW1eO
        TNHCGIzEnVFKnTeTiiNUNMsLjnOWJXsEH8jo68g=
X-Google-Smtp-Source: ABdhPJxf2DcvhUL+l5z85wGL4fy4Tsy31zarhuijgd5DhdTQc5gqg/xlXONttrpIA20aRY+Ty6I5QZgzpe9a3X74N5U=
X-Received: by 2002:a25:dc84:: with SMTP id y126mr1311339ybe.282.1642555538535;
 Tue, 18 Jan 2022 17:25:38 -0800 (PST)
MIME-Version: 1.0
References: <20220117113847.13115-1-mariusz.tkaczyk@linux.intel.com>
In-Reply-To: <20220117113847.13115-1-mariusz.tkaczyk@linux.intel.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 18 Jan 2022 17:25:27 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7VK4Tac7YDQ1hzQQTPx9MGjpXDiq5p7+YUMPJoh1M1cg@mail.gmail.com>
Message-ID: <CAPhsuW7VK4Tac7YDQ1hzQQTPx9MGjpXDiq5p7+YUMPJoh1M1cg@mail.gmail.com>
Subject: Re: [PATCH] raid1, raid10: drop pending_cnt.
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Jan 17, 2022 at 3:39 AM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> Those counters are not necessary after commit 11bb45e8aaf6 ("md: drop queue
> limitation for RAID1 and RAID10"). Remove them from all code (conf and
> plug structs). raid1_plug_cb and raid10_plug_cb are identical, so move
> definition of raid1_plug_cb to common raid1-10 definitions and use it for
> RAID10 too.
>
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Applied to md-next (with minor changes to the commit log).

Thanks,
Song
