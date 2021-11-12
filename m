Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76C7AC433EF
	for <linux-raid@archiver.kernel.org>; Fri, 12 Nov 2021 14:31:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EE9B60FE7
	for <linux-raid@archiver.kernel.org>; Fri, 12 Nov 2021 14:31:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235318AbhKLOes (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 12 Nov 2021 09:34:48 -0500
Received: from group.wh-serverpark.com ([159.69.170.92]:45017 "EHLO
        group.wh-serverpark.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235334AbhKLOeq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 12 Nov 2021 09:34:46 -0500
Received: from localhost (localhost [127.0.0.1])
        by group.wh-serverpark.com (Postfix) with ESMTP id 5FDF6EEBA4D;
        Fri, 12 Nov 2021 15:31:54 +0100 (CET)
Received: from group.wh-serverpark.com ([127.0.0.1])
        by localhost (group.wh-serverpark.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id Pw6HIVGiw-lD; Fri, 12 Nov 2021 15:31:53 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by group.wh-serverpark.com (Postfix) with ESMTP id DA912EEBA4E;
        Fri, 12 Nov 2021 15:31:53 +0100 (CET)
X-Virus-Scanned: amavisd-new at valiant.wh-serverpark.com
Received: from group.wh-serverpark.com ([127.0.0.1])
        by localhost (group.wh-serverpark.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id TPu8AQZ1TkBF; Fri, 12 Nov 2021 15:31:53 +0100 (CET)
Received: from enterprise.localnet (unknown [81.89.200.146])
        by group.wh-serverpark.com (Postfix) with ESMTPSA id C270DEEBA4D;
        Fri, 12 Nov 2021 15:31:53 +0100 (CET)
From:   Markus Hochholdinger <Markus@hochholdinger.net>
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org,
        Chris Webb <chris@arachsys.com>
Subject: Re: [PATCH 018 of 29] md: Support changing rdev size on running arrays.
Date:   Fri, 12 Nov 2021 15:31:46 +0100
Message-ID: <3594501.KpETP9ny9c@enterprise>
User-Agent: KMail/5.2.3 (Linux/4.19.0-0.bpo.6-amd64; KDE/5.28.0; x86_64; ; )
In-Reply-To: <9c51d755-1be3-dfb2-d26e-1b7d71cf1bbf@linux.dev>
References: <20080627164503.9671.patches@notabene> <2991762.XJcJRHA18g@enterprise> <9c51d755-1be3-dfb2-d26e-1b7d71cf1bbf@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Am Freitag, 12. November 2021, 09:22:26 CET schrieb Guoqing Jiang:
> On 11/11/21 11:09 PM, Markus Hochholdinger wrote:
> > It's possible, I've found the error:
> >    rdev->sb_start = sb_start;
> > is missing within md.c within /* minor version 0; superblock after data */
> >  From my understanding, this means the new calculated superblock position
> >  isn't> 
> > used.
> > I changed:
> > --- a/drivers/md/md.c    2021-09-30 08:11:08.000000000 +0000
> > +++ b/drivers/md/md.c     2021-11-11 14:54:10.535633028 +0000
> > @@ -2252,6 +2252,7 @@
> >                  if (!num_sectors || num_sectors > max_sectors)
> >                          num_sectors = max_sectors;
> > +               rdev->sb_start = sb_start;
> >          }
> >          sb = page_address(rdev->sb_page);
> >          sb->data_size = cpu_to_le64(num_sectors);
> > I tested it with 5.10.46 and resizing with superblock version 1.0 is now
> > working for me.
> > If this is correct, how can I get this into longterm 5.10.x and the
> > current
> > kernel upstream?
> Please refer to submitting-patches.rst and stable-kernel-rules.rst which
> are under
> Documentation.
> And I think this tag need to be added in your patch.
> Fixes: commit d9c0fa509eaf ("md: fix max sectors calculation for super 1.0")

Many thanks, this was very helpful for me.


-- 
Mfg

Markus Hochholdinger
