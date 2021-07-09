Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31F93C07E96
	for <linux-raid@archiver.kernel.org>; Fri,  9 Jul 2021 01:56:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12E8561442
	for <linux-raid@archiver.kernel.org>; Fri,  9 Jul 2021 01:56:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbhGIB6w (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 8 Jul 2021 21:58:52 -0400
Received: from tn-76-7-174-50.sta.embarqhsd.net ([76.7.174.50]:55386 "EHLO
        animx.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229637AbhGIB6v (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 8 Jul 2021 21:58:51 -0400
Received: from wakko by animx.eu.org with local 
        id 1m1fkM-0003pV-TC; Thu, 08 Jul 2021 21:56:06 -0400
Date:   Thu, 8 Jul 2021 21:56:06 -0400
From:   Wakko Warner <wakko@animx.eu.org>
To:     NeilBrown <neilb@suse.de>
Cc:     linux-raid@vger.kernel.org
Subject: Re: bad sector and unused area.
Message-ID: <YOestteXfXrT6GRh@animx.eu.org>
References: <YOdyyGBnFKHr7Xyc@animx.eu.org>
 <c2e60c47-68fd-4be2-6a8b-633d651bc2e2@thelounge.net>
 <YOeKl6vWvy9iYliT@animx.eu.org>
 <162579007144.31036.14874903367678850529@noble.neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162579007144.31036.14874903367678850529@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

NeilBrown wrote:
> On Fri, 09 Jul 2021, Wakko Warner wrote:
> > Reindl Harald wrote:
> > > 
> > > 
> > > Am 08.07.21 um 23:48 schrieb Wakko Warner:
> > > > I have a raid5 of 3 disks.
> > > > 
> > > > 2 of them have bad sectors.  Sector 1110 and 1118.
> > > > 
> > > > I'm curious to know if these sectors actually contain any data or if they
> > > > can just be overwritten.
> > > 
> > > the RAID layer don't know anything about data by definition, it even don't
> > > care what filesystem is running on top
> > 
> > So did you actually read what I said?
> > 
> >     Data Offset : 262144 sectors
> >    Super Offset : 0 sectors
> > 
> > This is /dev/sda1 which starts at sector 128 of /dev/sda.  Sector 1110 on
> > /dev/sda is bad.  That would place it between super offset and data offset. 
> > Thus, there wouldn't be a filesystem there.  I'm asking if it contains any
> > "data" that might be "used" by "something".  My /dev/md0 data starts at
> > offset 262144 of /dev/sda1 which is well beyond sector 1110 of /dev/sda.
> 
> If you had an unusually large bitmap, it might use those bad sectors,
> but unlikely.
> If you reshaped the array to more devices, it would reduce the Data
> Offset, so might start writing in that space.
> 
> Otherwise you should be safe.

Ok thanks.  I did do a superblock backup on my 3 drives a few months ago.  I
checked offset 72 to offset 262143, it was all 0s.  I assume whatever is
there was on the disk and not wiped when I created the array.

I also dumped the same sectors from each of the disks.  interestingly, what
is stored there is the same on all 3 drives except for the areas that were
bad.

This array has never been reshaped.  It also has never had a disk replaced.

I already DD'd zero to the drive, but only the sectors that were not
readable.  Didn't see any reason not to.  I found it interesting that the
reallocated sectors didn't go up.  The drives have 13 years of power on
time.

This is mdstat:
md0 : active raid5 sda1[0] sdb1[1] sdc1[3]
      488018688 blocks super 1.1 level 5, 64k chunk, algorithm 2 [3/3] [UUU]
      bitmap: 1/2 pages [4KB], 65536KB chunk

And that is the only array on this machine.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
