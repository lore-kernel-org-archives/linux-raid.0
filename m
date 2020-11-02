Return-Path: <SRS0=c9Ba=EI=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC290C388F9
	for <linux-raid@archiver.kernel.org>; Mon,  2 Nov 2020 20:19:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8344521D40
	for <linux-raid@archiver.kernel.org>; Mon,  2 Nov 2020 20:19:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgKBUTY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 2 Nov 2020 15:19:24 -0500
Received: from vps.thesusis.net ([34.202.238.73]:56422 "EHLO vps.thesusis.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgKBUTX (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 2 Nov 2020 15:19:23 -0500
X-Greylist: delayed 446 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Nov 2020 15:19:23 EST
Received: from localhost (localhost [127.0.0.1])
        by vps.thesusis.net (Postfix) with ESMTP id AD71123B69;
        Mon,  2 Nov 2020 15:11:55 -0500 (EST)
Received: from vps.thesusis.net ([IPv6:::1])
        by localhost (vps.thesusis.net [IPv6:::1]) (amavisd-new, port 10024)
        with ESMTP id US_wt1stFoAn; Mon,  2 Nov 2020 15:11:54 -0500 (EST)
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id A70E923B6D; Mon,  2 Nov 2020 15:11:53 -0500 (EST)
References: <9b6db7d5-4a34-a1f9-2314-5e3522555052@redhat.com>
User-agent: mu4e 1.5.6; emacs 26.3
From:   Phillip Susi <phill@thesusis.net>
To:     Xiao Ni <xni@redhat.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>
Subject: Re: The raid device can't be unmount when it can't work
In-reply-to: <9b6db7d5-4a34-a1f9-2314-5e3522555052@redhat.com>
Date:   Mon, 02 Nov 2020 15:11:53 -0500
Message-ID: <87tuu7y0vq.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Xiao Ni writes:

> When one raid loses disks that are bigger than the max degraded number, 
> the udev rule[1] tries to stop
> the raid device. If the raid device is mount, it tries to unmount it

Why?  If there are open files on it, you won't be able to unmount it
anyway, and what would you gain by stopping the broken device?

> first[2]. It uses udisks command to do this.
> It's a little old. Now the package version is udisks2 which uses 
> udisksctl to do this. I write a patch[3] and do
> test. It's failed because of "udisksctl error Permission denied".

Udisks is a GNOME desktop component, and so may not even exist on many
systems.  When it does, you still can't call it from udev scripts since
they are not run within the desktop in the context of a logged in user.
If you want to unmount the device, just use umount.
