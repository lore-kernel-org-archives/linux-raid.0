From: "Peter L. Ashford" <ashford@sdsc.edu>
Subject: Re: Disks keep disapearing
Date: Fri, 9 May 2003 17:03:29 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.30.0305091654350.23888-100000@multivac.sdsc.edu>
References: <002f01c3165c$3a4e2cf0$21dd7e42@admin>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <002f01c3165c$3a4e2cf0$21dd7e42@admin>
To: brandon <maillists@hosttuls.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Brandon,

> 3 servers I work with are having issues I am so far unable to track
> down.  All 3 are setup like this:
>
> 2x WD 120GB drives RAID1, ext3


> All 3 of the servers run fine for about a week, then they crash.  When
> they come back up, one of the drives is missing from the array.  Nothing
> in the messsages log that I can find is helpful.  Using sar, I can see
> that the load average isnt too high before they crash.
>
> When the first server crashed, I thought perhaps the "Win95 Ext'd (LBA)"
> partition type might have been causing some problems.  I replaced the
> failed drive, just in case it was hardware, partitioned the drive to be
> the same, except made the extended part. "5  Extended".  Rebuilt the
> array, but still had these crashes.
>
> Any suggestions on how I should go about troubleshooting this? Anyone
> know what might be causing this?

WD has had problems similar to this with many of their drives.  It just
decides to 'go away'.  There is a fix available on their web site for the
180GB and 200GB drives (and a better description of the problem), but the
problem is NOT limited to those drives.

If the description looks like it matches your problem, you should contact
the WD tech support people, and get the fix for your drives from them.
You'll have to go to level 2 support, and maybe even to a product manager,
to get the fix.

I don't know if this particular problem could cause the crashed you're
seeing, but it could cause the drives to disappear.  Perhaps the drives
are disappearing, and causing the crash.

Good luck.
				Peter Ashford

