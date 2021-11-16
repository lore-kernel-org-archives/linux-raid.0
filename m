Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57524C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 16 Nov 2021 09:44:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 404FE61C14
	for <linux-raid@archiver.kernel.org>; Tue, 16 Nov 2021 09:44:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233470AbhKPJrv convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 16 Nov 2021 04:47:51 -0500
Received: from group.wh-serverpark.com ([159.69.170.92]:47011 "EHLO
        group.wh-serverpark.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233348AbhKPJrp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 16 Nov 2021 04:47:45 -0500
Received: from localhost (localhost [127.0.0.1])
        by group.wh-serverpark.com (Postfix) with ESMTP id DBC76EE292F;
        Tue, 16 Nov 2021 10:44:46 +0100 (CET)
Received: from group.wh-serverpark.com ([127.0.0.1])
        by localhost (group.wh-serverpark.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id pGg22S8crCri; Tue, 16 Nov 2021 10:44:46 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by group.wh-serverpark.com (Postfix) with ESMTP id 639E0EE46FD;
        Tue, 16 Nov 2021 10:44:46 +0100 (CET)
X-Virus-Scanned: amavisd-new at valiant.wh-serverpark.com
Received: from group.wh-serverpark.com ([127.0.0.1])
        by localhost (group.wh-serverpark.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ZTu0_Haup_LH; Tue, 16 Nov 2021 10:44:46 +0100 (CET)
Received: from enterprise.localnet (unknown [93.189.159.254])
        by group.wh-serverpark.com (Postfix) with ESMTPSA id 47457EE292F;
        Tue, 16 Nov 2021 10:44:46 +0100 (CET)
From:   Markus Hochholdinger <Markus@hochholdinger.net>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     song@kernel.org, linux-raid@vger.kernel.org, xni@redhat.com
Subject: Re: [PATCH] md: fix update super 1.0 on rdev size change
Date:   Tue, 16 Nov 2021 10:44:46 +0100
Message-ID: <2299535.YZZJjEnbGj@enterprise>
In-Reply-To: <91d75292-401f-3788-63aa-f3c9aca8841c@molgen.mpg.de>
References: <20211112142822.813606-1-markus@hochholdinger.net> <91d75292-401f-3788-63aa-f3c9aca8841c@molgen.mpg.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Paul,

Am Dienstag, 16. November 2021, 10:24:17 CET schrieb Paul Menzel:
> Dear Markus,
> Thank you for your patch.

I have to thank you.


> Am 12.11.21 um 15:28 schrieb markus@hochholdinger.net:
> > From: Markus Hochholdinger <markus@hochholdinger.net>
> > The superblock of version 1.0 doesn't get moved to the new position on a
> > device size change. This leads to a rdev without a superblock on a known
> > position, the raid can't be re-assembled.
> > Fixes: commit d9c0fa509eaf ("md: fix max sectors calculation for super
> > 1.0")
> I think it’s common to not write *commit* in there, but just the short
> hash. `scripts/checkpatch.pl` does not mention that, but it mentions:
>      ERROR: Missing Signed-off-by: line(s)
>      total: 1 errors, 0 warnings, 7 lines checked

I'm sorry, this was my first patch request against the linux kernel.
Within https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/
tree/Documentation/process/submitting-patches.rst I read to sign off a patch if 
it is from me, but the line was there before. So I thought I don't have to 
sign it.

Should I do the patch request again with Signed-off information?


> >   drivers/md/md.c | 1 +
> >   1 file changed, 1 insertion(+)
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 6c0c3d0d905a..ad968cfc883d 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -2193,6 +2193,7 @@ super_1_rdev_size_change(struct md_rdev *rdev,
> > sector_t num_sectors)> 
> >   		if (!num_sectors || num_sectors > max_sectors)
> >   			num_sectors = max_sectors;
> > +		rdev->sb_start = sb_start;
> >   	}
> >   	sb = page_address(rdev->sb_page);
> >   	sb->data_size = cpu_to_le64(num_sectors);
> Kind regards,
> Paul

Regards,
Markus


