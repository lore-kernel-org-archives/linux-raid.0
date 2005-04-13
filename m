From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: out of sync raid 5 + xfs = kernel startup problem
Date: Wed, 13 Apr 2005 14:10:40 +1000
Message-ID: <16988.39872.477594.821987@cse.unsw.edu.au>
References: <425C7D1E.30708@flaminglunchbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Robey Holderith on Tuesday April 12
Sender: linux-raid-owner@vger.kernel.org
To: Robey Holderith <robey@flaminglunchbox.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday April 12, robey@flaminglunchbox.net wrote:
> My raid5 system recently went through a sequence of power outages.  When 
> everything came back on the drives were out of sync.  No big issue... 
> just sync them back up again.  But something is going wrong.  Any help 
> is appreciated.  dmesg provides the following (the network stuff is 
> mixed in):
> 
..
> md: raidstart(pid 220) used deprecated START_ARRAY ioctl. This will not 
> be supported beyond 2.6

First hint.  Don't use 'raidstart'.  It works OK when everything is
working, but when things aren't working, raidstart makes it worse.

> md: could not bd_claim sdf2.

That's odd... Maybe it is trying to 'claim' it twice, because it
certainly seems to have got it below..

> md: autorun ...
> md: considering sdd2 ...
> md:  adding sdd2 ...
> md:  adding sde2 ...
> md:  adding sdf2 ...
> md:  adding sdc2 ...
> md:  adding sdb2 ...
> md:  adding sda2 ...
> md: created md0
> md: bind<sda2>
> md: bind<sdb2>
> md: bind<sdc2>
> md: bind<sdf2>
> md: bind<sde2>
> md: bind<sdd2>
> md: running: <sdd2><sde2><sdf2><sdc2><sdb2><sda2>
> md: kicking non-fresh sdd2 from array!

So sdd2 is not fresh.  Must have been missing at one stage, so it
probably has old data.


> md: unbind<sdd2>
> md: export_rdev(sdd2)
> md: md0: raid array is not clean -- starting background reconstruction
> raid5: device sde2 operational as raid disk 4
> raid5: device sdf2 operational as raid disk 3
> raid5: device sdc2 operational as raid disk 2
> raid5: device sdb2 operational as raid disk 1
> raid5: device sda2 operational as raid disk 0
> raid5: cannot start dirty degraded array for md0


Here's the main problem.

You've got a degraded, unclean array.  i.e. one drive is
failed/missing and md isn't confident that all the parity blocks are
correct due to an unclean shutdown (could have been in the middle of a
write). 
This means you could have undetectable data corruption.

md wants you to know this an not assume that everything is perfectly
OK.

You can still start the array, but you will need to use
  mdadm --assemble --force
which means you need to boot first ... got a boot CD?

I should add a "raid=force-start" or similar boot option, but I
haven't yet.

So, boot somehow, and
  mdadm --assemble /dev/md0 --force /dev/sd[a-f]2

  mdadm /dev/md0 -a /dev/sdd2

 wait for sync to complete (not absolutely needed).

Reboot.

> XFS: SB read failed
> Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP:
> <ffffffff802c4d5d>{raid5_unplug_device+13}

Hmm.. This is a bit of a worry.. I should be doing
	mddev->queue->unplug_fn = raid5_unplug_device;
	mddev->queue->issue_flush_fn = raid5_issue_flush;
a bit later in drivers/md/raid5.c(run), after the last 'goto
abort'... I'll have to think through it a bit though to be sure.

NeilBrown
