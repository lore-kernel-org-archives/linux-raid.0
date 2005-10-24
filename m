From: Jeff Breidenbach <jeff@jab.org>
Subject: Re: split RAID1 during backups?
Date: Mon, 24 Oct 2005 05:07:28 -0700
Message-ID: <E1EU16u-0002ZK-00@toko.jab.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


>First of all, if the data is mostly static, rsync might work faster.

Any operation that stats the individual files - even to just look at
timestamps - takes about two weeks. Therefore it is hard for me to see
rsync as a viable solution, even though the data is mostly
static. About 400,000 files change between weekly backups.

>I take it sdc and sdd using SATA don't influence each other?

Correct.

>However you will endure a rebuild on md0 when you re-add the disk, but
>given everything is mounted read-only, you should not practically be
>doing anything

If the rebuild operation is a no-op, then that sounds like a great
idea. If the rebuild operation requires scanning over all data in both
drives, I think that's going to be at least as expensive as the
current 10 hour process.

Thanks for the suggestions so far.

Cheers,
Jeff

