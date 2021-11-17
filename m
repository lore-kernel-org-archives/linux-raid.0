Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12424C4332F
	for <linux-raid@archiver.kernel.org>; Wed, 17 Nov 2021 10:21:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFCC061BAA
	for <linux-raid@archiver.kernel.org>; Wed, 17 Nov 2021 10:21:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236312AbhKQKYG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 17 Nov 2021 05:24:06 -0500
Received: from group.wh-serverpark.com ([159.69.170.92]:57012 "EHLO
        group.wh-serverpark.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236331AbhKQKYA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 17 Nov 2021 05:24:00 -0500
Received: from localhost (localhost [127.0.0.1])
        by group.wh-serverpark.com (Postfix) with ESMTP id AD657EE292D;
        Wed, 17 Nov 2021 11:21:00 +0100 (CET)
Received: from group.wh-serverpark.com ([127.0.0.1])
        by localhost (group.wh-serverpark.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id q_w-uYWZDaFU; Wed, 17 Nov 2021 11:21:00 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by group.wh-serverpark.com (Postfix) with ESMTP id 35731EEBA44;
        Wed, 17 Nov 2021 11:21:00 +0100 (CET)
X-Virus-Scanned: amavisd-new at valiant.wh-serverpark.com
Received: from group.wh-serverpark.com ([127.0.0.1])
        by localhost (group.wh-serverpark.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id bTerXSAudiW9; Wed, 17 Nov 2021 11:21:00 +0100 (CET)
Received: from enterprise.localnet (unknown [93.189.159.254])
        by group.wh-serverpark.com (Postfix) with ESMTPSA id 1510EEE292D;
        Wed, 17 Nov 2021 11:21:00 +0100 (CET)
From:   Markus Hochholdinger <Markus@hochholdinger.net>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>, Xiao Ni <xni@redhat.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Re: [PATCH v2] md: fix update super 1.0 on rdev size change
Date:   Wed, 17 Nov 2021 11:20:59 +0100
Message-ID: <3087286.Pd3bozeLmo@enterprise>
In-Reply-To: <CAPhsuW4zBGnKAV_TWaZ78NVEhOUw61xYYKda1c33YB=JtAfChA@mail.gmail.com>
References: <20211116102134.1738347-1-markus@hochholdinger.net> <CAPhsuW4zBGnKAV_TWaZ78NVEhOUw61xYYKda1c33YB=JtAfChA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Am Mittwoch, 17. November 2021, 08:17:21 CET schrieb Song Liu:
> On Tue, Nov 16, 2021 at 2:22 AM Markus Hochholdinger
> <markus@hochholdinger.net> wrote:
> > The superblock of version 1.0 doesn't get moved to the new position on a
> > device size change. This leads to a rdev without a superblock on a known
> > position, the raid can't be re-assembled.
> > The line was removed by mistake and is re-added by this patch.
> > Fixes: d9c0fa509eaf ("md: fix max sectors calculation for super 1.0")
> > Signed-off-by: Markus Hochholdinger <markus@hochholdinger.net>
> > Reviewd-by: Xiao Ni <xni@redhat.com>
> Applied to md-fixes. Thanks!

Many thanks.

> This version still has some minor issues. I fixed them before applying. For
> future patches, please run ./scripts/checkpatch.pl on the .patch file.

OK, I wasn't aware of that, will do that check the next time.

Regards,
Markus


