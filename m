Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C0A8C43217
	for <linux-raid@archiver.kernel.org>; Sun, 27 Nov 2022 14:58:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiK0O64 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 27 Nov 2022 09:58:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiK0O6y (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 27 Nov 2022 09:58:54 -0500
Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F6E2F5BD
        for <linux-raid@vger.kernel.org>; Sun, 27 Nov 2022 06:58:53 -0800 (PST)
Received: from quad.stoffel.org (068-116-170-226.res.spectrum.com [68.116.170.226])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.stoffel.org (Postfix) with ESMTPSA id F30E720568;
        Sun, 27 Nov 2022 09:58:51 -0500 (EST)
Received: by quad.stoffel.org (Postfix, from userid 1000)
        id 4B0FEA80D6; Sun, 27 Nov 2022 09:58:51 -0500 (EST)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <25475.31531.261178.346567@quad.stoffel.home>
Date:   Sun, 27 Nov 2022 09:58:51 -0500
From:   "John Stoffel" <john@stoffel.org>
To:     Reindl Harald <h.reindl@thelounge.net>
Cc:     John Stoffel <john@stoffel.org>,
        Wols Lists <antlists@youngman.org.uk>,
        David T-G <davidtg-robot@justpickone.org>,
        Linux RAID list <linux-raid@vger.kernel.org>
Subject: Re: how do i fix these RAID5 arrays?
In-Reply-To: <fd543697-14a6-0868-82a1-be61790e07f3@thelounge.net>
References: <20221123220736.GD19721@jpo>
        <20221124032821.628cd042@nvm>
        <20221124211019.GE19721@jpo>
        <f58964da-4ded-61a8-bd6a-e2391557b38a@youngman.org.uk>
        <25474.28874.952381.412636@quad.stoffel.home>
        <fd543697-14a6-0868-82a1-be61790e07f3@thelounge.net>
X-Mailer: VM 8.2.0b under 27.1 (x86_64-pc-linux-gnu)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

>>>>> "Reindl" == Reindl Harald <h.reindl@thelounge.net> writes:

> Am 26.11.22 um 21:02 schrieb John Stoffel:
>> I call it a failure of the layering model.  If you want RAID, use MD.
>> If you want logical volumes, then put LVM on top.  Then put
>> filesystems into logical volumes.
>> 
>> So much simpler...

> have you ever replaced a 6 TB drive and waited for the resync of
> mdadm in the hope in all that hours no other drive goes down?

Yes, but I also run RAID6 so that if I lose a drive, I don't lose
redundancy.  I also have backups.  

> when your array is 10% used it's braindead
> when your array is new and empty it's braindead

> ZFS/BTRFS don't neeed to mirror/restore 90% nulls

I like the idea of ZFS, but in my $WORK experience with Oracle ZFS
arrays, it tended to fall off a cliff performance wise when pushed too
hard.  

And I don't like that you can only grow, not shrink zvols and the
underlying storage.  

But I'm also not smart enough to design a filesystem and make it
work.  :-)

