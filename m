From: Steven Ihde <sihde@cs.stanford.edu>
Subject: Re: Bringing broken raid 5 back on-line.
Date: Tue, 3 Feb 2004 17:00:47 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040204010047.GA26264@hamachi.dyndns.org>
References: <Pine.LNX.4.33.0402021518100.15302-100000@holly.rdwarf.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0402021518100.15302-100000@holly.rdwarf.com>
To: Louis Erickson <wwonko@rdwarf.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I didn't see any other answers, so I'll take a shot...

On Mon, Feb 02, 2004 at 03:44:57PM -0800, Louis Erickson wrote:
[snip]
> We've got a raid 5 with three drives.  I'll spare you the comedy of errors
> and/or sob story that you've all probably heard before, but the upshot is
> that we have two failed drives and no current backup.
> 
> When the second drive failed, the raid went offline right away.  The
> second failure was apparently due to a write fail on the disk.  I presume
> that the data on the second failed drive and the main drive is mostly in
> synch, except for the last change made.  My conclusion is that other than
> the file being written, the rest of the data should be okay.  Please tell
> me if I'm wrong there.

That's a reasonable guess, I think.  It depends to some extent what
went bad... once I had a drive that developed a few bad sectors, but
the bad sectors were in the middle of the inodes for my /home
partition, so it did some pretty serious damage.

> We got identical drives to the one good drive and the second
> failure, and have used dd to copy the data on to those volumes, so
> we can attempt to recover and not hurt our only copies of this data.
> I've seen another message on this list which suggests this should
> work.  Copies were made with no errors.
>
> At the moment, my system is a little old and does not have mdadm on it.
> Is it worth getting and installing this, or am I best to stick with the
> original raidtools?
> 

I advise you to get and install mdadm -- it has worked fine for me and
mdadm seems to be the overwhelming preference of the posters to this
list and thus easier to get support for.

> The question of the hour is: How do I get the two drives to come back
> on-line in degraded mode?  They have different event counters and will not
> come up.
> 
> Any advice or direction you can provide will be very much appreciated.

Once you have mdadm, 

mdadm --assemble /dev/md<whatever> --force <good drive #1> <good drive
#2> missing

should work for you.  Note that "missing" is a literal string which
you supply instead of a third device name, indicating that you want to
assemble a three-drive array in degraded mode without one of its
drives.  You should see some message in the logs about forcing the
event count of some drive or another.  "--force" is necessary because
the remaining drives' event counts are different.

-Steve


