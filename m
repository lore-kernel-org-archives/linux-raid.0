From: Matt Garman <matthew.garman@gmail.com>
Subject: WD GreenPower & Load_Cycle_Count
Date: Tue, 23 Dec 2008 08:53:34 -0600
Message-ID: <20081223145334.GA17496@sewage.raw-sewage.fake>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


A while ago I stumbled on a thread on the Linux kernel mailing list
titled "Western Digital GreenPower drives and Linux".  It's easy to
find via google, or use this link[1].

The gist is that if you look at the SMART attributes on these
drives, chances are you'll see a really high Load_Cycle_Count.  I do
for my WD GP drives.

I posted[2] on the ars technica forums a while back with the same
topic.  The suggestion in the last post was to use hdparm's
spindown_time (-S) parameter to change the drive's behavior.  I
tried this, and it does in seem to keep that Load_Cycle_Count
variable from increasing so quickly.

But the original thread on LKML made it sound like the only way to
solve the problem was with Western Digital's Windows-only
"wdidle3.exe" utility.

Another question is this: does that Load_Cycle_Count SMART attribute
really correspond to the number of head parks that have a specified
ceiling (300k for consumer drives, 600k for enterprise/RE2)?  Some
of the threads I've read suggest that the SMART attribute talks
about "soft" head parks (moving the head away from the platters),
and WD's spec is for "hard" parks (where the head actually comes to
rest, as in power down).

Here's another interesting thread on the topic on silentpcreview[3].

Anyway, I haven't been able to find a conclusive answer to this on
the web.  Just wondering if anyone on the list has any more info.

Thanks,
Matt

[1] http://groups.google.com/group/linux.kernel/browse_thread/thread/505ccf760023d132/7e4f4e996f911efd

[2] http://episteme.arstechnica.com/eve/forums/a/tpc/f/24609792/m/481009715931?r=481009715931

[3] http://www.silentpcreview.com/forums/viewtopic.php?t=51401


