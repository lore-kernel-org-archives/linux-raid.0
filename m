From: Mike Perry <mikepery@fscked.org>
Subject: Hot adding active disk to RAID1?
Date: Sat, 7 Feb 2004 09:29:48 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040207152948.GA17368@fscked.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well, this is probably a FAQ, but I've really looked around and can't
seem to find how to do it..

So here's the story: I just created a RAID1 array. I did this by simply
creating a single disk array, and then copying the data from the
original disk onto the array, and then trying to raidhotadd the original
disk once the array was created and the contents fully copied. I did NOT
use a failed-disk directive for the original disk, as I have had at
least one experience where the failed-disk directive was ignored and
that drive was mirrored to anyways.. Luckily the failed-disk had no
important data on it that time, but I didn't want to risk it this time..

At any rate, now it seems that my hotadded disk is NOT part of the
active array, but is in fact a spare. Here's the relevant lines from
mdadm --detail /dev/md0

	Raid Disks : 1
	Total Disks : 2
	Preferred Minor : 0
	
	Active Drives : 1
	Working Drives : 2
	Failed Drives : 0
	Spare Drives : 1

It should be a simple matter to convert that spare to an active drive,
right? Especially for RAID1. How do I go about doing that? 

I've found a tool called raidreconf by the author of the RAID HOWTO, but
I'm reluctant to just run that and hope for the best, especially since
it seems to be written for just RAID0 and 5 (the rather scant manpage
makes no mention of RAID1 whatsoever). 

Does anyone have any experience with using raidreconf for RAID1, or have
a way to hotadd a disk and have it become active, instead of being a
spare?


-- 
Mike Perry
Mad Computer Scientist
fscked.org evil labs
