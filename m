Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCF20C433EF
	for <linux-raid@archiver.kernel.org>; Sun, 19 Dec 2021 11:58:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235597AbhLSL6q (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 19 Dec 2021 06:58:46 -0500
Received: from dione.uberspace.de ([185.26.156.222]:44676 "EHLO
        dione.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbhLSL6q (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 19 Dec 2021 06:58:46 -0500
Received: (qmail 20644 invoked by uid 989); 19 Dec 2021 11:58:44 -0000
Authentication-Results: dione.uberspace.de;
        auth=pass (plain)
Date:   Sun, 19 Dec 2021 12:58:38 +0100
From:   Andreas Klauer <Andreas.Klauer@metamorpher.de>
To:     Tony Bush <thecompguru@gmail.com>
Cc:     linux-raid@vger.kernel.org
Subject: Re: Need help Recover raid5 array
Message-ID: <Yb8ebs7lhEHHTqif@metamorpher.de>
References: <CAA9kLn1nZZKHLahjkyJzChgTMC2WKEoyJG2PhHzeXbD_qY_-yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA9kLn1nZZKHLahjkyJzChgTMC2WKEoyJG2PhHzeXbD_qY_-yw@mail.gmail.com>
X-Rspamd-Bar: --
X-Rspamd-Report: BAYES_HAM(-1.97348) MIME_GOOD(-0.1)
X-Rspamd-Score: -2.07348
Received: from unknown (HELO unkown) (::1)
        by dione.uberspace.de (Haraka/2.8.28) with ESMTPSA; Sun, 19 Dec 2021 12:58:44 +0100
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, Dec 18, 2021 at 11:31:39PM -0500, Tony Bush wrote:
> I forgot that this new-to-this-system SSD had Windows 10 OS on
> it and I believe it tried to boot while I was working on hooking up my
> monitor.  So I think that it saw my raid drives and tried to fdisk
> them.  I did mdadm directly to drive and not to a partition(big
> mistake I know now).  So I think the drives were seen as corrupted and
> fdisk corrected the formatting.

Windows is known to do this but it can just as well happen within Linux.
Hopefully no filesystem formatting took place...

> To fix, I have been leaning toward making the drives ready only and
> using an overlay file. Like here:
> https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file

This method is so useful there should be standard command in Linux 
to create and manage overlays; but there is none so you have to make do 
with the 'overlay manipulation functions' as shown in the wiki.

> But i dont understand all the commands well enough to work this for my
> situation.  Seems like since I don't know the original drive
> arrangement that may be adding an additional level of complexity.  If
> I can figure out the read only and overlay, I still don't know exactly
> the right way to proceed on the mdadm front.  Please anyone who has a
> handle on a situation like this, let me know what I should do.  Thanks

I summarized `mdadm --create` for data recovery here:

  https://unix.stackexchange.com/a/131927/30851

In addition you should remove the bogus GPT and MBR partition headers. 
You can use 'wipefs' for this task. (Test it with overlays first...)

  wipefs --all --types pmbr,gpt,dos /dev/...

You are lucky to have all the relevant `mdadm --examine` output, 
so you already know the correct data offset and only need to guess 
the correct order of drives.

Regards
Andreas Klauer
