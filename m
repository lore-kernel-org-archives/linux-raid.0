From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Remote NAS
Date: Tue, 29 Sep 2009 04:25:27 -0500
Message-ID: <20090929092508524.RDPE26368@cdptpa-omta03.mail.rr.com>
References: <41943.20139.qm@web38801.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41943.20139.qm@web38801.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I am puzzled by why write-mostly.  Ostensibly Gb ethernet is supposed to
> nearly equal the data transfer rate of the controller cards, and be many
> times the speed of actual data transfer from the drives.

Not at all.  Some multilane solutions can manage close to 300MBps per drive.
The absolute maximum throughput of a Gig-E is right at 120MBps.  OTOH, 50 -
60 MBps may be far more than you need, in which case Gig-E is fine.

> So shouldn't a NAS have plenty of bandwidth to accommodate most any drive
> operations?

For your case, perhaps, but you were the one concerned about performance.

 
> I will be setting up a small high-perf drive for / (including database) so
> the only data on the array will be /home (including large videos).

	Why are you putting the array in /home?  Does MythTV require it?  If
not, personally, I would recommend a separate directory for the recordings
and not in /home.  I mount my array in /RAID and put the recordings in
/RAID/Recordings.

> Seems like there is no need to specify write-mostly?

	For your setup it may or may not result in some performance gain.
Certainly reading the material strictly from the local drives will probably
result in higher throughput, but a lower througput for reading the videos
during commercial flagging might actually result in better responsiveness of
your MythTV menus.

