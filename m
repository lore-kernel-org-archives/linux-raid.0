From: Lorac Thelmwood <lorac.web@gmail.com>
Subject: corrupt raid 5
Date: Tue, 3 Jan 2006 19:07:53 -0800
Message-ID: <5981e8c80601031907l6d612bfcsf4a81826efc97f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a 5 disk raid 5 array that has a couple issues.

First I can't start the array because it complains about a bad
superblock.  Secondly, one of the drives had a problem with losing its
interrupt, and that caused the system to hang a couple times.  I have
tested all the drives using seatools (I have 5 * 200GB ATA drives) and
they all report no problems.

If I ask mdadm for detail on the array, it tells me that the array is
active, but degraded (/dev/hdh1 is removed).  I try adding the drive
back into the array, and it says it is rebuilding.  However, even
after 12 hours it still says that.  If i reboot, it just kicks the
drive out of the array again.

I could probably find room for the data elsewhere, and rebuild the
array; however I need to get at the actual data for that.

Does anyone have any suggestions?
