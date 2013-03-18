From: Joel Young <jdy@cryregarder.com>
Subject: Re: RAID 0 of Two RAID 5s Stays Up When Component RAID fails
Date: Mon, 18 Mar 2013 23:57:20 +0000 (UTC)
Message-ID: <loom.20130319T005432-235@post.gmane.org>
References: <loom.20130314T022616-853@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Joel Young <jdy <at> cryregarder.com> writes:

> mdadm /dev/md0 --fail /dev/loop0
> mdadm /dev/md0 --fail /dev/loop1

I typod this when mailing the list.  It should have been:
mdadm /dev/md0 --fail /dev/loop1
mdadm /dev/md0 --fail /dev/loop2

In an off-list discussion with Neil Brown, he pointed out that
just as we don't fail a drive when a sector goes bad, we don't
fail a raid-0 if a component fails.

At this time, I don't follow that reasoning, but I can work
with it.

Joel

