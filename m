From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: New raid level suggestion.
Date: Thu, 30 Dec 2010 09:23:56 +0100
Message-ID: <20101230082356.GC2986@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi,

A friend has a webserver. He has 4 drive bays and due to previous
problems he's not content to have 3 or 4 drives in a raid5
configuration, but he wants a "hot spare" so that when it takes him a
week to find a new drive and some time to drive to the hosting
company, he isn't susceptible to a second drive crashing in the
meantime.

So in principle he'll build a 3-drive RAID5 with a hot spare.... 

Now we've been told that raid5 performs badly for the workload that is
expected. It would be much better to run the system in RAID10. However
if he'd switch to RAID10, after a single drive failure he has a window
of about a week where he has a 33% chance of a second drive failure
being "fatal".

So I was thinking.... He's resigned himself to a configuration where
he pays for 4x the disk space and only gets 2x the available space.

So he could run his array in RAID10 mode, however when a drive fails, 
a fallback to raid5 would be in order. In this case, after the resync 
a single-drive-failure tolerance is again obtained. 

In practise scaling down to raid5 is not easy/possible. RAID4 however
should be doable.

In fact this can almost be implemented entirely in userspace. Just
remove the mirror drive from the underlying raid0, and reinitialize as
raid4. If you do this correctly the data will still be there....

Although doing this with an active filesystem running on these drives
is probably impossible due to "device is in use" error messages.... 

So: Has anybody tried this before?
Can this be implemented without kernel support?
Anybody feel like implementing this?

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
