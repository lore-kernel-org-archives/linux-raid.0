Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FAE7C43217
	for <linux-raid@archiver.kernel.org>; Sat, 26 Nov 2022 20:02:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbiKZUCW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 26 Nov 2022 15:02:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiKZUCV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 26 Nov 2022 15:02:21 -0500
Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 991F21A053
        for <linux-raid@vger.kernel.org>; Sat, 26 Nov 2022 12:02:20 -0800 (PST)
Received: from quad.stoffel.org (068-116-170-226.res.spectrum.com [68.116.170.226])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mail.stoffel.org (Postfix) with ESMTPSA id 5996A1E5E4;
        Sat, 26 Nov 2022 15:02:19 -0500 (EST)
Received: by quad.stoffel.org (Postfix, from userid 1000)
        id F3565A80CE; Sat, 26 Nov 2022 15:02:18 -0500 (EST)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <25474.28874.952381.412636@quad.stoffel.home>
Date:   Sat, 26 Nov 2022 15:02:18 -0500
From:   "John Stoffel" <john@stoffel.org>
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     David T-G <davidtg-robot@justpickone.org>,
        Linux RAID list <linux-raid@vger.kernel.org>
Subject: Re: how do i fix these RAID5 arrays?
In-Reply-To: <f58964da-4ded-61a8-bd6a-e2391557b38a@youngman.org.uk>
References: <20221123220736.GD19721@jpo>
        <20221124032821.628cd042@nvm>
        <20221124211019.GE19721@jpo>
        <f58964da-4ded-61a8-bd6a-e2391557b38a@youngman.org.uk>
X-Mailer: VM 8.2.0b under 27.1 (x86_64-pc-linux-gnu)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

>>>>> "Wols" == Wols Lists <antlists@youngman.org.uk> writes:

> On 24/11/2022 21:10, David T-G wrote:
>> I don't want to try BtrFS.  That's another area where I have no experience,
>> but from what I've seen and read I really don't want to go there yet.

> Btrfs ...

> It's a good idea, and provided you don't do anything esoteric it's
> been solid for years.

Does it count when you try to upgrade SLES 12.3 with the latest
patches to 15 and it bombs so badly that the btrfs snapshots can't get
you working again and you have to blow the system away to do a fresh
full re-install?  

I don't trust btrfs because when (not if) it goes badly, it goes
REALLY badly in my experience.  Where ext4 and xfs both will recover
enough to keep working.  You might lose data, but you won't lose the
entire filesystem.  

> It used to have a terrible reputation for surviving a disk full - at
> a guess it needs some disk space to shuffle its btree to recover
> space - and a disk-full situation borked the garbage collection.

It can't handle snapshots well either in my experience.  

> Raid-1 (mirroring) by default only mirrors the directories, the data
> isn't mirrored so you can easily still lose that ... (they call that
> user misconfiguration, I call it developer arrogance ...)

I call it a failure of the layering model.  If you want RAID, use MD.
If you want logical volumes, then put LVM on top.  Then put
filesystems into logical volumes.  

So much simpler...

> Parity raid is still borken...

So why the hell are you recommending it?  

> At the end of the day, if you want to protect your data, DON'T rely on 
> the filesystem. There are far too many cases where the developers have 
> made decisions that protect the file system (and hence computer uptime) 
> at the expense of the data IN the filesystem. I don't give a monkeys if 
> the filesystem protects itself to enable a crashed computer to reboot 
> ten seconds faster, if the consequence of that change is my computer is 
> out of action for a day while I have to restore a backup to re-instate 
> the integrity of my data !!!

Yes, I agree 100%.  

Mirrors and backups are key.  And offsite backups are key too.
Especially for family photos and other keep sakes you don't want to
lose.  rips of CDs and DVDs aren't nearly as important in my book.  

