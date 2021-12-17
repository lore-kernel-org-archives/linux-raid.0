Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AC57C433F5
	for <linux-raid@archiver.kernel.org>; Fri, 17 Dec 2021 00:52:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbhLQAwh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 16 Dec 2021 19:52:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbhLQAwg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 16 Dec 2021 19:52:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09387C061574
        for <linux-raid@vger.kernel.org>; Thu, 16 Dec 2021 16:52:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7944B61FAA
        for <linux-raid@vger.kernel.org>; Fri, 17 Dec 2021 00:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32E8C36AE2
        for <linux-raid@vger.kernel.org>; Fri, 17 Dec 2021 00:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639702354;
        bh=zsErKKb42TeZS5eI57H0AJ1QvTK9UquZ9J1c7X/7Xdk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=SzpQqtkyBhN/De6JFz/Ium46+nLXLoAYvABxItzZrteCqVbbFqX7xVV4H3h5f3aDC
         RlUqYl14dr3CgEFAJzWzQhL8QOFQECrMgnP7fC6LigYFz85Wlje6FD4S3NoBpY/XYq
         gQBkD4wi+VhRzSMHg0RFB7ks12yOpdMijb5I+IHlxoG5UNBHMG44C8kSE1x+y97wNp
         vVk9zNEz8Xt7lyN9W1XBp0DXnjUe2ECzUUAjmkdlERa3Egg50RektYReCIQbyzuavi
         BrPmG+w6vcXozjCVGlE765gkx4qtklmwGzUoIcg4h9PpwcbkbPBUasWvXLFlapv+YB
         l7Hgs2WC/9vlw==
Received: by mail-yb1-f177.google.com with SMTP id e136so1835799ybc.4
        for <linux-raid@vger.kernel.org>; Thu, 16 Dec 2021 16:52:34 -0800 (PST)
X-Gm-Message-State: AOAM530jmLjVuHjoI9t+HLrm642uMhQKCAums2NwMdXpb/D99k0AC8vj
        YM+lq0zHBkhKWQDW4N8i33wJ3MXf9QUdSHacHNQ=
X-Google-Smtp-Source: ABdhPJwQId/keGuruYw4IEuHjlaWTeXYg1U8UPLFhihrCViU4nl0s+l0qsfaIYHKt56+VBBxISZr6VVfa+zKByiFGh0=
X-Received: by 2002:a25:a283:: with SMTP id c3mr1042959ybi.219.1639702354019;
 Thu, 16 Dec 2021 16:52:34 -0800 (PST)
MIME-Version: 1.0
References: <20211216145222.15370-1-mariusz.tkaczyk@linux.intel.com>
In-Reply-To: <20211216145222.15370-1-mariusz.tkaczyk@linux.intel.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 16 Dec 2021 16:52:23 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4zmx+mU6vxiTARPme3P0ANMNbC537SDKj2dEDKc_30kg@mail.gmail.com>
Message-ID: <CAPhsuW4zmx+mU6vxiTARPme3P0ANMNbC537SDKj2dEDKc_30kg@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] Use MD_BROKEN for redundant arrays
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Dec 16, 2021 at 6:52 AM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> Hi Song,
> As discussed in first version[1], I've done following:
> - errors handler for RAID0 and linear added
> - raid5 bug described
> - MD_BROKEN described
> - removed MD_BROKEN check for superblock update.
>
> [1] https://lore.kernel.org/linux-raid/20210917153452.5593-1-mariusz.tkaczyk@linux.intel.com/
>
> Mariusz Tkaczyk (3):
>   raid0, linear, md: add error_handlers for raid0 and linear
>   md: Set MD_BROKEN for RAID1 and RAID10
>   raid5: introduce MD_BROKEN

The set looks good to me. The only concern is that we changed some messages.
While dmesg is not a stable API, I believe there are people grep on it
to detect errors.
Therefore, please try to keep these messages same as before (as much
as possible).

Thanks,
Song
