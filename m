From: "John Stoffel" <john@stoffel.org>
Subject: Re: corrupt raid 5
Date: Tue, 3 Jan 2006 23:41:37 -0500
Message-ID: <17339.20993.529499.281141@smtp.charter.net>
References: <5981e8c80601031907l6d612bfcsf4a81826efc97f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5981e8c80601031907l6d612bfcsf4a81826efc97f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lorac Thelmwood <lorac.web@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Lorac> First I can't start the array because it complains about a bad
Lorac> superblock. 

What's the exact error you get here?  And the version of mdadm that
you're using?  What's the output of 'cat /proc/mdstat' and 'mdadm
--detail /dev/md?' where ? is the number of your raid 5 array?

Lorac>  Secondly, one of the drives had a problem with losing its
Lorac> interrupt, and that caused the system to hang a couple times.

Ouch, not a good thing.  Which kernel and which controllers do you
have on the system?  More details are better.  

Lorac> I have tested all the drives using seatools (I have 5 * 200GB
Lorac> ATA drives) and they all report no problems.

Is this a Windows only tool from Seagate to check disks?

Lorac> If I ask mdadm for detail on the array, it tells me that the
Lorac> array is active, but degraded (/dev/hdh1 is removed).  I try
Lorac> adding the drive back into the array, and it says it is
Lorac> rebuilding.  However, even after 12 hours it still says that.

See what the output of /proc/mdstat says at that point.  You should
just let it finish rebuilding until it's done.  You can tweak the
rebuild speed by doing:

	echo 200000 > /proc/sys/dev/raid/speed_limit_max
	echo 20000 > /proc/sys/dev/raid/speed_limit_min

This should help speed up things.  But before you do that, give us
current values in there.

Lorac> If i reboot, it just kicks the drive out of the array again.

Of course, it hasn't marked it clean yet because it hasn't finished
re-syncing it. 

Lorac> I could probably find room for the data elsewhere, and rebuild
Lorac> the array; however I need to get at the actual data for that.

You shouldn't need to do that.  Once you bring the array up, you
should be able to do an fsck on the filesystem, even while it's
re-syncing, and then mount hte filesystem and recover your data.

Aren't you able to do that?

John
