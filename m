From: Louis Erickson <wwonko@rdwarf.com>
Subject: Bringing broken raid 5 back on-line.
Date: Mon, 2 Feb 2004 15:44:57 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0402021518100.15302-100000@holly.rdwarf.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello, all.

This is probably a very common question, but I didn't see a clear answer
while looking at the list archives, so I'm going to ask for your
assistance.

We've got a raid 5 with three drives.  I'll spare you the comedy of errors
and/or sob story that you've all probably heard before, but the upshot is
that we have two failed drives and no current backup.

When the second drive failed, the raid went offline right away.  The
second failure was apparently due to a write fail on the disk.  I presume
that the data on the second failed drive and the main drive is mostly in
synch, except for the last change made.  My conclusion is that other than
the file being written, the rest of the data should be okay.  Please tell
me if I'm wrong there.

We got identical drives to the one good drive and the second failure, and
have used dd to copy the data on to those volumes, so we can attempt to
recover and not hurt our only copies of this data.  I've seen another
message on this list which suggests this should work.  Copies were made
with no errors.

At the moment, my system is a little old and does not have mdadm on it.
Is it worth getting and installing this, or am I best to stick with the
original raidtools?

The question of the hour is: How do I get the two drives to come back
on-line in degraded mode?  They have different event counters and will not
come up.

Any advice or direction you can provide will be very much appreciated.

-- 
Louis Erickson - wwonko@rdwarf.com - http://www.rdwarf.com/~wwonko/

No matter what other nations may say about the United States,
immigration is still the sincerest form of flattery.

